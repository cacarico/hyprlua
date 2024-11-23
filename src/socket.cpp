/**
 * @file
 * @brief Hyprland plugin that handles various events received over a Unix socket.
 */

#include <iostream>
#include <string>
#include <unordered_map>
#include <functional>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <cstring>
#include <thread>
#include <atomic>

// For symbol exporting
#define PLUGIN_API __attribute__((visibility("default")))

const std::string SOCKET_PATH = "/run/user/1000/hypr/4520b30d498daca8079365bdb909a8dea38e8d55_1729939633_770190872/.socket2.sock";

/**
 * @brief Handles workspace change events.
 * @param data The data associated with the workspace change event.
 */
void handleWorkspace(const std::string& data) {
    std::cout << "Workspace event: " << data << std::endl;
}

/**
 * @brief Handles v2 workspace change events.
 * Parses the workspace ID and name from the provided data.
 * @param data The data associated with the workspace v2 change event.
 */
void handleWorkspaceV2(const std::string& data) {
    std::cout << "WorkspaceV2 event: " << data << std::endl;
}

/**
 * @brief Handles focused monitor change events.
 * @param data The data associated with the focused monitor event.
 */
void handleFocusedMon(const std::string& data) {
    std::cout << "Focused monitor event: " << data << std::endl;
}

/**
 * @brief Handles active window change events.
 * @param data The data associated with the active window event.
 */
void handleActiveWindow(const std::string& data) {
    std::cout << "Active window event: " << data << std::endl;
}

/**
 * @brief Handles v2 active window events.
 * @param data The data associated with the active window v2 event.
 */
void handleActiveWindowV2(const std::string& data) {
    std::cout << "Active window V2 event: " << data << std::endl;
}

/**
 * @brief Handles fullscreen status change events.
 * @param data The data indicating whether fullscreen is enabled (1) or disabled (0).
 */
void handleFullscreen(const std::string& data) {
    std::cout << "Fullscreen event: " << data << std::endl;
}

/**
 * @brief Handles events related to opening new windows.
 * Parses details such as address, workspace, window class, and title.
 * @param data The data associated with the open window event.
 */
void handleOpenWindow(const std::string& data) {
    std::cout << "Open window event: " << data << std::endl;
}

/**
 * @brief Handles events related to closing windows.
 * @param data The data associated with the close window event.
 */
void handleCloseWindow(const std::string& data) {
    std::cout << "Close window event: " << data << std::endl;
}

// Define the event handler type
using EventHandler = std::function<void(const std::string&)>;

/**
 * @brief Map of event names to their respective handlers.
 */
std::unordered_map<std::string, EventHandler> eventHandlers = {
    {"workspace", handleWorkspace},
    {"workspacev2", handleWorkspaceV2},
    {"focusedmon", handleFocusedMon},
    {"activewindow", handleActiveWindow},
    {"activewindowv2", handleActiveWindowV2},
    {"fullscreen", handleFullscreen},
    {"openwindow", handleOpenWindow},
    {"closewindow", handleCloseWindow}
};

/**
 * @brief Processes incoming messages by identifying the event type and delegating to the appropriate handler.
 * @param message The message received from the socket, in the format "eventType>>data".
 */
void processMessage(const std::string& message) {
    auto delimiterPos = message.find(">>");
    if (delimiterPos == std::string::npos) {
        std::cerr << "Invalid message format: " << message << std::endl;
        return;
    }

    std::string eventType = message.substr(0, delimiterPos);
    std::string data = message.substr(delimiterPos + 2);

    auto handlerIt = eventHandlers.find(eventType);
    if (handlerIt != eventHandlers.end()) {
        handlerIt->second(data);
    } else {
        std::cout << "Unhandled event type: " << eventType << " with data: " << data << std::endl;
    }
}

// Global variables for thread management
std::thread socketThread;
std::atomic<bool> keepRunning{true};
int socket_fd = -1;

/**
 * @brief Establishes a connection to the Unix socket and reads incoming messages in a loop.
 */
void readFromSocket() {
    struct sockaddr_un addr;
    socket_fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (socket_fd == -1) {
        std::cerr << "Failed to create socket: " << strerror(errno) << std::endl;
        return;
    }

    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, SOCKET_PATH.c_str(), sizeof(addr.sun_path) - 1);

    if (connect(socket_fd, (struct sockaddr*)&addr, sizeof(addr)) == -1) {
        std::cerr << "Failed to connect to socket: " << strerror(errno) << std::endl;
        close(socket_fd);
        socket_fd = -1;
        return;
    }

    char buffer[4096];
    while (keepRunning) {
        ssize_t bytesRead = read(socket_fd, buffer, sizeof(buffer) - 1);
        if (bytesRead > 0) {
            buffer[bytesRead] = '\0';
            processMessage(std::string(buffer));
        } else if (bytesRead == 0) {
            std::cerr << "Socket closed by server." << std::endl;
            break;
        } else {
            if (errno == EINTR) {
                continue; // Interrupted, retry
            }
            std::cerr << "Error reading from socket: " << strerror(errno) << std::endl;
            break;
        }
    }

    if (socket_fd != -1) {
        close(socket_fd);
        socket_fd = -1;
    }
}

/**
 * @brief Plugin initialization function called by Hyprland when the plugin is loaded.
 */
extern "C" PLUGIN_API void hyprland_plugin_init() {
    std::cout << "Hyprland plugin initialized." << std::endl;
    keepRunning = true;
    socketThread = std::thread(readFromSocket);
}

/**
 * @brief Plugin exit function called by Hyprland when the plugin is unloaded.
 */
extern "C" PLUGIN_API void hyprland_plugin_exit() {
    std::cout << "Hyprland plugin exiting." << std::endl;
    keepRunning = false;
    if (socket_fd != -1) {
        shutdown(socket_fd, SHUT_RDWR);
        close(socket_fd);
        socket_fd = -1;
    }
    if (socketThread.joinable()) {
        socketThread.join();
    }
}
