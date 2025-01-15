#include "globals.hpp"
#include <string>
#include <cstring>
#include <cerrno>
#include <unistd.h>
#include <sys/inotify.h>
#include <fcntl.h>
#include <chrono>

APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    const std::string HASH = __hyprland_api_get_hash();

    if (HASH != GIT_COMMIT_HASH) {
        sendNotification(
            "[Hyprlua] Mismatched headers! Can't proceed.",
            CHyprColor{1.0, 0.2, 0.2, 1.0},
            5000
        );
        throw std::runtime_error("[Hyprlua] Version mismatch");
    }

    // Start the file watcher thread
    watcherThread = std::thread([](){
        const std::string filepath = "/home/cacarico/ghq/github.com/cacarico/dotfiles-pvt/config/hypr/hyprland.lua";
        const std::string directory = "/home/cacarico/ghq/github.com/cacarico/dotfiles-pvt/config/hypr/";

        int inotifyFd = inotify_init1(IN_NONBLOCK);
        if (inotifyFd < 0) {
            sendNotification(
                "[Hyprlua] inotify_init1 error: " + std::string(std::strerror(errno)),
                CHyprColor{1.0, 0.2, 0.2, 1.0},
                5000
            );
            return;
        }

        int watchDesc = inotify_add_watch(inotifyFd, directory.c_str(), IN_MODIFY | IN_CLOSE_WRITE | IN_MOVED_TO | IN_CREATE);
        if (watchDesc < 0) {
            sendNotification(
                "[Hyprlua] Failed to add watch for " + directory + ": " + std::string(std::strerror(errno)),
                CHyprColor{1.0, 0.2, 0.2, 1.0},
                5000
            );
            close(inotifyFd);
            return;
        }

        sendNotification(
            "[Hyprlua] Monitoring '" + filepath + "' for changes...",
            CHyprColor{0.2, 1.0, 0.2, 1.0},
            3000
        );

        auto lastEventTime = std::chrono::steady_clock::now() - std::chrono::seconds(1);

        while (keepWatching) {
            char buffer[4096] __attribute__((aligned(__alignof__(inotify_event))));
            ssize_t numRead = read(inotifyFd, buffer, sizeof(buffer));

            if (numRead > 0) {
                for (char* ptr = buffer; ptr < buffer + numRead; ) {
                    auto* event = reinterpret_cast<inotify_event*>(ptr);

                    if (event->len > 0) {
                        std::string eventFile = directory + event->name;

                        if (eventFile == filepath) {
                            auto now = std::chrono::steady_clock::now();
                            if (now - lastEventTime > std::chrono::milliseconds(500)) {
                                sendNotification("File was modified: " + filepath, CHyprColor{0.2, 0.6, 1.0, 1.0}, 3000);
                                lastEventTime = now;
                            }
                        }
                    }

                    ptr += sizeof(inotify_event) + event->len;
                }
            } else if (numRead == -1 && errno != EAGAIN) {
                // An error occurred
                sendNotification(
                    "[Hyprlua] read error: " + std::string(std::strerror(errno)),
                    CHyprColor{1.0, 0.2, 0.2, 1.0},
                    5000
                );
            }

            std::this_thread::sleep_for(std::chrono::milliseconds(500)); // Sleep to reduce CPU usage
        }

        inotify_rm_watch(inotifyFd, watchDesc);
        close(inotifyFd);
    });

    return {"Hyprlua", "A plugin to enable lua support for Hyprland", "cacarico", "0.1"};
}

APICALL EXPORT void PLUGIN_EXIT() {
    // Signal the watcher thread to stop
    keepWatching = false;

    // Wait for the watcher thread to finish
    if (watcherThread.joinable()) {
        watcherThread.join();
    }

    sendNotification(
        "[Hyprlua] Plugin exiting. Stopped file monitoring.",
        CHyprColor{1.0, 1.0, 0.2, 1.0},
        3000
    );
}
