#pragma once

#include <hyprland/src/plugins/PluginAPI.hpp>
#include <memory>

/**
 * @file globals.hpp
 * @brief Global variables and forward declarations for Hyprlua plugin
 */

/// @brief Hyprland API handle provided during plugin initialization
inline HANDLE PHANDLE = nullptr;

/// @brief Forward declaration of FileWatcher class
class FileWatcher;

/**
 * @brief Global FileWatcher instance manager
 * @details Smart pointer managing the lifecycle of the file monitoring instance
 * @note Accessed by both main plugin logic and cleanup routines
 */
extern std::unique_ptr<FileWatcher> g_FileWatcher;
