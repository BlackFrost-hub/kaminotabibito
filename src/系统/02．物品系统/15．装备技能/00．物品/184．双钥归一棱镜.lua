--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____14_FF0E_5355_4F4D_65F6_9650_6807_8BB0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.14．单位时限标记")
local _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0 = ____14_FF0E_5355_4F4D_65F6_9650_6807_8BB0["创建单位时限标记"]
local ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.24．句柄上下文托管")
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1["创建句柄上下文托管器"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却就绪"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local _____53D6_653B_51FB_529B = ____07_FF0E_88C5_5907_8F85_52A9["取攻击力"]
local _____53D6_8303_56F4_654C_4EBA = ____07_FF0E_88C5_5907_8F85_52A9["取范围敌人"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____5F00_59CB_901A_7528_62A4_76FE = ____07_FF0E_88C5_5907_8F85_52A9["开始通用护盾"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local _____76D1_542C_88C5_5907_4E22_5F03_6E05_7406 = ____07_FF0E_88C5_5907_8F85_52A9["监听装备丢弃清理"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_1.createUnitEffect
local destroyUnitEffect = ____require_result_1.destroyUnitEffect
local _____94A5_5319_6301_7EED_79D2 = 6
local _____6B66_9B42_94A5_7279_6548_8DEF_5F84 = "Common\\Effect\\Form\\Aura\\EquipmentMartialSoulKeyAura.mdx"
local _____7075_8BC6_94A5_7279_6548_8DEF_5F84 = "Common\\Effect\\Form\\Aura\\EquipmentSpiritKeyAura.mdx"
local _____6B66_9B42_94A5_7279_6548_952E = "双钥归一-武魂钥特效"
local _____7075_8BC6_94A5_7279_6548_952E = "双钥归一-灵识钥特效"
local _____6B66_9B42_94A5 = _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0("双钥归一-武魂钥")
local _____7075_8BC6_94A5 = _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0("双钥归一-灵识钥")
local _____53CC_94A5_8868_73B0 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("双钥归一棱镜-钥匙表现")
local function _____83B7_53D6_53CC_94A5_8868_73B0_72B6_6001(unit)
    local state = _____53CC_94A5_8868_73B0["读取"](unit)
    if state ~= nil and state["单位"] == unit then
        return state
    end
    state = {
        ["单位"] = unit,
        ["武魂钥特效存在"] = false,
        ["灵识钥特效存在"] = false,
        ["武魂钥到期任务ID"] = 0,
        ["灵识钥到期任务ID"] = 0
    }
    _____53CC_94A5_8868_73B0["写入"](unit, state)
    return state
end
local function _____6E05_7406_7A7A_53CC_94A5_8868_73B0_72B6_6001(unit, state)
    if state["武魂钥特效存在"] or state["灵识钥特效存在"] then
        return
    end
    if state["武魂钥到期任务ID"] > 0 or state["灵识钥到期任务ID"] > 0 then
        return
    end
    _____53CC_94A5_8868_73B0["清空"](unit)
end
local function _____9500_6BC1_6B66_9B42_94A5_8868_73B0(unit)
    local state = _____53CC_94A5_8868_73B0["读取"](unit)
    if state ~= nil and state["单位"] == unit then
        if state["武魂钥到期任务ID"] > 0 then
            removeDelayedCallback(state["武魂钥到期任务ID"])
        end
        state["武魂钥到期任务ID"] = 0
        state["武魂钥特效存在"] = false
        _____6E05_7406_7A7A_53CC_94A5_8868_73B0_72B6_6001(unit, state)
    end
    destroyUnitEffect(unit, _____6B66_9B42_94A5_7279_6548_952E)
end
local function _____9500_6BC1_7075_8BC6_94A5_8868_73B0(unit)
    local state = _____53CC_94A5_8868_73B0["读取"](unit)
    if state ~= nil and state["单位"] == unit then
        if state["灵识钥到期任务ID"] > 0 then
            removeDelayedCallback(state["灵识钥到期任务ID"])
        end
        state["灵识钥到期任务ID"] = 0
        state["灵识钥特效存在"] = false
        _____6E05_7406_7A7A_53CC_94A5_8868_73B0_72B6_6001(unit, state)
    end
    destroyUnitEffect(unit, _____7075_8BC6_94A5_7279_6548_952E)
end
local function ____on_6B66_9B42_94A5_5230_671F(variable)
    local unit = variable
    local state = _____53CC_94A5_8868_73B0["读取"](unit)
    if state == nil or state["单位"] ~= unit then
        return
    end
    state["武魂钥到期任务ID"] = 0
    _____6B66_9B42_94A5["清空"](_____6B66_9B42_94A5, unit)
    _____9500_6BC1_6B66_9B42_94A5_8868_73B0(unit)
end
local function ____on_7075_8BC6_94A5_5230_671F(variable)
    local unit = variable
    local state = _____53CC_94A5_8868_73B0["读取"](unit)
    if state == nil or state["单位"] ~= unit then
        return
    end
    state["灵识钥到期任务ID"] = 0
    _____7075_8BC6_94A5["清空"](_____7075_8BC6_94A5, unit)
    _____9500_6BC1_7075_8BC6_94A5_8868_73B0(unit)
end
local function _____6807_8BB0_6B66_9B42_94A5(unit)
    local state = _____83B7_53D6_53CC_94A5_8868_73B0_72B6_6001(unit)
    _____6B66_9B42_94A5["标记"](_____6B66_9B42_94A5, unit, _____94A5_5319_6301_7EED_79D2)
    if not state["武魂钥特效存在"] then
        state["武魂钥特效存在"] = createUnitEffect(
            unit,
            "origin",
            _____6B66_9B42_94A5_7279_6548_8DEF_5F84,
            nil,
            _____6B66_9B42_94A5_7279_6548_952E
        ) ~= nil
    end
    if state["武魂钥到期任务ID"] > 0 then
        removeDelayedCallback(state["武魂钥到期任务ID"])
    end
    state["武魂钥到期任务ID"] = addDelayedCallback(_____94A5_5319_6301_7EED_79D2 * 1000, ____on_6B66_9B42_94A5_5230_671F, unit)
end
local function _____6807_8BB0_7075_8BC6_94A5(unit)
    local state = _____83B7_53D6_53CC_94A5_8868_73B0_72B6_6001(unit)
    _____7075_8BC6_94A5["标记"](_____7075_8BC6_94A5, unit, _____94A5_5319_6301_7EED_79D2)
    if not state["灵识钥特效存在"] then
        state["灵识钥特效存在"] = createUnitEffect(
            unit,
            "origin",
            _____7075_8BC6_94A5_7279_6548_8DEF_5F84,
            nil,
            _____7075_8BC6_94A5_7279_6548_952E
        ) ~= nil
    end
    if state["灵识钥到期任务ID"] > 0 then
        removeDelayedCallback(state["灵识钥到期任务ID"])
    end
    state["灵识钥到期任务ID"] = addDelayedCallback(_____94A5_5319_6301_7EED_79D2 * 1000, ____on_7075_8BC6_94A5_5230_671F, unit)
end
local function _____6E05_7406_53CC_94A5(unit)
    _____6B66_9B42_94A5["清空"](_____6B66_9B42_94A5, unit)
    _____7075_8BC6_94A5["清空"](_____7075_8BC6_94A5, unit)
    _____9500_6BC1_6B66_9B42_94A5_8868_73B0(unit)
    _____9500_6BC1_7075_8BC6_94A5_8868_73B0(unit)
end
local function _____5C1D_8BD5_53CC_94A5_5171_9E23(unit, target)
    if not _____6B66_9B42_94A5["存在"](_____6B66_9B42_94A5, unit) or not _____7075_8BC6_94A5["存在"](_____7075_8BC6_94A5, unit) then
        return
    end
    local key = _____53D6_88C5_5907_51B7_5374_952E(unit, "双钥共鸣")
    if not _____88C5_5907_51B7_5374_5C31_7EEA(key) then
        return
    end
    _____6B66_9B42_94A5["消耗"](_____6B66_9B42_94A5, unit)
    _____7075_8BC6_94A5["消耗"](_____7075_8BC6_94A5, unit)
    _____9500_6BC1_6B66_9B42_94A5_8868_73B0(unit)
    _____9500_6BC1_7075_8BC6_94A5_8868_73B0(unit)
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(key, 6, unit, _____56DBBoss_6218_5229_54C1_88C5_5907_540D["双钥归一棱镜"])
    local units = _____53D6_8303_56F4_654C_4EBA(unit, target, 260)
    do
        local i = 0
        while i < #units do
            _____9020_6210_88C5_5907_4F24_5BB3(
                unit,
                units[i + 1],
                _____53D6_653B_51FB_529B(unit) * 0.55 + 180,
                _____88C5_5907_4F24_5BB3_7C7B_578B["魔法"],
                false,
                nil,
                {["装备技能类型"] = "装备被动", ["标签"] = "双钥共鸣", ["伤害形态"] = "AOE"}
            )
            i = i + 1
        end
    end
    _____5F00_59CB_901A_7528_62A4_76FE(
        unit,
        unit,
        _____53D6_6700_5927_751F_547D(unit) * 0.06,
        4,
        "双钥共鸣"
    )
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["誓盾"],
        unit,
        "origin",
        1,
        0.28
    )
end
local function ____on_6B66_9B42_94A5_89E6_53D1(e)
    _____6807_8BB0_6B66_9B42_94A5(e["持有者"])
    _____5C1D_8BD5_53CC_94A5_5171_9E23(e["持有者"], e["目标"])
end
local function _____975E_88C5_5907_6280_80FD_4F24_5BB3(e)
    local ____opt_2 = e["伤害快照"]
    if ____opt_2 ~= nil then
        ____opt_2 = ____opt_2.isEquipmentSkillDamage
    end
    return ____opt_2 ~= true
end
local function ____on_7075_8BC6_94A5_89E6_53D1(e)
    _____6807_8BB0_7075_8BC6_94A5(e["持有者"])
    _____5C1D_8BD5_53CC_94A5_5171_9E23(e["持有者"], e["目标"])
end
local function ____on_53CC_94A5_5F52_4E00_68F1_955C_4E22_5F03(unit)
    _____6E05_7406_53CC_94A5(unit)
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({["名称"] = "双钥归一-武魂钥", ["装备名"] = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["双钥归一棱镜"], ["伤害过滤"] = "纯普攻", ["on触发"] = ____on_6B66_9B42_94A5_89E6_53D1})
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "双钥归一-灵识钥",
    ["装备名"] = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["双钥归一棱镜"],
    ["伤害过滤"] = "技能",
    ["自定义过滤"] = _____975E_88C5_5907_6280_80FD_4F24_5BB3,
    ["on触发"] = ____on_7075_8BC6_94A5_89E6_53D1
})
_____76D1_542C_88C5_5907_4E22_5F03_6E05_7406(_____56DBBoss_6218_5229_54C1_88C5_5907_540D["双钥归一棱镜"], ____on_53CC_94A5_5F52_4E00_68F1_955C_4E22_5F03)
return ____exports
