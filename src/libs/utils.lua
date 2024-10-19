local utils = {}

--- Validate types
--- @param params (table) Parameters list (e.g., {options = { options, "table", true }})
function utils.validate(params)
	for param_name, param_info in pairs(params) do
		local value, expected_types, optional = param_info[1], param_info[2], param_info[3]

		if value == nil then
			if not optional then
				error(string.format("Parameter '%s' is required.", param_name))
			end
		else
			local value_type = type(value)
			local valid_type = false

			for _, expected_type in ipairs(type(expected_types) == "table" and expected_types or { expected_types }) do
				if value_type == expected_type then
					valid_type = true
					break
				end
			end
			if not valid_type then
				error(
					string.format(
						"Parameter '%s' must be of type %s.",
						param_name,
						table.concat(expected_types, " or ")
					)
				)
			end
		end
	end
end

--- Merge tables
--- @param defaults (table) Default List
--- @param opts (table) User options
function utils.merge_tables(defaults, opts)
	if type(opts) ~= "table" then
		return defaults
	end
	for k, v in pairs(opts) do
		if type(v) == "table" and type(defaults[k] or nil) == "table" then
			defaults[k] = utils.merge_tables(defaults[k], v)
		else
			defaults[k] = v
		end
	end
	return defaults
end

--- Serialize the configuration table into a formatted string
--- @param config (table) The configuration table to serialize
--- @param config_type (string) Representing the type or name of the configuration (e.g., "general")
--- @return string Returns the serialized table
function utils.serialize_config(config, config_type)
	local serialized_lines = {}
	local header_line = string.format("%s {", config_type)
	table.insert(serialized_lines, header_line)

	-- Recursive function to serialize nested tables
	local function serialize_table(current_table, parent_key)
		-- Collect all keys from the current table
		local keys = {}
		for key in pairs(current_table) do
			table.insert(keys, key)
		end

		-- Sort the keys alphabetically for consistent ordering
		table.sort(keys)

		-- Iterate over each sorted key
		for _, key in ipairs(keys) do
			local value = current_table[key]
			local full_key = parent_key and (parent_key .. "." .. key) or key

			if type(value) == "table" then
				-- Recursively serialize nested tables
				serialize_table(value, full_key)
			else
				local serialized_value

				-- Determine how to serialize the value based on its type
				if type(value) == "string" then
					serialized_value = value
				elseif type(value) == "number" or type(value) == "boolean" then
					serialized_value = tostring(value)
				else
					serialized_value = "nil"
				end

				-- Add the serialized key-value pair to the lines
				table.insert(serialized_lines, string.format("    %s = %s", full_key, serialized_value))
			end
		end
	end

	-- Serializes and
	serialize_table(config)
	table.insert(serialized_lines, "}")

	return table.concat(serialized_lines, "\n")
end

return utils
