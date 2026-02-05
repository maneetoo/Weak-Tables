--[[--

    WeakTables - An improved utility module for creating weak tables in Roblox Lua
    
    Provides functionality for creating tables with weak keys, weak values, or both.
    Useful for preventing memory leaks by allowing garbage collection of unreferenced objects.
    
    =======================================================================================
    HOW TO USE:
    =======================================================================================
    
    1. Basic setup:
        local WeakTables = require(path.to.WeakTables)
        
    2. Creating weak tables:
        -- Weak keys (keys can be garbage collected)
        local weakKeyTable = WeakTables.newWeakKeys()
        
        -- Weak values (values can be garbage collected)
        local weakValueTable = WeakTables.newWeakValues()
        
        -- Weak keys and values (both can be garbage collected)
        local weakBothTable = WeakTables.newWeakBoth()
        
        -- Custom mode
        local customWeakTable = WeakTables.newWeak("kv") -- "k", "v", or "kv"
        
    3. Using weak tables:
        -- Works like regular tables
        weakKeyTable[someObject] = "data"
        weakValueTable["key"] = someObject
        
        -- Check if entry still exists
        if weakKeyTable[someObject] then
            -- Object still exists in memory
        end
        
    Key Features:
    • Prevents memory leaks by allowing garbage collection
    • Three types of weak tables: keys, values, or both
    • Simple API similar to regular tables
    • Compatible with Luau type checking
    • Edge case handling and validation
    • Debug utilities
    • Safe iteration methods
    
    Important Notes:
    • Weak tables automatically remove entries when keys/values are garbage collected
    • Entries may disappear during iteration - use safe iteration methods
    • nil values in weak tables behave differently than in regular tables
    
    
    -+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=
    More information about WeakTables and their purpose: https://www.lua.org/pil/17.html
    -+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=-+=
    
    
    Author: @manee_too (Discord UID: 1043756666857992192)
    Version: 1.0.0
    License: MIT
    
--]]--

local WeakTables = {}

-- Export types for Luau type checking
export type WeakTable<K, V> = {[K]: V}
export type WeakKeysTable<K, V> = WeakTable<K, V>
export type WeakValuesTable<K, V> = WeakTable<K, V>
export type WeakBothTable<K, V> = WeakTable<K, V>

-- Internal validation function
local function validateTable(tbl, methodName)
	if tbl == nil then
		error(string.format("%s: table cannot be nil", methodName), 3)
	end
	if type(tbl) ~= "table" then
		error(string.format("%s: expected table, got %s", methodName, type(tbl)), 3)
	end
end

-- Internal validation for mode parameter
local function validateMode(mode, methodName)
	if mode == nil then
		error(string.format("%s: mode cannot be nil", methodName), 3)
	end
	if type(mode) ~= "string" then
		error(string.format("%s: mode must be a string, got %s", methodName, type(mode)), 3)
	end
	if not (mode == "k" or mode == "v" or mode == "kv") then
		error(string.format("%s: invalid mode '%s'. Use 'k', 'v', or 'kv'", methodName, mode), 3)
	end
end

--- Creates a new table with weak keys (keys can be garbage collected)
-- @param initialData table? - Optional initial data for the table
-- @return WeakKeysTable - A table with weak keys
function WeakTables.newWeakKeys<K, V>(initialData: {[K]: V}?): WeakKeysTable<K, V>
	local tbl = {}
	setmetatable(tbl, {__mode = "k"})  -- Weak keys

	if initialData then
		validateTable(initialData, "newWeakKeys")
		for key, value in pairs(initialData) do
			tbl[key] = value
		end
	end

	return tbl
end

--- Creates a new table with weak values (values can be garbage collected)
-- @param initialData table? - Optional initial data for the table
-- @return WeakValuesTable - A table with weak values
function WeakTables.newWeakValues<K, V>(initialData: {[K]: V}?): WeakValuesTable<K, V>
	local tbl = {}
	setmetatable(tbl, {__mode = "v"})  -- Weak values

	if initialData then
		validateTable(initialData, "newWeakValues")
		for key, value in pairs(initialData) do
			tbl[key] = value
		end
	end

	return tbl
end

--- Creates a new table with both weak keys and values
-- @param initialData table? - Optional initial data for the table
-- @return WeakBothTable - A table with weak keys and values
function WeakTables.newWeakBoth<K, V>(initialData: {[K]: V}?): WeakBothTable<K, V>
	local tbl = {}
	setmetatable(tbl, {__mode = "kv"})  -- Weak keys and values

	if initialData then
		validateTable(initialData, "newWeakBoth")
		for key, value in pairs(initialData) do
			tbl[key] = value
		end
	end

	return tbl
end

--- Creates a weak table with specified mode
-- @param mode string - Weak mode: "k" (keys), "v" (values), or "kv" (both)
-- @param initialData table? - Optional initial data for the table
-- @return table - A weak table with specified mode
function WeakTables.newWeak<K, V>(mode: string, initialData: {[K]: V}?): WeakTable<K, V>
	validateMode(mode, "newWeak")

	local tbl = {}
	setmetatable(tbl, {__mode = mode})

	if initialData then
		validateTable(initialData, "newWeak")
		for key, value in pairs(initialData) do
			tbl[key] = value
		end
	end

	return tbl
end

--- Makes an existing table weak
-- @param tbl table - The table to make weak
-- @param mode string - Weak mode: "k" (keys), "v" (values), or "kv" (both)
-- @return table - The same table with weak references (now has metatable)
function WeakTables.makeWeak(tbl: {}, mode: string): {}
	validateTable(tbl, "makeWeak")
	validateMode(mode, "makeWeak")

	-- Check if table already has a metatable
	local existingMt = getmetatable(tbl)
	if existingMt then
		-- Preserve existing metatable but add/update __mode
		existingMt.__mode = mode
	else
		setmetatable(tbl, {__mode = mode})
	end

	return tbl
end

--- Checks if a table has weak references
-- @param tbl table - The table to check
-- @return boolean - True if the table has weak references
function WeakTables.isWeakTable(tbl: any): boolean
	if tbl == nil then
		return false
	end
	if type(tbl) ~= "table" then
		return false
	end

	local mt = getmetatable(tbl)
	return mt and mt.__mode ~= nil
end

--- Gets the weak mode of a table
-- @param tbl table - The table to check
-- @return string? - The weak mode ("k", "v", "kv", or nil if not weak)
function WeakTables.getWeakMode(tbl: any): string?
	if tbl == nil then
		return nil
	end
	if type(tbl) ~= "table" then
		return nil
	end

	local mt = getmetatable(tbl)
	return mt and mt.__mode
end

--- Creates a regular table from a weak table (copies all existing entries)
-- @param weakTable table - The weak table to convert
-- @return table - A regular table with the same entries
function WeakTables.toRegularTable<K, V>(weakTable: WeakTable<K, V>): {[K]: V}
	validateTable(weakTable, "toRegularTable")

	local regularTable = {}
	for key, value in pairs(weakTable) do
		if key ~= nil and value ~= nil then 
			regularTable[key] = value
		end
	end
	return regularTable
end

--- Creates a deep copy of a weak table (preserving weak mode)
-- @param weakTable table - The weak table to clone
-- @return table - A new weak table with the same mode and entries
function WeakTables.clone<K, V>(weakTable: WeakTable<K, V>): WeakTable<K, V>
	validateTable(weakTable, "clone")

	local mode = WeakTables.getWeakMode(weakTable) or "kv"
	local cloned = WeakTables.newWeak(mode)

	for key, value in pairs(weakTable) do
		if key ~= nil then  -- Skip nil keys (collected by GC)
			cloned[key] = value
		end
	end

	return cloned
end

--- Counts the number of entries in a weak table
-- Note: This may not be accurate as garbage collection can remove entries
-- @param weakTable table - The weak table to count
-- @return number - Approximate number of entries
function WeakTables.count(weakTable: {}): number
	validateTable(weakTable, "count")

	local count = 0
	for _ in pairs(weakTable) do
		count = count + 1
	end
	return count
end

--- Safely iterates over a weak table
-- Collects all entries first to avoid issues during iteration
-- @param weakTable table - The weak table to iterate
-- @param callback function - Function called for each entry: callback(key, value)
function WeakTables.safeForEach<K, V>(weakTable: WeakTable<K, V>, callback: (K, V) -> ())
	validateTable(weakTable, "safeForEach")

	if type(callback) ~= "function" then
		error("safeForEach: callback must be a function", 2)
	end

	-- First collect all entries to avoid GC issues during iteration
	local entries = WeakTables.toRegularTable(weakTable)

	-- Then iterate over the collected entries
	for key, value in pairs(entries) do
		callback(key, value)
	end
end

--- Maps a weak table to a new table
-- @param weakTable table - The weak table to map
-- @param mapper function - Function that transforms each entry: mapper(key, value) -> newValue
-- @return table - A new regular table with mapped values
function WeakTables.map<K, V, R>(weakTable: WeakTable<K, V>, mapper: (K, V) -> R): {[K]: R}
	validateTable(weakTable, "map")

	if type(mapper) ~= "function" then
		error("map: mapper must be a function", 2)
	end

	local result = {}
	WeakTables.safeForEach(weakTable, function(key, value)
		result[key] = mapper(key, value)
	end)

	return result
end

--- Filters a weak table
-- @param weakTable table - The weak table to filter
-- @param predicate function - Function that tests each entry: predicate(key, value) -> boolean
-- @return table - A new regular table with filtered entries
function WeakTables.filter<K, V>(weakTable: WeakTable<K, V>, predicate: (K, V) -> boolean): {[K]: V}
	validateTable(weakTable, "filter")

	if type(predicate) ~= "function" then
		error("filter: predicate must be a function", 2)
	end

	local result = {}
	WeakTables.safeForEach(weakTable, function(key, value)
		if predicate(key, value) then
			result[key] = value
		end
	end)

	return result
end

--- Prints debug information about a weak table
-- @param weakTable table - The weak table to debug
-- @param name string? - Optional name for the table in output
function WeakTables.debugPrint(weakTable: {}, name: string?)
	validateTable(weakTable, "debugPrint")

	local mode = WeakTables.getWeakMode(weakTable) or "not weak"
	local count = WeakTables.count(weakTable)

	local tableName = name or "weak table"

	print(string.format("=== Debug: %s ===", tableName))
	print(string.format("Mode: %s", mode))
	print(string.format("Entry count: %d", count))
	print("Entries:")

	local hasEntries = false
	WeakTables.safeForEach(weakTable, function(key, value)
		hasEntries = true
		local keyStr = tostring(key)
		local valueStr = tostring(value)
		print(string.format("  [%s] = %s", keyStr, valueStr))
	end)

	if not hasEntries then
		print("  (no entries or all collected by GC)")
	end

	print("=== End Debug ===")
end

--- Removes the deprecated clean() method warning
-- This method is kept for backward compatibility but does nothing
function WeakTables.clean(weakTable: {}): {}
	validateTable(weakTable, "clean")

	-- Weak tables clean themselves automatically through garbage collection
	-- This method is deprecated and does nothing
	warn("WeakTables.clean() is deprecated and does nothing. Weak tables clean themselves automatically.")

	return weakTable
end

-- Add __index metamethod to the module for better UX
local moduleMt = {
	__index = function(self, key)
		-- Provide helpful error message for undefined methods
		error(string.format("WeakTables.%s is not a valid method. Check the documentation for available methods.", key), 2)
	end
}

setmetatable(WeakTables, moduleMt)

return WeakTables :: typeof(WeakTables) & {
	newWeakKeys: <K, V>(initialData: {[K]: V}?) -> WeakKeysTable<K, V>,
	newWeakValues: <K, V>(initialData: {[K]: V}?) -> WeakValuesTable<K, V>,
	newWeakBoth: <K, V>(initialData: {[K]: V}?) -> WeakBothTable<K, V>,
	newWeak: <K, V>(mode: string, initialData: {[K]: V}?) -> WeakTable<K, V>,
	makeWeak: (tbl: {}, mode: string) -> {},
	isWeakTable: (any) -> boolean,
	getWeakMode: (any) -> string?,
	toRegularTable: <K, V>(WeakTable<K, V>) -> {[K]: V},
	clone: <K, V>(WeakTable<K, V>) -> WeakTable<K, V>,
	count: ({}) -> number,
	safeForEach: <K, V>(WeakTable<K, V>, (K, V) -> ()) -> (),
	map: <K, V, R>(WeakTable<K, V>, (K, V) -> R) -> {[K]: R},
	filter: <K, V>(WeakTable<K, V>, (K, V) -> boolean) -> {[K]: V},
	debugPrint: ({}, string?) -> (),
	clean: ({}) -> {},  -- Deprecated, kept for backward compatibility
}