local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取影骨莫特斯上下文"]
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建影骨莫特斯上下文"]
local _____5237_65B0_5F71_9AA8_5E7D_7075_5F62_6001Buff = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新影骨幽灵形态Buff"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯音效配置"]
local ____04_FF0E_9AB8_9AA8_53EC_5524 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.04．骸骨召唤")
local _____521B_5EFA_5F71_9AA8_53EC_5524_7269 = ____04_FF0E_9AB8_9AA8_53EC_5524["创建影骨召唤物"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.08．台词播放")
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放影骨莫特斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____6781_5750_6807X = ____11_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____11_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetRandomReal = jass.GetRandomReal
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local SetUnitVertexColor = jass.SetUnitVertexColor
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.10．战斗视野压制")
local _____65BD_52A0_6218_6597_89C6_91CE_538B_5236 = ____require_result_3["施加战斗视野压制"]
local _____5F71_9AA8_5355_4F4D_7C7B_578BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____5E7D_5F71_7206_53D1_6280_80FDID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["幽影爆发"])
local _____9AB7_9AC5_76D7_8D3CID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["骷髅盗贼单位类型"])
local _____9AB7_9AC5_5C04_624BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["骷髅射手单位类型"])
local _____5DF2_6CE8_518C_5E7D_5F71_7206_53D1 = false
local _____5DF2_6CE8_518C_5E7D_5F71_627F_4F24 = false
local _____5E7D_5F71_7206_53D1_5468_671F_8868 = {}
local _____4E0B_4E00_4E2A_5E7D_5F71_5468_671FID = 0
local function ____on_5F71_9AA8_5E7D_5F71_627F_4F24_4FEE_6B63(damageContext)
    if not _____5355_4F4D_6709_6548(damageContext.target) or GetUnitTypeId(damageContext.target) ~= _____5F71_9AA8_5355_4F4D_7C7B_578BID then
        return damageContext.currentDamage
    end
    local context = _____83B7_53D6_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(damageContext.target)
    if context == nil or not context["幽影爆发中"] or damageContext.target ~= context["Boss单位"] then
        return damageContext.currentDamage
    end
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]
    if damageContext.isPhysicalDamage == true then
        return damageContext.currentDamage * (1 - cfg["物理承伤降低"])
    end
    if damageContext.isMagicDamage == true then
        return damageContext.currentDamage * (1 + cfg["魔法承伤提高"])
    end
    return damageContext.currentDamage
end
local function _____786E_4FDD_5E7D_5F71_627F_4F24_4FEE_6B63()
    if _____5DF2_6CE8_518C_5E7D_5F71_627F_4F24 then
        return
    end
    _____5DF2_6CE8_518C_5E7D_5F71_627F_4F24 = true
    registerDamageModifier(____on_5F71_9AA8_5E7D_5F71_627F_4F24_4FEE_6B63, 52)
end
local function _____5E7D_5F71_7206_53D1_53EC_5524Tick()
    for key in pairs(_____5E7D_5F71_7206_53D1_5468_671F_8868) do
        do
            local data = _____5E7D_5F71_7206_53D1_5468_671F_8868[key]
            if data == nil then
                goto __continue10
            end
            local context = data.context
            if not _____5355_4F4D_6709_6548(context["Boss单位"]) or not context["幽影爆发中"] then
                removePeriodicCallback(data.id)
                __TS__Delete(_____5E7D_5F71_7206_53D1_5468_671F_8868, key)
                goto __continue10
            end
            data.count = data.count + 1
            local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]
            local angle = GetRandomReal(0, 360)
            local x = _____6781_5750_6807X(cfg["召唤中心X"], cfg["召唤半径"], angle)
            local y = _____6781_5750_6807Y(cfg["召唤中心Y"], cfg["召唤半径"], angle)
            local unitType = data.count % 2 == 0 and _____9AB7_9AC5_5C04_624BID or _____9AB7_9AC5_76D7_8D3CID
            local instance = _____521B_5EFA_5F71_9AA8_53EC_5524_7269(
                context,
                unitType,
                x,
                y,
                nil,
                true
            )
            if instance ~= nil and instance["单位"] ~= nil then
                local ____context__5E7D_5F71_53EC_5524_7269_4 = context["幽影召唤物"]
                ____context__5E7D_5F71_53EC_5524_7269_4[#____context__5E7D_5F71_53EC_5524_7269_4 + 1] = instance["单位"]
            end
            if data.count * cfg["召唤间隔秒"] >= cfg["召唤持续秒"] then
                removePeriodicCallback(data.id)
                __TS__Delete(_____5E7D_5F71_7206_53D1_5468_671F_8868, key)
            end
        end
        ::__continue10::
    end
end
local function _____7ED3_675F_5F71_9AA8_5E7D_5F71_7206_53D1(context)
    if not context["幽影爆发中"] then
        return
    end
    context["幽影爆发中"] = false
    _____5237_65B0_5F71_9AA8_5E7D_7075_5F62_6001Buff(context)
    if _____5355_4F4D_6709_6548(context["Boss单位"]) then
        SetUnitVertexColor(
            context["Boss单位"],
            255,
            255,
            255,
            255
        )
    end
    local lossRatio = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["结束召唤物损血比例"]
    do
        local i = 0
        while i < #context["幽影召唤物"] do
            do
                local unit = context["幽影召唤物"][i + 1]
                if not _____5355_4F4D_6709_6548(unit) then
                    goto __continue20
                end
                local life = GetUnitState(unit, UNIT_STATE_LIFE)
                SetUnitState(unit, UNIT_STATE_LIFE, life * (1 - lossRatio))
            end
            ::__continue20::
            i = i + 1
        end
    end
    context["幽影召唤物"] = {}
end
local function _____9500_6BC1_5F71_9AA8_5E7D_7075_5F62_6001_7279_6548(variable)
    if variable == nil or variable["已销毁"] or variable.aura == nil or variable.aura == 0 then
        return
    end
    variable["已销毁"] = true
    DestroyEffect(variable.aura)
end
local function _____5F71_9AA8_5E7D_5F71_7206_53D1_7ED3_675F(variable)
    if variable == nil then
        return
    end
    _____7ED3_675F_5F71_9AA8_5E7D_5F71_7206_53D1(variable.context)
    _____9500_6BC1_5F71_9AA8_5E7D_7075_5F62_6001_7279_6548(variable)
end
____exports["释放影骨幽影爆发"] = function(context)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(context["Boss单位"], "幽影爆发")
    AddSpecialEffect(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["幽影爆发开场"], _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["召唤中心X"], _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["召唤中心Y"])
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["幽影爆发"]["领域展开"], _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["召唤中心X"], _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["召唤中心Y"], _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["幽影爆发"]["召唤潮开始"], _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["召唤中心X"], _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["召唤中心Y"], _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["标识"],
        ["音效路径列表"] = _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["音效路径列表"],
        X = GetUnitX(context["Boss单位"]),
        Y = GetUnitY(context["Boss单位"]),
        ["裁断距离"] = _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"],
        ["冷却Ms"] = _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["爆发触发概率百分比"]
    })
    local aura = AddSpecialEffectTarget(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["幽灵形态持续"], context["Boss单位"], "origin")
    local endVariable = {context = context, aura = aura, ["已销毁"] = false}
    if aura ~= nil and aura ~= 0 then
        local ____self_5 = context["清理"]
        ____self_5["登记清理"](____self_5, "影骨-幽灵形态", _____9500_6BC1_5F71_9AA8_5E7D_7075_5F62_6001_7279_6548, endVariable)
    end
    context["幽影爆发中"] = true
    context["幽影召唤物"] = {}
    _____5237_65B0_5F71_9AA8_5E7D_7075_5F62_6001Buff(context)
    SetUnitVertexColor(
        context["Boss单位"],
        170,
        80,
        255,
        150
    )
    _____65BD_52A0_6218_6597_89C6_91CE_538B_5236({
        ["清理"] = context["清理"],
        ["名称"] = "影骨-幽影视野压制",
        ["来源单位"] = context["Boss单位"],
        ["目标列表"] = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"]),
        ["持续时间"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["持续秒"],
        ["视野减少值"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["视野降低"],
        ["图标路径"] = "BuffIcon\\Boss\\ShadowboneMortes\\shadow_vision.blp",
        ["叠加键"] = "影骨-幽影视野压制"
    })
    _____4E0B_4E00_4E2A_5E7D_5F71_5468_671FID = _____4E0B_4E00_4E2A_5E7D_5F71_5468_671FID + 1
    local key = _____4E0B_4E00_4E2A_5E7D_5F71_5468_671FID
    local id = addPeriodicCallback(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["召唤间隔秒"] * 1000, _____5E7D_5F71_7206_53D1_53EC_5524Tick)
    _____5E7D_5F71_7206_53D1_5468_671F_8868[key] = {context = context, count = 0, id = id}
    local ____self_6 = context["清理"]
    ____self_6["登记周期回调"](____self_6, "影骨-幽影爆发召唤", id)
    local ____self_7 = context["清理"]
    ____self_7["登记延迟回调"](
        ____self_7,
        "影骨-幽影爆发结束",
        addDelayedCallback(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["持续秒"] * 1000, _____5F71_9AA8_5E7D_5F71_7206_53D1_7ED3_675F, endVariable)
    )
end
local function ____on_5F71_9AA8_5E7D_5F71_7206_53D1_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____5E7D_5F71_7206_53D1_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5F71_9AA8_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context ~= nil then
        ____exports["释放影骨幽影爆发"](context)
    end
end
____exports["注册影骨莫特斯幽影爆发"] = function()
    if _____5DF2_6CE8_518C_5E7D_5F71_7206_53D1 then
        return
    end
    _____5DF2_6CE8_518C_5E7D_5F71_7206_53D1 = true
    _____786E_4FDD_5E7D_5F71_627F_4F24_4FEE_6B63()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "06．幽影爆发",
        ["单位类型ID"] = _____5F71_9AA8_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5E7D_5F71_7206_53D1_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5F71_9AA8_5E7D_5F71_7206_53D1_65BD_6CD5(boss, _____5E7D_5F71_7206_53D1_6280_80FDID)
        end
    })
end
return ____exports
