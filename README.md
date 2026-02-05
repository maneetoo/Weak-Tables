# 🔧 WeakTables - Weak Reference Tables for Roblox Lua
#### (WeakTables-Roblox)

**Create weak tables to prevent memory leaks in Roblox games. Automatic garbage collection included.**

---

## 💡 What It Does

Utility module for working with weak-reference tables in Roblox Luau. Allows creation of tables where keys and/or values can be automatically removed by garbage collector.

> Example: Object cache → when object gets destroyed, table entry removes itself → no memory leaks!

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

## 📚 Main Functions

### Creating Weak Tables
```lua
-- Weak keys
local weakKeys = WeakTables.newWeakKeys()

-- Weak values
local weakValues = WeakTables.newWeakValues()

-- Weak keys and values
local weakBoth = WeakTables.newWeakBoth()

-- Custom mode
local custom = WeakTables.newWeak("kv")  -- "k", "v", or "kv"
```

### Utilities
```lua
-- Convert regular table to weak
WeakTables.makeWeak(myTable, "k")

-- Check table type
if WeakTables.isWeakTable(myTable) then
    print("This is a weak table!")
end

-- Safe iteration (no GC interference)
WeakTables.safeForEach(weakTable, function(key, value)
    print(key, value)
end)

-- Debug
WeakTables.debugPrint(cache, "Player Cache")
```

---

## ⚠️ Important Notes

- **Entries removed automatically** by garbage collector
- **Removal timing is unpredictable** - entries can disappear anytime
- **Don't store critical data** in weak tables
- **Use `safeForEach()`** for reliable iteration
- **Perfect for caching** and temporary storage

---

## 📦 Installation

1. Download `WeakTables.luau`
2. Place in `ReplicatedStorage`
3. Use:
```lua
local WeakTables = require(game.ReplicatedStorage.WeakTables)
```

---

## 📄 License

**MIT License © 2025 @manee_too**
You may use, modify, and distribute this plugin freely.
Please include attribution to "Coffilhg" in your game credits.

Full License: [LICENSE](https://github.com/maneetoo/Weak-Tables/edit/main/LICENSE)

---

## ❓ Why Use This?

- **Caching** - data removes itself when objects are destroyed
- **Object registries** - automatic cleanup on deletion
- **Temporary storage** - no manual cleanup needed
- **Memory leak prevention** - crucial for long game sessions
