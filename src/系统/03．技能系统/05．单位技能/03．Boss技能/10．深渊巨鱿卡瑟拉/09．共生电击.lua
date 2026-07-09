--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____6D88_8017_73A9_5BB6_89E6_624B_6B8B_7247 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["消耗玩家触手残片"]
local _____5237_65B0_5361_745F_62C9_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新卡瑟拉阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local _____5361_745F_62C9_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉音效配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____8DDD_79BB_5E73_65B9XY = ____14_FF0E_516C_5171_5DE5_5177["距离平方XY"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____06_FF0E_52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.06．动态装饰物安全区组")
local _____521B_5EFA_52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4 = ____06_FF0E_52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4["创建动态装饰物安全区组"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["创建独立技能伤害实例"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_3["施加快速控制Buff"]
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local ____require_result_5 = require("系统.05．Buff系统.03．Buff表.01．Boss.08．卡瑟拉")
local _____5361_745F_62C9BuffID = ____require_result_5["卡瑟拉BuffID"]
local function _____64AD_653E_70B9_7279_6548(model, x, y)
    if model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    DestroyEffect(effect)
end
local function _____64AD_653E_5355_4F4D_7279_6548(model, unit)
    if model == "" or not _____5355_4F4D_6709_6548(unit) then
        return
    end
    local effect = AddSpecialEffectTarget(model, unit, "origin")
    DestroyEffect(effect)
end
local function _____786E_4FDD_7EDD_7F18_73CA_745A(context)
    if context["绝缘珊瑚安全区组"] ~= nil and #context["绝缘珊瑚列表"] > 0 then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    local _____70B9_4F4D_5217_8868 = {}
    do
        local i = 0
        while i < cfg["珊瑚数量"] do
            local angle = i * 120 + 40
            local x = _____6781_5750_6807X(bx, angle, cfg["珊瑚距离"])
            local y = _____6781_5750_6807Y(by, angle, cfg["珊瑚距离"])
            _____70B9_4F4D_5217_8868[#_____70B9_4F4D_5217_8868 + 1] = {
                ID = "绝缘珊瑚" .. tostring(i + 1),
                X = x,
                Y = y,
                ["半径"] = cfg["安全半径"],
                ["朝向"] = angle
            }
            i = i + 1
        end
    end
    local _____5B89_5168_533A_7EC4 = _____521B_5EFA_52A8_6001_88C5_9970_7269_5B89_5168_533A_7EC4({
        ["清理"] = context["清理"],
        ["名称"] = "卡瑟拉-绝缘珊瑚",
        ["装饰物ID"] = cfg["珊瑚装饰物ID"],
        ["点位列表"] = _____70B9_4F4D_5217_8868,
        ["默认模型路径"] = cfg["珊瑚模型路径"],
        ["缩放"] = cfg["珊瑚缩放"],
        ["来源单位"] = boss
    })
    context["绝缘珊瑚安全区组"] = _____5B89_5168_533A_7EC4
    local _____5B89_5168_533A_5217_8868 = _____5B89_5168_533A_7EC4["取列表"](_____5B89_5168_533A_7EC4)
    context["绝缘珊瑚列表"] = {}
    do
        local i = 0
        while i < #_____5B89_5168_533A_5217_8868 do
            local _____533A = _____5B89_5168_533A_5217_8868[i + 1]
            local ____context__7EDD_7F18_73CA_745A_5217_8868_6 = context["绝缘珊瑚列表"]
            ____context__7EDD_7F18_73CA_745A_5217_8868_6[#____context__7EDD_7F18_73CA_745A_5217_8868_6 + 1] = {X = _____533A.X, Y = _____533A.Y, ["半径"] = _____533A["半径"], ["装饰单位"] = _____533A["装饰物"]}
            i = i + 1
        end
    end
end
local function _____73A9_5BB6_5728_7EDD_7F18_73CA_745A_5185(context, hero)
    if context["绝缘珊瑚安全区组"] ~= nil then
        local ____self_7 = context["绝缘珊瑚安全区组"]
        return ____self_7["单位是否安全"](____self_7, hero)
    end
    local hx = GetUnitX(hero)
    local hy = GetUnitY(hero)
    do
        local i = 0
        while i < #context["绝缘珊瑚列表"] do
            local coral = context["绝缘珊瑚列表"][i + 1]
            if _____8DDD_79BB_5E73_65B9XY(hx, hy, coral.X, coral.Y) <= coral["半径"] * coral["半径"] then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____9884_8B66_7EDD_7F18_73CA_745A(context)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]
    if context["绝缘珊瑚安全区组"] ~= nil then
        local ____self_8 = context["绝缘珊瑚安全区组"]
        ____self_8["显示提示"](____self_8, cfg["预警秒"])
    end
end
local function _____7ED3_7B97_5361_745F_62C9_5171_751F_7535_51FB(context, _____6280_80FD_5B9E_4F8BID)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["Boss潜入中"] then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5361_745F_62C9_97F3_6548_914D_7F6E["共生电击"]["爆发"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____64AD_653E_70B9_7279_6548(
        cfg["全屏命中特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue23
                end
                if _____73A9_5BB6_5728_7EDD_7F18_73CA_745A_5185(context, hero) then
                    registerManualBuff(
                        hero,
                        _____5361_745F_62C9BuffID["绝缘庇护"],
                        cfg["麻痹秒"],
                        1,
                        {sourceName = "卡瑟拉-绝缘庇护"}
                    )
                    goto __continue23
                end
                if _____6D88_8017_73A9_5BB6_89E6_624B_6B8B_7247(context, hero, cfg["抵消残片数"]) then
                    goto __continue23
                end
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = cfg["雷伤害"],
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_LIGHTNING,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能",
                    ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                    ["标签"] = "卡瑟拉共生电击"
                })
                _____64AD_653E_5355_4F4D_7279_6548(cfg["麻痹命中特效路径"], hero)
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, hero, 0, cfg["麻痹秒"])
                registerManualBuff(
                    hero,
                    _____5361_745F_62C9BuffID["麻痹电流"],
                    cfg["麻痹秒"],
                    1,
                    {sourceName = "卡瑟拉-麻痹电流"}
                )
            end
            ::__continue23::
            i = i + 1
        end
    end
end
____exports["尝试释放卡瑟拉共生电击"] = function(context, nowMs)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["Boss潜入中"] then
        return
    end
    if _____5237_65B0_5361_745F_62C9_9636_6BB5(context) < 3 then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]
    _____786E_4FDD_7EDD_7F18_73CA_745A(context)
    if context["下次共生电击时间"] <= 0 then
        context["下次共生电击时间"] = nowMs + cfg["间隔秒"] * 1000
        return
    end
    if nowMs < context["下次共生电击时间"] then
        return
    end
    context["下次共生电击时间"] = nowMs + cfg["间隔秒"] * 1000
    _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "共生电击")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5361_745F_62C9_97F3_6548_914D_7F6E["共生电击"]["预警"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["标识"],
        ["音效路径列表"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["音效路径列表"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["裁断距离"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"],
        ["冷却Ms"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["关键机制触发概率百分比"]
    })
    _____64AD_653E_70B9_7279_6548(
        cfg["蓄力特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    _____9884_8B66_7EDD_7F18_73CA_745A(context)
    local _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "卡瑟拉共生电击", ["持续时间秒"] = cfg["预警秒"] + 2})
    local id = addDelayedCallback(
        cfg["预警秒"] * 1000,
        function()
            _____7ED3_7B97_5361_745F_62C9_5171_751F_7535_51FB(context, _____6280_80FD_5B9E_4F8BID)
        end
    )
    local ____self_9 = context["清理"]
    ____self_9["登记延迟回调"](____self_9, "卡瑟拉-共生电击结算", id)
end
____exports["注册卡瑟拉共生电击"] = function()
end
return ____exports
