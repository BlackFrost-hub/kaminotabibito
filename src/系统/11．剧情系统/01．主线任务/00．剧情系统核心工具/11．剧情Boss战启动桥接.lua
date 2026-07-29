--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["剧情Boss预置暂停来源"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_0["移除单位暂停"]
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动")
local _____542F_52A8Boss_6218_8FD0_884C = ____require_result_2["启动Boss战运行"]
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_3["应用Boss战启动属性配置"]
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_4["记录Boss自动技能启动"]
local _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD = ____require_result_4["是否已登记Boss自动技能"]
local SetUnitInvulnerable = jass.SetUnitInvulnerable
____exports["启动剧情Boss战"] = function(bossUnit, _____53C2_6570)
    if bossUnit == nil or bossUnit == 0 then
        return false
    end
    if not _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD(bossUnit) then
        _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(bossUnit, "Boss战.绑定单位")
    end
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(bossUnit)
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "绑定单位",
        "unit",
        bossUnit
    )
    local ____temp_7 = _____53C2_6570 and _____53C2_6570["触发单位"]
    if ____temp_7 == nil then
        ____temp_7 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    end
    local _____89E6_53D1_5355_4F4D = ____temp_7
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        YDUserDataSetSafe(
            "string",
            "Boss战",
            "触发玩家",
            "unit",
            _____89E6_53D1_5355_4F4D
        )
    end
    _____79FB_9664_5355_4F4D_6682_505C(bossUnit, _____53C2_6570 and _____53C2_6570["暂停来源"] or _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90)
    SetUnitInvulnerable(bossUnit, false)
    _____542F_52A8Boss_6218_8FD0_884C(bossUnit)
    return true
end
return ____exports
