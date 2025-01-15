#pragma once

#include <hyprland/src/plugins/PluginAPI.hpp>
#include <string>
#include <mutex>
#include <memory>

inline HANDLE PHANDLE = nullptr;

void sendNotification(const std::string& message, const CHyprColor& color, int duration);

// Mutex to ensure thread-safe notifications
extern std::mutex notificationMutex;

class FileWatcher;

// Global smart pointer to manage the FileWatcher instance
extern std::unique_ptr<FileWatcher> g_FileWatcher;
