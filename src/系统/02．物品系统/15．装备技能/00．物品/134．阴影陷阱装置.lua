--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____5355_4F4D_662F_82F1_96C4 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位是英雄"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["播放单位特效"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.09．主动陷阱模板")
local _____521B_5EFA_4E3B_52A8_9677_9631 = ____require_result_1["创建主动陷阱"]
local _____9ED8_8BA4_4E3B_52A8_9677_9631_6A21_578B = ____require_result_1["默认主动陷阱模型"]
local jass = require("jass.common")
local GetItemCharges = jass.GetItemCharges
local SetItemCharges = jass.SetItemCharges
local GetHandleId = jass.GetHandleId
local _____9634_5F71_9677_9631_89E6_53D1_7279_6548 = "Common\\Effect\\Form\\MagicCircle\\ShadowTrapRune.mdx"
local _____7EA0_7F20_6839_987B_76EE_6807_7279_6548 = "Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl"
local _____5DF2_521D_59CB_5316_6B21_6570_7269_54C1_8868 = {}
local function _____53D6_7269_54C1_53E5_67C4ID(item)
    if item == nil or item == 0 then
        return 0
    end
    return GetHandleId(item) or 0
end
local function _____521D_59CB_5316_9634_5F71_9677_9631_6B21_6570(item)
    local id = _____53D6_7269_54C1_53E5_67C4ID(item)
    if id == 0 or _____5DF2_521D_59CB_5316_6B21_6570_7269_54C1_8868[id] == true then
        return
    end
    _____5DF2_521D_59CB_5316_6B21_6570_7269_54C1_8868[id] = true
    if GetItemCharges(item) <= 0 then
        SetItemCharges(item, _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["阴影陷阱装置"]["最大次数"])
    end
end
local function ____on_9634_5F71_9677_9631_88C5_7F6E_62FE_53D6(unit, item)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(item, _____7269_54C1_4F7F_7528_88C5_5907ID["阴影陷阱装置"]) then
        return
    end
    _____521D_59CB_5316_9634_5F71_9677_9631_6B21_6570(item)
end
local function ____on_9634_5F71_9677_9631_89E6_53D1(target)
    _____64AD_653E_5355_4F4D_7279_6548(_____7EA0_7F20_6839_987B_76EE_6807_7279_6548, target, "origin", _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["阴影陷阱装置"]["控制持续秒数"])
end
local function _____6D88_8017_9634_5F71_9677_9631_6B21_6570(item)
    _____521D_59CB_5316_9634_5F71_9677_9631_6B21_6570(item)
    local charges = GetItemCharges(item)
    if not (charges > 0) then
        return false
    end
    SetItemCharges(item, charges - 1)
    return true
end
local function _____9634_5F71_9677_9631_8FD8_6709_6B21_6570(item)
    _____521D_59CB_5316_9634_5F71_9677_9631_6B21_6570(item)
    return GetItemCharges(item) > 0
end
____exports["处理阴影陷阱装置使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["阴影陷阱装置"]) then
        return
    end
    local caster = ctx["施法单位"]
    if not _____5355_4F4D_662F_82F1_96C4(caster) then
        return
    end
    if not _____9634_5F71_9677_9631_8FD8_6709_6B21_6570(ctx["物品"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["阴影陷阱装置"]
    local x = ctx["目标X"] ~= 0 and ctx["目标X"] or _____53D6_5355_4F4DX(caster)
    local y = ctx["目标Y"] ~= 0 and ctx["目标Y"] or _____53D6_5355_4F4DY(caster)
    local trap = _____521B_5EFA_4E3B_52A8_9677_9631({
        ["名称"] = "阴影陷阱装置",
        ["施法者"] = caster,
        X = x,
        Y = y,
        ["持续秒数"] = cfg["持续秒数"],
        ["触发半径"] = cfg["触发半径"],
        ["模型路径"] = _____9ED8_8BA4_4E3B_52A8_9677_9631_6A21_578B,
        ["缩放"] = cfg["缩放"],
        ["触发后销毁"] = true,
        ["只触发敌人"] = true,
        ["控制类型"] = "roots",
        ["控制持续秒数"] = cfg["控制持续秒数"],
        ["触发特效路径"] = _____9634_5F71_9677_9631_89E6_53D1_7279_6548,
        ["on触发"] = ____on_9634_5F71_9677_9631_89E6_53D1
    })
    if trap == nil then
        return
    end
    _____6D88_8017_9634_5F71_9677_9631_6B21_6570(ctx["物品"])
end
onItemPickup(____on_9634_5F71_9677_9631_88C5_7F6E_62FE_53D6)
return ____exports
