--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
local _____7ED9_73A9_5BB6_7EC4_6DFB_52A0_591A_4E2A_533A_57DF_89C6_91CE = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["给玩家组添加多个区域视野"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_0.EC_CreateEffect
local ____require_result_1 = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐")
local _____542F_7528_7B2C_4E8C_7AE0_7CBE_7075_57CE_80CC_666F_97F3_4E50 = ____require_result_1["启用第二章精灵城背景音乐"]
local _____542F_7528_7B2C_4E8C_7AE0_7CBE_7075_57CE_738B_5BAB_80CC_666F_97F3_4E50 = ____require_result_1["启用第二章精灵城王宫背景音乐"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local ____require_result_3 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_3.safeTriggerAddAction
local safeDestroyTrigger = ____require_result_3.safeDestroyTrigger
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local registerEnterRegionTrigger = ____require_result_4.registerEnterRegionTrigger
local ____require_result_5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_5["是玩家英雄组单位"]
local ____require_result_6 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____52A8_6001_77E9_5F62_533A_57DF_914D_7F6E_8868 = ____require_result_6["动态矩形区域配置表"]
local _____6CE8_518C_52A8_6001_77E9_5F62_533A_57DF = ____require_result_6["注册动态矩形区域"]
local _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF = ____require_result_6["注销动态矩形区域"]
do
    local ____20_FF0E_963F_5C14_6587_5F15_5BFC = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.20．阿尔文引导")
    ____exports["阿尔文接引剧情片段"] = ____20_FF0E_963F_5C14_6587_5F15_5BFC["阿尔文接引剧情片段"]
end
local CreateRegion = jass.CreateRegion
local CreateTrigger = jass.CreateTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local RegionAddRect = jass.RegionAddRect
local RemoveRegion = jass.RemoveRegion
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____738B_57CE_95E8_7981_77E9_5F62_952E = "剧情.王城门禁入口"
local _____738B_57CE_95E8_7981_76D1_542C
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____6E05_7406_738B_57CE_95E8_7981_77E9_5F62_76D1_542C()
    local _____72B6_6001 = _____738B_57CE_95E8_7981_76D1_542C
    if _____72B6_6001 == nil then
        return
    end
    if _____72B6_6001["取消监听"] ~= nil then
        _____72B6_6001["取消监听"](_____72B6_6001)
    end
    if _____53E5_67C4_6709_6548(_____72B6_6001["触发器"]) then
        safeDestroyTrigger(_____72B6_6001["触发器"])
    end
    if _____53E5_67C4_6709_6548(_____72B6_6001["区域"]) then
        RemoveRegion(_____72B6_6001["区域"])
    end
    _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____738B_57CE_95E8_7981_77E9_5F62_952E)
    _____738B_57CE_95E8_7981_76D1_542C = nil
end
local function _____64AD_653E_738B_57CE_95E8_7981_5267_60C5(_____89E6_53D1_5355_4F4D)
    local ____require_result_7 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_7["播放主线剧情片段"]
    local _____5DF2_64AD_653E = _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("elven_city_gate_open", {["片段ID"] = "elven_city_gate_open", ["触发配置名"] = "精灵城门禁矩形入口", ["触发单位"] = _____89E6_53D1_5355_4F4D})
    if not _____5DF2_64AD_653E then
        _____6E05_7406_738B_57CE_95E8_7981_77E9_5F62_76D1_542C()
    end
end
local function ____on_738B_57CE_95E8_7981_77E9_5F62_8FDB_5165()
    local _____72B6_6001 = _____738B_57CE_95E8_7981_76D1_542C
    if _____72B6_6001 == nil or _____72B6_6001["已触发"] or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 21 then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if not _____53E5_67C4_6709_6548(_____89E6_53D1_5355_4F4D) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    _____72B6_6001["已触发"] = true
    _____64AD_653E_738B_57CE_95E8_7981_5267_60C5(_____89E6_53D1_5355_4F4D)
end
local function _____6CE8_518C_738B_57CE_95E8_7981_77E9_5F62_76D1_542C()
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 21 or _____738B_57CE_95E8_7981_76D1_542C ~= nil then
        return
    end
    local _____533A_57DF = CreateRegion()
    local _____77E9_5F62 = _____6CE8_518C_52A8_6001_77E9_5F62_533A_57DF(_____52A8_6001_77E9_5F62_533A_57DF_914D_7F6E_8868[_____738B_57CE_95E8_7981_77E9_5F62_952E])
    local _____89E6_53D1_5668 = CreateTrigger()
    if not _____53E5_67C4_6709_6548(_____533A_57DF) or not _____53E5_67C4_6709_6548(_____77E9_5F62) or not _____53E5_67C4_6709_6548(_____89E6_53D1_5668) then
        if _____53E5_67C4_6709_6548(_____533A_57DF) then
            RemoveRegion(_____533A_57DF)
        end
        if _____53E5_67C4_6709_6548(_____89E6_53D1_5668) then
            safeDestroyTrigger(_____89E6_53D1_5668)
        end
        _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____738B_57CE_95E8_7981_77E9_5F62_952E)
        return
    end
    RegionAddRect(_____533A_57DF, _____77E9_5F62)
    if safeTriggerAddAction(_____89E6_53D1_5668, ____on_738B_57CE_95E8_7981_77E9_5F62_8FDB_5165) == nil then
        RemoveRegion(_____533A_57DF)
        _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____738B_57CE_95E8_7981_77E9_5F62_952E)
        safeDestroyTrigger(_____89E6_53D1_5668)
        return
    end
    _____738B_57CE_95E8_7981_76D1_542C = {
        ["区域"] = _____533A_57DF,
        ["矩形"] = _____77E9_5F62,
        ["触发器"] = _____89E6_53D1_5668,
        ["取消监听"] = registerEnterRegionTrigger(_____89E6_53D1_5668, _____533A_57DF, nil),
        ["已触发"] = false
    }
end
____exports["执行阿尔文接引"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
    local _____963F_5C14_6587 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.阿尔文")
    if _____963F_5C14_6587 == nil or _____963F_5C14_6587 == 0 then
        return
    end
    EC_CreateEffect(
        "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
        GetUnitX(_____963F_5C14_6587),
        GetUnitY(_____963F_5C14_6587),
        0,
        270,
        2,
        1,
        1.5
    )
end
____exports["执行启用第二章精灵城背景音乐"] = function()
    local _____8C03_8BD5_6A21_5757 = "剧情20-21-BGM"
    debugLogForce(_____8C03_8BD5_6A21_5757, "进入 20→21 BGM 动作")
    local _____7CBE_7075_57CE_7ED3_679C = _____542F_7528_7B2C_4E8C_7AE0_7CBE_7075_57CE_80CC_666F_97F3_4E50()
    debugLogForce(_____8C03_8BD5_6A21_5757, "精灵城背景音乐挂载结果", _____7CBE_7075_57CE_7ED3_679C)
    local _____738B_5BAB_7ED3_679C = _____542F_7528_7B2C_4E8C_7AE0_7CBE_7075_57CE_738B_5BAB_80CC_666F_97F3_4E50()
    debugLogForce(_____8C03_8BD5_6A21_5757, "王宫背景音乐挂载结果", _____738B_5BAB_7ED3_679C)
    _____6CE8_518C_738B_57CE_95E8_7981_77E9_5F62_76D1_542C()
    debugLogForce(_____8C03_8BD5_6A21_5757, "王城门禁矩形监听已注册")
end
____exports["执行清理王城门禁矩形监听"] = function()
    _____6E05_7406_738B_57CE_95E8_7981_77E9_5F62_76D1_542C()
end
____exports["执行阿尔文对话开启视野"] = function()
    _____7ED9_73A9_5BB6_7EC4_6DFB_52A0_591A_4E2A_533A_57DF_89C6_91CE("gg_rct______________026")
end
____exports["阿尔文引导剧情动作注册表"] = {["JLC精灵城_阿尔文接引"] = ____exports["执行阿尔文接引"], ["第二章_启用精灵城背景音乐"] = ____exports["执行启用第二章精灵城背景音乐"], ["第二章_阿尔文对话开启视野"] = ____exports["执行阿尔文对话开启视野"], ["第二章_清理王城门禁矩形监听"] = ____exports["执行清理王城门禁矩形监听"]}
return ____exports
