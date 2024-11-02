#include <iostream>
#include <string>
#include <unordered_map>
#include <functional>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <cstring>

const std::string SOCKET_PATH = "/run/user/1000/hypr/4520b30d498daca8079365bdb909a8dea38e8d55_1729939633_770190872/.socket2.sock";

// Function prototypes
void handleWorkspace(const std::string& data);
void handleWorkspaceV2(const std::string& data);
void handleFocusedMon(const std::string& data);
void handleActiveWindow(const std::string& data);
void handleActiveWindowV2(const std::string& data);
void handleFullscreen(const std::string& data);
void handleOpenWindow(const std::string& data);
void handleCloseWindow(const std::string& data);

// Define the event handler type
using EventHandler = std::function<void(const std::string&)>;

// Create a map of event handlers
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

// Event handler implementations
void handleWorkspace(const std::string& data) {
    std::cout << "Workspace changed: " << data << std::endl;
}

void handleWorkspaceV2(const std::string& data) {
    auto delimiterPos = data.find(',');
    std::string id = data.substr(0, delimiterPos);
    std::string name = data.substr(delimiterPos + 1);
    std::cout << "Workspace v2 changed: " << id << ", " << name << std::endl;
}

void handleFocusedMon(const std::string& data) {
    auto delimiterPos = data.find(',');
    std::string monitor = data.substr(0, delimiterPos);
    std::string workspace = data.substr(delimiterPos + 1);
    std::cout << "Focused monitor: " << monitor << " Workspace: " << workspace << std::endl;
}

void handleActiveWindow(const std::string& data) {
    auto delimiterPos = data.find(',');
    std::string windowClass = data.substr(0, delimiterPos);
    std::string windowTitle = data.substr(delimiterPos + 1);
    std::cout << "Active window: " << windowClass << " " << windowTitle << std::endl;
}

void handleActiveWindowV2(const std::string& data) {
    std::cout << "Active window v2: " << data << std::endl;
}

void handleFullscreen(const std::string& data) {
    int status = std::stoi(data);
    if (status == 1) {
        std::cout << "Window entered fullscreen" << std::endl;
    } else {
        std::cout << "Window exited fullscreen" << std::endl;
    }
}

void handleOpenWindow(const std::string& data) {
    auto tokens = data.find(',');
    std::string address = data.substr(0, tokens);
    std::string workspace = data.substr(tokens + 1, data.find(',', tokens + 1));
    std::string windowClass = data.substr(data.find(',', tokens + 1) + 1, data.find(',', data.find(',', tokens + 1) + 1));
    std::string title = data.substr(data.find_last_of(',') + 1);
    std::cout << "Open window: " << address << " " << workspace << " " << windowClass << " " << title << std::endl;
}

void handleCloseWindow(const std::string& data) {
    std::cout << "Close window: " << data << std::endl;
}

// Function to process messages
void processMessage(const std::string& message) {
    auto delimiterPos = message.find(">>");
    std::string eventType = message.substr(0, delimiterPos);
    std::string data = message.substr(delimiterPos + 2);

    auto handler = eventHandlers.find(eventType);
    if (handler != eventHandlers.end()) {
        handler->second(data);
    } else {
        std::cout << "Unknown event type: " << eventType << std::endl;
    }
}

// Function to connect to the Unix socket and read messages
void readFromSocket() {
    int sock = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sock == -1) {
        std::cerr << "Failed to create socket" << std::endl;
        return;
    }

    sockaddr_un addr{};
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, SOCKET_PATH.c_str(), sizeof(addr.sun_path) - 1);

    if (connect(sock, reinterpret_cast<sockaddr*>(&addr), sizeof(addr)) == -1) {
        std::cerr << "Failed to connect to socket" << std::endl;
        close(sock);
        return;
    }

    char buffer[1024];
    while (true) {
        ssize_t bytesReceived = recv(sock, buffer, sizeof(buffer) - 1, 0);
        if (bytesReceived > 0) {
            buffer[bytesReceived] = '\0';
            processMessage(std::string(buffer));
        } else if (bytesReceived == 0) {
            std::cerr << "Connection closed" << std::endl;
            break;
        } else {
            std::cerr << "Error receiving data" << std::endl;
            break;
        }
    }

    close(sock);
}

int main() {
    readFromSocket();
    return 0;
}
