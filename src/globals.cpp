// globals.cpp
#include "globals.hpp"
#include <hyprland/src/plugins/PluginAPI.hpp>

#include <mutex>

// Definition of global variables
std::thread watcherThread;
std::atomic<bool> keepWatching(true);

// Mutex for thread-safe notifications (if needed)
std::mutex notificationMutex;

// Implementation of sendNotification
void sendNotification(const std::string& message, const CHyprColor& color, int duration) {
    std::lock_guard<std::mutex> lock(notificationMutex); // Ensure thread safety
    if (PHANDLE) {
        HyprlandAPI::addNotification(PHANDLE, message, color, duration);
    }
}
