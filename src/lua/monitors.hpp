// monitors.hpp
#pragma once

#include <sol/sol.hpp>

namespace hyprlua::modules {

    std::vector<std::string> list_monitors();
    void                     bind_monitors(sol::state& lua);

} // namespace hyprlua::modules
