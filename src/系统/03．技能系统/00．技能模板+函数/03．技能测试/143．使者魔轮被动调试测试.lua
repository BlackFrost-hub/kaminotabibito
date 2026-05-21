--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 使者魔轮被动调试测试
-- 
-- 输入 "143"：直接给大法师注册魔法吸收护盾并执行低蓝门槛测试
-- 输入 "145"：直接给大法师注册后再移除护盾，测试回收
local jass = require("jass.common")
local japi = require("jass.japi")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.24．魔法吸收护盾.01．魔法吸收护盾")
local _____5F00_59CB_9B54_6CD5_5438_6536_62A4_76FE = ____require_result_3["开始魔法吸收护盾"]
local _____79FB_9664_5355_4F4D_9B54_6CD5_5438_6536_62A4_76FE = ____require_result_3["移除单位魔法吸收护盾"]
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitStateJapi = japi.SetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local _____6A21_5757_540D = "使者魔轮被动测试"
local _____6D4B_8BD5_547D_4EE4_4F4E_84DD = "143"
local _____6D4B_8BD5_547D_4EE4_4E22_5F03 = "145"
local _____6D4B_8BD5_6807_7B7E = "测试:使者魔轮被动"
local _____4F4E_84DD_6D4B_8BD5_4F24_5BB3 = 100
local function _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    local ____g_gg_unit_Hamg_0002_4 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_4 == nil then
        ____g_gg_unit_Hamg_0002_4 = _G.bj_lastCreatedUnit
    end
    return ____g_gg_unit_Hamg_0002_4
end
local function _____53D6_95E8_69DB(unit)
    local maxMana = GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA)
    return maxMana * 0.1 + 500
end
local function _____6253_5370_5355_4F4D_72B6_6001(_____524D_7F00, unit)
    local currentLife = GetUnitState(unit, UNIT_STATE_LIFE)
    local currentMana = GetUnitState(unit, UNIT_STATE_MANA)
    local maxMana = GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA)
    local threshold = _____53D6_95E8_69DB(unit)
    debugLogForce(
        _____6A21_5757_540D,
        _____524D_7F00,
        "life=",
        currentLife,
        "mana=",
        currentMana,
        "maxMana=",
        maxMana,
        "threshold=",
        threshold
    )
end
local function _____8BBE_7F6E_6D4B_8BD5_9B54_6CD5(unit, maxMana, currentMana)
    SetUnitStateJapi(unit, UNIT_STATE_MAX_MANA, maxMana)
    SetUnitState(unit, UNIT_STATE_MANA, currentMana)
    debugLogForce(
        _____6A21_5757_540D,
        "已设置魔法",
        "maxMana=",
        maxMana,
        "currentMana=",
        currentMana
    )
    _____6253_5370_5355_4F4D_72B6_6001("设置后", unit)
end
local function _____9020_6210_9B54_6CD5_4F24_5BB3(source, target, amount, _____6807_9898)
    debugLogForce(
        _____6A21_5757_540D,
        _____6807_9898,
        "准备施加魔法伤害",
        "amount=",
        amount
    )
    _____6253_5370_5355_4F4D_72B6_6001("施加前", target)
    UnitDamageTarget(
        source,
        target,
        amount,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_MAGIC,
        WEAPON_TYPE_WHOKNOWS
    )
    addDelayedCallback(
        100,
        function()
            _____6253_5370_5355_4F4D_72B6_6001("施加后", target)
        end
    )
end
local function _____6CE8_518C_6D4B_8BD5_62A4_76FE(unit)
    _____79FB_9664_5355_4F4D_9B54_6CD5_5438_6536_62A4_76FE(unit, _____6D4B_8BD5_6807_7B7E)
    local id = _____5F00_59CB_9B54_6CD5_5438_6536_62A4_76FE({
        ["单位"] = unit,
        ["持续时间"] = 0,
        ["伤害吸收比例"] = 0.2,
        ["每点魔法吸收伤害"] = 2.2,
        ["最低魔法百分比"] = 0.1,
        ["最低魔法固定值"] = 500,
        ["仅非物理伤害"] = true,
        ["是否有特效"] = true,
        ["特效路径"] = "war3mapImported\\Energy Shield.mdl",
        ["特效挂点"] = "origin",
        ["显示文本"] = true,
        ["标签"] = _____6D4B_8BD5_6807_7B7E
    })
    debugLogForce(
        _____6A21_5757_540D,
        "已直接注册测试护盾",
        "id=",
        id,
        "标签=",
        _____6D4B_8BD5_6807_7B7E
    )
end
local function _____6D4B_8BD5_4F4E_84DD()
    local unit = _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到测试单位")
        return
    end
    _____6CE8_518C_6D4B_8BD5_62A4_76FE(unit)
    _____8BBE_7F6E_6D4B_8BD5_9B54_6CD5(unit, 1000, 540)
    debugLogForce(
        _____6A21_5757_540D,
        "低蓝测试说明",
        "阈值=600",
        "当前蓝=540",
        "预期：不触发魔法吸收"
    )
    addDelayedCallback(
        150,
        function()
            _____9020_6210_9B54_6CD5_4F24_5BB3(unit, unit, _____4F4E_84DD_6D4B_8BD5_4F24_5BB3, "低蓝测试")
        end
    )
end
local function _____6D4B_8BD5_4E22_5F03()
    local unit = _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到测试单位")
        return
    end
    _____6CE8_518C_6D4B_8BD5_62A4_76FE(unit)
    _____8BBE_7F6E_6D4B_8BD5_9B54_6CD5(unit, 1000, 800)
    debugLogForce(_____6A21_5757_540D, "移除测试说明", "先注册护盾，再移除护盾，预期移除后不再吸收")
    addDelayedCallback(
        150,
        function()
            _____6253_5370_5355_4F4D_72B6_6001("移除前", unit)
            _____79FB_9664_5355_4F4D_9B54_6CD5_5438_6536_62A4_76FE(unit, _____6D4B_8BD5_6807_7B7E)
            debugLogForce(_____6A21_5757_540D, "已移除测试护盾", "标签=", _____6D4B_8BD5_6807_7B7E)
            addDelayedCallback(
                150,
                function()
                    _____6253_5370_5355_4F4D_72B6_6001("移除后伤害前", unit)
                    _____9020_6210_9B54_6CD5_4F24_5BB3(unit, unit, _____4F4E_84DD_6D4B_8BD5_4F24_5BB3, "移除后伤害")
                end
            )
        end
    )
end
local function ____on_804A_5929_547D_4EE4_56DE_8C03(_player, command)
    if command == _____6D4B_8BD5_547D_4EE4_4F4E_84DD then
        _____6D4B_8BD5_4F4E_84DD()
        return
    end
    if command == _____6D4B_8BD5_547D_4EE4_4E22_5F03 then
        _____6D4B_8BD5_4E22_5F03()
        return
    end
    debugLogForce(_____6A21_5757_540D, "未知命令", command)
end
local function _____521D_59CB_5316_6D4B_8BD5()
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4_4F4E_84DD, ____on_804A_5929_547D_4EE4_56DE_8C03)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4_4E22_5F03, ____on_804A_5929_547D_4EE4_56DE_8C03)
    debugLogForce(
        _____6A21_5757_540D,
        "已注册测试命令",
        _____6D4B_8BD5_547D_4EE4_4F4E_84DD,
        _____6D4B_8BD5_547D_4EE4_4E22_5F03,
        "测试方式=直接注册魔法吸收护盾",
        "预期阈值公式=最大魔法*10%+500",
        "低蓝=540"
    )
end
_____521D_59CB_5316_6D4B_8BD5()
return ____exports
