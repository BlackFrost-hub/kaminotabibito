--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_1.X_FixUnitStandingSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_3["创建单位并登记排泄安全"]
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local function _____8BFB_53D6_5DF2_7ED1_5B9ANPC(_____914D_7F6E)
    if _____914D_7F6E["YD表"] == nil or _____914D_7F6E["YD键"] == nil or _____914D_7F6E["YD字段"] == nil then
        return nil
    end
    local unit = YDUserDataGetSafe("string", _____914D_7F6E["YD表"], _____914D_7F6E["YD键"], _____914D_7F6E["YD类型"] or "unit")
    local ____temp_4
    if unit == nil or unit == 0 then
        ____temp_4 = nil
    else
        ____temp_4 = unit
    end
    return ____temp_4
end
local function _____5199_5165NPC_7ED1_5B9A(_____914D_7F6E, unit)
    if _____914D_7F6E["YD表"] == nil or _____914D_7F6E["YD键"] == nil or _____914D_7F6E["YD字段"] == nil then
        return
    end
    YDUserDataSetSafe(
        "string",
        _____914D_7F6E["YD表"],
        _____914D_7F6E["YD键"],
        _____914D_7F6E["YD类型"] or "unit",
        unit
    )
end
--- 只负责剧情 NPC 的单位生命周期，不负责任务标记、对话或剧情入口注册。
____exports["创建剧情NPC单位"] = function(_____914D_7F6E)
    local unit = _____8BFB_53D6_5DF2_7ED1_5B9ANPC(_____914D_7F6E)
    if unit == nil then
        local owner = Player(_____914D_7F6E["玩家ID"] or _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID)
        local unitTypeId = stringToFourCCSafe(_____914D_7F6E["单位ID"])
        if not (unitTypeId > 0) then
            return nil
        end
        local ____temp_5
        if _____914D_7F6E["登记死亡排泄"] == true then
            ____temp_5 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                owner,
                unitTypeId,
                _____914D_7F6E.X,
                _____914D_7F6E.Y,
                _____914D_7F6E["朝向"]
            )
        else
            ____temp_5 = CreateUnit(
                owner,
                unitTypeId,
                _____914D_7F6E.X,
                _____914D_7F6E.Y,
                _____914D_7F6E["朝向"]
            )
        end
        unit = ____temp_5
        if unit == nil then
            return nil
        end
        _____5199_5165NPC_7ED1_5B9A(_____914D_7F6E, unit)
    end
    if _____914D_7F6E["初始化无敌"] == true then
        SetUnitInvulnerable(unit, true)
    end
    if _____914D_7F6E["初始化固定站立"] == true then
        X_FixUnitStandingSafe(unit)
    end
    return unit
end
return ____exports
