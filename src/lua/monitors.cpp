/**
 * @file monitors.cpp
 * @brief C++ module exposing Hyprland monitor management to Lua via Sol2 bindings.
 *
 * This module allows users to list, add, and disable monitors
 * from their Lua configuration using Hyprland's internal API.
 */

#include "monitors.hpp"
#include "utils.hpp"
#include "logger.hpp"

#include <hyprland/src/Compositor.hpp>
#include <hyprland/src/helpers/Color.hpp>
#include <hyprland/src/helpers/Monitor.hpp>
#include <sol/sol.hpp>
#include <iostream>
#include <vector>
#include <sstream>

namespace hyprlua::modules {

    /**
 * @brief Apply a monitor configuration rule via Hyprland's API.
 *
 * This function constructs an SMonitorRule from the provided parameters and
 * applies it to the monitor matching the given name (internal or EDID-style).
 *
 * @param name       The monitor identifier (internal name or prefixed with "desc:" for EDID match).
 * @param resolution The resolution string in the format "WIDTHxHEIGHT" (e.g. "1920x1080" or "preferred").
 * @param position   The position offset string "XxY" (e.g. "0x0" or "auto").
 * @param scale      The scaling factor as a float (e.g. 1.0).
 * @param workspaces Optional list of workspaces to assign to this output.
 */
    void add_monitor(const std::string& name, const std::string& resolution, const std::string& position, const double_t& scale, sol::optional<std::vector<double_t>> workspaces) {
        sendNotification("Applying monitor with Hyprland API", CHyprColor{1.0f, 0.5f, 0.0f, 1.0f}, 5000);
        log::info("Starting add_monitor");

        // Debug log of input parameters
        std::ostringstream debugLog;
        debugLog << "Add Monitor:\n"
                 << "  Name:       " << name << "\n"
                 << "  Resolution: " << resolution << "\n"
                 << "  Position:   " << position << "\n"
                 << "  Scale:      " << scale << "\n";
        if (workspaces) {
            debugLog << "  Workspaces: ";
            for (const auto& w : workspaces.value())
                debugLog << w << " ";
            debugLog << "\n";
        }
        log::debug(debugLog.str());

        // Build the monitor rule
        SMonitorRule rule;
        rule.name = name;

        // Parse resolution
        int resX = 1920, resY = 1080;
        sscanf(resolution.c_str(), "%dx%d", &resX, &resY);
        rule.resolution = Vector2D(resX, resY);

        // Parse position
        int posX = 0, posY = 0;
        sscanf(position.c_str(), "%dx%d", &posX, &posY);
        rule.offset = Vector2D(posX, posY);

        // Apply scale and enable
        rule.scale    = static_cast<float>(scale);
        rule.disabled = false;

        // Lookup the monitor in Hyprland
        auto monitor = g_pCompositor->getMonitorFromName(name);
        if (!monitor) {
            log::error("Monitor not found: " + name);
            std::cerr << "[hyprlua] Monitor not found: " << name << "\n";
            return;
        }

        // Apply the rule and notify
        monitor->applyMonitorRule(&rule, true);
        log::info("Monitor rule applied: " + name);
        sendNotification("Monitor rule applied", CHyprColor{0.0f, 1.0f, 0.0f, 1.0f}, 3000);
    }

    /**
 * @brief Disable a monitor via a Hyprland rule.
 *
 * Marks the monitor matching @p name as disabled, preventing it from showing.
 *
 * @param name The monitor identifier to disable.
 */
    void disable_monitor(const std::string& name) {
        sendNotification("Disabling monitor", CHyprColor{1.0f, 0.2f, 0.2f, 1.0f}, 5000);
        log::info("Disabling monitor: " + name);

        // Build a disabled rule
        SMonitorRule rule;
        rule.name     = name;
        rule.disabled = true;

        // Lookup and disable
        auto monitor = g_pCompositor->getMonitorFromName(name);
        if (!monitor) {
            log::error("Monitor not found for disabling: " + name);
            std::cerr << "[hyprlua] Monitor not found: " << name << "\n";
            return;
        }
        monitor->applyMonitorRule(&rule, true);

        log::info("Monitor disabled: " + name);
        sendNotification("Monitor disabled", CHyprColor{1.0f, 0.0f, 0.0f, 1.0f}, 3000);
    }

    /**
 * @brief List all known monitors (including disabled or fallback outputs).
 *
 * Iterates Hyprland's m_realMonitors to return every monitor's internal name.
 *
 * @return A vector of internal monitor names (e.g. "WAYLAND-1").
 */
std::vector<std::string> list_monitors() {
    std::vector<std::string> names;

    // m_monitors is vector<CSharedPointer<CMonitor>>
    for (auto& monSP : g_pCompositor->m_monitors) {
        if (!monSP)             // skip null shared‐ptrs
            continue;

        CMonitor* mon = monSP.get();

        // ————————————————————————————————————————————
        // 1) skip the internal fallback output
        if (mon->m_isUnsafeFallback)
            continue;

        // 2) skip the headless Wayland output used for XWayland
        //    they all come in as “WAYLAND-N”
        if (mon->m_name.rfind("WAYLAND", 0) == 0)
            continue;

        // 3) only include actually enabled, user-driven outputs
        if (!mon->m_enabled)
            continue;
        // ————————————————————————————————————————————

        // what hyprctl prints (e.g. “eDP-1”, “HDMI-A-1”)
        names.emplace_back(mon->m_name);
    }

    return names;}


    /**
 * @brief Bind the monitors module functions into Lua.
 *
 * Registers the C++ functions to be callable from Lua scripts:
 *  - __hypr_add_monitor
 *  - __hypr_disable_monitor
 *  - __hypr_list_monitors
 *
 * @param lua The Sol2 Lua state to bind into.
 */
    void bind_monitors(sol::state& lua) {
        sendNotification("Binding monitors module", CHyprColor{0.2f, 0.8f, 0.2f, 1.0f}, 4000);
        log::info("Binding monitor Lua functions");

        lua.set_function("__hypr_add_monitor", &add_monitor);
        lua.set_function("__hypr_disable_monitor", &disable_monitor);
        lua.set_function("__hypr_list_monitors", &list_monitors);

        std::cout << "[hyprlua] Monitors module loaded.\n";
        log::debug("Monitors module successfully bound.");
    }

} // namespace hyprlua::modules
