--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.00．配置")
local _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["卡瑟拉单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建卡瑟拉上下文"]
local _____53D6_73A9_5BB6_89E6_624B_6B8B_7247 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["取玩家触手残片"]
local _____5237_65B0_5361_745F_62C9_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新卡瑟拉阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local _____5361_745F_62C9_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉音效配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____14_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5750_6807_89D2_5EA6 = ____14_FF0E_516C_5171_5DE5_5177["取坐标角度"]
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____14_FF0E_516C_5171_5DE5_5177["点到线段距离平方"]
local _____8DDD_79BB_5E73_65B9XY = ____14_FF0E_516C_5171_5DE5_5177["距离平方XY"]
local _____64AD_653E_5361_745F_62C9_9650_65F6_52A8_4F5C = ____14_FF0E_516C_5171_5DE5_5177["播放卡瑟拉限时动作"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitFacing = jass.SetUnitFacing
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.13．属性抗性门槛")
local _____53D6_5355_4F4D_5C5E_6027_6297_6027 = ____require_result_5["取单位属性抗性"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_6["开始击退"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____65BD_52A0_7729_6655 = ____require_result_7["施加眩晕"]
local _____5361_745F_62C9_5355_4F4D_7C7B_578BID = stringToFourCC(_____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____9AD8_538B_6C34_70AE_6280_80FDID = stringToFourCC(_____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["高压水炮"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____9009_62E9_6700_8FDC_73A9_5BB6(boss)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    local best = nil
    local bestDist = -1
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue4
                end
                local dist = _____8DDD_79BB_5E73_65B9XY(
                    bx,
                    by,
                    GetUnitX(hero),
                    GetUnitY(hero)
                )
                if dist > bestDist then
                    bestDist = dist
                    best = hero
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
    return best
end
local function _____73A9_5BB6_6C34_6297_8FBE_6807(context, hero)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["高压水炮"]
    local fragmentResist = _____53D6_73A9_5BB6_89E6_624B_6B8B_7247(context, hero) * _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]["水抗加成"]
    return _____53D6_5355_4F4D_5C5E_6027_6297_6027(hero, "水", true) + fragmentResist >= cfg["水抗门槛"]
end
local function _____64AD_653E_6C34_70AE_8DEF_5F84_7279_6548(context, startX, startY, angle)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["高压水炮"]
    local distance = cfg["路径水花间隔"]
    while distance <= cfg["距离"] do
        local effect = AddSpecialEffect(
            cfg["路径水花模型路径"],
            _____6781_5750_6807X(startX, angle, distance),
            _____6781_5750_6807Y(startY, angle, distance)
        )
        DestroyEffect(effect)
        distance = distance + cfg["路径水花间隔"]
    end
end
local function _____7ED3_7B97_9AD8_538B_6C34_70AE(context, startX, startY, angle)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["高压水炮"]
    local endX = _____6781_5750_6807X(startX, angle, cfg["距离"])
    local endY = _____6781_5750_6807Y(startY, angle, cfg["距离"])
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local radius2 = cfg["宽度"] * 0.5 * (cfg["宽度"] * 0.5)
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["Boss攻击力比例"]
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5361_745F_62C9_97F3_6548_914D_7F6E["高压水炮"]["发射"], startX, startY, _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"])
    _____64AD_653E_6C34_70AE_8DEF_5F84_7279_6548(context, startX, startY, angle)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue13
                end
                if _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                    GetUnitX(hero),
                    GetUnitY(hero),
                    startX,
                    startY,
                    endX,
                    endY
                ) > radius2 then
                    goto __continue13
                end
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____9AD8_538B_6C34_70AE_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = damage,
                    attack = true,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
                if _____73A9_5BB6_6C34_6297_8FBE_6807(context, hero) then
                    goto __continue13
                end
                _____5F00_59CB_51FB_9000(
                    hero,
                    {
                        ["来源单位"] = boss,
                        ["距离"] = cfg["距离"],
                        ["每秒速度"] = 1500,
                        ["检查地形"] = true,
                        ["暂停单位"] = true,
                        ["结束回调"] = function(movedUnit)
                            if _____5355_4F4D_6709_6548(movedUnit) then
                                _____65BD_52A0_7729_6655(boss, movedUnit, cfg["击退到边缘眩晕秒"])
                            end
                        end
                    }
                )
            end
            ::__continue13::
            i = i + 1
        end
    end
end
____exports["释放卡瑟拉高压水炮"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["Boss潜入中"] then
        return
    end
    if _____5237_65B0_5361_745F_62C9_9636_6BB5(context) < 2 then
        return
    end
    local target = _____9009_62E9_6700_8FDC_73A9_5BB6(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["高压水炮"]
    _____64AD_653E_5361_745F_62C9_9650_65F6_52A8_4F5C(boss, cfg["动画编号"], cfg["动画速度"], cfg["前摇秒"])
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local angle = _____53D6_5750_6807_89D2_5EA6(
        startX,
        startY,
        GetUnitX(target),
        GetUnitY(target)
    )
    local centerX = _____6781_5750_6807X(startX, angle, cfg["距离"] * 0.5)
    local centerY = _____6781_5750_6807Y(startY, angle, cfg["距离"] * 0.5)
    SetUnitFacing(boss, angle)
    _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "高压水炮")
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = centerX,
        Y = centerY,
        ["宽度"] = cfg["宽度"],
        ["长度"] = cfg["距离"],
        ["朝向"] = angle,
        ["持续时间"] = cfg["前摇秒"],
        ["来源单位"] = boss
    })
    local id = addDelayedCallback(
        cfg["前摇秒"] * 1000,
        function()
            _____7ED3_7B97_9AD8_538B_6C34_70AE(context, startX, startY, angle)
        end
    )
    local ____self_8 = context["清理"]
    ____self_8["登记延迟回调"](____self_8, "卡瑟拉-高压水炮结算", id)
end
local function ____on_5361_745F_62C9_9AD8_538B_6C34_70AE_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____9AD8_538B_6C34_70AE_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5361_745F_62C9_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放卡瑟拉高压水炮"](context)
end
____exports["注册卡瑟拉高压水炮"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "07．高压水炮",
        ["单位类型ID"] = _____5361_745F_62C9_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____9AD8_538B_6C34_70AE_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5361_745F_62C9_9AD8_538B_6C34_70AE_65BD_6CD5(boss, _____9AD8_538B_6C34_70AE_6280_80FDID)
        end
    })
end
return ____exports
