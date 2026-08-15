local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____53D6_5F53_524D_65BD_6CD5_6280_80FD_7C7B_578BID, _____5F53_524D_65BD_6CD5_6280_80FD_7C7B_578BID_7F13_5B58
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.00．配置")
local _____585E_62C9_65AF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞拉斯技能配置"]
local ____06_FF0E_585E_62C9_65AF = require("系统.05．Buff系统.03．Buff表.02．英雄.06．塞拉斯")
local _____585E_62C9_65AFBuffID = ____06_FF0E_585E_62C9_65AF["塞拉斯BuffID"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.01．状态表")
local _____83B7_53D6_6216_521B_5EFA_585E_62C9_65AF_9B54_6CD5_72B6_6001 = ____01_FF0E_72B6_6001_8868["获取或创建塞拉斯魔法状态"]
local _____6D88_8D39_585E_62C9_65AF_5927_9B54_6CD5_5316 = ____01_FF0E_72B6_6001_8868["消费塞拉斯大魔法化"]
local _____8BBE_7F6E_585E_62C9_65AF_653B_51FB_6807_8BB0 = ____01_FF0E_72B6_6001_8868["设置塞拉斯攻击标记"]
local _____585E_62C9_65AF_9B54_6CD5_6280_80FD_589E_5E45_500D_7387 = ____01_FF0E_72B6_6001_8868["塞拉斯魔法技能增幅倍率"]
local ____02_FF0E_6280_80FD_5165_53E3_4E0E_5173_95ED = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.02．技能入口与关闭")
local _____585E_62C9_65AF_5143_7D20_65BD_6CD5_540E_81EA_52A8_5173_95ED = ____02_FF0E_6280_80FD_5165_53E3_4E0E_5173_95ED["塞拉斯元素施法后自动关闭"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
function _____53D6_5F53_524D_65BD_6CD5_6280_80FD_7C7B_578BID()
    return _____5F53_524D_65BD_6CD5_6280_80FD_7C7B_578BID_7F13_5B58
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_0["施加眩晕"]
local _____65BD_52A0_51CF_901F = ____require_result_0["施加减速"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local _____83B7_53D6_5355_4F4DBuff_5C42_6570 = ____require_result_2["获取单位Buff层数"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成批量AOE技能伤害"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_4["造成技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_5["获取范围敌军"]
local _____5728_5750_6807_64AD_653E_7279_6548 = ____require_result_5["在坐标播放特效"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_6.createTimedUnitEffect
local ____require_result_7 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_7.Sound3DII_UnitPlayReuse
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_8.addPeriodicCallback
local removePeriodicCallback = ____require_result_8.removePeriodicCallback
local ____require_result_9 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_9.registerDeathListener
local ____require_result_10 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_10["技能_设置技能冷却时间"]
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local _____914D_7F6E = _____585E_62C9_65AF_6280_80FD_914D_7F6E
local _____5143_7D20_914D_7F6E = _____914D_7F6E["元素魔法"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____Q_5165_53E3_7C7B_578BID = _____914D_7F6E["Q入口"]["技能类型ID"]
local _____5143_7D20_4E0A_4E0B_6587_8868 = {}
local _____707C_70E7_5468_671F_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____53D6_53E5_67C4ID(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
local function _____8FC7_6EE4_5143_7D20_9B54_6CD5_6807_7684(_____654C_519B_5217_8868)
    local result = {}
    do
        local i = 0
        while i < #_____654C_519B_5217_8868 do
            do
                local u = _____654C_519B_5217_8868[i + 1]
                if u == nil or u == 0 then
                    goto __continue6
                end
                if IsUnitType(u, UNIT_TYPE_ANCIENT) or IsUnitType(u, UNIT_TYPE_MECHANICAL) or IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                    goto __continue6
                end
                result[#result + 1] = u
            end
            ::__continue6::
            i = i + 1
        end
    end
    return result
end
local function _____6E05_7406_5143_7D20_4E0A_4E0B_6587(context)
    if context["tick回调ID"] ~= 0 then
        removePeriodicCallback(context["tick回调ID"])
        context["tick回调ID"] = 0
    end
    local id = _____53D6_53E5_67C4ID(context["施法者"])
    if id ~= 0 and _____5143_7D20_4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____5143_7D20_4E0A_4E0B_6587_8868, id)
    end
end
local function _____63A8_8FDB_707C_70E7_5468_671F(variable)
    local record = variable
    if record == nil then
        return
    end
    local caster = record.caster
    local target = record.target
    if caster == nil or caster == 0 or target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        removePeriodicCallback(record["回调ID"])
        __TS__Delete(_____707C_70E7_5468_671F_8868, record["回调ID"])
        return
    end
    local _____5C42_6570 = _____83B7_53D6_5355_4F4DBuff_5C42_6570(target, _____585E_62C9_65AFBuffID["灼烧"])
    if _____5C42_6570 <= 0 then
        removePeriodicCallback(record["回调ID"])
        __TS__Delete(_____707C_70E7_5468_671F_8868, record["回调ID"])
        return
    end
    registerManualBuff(
        target,
        _____585E_62C9_65AFBuffID["灼烧"],
        _____5C42_6570 * 1,
        0.015,
        {stack = _____5C42_6570 - 1, allowZeroStack = true, sourceUnit = caster}
    )
    local _____5DF2_635F_5931_751F_547D = GetUnitState(target, UNIT_STATE_MAX_LIFE) - GetUnitState(target, UNIT_STATE_LIFE)
    local _____4F24_5BB3 = _____5DF2_635F_5931_751F_547D * _____5143_7D20_914D_7F6E["火焰"]["灼烧每秒已损失生命比例"]
    if _____4F24_5BB3 > 0.5 and _____5355_4F4D_5B58_6D3B(caster) then
        _____9020_6210_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标"] = target,
            ["伤害"] = _____4F24_5BB3,
            ["伤害类型"] = jass.DAMAGE_TYPE_FIRE,
            attackType = jass.ATTACK_TYPE_NORMAL,
            weaponType = jass.WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["标签"] = "塞拉斯-灼烧"
        })
    end
    createTimedUnitEffect(target, _____5143_7D20_914D_7F6E["火焰"]["灼烧特效"]["挂点"], _____5143_7D20_914D_7F6E["火焰"]["灼烧特效"]["模型路径"], _____5143_7D20_914D_7F6E["火焰"]["灼烧特效"]["持续秒"])
end
local function _____65BD_52A0_707C_70E7(caster, target)
    local _____5F53_524D_5C42_6570 = _____83B7_53D6_5355_4F4DBuff_5C42_6570(target, _____585E_62C9_65AFBuffID["灼烧"])
    local _____65B0_5C42_6570 = _____5F53_524D_5C42_6570 + _____5143_7D20_914D_7F6E["火焰"]["灼烧每次命中加层"]
    registerManualBuff(
        target,
        _____585E_62C9_65AFBuffID["灼烧"],
        _____65B0_5C42_6570 * 1,
        0.015,
        {stack = _____65B0_5C42_6570, sourceUnit = caster}
    )
    local record = {caster = caster, target = target, ["回调ID"] = 0}
    record["回调ID"] = addPeriodicCallback(1000, _____63A8_8FDB_707C_70E7_5468_671F, record)
    _____707C_70E7_5468_671F_8868[record["回调ID"]] = record
end
local function _____5143_7D20_547D_4E2D_7ED3_7B97_5904_7406(target, ______7D22_5F15, ______6210_529F, _____53D8_91CF)
    if target == nil or target == 0 then
        return
    end
    local payload = _____53D8_91CF
    if payload == nil then
        return
    end
    local caster = payload.caster
    local _____5143_7D20 = payload["元素"]
    if _____5143_7D20 == "火" then
        _____65BD_52A0_707C_70E7(caster, target)
        _____8BBE_7F6E_585E_62C9_65AF_653B_51FB_6807_8BB0(caster, "火")
        registerManualBuff(
            caster,
            _____585E_62C9_65AFBuffID["火焰附加攻击"],
            30,
            1,
            {stack = 1}
        )
    elseif _____5143_7D20 == "冰" then
        _____65BD_52A0_7729_6655(
            caster,
            target,
            _____5143_7D20_914D_7F6E["冰冻"]["冻结秒"],
            _____585E_62C9_65AFBuffID["冻结"],
            "技能"
        )
        registerManualBuff(
            target,
            _____585E_62C9_65AFBuffID["冻结"],
            _____5143_7D20_914D_7F6E["冰冻"]["冻结秒"],
            1,
            {stack = 1, sourceUnit = caster}
        )
        _____8BBE_7F6E_585E_62C9_65AF_653B_51FB_6807_8BB0(caster, "冰")
        registerManualBuff(
            caster,
            _____585E_62C9_65AFBuffID["冰冻附加攻击"],
            30,
            1,
            {stack = 1}
        )
    elseif _____5143_7D20 == "雷" then
        _____65BD_52A0_51CF_901F(
            caster,
            target,
            _____5143_7D20_914D_7F6E["雷击"]["减速比例"],
            _____5143_7D20_914D_7F6E["雷击"]["减速秒"],
            _____585E_62C9_65AFBuffID["雷击减速"],
            "技能"
        )
        registerManualBuff(
            target,
            _____585E_62C9_65AFBuffID["雷击减速"],
            _____5143_7D20_914D_7F6E["雷击"]["减速秒"],
            _____5143_7D20_914D_7F6E["雷击"]["减速比例"],
            {stack = 1, sourceUnit = caster}
        )
        createTimedUnitEffect(target, "origin", _____5143_7D20_914D_7F6E["雷击"]["目标特效"]["模型路径"], _____5143_7D20_914D_7F6E["雷击"]["目标特效"]["持续秒"])
        _____8BBE_7F6E_585E_62C9_65AF_653B_51FB_6807_8BB0(caster, "雷")
        registerManualBuff(
            caster,
            _____585E_62C9_65AFBuffID["雷击附加攻击"],
            30,
            1,
            {stack = 1}
        )
    end
end
local function _____64AD_653E_5143_7D20_843D_70B9_8868_73B0(caster, _____5143_7D20, x, y)
    if _____5143_7D20 == "火" then
        do
            local i = 0
            while i < #_____5143_7D20_914D_7F6E["火焰"]["特效"] do
                local fx = _____5143_7D20_914D_7F6E["火焰"]["特效"][i + 1]
                _____5728_5750_6807_64AD_653E_7279_6548(
                    fx["模型路径"],
                    x,
                    y,
                    0,
                    fx["缩放"],
                    fx["持续秒"]
                )
                i = i + 1
            end
        end
    elseif _____5143_7D20 == "冰" then
        do
            local i = 0
            while i < #_____5143_7D20_914D_7F6E["冰冻"]["特效"] do
                local fx = _____5143_7D20_914D_7F6E["冰冻"]["特效"][i + 1]
                _____5728_5750_6807_64AD_653E_7279_6548(
                    fx["模型路径"],
                    x,
                    y,
                    0,
                    fx["缩放"],
                    fx["持续秒"]
                )
                i = i + 1
            end
        end
    elseif _____5143_7D20 == "雷" then
        Sound3DII_UnitPlayReuse(_____5143_7D20_914D_7F6E["雷击"]["目标音效"]["路径"], caster, _____5143_7D20_914D_7F6E["雷击"]["目标音效"]["裁断距离"])
        _____5728_5750_6807_64AD_653E_7279_6548(
            _____5143_7D20_914D_7F6E["雷击"]["落点特效"]["模型路径"],
            x,
            y,
            0,
            _____5143_7D20_914D_7F6E["雷击"]["落点特效"]["缩放"],
            _____5143_7D20_914D_7F6E["雷击"]["落点特效"]["持续秒"]
        )
    end
end
local function _____63A8_8FDB_5143_7D20_9B54_6CD5tick(variable)
    local context = variable
    if context == nil then
        return
    end
    local caster = context["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6E05_7406_5143_7D20_4E0A_4E0B_6587(context)
        return
    end
    local x = context["目标X"]
    local y = context["目标Y"]
    local _____76EE_6807_5355_4F4D = context["目标单位"]
    if _____76EE_6807_5355_4F4D ~= nil and _____76EE_6807_5355_4F4D ~= 0 and _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        x = GetUnitX(_____76EE_6807_5355_4F4D)
        y = GetUnitY(_____76EE_6807_5355_4F4D)
        context["目标X"] = x
        context["目标Y"] = y
    end
    local _____654C_519B_5217_8868 = _____8FC7_6EE4_5143_7D20_9B54_6CD5_6807_7684(_____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____5143_7D20_914D_7F6E["范围"]))
    if context["伤害快照"] > 0 and #_____654C_519B_5217_8868 > 0 then
        local ____temp_12
        if context["元素"] == "火" then
            ____temp_12 = jass.DAMAGE_TYPE_FIRE
        else
            local ____temp_11
            if context["元素"] == "冰" then
                ____temp_11 = jass.DAMAGE_TYPE_COLD
            else
                ____temp_11 = jass.DAMAGE_TYPE_LIGHTNING
            end
            ____temp_12 = ____temp_11
        end
        local _____4F24_5BB3_7C7B_578B = ____temp_12
        _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标列表"] = _____654C_519B_5217_8868,
            ["伤害"] = context["伤害快照"],
            ["伤害类型"] = _____4F24_5BB3_7C7B_578B,
            attackType = jass.ATTACK_TYPE_NORMAL,
            weaponType = jass.WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["标签"] = "塞拉斯-元素魔法",
            ["技能ID"] = context["技能类型ID"],
            ["技能实例ID"] = context["技能实例ID"],
            ["变量"] = {caster = caster, ["元素"] = context["元素"]},
            ["每目标结算后处理器"] = _____5143_7D20_547D_4E2D_7ED3_7B97_5904_7406
        })
    end
    _____64AD_653E_5143_7D20_843D_70B9_8868_73B0(caster, context["元素"], x, y)
    context["已结算次数"] = context["已结算次数"] + 1
    if context["已结算次数"] >= context["结算次数"] then
        _____6E05_7406_5143_7D20_4E0A_4E0B_6587(context)
        _____585E_62C9_65AF_5143_7D20_65BD_6CD5_540E_81EA_52A8_5173_95ED(caster)
    end
end
local function _____53D6_5143_7D20_4E0E_7C7B_578BID(_____6280_80FD_7C7B_578BID)
    if _____6280_80FD_7C7B_578BID == _____5143_7D20_914D_7F6E["火焰技能类型ID"] then
        return "火"
    end
    if _____6280_80FD_7C7B_578BID == _____5143_7D20_914D_7F6E["冰冻技能类型ID"] then
        return "冰"
    end
    if _____6280_80FD_7C7B_578BID == _____5143_7D20_914D_7F6E["雷击技能类型ID"] then
        return "雷"
    end
    return ""
end
local function _____53D6_5143_7D20_4F24_5BB3_7C7B_578B_57FA_6570(_____5143_7D20)
    if _____5143_7D20 == "冰" then
        return {["基础倍率"] = _____5143_7D20_914D_7F6E["冰冻"]["基础倍率"], ["每级成长"] = _____5143_7D20_914D_7F6E["冰冻"]["每级成长"]}
    end
    if _____5143_7D20 == "雷" then
        return {["基础倍率"] = _____5143_7D20_914D_7F6E["雷击"]["基础倍率"], ["每级成长"] = _____5143_7D20_914D_7F6E["雷击"]["每级成长"]}
    end
    return {["基础倍率"] = _____5143_7D20_914D_7F6E["火焰"]["基础倍率"], ["每级成长"] = _____5143_7D20_914D_7F6E["火焰"]["每级成长"]}
end
local function _____64AD_653E_5143_7D20_65BD_6CD5_97F3_6548(caster, _____5143_7D20, _____662F_5927_9B54_6CD5)
    if _____5143_7D20 == "冰" then
        local snd = _____662F_5927_9B54_6CD5 and _____5143_7D20_914D_7F6E["冰冻"]["音效大魔法"] or _____5143_7D20_914D_7F6E["冰冻"]["音效普通"]
        Sound3DII_UnitPlayReuse(snd["路径"], caster, snd["裁断距离"])
    elseif _____5143_7D20 == "雷" then
        local snd = _____662F_5927_9B54_6CD5 and _____5143_7D20_914D_7F6E["雷击"]["音效大魔法"] or _____5143_7D20_914D_7F6E["雷击"]["音效普通"]
        Sound3DII_UnitPlayReuse(snd["路径"], caster, snd["裁断距离"])
    else
        local snd = _____662F_5927_9B54_6CD5 and _____5143_7D20_914D_7F6E["火焰"]["音效大魔法"] or _____5143_7D20_914D_7F6E["火焰"]["音效普通"]
        Sound3DII_UnitPlayReuse(snd["路径"], caster, snd["裁断距离"])
    end
end
local function _____83B7_53D6_6216_521B_5EFA_5143_7D20_4E0A_4E0B_6587(unit)
    local id = _____53D6_53E5_67C4ID(unit)
    if id == 0 then
        return nil
    end
    local current = _____5143_7D20_4E0A_4E0B_6587_8868[id]
    if current ~= nil and current["tick回调ID"] ~= 0 then
        return nil
    end
    if current ~= nil then
        return current
    end
    local created = {
        ["施法者"] = unit,
        ["元素"] = "",
        ["技能类型ID"] = 0,
        ["结算次数"] = 1,
        ["已结算次数"] = 0,
        ["伤害快照"] = 0,
        ["目标单位"] = nil,
        ["目标X"] = 0,
        ["目标Y"] = 0,
        ["tick回调ID"] = 0
    }
    _____5143_7D20_4E0A_4E0B_6587_8868[id] = created
    return created
end
local function _____91CA_653E_5143_7D20_9B54_6CD5(context, caster, _____6280_80FD_5B9E_4F8BID)
    local _____6280_80FD_7C7B_578BID = _____53D6_5F53_524D_65BD_6CD5_6280_80FD_7C7B_578BID()
    local _____5143_7D20 = _____53D6_5143_7D20_4E0E_7C7B_578BID(_____6280_80FD_7C7B_578BID)
    if _____5143_7D20 == "" then
        return
    end
    local state = _____83B7_53D6_6216_521B_5EFA_585E_62C9_65AF_9B54_6CD5_72B6_6001(caster)
    local _____662F_5927_9B54_6CD5 = _____6D88_8D39_585E_62C9_65AF_5927_9B54_6CD5_5316(caster)
    if _____662F_5927_9B54_6CD5 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, _____585E_62C9_65AFBuffID["大魔法化"])
    end
    if state ~= nil then
        state["当前元素"] = _____5143_7D20
    end
    local _____7B49_7EA7 = GetUnitAbilityLevel(caster, ____Q_5165_53E3_7C7B_578BID)
    local _____500D_7387_7EC4 = _____53D6_5143_7D20_4F24_5BB3_7C7B_578B_57FA_6570(_____5143_7D20)
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    local _____589E_5E45 = _____585E_62C9_65AF_9B54_6CD5_6280_80FD_589E_5E45_500D_7387(caster)
    local _____4F24_5BB3_5FEB_7167 = _____653B_51FB_529B * (_____500D_7387_7EC4["基础倍率"] + _____500D_7387_7EC4["每级成长"] * _____7B49_7EA7) * _____589E_5E45
    context["施法者"] = caster
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["元素"] = _____5143_7D20
    context["技能类型ID"] = _____6280_80FD_7C7B_578BID
    context["结算次数"] = _____662F_5927_9B54_6CD5 and _____5143_7D20_914D_7F6E["大魔法结算次数"] or _____5143_7D20_914D_7F6E["普通结算次数"]
    context["已结算次数"] = 0
    context["伤害快照"] = _____4F24_5BB3_5FEB_7167
    local _____76EE_6807_5355_4F4D = GetSpellTargetUnit()
    context["目标单位"] = _____76EE_6807_5355_4F4D
    if _____76EE_6807_5355_4F4D ~= nil and _____76EE_6807_5355_4F4D ~= 0 then
        context["目标X"] = GetUnitX(_____76EE_6807_5355_4F4D)
        context["目标Y"] = GetUnitY(_____76EE_6807_5355_4F4D)
    else
        context["目标X"] = GetSpellTargetX()
        context["目标Y"] = GetSpellTargetY()
    end
    _____64AD_653E_5143_7D20_65BD_6CD5_97F3_6548(caster, _____5143_7D20, _____662F_5927_9B54_6CD5)
    context["tick回调ID"] = addPeriodicCallback(_____5143_7D20_914D_7F6E["tick间隔秒"] * 1000, _____63A8_8FDB_5143_7D20_9B54_6CD5tick, context)
end
_____5F53_524D_65BD_6CD5_6280_80FD_7C7B_578BID_7F13_5B58 = 0
local function _____91CA_653E_706B_7130_9B54_6CD5(context, caster, _____6280_80FD_5B9E_4F8BID)
    _____5F53_524D_65BD_6CD5_6280_80FD_7C7B_578BID_7F13_5B58 = _____5143_7D20_914D_7F6E["火焰技能类型ID"]
    _____91CA_653E_5143_7D20_9B54_6CD5(context, caster, _____6280_80FD_5B9E_4F8BID)
end
local function _____91CA_653E_51B0_51BB_9B54_6CD5(context, caster, _____6280_80FD_5B9E_4F8BID)
    _____5F53_524D_65BD_6CD5_6280_80FD_7C7B_578BID_7F13_5B58 = _____5143_7D20_914D_7F6E["冰冻技能类型ID"]
    _____91CA_653E_5143_7D20_9B54_6CD5(context, caster, _____6280_80FD_5B9E_4F8BID)
end
local function _____91CA_653E_96F7_51FB_9B54_6CD5(context, caster, _____6280_80FD_5B9E_4F8BID)
    _____5F53_524D_65BD_6CD5_6280_80FD_7C7B_578BID_7F13_5B58 = _____5143_7D20_914D_7F6E["雷击技能类型ID"]
    _____91CA_653E_5143_7D20_9B54_6CD5(context, caster, _____6280_80FD_5B9E_4F8BID)
end
local function _____5143_7D20_9B54_6CD5_53EF_91CA_653E(context)
    return context["tick回调ID"] == 0
end
local function _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587(unit)
    if unit == nil or unit == 0 then
        return nil
    end
    return {["施法者"] = unit}
end
local function _____91CA_653EW_5927_9B54_6CD5_5316(_context, caster)
    local state = _____83B7_53D6_6216_521B_5EFA_585E_62C9_65AF_9B54_6CD5_72B6_6001(caster)
    if state == nil then
        return
    end
    if state["大魔法化"] then
        return
    end
    do
        local i = 0
        while i < #_____914D_7F6E.W["音效"] do
            local snd = _____914D_7F6E.W["音效"][i + 1]
            Sound3DII_UnitPlayReuse(snd["路径"], caster, snd["裁断距离"])
            i = i + 1
        end
    end
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    do
        local i = 0
        while i < #_____914D_7F6E.W["特效"] do
            local fx = _____914D_7F6E.W["特效"][i + 1]
            _____5728_5750_6807_64AD_653E_7279_6548(
                fx["模型路径"],
                x,
                y,
                0,
                fx["缩放"],
                fx["持续秒"]
            )
            i = i + 1
        end
    end
    state["大魔法化"] = true
    registerManualBuff(
        caster,
        _____585E_62C9_65AFBuffID["大魔法化"],
        60,
        1,
        {stack = 1}
    )
    local ____W_7B49_7EA7 = GetUnitAbilityLevel(caster, _____914D_7F6E.W["技能类型ID"])
    local ____W_51B7_5374 = _____914D_7F6E.W["冷却基础秒"] - _____914D_7F6E.W["冷却每级递减秒"] * ____W_7B49_7EA7
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, _____914D_7F6E.W["技能类型ID"], ____W_51B7_5374, ____W_51B7_5374)
end
local function _____5143_7D20_9B54_6CD5_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local id = _____53D6_53E5_67C4ID(dyingUnit)
    if id ~= 0 then
        local context = _____5143_7D20_4E0A_4E0B_6587_8868[id]
        if context ~= nil then
            _____6E05_7406_5143_7D20_4E0A_4E0B_6587(context)
        end
    end
    for key in pairs(_____707C_70E7_5468_671F_8868) do
        do
            local record = _____707C_70E7_5468_671F_8868[__TS__Number(key)]
            if record == nil then
                goto __continue77
            end
            if record.target == dyingUnit or record.caster == dyingUnit then
                removePeriodicCallback(record["回调ID"])
                __TS__Delete(
                    _____707C_70E7_5468_671F_8868,
                    __TS__Number(key)
                )
            end
        end
        ::__continue77::
    end
end
____exports["注册塞拉斯元素魔法"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞拉斯-火焰魔法（A0JQ）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5143_7D20_914D_7F6E["火焰技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5143_7D20_4E0A_4E0B_6587,
        ["可释放"] = _____5143_7D20_9B54_6CD5_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653E_706B_7130_9B54_6CD5,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____5143_7D20_914D_7F6E["tick间隔秒"] * _____5143_7D20_914D_7F6E["大魔法结算次数"] + 1
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞拉斯-冰冻魔法（A0JR）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5143_7D20_914D_7F6E["冰冻技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5143_7D20_4E0A_4E0B_6587,
        ["可释放"] = _____5143_7D20_9B54_6CD5_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653E_51B0_51BB_9B54_6CD5,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____5143_7D20_914D_7F6E["tick间隔秒"] * _____5143_7D20_914D_7F6E["大魔法结算次数"] + 1
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞拉斯-雷击魔法（A0JS）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5143_7D20_914D_7F6E["雷击技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5143_7D20_4E0A_4E0B_6587,
        ["可释放"] = _____5143_7D20_9B54_6CD5_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653E_96F7_51FB_9B54_6CD5,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____5143_7D20_914D_7F6E["tick间隔秒"] * _____5143_7D20_914D_7F6E["大魔法结算次数"] + 1
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞拉斯-大魔法化（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.W["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653EW_5927_9B54_6CD5_5316,
        ["创建独立技能实例"] = false
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(_____5143_7D20_9B54_6CD5_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册塞拉斯元素魔法"]()
return ____exports
