local M = {}

-- M.setup = function(opt)
-- 	print("Options", opt)
-- end

-- functions we need
-- vim.keymap.set(...) -> create new keymaps
-- nvim_get_keymap
-- vim.api.nvim_get_keymap

local find_mapping = function(maps, lhs)
	-- paris: iterates over every key in a table, order not guaranteed
	-- ipairs: itereates over only numeric keys in a table order is guaranteed
	for _, value in ipairs(maps) do
		if value.lhs == lhs then
			return value
		end
	end
end

M._stack = {}

M.push = function(name, mode, mappings)
	local maps = vim.api.nvim_get_keymap(mode)

	local existing_maps = {}
	for lhs, rhs in pairs(mappings) do
		print("Searching for:", lhs)
		local existing = find_mapping(maps, lhs)

		if existing then
			table.insert(existing_maps, existing)
		end
	end

	P(existing_maps)

	M._stack[name] = existing_maps

	for lhs, rhs in pairs(mappings) do
		vim.keymap.set(mode, lhs, rhs)
	end
end

M.push("debug_mode", "n", {
	["\\ff"] = ":echo 'Hello'",
	["\\zt"] = ":echo 'Goodbye'",
})

M.pop = function(name)
end
--[[
lua require("stackmap").push("debug_mode", "n", {
	["<leader>st"] = ":echo 'Hello'"
	["<leader>zt"] = ":echo 'Goodbye'"
})
..
lua require("stackmap").pop("debug_mode", {
	...
})
--]]
return M
