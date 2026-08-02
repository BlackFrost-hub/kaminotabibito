local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____767B_8BB0_5F71_9AA8_53EC_5524_7269, _____6E05_9664_5F71_9AA8_53EC_5524_7269_767B_8BB0, _____5F71_9AA8_53EC_5524_7269_9500_6BC1, _____521B_5EFA_70B9_7279_6548, GetUnitStateJapi, GetOwningPlayer, GetRandomReal, IssueTargetOrder, UNIT_STATE_MAX_LIFE, _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, registerManualBuff, _____5F71_9AA8_83AB_7279_65AFBuffID, _____9AB8_9AA8_6218_58EBID, _____5F71_9AA8_53EC_5524_7269_4E0A_4E0B_6587_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建影骨莫特斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6A21_578B_52A8_753B_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯模型动画配置"]
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯音效配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.08．台词播放")
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放影骨莫特斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____6781_5750_6807X = ____11_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____11_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____53D6_5355_4F4DID = ____11_FF0E_516C_5171_5DE5_5177["取单位ID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
local ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.03．召唤物组状态管理")
local _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001 = ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406["创建召唤物组状态"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["施加临时属性效果"]
function _____767B_8BB0_5F71_9AA8_53EC_5524_7269(unit, context)
    local id = _____53D6_5355_4F4DID(unit)
    if id ~= 0 then
        _____5F71_9AA8_53EC_5524_7269_4E0A_4E0B_6587_8868[id] = context
    end
end
function _____6E05_9664_5F71_9AA8_53EC_5524_7269_767B_8BB0(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id ~= 0 then
        __TS__Delete(_____5F71_9AA8_53EC_5524_7269_4E0A_4E0B_6587_8868, id)
    end
end
function _____5F71_9AA8_53EC_5524_7269_9500_6BC1(unit, variable)
    _____6E05_9664_5F71_9AA8_53EC_5524_7269_767B_8BB0(unit)
end
____exports["创建影骨召唤物"] = function(context, unitType, x, y, group)
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]
    local bossMaxLife = GetUnitStateJapi(context["Boss单位"], UNIT_STATE_MAX_LIFE)
    local _____6700_5927_751F_547D = unitType == _____9AB8_9AA8_6218_58EBID and cfg["骸骨战士生命值"] + bossMaxLife * cfg["骸骨战士Boss最大生命比例"] or cfg["骷髅生命值"] + bossMaxLife * cfg["骷髅Boss最大生命比例"]
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "影骨-骷髅召唤物",
        ["主人单位"] = context["Boss单位"],
        ["所属玩家"] = GetOwningPlayer(context["Boss单位"]),
        ["单位类型"] = unitType,
        X = x,
        Y = y,
        ["朝向"] = GetRandomReal(0, 360),
        ["最大生命"] = _____6700_5927_751F_547D,
        ["持续时间"] = unitType == _____9AB8_9AA8_6218_58EBID and cfg["骸骨战士持续秒"] or cfg["骷髅持续秒"],
        ["变量"] = {context = context},
        ["on销毁"] = _____5F71_9AA8_53EC_5524_7269_9500_6BC1
    })
    if instance ~= nil and instance["单位"] ~= nil then
        _____767B_8BB0_5F71_9AA8_53EC_5524_7269(instance["单位"], context)
        if group ~= nil then
            group["登记"](group, instance["单位"])
        end
        if context["幽影爆发中"] then
            registerManualBuff(
                instance["单位"],
                _____5F71_9AA8_83AB_7279_65AFBuffID["暗影强化"],
                _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["持续秒"],
                1,
                {sourceName = "影骨-暗影强化"}
            )
        end
        local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(context["Boss单位"])
        if _____5355_4F4D_6709_6548(target) then
            IssueTargetOrder(instance["单位"], "attack", target)
        end
        _____521B_5EFA_70B9_7279_6548({["模型路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骷髅出生"], X = x, Y = y, ["持续秒"] = cfg["瞬时特效持续秒"]})
    end
    return instance
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
GetOwningPlayer = jass.GetOwningPlayer
GetRandomReal = jass.GetRandomReal
local GetRandomInt = jass.GetRandomInt
IssueTargetOrder = jass.IssueTargetOrder
local GetPlayerState = jass.GetPlayerState
local SetPlayerState = jass.SetPlayerState
local GetUnitState = jass.GetUnitState
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
_____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_3["创建可攻击机制单位"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.06．战斗内拾取物")
local _____521B_5EFA_6218_6597_5185_62FE_53D6_7269 = ____require_result_4["创建战斗内拾取物"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_76EE_6807_5217_8868 = ____require_result_5["获取Boss技能敌对目标列表"]
_____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_5["获取Boss技能随机敌对英雄"]
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageBaseModifier = ____require_result_6.registerDamageBaseModifier
local ____require_result_7 = require("系统.04．伤害系统.00．伤害计算.07．伤害类型转换")
local registerDamageTypeConversion = ____require_result_7.registerDamageTypeConversion
local ____require_result_8 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_8.registerManualBuff
local getBuffRuntime = ____require_result_8.getBuffRuntime
local ____require_result_9 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.04．影骨莫特斯")
_____5F71_9AA8_83AB_7279_65AFBuffID = ____require_result_9["影骨莫特斯BuffID"]
local _____5F71_9AA8_5355_4F4D_7C7B_578BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____9AB8_9AA8_53EC_5524_6280_80FDID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["骸骨召唤"])
local _____9AB7_9AC5_76D7_8D3CID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["骷髅盗贼单位类型"])
_____9AB8_9AA8_6218_58EBID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["骸骨战士单位类型"])
local _____5DF2_6CE8_518C_9AB8_9AA8_53EC_5524 = false
local function _____968F_673A_53D6_5F71_9AA8_97F3_6548_8DEF_5F84(list)
    local count = #list
    if count <= 0 then
        return ""
    end
    if count == 1 then
        return list[1]
    end
    return list[GetRandomInt(0, count - 1) + 1]
end
local _____5DF2_6CE8_518C_9AB7_9AC5_5077_7A83 = false
local _____5DF2_6CE8_518C_9AB7_9AC5_4F24_5BB3_8F6C_6362 = false
_____5F71_9AA8_53EC_5524_7269_4E0A_4E0B_6587_8868 = {}
local _____9AB8_9AA8_7B26_5492_5C5E_6027_6548_679C_8868 = {}
local function ____on_5F71_9AA8_9AB7_9AC5_5077_7A83_4FEE_6B63(damageContext)
    local ____temp_10
    if damageContext.originalAttacker ~= nil and damageContext.originalAttacker ~= 0 then
        ____temp_10 = damageContext.originalAttacker
    else
        ____temp_10 = damageContext.attacker
    end
    local attacker = ____temp_10
    local target = damageContext.target
    local context = _____5F71_9AA8_53EC_5524_7269_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(attacker)]
    if context == nil or not _____5355_4F4D_6709_6548(attacker) or not _____5355_4F4D_6709_6548(target) or damageContext.isNormalAttack ~= true then
        return damageContext.currentDamage
    end
    local owner = GetOwningPlayer(target)
    local gold = GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD)
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]
    local stolen = cfg["偷金币固定值"] + gold * cfg["偷金币当前比例"]
    local nextGold = gold - stolen
    SetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD, nextGold > 0 and nextGold or 0)
    if gold < GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE) then
        return damageContext.currentDamage + _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(context["Boss单位"], target, {["来源攻击力比例"] = cfg["贫血惩罚Boss攻击力比例"], ["目标最大生命比例"] = cfg["贫血惩罚目标最大生命比例"]})
    end
    return damageContext.currentDamage
end
local function _____786E_4FDD_9AB7_9AC5_5077_7A83_4FEE_6B63()
    if _____5DF2_6CE8_518C_9AB7_9AC5_5077_7A83 then
        return
    end
    _____5DF2_6CE8_518C_9AB7_9AC5_5077_7A83 = true
    registerDamageBaseModifier(____on_5F71_9AA8_9AB7_9AC5_5077_7A83_4FEE_6B63, 50)
end
local function ____on_5F71_9AA8_9AB7_9AC5_4F24_5BB3_7C7B_578B_8F6C_6362(damageContext)
    local ____temp_11
    if damageContext.originalAttacker ~= nil and damageContext.originalAttacker ~= 0 then
        ____temp_11 = damageContext.originalAttacker
    else
        ____temp_11 = damageContext.attacker
    end
    local attacker = ____temp_11
    if not _____5355_4F4D_6709_6548(attacker) or damageContext.isNormalAttack ~= true then
        return nil
    end
    if damageContext.rawDamageType ~= DAMAGE_TYPE_NORMAL then
        return nil
    end
    local context = _____5F71_9AA8_53EC_5524_7269_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(attacker)]
    if context == nil or not context["幽影爆发中"] then
        return nil
    end
    local empowered = getBuffRuntime(attacker, _____5F71_9AA8_83AB_7279_65AFBuffID["暗影强化"])
    if empowered == nil then
        return nil
    end
    return {reapplyDamage = {
        damageType = DAMAGE_TYPE_SHADOW_STRIKE,
        attack = true,
        ranged = damageContext.isRangedAttack == true,
        attackType = damageContext.rawAttackType,
        weaponType = damageContext.rawWeaponType
    }}
end
local function _____786E_4FDD_9AB7_9AC5_4F24_5BB3_7C7B_578B_8F6C_6362()
    if _____5DF2_6CE8_518C_9AB7_9AC5_4F24_5BB3_8F6C_6362 then
        return
    end
    _____5DF2_6CE8_518C_9AB7_9AC5_4F24_5BB3_8F6C_6362 = true
    registerDamageTypeConversion(____on_5F71_9AA8_9AB7_9AC5_4F24_5BB3_7C7B_578B_8F6C_6362, 60)
end
local function _____6E05_9664_9AB8_9AA8_7B26_5492_5C5E_6027_6548_679C(unit)
    if unit == nil or unit == 0 then
        return
    end
    local id = GetHandleId(unit) or 0
    if id == 0 then
        return
    end
    local effect = _____9AB8_9AA8_7B26_5492_5C5E_6027_6548_679C_8868[id]
    __TS__Delete(_____9AB8_9AA8_7B26_5492_5C5E_6027_6548_679C_8868, id)
    if effect ~= nil then
        effect["清除"]()
    end
end
local function ____on_9AB8_9AA8_7B26_5492Buff_79FB_9664(unit, _buffID, _row)
    _____6E05_9664_9AB8_9AA8_7B26_5492_5C5E_6027_6548_679C(unit)
end
local function _____65BD_52A0_9AB8_9AA8_7B26_5492_5C5E_6027_6548_679C(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return
    end
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]
    _____6E05_9664_9AB8_9AA8_7B26_5492_5C5E_6027_6548_679C(unit)
    local _____9B54_6297_5C5E_6027_7C7B_578B = IsUnitType(unit, UNIT_TYPE_HERO) and "玩家属性" or "单位属性"
    local _____5C5E_6027_9879 = {{["类型"] = "护甲", ["数值"] = cfg["符咒护甲提升"]}, {["类型"] = _____9B54_6297_5C5E_6027_7C7B_578B, ["属性名"] = "魔抗", ["数值"] = cfg["符咒魔抗提升"]}}
    local effect = _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, cfg["符咒Buff持续秒"] * 1000, _____5C5E_6027_9879)
    local id = GetHandleId(unit) or 0
    if id ~= 0 and effect["是否激活"]() then
        _____9AB8_9AA8_7B26_5492_5C5E_6027_6548_679C_8868[id] = effect
    end
end
local function _____5F71_9AA8_7B26_5492_53EF_62FE_53D6_5355_4F4D(variable)
    if variable == nil or not _____5355_4F4D_6709_6548(variable.context["Boss单位"]) then
        return {}
    end
    return _____83B7_53D6Boss_6280_80FD_654C_5BF9_76EE_6807_5217_8868(variable.context["Boss单位"])
end
local function _____5F71_9AA8_7B26_5492_62FE_53D6(hero, ______5B9E_4F8B, _variable)
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骸骨符咒拾取"],
        X = GetUnitX(hero),
        Y = GetUnitY(hero),
        ["持续秒"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["瞬时特效持续秒"]
    })
    registerManualBuff(
        hero,
        _____5F71_9AA8_83AB_7279_65AFBuffID["骸骨符咒"],
        cfg["符咒Buff持续秒"],
        cfg["符咒护甲提升"],
        {effectValue2 = cfg["符咒魔抗提升"], sourceName = "影骨-骸骨符咒", onRemove = ____on_9AB8_9AA8_7B26_5492Buff_79FB_9664}
    )
    _____65BD_52A0_9AB8_9AA8_7B26_5492_5C5E_6027_6548_679C(hero)
end
local function _____521B_5EFA_9AB8_9AA8_7B26_5492(context, x, y)
    _____521B_5EFA_6218_6597_5185_62FE_53D6_7269({
        ["清理"] = context["清理"],
        ["名称"] = "影骨-骸骨符咒",
        X = x,
        Y = y,
        ["模型路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骸骨符咒掉落"],
        ["持续秒"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["符咒持续秒"],
        ["拾取半径"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["符咒拾取半径"],
        ["变量"] = {context = context},
        ["可拾取单位列表"] = _____5F71_9AA8_7B26_5492_53EF_62FE_53D6_5355_4F4D,
        ["on拾取"] = _____5F71_9AA8_7B26_5492_62FE_53D6
    })
end
local function _____5F71_9AA8_9AB8_9AA8_6218_58EB_91CD_7EC4(variable)
    if variable == nil or not _____5355_4F4D_6709_6548(variable.context["Boss单位"]) then
        return
    end
    local context = variable.context
    local angle = GetRandomReal(0, 360)
    local x = _____6781_5750_6807X(
        GetUnitX(context["Boss单位"]),
        _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["召唤偏移半径"],
        angle
    )
    local y = _____6781_5750_6807Y(
        GetUnitY(context["Boss单位"]),
        _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["召唤偏移半径"],
        angle
    )
    ____exports["创建影骨召唤物"](context, _____9AB8_9AA8_6218_58EBID, x, y)
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骸骨战士重组"], X = x, Y = y, ["持续秒"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["瞬时特效持续秒"]})
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____968F_673A_53D6_5F71_9AA8_97F3_6548_8DEF_5F84(_____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["骸骨召唤"]["骸骨战士重组列表"]),
        x,
        y,
        _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
end
local function _____5F71_9AA8_53EC_5524_7269_6B7B_4EA1(unit, _killer, _group, variable)
    _____6E05_9664_5F71_9AA8_53EC_5524_7269_767B_8BB0(unit)
    local groupVariable = variable
    if groupVariable == nil then
        return
    end
    local context = groupVariable.context
    _____521B_5EFA_9AB8_9AA8_7B26_5492(
        context,
        GetUnitX(unit),
        GetUnitY(unit)
    )
end
local function _____5F71_9AA8_53EC_5524_7EC4_5168_90E8_6B7B_4EA1(_group, variable)
    local groupVariable = variable
    if groupVariable == nil or not groupVariable["允许重组"] or groupVariable["重组已安排"] or groupVariable["阶段"] >= 3 then
        return
    end
    local context = groupVariable.context
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    groupVariable["重组已安排"] = true
    local id = addDelayedCallback(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["重组延迟秒"] * 1000, _____5F71_9AA8_9AB8_9AA8_6218_58EB_91CD_7EC4, {context = context})
    local ____self_12 = context["清理"]
    ____self_12["登记延迟回调"](____self_12, "影骨-骸骨重组", id)
end
____exports["创建影骨召唤组"] = function(context, _____9636_6BB5, _____5141_8BB8_91CD_7EC4, _____9884_671F_6570_91CF)
    if _____9636_6BB5 == nil then
        _____9636_6BB5 = context["阶段"]
    end
    if _____5141_8BB8_91CD_7EC4 == nil then
        _____5141_8BB8_91CD_7EC4 = true
    end
    if _____9884_671F_6570_91CF == nil then
        _____9884_671F_6570_91CF = 4
    end
    local groupVariable = {context = context, ["阶段"] = _____9636_6BB5, ["允许重组"] = _____5141_8BB8_91CD_7EC4, ["重组已安排"] = false}
    local group = _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001({
        ["清理"] = context["清理"],
        ["名称"] = "影骨-骸骨召唤组",
        ["变量"] = groupVariable,
        ["on单位死亡"] = _____5F71_9AA8_53EC_5524_7269_6B7B_4EA1,
        ["on全部死亡"] = _____5F71_9AA8_53EC_5524_7EC4_5168_90E8_6B7B_4EA1
    })
    group["开始批次"](group, _____9884_671F_6570_91CF)
    return group
end
local function _____53EC_5524_5F71_9AA8_9AB7_9AC5(context, group, count)
    local soundX = GetUnitX(context["Boss单位"])
    local soundY = GetUnitY(context["Boss单位"])
    do
        local i = 0
        while i < count do
            local angle = GetRandomReal(0, 360)
            local dist = GetRandomReal(80, _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["召唤偏移半径"])
            local x = _____6781_5750_6807X(
                GetUnitX(context["Boss单位"]),
                dist,
                angle
            )
            local y = _____6781_5750_6807Y(
                GetUnitY(context["Boss单位"]),
                dist,
                angle
            )
            if i == 0 then
                soundX = x
                soundY = y
            end
            _____521B_5EFA_70B9_7279_6548({["模型路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骸骨召唤预警"], X = x, Y = y, ["持续秒"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["瞬时特效持续秒"]})
            ____exports["创建影骨召唤物"](
                context,
                _____9AB7_9AC5_76D7_8D3CID,
                x,
                y,
                group
            )
            i = i + 1
        end
    end
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["骸骨召唤"]["骷髅盗贼出生"], soundX, soundY, _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
end
____exports["释放影骨骸骨召唤"] = function(context)
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return nil
    end
    if context["骸骨召唤组合执行器"] == nil then
        context["骸骨召唤组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "影骨莫特斯-骸骨召唤", ["清理"] = context["清理"], ["互斥组"] = "影骨莫特斯骸骨召唤"})
    end
    local ____self_13 = context["骸骨召唤组合执行器"]
    if ____self_13["是否运行中"](____self_13) then
        return nil
    end
    local group = ____exports["创建影骨召唤组"](context, context["阶段"], true, 4)
    local ____self_14 = context["骸骨召唤组合执行器"]
    local _____6267_884CID = ____self_14["开始"](
        ____self_14,
        {
            key = "骸骨召唤",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = 3000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868({
                {
                    ["时点毫秒"] = 1000,
                    ["名称"] = "骸骨召唤第二批",
                    ["执行"] = function()
                        _____53EC_5524_5F71_9AA8_9AB7_9AC5(context, group, 1)
                    end
                },
                {
                    ["时点毫秒"] = 2000,
                    ["名称"] = "骸骨召唤第三批",
                    ["执行"] = function()
                        _____53EC_5524_5F71_9AA8_9AB7_9AC5(context, group, 1)
                        group["结束批次"](group)
                    end
                }
            })
        }
    )
    if _____6267_884CID == 0 then
        group["销毁"](group)
        return nil
    end
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "影骨-骸骨召唤",
        ["施法者"] = boss,
        ["硬直秒"] = 3,
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["恢复动画编号"] = _____5F71_9AA8_83AB_7279_65AF_6A21_578B_52A8_753B_914D_7F6E["战斗待机编号"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = 3,
            ["颜色ID"] = 4,
            ["标题文本"] = "骸骨召唤",
            ["提示文本"] = "莫特斯正在分批唤醒骸骨盗贼"
        },
        ["清理"] = context["清理"],
        ["播放台词"] = function()
            _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(boss, "骸骨召唤")
        end,
        ["on生效"] = function()
        end
    })
    context["当前召唤组"] = group
    _____53EC_5524_5F71_9AA8_9AB7_9AC5(context, group, 2)
    return group
end
local function ____on_5F71_9AA8_9AB8_9AA8_53EC_5524_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____9AB8_9AA8_53EC_5524_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5F71_9AA8_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context ~= nil then
        ____exports["释放影骨骸骨召唤"](context)
    end
end
____exports["注册影骨莫特斯骸骨召唤"] = function()
    if _____5DF2_6CE8_518C_9AB8_9AA8_53EC_5524 then
        return
    end
    _____5DF2_6CE8_518C_9AB8_9AA8_53EC_5524 = true
    _____786E_4FDD_9AB7_9AC5_5077_7A83_4FEE_6B63()
    _____786E_4FDD_9AB7_9AC5_4F24_5BB3_7C7B_578B_8F6C_6362()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "04．骸骨召唤",
        ["单位类型ID"] = _____5F71_9AA8_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____9AB8_9AA8_53EC_5524_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5F71_9AA8_9AB8_9AA8_53EC_5524_65BD_6CD5(boss, _____9AB8_9AA8_53EC_5524_6280_80FDID)
        end
    })
end
return ____exports
