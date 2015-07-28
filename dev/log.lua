log = {}

log.table = function(table, maxTab)
    local print_r_cache = {}
    local currentTab = 0
    local function sub_print_r(t, indent, count)
        if not count then count = 0 end
        count = count + 1
        if count == maxTab then return end
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "'" .. pos .. "' = " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8), count)
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "'" .. pos .. "' => '" .. val .. "'")
                    else
                        print(indent .. "'" .. pos .. "' => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end

    if (type(table) == "table") then
        print("==== " .. tostring(table) .. " ====")
        print("{")
        sub_print_r(table, "  ", currentTab)
        print("==========================")
        print("}")
    else
        sub_print_r(table, "  ")
    end
end

log.debug = function()
end