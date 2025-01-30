#pragma once

#include <string>
#include <thread>
#include <atomic>
#include "globals.hpp"

/**
 * @class FileWatcher
 * @brief Monitors filesystem changes in a directory using inotify
 *
 * This class watches a specified directory for changes to a target file,
 * providing notifications through the application's UI system. It uses
 * Linux's inotify API internally and runs monitoring in a separate thread.
 */
class FileWatcher {
  public:
    /**
     * @brief Construct a new FileWatcher instance
     * @param filepath Full path to the target file to monitor
     * @param directory Parent directory to watch for changes
     */
    FileWatcher(const std::string& filepath, const std::string& directory);

    /**
     * @brief Destructor that ensures clean thread termination
     */
    ~FileWatcher();

    /**
     * @brief Start the file watching thread
     */
    void start();

    /**
     * @brief Stop the file watching thread
     */
    void stop();

  private:
    /**
     * @brief Main monitoring loop using inotify
     * @details This method contains the core logic for setting up inotify watches,
     *          processing filesystem events, and handling errors.
     */
    void watch();

    /// @brief Full path to the target file being monitored
    std::string m_filepath;

    /// @brief Directory path being watched for changes
    std::string m_directory;

    /// @brief Thread handle for the monitoring thread
    std::thread m_thread;

    /// @brief Atomic flag to control the monitoring loop
    std::atomic<bool> m_keepWatching;
};
