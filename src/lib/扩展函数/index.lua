--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
require("lib.扩展函数.BJ函数.index")
require("lib.扩展函数.YDWE函数.index")
require("lib.扩展函数.KK扩展API.index")
require("lib.扩展函数.Star扩展函数.index")
require("lib.扩展函数.物品相关函数.index")
require("lib.扩展函数.自定义扩展函数.index")
--- 初始化扩展函数
function ____exports.init(self)
    local p = _G.print
    if type(p) == "function" then
        p(nil, "[扩展函数] 初始化完成")
    end
end
return ____exports
