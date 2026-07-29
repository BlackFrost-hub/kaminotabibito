--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____6E05_7406_6765_6E90, _____505C_6B62_6D4B_8BD5, ____on_6D4B_8BD5Tick, removePeriodicCallback, debugLogForce, RemoveUnit, UnitDamageTarget, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS, _____6A21_5757_540D, _____5355_6B21_4F24_5BB3, _____603B_6B21_6570, _____5F53_524D_6765_6E90, _____5F53_524D_76EE_6807, _____5F53_524D_6B21_6570, _____5F53_524D_8BA1_65F6_5668ID, _____5F53_524D_603B_4F24_5BB3
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
function _____6E05_7406_6765_6E90()
    if not _____5355_4F4D_6709_6548(_____5F53_524D_6765_6E90) then
        return
    end
    RemoveUnit(_____5F53_524D_6765_6E90)
    _____5F53_524D_6765_6E90 = nil
end
function _____505C_6B62_6D4B_8BD5()
    if _____5F53_524D_8BA1_65F6_5668ID ~= 0 then
        removePeriodicCallback(_____5F53_524D_8BA1_65F6_5668ID)
        _____5F53_524D_8BA1_65F6_5668ID = 0
    end
    _____6E05_7406_6765_6E90()
    _____5F53_524D_76EE_6807 = nil
    _____5F53_524D_6B21_6570 = 0
    _____5F53_524D_603B_4F24_5BB3 = 0
end
function ____on_6D4B_8BD5Tick()
    if not _____5355_4F4D_6709_6548(_____5F53_524D_6765_6E90) or not _____5355_4F4D_6709_6548(_____5F53_524D_76EE_6807) then
        debugLogForce(_____6A21_5757_540D, "测试中断", "原因=来源或目标失效")
        _____505C_6B62_6D4B_8BD5()
        return
    end
    _____5F53_524D_6B21_6570 = _____5F53_524D_6B21_6570 + 1
    debugLogForce(
        _____6A21_5757_540D,
        "tick=",
        _____5F53_524D_6B21_6570,
        "of",
        _____603B_6B21_6570,
        "amount=",
        _____5355_6B21_4F24_5BB3
    )
    UnitDamageTarget(
        _____5F53_524D_6765_6E90,
        _____5F53_524D_76EE_6807,
        _____5355_6B21_4F24_5BB3,
        false,
        false,
        ATTACK_TYPE_CHAOS,
        DAMAGE_TYPE_MAGIC,
        WEAPON_TYPE_WHOKNOWS
    )
    if _____5F53_524D_6B21_6570 >= _____603B_6B21_6570 then
        debugLogForce(_____6A21_5757_540D, "测试结束", "总伤害=", _____5F53_524D_603B_4F24_5BB3)
        _____505C_6B62_6D4B_8BD5()
    end
end
--- 命中 / 闪避 / 暴击系统测试
-- 
-- 当前只保留一个场景：
-- 敌人攻击大法师，2 秒内造成 20 次 10 点魔法伤害，测试 10% 闪避。
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_2.debugLogForce
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_4.YDUserDataSetSafe
local ____require_result_5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_5.getRegisteredPlayerHero
local ____require_result_6 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_6["是玩家英雄组单位"]
local ____require_result_7 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_7.registerAppliedFinalDamageListener
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local CreateUnit = jass.CreateUnit
RemoveUnit = jass.RemoveUnit
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
UnitDamageTarget = jass.UnitDamageTarget
local Player = jass.Player
ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS
DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
_____6A21_5757_540D = "命中闪避暴击测试"
local _____6D4B_8BD5_547D_4EE4 = "暴击测试"
local _____654C_4EBA_7C7B_578B = stringToFourCCSafe("hfoo")
_____5355_6B21_4F24_5BB3 = 10
_____603B_6B21_6570 = 20
local _____95F4_9694_6BEB_79D2 = 100
local _____5927_6CD5_5E08_95EA_907F_7387 = 0.1
_____5F53_524D_6765_6E90 = nil
_____5F53_524D_76EE_6807 = nil
_____5F53_524D_6B21_6570 = 0
_____5F53_524D_8BA1_65F6_5668ID = 0
_____5F53_524D_603B_4F24_5BB3 = 0
local function _____53D6_5730_56FE_5927_6CD5_5E08()
    local ____globals_gg_unit_Hamg_0002_8 = globals.gg_unit_Hamg_0002
    if ____globals_gg_unit_Hamg_0002_8 == nil then
        ____globals_gg_unit_Hamg_0002_8 = nil
    end
    return ____globals_gg_unit_Hamg_0002_8
end
local function _____53D6_6D4B_8BD5_76EE_6807(whichPlayer)
    local _____6CE8_518C_82F1_96C4 = getRegisteredPlayerHero(whichPlayer)
    if _____5355_4F4D_6709_6548(_____6CE8_518C_82F1_96C4) then
        return _____6CE8_518C_82F1_96C4
    end
    local _____5730_56FE_5927_6CD5_5E08 = _____53D6_5730_56FE_5927_6CD5_5E08()
    if _____5355_4F4D_6709_6548(_____5730_56FE_5927_6CD5_5E08) and _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____5730_56FE_5927_6CD5_5E08) then
        return _____5730_56FE_5927_6CD5_5E08
    end
    return nil
end
local function _____521B_5EFA_654C_4EBA(target)
    _____6E05_7406_6765_6E90()
    local enemy = CreateUnit(
        Player(jass.PLAYER_NEUTRAL_AGGRESSIVE),
        _____654C_4EBA_7C7B_578B,
        GetUnitX(target) + 250,
        GetUnitY(target),
        270
    )
    if not _____5355_4F4D_6709_6548(enemy) then
        return nil
    end
    _____5F53_524D_6765_6E90 = enemy
    return enemy
end
local function _____8BBE_7F6E_76EE_6807_6EE1_8840(target)
    local _____6700_5927_751F_547D = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
    SetUnitState(target, UNIT_STATE_LIFE, _____6700_5927_751F_547D)
    debugLogForce(_____6A21_5757_540D, "已设置满血", "life=", _____6700_5927_751F_547D)
end
local function _____8BBE_7F6E_5927_6CD5_5E08_95EA_907F(target)
    YDUserDataSetSafe(
        "unit",
        target,
        "闪避率",
        "real",
        _____5927_6CD5_5E08_95EA_907F_7387
    )
    debugLogForce(
        _____6A21_5757_540D,
        "已设置闪避率",
        tostring(math.floor(_____5927_6CD5_5E08_95EA_907F_7387 * 100)) .. "%"
    )
end
local function ____on_6700_7EC8_4F24_5BB3(target, attacker, applied, _snapshot)
    if target ~= _____5F53_524D_76EE_6807 or attacker ~= _____5F53_524D_6765_6E90 then
        return
    end
    _____5F53_524D_603B_4F24_5BB3 = _____5F53_524D_603B_4F24_5BB3 + applied
    debugLogForce(
        _____6A21_5757_540D,
        "本次最终伤害",
        applied,
        "累计总伤害",
        _____5F53_524D_603B_4F24_5BB3
    )
end
local function _____5F00_59CB_6D4B_8BD5(whichPlayer)
    _____505C_6B62_6D4B_8BD5()
    local target = _____53D6_6D4B_8BD5_76EE_6807(whichPlayer)
    if not _____5355_4F4D_6709_6548(target) then
        debugLogForce(_____6A21_5757_540D, "未找到测试目标", "player=", whichPlayer)
        return
    end
    if not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(target) then
        debugLogForce(
            _____6A21_5757_540D,
            "测试中止",
            "原因=目标不在玩家英雄单位组",
            "target=",
            target
        )
        return
    end
    local enemy = _____521B_5EFA_654C_4EBA(target)
    if not _____5355_4F4D_6709_6548(enemy) then
        debugLogForce(_____6A21_5757_540D, "创建敌人失败")
        return
    end
    _____5F53_524D_76EE_6807 = target
    _____5F53_524D_6B21_6570 = 0
    _____5F53_524D_603B_4F24_5BB3 = 0
    _____8BBE_7F6E_76EE_6807_6EE1_8840(target)
    _____8BBE_7F6E_5927_6CD5_5E08_95EA_907F(target)
    debugLogForce(
        _____6A21_5757_540D,
        "开始测试",
        "player=",
        whichPlayer,
        "registeredHero=",
        getRegisteredPlayerHero(whichPlayer),
        "target=",
        target,
        "玩家英雄组单位=",
        _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(target),
        "enemy=",
        enemy,
        "单次伤害=",
        _____5355_6B21_4F24_5BB3,
        "总次数=",
        _____603B_6B21_6570
    )
    _____5F53_524D_8BA1_65F6_5668ID = addPeriodicCallback(_____95F4_9694_6BEB_79D2, ____on_6D4B_8BD5Tick)
end
local function ____on_804A_5929_56DE_8C03(player, command)
    if command ~= _____6D4B_8BD5_547D_4EE4 then
        return
    end
    _____5F00_59CB_6D4B_8BD5(player)
end
local function _____521D_59CB_5316()
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929_56DE_8C03)
    registerAppliedFinalDamageListener(____on_6700_7EC8_4F24_5BB3)
    debugLogForce(_____6A21_5757_540D, "已注册测试命令", _____6D4B_8BD5_547D_4EE4, "内容=敌人打大法师，2秒内20次10点魔法伤害")
end
_____521D_59CB_5316()
return ____exports
