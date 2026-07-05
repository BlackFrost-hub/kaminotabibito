--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____8DDD_79BB_5E73_65B9, _____9009_62E9_706B_7130_9501_94FE_76EE_6807, _____8BA1_7B97_8D85_8DDD_4F24_5BB3, _____66F4_65B0_9501_94FE_5355_4F4D_4F4D_7F6E, _____505C_6B62_706B_7130_9501_94FE, ____on_706B_7130_9501_94FEBuff_79FB_9664, ____on_706B_7130_9501_94FETick, _____521B_5EFA_706B_7130_9501_94FE, ____on_5DF4_5C14_624E_7F57_65AF_706B_7130_9501_94FE_751F_6548, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D, _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, addPeriodicCallback, removePeriodicCallback, getServerTime, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitState, IsUnitType, SetUnitX, SetUnitY, Player, UNIT_STATE_MAX_LIFE, UNIT_TYPE_DEAD, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS, PLAYER_NEUTRAL_AGGRESSIVE, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID, _____706B_7130_9501_94FE_6280_80FDID
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建巴尔扎罗斯上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____8DDD_79BB_5E73_65B9(a, b)
    local dx = GetUnitX(a) - GetUnitX(b)
    local dy = GetUnitY(a) - GetUnitY(b)
    return dx * dx + dy * dy
end
function _____9009_62E9_706B_7130_9501_94FE_76EE_6807(boss)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["火焰锁链"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local farthest = nil
    local farthestDistance2 = -1
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue6
                end
                local distance2 = _____8DDD_79BB_5E73_65B9(boss, hero)
                if distance2 > farthestDistance2 then
                    farthest = hero
                    farthestDistance2 = distance2
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
    if farthest ~= nil and farthestDistance2 >= config["最远目标最低距离"] * config["最远目标最低距离"] then
        return farthest
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
end
function _____8BA1_7B97_8D85_8DDD_4F24_5BB3(boss, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["火焰锁链"]
    return (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * config["超距伤害Boss攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["超距伤害目标最大生命比例"]) * config["超距伤害总倍率"]
end
function _____66F4_65B0_9501_94FE_5355_4F4D_4F4D_7F6E(state)
    local boss = state.context["Boss单位"]
    local target = state.target
    local chainUnit = state.chainUnit
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_6709_6548(chainUnit) then
        return
    end
    SetUnitX(
        chainUnit,
        (GetUnitX(boss) + GetUnitX(target)) * 0.5
    )
    SetUnitY(
        chainUnit,
        (GetUnitY(boss) + GetUnitY(target)) * 0.5
    )
end
function _____505C_6B62_706B_7130_9501_94FE(state, removeBuff)
    if state.stopped then
        return
    end
    state.stopped = true
    if state.tickId ~= 0 then
        removePeriodicCallback(state.tickId)
        state.tickId = 0
    end
    if state.line ~= nil then
        local ____self_9 = state.line
        ____self_9["停止"](____self_9, "火焰锁链结束")
    end
    if removeBuff then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(state.target, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["火焰锁链"])
    end
end
function ____on_706B_7130_9501_94FEBuff_79FB_9664(unit, _buffID, row)
    local ____temp_10
    if row ~= nil then
        ____temp_10 = row.chainState
    else
        ____temp_10 = nil
    end
    local state = ____temp_10
    if state ~= nil then
        _____505C_6B62_706B_7130_9501_94FE(state, false)
    end
end
function ____on_706B_7130_9501_94FETick(state)
    if state.stopped then
        return
    end
    local boss = state.context["Boss单位"]
    local target = state.target
    local chainUnit = state.chainUnit
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_6709_6548(chainUnit) then
        _____505C_6B62_706B_7130_9501_94FE(state, true)
        return
    end
    _____66F4_65B0_9501_94FE_5355_4F4D_4F4D_7F6E(state)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["火焰锁链"]
    if _____8DDD_79BB_5E73_65B9(boss, target) <= config["断链距离"] * config["断链距离"] then
        return
    end
    local now = getServerTime()
    if state.lastDamageMs > 0 and now - state.lastDamageMs < config["超距Tick秒"] * 1000 then
        return
    end
    state.lastDamageMs = now
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害"] = _____8BA1_7B97_8D85_8DDD_4F24_5BB3(boss, target),
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_CHAOS,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能"
    })
end
function _____521B_5EFA_706B_7130_9501_94FE(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["火焰锁链"]
    local centerX = (GetUnitX(boss) + GetUnitX(target)) * 0.5
    local centerY = (GetUnitY(boss) + GetUnitY(target)) * 0.5
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    local state = {
        context = context,
        target = target,
        chainUnit = nil,
        line = nil,
        tickId = 0,
        lastDamageMs = 0,
        stopped = false
    }
    local chain = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "巴尔扎罗斯-火焰锁链单位",
        ["主人单位"] = boss,
        ["所属玩家"] = Player(PLAYER_NEUTRAL_AGGRESSIVE),
        ["单位类型"] = config["锁链单位ID"],
        X = centerX,
        Y = centerY,
        ["最大生命"] = maxLife * config["锁链单位生命Boss最大生命比例"],
        ["生命值受小怪倍率"] = false,
        ["飞行高度"] = config["锁链单位飞行高度"],
        ["缩放"] = config["锁链单位缩放"],
        ["on死亡"] = function()
            _____505C_6B62_706B_7130_9501_94FE(state, true)
        end
    })
    if chain == nil or not _____5355_4F4D_6709_6548(chain["单位"]) then
        return
    end
    state.chainUnit = chain["单位"]
    state.line = _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF({
        ["清理"] = context["清理"],
        ["名称"] = "巴尔扎罗斯-火焰锁链闪电",
        ["起点单位"] = boss,
        ["终点单位"] = target,
        ["闪电代码"] = config["闪电代码"],
        ["持续秒"] = config["持续秒"],
        ["起点高度"] = config["闪电起点高度"],
        ["终点高度"] = config["闪电终点高度"],
        ["Tick间隔毫秒"] = config["锁链Tick毫秒"],
        ["on断开"] = function()
            _____505C_6B62_706B_7130_9501_94FE(state, true)
        end
    })
    state.tickId = addPeriodicCallback(
        config["锁链Tick毫秒"],
        function()
            ____on_706B_7130_9501_94FETick(state)
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记周期回调"](____self_11, "巴尔扎罗斯-火焰锁链Tick", state.tickId)
    registerManualBuff(
        target,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["火焰锁链"],
        config["持续秒"],
        0,
        {sourceName = "巴尔扎罗斯", chainState = state, onRemove = ____on_706B_7130_9501_94FEBuff_79FB_9664}
    )
end
____exports["释放巴尔扎罗斯火焰锁链"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____9009_62E9_706B_7130_9501_94FE_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["火焰锁链"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = GetUnitX(target),
        Y = GetUnitY(target),
        ["半径"] = config["锁定提示半径"],
        ["持续时间"] = config["施法硬直秒"],
        ["来源单位"] = boss
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "火焰锁链")
        end,
        ["on生效"] = function()
            _____521B_5EFA_706B_7130_9501_94FE(context, target)
        end
    })
end
function ____on_5DF4_5C14_624E_7F57_65AF_706B_7130_9501_94FE_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____706B_7130_9501_94FE_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放巴尔扎罗斯火焰锁链"](context)
end
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.index")
_____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_3["创建可攻击机制单位"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.07．机制连线.index")
_____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF = ____require_result_4["创建持续单位连线"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
_____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_5["获取Boss技能随机敌对英雄"]
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_6.addPeriodicCallback
removePeriodicCallback = ____require_result_6.removePeriodicCallback
getServerTime = ____require_result_6.getServerTime
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_7.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_7["移除单位指定Buff"]
local ____require_result_8 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_8["造成单体技能伤害"]
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
IsUnitType = jass.IsUnitType
SetUnitX = jass.SetUnitX
SetUnitY = jass.SetUnitY
Player = jass.Player
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS
DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
_____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____706B_7130_9501_94FE_6280_80FDID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["火焰锁链"]["技能槽位"])
local _____706B_7130_9501_94FE_5DF2_6CE8_518C = false
____exports["注册巴尔扎罗斯火焰锁链"] = function()
    if _____706B_7130_9501_94FE_5DF2_6CE8_518C then
        return
    end
    _____706B_7130_9501_94FE_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "巴尔扎罗斯火焰锁链",
        ["单位类型ID"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____706B_7130_9501_94FE_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5DF4_5C14_624E_7F57_65AF_706B_7130_9501_94FE_751F_6548(boss, _____706B_7130_9501_94FE_6280_80FDID)
        end
    })
end
return ____exports
