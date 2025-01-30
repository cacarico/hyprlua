#include "utils.hpp"
#include "globals.hpp"
#include <cstdlib>
#include <string>

/**
 * @var std::mutex notificationMutex
 * @brief Mutex instance for notification thread safety
 * @details Shared across all threads accessing Hyprland's notification API
 */
std::mutex notificationMutex;

/**
 * @brief Implementation of thread-safe notification delivery
 * @details Uses lock_guard to ensure mutual exclusion when accessing Hyprland API
 * @param message Notification content (max 1 line recommended)
 * @param color RGBA color tuple {r, g, b, a} (0.0-1.0 range)
 * @param duration Visibility time in ms (3000 = 3 seconds)
 * @warning PHANDLE must be initialized before calling this function
 */
void sendNotification(const std::string& message, const CHyprColor& color, int duration) {
    std::lock_guard<std::mutex> lock(notificationMutex);
    if (PHANDLE) {
        HyprlandAPI::addNotification(PHANDLE, message, color, duration);
    }
}

/**
 * @brief Expands tilde prefix to current user's home directory
 * @details Implementation details:
 * - Returns empty string for empty input
 * - Only expands leading tilde
 * - Uses $HOME environment variable on UNIX-like systems
 * - Falls back to tilde removal if $HOME not set
 * @param path Input filesystem path (e.g. "~/.config/hypr")
 * @return Expanded path (e.g. "/home/user/.config/hypr")
 * @note Windows support is limited - considers USERPROFILE but focuses on *nix
 */
std::string expandTilde(const std::string& path) {
    if (path.empty()) {
        return "";
    }

    if (path[0] == '~') {
        const char* home = std::getenv("HOME");
        if (home) {
            return std::string(home) + path.substr(1);
        }
        return path.substr(1);
    }

    return path;
}
