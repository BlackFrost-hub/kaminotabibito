--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- YDUserData 安全封装
-- 
-- 用途：
-- - 专门给 `@noSelfInFile` 文件使用
-- - 避免直接调用 `01．YDUserData兼容.ts` 导出的 `YDUserDataGet/Set`
--   时因为 TSTL / Lua 的 self 形态导致参数错位
-- 
-- 规则：
-- - 在普通文件里，仍可直接用原版 `YDUserDataGet/Set`
-- - 在 `@noSelfInFile` 文件里，优先用这里的安全版
local ydweCompat = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGetUnsafe = ydweCompat.YDUserDataGet
local YDUserDataSetUnsafe = ydweCompat.YDUserDataSet
function ____exports.YDUserDataGetSafe(tableType, tableKey, attr, valueType)
    return YDUserDataGetUnsafe(
        nil,
        tableType,
        tableKey,
        attr,
        valueType
    )
end
function ____exports.YDUserDataSetSafe(tableType, tableKey, attr, valueType, value)
    YDUserDataSetUnsafe(
        nil,
        tableType,
        tableKey,
        attr,
        valueType,
        value
    )
end
____exports["安全YDUserDataGet"] = ____exports.YDUserDataGetSafe
____exports["安全YDUserDataSet"] = ____exports.YDUserDataSetSafe
return ____exports
