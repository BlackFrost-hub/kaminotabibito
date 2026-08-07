--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local ____require_result_2 = require("系统.01．单位系统.03．怪物刷新系统.02．怪物刷新核心")
local _____767B_8BB0_52A8_6001_5237_602A_5355_4F4D = ____require_result_2["登记动态刷怪单位"]
local Player = jass.Player
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
____exports["米亚道中普通怪出生配置表"] = {{["单位ID"] = "n07B", X = 29579.5, Y = -20517.2, ["朝向"] = 270}, {["单位ID"] = "n07C", X = 28760.5, Y = -20738.6, ["朝向"] = 270}, {["单位ID"] = "n07B", X = 28484.2, Y = -20575.6, ["朝向"] = 270}, {["单位ID"] = "n07C", X = 28158.2, Y = -20646.8, ["朝向"] = 270}}
____exports["米亚道中精英出生配置"] = {["单位ID"] = "n07D", X = 27259.1, Y = -20699.3, ["朝向"] = 270}
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____521B_5EFA_5E76_767B_8BB0_7C73_4E9A_9053_4E2D_602A_7269(_____914D_7F6E)
    local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____914D_7F6E["单位ID"])
    if not (_____5355_4F4D_7C7B_578BID > 0) then
        return nil
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        _____5355_4F4D_7C7B_578BID,
        _____914D_7F6E.X,
        _____914D_7F6E.Y,
        _____914D_7F6E["朝向"]
    )
    if _____53E5_67C4_6709_6548(unit) then
        _____767B_8BB0_52A8_6001_5237_602A_5355_4F4D(unit)
    end
    return unit
end
____exports["创建米亚道中怪物"] = function()
    for ____, _____914D_7F6E in ipairs(____exports["米亚道中普通怪出生配置表"]) do
        _____521B_5EFA_5E76_767B_8BB0_7C73_4E9A_9053_4E2D_602A_7269(_____914D_7F6E)
    end
    _____521B_5EFA_5E76_767B_8BB0_7C73_4E9A_9053_4E2D_602A_7269(____exports["米亚道中精英出生配置"])
end
return ____exports
