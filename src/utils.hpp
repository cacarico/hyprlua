#pragma once
#include <hyprland/src/helpers/Color.hpp>
#include <mutex>
#include <string>

/**
 * @file utils.hpp
 * @brief Utility functions and resources for Hyprland plugin
 */

/**
 * @brief Send a notification through Hyprland's notification system
 * @param message The text content to display
 * @param color The color scheme for the notification (RGBA)
 * @param duration Display duration in milliseconds
 * @note Thread-safe through mutex locking
 */
void sendNotification(const std::string& message, const CHyprColor& color, int duration);

/// @brief Mutex for synchronizing notifications across threads
extern std::mutex notificationMutex;

/**
 * @brief Expand tilde (~) in paths to user's home directory
 * @param path Input path potentially containing tilde
 * @return Expanded path if tilde exists, original path otherwise
 * @note Handles both "~" and "~/subpath" formats
 */
std::string expandTilde(const std::string& path);
