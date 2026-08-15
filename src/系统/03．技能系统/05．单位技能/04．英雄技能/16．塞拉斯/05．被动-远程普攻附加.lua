--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.00．配置")
local _____585E_62C9_65AF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞拉斯技能配置"]
local ____06_FF0E_585E_62C9_65AF = require("系统.05．Buff系统.03．Buff表.02．英雄.06．塞拉斯")
local _____585E_62C9_65AFBuffID = ____06_FF0E_585E_62C9_65AF["塞拉斯BuffID"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.01．状态表")
local _____6D88_8D39_585E_62C9_65AF_653B_51FB_6807_8BB0 = ____01_FF0E_72B6_6001_8868["消费塞拉斯攻击标记"]
local _____585E_62C9_65AF_62E5_6709_4EFB_610F_653B_51FB_6807_8BB0 = ____01_FF0E_72B6_6001_8868["塞拉斯拥有任意攻击标记"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_0.registerDamageCallback
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_1["造成批量AOE技能伤害"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_2["获取范围敌军"]
local _____5728_5750_6807_64AD_653E_7279_6548 = ____require_result_2["在坐标播放特效"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitAlly = jass.IsUnitAlly
local IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer
local GetUnitState = jass.GetUnitState
local SquareRoot = jass.SquareRoot
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local IsUnitType = jass.IsUnitType
local _____914D_7F6E = _____585E_62C9_65AF_6280_80FD_914D_7F6E
local _____88AB_52A8_914D_7F6E = _____914D_7F6E["被动"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local function _____4E24_70B9_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return SquareRoot(dx * dx + dy * dy)
end
local function _____8FC7_6EE4_88AB_52A8_8FFD_52A0_6807_7684(_____654C_519B_5217_8868)
    local result = {}
    do
        local i = 0
        while i < #_____654C_519B_5217_8868 do
            do
                local u = _____654C_519B_5217_8868[i + 1]
                if u == nil or u == 0 then
                    goto __continue5
                end
                if IsUnitType(u, UNIT_TYPE_ANCIENT) or IsUnitType(u, UNIT_TYPE_MECHANICAL) or IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                    goto __continue5
                end
                result[#result + 1] = u
            end
            ::__continue5::
            i = i + 1
        end
    end
    return result
end
local function _____6267_884C_88AB_52A8_8FFD_52A0_4F24_5BB3(variable)
    local payload = variable
    if payload == nil then
        return
    end
    local caster = payload.caster
    if caster == nil or caster == 0 or GetUnitTypeId(caster) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    if payload["火"] then
        _____5728_5750_6807_64AD_653E_7279_6548(
            _____88AB_52A8_914D_7F6E["火焰特效"]["模型路径"],
            payload["目标X"],
            payload["目标Y"],
            0,
            _____88AB_52A8_914D_7F6E["火焰特效"]["缩放"],
            _____88AB_52A8_914D_7F6E["火焰特效"]["持续秒"]
        )
    elseif payload["雷"] then
        _____5728_5750_6807_64AD_653E_7279_6548(
            _____88AB_52A8_914D_7F6E["雷击特效"]["模型路径"],
            payload["目标X"],
            payload["目标Y"],
            0,
            _____88AB_52A8_914D_7F6E["雷击特效"]["缩放"],
            _____88AB_52A8_914D_7F6E["雷击特效"]["持续秒"]
        )
    elseif payload["冰"] then
        _____5728_5750_6807_64AD_653E_7279_6548(
            _____88AB_52A8_914D_7F6E["冰冻特效"]["模型路径"],
            payload["目标X"],
            payload["目标Y"],
            0,
            _____88AB_52A8_914D_7F6E["冰冻特效"]["缩放"],
            _____88AB_52A8_914D_7F6E["冰冻特效"]["持续秒"]
        )
    else
        return
    end
    local _____4F24_5BB3 = GetUnitState(caster, UNIT_STATE_MANA) * _____88AB_52A8_914D_7F6E["当前魔法值伤害比例"]
    if not (_____4F24_5BB3 > 0) then
        return
    end
    local ____payload__706B_6
    if payload["火"] then
        ____payload__706B_6 = jass.DAMAGE_TYPE_FIRE
    else
        local ____payload__96F7_5
        if payload["雷"] then
            ____payload__96F7_5 = jass.DAMAGE_TYPE_LIGHTNING
        else
            ____payload__96F7_5 = jass.DAMAGE_TYPE_COLD
        end
        ____payload__706B_6 = ____payload__96F7_5
    end
    local _____4F24_5BB3_7C7B_578B = ____payload__706B_6
    local _____654C_519B_5217_8868 = _____8FC7_6EE4_88AB_52A8_8FFD_52A0_6807_7684(_____83B7_53D6_8303_56F4_654C_519B(caster, payload["目标X"], payload["目标Y"], _____88AB_52A8_914D_7F6E["附加伤害范围"]))
    if #_____654C_519B_5217_8868 == 0 then
        return
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = _____654C_519B_5217_8868,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = _____4F24_5BB3_7C7B_578B,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "普攻强化",
        ["标签"] = "塞拉斯-被动附加"
    })
end
local function _____5904_7406_585E_62C9_65AF_666E_653B_9644_52A0(unit, _damage, _damageType, _fromDotTickBatch, source, isNormalAttack)
    if not isNormalAttack then
        return
    end
    if unit == nil or unit == 0 or source == nil or source == 0 then
        return
    end
    if GetUnitTypeId(source) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local sourceOwner = GetOwningPlayer(source)
    if sourceOwner == nil or sourceOwner == 0 then
        return
    end
    if IsUnitAlly(unit, sourceOwner) then
        return
    end
    if IsUnitOwnedByPlayer(unit, sourceOwner) then
        return
    end
    local _____8DDD_79BB = _____4E24_70B9_8DDD_79BB(
        GetUnitX(unit),
        GetUnitY(unit),
        GetUnitX(source),
        GetUnitY(source)
    )
    if _____8DDD_79BB < _____88AB_52A8_914D_7F6E["触发距离"] then
        return
    end
    if not _____585E_62C9_65AF_62E5_6709_4EFB_610F_653B_51FB_6807_8BB0(source) then
        return
    end
    local marks = _____6D88_8D39_585E_62C9_65AF_653B_51FB_6807_8BB0(source)
    if not marks["火"] and not marks["冰"] and not marks["雷"] then
        return
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(source, _____585E_62C9_65AFBuffID["火焰附加攻击"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(source, _____585E_62C9_65AFBuffID["冰冻附加攻击"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(source, _____585E_62C9_65AFBuffID["雷击附加攻击"])
    local payload = {
        caster = source,
        ["目标X"] = GetUnitX(unit),
        ["目标Y"] = GetUnitY(unit),
        ["火"] = marks["火"],
        ["冰"] = marks["冰"],
        ["雷"] = marks["雷"]
    }
    addDelayedCallback(_____88AB_52A8_914D_7F6E["延迟秒"] * 1000, _____6267_884C_88AB_52A8_8FFD_52A0_4F24_5BB3, payload)
end
____exports["注册塞拉斯普攻附加被动"] = function()
    registerDamageCallback(_____5904_7406_585E_62C9_65AF_666E_653B_9644_52A0)
end
____exports["注册塞拉斯普攻附加被动"]()
____exports["塞拉斯普攻附加被动状态"] = {["已完成设计"] = true, ["已完成实现"] = true, ["触发"] = "H014 普攻、目标非玩家拥有敌方、距离≥500、存在元素标记", ["效果"] = "0.12秒后受击位置350范围，当前魔法值×40%元素伤害，防递归（普攻强化来源）"}
return ____exports
