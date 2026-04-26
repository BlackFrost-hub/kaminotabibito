--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 表现系统 - 统一导出和初始化入口
-- 
-- 须导出 `init`：`main.lua` 对 `require("系统.09．表现系统.index")` 的返回值做 `:init()` 调用。
-- 若本文件无任何 export，TSTL 会生成无 `return ____exports` 的 chunk，`require` 得到 `true`，下一行索引即报错。
function ____exports.init(self)
    local _____539F_751FUI = require("系统.09．表现系统.00．初始化UI")
    if type(_____539F_751FUI.initNativeUI) == "function" then
        _____539F_751FUI:initNativeUI()
    end
end
return ____exports
