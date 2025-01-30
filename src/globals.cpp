#include "globals.hpp"
#include "watcher.hpp"
#include <hyprland/src/plugins/PluginAPI.hpp>

/**
 * @var std::unique_ptr<FileWatcher> g_FileWatcher
 * @brief Global file watcher instance definition
 * @details Initialized to nullptr, will be populated during plugin initialization
 *          and cleaned up during plugin termination
 */
std::unique_ptr<FileWatcher> g_FileWatcher = nullptr;
