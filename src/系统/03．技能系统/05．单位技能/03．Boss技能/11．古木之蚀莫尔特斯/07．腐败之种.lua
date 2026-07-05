--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8D1D_585E_5C14_4F4D_7F6E, _____83AB_5C14_7279_65AF_8150_8D25_5E7C_6811_6CE2_52A8, _____83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_6210_957F, _____521B_5EFA_8150_8D25_5E7C_6811, _____5E7C_6811_6CE2_52A8Tick, _____521B_5EFA_843D_5730_79CD_5B50, _____5F39_9053Tick, _____9020_6210AOE_6280_80FD_4F24_5BB3, GetUnitX, GetUnitY, GetOwningPlayer, DestroyEffect, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS, EXSetEffectXY, EXSetEffectZ, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime, _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____8BFB_53D6_5355_4F4D_653B_51FB_529B
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建莫尔特斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.03．腐败值与根须领域")
local _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C = ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF["应用莫尔特斯腐败值"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____53D6_5750_6807_89D2_5EA6 = ____16_FF0E_516C_5171_5DE5_5177["取坐标角度"]
local _____6781_5750_6807X = ____16_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____16_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local stringToFourCC = ____16_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____8D1D_585E_5C14_4F4D_7F6E(a, b, c, t)
    local u = 1 - t
    return u * u * a + 2 * u * t * b + t * t * c
end
function _____83AB_5C14_7279_65AF_8150_8D25_5E7C_6811_6CE2_52A8(variable)
    local data = variable
    if data == nil then
        return
    end
    _____5E7C_6811_6CE2_52A8Tick(data)
end
function _____83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_6210_957F(variable)
    local data = variable
    if data == nil then
        return
    end
    local ____self_5 = data.seed
    if not ____self_5["是否存活"](____self_5) then
        return
    end
    local ____self_6 = data.seed
    ____self_6["销毁"](____self_6)
    _____521B_5EFA_8150_8D25_5E7C_6811(data.context, data.x, data.y)
end
function _____521B_5EFA_8150_8D25_5E7C_6811(context, x, y)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败幼树",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["幼树单位类型"],
        ["模型路径"] = cfg["幼树模型路径"],
        X = x,
        Y = y,
        ["最大生命"] = cfg["幼树生命值"],
        ["缩放"] = cfg["幼树缩放"],
        ["持续时间"] = cfg["持续秒"]
    })
    if instance == nil or not _____5355_4F4D_6709_6548(instance["单位"]) then
        return
    end
    local data = {context = context, ["幼树单位"] = instance["单位"], ["剩余跳数"] = cfg["持续秒"] / cfg["波动间隔秒"], ["周期ID"] = 0}
    data["周期ID"] = addPeriodicCallback(cfg["波动间隔秒"] * 1000, _____83AB_5C14_7279_65AF_8150_8D25_5E7C_6811_6CE2_52A8, data)
    local ____self_7 = context["清理"]
    ____self_7["登记周期回调"](____self_7, "莫尔特斯-腐败幼树波动", data["周期ID"])
end
function _____5E7C_6811_6CE2_52A8Tick(data)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]
    local boss = data.context["Boss单位"]
    local tree = data["幼树单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(tree) or data["剩余跳数"] <= 0 then
        removePeriodicCallback(data["周期ID"])
        return
    end
    data["剩余跳数"] = data["剩余跳数"] - 1
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["每跳Boss攻击力比例"]
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue15
                end
                local dx = GetUnitX(hero) - GetUnitX(tree)
                local dy = GetUnitY(hero) - GetUnitY(tree)
                if dx * dx + dy * dy > cfg["波动半径"] * cfg["波动半径"] then
                    goto __continue15
                end
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = damage,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_PLANT,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
                _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C(data.context, hero, cfg["每跳腐败值"])
            end
            ::__continue15::
            i = i + 1
        end
    end
end
function _____521B_5EFA_843D_5730_79CD_5B50(context, x, y)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]
    local seed = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败种子",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["种子单位类型"],
        ["模型路径"] = cfg["投射物模型路径"],
        X = x,
        Y = y,
        ["最大生命"] = cfg["种子生命值"],
        ["缩放"] = 0.85,
        ["持续时间"] = cfg["生长延迟秒"] + 1
    })
    if seed == nil then
        return
    end
    local id = addDelayedCallback(cfg["生长延迟秒"] * 1000, _____83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_6210_957F, {context = context, seed = seed, x = x, y = y})
    local ____self_8 = context["清理"]
    ____self_8["登记延迟回调"](____self_8, "莫尔特斯-腐败种子成长", id)
end
function _____5F39_9053Tick(data)
    local now = getServerTime()
    local t = (now - data["起始时间"]) / data["持续毫秒"]
    if t >= 1 then
        t = 1
    end
    if t < 0 then
        t = 0
    end
    local x = _____8D1D_585E_5C14_4F4D_7F6E(data["起点X"], data["中点X"], data["终点X"], t)
    local y = _____8D1D_585E_5C14_4F4D_7F6E(data["起点Y"], data["中点Y"], data["终点Y"], t)
    if EXSetEffectXY ~= nil then
        EXSetEffectXY(data["特效"], x, y)
    end
    if EXSetEffectZ ~= nil then
        EXSetEffectZ(data["特效"], _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]["弧线高度"] * (1 - (t - 0.5) * (t - 0.5) * 4))
    end
    if t >= 1 then
        removePeriodicCallback(data["周期ID"])
        DestroyEffect(data["特效"])
        _____521B_5EFA_843D_5730_79CD_5B50(data.context, data["终点X"], data["终点Y"])
    end
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetOwningPlayer = jass.GetOwningPlayer
local AddSpecialEffect = jass.AddSpecialEffect
DestroyEffect = jass.DestroyEffect
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
EXSetEffectXY = japi.EXSetEffectXY
EXSetEffectZ = japi.EXSetEffectZ
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_1.addDelayedCallback
addPeriodicCallback = ____require_result_1.addPeriodicCallback
removePeriodicCallback = ____require_result_1.removePeriodicCallback
getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
_____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_2["创建可攻击机制单位"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_3["获取Boss技能随机敌对英雄"]
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____8150_8D25_4E4B_79CD_6280_80FDID = stringToFourCC(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD_5F39_9053(variable)
    local data = variable
    if data == nil then
        return
    end
    _____5F39_9053Tick(data)
end
local function _____53D1_5C04_8150_8D25_4E4B_79CD(context, target)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]
    local sx = GetUnitX(boss)
    local sy = GetUnitY(boss)
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    local angle = _____53D6_5750_6807_89D2_5EA6(sx, sy, tx, ty) + 90
    local distance = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根须领域"]["单格边长"] * cfg["中点偏移比例"]
    local midX = _____6781_5750_6807X((sx + tx) / 2, angle, distance)
    local midY = _____6781_5750_6807Y((sy + ty) / 2, angle, distance)
    local effect = AddSpecialEffect(cfg["投射物模型路径"], sx, sy)
    local data = {
        context = context,
        ["特效"] = effect,
        ["起点X"] = sx,
        ["起点Y"] = sy,
        ["中点X"] = midX,
        ["中点Y"] = midY,
        ["终点X"] = tx,
        ["终点Y"] = ty,
        ["起始时间"] = getServerTime(),
        ["持续毫秒"] = cfg["飞行秒"] * 1000,
        ["周期ID"] = 0
    }
    data["周期ID"] = addPeriodicCallback(50, _____83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD_5F39_9053, data)
    local ____self_9 = context["清理"]
    ____self_9["登记周期回调"](____self_9, "莫尔特斯-腐败之种弹道", data["周期ID"])
end
____exports["释放莫尔特斯腐败之种"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local spellTarget = GetSpellTargetUnit()
    local _____5355_4F4D_6709_6548_result_10
    if _____5355_4F4D_6709_6548(spellTarget) then
        _____5355_4F4D_6709_6548_result_10 = spellTarget
    else
        _____5355_4F4D_6709_6548_result_10 = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
    end
    local target = _____5355_4F4D_6709_6548_result_10
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "腐败之种")
    _____53D1_5C04_8150_8D25_4E4B_79CD(context, target)
end
local function ____on_83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8150_8D25_4E4B_79CD_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放莫尔特斯腐败之种"](context)
end
____exports["注册莫尔特斯腐败之种"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "07．腐败之种",
        ["单位类型ID"] = _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8150_8D25_4E4B_79CD_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD_65BD_6CD5(boss, _____8150_8D25_4E4B_79CD_6280_80FDID)
        end
    })
end
return ____exports
