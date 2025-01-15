#pragma once

#include <string>
#include <thread>
#include <atomic>
#include "globals.hpp"

class FileWatcher {
public:
    FileWatcher(const std::string& filepath, const std::string& directory);
    ~FileWatcher();

    void start();
    void stop();

private:
    // The core file watching logic
    void watch();

    std::string m_filepath;
    std::string m_directory;
    std::thread m_thread;      // Thread running the watcher
    std::atomic<bool> m_keepWatching; // Flag to control the watcher loop
};
