#include <iostream>
#include <string>
#include <cstring>
#include <cerrno>
#include <unistd.h>
#include <sys/inotify.h>
#include <fcntl.h>
#include <chrono>

int main() {
    const std::string filepath = "/home/cacarico/ghq/github.com/cacarico/dotfiles-pvt/config/hypr/hyprland.lua";
    const std::string directory = "/home/cacarico/ghq/github.com/cacarico/dotfiles-pvt/config/hypr/";

    int inotifyFd = inotify_init1(IN_NONBLOCK);
    if (inotifyFd < 0) {
        std::cerr << "inotify_init1 error: " << std::strerror(errno) << "\n";
        return 1;
    }

    int watchDesc = inotify_add_watch(inotifyFd, directory.c_str(), IN_ALL_EVENTS);
    if (watchDesc < 0) {
        std::cerr << "Failed to add watch for " << directory
                  << ": " << std::strerror(errno) << "\n";
        close(inotifyFd);
        return 1;
    }

    std::cout << "Monitoring '" << filepath << "' for changes...\n";

    auto lastEventTime = std::chrono::steady_clock::now() - std::chrono::seconds(1);

    while (true) {
        char buffer[4096] __attribute__((aligned(__alignof__(inotify_event))));
        ssize_t numRead = read(inotifyFd, buffer, sizeof(buffer));

        if (numRead > 0) {
            for (char* ptr = buffer; ptr < buffer + numRead; ) {
                auto* event = reinterpret_cast<inotify_event*>(ptr);

                if (event->len > 0) {
                    std::string eventFile = directory + event->name;

                    if (eventFile == filepath) {
                        auto now = std::chrono::steady_clock::now();
                        if (now - lastEventTime > std::chrono::milliseconds(500)) {
                            std::cout << "File was modified: " << filepath << "\n";
                            lastEventTime = now;
                        }
                    }
                }

                ptr += sizeof(inotify_event) + event->len;
            }
        }

        usleep(500000); // Sleep to reduce CPU usage
    }

    inotify_rm_watch(inotifyFd, watchDesc);
    close(inotifyFd);

    return 0;
}
