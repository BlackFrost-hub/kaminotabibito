local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.00．配置")
local _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["坂井悠二技能配置"]
local ____05_FF0E_5742_4E95_60A0_4E8C = require("系统.05．Buff系统.03．Buff表.02．英雄.05．坂井悠二")
local _____5742_4E95_60A0_4E8CBuffID = ____05_FF0E_5742_4E95_60A0_4E8C["坂井悠二BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_0["施加眩晕"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成批量AOE技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_3["获取范围敌军"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local addPeriodicCallback = ____require_result_5.addPeriodicCallback
local removePeriodicCallback = ____require_result_5.removePeriodicCallback
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
local GetHandleId = jass.GetHandleId
local CreateUnit = jass.CreateUnit
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitScale = jass.SetUnitScale
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local UnitApplyTimedLife = jass.UnitApplyTimedLife
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local _____914D_7F6E = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.Q
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E["单位类型ID"]
local ____Q_6280_80FDID_5B57_7B26_4E32 = _____914D_7F6E["技能ID"]
local _____4E0A_4E0B_6587_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____83B7_53D6Q_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return nil
    end
    return _____4E0A_4E0B_6587_8868[id]
end
local function _____83B7_53D6_6216_521B_5EFAQ_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return nil
    end
    local current = _____4E0A_4E0B_6587_8868[id]
    if current ~= nil then
        return current
    end
    local created = {
        ["施法者"] = unit,
        ["已启动"] = false,
        ["周期回调ID"] = 0,
        ["已完成段数"] = 0,
        ["起点X"] = 0,
        ["起点Y"] = 0,
        ["方向角度"] = 0,
        ["伤害攻击力快照"] = 0
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function _____6E05_7406Q_4E0A_4E0B_6587(context)
    if context["周期回调ID"] ~= 0 then
        removePeriodicCallback(context["周期回调ID"])
        context["周期回调ID"] = 0
    end
    context["已启动"] = false
    local id = _____53D6_5355_4F4DID(context["施法者"])
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
end
local function _____8FC7_6EE4Q_547D_4E2D_6807_7684(_____654C_519B_5217_8868)
    local result = {}
    do
        local i = 0
        while i < #_____654C_519B_5217_8868 do
            do
                local u = _____654C_519B_5217_8868[i + 1]
                if u == nil or u == 0 then
                    goto __continue12
                end
                if IsUnitType(u, UNIT_TYPE_ANCIENT) or IsUnitType(u, UNIT_TYPE_MECHANICAL) or IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                    goto __continue12
                end
                result[#result + 1] = u
            end
            ::__continue12::
            i = i + 1
        end
    end
    return result
end
local function ____Q_547D_4E2D_5B9A_8EAB_5904_7406(target, ______7D22_5F15, ______6210_529F, _____53D8_91CF)
    if target == nil or target == 0 then
        return
    end
    local caster = _____53D8_91CF
    if caster == nil or caster == 0 then
        return
    end
    _____65BD_52A0_7729_6655(
        caster,
        target,
        _____914D_7F6E["主动"]["命中控制"]["控制秒"],
        _____5742_4E95_60A0_4E8CBuffID["Q命中定身"],
        "技能"
    )
end
local function ____Q_6BB5_5185_626B_63CF(variable)
    local scan = variable
    if scan == nil then
        return
    end
    local caster = scan["施法者"]
    if scan["扫描次数"] >= _____914D_7F6E["主动"]["扫描次数"] then
        removePeriodicCallback(scan["回调ID"])
        scan["回调ID"] = 0
        scan["已命中句柄表"] = {}
        return
    end
    scan["扫描次数"] = scan["扫描次数"] + 1
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        removePeriodicCallback(scan["回调ID"])
        scan["回调ID"] = 0
        scan["已命中句柄表"] = {}
        return
    end
    local _____8DDD_79BB = _____914D_7F6E["主动"]["每次扫描推进距离"] * scan["扫描次数"]
    local _____5224_5B9AX = _____6781_5750_6807X(scan["起点X"], scan["方向角度"], _____8DDD_79BB)
    local _____5224_5B9AY = _____6781_5750_6807Y(scan["起点Y"], scan["方向角度"], _____8DDD_79BB)
    local _____5355_6B21_4F24_5BB3 = scan["伤害攻击力快照"] * _____914D_7F6E["主动"]["总伤害攻击力倍率"] * _____914D_7F6E["主动"]["单段伤害比例"]
    if _____5355_6B21_4F24_5BB3 <= 0 then
        return
    end
    local _____654C_519B_5217_8868 = _____8FC7_6EE4Q_547D_4E2D_6807_7684(_____83B7_53D6_8303_56F4_654C_519B(caster, _____5224_5B9AX, _____5224_5B9AY, _____914D_7F6E["主动"]["命中半径"]))
    local _____672C_6B21_76EE_6807 = {}
    do
        local i = 0
        while i < #_____654C_519B_5217_8868 do
            do
                local u = _____654C_519B_5217_8868[i + 1]
                if u == nil or u == 0 then
                    goto __continue24
                end
                local hid = GetHandleId(u) or 0
                if hid ~= 0 and scan["已命中句柄表"][hid] == true then
                    goto __continue24
                end
                if hid ~= 0 then
                    scan["已命中句柄表"][hid] = true
                end
                _____672C_6B21_76EE_6807[#_____672C_6B21_76EE_6807 + 1] = u
            end
            ::__continue24::
            i = i + 1
        end
    end
    if #_____672C_6B21_76EE_6807 == 0 then
        return
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = _____672C_6B21_76EE_6807,
        ["伤害"] = _____5355_6B21_4F24_5BB3,
        ["伤害类型"] = jass.DAMAGE_TYPE_MAGIC,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["标签"] = "坂井悠二-Q-吸血鬼-分段",
        ["技能ID"] = stringToFourCC(____Q_6280_80FDID_5B57_7B26_4E32),
        ["技能实例ID"] = scan["技能实例ID"],
        ["变量"] = caster,
        ["每目标结算后处理器"] = ____Q_547D_4E2D_5B9A_8EAB_5904_7406
    })
end
local function _____63A8_8FDBQ_6BB5(variable)
    local context = variable
    if context == nil then
        return
    end
    local caster = context["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6E05_7406Q_4E0A_4E0B_6587(context)
        return
    end
    if context["已完成段数"] >= _____914D_7F6E["主动"]["段数"] then
        _____6E05_7406Q_4E0A_4E0B_6587(context)
        return
    end
    context["已完成段数"] = context["已完成段数"] + 1
    local _____58F3_56DBCC = stringToFourCC(_____914D_7F6E["主动"]["壳"]["单位ID"])
    local _____58F3_5355_4F4D = CreateUnit(
        GetOwningPlayer(caster),
        _____58F3_56DBCC,
        context["起点X"],
        context["起点Y"],
        context["方向角度"] + _____914D_7F6E["主动"]["壳"]["朝向偏移角度"]
    )
    if _____58F3_5355_4F4D ~= nil and _____58F3_5355_4F4D ~= 0 then
        SetUnitFlyHeight(_____58F3_5355_4F4D, _____914D_7F6E["主动"]["壳"]["飞行高度增量"], 0)
        SetUnitScale(_____58F3_5355_4F4D, _____914D_7F6E["主动"]["壳"]["缩放"], _____914D_7F6E["主动"]["壳"]["缩放"], _____914D_7F6E["主动"]["壳"]["缩放"])
        AddSpecialEffectTarget(_____914D_7F6E["主动"]["壳"]["模型路径"], _____58F3_5355_4F4D, "origin")
    end
    local scan = {
        ["施法者"] = caster,
        ["技能实例ID"] = context["技能实例ID"],
        ["起点X"] = context["起点X"],
        ["起点Y"] = context["起点Y"],
        ["方向角度"] = context["方向角度"],
        ["伤害攻击力快照"] = context["伤害攻击力快照"],
        ["扫描次数"] = 0,
        ["回调ID"] = 0,
        ["已命中句柄表"] = {}
    }
    scan["回调ID"] = addPeriodicCallback(_____914D_7F6E["主动"]["扫描间隔秒"] * 1000, ____Q_6BB5_5185_626B_63CF, scan)
end
local function _____91CA_653EQ_6280_80FD(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["已启动"] then
        return
    end
    context["已启动"] = true
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["伤害攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    context["起点X"] = GetUnitX(caster)
    context["起点Y"] = GetUnitY(caster)
    context["已完成段数"] = 0
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____671D_5411_76EE_6807 = _____4E24_70B9_89D2_5EA6(context["起点X"], context["起点Y"], _____76EE_6807X, _____76EE_6807Y)
    context["方向角度"] = _____671D_5411_76EE_6807
    SetUnitFacing(caster, _____671D_5411_76EE_6807)
    context["周期回调ID"] = addPeriodicCallback(_____914D_7F6E["主动"]["段间隔秒"] * 1000, _____63A8_8FDBQ_6BB5, context)
end
local function ____Q_53EF_91CA_653E(context)
    return not context["已启动"] and context["周期回调ID"] == 0
end
local function ____Q_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____83B7_53D6Q_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____6E05_7406Q_4E0A_4E0B_6587(context)
    end
end
____exports["注册坂井悠二Q"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "坂井悠二-吸血鬼（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = ____Q_6280_80FDID_5B57_7B26_4E32,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAQ_4E0A_4E0B_6587,
        ["可释放"] = ____Q_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653EQ_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____914D_7F6E["主动"]["段间隔秒"] * _____914D_7F6E["主动"]["段数"] + _____914D_7F6E["主动"]["扫描间隔秒"] * _____914D_7F6E["主动"]["扫描次数"] + 1
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____Q_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册坂井悠二Q"]()
____exports["坂井悠二Q技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["伤害形态"] = "固定马甲 + 直线扫描伤害（特效不推进，伤害判定点推进）",
    ["伤害"] = "300% 攻击力，外层 0.21s×5 段每次命中 20%，段内 0.01s×20 tick 扫描 40码/tick，半径 175，段内去重",
    ["命中控制"] = "几乎无法移动 1 秒（眩晕）"
}
return ____exports
