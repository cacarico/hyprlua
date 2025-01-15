#include "globals.hpp"
#include "watcher.hpp"

#include <filesystem>
#include <string>
#include <stdexcept>

// Plugin API version function
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

  // Define the file and directory to watch
  const std::string filepath = "/home/cacarico/ghq/github.com/cacarico/dotfiles-pvt/config/hypr/hyprland.lua";
  std::filesystem::path filePathObj(filepath);
  const std::string directory = filePathObj.parent_path().string();

  // Initialize the FileWatcher
  g_FileWatcher = std::make_unique<FileWatcher>(filepath, directory);
  g_FileWatcher->start();

  sendNotification(
      "[Hyprlua] Plugin initialized successfully.",
      CHyprColor{0.2, 0.6, 1.0, 1.0},
      3000
      );

  // Return the plugin description info
  return {"Hyprlua", "A plugin to enable lua support for Hyprland", "cacarico", "0.1"};
}

// Plugin exit function
APICALL EXPORT void PLUGIN_EXIT() {
  // Stop and clean up the watcher thread
  if (g_FileWatcher) {
    g_FileWatcher->stop();
    g_FileWatcher.reset();
  }

  sendNotification(
      "[Hyprlua] Plugin exiting. Stopped file monitoring.",
      CHyprColor{1.0, 1.0, 0.2, 1.0},
      3000
      );
}
