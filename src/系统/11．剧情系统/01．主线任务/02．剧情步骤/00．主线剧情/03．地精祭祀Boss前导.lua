--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_0["暂停并设置无敌安全"]
local _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = "剧情系统:Boss预置"
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local ____require_result_2 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____require_result_2["启动剧情Boss战"]
local ____require_result_3 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_3.IsUnitAliveBJ
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_4["是玩家英雄组单位"]
local Player = jass.Player
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____5DF2_521D_59CB_5316_8FDB_5EA603_6838_5FC3 = false
local function _____8BFB_53D6_5730_7CBE_5DEB_5E08Boss()
    return YDUserDataGetSafe("string", "Boss", "地精巫师", "unit")
end
local function ____Boss_4ECD_662F_524D_5BFC_72B6_6001(bossUnit)
    return bossUnit ~= nil and bossUnit ~= 0 and IsUnitAliveBJ(bossUnit)
end
____exports["执行地精祭祀Boss前导激活"] = function(_____53C2_6570)
    local bossUnit = _____8BFB_53D6_5730_7CBE_5DEB_5E08Boss()
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 2 or not ____Boss_4ECD_662F_524D_5BFC_72B6_6001(bossUnit) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    local _____8840_6761Boss_7EC4 = YDUserDataGetSafe("string", "血条Boss", "单位组", "group")
    if _____8840_6761Boss_7EC4 ~= nil and _____8840_6761Boss_7EC4 ~= 0 then
        local GroupAddUnit = jass.GroupAddUnit
        GroupAddUnit(_____8840_6761Boss_7EC4, bossUnit)
    end
    local SetUnitOwner = jass.SetUnitOwner
    SetUnitOwner(
        bossUnit,
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        true
    )
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(bossUnit, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90)
end
____exports["执行地精祭祀Boss战正式注册"] = function(_____53C2_6570)
    local bossUnit = _____8BFB_53D6_5730_7CBE_5DEB_5E08Boss()
    if bossUnit == nil or bossUnit == 0 or not IsUnitAliveBJ(bossUnit) then
        return
    end
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    _____542F_52A8_5267_60C5Boss_6218(bossUnit, {["触发单位"] = _____89E6_53D1_5355_4F4D, ["暂停来源"] = _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90})
end
____exports["地精祭祀Boss前导剧情动作注册表"] = {["JLC精灵村_地精祭祀Boss前导激活"] = ____exports["执行地精祭祀Boss前导激活"], ["JLC精灵村_地精祭祀Boss战正式注册"] = ____exports["执行地精祭祀Boss战正式注册"]}
____exports["初始化进度03_地精祭祀Boss前导核心"] = function()
    if _____5DF2_521D_59CB_5316_8FDB_5EA603_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_8FDB_5EA603_6838_5FC3 = true
end
return ____exports
