--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF = require("系统.11．剧情系统.02．支线任务.04．莫尔特斯.00．常量")
local _____8D6B_514B_63D0_5C14_5F52_4F4DX = ____00_FF0E_5E38_91CF["赫克提尔归位X"]
local _____8D6B_514B_63D0_5C14_5F52_4F4DY = ____00_FF0E_5E38_91CF["赫克提尔归位Y"]
local _____8D6B_514B_63D0_5C14_5F52_4F4D_671D_5411 = ____00_FF0E_5E38_91CF["赫克提尔归位朝向"]
local _____8D6B_514B_63D0_5C14_8BED_4E49_5F15_7528 = ____00_FF0E_5E38_91CF["赫克提尔语义引用"]
local _____83AB_5C14_7279_65AF_89E3_9501_5267_60C5_8FDB_5EA6 = ____00_FF0E_5E38_91CF["莫尔特斯解锁剧情进度"]
local ____02_FF0E_5165_53E3_914D_7F6E = require("系统.11．剧情系统.02．支线任务.04．莫尔特斯.02．入口配置")
local _____83AB_5C14_7279_65AFNPC_914D_7F6E_5217_8868 = ____02_FF0E_5165_53E3_914D_7F6E["莫尔特斯NPC配置列表"]
local _____83AB_5C14_7279_65AF_4EFB_52A1_914D_7F6E_5217_8868 = ____02_FF0E_5165_53E3_914D_7F6E["莫尔特斯任务配置列表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____require_result_1["读取剧情进度"]
local _____6CE8_518C_5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C = ____require_result_1["注册剧情进度变更监听"]
local ____require_result_2 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____require_result_2["读取语义单位引用"]
local ____require_result_3 = require("系统.09．表现系统.02．对话框系统.09．NPC头顶与气泡特效")
local tryAttachQuestMarkerForConfigNpc = ____require_result_3.tryAttachQuestMarkerForConfigNpc
local ____require_result_4 = require("系统.11．剧情系统.02．支线任务.00A．动态支线注册")
local _____6CE8_518C_52A8_6001_652F_7EBF_914D_7F6E = ____require_result_4["注册动态支线配置"]
local IssueImmediateOrder = jass.IssueImmediateOrder
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local _____52A8_6001_89E3_9501_5DF2_521D_59CB_5316 = false
local _____83AB_5C14_7279_65AF_4EFB_52A1_5DF2_89E3_9501 = false
local _____5F52_4F4D_91CD_8BD5_5DF2_5B89_6392 = false
local function _____53E5_67C4_6709_6548(_____53E5_67C4)
    return _____53E5_67C4 ~= nil and _____53E5_67C4 ~= 0
end
local function _____542F_7528_83AB_5C14_7279_65AFNPC_914D_7F6E()
    local ____NPC_914D_7F6E = _____83AB_5C14_7279_65AFNPC_914D_7F6E_5217_8868[1]
    local _____4EFB_52A1_914D_7F6E = _____83AB_5C14_7279_65AF_4EFB_52A1_914D_7F6E_5217_8868[1]
    if not _____6CE8_518C_52A8_6001_652F_7EBF_914D_7F6E(_____4EFB_52A1_914D_7F6E, ____NPC_914D_7F6E) then
        return nil
    end
    if ____NPC_914D_7F6E ~= nil then
        ____NPC_914D_7F6E["启用"] = true
    end
    return ____NPC_914D_7F6E
end
local function _____5C1D_8BD5_89E3_9501_5E76_5F52_4F4D_8D6B_514B_63D0_5C14()
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() < _____83AB_5C14_7279_65AF_89E3_9501_5267_60C5_8FDB_5EA6 then
        return false
    end
    local ____NPC_914D_7F6E = _____542F_7528_83AB_5C14_7279_65AFNPC_914D_7F6E()
    local _____8D6B_514B_63D0_5C14 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____8D6B_514B_63D0_5C14_8BED_4E49_5F15_7528)
    if ____NPC_914D_7F6E == nil or not _____53E5_67C4_6709_6548(_____8D6B_514B_63D0_5C14) then
        return false
    end
    IssueImmediateOrder(_____8D6B_514B_63D0_5C14, "stop")
    SetUnitPosition(_____8D6B_514B_63D0_5C14, _____8D6B_514B_63D0_5C14_5F52_4F4DX, _____8D6B_514B_63D0_5C14_5F52_4F4DY)
    SetUnitFacing(_____8D6B_514B_63D0_5C14, _____8D6B_514B_63D0_5C14_5F52_4F4D_671D_5411)
    tryAttachQuestMarkerForConfigNpc(_____8D6B_514B_63D0_5C14, ____NPC_914D_7F6E)
    _____83AB_5C14_7279_65AF_4EFB_52A1_5DF2_89E3_9501 = true
    return true
end
local function ____on_8D6B_514B_63D0_5C14_5F52_4F4D_91CD_8BD5()
    _____5F52_4F4D_91CD_8BD5_5DF2_5B89_6392 = false
    _____5C1D_8BD5_89E3_9501_5E76_5F52_4F4D_8D6B_514B_63D0_5C14()
end
local function _____5B89_6392_8D6B_514B_63D0_5C14_5F52_4F4D_91CD_8BD5()
    if _____5F52_4F4D_91CD_8BD5_5DF2_5B89_6392 or _____83AB_5C14_7279_65AF_4EFB_52A1_5DF2_89E3_9501 then
        return
    end
    _____5F52_4F4D_91CD_8BD5_5DF2_5B89_6392 = true
    addDelayedCallback(1100, ____on_8D6B_514B_63D0_5C14_5F52_4F4D_91CD_8BD5)
end
local function ____on_5267_60C5_8FDB_5EA6_53D8_66F4_89E3_9501_83AB_5C14_7279_65AF(_____65B0_8FDB_5EA6, ______65E7_8FDB_5EA6)
    if _____65B0_8FDB_5EA6 < _____83AB_5C14_7279_65AF_89E3_9501_5267_60C5_8FDB_5EA6 or _____83AB_5C14_7279_65AF_4EFB_52A1_5DF2_89E3_9501 then
        return
    end
    if not _____5C1D_8BD5_89E3_9501_5E76_5F52_4F4D_8D6B_514B_63D0_5C14() then
        _____5B89_6392_8D6B_514B_63D0_5C14_5F52_4F4D_91CD_8BD5()
    end
end
____exports["初始化莫尔特斯动态解锁"] = function()
    if _____52A8_6001_89E3_9501_5DF2_521D_59CB_5316 then
        return
    end
    _____52A8_6001_89E3_9501_5DF2_521D_59CB_5316 = true
    _____6CE8_518C_5267_60C5_8FDB_5EA6_53D8_66F4_76D1_542C(____on_5267_60C5_8FDB_5EA6_53D8_66F4_89E3_9501_83AB_5C14_7279_65AF)
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() >= _____83AB_5C14_7279_65AF_89E3_9501_5267_60C5_8FDB_5EA6 then
        _____542F_7528_83AB_5C14_7279_65AFNPC_914D_7F6E()
        _____5B89_6392_8D6B_514B_63D0_5C14_5F52_4F4D_91CD_8BD5()
    end
end
return ____exports
