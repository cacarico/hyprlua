#include "globals.hpp"

#include <atomic>
#include <cerrno>
#include <cstring>
#include <filesystem>
#include <iostream>
#include <stdexcept>
#include <string>
#include <sys/inotify.h>
#include <thread>
#include <unistd.h>
#include <vector>

static std::atomic<bool> g_runInotify{true};
static std::thread g_inotifyThread;

// Do NOT change this function (required by Hyprland).
APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    // Verify Hyprland version compatibility
    const std::string HASH = __hyprland_api_get_hash();
    if (HASH != GIT_COMMIT_HASH) {
        HyprlandAPI::addNotification(
            PHANDLE,
            "[Hyprlua] Mismatched headers! Can't proceed.",
            CHyprColor{1.0, 0.2, 0.2, 1.0},
            5000
        );
        throw std::runtime_error("[Hyprlua] Version mismatch");
    }

    // The file we want to watch
    const std::string filename = "/home/cacarico/.config/hypr/hyprland.lua";

    // Initialize inotify
    int inotifyFd = ::inotify_init();
    if (inotifyFd < 0) {
        std::cerr << "[Hyprlua] inotify_init error: " << std::strerror(errno) << "\n";
    }

    // Add a watch for modifications
    int watchDesc = ::inotify_add_watch(inotifyFd, filename.c_str(), IN_MODIFY);
    if (watchDesc < 0) {
        std::cerr << "[Hyprlua] Failed to watch " << filename
                  << ": " << std::strerror(errno) << "\n";
    }

    std::cout << "[Hyprlua] Watching '" << filename << "' for modifications...\n";

    // Launch a separate thread so this doesn’t block Hyprland
    g_runInotify = true;
    g_inotifyThread = std::thread([=]() {
        constexpr size_t EVENT_SIZE = sizeof(inotify_event);
        constexpr size_t BUFFER_SIZE = 1024 * (EVENT_SIZE + 16);
        std::vector<char> buffer(BUFFER_SIZE);

        while (g_runInotify) {
            ssize_t numRead = ::read(inotifyFd, buffer.data(), buffer.size());
            if (numRead < 0) {
                if (errno == EINTR) {
                    // If interrupted by a signal, try again
                    continue;
                }
                std::cerr << "[Hyprlua] read error: " << std::strerror(errno) << '\n';
                break;
            }

            // Process all inotify events
            for (char* ptr = buffer.data(); ptr < buffer.data() + numRead; ) {
                auto* event = reinterpret_cast<inotify_event*>(ptr);

                // If the file was modified
                if (event->mask & IN_MODIFY) {
                    // Send a Hyprland notification instead of just printing
                    HyprlandAPI::addNotification(
                        PHANDLE,
                        "[Hyprlua] File modified: " + filename,
                        CHyprColor{0.4, 1.0, 0.4, 1.0}, // green-ish color
                        5000                           // show for 5 seconds
                    );
                }

                // Move to the next event
                ptr += EVENT_SIZE + event->len;
            }
        }

        // Cleanup when we exit
        if (watchDesc >= 0) {
            ::inotify_rm_watch(inotifyFd, watchDesc);
        }
        if (inotifyFd >= 0) {
            ::close(inotifyFd);
        }
    });

    // Detach the thread so it won’t block plugin init
    g_inotifyThread.detach();

    // Return plugin info
    return {
        "Hyprlua",                       // name
        "A plugin to enable lua support for Hyprland",  // description
        "cacarico",                      // author
        "0.1"                            // version
    };
}

// Called when the plugin is unloaded
APICALL EXPORT void PLUGIN_EXIT() {
    // Signal the thread to stop
    g_runInotify = false;

    // If we had *not* detached the thread, we could join it here:
    // if (g_inotifyThread.joinable()) {
    //     g_inotifyThread.join();
    // }
}
