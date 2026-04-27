local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
--- 联机安全 Map 遍历工具
-- Lua pairs 遍历顺序不确定，跨客户端可能不一致导致 desync。
-- 安全做法：收集 keys → 排序 → 按序遍历。
function ____exports.forEachSorted(self, map, callback)
    local keys = {}
    for ____, k in __TS__Iterator(map:keys()) do
        keys[#keys + 1] = k
    end
    __TS__ArraySort(
        keys,
        function(____, a, b)
            if type(a) == "number" and type(b) == "number" then
                return a - b
            end
            local sa = tostring(a)
            local sb = tostring(b)
            if sa < sb then
                return -1
            end
            if sa > sb then
                return 1
            end
            return 0
        end
    )
    do
        local i = 0
        while i < #keys do
            local key = keys[i + 1]
            local value = map:get(key)
            if value ~= nil then
                callback(nil, key, value)
            end
            i = i + 1
        end
    end
end
return ____exports
