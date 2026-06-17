--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____8BBE_7F6E_5355_4F4D_5B9E_6570, _____8BBE_7F6E_73A9_5BB6_5B9E_6570, _____91CD_7F6E_6D4B_8BD5_5C5E_6027, _____6E05_7406_4E34_65F6_5355_4F4D, YDUserDataSetSafe, GetOwningPlayer, RemoveUnit, _____5F85_6E05_7406_5355_4F4D, _____5F85_91CD_7F6E_5927_6CD5_5E08
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
function _____8BBE_7F6E_5355_4F4D_5B9E_6570(unit, attr, value)
    if not _____5355_4F4D_6709_6548(unit) then
        return
    end
    YDUserDataSetSafe(
        "unit",
        unit,
        attr,
        "real",
        value
    )
end
function _____8BBE_7F6E_73A9_5BB6_5B9E_6570(unit, attr, value)
    if not _____5355_4F4D_6709_6548(unit) then
        return
    end
    local owner = GetOwningPlayer(unit)
    if not _____5355_4F4D_6709_6548(owner) then
        return
    end
    YDUserDataSetSafe(
        "player",
        owner,
        attr,
        "real",
        value
    )
end
function _____91CD_7F6E_6D4B_8BD5_5C5E_6027(archmage, target)
    _____8BBE_7F6E_73A9_5BB6_5B9E_6570(archmage, "命中率", 0)
    _____8BBE_7F6E_73A9_5BB6_5B9E_6570(archmage, "闪避率", 0)
    _____8BBE_7F6E_73A9_5BB6_5B9E_6570(archmage, "暴击率", 0)
    _____8BBE_7F6E_73A9_5BB6_5B9E_6570(archmage, "暴击伤害", 0)
    _____8BBE_7F6E_5355_4F4D_5B9E_6570(archmage, "闪避率", 0)
    if _____5355_4F4D_6709_6548(target) then
        _____8BBE_7F6E_5355_4F4D_5B9E_6570(target, "闪避率", 0)
        _____8BBE_7F6E_5355_4F4D_5B9E_6570(target, "被暴击率", 0)
        _____8BBE_7F6E_5355_4F4D_5B9E_6570(target, "被暴击伤害", 0)
    end
end
function _____6E05_7406_4E34_65F6_5355_4F4D()
    if _____5355_4F4D_6709_6548(_____5F85_91CD_7F6E_5927_6CD5_5E08) then
        _____91CD_7F6E_6D4B_8BD5_5C5E_6027(_____5F85_91CD_7F6E_5927_6CD5_5E08, nil)
        _____5F85_91CD_7F6E_5927_6CD5_5E08 = nil
    end
    if not _____5355_4F4D_6709_6548(_____5F85_6E05_7406_5355_4F4D) then
        return
    end
    RemoveUnit(_____5F85_6E05_7406_5355_4F4D)
    _____5F85_6E05_7406_5355_4F4D = nil
end
--- 伤害数字前缀模型测试
-- 
-- 聊天命令：
-- - 数字暴击：大法师攻击临时步兵，强制暴击，观察目标头顶“暴击图标 + 伤害数字”。
-- - 数字闪避：临时步兵攻击大法师，强制闪避，观察大法师头顶闪避图标。
-- - 数字未命中：大法师攻击临时步兵，强制未命中，观察大法师头顶未命中图标。
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local createDelayedCall = ____require_result_1.createDelayedCall
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local CreateUnit = jass.CreateUnit
RemoveUnit = jass.RemoveUnit
local SetUnitState = jass.SetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local Player = jass.Player
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____6A21_5757_540D = "伤害数字前缀模型测试"
local _____547D_4EE4_66B4_51FB = "数字暴击"
local _____547D_4EE4_95EA_907F = "数字闪避"
local _____547D_4EE4_672A_547D_4E2D = "数字未命中"
local _____4E34_65F6_5355_4F4D_7C7B_578B = stringToFourCCSafe("hfoo")
local _____6D4B_8BD5_4F24_5BB3 = 100
local _____4E34_65F6_5355_4F4D_751F_547D = 1000
local _____6E05_7406_5EF6_8FDF = 1.2
_____5F85_6E05_7406_5355_4F4D = nil
_____5F85_91CD_7F6E_5927_6CD5_5E08 = nil
local function _____53D6_6D4B_8BD5_5927_6CD5_5E08()
    local unit = globals.gg_unit_Hamg_0002
    local _____5355_4F4D_6709_6548_result_5
    if _____5355_4F4D_6709_6548(unit) then
        _____5355_4F4D_6709_6548_result_5 = unit
    else
        _____5355_4F4D_6709_6548_result_5 = nil
    end
    return _____5355_4F4D_6709_6548_result_5
end
local function _____521B_5EFA_4E34_65F6_5355_4F4D(nearUnit, offsetX)
    local unit = CreateUnit(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        _____4E34_65F6_5355_4F4D_7C7B_578B,
        GetUnitX(nearUnit) + offsetX,
        GetUnitY(nearUnit),
        270
    )
    if not _____5355_4F4D_6709_6548(unit) then
        return nil
    end
    SetUnitState(unit, UNIT_STATE_MAX_LIFE, _____4E34_65F6_5355_4F4D_751F_547D)
    SetUnitState(unit, UNIT_STATE_LIFE, _____4E34_65F6_5355_4F4D_751F_547D)
    _____5F85_6E05_7406_5355_4F4D = unit
    createDelayedCall(_____6E05_7406_5EF6_8FDF, _____6E05_7406_4E34_65F6_5355_4F4D)
    return unit
end
local function _____6267_884C_66B4_51FB_6D4B_8BD5(archmage)
    local target = _____521B_5EFA_4E34_65F6_5355_4F4D(archmage, 250)
    if not _____5355_4F4D_6709_6548(target) then
        debugLogForce(_____6A21_5757_540D, "创建暴击测试目标失败")
        return
    end
    _____5F85_91CD_7F6E_5927_6CD5_5E08 = archmage
    _____91CD_7F6E_6D4B_8BD5_5C5E_6027(archmage, target)
    _____8BBE_7F6E_73A9_5BB6_5B9E_6570(archmage, "暴击率", 1)
    _____8BBE_7F6E_73A9_5BB6_5B9E_6570(archmage, "暴击伤害", 0)
    debugLogForce(_____6A21_5757_540D, "执行", _____547D_4EE4_66B4_51FB, "观察临时目标头顶暴击图标和伤害数字")
    UnitDamageTarget(
        archmage,
        target,
        _____6D4B_8BD5_4F24_5BB3,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____6267_884C_95EA_907F_6D4B_8BD5(archmage)
    local attacker = _____521B_5EFA_4E34_65F6_5355_4F4D(archmage, 250)
    if not _____5355_4F4D_6709_6548(attacker) then
        debugLogForce(_____6A21_5757_540D, "创建闪避测试攻击者失败")
        return
    end
    _____5F85_91CD_7F6E_5927_6CD5_5E08 = archmage
    _____91CD_7F6E_6D4B_8BD5_5C5E_6027(archmage, attacker)
    _____8BBE_7F6E_5355_4F4D_5B9E_6570(archmage, "闪避率", 1)
    debugLogForce(_____6A21_5757_540D, "执行", _____547D_4EE4_95EA_907F, "观察大法师头顶闪避图标")
    UnitDamageTarget(
        attacker,
        archmage,
        _____6D4B_8BD5_4F24_5BB3,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____6267_884C_672A_547D_4E2D_6D4B_8BD5(archmage)
    local target = _____521B_5EFA_4E34_65F6_5355_4F4D(archmage, 250)
    if not _____5355_4F4D_6709_6548(target) then
        debugLogForce(_____6A21_5757_540D, "创建未命中测试目标失败")
        return
    end
    _____5F85_91CD_7F6E_5927_6CD5_5E08 = archmage
    _____91CD_7F6E_6D4B_8BD5_5C5E_6027(archmage, target)
    _____8BBE_7F6E_73A9_5BB6_5B9E_6570(archmage, "命中率", -1)
    debugLogForce(_____6A21_5757_540D, "执行", _____547D_4EE4_672A_547D_4E2D, "观察大法师头顶未命中图标")
    UnitDamageTarget(
        archmage,
        target,
        _____6D4B_8BD5_4F24_5BB3,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function ____on_804A_5929_547D_4EE4(_player, command)
    local archmage = _____53D6_6D4B_8BD5_5927_6CD5_5E08()
    if not _____5355_4F4D_6709_6548(archmage) then
        debugLogForce(_____6A21_5757_540D, "找不到 gg_unit_Hamg_0002")
        return
    end
    if command == _____547D_4EE4_66B4_51FB then
        _____6267_884C_66B4_51FB_6D4B_8BD5(archmage)
        return
    end
    if command == _____547D_4EE4_95EA_907F then
        _____6267_884C_95EA_907F_6D4B_8BD5(archmage)
        return
    end
    if command == _____547D_4EE4_672A_547D_4E2D then
        _____6267_884C_672A_547D_4E2D_6D4B_8BD5(archmage)
    end
end
local function _____521D_59CB_5316()
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____547D_4EE4_66B4_51FB, ____on_804A_5929_547D_4EE4)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____547D_4EE4_95EA_907F, ____on_804A_5929_547D_4EE4)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____547D_4EE4_672A_547D_4E2D, ____on_804A_5929_547D_4EE4)
    debugLogForce(
        _____6A21_5757_540D,
        "已注册命令",
        _____547D_4EE4_66B4_51FB,
        _____547D_4EE4_95EA_907F,
        _____547D_4EE4_672A_547D_4E2D
    )
end
_____521D_59CB_5316()
return ____exports
