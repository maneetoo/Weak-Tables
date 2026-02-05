# 🔧 WeakTables - Weak Reference Tables for Roblox Lua
**Create weak tables to prevent memory leaks in Roblox games. Automatic garbage collection included. More information [here](https://www.lua.org/pil/17.html)**

---

## 💡 What It Does

WeakTables provides a clean, type-safe API for creating tables with weak references in Roblox Luau. Unlike regular tables, weak tables automatically remove entries when their keys or values are no longer referenced elsewhere, preventing memory leaks in long-running games.

> Example: Create a cache for expensive computations → store results with weak keys → when objects are destroyed, entries are automatically removed → no manual cleanup needed!

---

## 🚀 Features

### 📦 **Three Weak Table Types**
- **Weak Keys** (`newWeakKeys`) - Keys can be garbage collected
- **Weak Values** (`newWeakValues`) - Values can be garbage collected  
- **Weak Both** (`newWeakBoth`) - Both keys and values can be garbage collected

### 🔧 **Utility Functions**
- `makeWeak()` - Convert existing tables to weak tables
- `isWeakTable()` - Check if a table has weak references
- `getWeakMode()` - Get the weak mode of a table
- `toRegularTable()` - Convert weak table to regular table
- `clone()` - Create a deep copy preserving weak mode

### 🛡️ **Safe Operations**
- `safeForEach()` - Iterate safely without GC interference
- `map()` / `filter()` - Functional programming utilities
- `count()` - Get approximate entry count
- `debugPrint()` - Debugging helper

### 🏗️ **Roblox & Luau Ready**
- Full Luau type definitions
- Studio autocomplete support
- Error handling and validation
- MIT licensed - free to use and modify

---

## ⚠️ Important Notes

### 🔄 **Garbage Collection Behavior**
- Weak table entries are **automatically removed** by Lua's garbage collector
- Timing is non-deterministic - entries may disappear at any time
- Never assume entries will persist across frames

### 🎮 **Roblox-Specific Considerations**
- **Instance references**: When Instances are destroyed, they become `nil` in weak tables
- **Memory management**: Essential for long-running games to prevent leaks
- **Event connections**: Consider using weak tables for event handler registries

### ⚡ **Performance Tips**
- Use `safeForEach()` for reliable iteration
- Avoid storing essential game state in weak tables
- Combine with `pcall()` for defensive programming
- Monitor memory usage with Roblox Studio's memory profiler

---

## 🚀 Quick Start

```lua
local WeakTables = require(game.ReplicatedStorage.WeakTables)

-- Weak keys table
local cache = WeakTables.newWeakKeys()
cache[player] = playerData  -- Removes when player leaves

-- Weak values table
local registry = WeakTables.newWeakValues()
registry["player"] = character  -- Removes when character destroyed

-- Both weak keys and values
local tempStorage = WeakTables.newWeakBoth()
```

---

## 📚 API Examples

### Basic Usage
```lua
-- Weak keys: keys can be GC'd
local weakKeys = WeakTables.newWeakKeys()
weakKeys[player] = playerData  -- Removed when player leaves

-- Weak values: values can be GC'd  
local weakValues = WeakTables.newWeakValues()
weakValues["cacheKey"] = temporaryObject  -- Removed when object destroyed

-- Weak both: both can be GC'd
local weakBoth = WeakTables.newWeakBoth()
weakBoth[temporaryKey] = temporaryValue
```

### Safe Iteration
```lua
-- Regular iteration may miss entries due to GC
for key, value in pairs(weakTable) do
    -- Entries might disappear during iteration!
end

-- Safe iteration collects entries first
WeakTables.safeForEach(weakTable, function(key, value)
    -- Safe from GC interference
    print(key, value)
end)
```

### Utility Functions
```lua
-- Convert existing table to weak table
local regularTable = {a = 1, b = 2}
WeakTables.makeWeak(regularTable, "k")  -- Now has weak keys

-- Check table type
if WeakTables.isWeakTable(myTable) then
    print("This is a weak table!")
end

-- Debug printing
WeakTables.debugPrint(myWeakTable, "Player Cache")
```

---

## 📦 Installation

1. Download [WeakTables.luau](https://github.com/maneetoo/Weak-Tables/blob/main/WeakTables.lua)
2. Place in your Roblox project's `ReplicatedStorage` or `ServerScriptService`
3. Require in your scripts:
```lua
local WeakTables = require(path.to.WeakTables)
```
4. Done! You can use WeakTables @module

---

## 📄 License

**MIT License © 2025 @manee_too**
You may use, modify, and distribute this plugin freely.
Please include attribution to "@manee_too" in your game credits.

Full License: [LICENSE](https://github.com/maneetoo/Weak-Tables/edit/main/LICENSE)

---

## ❓ Why Use This?

- **Caching** - data removes itself when objects are destroyed
- **Object registries** - automatic cleanup on deletion
- **Temporary storage** - no manual cleanup needed
- **Memory leak prevention** - crucial for long game sessions
