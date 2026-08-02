local ____lualib = require("lualib_bundle")
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local _____8BBE_7F6E_73A9_5BB6_82F1_96C4_7EC4_63A7_5236_72B6_6001 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["设置玩家英雄组控制状态"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["发布主线节点目标"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_0.safeTriggerAddAction
local safeDestroyTrigger = ____require_result_0.safeDestroyTrigger
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local registerEnterRegionTrigger = ____require_result_1.registerEnterRegionTrigger
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_2["获取玩家英雄单位组"]
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_2["是玩家英雄组单位"]
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_3["按名字反查总单位ID"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_5["创建单位并登记排泄安全"]
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_6["立即移除单位并取消排泄登记"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_7["暂停并设置无敌安全"]
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_7["解除暂停并取消无敌安全"]
local ____require_result_8 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_8.IsUnitAliveBJ
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码")
local _____95EA_7535_6548_679C_4EE3_7801 = ____require_result_9["闪电效果代码"]
local ____require_result_10 = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐")
local _____6CE8_518C_5C01_5370_5B88_536B_6218_533A_57DF_97F3_4E50 = ____require_result_10["注册封印守卫战区域音乐"]
local CreateRegion = jass.CreateRegion
local CreateTrigger = jass.CreateTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local Rect = jass.Rect
local RegionAddRect = jass.RegionAddRect
local RemoveRect = jass.RemoveRect
local RemoveRegion = jass.RemoveRegion
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local IssueImmediateOrder = jass.IssueImmediateOrder
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local AddLightningEx = jass.AddLightningEx
local DestroyLightning = jass.DestroyLightning
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local _____5C01_5370_6838_5FC3_7EAF_5BF9_767D_6765_6E90 = "剧情系统:封印核心纯对白"
local _____5C01_5370_6838_5FC3_5165_53E3_534A_5F84 = 480
____exports["封印核心场景站位表"] = {
    ["A入口"] = {X = 2480.1, Y = -9696.2, ["朝向"] = 178.32},
    ["B玩家"] = {X = 1635.4, Y = -10330.4, ["朝向"] = 134.2},
    ["C里科特"] = {X = 443.5, Y = -9340.2, ["朝向"] = 320.28},
    ["D教皇"] = {X = 1314.7, Y = -9198.5, ["朝向"] = 285.82},
    ["E奥斯特利一世"] = {X = 975.9, Y = -9652.2, ["朝向"] = 314.2}
}
local _____4E03_8272_95EA_7535_6F14_51FA_8868 = {
    {["代码"] = _____95EA_7535_6548_679C_4EE3_7801["红色光束"], X = 2630.6, Y = -8719.3},
    {["代码"] = _____95EA_7535_6548_679C_4EE3_7801["粉色光束"], X = 1148.2, Y = -7998.1},
    {["代码"] = _____95EA_7535_6548_679C_4EE3_7801["黄色光束"], X = -337.3, Y = -8510.6},
    {["代码"] = _____95EA_7535_6548_679C_4EE3_7801["黑色光束"], X = -838.9, Y = -9768.8},
    {["代码"] = _____95EA_7535_6548_679C_4EE3_7801["绿色光束"], X = -377.1, Y = -10973.8},
    {["代码"] = _____95EA_7535_6548_679C_4EE3_7801["金色光束"], X = 1141.3, Y = -11431.3},
    {["代码"] = _____95EA_7535_6548_679C_4EE3_7801["青蓝白光束"], X = 2639.2, Y = -10680}
}
local _____5F53_524D_5C01_5370_6838_5FC3_573A_666F_72B6_6001
local _____5F53_524D_5C01_5370_6838_5FC3_5165_53E3_76D1_542C
local _____5F53_524D_73A9_5BB6_5BF9_767D_7AD9_4F4D
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____5355_4F4D_5B58_6D3B(unit)
    return _____53E5_67C4_6709_6548(unit) and IsUnitAliveBJ(unit)
end
local function _____5B9A_4F4D_5E76_505C_6B62_5355_4F4D(unit, _____7AD9_4F4D)
    if not _____53E5_67C4_6709_6548(unit) then
        return
    end
    SetUnitPosition(unit, _____7AD9_4F4D.X, _____7AD9_4F4D.Y)
    SetUnitFacing(unit, _____7AD9_4F4D["朝向"])
    IssueImmediateOrder(unit, "stop")
end
local function ____on_79FB_52A8_73A9_5BB6_5230_5BF9_767D_7AD9_4F4D()
    if _____5F53_524D_73A9_5BB6_5BF9_767D_7AD9_4F4D == nil then
        return
    end
    _____5B9A_4F4D_5E76_505C_6B62_5355_4F4D(
        GetEnumUnit(),
        _____5F53_524D_73A9_5BB6_5BF9_767D_7AD9_4F4D
    )
end
local function _____79FB_52A8_73A9_5BB6_961F_4F0D_5230_5BF9_767D_7AD9_4F4D()
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if not _____53E5_67C4_6709_6548(_____73A9_5BB6_82F1_96C4_7EC4) then
        return
    end
    _____5F53_524D_73A9_5BB6_5BF9_767D_7AD9_4F4D = ____exports["封印核心场景站位表"]["B玩家"]
    ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_79FB_52A8_73A9_5BB6_5230_5BF9_767D_7AD9_4F4D)
    _____5F53_524D_73A9_5BB6_5BF9_767D_7AD9_4F4D = nil
end
local function _____521B_5EFA_5360_4F4D_5355_4F4D(_____5355_4F4D_540D, _____7AD9_4F4D)
    local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D))
    if not (_____5355_4F4D_7C7B_578BID > 0) then
        return nil
    end
    return _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
        _____5355_4F4D_7C7B_578BID,
        _____7AD9_4F4D.X,
        _____7AD9_4F4D.Y,
        _____7AD9_4F4D["朝向"]
    )
end
local function _____8BFB_53D6_6216_521B_5EFA_573A_666F_5355_4F4D(_____8BFB_53D6_5F15_7528, _____8FD0_884C_65F6_952E, _____5360_4F4D_5355_4F4D_540D, _____7AD9_4F4D)
    local unit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____8BFB_53D6_5F15_7528)
    local _____4E34_65F6_521B_5EFA = false
    if not _____5355_4F4D_5B58_6D3B(unit) then
        unit = _____521B_5EFA_5360_4F4D_5355_4F4D(_____5360_4F4D_5355_4F4D_540D, _____7AD9_4F4D)
        _____4E34_65F6_521B_5EFA = true
    end
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return nil
    end
    _____5B9A_4F4D_5E76_505C_6B62_5355_4F4D(unit, _____7AD9_4F4D)
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(unit, (_____5C01_5370_6838_5FC3_7EAF_5BF9_767D_6765_6E90 .. ":") .. _____8FD0_884C_65F6_952E)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8FD0_884C_65F6_952E, unit)
    return {["运行时键"] = _____8FD0_884C_65F6_952E, ["单位"] = unit, ["临时创建"] = _____4E34_65F6_521B_5EFA}
end
local function _____521B_5EFA_5C01_5370_6838_5FC3_573A_666F_5355_4F4D(_____72B6_6001)
    local _____91CC_79D1_7279 = _____8BFB_53D6_6216_521B_5EFA_573A_666F_5355_4F4D("Boss.里科特", "剧情运行时.封印核心里科特", "里科特", ____exports["封印核心场景站位表"]["C里科特"])
    if _____91CC_79D1_7279 == nil then
        return false
    end
    local ____72B6_6001__5355_4F4D_5217_8868_11 = _____72B6_6001["单位列表"]
    ____72B6_6001__5355_4F4D_5217_8868_11[#____72B6_6001__5355_4F4D_5217_8868_11 + 1] = _____91CC_79D1_7279
    local _____6559_7687 = _____8BFB_53D6_6216_521B_5EFA_573A_666F_5355_4F4D("主线NPC.封印核心教皇", "剧情运行时.封印核心教皇", "精灵审判官", ____exports["封印核心场景站位表"]["D教皇"])
    if _____6559_7687 == nil then
        return false
    end
    local ____72B6_6001__5355_4F4D_5217_8868_12 = _____72B6_6001["单位列表"]
    ____72B6_6001__5355_4F4D_5217_8868_12[#____72B6_6001__5355_4F4D_5217_8868_12 + 1] = _____6559_7687
    local _____5965_65AF_7279_5229_4E00_4E16 = _____8BFB_53D6_6216_521B_5EFA_573A_666F_5355_4F4D("主线NPC.封印核心奥斯特利一世", "剧情运行时.封印核心奥斯特利一世", "血精灵守护者", ____exports["封印核心场景站位表"]["E奥斯特利一世"])
    if _____5965_65AF_7279_5229_4E00_4E16 == nil then
        return false
    end
    local ____72B6_6001__5355_4F4D_5217_8868_13 = _____72B6_6001["单位列表"]
    ____72B6_6001__5355_4F4D_5217_8868_13[#____72B6_6001__5355_4F4D_5217_8868_13 + 1] = _____5965_65AF_7279_5229_4E00_4E16
    return true
end
local function _____521B_5EFA_4E03_8272_95EA_7535(_____72B6_6001)
    if #_____72B6_6001["闪电列表"] > 0 then
        return
    end
    local _____76EE_6807 = ____exports["封印核心场景站位表"]["E奥斯特利一世"]
    do
        local i = 0
        while i < #_____4E03_8272_95EA_7535_6F14_51FA_8868 do
            local _____914D_7F6E = _____4E03_8272_95EA_7535_6F14_51FA_8868[i + 1]
            local _____95EA_7535 = AddLightningEx(
                _____914D_7F6E["代码"],
                false,
                _____914D_7F6E.X,
                _____914D_7F6E.Y,
                1700,
                _____76EE_6807.X,
                _____76EE_6807.Y,
                250.8
            )
            if _____53E5_67C4_6709_6548(_____95EA_7535) then
                local ____72B6_6001__95EA_7535_5217_8868_14 = _____72B6_6001["闪电列表"]
                ____72B6_6001__95EA_7535_5217_8868_14[#____72B6_6001__95EA_7535_5217_8868_14 + 1] = _____95EA_7535
            end
            i = i + 1
        end
    end
end
local function _____6E05_7406_5C01_5370_6838_5FC3_95EA_7535(_____72B6_6001)
    do
        local i = 0
        while i < #_____72B6_6001["闪电列表"] do
            local _____95EA_7535 = _____72B6_6001["闪电列表"][i + 1]
            if _____53E5_67C4_6709_6548(_____95EA_7535) then
                DestroyLightning(_____95EA_7535)
            end
            i = i + 1
        end
    end
    __TS__ArraySetLength(_____72B6_6001["闪电列表"], 0)
end
local function _____6E05_7406_5C01_5370_6838_5FC3_573A_666F_5355_4F4D(_____72B6_6001)
    do
        local i = 0
        while i < #_____72B6_6001["单位列表"] do
            local _____8BB0_5F55 = _____72B6_6001["单位列表"][i + 1]
            _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____8BB0_5F55["单位"], (_____5C01_5370_6838_5FC3_7EAF_5BF9_767D_6765_6E90 .. ":") .. _____8BB0_5F55["运行时键"])
            if _____8BB0_5F55["临时创建"] and _____53E5_67C4_6709_6548(_____8BB0_5F55["单位"]) then
                _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____8BB0_5F55["单位"])
            end
            _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8BB0_5F55["运行时键"])
            i = i + 1
        end
    end
    __TS__ArraySetLength(_____72B6_6001["单位列表"], 0)
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.封印核心玩家")
end
____exports["清理封印核心场景"] = function()
    local _____72B6_6001 = _____5F53_524D_5C01_5370_6838_5FC3_573A_666F_72B6_6001
    if _____72B6_6001 ~= nil and not _____72B6_6001["已清理"] then
        _____72B6_6001["已清理"] = true
        _____6E05_7406_5C01_5370_6838_5FC3_95EA_7535(_____72B6_6001)
        _____6E05_7406_5C01_5370_6838_5FC3_573A_666F_5355_4F4D(_____72B6_6001)
    end
    _____5F53_524D_5C01_5370_6838_5FC3_573A_666F_72B6_6001 = nil
    _____8BBE_7F6E_73A9_5BB6_82F1_96C4_7EC4_63A7_5236_72B6_6001(false, false)
end
____exports["布置封印核心纯对白"] = function()
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 48 then
        return false
    end
    if _____5F53_524D_5C01_5370_6838_5FC3_573A_666F_72B6_6001 ~= nil and not _____5F53_524D_5C01_5370_6838_5FC3_573A_666F_72B6_6001["已清理"] then
        return true
    end
    local _____72B6_6001 = {["单位列表"] = {}, ["闪电列表"] = {}, ["已清理"] = false}
    _____5F53_524D_5C01_5370_6838_5FC3_573A_666F_72B6_6001 = _____72B6_6001
    _____79FB_52A8_73A9_5BB6_961F_4F0D_5230_5BF9_767D_7AD9_4F4D()
    _____8BBE_7F6E_73A9_5BB6_82F1_96C4_7EC4_63A7_5236_72B6_6001(true, false)
    if not _____521B_5EFA_5C01_5370_6838_5FC3_573A_666F_5355_4F4D(_____72B6_6001) then
        ____exports["清理封印核心场景"]()
        return false
    end
    _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807(48)
    return true
end
____exports["创建封印核心七色光束"] = function()
    local _____72B6_6001 = _____5F53_524D_5C01_5370_6838_5FC3_573A_666F_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已清理"] then
        return
    end
    _____521B_5EFA_4E03_8272_95EA_7535(_____72B6_6001)
end
local function _____6E05_7406_5C01_5370_6838_5FC3_5165_53E3_76D1_542C()
    local _____72B6_6001 = _____5F53_524D_5C01_5370_6838_5FC3_5165_53E3_76D1_542C
    if _____72B6_6001 == nil then
        return
    end
    if _____72B6_6001["取消监听"] ~= nil then
        _____72B6_6001["取消监听"](_____72B6_6001)
    end
    if _____53E5_67C4_6709_6548(_____72B6_6001["触发器"]) then
        safeDestroyTrigger(_____72B6_6001["触发器"])
    end
    if _____53E5_67C4_6709_6548(_____72B6_6001["矩形"]) then
        RemoveRect(_____72B6_6001["矩形"])
    end
    if _____53E5_67C4_6709_6548(_____72B6_6001["区域"]) then
        RemoveRegion(_____72B6_6001["区域"])
    end
    _____5F53_524D_5C01_5370_6838_5FC3_5165_53E3_76D1_542C = nil
end
local function _____64AD_653E_5C01_5370_6838_5FC3_7EAF_5BF9_767D(_____89E6_53D1_5355_4F4D)
    local ____require_result_15 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_15["播放主线剧情片段"]
    local _____5DF2_64AD_653E = _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("molten_realm_seal_core_dialogue", {["片段ID"] = "molten_realm_seal_core_dialogue", ["触发配置名"] = "封印核心入口", ["触发单位"] = _____89E6_53D1_5355_4F4D})
    if not _____5DF2_64AD_653E then
        ____exports["清理封印核心场景"]()
    end
end
local function ____on_5C01_5370_6838_5FC3_5165_53E3_89E6_53D1()
    local _____72B6_6001 = _____5F53_524D_5C01_5370_6838_5FC3_5165_53E3_76D1_542C
    if _____72B6_6001 == nil or _____72B6_6001["已触发"] then
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 48 then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if not _____5355_4F4D_5B58_6D3B(_____89E6_53D1_5355_4F4D) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    _____72B6_6001["已触发"] = true
    _____6E05_7406_5C01_5370_6838_5FC3_5165_53E3_76D1_542C()
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.封印核心玩家", _____89E6_53D1_5355_4F4D)
    _____64AD_653E_5C01_5370_6838_5FC3_7EAF_5BF9_767D(_____89E6_53D1_5355_4F4D)
end
____exports["开始监听封印核心入口"] = function()
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 48 or _____5F53_524D_5C01_5370_6838_5FC3_5165_53E3_76D1_542C ~= nil then
        return
    end
    _____6CE8_518C_5C01_5370_5B88_536B_6218_533A_57DF_97F3_4E50()
    local _____533A_57DF = CreateRegion()
    local _____77E9_5F62 = Rect(____exports["封印核心场景站位表"]["A入口"].X - _____5C01_5370_6838_5FC3_5165_53E3_534A_5F84, ____exports["封印核心场景站位表"]["A入口"].Y - _____5C01_5370_6838_5FC3_5165_53E3_534A_5F84, ____exports["封印核心场景站位表"]["A入口"].X + _____5C01_5370_6838_5FC3_5165_53E3_534A_5F84, ____exports["封印核心场景站位表"]["A入口"].Y + _____5C01_5370_6838_5FC3_5165_53E3_534A_5F84)
    local _____89E6_53D1_5668 = CreateTrigger()
    if not _____53E5_67C4_6709_6548(_____533A_57DF) or not _____53E5_67C4_6709_6548(_____77E9_5F62) or not _____53E5_67C4_6709_6548(_____89E6_53D1_5668) then
        if _____53E5_67C4_6709_6548(_____77E9_5F62) then
            RemoveRect(_____77E9_5F62)
        end
        if _____53E5_67C4_6709_6548(_____533A_57DF) then
            RemoveRegion(_____533A_57DF)
        end
        if _____53E5_67C4_6709_6548(_____89E6_53D1_5668) then
            safeDestroyTrigger(_____89E6_53D1_5668)
        end
        return
    end
    RegionAddRect(_____533A_57DF, _____77E9_5F62)
    if safeTriggerAddAction(_____89E6_53D1_5668, ____on_5C01_5370_6838_5FC3_5165_53E3_89E6_53D1) == nil then
        RemoveRect(_____77E9_5F62)
        RemoveRegion(_____533A_57DF)
        safeDestroyTrigger(_____89E6_53D1_5668)
        return
    end
    _____5F53_524D_5C01_5370_6838_5FC3_5165_53E3_76D1_542C = {
        ["区域"] = _____533A_57DF,
        ["矩形"] = _____77E9_5F62,
        ["触发器"] = _____89E6_53D1_5668,
        ["取消监听"] = registerEnterRegionTrigger(_____89E6_53D1_5668, _____533A_57DF, nil),
        ["已触发"] = false
    }
end
____exports["执行布置封印核心纯对白"] = function(______53C2_6570)
    ____exports["布置封印核心纯对白"]()
end
____exports["执行创建封印核心七色光束"] = function(______53C2_6570)
    ____exports["创建封印核心七色光束"]()
end
____exports["执行结束封印核心纯对白"] = function(______53C2_6570)
    ____exports["清理封印核心场景"]()
end
____exports["执行清理封印核心入口"] = function(______53C2_6570)
    _____6E05_7406_5C01_5370_6838_5FC3_5165_53E3_76D1_542C()
    ____exports["清理封印核心场景"]()
end
____exports["封印核心场景剧情动作注册表"] = {["第三章_布置封印核心纯对白"] = ____exports["执行布置封印核心纯对白"], ["第三章_创建封印核心七色光束"] = ____exports["执行创建封印核心七色光束"], ["第三章_结束封印核心纯对白"] = ____exports["执行结束封印核心纯对白"], ["第三章_清理封印核心入口"] = ____exports["执行清理封印核心入口"]}
return ____exports
