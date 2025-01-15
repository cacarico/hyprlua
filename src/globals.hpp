#pragma once

#include <hyprland/src/plugins/PluginAPI.hpp>
#include <string>
#include <thread>
#include <atomic>

inline HANDLE PHANDLE = nullptr;

// Thread management for the file watcher
extern std::thread watcherThread;
extern std::atomic<bool> keepWatching;

// Function to send notifications
void sendNotification(const std::string& message, const CHyprColor& color, int duration);
