local utils = {}

function utils.validate(params)
    for param_name, param_info in pairs(params) do
        local value, expected_types, optional = param_info[1], param_info[2], param_info[3]
        if value == nil then
            if not optional then
                error(string.format("Parameter '%s' is required.", param_name))
            end
        else
            local value_type = type(value)
            local valid = false
            for _, expected_type in ipairs(type(expected_types) == "table" and expected_types or { expected_types }) do
                if value_type == expected_type then
                    valid = true
                    break
                end
            end
            if not valid then
                error(string.format("Parameter '%s' must be of type %s.", param_name, table.concat(expected_types, " or ")))
            end
        end
    end
end

return utils
