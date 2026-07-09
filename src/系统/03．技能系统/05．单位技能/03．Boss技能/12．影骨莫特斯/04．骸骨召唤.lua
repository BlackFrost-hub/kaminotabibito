local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____968F_673A_53D6_5F71_9AA8_97F3_6548_8DEF_5F84, _____767B_8BB0_5F71_9AA8_53EC_5524_7269, _____6E05_9664_5F71_9AA8_53EC_5524_7269_767B_8BB0, _____5F71_9AA8_7B26_5492_53EF_62FE_53D6_5355_4F4D, _____5F71_9AA8_7B26_5492_62FE_53D6, _____521B_5EFA_9AB8_9AA8_7B26_5492, _____5F71_9AA8_9AB8_9AA8_6218_58EB_91CD_7EC4, _____5C1D_8BD5_91CD_7EC4_9AB8_9AA8_6218_58EB, _____5F71_9AA8_53EC_5524_7269_6B7B_4EA1, _____5F71_9AA8_53EC_5524_7269_9500_6BC1, GetUnitX, GetUnitY, GetOwningPlayer, GetRandomReal, GetRandomInt, AddSpecialEffect, IssueTargetOrder, addDelayedCallback, _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D, _____521B_5EFA_6218_6597_5185_62FE_53D6_7269, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, registerManualBuff, _____5F71_9AA8_83AB_7279_65AFBuffID, _____9AB8_9AA8_6218_58EBID, _____5F71_9AA8_53EC_5524_7269_4E0A_4E0B_6587_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建影骨莫特斯上下文"]
local _____5237_65B0_5F71_9AA8_83AB_7279_65AF_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新影骨莫特斯阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯音效配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.08．台词播放")
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放影骨莫特斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____6781_5750_6807X = ____11_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____11_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____53D6_5355_4F4DID = ____11_FF0E_516C_5171_5DE5_5177["取单位ID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
function _____968F_673A_53D6_5F71_9AA8_97F3_6548_8DEF_5F84(list)
    local count = #list
    if count <= 0 then
        return ""
    end
    if count == 1 then
        return list[1]
    end
    return list[GetRandomInt(0, count - 1) + 1]
end
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
function _____5F71_9AA8_7B26_5492_53EF_62FE_53D6_5355_4F4D(variable)
    if variable == nil or not _____5355_4F4D_6709_6548(variable.context["Boss单位"]) then
        return {}
    end
    return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(variable.context["Boss单位"])
end
function _____5F71_9AA8_7B26_5492_62FE_53D6(hero, ______5B9E_4F8B, _variable)
    AddSpecialEffect(
        _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骸骨符咒拾取"],
        GetUnitX(hero),
        GetUnitY(hero)
    )
    registerManualBuff(
        hero,
        _____5F71_9AA8_83AB_7279_65AFBuffID["骸骨符咒"],
        12,
        1,
        {sourceName = "影骨-骸骨符咒"}
    )
end
function _____521B_5EFA_9AB8_9AA8_7B26_5492(context, x, y)
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
function _____5F71_9AA8_9AB8_9AA8_6218_58EB_91CD_7EC4(variable)
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
    ____exports["创建影骨召唤物"](
        context,
        _____9AB8_9AA8_6218_58EBID,
        x,
        y,
        nil,
        false
    )
    AddSpecialEffect(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骸骨战士重组"], x, y)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____968F_673A_53D6_5F71_9AA8_97F3_6548_8DEF_5F84(_____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["骸骨召唤"]["骸骨战士重组列表"]),
        x,
        y,
        _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
end
function _____5C1D_8BD5_91CD_7EC4_9AB8_9AA8_6218_58EB(context, group)
    if group["已重组"] or group["阶段"] >= 3 or group["死亡数"] < group["总数"] then
        return
    end
    group["已重组"] = true
    local id = addDelayedCallback(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["重组延迟秒"] * 1000, _____5F71_9AA8_9AB8_9AA8_6218_58EB_91CD_7EC4, {context = context})
    local ____self_8 = context["清理"]
    ____self_8["登记延迟回调"](____self_8, "影骨-骸骨重组", id)
end
function _____5F71_9AA8_53EC_5524_7269_6B7B_4EA1(unit, _killer, variable)
    _____6E05_9664_5F71_9AA8_53EC_5524_7269_767B_8BB0(unit)
    if variable == nil then
        return
    end
    local context = variable.context
    _____521B_5EFA_9AB8_9AA8_7B26_5492(
        context,
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if variable.group ~= nil and variable.canReform then
        local ____variable_group_9, _____6B7B_4EA1_6570_10 = variable.group, "死亡数"
        ____variable_group_9[_____6B7B_4EA1_6570_10] = ____variable_group_9[_____6B7B_4EA1_6570_10] + 1
        _____5C1D_8BD5_91CD_7EC4_9AB8_9AA8_6218_58EB(context, variable.group)
    end
end
function _____5F71_9AA8_53EC_5524_7269_9500_6BC1(unit, variable)
    _____6E05_9664_5F71_9AA8_53EC_5524_7269_767B_8BB0(unit)
end
____exports["创建影骨召唤物"] = function(context, unitType, x, y, group, canReform)
    if canReform == nil then
        canReform = true
    end
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "影骨-骷髅召唤物",
        ["主人单位"] = context["Boss单位"],
        ["所属玩家"] = GetOwningPlayer(context["Boss单位"]),
        ["单位类型"] = unitType,
        X = x,
        Y = y,
        ["朝向"] = GetRandomReal(0, 360),
        ["最大生命"] = unitType == _____9AB8_9AA8_6218_58EBID and cfg["骸骨战士生命值"] or cfg["骷髅生命值"],
        ["持续时间"] = unitType == _____9AB8_9AA8_6218_58EBID and cfg["骸骨战士持续秒"] or cfg["骷髅持续秒"],
        ["变量"] = {context = context, group = group, canReform = canReform},
        ["on死亡"] = _____5F71_9AA8_53EC_5524_7269_6B7B_4EA1,
        ["on销毁"] = _____5F71_9AA8_53EC_5524_7269_9500_6BC1
    })
    if instance ~= nil and instance["单位"] ~= nil then
        _____767B_8BB0_5F71_9AA8_53EC_5524_7269(instance["单位"], context)
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
        AddSpecialEffect(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骷髅出生"], x, y)
    end
    return instance
end
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetOwningPlayer = jass.GetOwningPlayer
GetRandomReal = jass.GetRandomReal
GetRandomInt = jass.GetRandomInt
AddSpecialEffect = jass.AddSpecialEffect
IssueTargetOrder = jass.IssueTargetOrder
local GetPlayerState = jass.GetPlayerState
local SetPlayerState = jass.SetPlayerState
local GetUnitState = jass.GetUnitState
local PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
_____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_1["创建可攻击机制单位"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.06．战斗内拾取物")
_____521B_5EFA_6218_6597_5185_62FE_53D6_7269 = ____require_result_2["创建战斗内拾取物"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
_____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_3["获取Boss技能随机敌对英雄"]
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_4.registerDamageModifier
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_5.registerManualBuff
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.01．Boss.10．影骨莫特斯")
_____5F71_9AA8_83AB_7279_65AFBuffID = ____require_result_6["影骨莫特斯BuffID"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local _____5F71_9AA8_5355_4F4D_7C7B_578BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____9AB8_9AA8_53EC_5524_6280_80FDID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["骸骨召唤"])
local _____9AB7_9AC5_76D7_8D3CID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["骷髅盗贼单位类型"])
_____9AB8_9AA8_6218_58EBID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨召唤"]["骸骨战士单位类型"])
local _____5DF2_6CE8_518C_9AB8_9AA8_53EC_5524 = false
local _____5DF2_6CE8_518C_9AB7_9AC5_5077_7A83 = false
_____5F71_9AA8_53EC_5524_7269_4E0A_4E0B_6587_8868 = {}
local function ____on_5F71_9AA8_9AB7_9AC5_5077_7A83_4FEE_6B63(damageContext)
    local attacker = damageContext.attacker
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
    if gold < GetUnitState(target, UNIT_STATE_MAX_LIFE) then
        return damageContext.currentDamage + _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["Boss单位"]) * cfg["贫血惩罚Boss攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * cfg["贫血惩罚目标最大生命比例"]
    end
    return damageContext.currentDamage
end
local function _____786E_4FDD_9AB7_9AC5_5077_7A83_4FEE_6B63()
    if _____5DF2_6CE8_518C_9AB7_9AC5_5077_7A83 then
        return
    end
    _____5DF2_6CE8_518C_9AB7_9AC5_5077_7A83 = true
    registerDamageModifier(____on_5F71_9AA8_9AB7_9AC5_5077_7A83_4FEE_6B63, 50)
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
            AddSpecialEffect(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骸骨召唤预警"], x, y)
            ____exports["创建影骨召唤物"](
                context,
                _____9AB7_9AC5_76D7_8D3CID,
                x,
                y,
                group,
                true
            )
            i = i + 1
        end
    end
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["骸骨召唤"]["骷髅盗贼出生"], soundX, soundY, _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
end
local function _____5F71_9AA8_9AB8_9AA8_53EC_5524_5206_6BB5(variable)
    if variable == nil then
        return
    end
    _____53EC_5524_5F71_9AA8_9AB7_9AC5(variable.context, variable.group, variable.count)
end
____exports["释放影骨骸骨召唤"] = function(context)
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(context["Boss单位"], "骸骨召唤")
    local ____context_11, _____4E0B_4E00_4E2A_53EC_5524_7EC4ID_12 = context, "下一个召唤组ID"
    local ____context__4E0B_4E00_4E2A_53EC_5524_7EC4ID_13 = ____context_11[_____4E0B_4E00_4E2A_53EC_5524_7EC4ID_12] + 1
    ____context_11[_____4E0B_4E00_4E2A_53EC_5524_7EC4ID_12] = ____context__4E0B_4E00_4E2A_53EC_5524_7EC4ID_13
    local group = {
        ID = ____context__4E0B_4E00_4E2A_53EC_5524_7EC4ID_13,
        ["阶段"] = _____5237_65B0_5F71_9AA8_83AB_7279_65AF_9636_6BB5(context),
        ["总数"] = 4,
        ["死亡数"] = 0,
        ["已重组"] = false
    }
    context["当前召唤组"] = group
    _____53EC_5524_5F71_9AA8_9AB7_9AC5(context, group, 2)
    local ____self_14 = context["清理"]
    ____self_14["登记延迟回调"](
        ____self_14,
        "影骨-骸骨召唤2",
        addDelayedCallback(1000, _____5F71_9AA8_9AB8_9AA8_53EC_5524_5206_6BB5, {context = context, group = group, count = 1})
    )
    local ____self_15 = context["清理"]
    ____self_15["登记延迟回调"](
        ____self_15,
        "影骨-骸骨召唤3",
        addDelayedCallback(2000, _____5F71_9AA8_9AB8_9AA8_53EC_5524_5206_6BB5, {context = context, group = group, count = 1})
    )
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
