#include "globals.hpp"
#include "watcher.hpp"
#include "utils.hpp"
#include "lua/runtime.hpp"

#include <filesystem>
#include <cstdlib>
#include <iostream>
#include <string>
#include <any>

/**
 * @file main.cpp
 * @brief Main implementation of Hyprlua plugin for Hyprland compositor
 * @details Plugin initialization is deferred until after the first real monitor is added.
 */

/// Colors for notifications
const CHyprColor ERROR_COLOR   = {1.0f, 0.2f, 0.2f, 1.0f};
const CHyprColor SUCCESS_COLOR = {0.2f, 0.6f, 1.0f, 1.0f};

/// Timeouts (milliseconds)
const int ERROR_TIMEOUT   = 5000;
const int SUCCESS_TIMEOUT = 3000;

/// Ensure init happens only once
static bool pluginStarted = false;

/// @brief Performs the core plugin initialization
static void initPlugin() {
    try {
        // Resolve config path from env or default
        const char* configEnv = std::getenv("HYPRLUA_CONFIG_PATH");
        std::string filepath = configEnv ? configEnv : "~/.config/hypr/hyprland.lua";
        filepath = expandTilde(filepath);

        // Ensure watcher directory
        std::filesystem::path filePathObj(filepath);
        std::string directory = filePathObj.parent_path().string();

        // Initialize and start file watcher
        g_FileWatcher = std::make_unique<FileWatcher>(filepath, directory);
        if (!g_FileWatcher)
            throw std::runtime_error("[Hyprlua] Failed to allocate FileWatcher");
        g_FileWatcher->start();

        // Notify success and init Lua runtime
        sendNotification("[Hyprlua] Plugin initialized successfully.", SUCCESS_COLOR, SUCCESS_TIMEOUT);
        hyprlua::init_lua_runtime(
            "/home/cacarico/ghq/github.com/cacarico/hyprlua/runtime/modules/",
            "/home/cacarico/.config/hypr/hyprland.lua"
        );
    } catch (const std::exception& e) {
        std::cerr << "[Hyprlua] Initialization error: " << e.what() << std::endl;
        sendNotification(std::string("[Hyprlua] Error during init: ") + e.what(), ERROR_COLOR, ERROR_TIMEOUT);
    }
}

/**
 * @brief Plugin API version entry point
 */
APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

/**
 * @brief Plugin initialization entry point
 * @details Registers a callback for the first real monitor addition
 */
APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    // Register callback; run initPlugin once when first real monitor is added
    static auto cb = HyprlandAPI::registerCallbackDynamic(
        PHANDLE,
        "monitorAdded",
        [](void*, SCallbackInfo&, std::any) {
            if (!pluginStarted) {
                pluginStarted = true;
                initPlugin();
            }
        }
    );

    return {"Hyprlua", "A plugin to enable Lua support for Hyprland", "cacarico", "0.1"};
}

/**
 * @brief Plugin exit entry point
 */
APICALL EXPORT void PLUGIN_EXIT() {
    try {
        if (g_FileWatcher) {
            g_FileWatcher->stop();
            g_FileWatcher.reset();
        }
        sendNotification("[Hyprlua] Plugin exiting. Stopped file monitoring.", SUCCESS_COLOR, SUCCESS_TIMEOUT);
    } catch (const std::exception& e) {
        std::cerr << "[Hyprlua] Error during exit: " << e.what() << std::endl;
    }
}
