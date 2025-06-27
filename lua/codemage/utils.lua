--- Personal collecton of reusable doings

local M = {}

--- Helper method on the unified set to convert table of (k, v) to a simple table 1-indexed
--- of unique elements
---
--- @param set_table table A simlated "hashset"
--- @return table A new array containing the unique elements from the set
local function to_array(set_table)
    local unique_elements = {}

	-- iterate over the keys which now serves as our elements
    for elem, _ in pairs(set_table) do
        table.insert(unique_elements, elem)
    end
    return unique_elements
end

--- Returns a new unique table from two different tables containing
--- duplicate elements
---
--- @param tableA table The first table (array or hash map) of elements.
--- @param tableB table The second table (array or hashmap) of elements
--- @return table A union of the two input tables
function M.unified_set(tableA, tableB)
    local visited = {}

    -- loop through the first table, discards duplicates
    for _, elem in ipairs(tableA) do
        visited[elem] = true
    end

    -- and the second table, discarding elements using temporary table
    -- simulating hashset like behavior
    for _, elem in ipairs(tableB) do
        visited[elem] = true
    end

    -- convert the unified_set, back to a non-duplicate array
    return to_array(visited)
end

return M
