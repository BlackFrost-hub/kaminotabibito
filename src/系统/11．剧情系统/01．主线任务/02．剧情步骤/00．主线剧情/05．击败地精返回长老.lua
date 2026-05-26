local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668["播放主线剧情片段"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterUnitInRangeSimple = ____require_result_1.TriggerRegisterUnitInRangeSimple
local ____require_result_2 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitFacingToFaceUnitTimed = ____require_result_2.SetUnitFacingToFaceUnitTimed
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____require_result_3.YDWEAngleBetweenUnitsSafe
local CreateTrigger = jass.CreateTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local IsUnitInGroup = jass.IsUnitInGroup
local IssueImmediateOrder = jass.IssueImmediateOrder
local SetUnitFacingTimed = jass.SetUnitFacingTimed
local TriggerAddAction = jass.TriggerAddAction
local _____5DF2_521D_59CB_5316_8FDB_5EA605_6838_5FC3 = false
local function _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    return _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 and IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_7EC4)
end
local function ____on_51FB_8D25_5730_7CBE_8FD4_56DE_957F_8001_89E6_53D1()
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if not _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(_____89E6_53D1_5355_4F4D) then
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 4 then
        return
    end
    local _____7247_6BB5ID = "jlc_goblin_defeated_return_elder"
    _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587({["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = "击败地精返回长老核心", ["触发单位"] = _____89E6_53D1_5355_4F4D})
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = "击败地精返回长老核心", ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
____exports["执行击败地精回村前置"] = function(_____53C2_6570)
    if type(_____53C2_6570["设置剧情进度"]) == "number" then
        _____5199_5165_5267_60C5_8FDB_5EA6(_____53C2_6570["设置剧情进度"])
    end
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    local _____957F_8001_5355_4F4D = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        IssueImmediateOrder(_____89E6_53D1_5355_4F4D, "stop")
    end
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and _____957F_8001_5355_4F4D ~= nil and _____957F_8001_5355_4F4D ~= 0 then
        SetUnitFacingToFaceUnitTimed(
            _____89E6_53D1_5355_4F4D,
            _____957F_8001_5355_4F4D,
            __TS__Number(_____53C2_6570["触发单位转向耗时"]) or 1
        )
        SetUnitFacingTimed(
            _____957F_8001_5355_4F4D,
            YDWEAngleBetweenUnitsSafe(_____957F_8001_5355_4F4D, _____89E6_53D1_5355_4F4D),
            __TS__Number(_____53C2_6570["长老转向耗时"]) or 1
        )
    end
end
____exports["击败地精返回长老剧情动作注册表"] = {["JLC精灵村_击败地精回村前置"] = ____exports["执行击败地精回村前置"]}
____exports["初始化进度05_击败地精返回长老核心"] = function()
    if _____5DF2_521D_59CB_5316_8FDB_5EA605_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_8FDB_5EA605_6838_5FC3 = true
    local _____957F_8001_5355_4F4D = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
    if _____957F_8001_5355_4F4D == nil or _____957F_8001_5355_4F4D == 0 then
        return
    end
    local trigger = CreateTrigger()
    TriggerRegisterUnitInRangeSimple(trigger, 800, _____957F_8001_5355_4F4D)
    TriggerAddAction(trigger, ____on_51FB_8D25_5730_7CBE_8FD4_56DE_957F_8001_89E6_53D1)
end
return ____exports
