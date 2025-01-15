#include "globals.hpp"
#include "watcher.hpp"

#include <hyprland/src/plugins/PluginAPI.hpp>
#include <mutex>

// Definition of the mutex for thread-safe notifications
std::mutex notificationMutex;

// Implementation of the sendNotification function
void sendNotification(const std::string& message, const CHyprColor& color, int duration) {
    std::lock_guard<std::mutex> lock(notificationMutex); // Lock mutex for thread safety
    if (PHANDLE) {
        HyprlandAPI::addNotification(PHANDLE, message, color, duration);
    }
}

// Initialize the global watcher pointer as a nullptr
std::unique_ptr<FileWatcher> g_FileWatcher = nullptr;
