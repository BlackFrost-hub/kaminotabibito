local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取影骨莫特斯上下文"]
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建影骨莫特斯上下文"]
local _____8BBE_7F6E_5F71_9AA8_80CC_523A_51C6_5907 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["设置影骨背刺准备"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯表现配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.08．台词播放")
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放影骨莫特斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____6781_5750_6807X = ____11_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____11_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____76EE_6807_6B63_9762_671D_5411_6765_6E90 = ____11_FF0E_516C_5171_5DE5_5177["目标正面朝向来源"]
local _____53D6_5355_4F4DID = ____11_FF0E_516C_5171_5DE5_5177["取单位ID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomReal = jass.GetRandomReal
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local SetUnitVertexColor = jass.SetUnitVertexColor
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local IssueTargetOrder = jass.IssueTargetOrder
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_1["获取Boss技能随机敌对英雄"]
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local _____5F71_9AA8_5355_4F4D_7C7B_578BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____9634_5F71_7A7F_68AD_6280_80FDID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["阴影穿梭"])
local _____5DF2_6CE8_518C_9634_5F71_7A7F_68AD = false
local _____5DF2_6CE8_518C_80CC_523A_4FEE_6B63 = false
local _____5F85_7A7F_68AD_4E0A_4E0B_6587 = {}
local function ____on_5F71_9AA8_80CC_523A_4F24_5BB3_4FEE_6B63(damageContext)
    local boss = damageContext.attacker
    if not _____5355_4F4D_6709_6548(boss) or damageContext.isNormalAttack ~= true or damageContext.isSkillAttack == true or damageContext.isSkillDamage == true then
        return damageContext.currentDamage
    end
    if GetUnitTypeId(boss) ~= _____5F71_9AA8_5355_4F4D_7C7B_578BID then
        return damageContext.currentDamage
    end
    local context = _____83B7_53D6_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(boss)
    if context == nil or not context["背刺准备"] then
        return damageContext.currentDamage
    end
    _____8BBE_7F6E_5F71_9AA8_80CC_523A_51C6_5907(context, false)
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["阴影穿梭"]
    local damage = damageContext.currentDamage * cfg["背刺伤害倍率"]
    if _____76EE_6807_6B63_9762_671D_5411_6765_6E90(boss, damageContext.target, cfg["背刺角度"]) then
        damage = damage * cfg["正面减伤比例"]
    end
    if _____5355_4F4D_6709_6548(damageContext.target) then
        local effect = AddSpecialEffectTarget(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["背刺命中"], damageContext.target, "chest")
        if effect ~= nil and effect ~= 0 then
            DestroyEffect(effect)
        end
    end
    return damage
end
local function _____786E_4FDD_5F71_9AA8_80CC_523A_4FEE_6B63()
    if _____5DF2_6CE8_518C_80CC_523A_4FEE_6B63 then
        return
    end
    _____5DF2_6CE8_518C_80CC_523A_4FEE_6B63 = true
    registerDamageModifier(____on_5F71_9AA8_80CC_523A_4F24_5BB3_4FEE_6B63, 48)
end
local function _____5F71_9AA8_9634_5F71_7A7F_68AD_5B8C_6210()
    for key in pairs(_____5F85_7A7F_68AD_4E0A_4E0B_6587) do
        do
            local context = _____5F85_7A7F_68AD_4E0A_4E0B_6587[key]
            if context == nil then
                goto __continue12
            end
            __TS__Delete(_____5F85_7A7F_68AD_4E0A_4E0B_6587, key)
            local boss = context["Boss单位"]
            if not _____5355_4F4D_6709_6548(boss) then
                goto __continue12
            end
            local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
            if not _____5355_4F4D_6709_6548(target) then
                SetUnitInvulnerable(boss, false)
                SetUnitVertexColor(
                    boss,
                    255,
                    255,
                    255,
                    255
                )
                goto __continue12
            end
            local angle = GetRandomReal(0, 360)
            local distance = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["阴影穿梭"]["出现距离"]
            local x = _____6781_5750_6807X(
                GetUnitX(target),
                distance,
                angle
            )
            local y = _____6781_5750_6807Y(
                GetUnitY(target),
                distance,
                angle
            )
            AddSpecialEffect(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["阴影穿梭落点"], x, y)
            SetUnitX(boss, x)
            SetUnitY(boss, y)
            SetUnitInvulnerable(boss, false)
            SetUnitVertexColor(
                boss,
                255,
                255,
                255,
                255
            )
            _____8BBE_7F6E_5F71_9AA8_80CC_523A_51C6_5907(context, true)
            IssueTargetOrder(boss, "attackonce", target)
        end
        ::__continue12::
    end
end
____exports["释放影骨阴影穿梭"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(boss, "阴影穿梭")
    AddSpecialEffect(
        _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["阴影穿梭残影"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    SetUnitVertexColor(
        boss,
        255,
        255,
        255,
        80
    )
    SetUnitInvulnerable(boss, true)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return
    end
    _____5F85_7A7F_68AD_4E0A_4E0B_6587[id] = context
    local ____self_3 = context["清理"]
    ____self_3["登记延迟回调"](
        ____self_3,
        "影骨-阴影穿梭",
        addDelayedCallback(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["阴影穿梭"]["消失秒"] * 1000, _____5F71_9AA8_9634_5F71_7A7F_68AD_5B8C_6210)
    )
end
local function ____on_5F71_9AA8_9634_5F71_7A7F_68AD_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____9634_5F71_7A7F_68AD_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5F71_9AA8_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放影骨阴影穿梭"](context)
end
____exports["注册影骨莫特斯阴影穿梭"] = function()
    if _____5DF2_6CE8_518C_9634_5F71_7A7F_68AD then
        return
    end
    _____5DF2_6CE8_518C_9634_5F71_7A7F_68AD = true
    _____786E_4FDD_5F71_9AA8_80CC_523A_4FEE_6B63()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "03．阴影穿梭",
        ["单位类型ID"] = _____5F71_9AA8_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____9634_5F71_7A7F_68AD_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5F71_9AA8_9634_5F71_7A7F_68AD_65BD_6CD5(boss, _____9634_5F71_7A7F_68AD_6280_80FDID)
        end
    })
end
return ____exports
