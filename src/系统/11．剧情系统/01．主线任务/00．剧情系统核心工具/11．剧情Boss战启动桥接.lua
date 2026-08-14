--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____91CA_653E_5E76_767B_8BB0_5267_60C5Boss_9884_7F6E_968F_4ECE = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["释放并登记剧情Boss预置随从"]
local _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["剧情Boss预置暂停来源"]
local ____12_FF0E_5267_60C5Boss_6218_9884_8B66 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情Boss战预警")
local _____53D1_5E03_4E3B_7EBFBoss_6218_524D_63D0_793A = ____12_FF0E_5267_60C5Boss_6218_9884_8B66["发布主线Boss战前提示"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_0["移除单位暂停"]
local _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528 = ____require_result_0["单位是否存在其他暂停占用"]
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动")
local _____542F_52A8Boss_6218_8FD0_884C = ____require_result_2["启动Boss战运行"]
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_3["应用Boss战启动属性配置"]
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_4["记录Boss自动技能启动"]
local _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD = ____require_result_4["是否已登记Boss自动技能"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_6["解除暂停并取消无敌安全"]
local PauseUnit = jass.PauseUnit
local SetUnitInvulnerable = jass.SetUnitInvulnerable
____exports["启动剧情Boss战"] = function(bossUnit, _____53C2_6570)
    if bossUnit == nil or bossUnit == 0 then
        return false
    end
    _____91CA_653E_5E76_767B_8BB0_5267_60C5Boss_9884_7F6E_968F_4ECE(bossUnit)
    local _____5DF2_767B_8BB0_81EA_52A8_6280_80FD = _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD(bossUnit)
    if not _____5DF2_767B_8BB0_81EA_52A8_6280_80FD then
        _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(bossUnit, "Boss战.绑定单位")
    end
    if jass.GetUnitName(bossUnit) == "树魔首领" then
        debugLogForce(
            "树魔首领-主动施法诊断",
            "剧情开战桥接",
            "hid=",
            jass.GetHandleId(bossUnit),
            "typeId=",
            jass.GetUnitTypeId(bossUnit),
            "已登记=",
            _____5DF2_767B_8BB0_81EA_52A8_6280_80FD,
            "登记后=",
            _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD(bossUnit)
        )
    end
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(bossUnit)
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "绑定单位",
        "unit",
        bossUnit
    )
    local ____temp_9 = _____53C2_6570 and _____53C2_6570["触发单位"]
    if ____temp_9 == nil then
        ____temp_9 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    end
    local _____89E6_53D1_5355_4F4D = ____temp_9
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        YDUserDataSetSafe(
            "string",
            "Boss战",
            "触发玩家",
            "unit",
            _____89E6_53D1_5355_4F4D
        )
    end
    _____53D1_5E03_4E3B_7EBFBoss_6218_524D_63D0_793A(bossUnit)
    local _____6682_505C_6765_6E90 = _____53C2_6570 and _____53C2_6570["暂停来源"] or _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90
    local _____5B58_5728_5176_4ED6_6682_505C_6765_6E90 = _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528(bossUnit, _____6682_505C_6765_6E90)
    local _____5DF2_89E3_9664_5B89_5168_5F85_6218 = _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(bossUnit, _____6682_505C_6765_6E90)
    if not _____5DF2_89E3_9664_5B89_5168_5F85_6218 then
        _____79FB_9664_5355_4F4D_6682_505C(bossUnit, _____6682_505C_6765_6E90)
    end
    if not _____5B58_5728_5176_4ED6_6682_505C_6765_6E90 then
        PauseUnit(bossUnit, false)
    end
    SetUnitInvulnerable(bossUnit, false)
    _____542F_52A8Boss_6218_8FD0_884C(bossUnit)
    return true
end
return ____exports
