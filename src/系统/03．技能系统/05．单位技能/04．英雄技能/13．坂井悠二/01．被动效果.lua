local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.00．配置")
local _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["坂井悠二技能配置"]
local ____05_FF0E_5742_4E95_60A0_4E8C = require("系统.05．Buff系统.03．Buff表.02．英雄.05．坂井悠二")
local _____5742_4E95_60A0_4E8CBuffID = ____05_FF0E_5742_4E95_60A0_4E8C["坂井悠二BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local registerPlayerHeroListener = ____require_result_1.registerPlayerHeroListener
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_3.registerDamageCallback
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_4["造成单体技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local Player = jass.Player
local _____88AB_52A8_914D_7F6E = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.Q["被动"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E["单位类型ID"]
local _____5DF2_5E94_7528_5742_4E95_60A0_4E8C_88AB_52A8 = {}
local function _____662F_5742_4E95_60A0_4E8C(hero)
    return hero ~= nil and hero ~= 0 and GetUnitTypeId(hero) == _____82F1_96C4_5355_4F4D_7C7B_578BID
end
local function _____6E05_7406_5742_4E95_60A0_4E8C_88AB_52A8_72B6_6001(hero)
    if hero == nil or hero == 0 then
        return
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(hero, _____5742_4E95_60A0_4E8CBuffID["D暗属性加成"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(hero, _____5742_4E95_60A0_4E8CBuffID["D期间状态"])
end
local function _____66F4_65B0_5742_4E95_60A0_4E8C_88AB_52A8_72B6_6001(player, hero)
    if player == nil or player == 0 then
        return
    end
    local playerId = jass.GetPlayerId(player)
    local prev = _____5DF2_5E94_7528_5742_4E95_60A0_4E8C_88AB_52A8[playerId]
    if prev == hero then
        return
    end
    if prev ~= nil and prev ~= 0 then
        _____6E05_7406_5742_4E95_60A0_4E8C_88AB_52A8_72B6_6001(prev)
    end
    __TS__Delete(_____5DF2_5E94_7528_5742_4E95_60A0_4E8C_88AB_52A8, playerId)
    if not _____662F_5742_4E95_60A0_4E8C(hero) then
        return
    end
    _____5DF2_5E94_7528_5742_4E95_60A0_4E8C_88AB_52A8[playerId] = hero
end
local function _____521D_59CB_5316_5DF2_6709_5742_4E95_60A0_4E8C_88AB_52A8_72B6_6001()
    do
        local i = 0
        while i < 16 do
            local player = Player(i)
            _____66F4_65B0_5742_4E95_60A0_4E8C_88AB_52A8_72B6_6001(
                player,
                getRegisteredPlayerHero(player)
            )
            i = i + 1
        end
    end
end
local function _____5904_7406_5742_4E95_60A0_4E8C_666E_901A_653B_51FB_989D_5916_4F24_5BB3(target, damage, _damageType, _fromDotTickBatch, source, isNormalAttack)
    if source == nil or source == 0 then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(source) then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    if GetUnitTypeId(source) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    if not isNormalAttack then
        return
    end
    local _____500D_7387 = _____88AB_52A8_914D_7F6E["攻击力倍率"]
    if _____500D_7387 <= 0 then
        return
    end
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(source)
    if _____653B_51FB_529B <= 0 then
        return
    end
    local _____989D_5916_4F24_5BB3 = _____653B_51FB_529B * _____500D_7387
    if _____989D_5916_4F24_5BB3 <= 0 then
        return
    end
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害"] = _____989D_5916_4F24_5BB3,
        ["伤害类型"] = jass.DAMAGE_TYPE_MAGIC,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "普攻强化",
        ["标签"] = "坂井悠二-Q被动-暗魔法伤害"
    })
    local ____ = damage
end
local function _____5904_7406_5742_4E95_60A0_4E8C_6B7B_4EA1(dyingUnit, _killingUnit)
    if not _____662F_5742_4E95_60A0_4E8C(dyingUnit) then
        return
    end
    _____6E05_7406_5742_4E95_60A0_4E8C_88AB_52A8_72B6_6001(dyingUnit)
end
____exports["注册坂井悠二被动"] = function()
    registerPlayerHeroListener(_____66F4_65B0_5742_4E95_60A0_4E8C_88AB_52A8_72B6_6001)
    registerDeathListener(_____5904_7406_5742_4E95_60A0_4E8C_6B7B_4EA1)
    registerDamageCallback(_____5904_7406_5742_4E95_60A0_4E8C_666E_901A_653B_51FB_989D_5916_4F24_5BB3)
    _____521D_59CB_5316_5DF2_6709_5742_4E95_60A0_4E8C_88AB_52A8_72B6_6001()
end
____exports["注册坂井悠二被动"]()
return ____exports
