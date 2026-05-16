--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 周期范围效果测试
-- 
-- 输入 1033：一次性测试周期 AOE、腐败层数、禁锢、寄生，以及 4 个旧 STES 兼容入口。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口")
local _____542F_52A8_5468_671F_8303_56F4_6548_679C = ____require_result_1["启动周期范围效果"]
local _____65BD_52A0_7981_9522 = ____require_result_1["施加禁锢"]
local _____65BD_52A0_5BC4_751F = ____require_result_1["施加寄生"]
local _____5E94_7528_8150_8D25_5C42_6570 = ____require_result_1["应用腐败层数"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_FireWithParams = ____require_result_2.STES_FireWithParams
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_4.stringToFourCC
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local Player = jass.Player
local CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
local _____6A21_5757_540D = "周期范围效果测试"
local _____6D4B_8BD5_547D_4EE4 = "1033"
local _____4E2D_7ACB_654C_5BF9 = 12
local _____6B65_5175ID = "hfoo"
local ____AOE_7279_6548 = "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl"
local _____5F85_6E05_7406_6D4B_8BD5_5355_4F4D = nil
local function _____83B7_53D6_6D4B_8BD5_5927_6CD5_5E08()
    local ____g_gg_unit_Hamg_0002_6 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_6 == nil then
        ____g_gg_unit_Hamg_0002_6 = _G.bj_lastCreatedUnit
    end
    return ____g_gg_unit_Hamg_0002_6
end
local function _____521B_5EFA_6D4B_8BD5_76EE_6807(_____6765_6E90_5355_4F4D)
    local x = GetUnitX(_____6765_6E90_5355_4F4D) + 260
    local y = GetUnitY(_____6765_6E90_5355_4F4D)
    _____5F85_6E05_7406_6D4B_8BD5_5355_4F4D = CreateUnit(
        Player(_____4E2D_7ACB_654C_5BF9),
        stringToFourCC(_____6B65_5175ID),
        x,
        y,
        270
    )
    return _____5F85_6E05_7406_6D4B_8BD5_5355_4F4D
end
local function ____on_6E05_7406_5468_671F_8303_56F4_6548_679C_6D4B_8BD5_5355_4F4D()
    if _____5F85_6E05_7406_6D4B_8BD5_5355_4F4D == nil or _____5F85_6E05_7406_6D4B_8BD5_5355_4F4D == 0 then
        return
    end
    RemoveUnit(_____5F85_6E05_7406_6D4B_8BD5_5355_4F4D)
    _____5F85_6E05_7406_6D4B_8BD5_5355_4F4D = nil
    debugLogForce(_____6A21_5757_540D, "已清理测试目标")
end
local function _____6D4B_8BD5TS_76F4_8C03(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D)
    _____542F_52A8_5468_671F_8303_56F4_6548_679C({
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["特效模型"] = ____AOE_7279_6548,
        ["效果ID"] = 3,
        ["间隔"] = 1,
        ["持续时间"] = 4,
        ["半径"] = 650,
        X = GetUnitX(_____6765_6E90_5355_4F4D),
        Y = GetUnitY(_____6765_6E90_5355_4F4D)
    })
    _____5E94_7528_8150_8D25_5C42_6570({["目标单位"] = _____6765_6E90_5355_4F4D, ["层数"] = 7, ["腐败值"] = true})
    _____65BD_52A0_7981_9522({
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["目标单位"] = _____76EE_6807_5355_4F4D,
        ["伤害"] = 25,
        ["伤害间隔"] = 1,
        ["持续时间"] = 3
    })
    _____65BD_52A0_5BC4_751F({
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["目标单位"] = _____76EE_6807_5355_4F4D,
        ["伤害"] = 18,
        ["伤害间隔"] = 1,
        ["持续时间"] = 3
    })
end
local function _____6D4B_8BD5STES_517C_5BB9(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D)
    STES_FireWithParams(
        "PeriodicAoe_Event",
        {
            {type = "string", name = "AoeEffectFileID", value = ____AOE_7279_6548},
            {type = "integer", name = "EffectID", value = 3},
            {type = "real", name = "EffectInterval", value = 1},
            {type = "unit", name = "EffectSourceUnit", value = _____6765_6E90_5355_4F4D},
            {type = "real", name = "EffectTime", value = 4},
            {type = "real", name = "r", value = 650},
            {
                type = "real",
                name = "x",
                value = GetUnitX(_____6765_6E90_5355_4F4D)
            },
            {
                type = "real",
                name = "y",
                value = GetUnitY(_____6765_6E90_5355_4F4D)
            }
        }
    )
    STES_FireWithParams("DebuffStacks", {{type = "unit", name = "TargetUnit", value = _____6765_6E90_5355_4F4D}, {type = "real", name = "Stacks", value = 7}, {type = "boolean", name = "腐败值", value = true}})
    STES_FireWithParams("禁锢", {
        {type = "unit", name = "BuffSource", value = _____6765_6E90_5355_4F4D},
        {type = "unit", name = "BuffTarget", value = _____76EE_6807_5355_4F4D},
        {type = "real", name = "HitDamage", value = 20},
        {type = "real", name = "DamageInterval", value = 1},
        {type = "real", name = "time", value = 3}
    })
    STES_FireWithParams("寄生", {
        {type = "unit", name = "BuffSource", value = _____6765_6E90_5355_4F4D},
        {type = "unit", name = "BuffTarget", value = _____76EE_6807_5355_4F4D},
        {type = "real", name = "HitDamage", value = 15},
        {type = "real", name = "DamageInterval", value = 1},
        {type = "real", name = "time", value = 3}
    })
end
local function _____6267_884C_5468_671F_8303_56F4_6548_679C_6D4B_8BD5()
    local _____6765_6E90_5355_4F4D = _____83B7_53D6_6D4B_8BD5_5927_6CD5_5E08()
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, "测试失败：找不到大法师 gg_unit_Hamg_0002")
        return
    end
    local _____76EE_6807_5355_4F4D = _____521B_5EFA_6D4B_8BD5_76EE_6807(_____6765_6E90_5355_4F4D)
    _____6D4B_8BD5TS_76F4_8C03(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D)
    _____6D4B_8BD5STES_517C_5BB9(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D)
    addDelayedCallback(8000, ____on_6E05_7406_5468_671F_8303_56F4_6548_679C_6D4B_8BD5_5355_4F4D)
    debugLogForce(
        _____6A21_5757_540D,
        "已执行：TS直调 + 4个STES兼容入口",
        "owner=",
        GetOwningPlayer(_____6765_6E90_5355_4F4D),
        "target=",
        _____76EE_6807_5355_4F4D
    )
end
local function ____on_5468_671F_8303_56F4_6548_679C_6D4B_8BD5_547D_4EE4()
    _____6267_884C_5468_671F_8303_56F4_6548_679C_6D4B_8BD5()
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_5468_671F_8303_56F4_6548_679C_6D4B_8BD5_547D_4EE4)
debugLogForce(_____6A21_5757_540D, ("已注册：" .. _____6D4B_8BD5_547D_4EE4) .. " 周期范围效果测试")
return ____exports
