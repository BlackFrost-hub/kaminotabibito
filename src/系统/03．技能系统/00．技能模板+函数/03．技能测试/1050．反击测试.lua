--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local GetHandleId
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.13．反击.index")
local _____6CE8_518C_53CD_51FB = ____index["注册反击"]
local _____83B7_53D6_53CD_51FB_6570_91CF = ____index["获取反击数量"]
local _____53CD_51FB_7C7B_578B = ____index["反击类型"]
local _____53CD_51FB_4F24_5BB3_7C7B_578B = ____index["反击伤害类型"]
--- 反击系统测试
-- 
-- 输入 1050：测试反击系统基本功能
--   - 创建敌人单位并攻击大法师
--   - 验证反击伤害触发
-- 
-- 输入 1051：测试AOE反击
--   - 创建多个敌人单位
--   - 验证范围反击
-- 
-- 输入 1052：测试距离条件反击
--   - 测试最小距离/最大距离条件
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_1.debugLogForce
local setDebug = ____require_result_1.setDebug
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_2.stringToFourCC
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local createDelayedCall = ____require_result_3.createDelayedCall
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local Player = jass.Player
local CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
local SetUnitLifePercent = jass.SetUnitLifePercent
local SetUnitState = jass.SetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local GetUnitState = jass.GetUnitState
local _____6B65_5175ID = "hfoo"
local _____517D_65CF_6B65_5175ID = "hpea"
local _____4E2D_7ACB_654C_5BF9 = 12
local _____73A9_5BB61 = 0
local _____6A21_5757_540D = "反击测试"
local _____6D4B_8BD5_53CD_51FB_5355_4F4D = nil
local _____6D4B_8BD5_653B_51FB_80051 = nil
local _____6D4B_8BD5_653B_51FB_80052 = nil
local _____6D4B_8BD5_653B_51FB_80053 = nil
local _____5F85_6E05_7406_5355_4F4D = {}
--- 清理测试单位
local function _____6E05_7406_6D4B_8BD5_5355_4F4D()
    for ____, u in ipairs(_____5F85_6E05_7406_5355_4F4D) do
        if u ~= nil and u ~= 0 then
            RemoveUnit(u)
        end
    end
    _____5F85_6E05_7406_5355_4F4D = {}
    _____6D4B_8BD5_53CD_51FB_5355_4F4D = nil
    _____6D4B_8BD5_653B_51FB_80051 = nil
    _____6D4B_8BD5_653B_51FB_80052 = nil
    _____6D4B_8BD5_653B_51FB_80053 = nil
    debugLogForce(_____6A21_5757_540D, "已清理所有测试单位")
end
--- 获取大法师（反击单位）
local function _____83B7_53D6_6D4B_8BD5_5927_6CD5_5E08()
    return g.gg_unit_Hamg_0002
end
--- 创建敌人单位（攻击者）
local function _____521B_5EFA_654C_4EBA_5355_4F4D(x, y, unitId)
    local u = CreateUnit(
        Player(_____4E2D_7ACB_654C_5BF9),
        stringToFourCC(unitId),
        x,
        y,
        0
    )
    _____5F85_6E05_7406_5355_4F4D[#_____5F85_6E05_7406_5355_4F4D + 1] = u
    return u
end
--- 执行伤害（模拟敌人攻击）
local function _____6A21_62DF_653B_51FB(_____653B_51FB_8005, _____76EE_6807, _____4F24_5BB3_503C)
    if not _____653B_51FB_8005 or not _____76EE_6807 then
        return
    end
    local j = jass
    local _____5F53_524D_751F_547D = GetUnitState(_____76EE_6807, UNIT_STATE_LIFE)
    local _____65B0_751F_547D = math.max(1, _____5F53_524D_751F_547D - _____4F24_5BB3_503C)
    j:SetUnitState(_____76EE_6807, UNIT_STATE_LIFE, _____65B0_751F_547D)
    debugLogForce(
        _____6A21_5757_540D,
        "模拟攻击: 攻击者=",
        GetHandleId(_____653B_51FB_8005),
        "目标=",
        GetHandleId(_____76EE_6807),
        "伤害=",
        _____4F24_5BB3_503C
    )
end
GetHandleId = jass.GetHandleId
--- 测试基本反击
local function _____6D4B_8BD5_57FA_672C_53CD_51FB()
    local _____53CD_51FB_5355_4F4D = _____83B7_53D6_6D4B_8BD5_5927_6CD5_5E08()
    if not _____53CD_51FB_5355_4F4D then
        debugLogForce(_____6A21_5757_540D, "错误：未找到大法师")
        return
    end
    _____6E05_7406_6D4B_8BD5_5355_4F4D()
    local x = GetUnitX(_____53CD_51FB_5355_4F4D) + 200
    local y = GetUnitY(_____53CD_51FB_5355_4F4D)
    _____6D4B_8BD5_653B_51FB_80051 = _____521B_5EFA_654C_4EBA_5355_4F4D(x, y, _____6B65_5175ID)
    local _____5B9E_4F8BID = _____6CE8_518C_53CD_51FB({
        ["反击来源"] = _____53CD_51FB_5355_4F4D,
        ["反击类型"] = _____53CD_51FB_7C7B_578B["任意伤害"],
        ["伤害计算方式"] = _____53CD_51FB_4F24_5BB3_7C7B_578B["固定值"],
        ["伤害值"] = 50,
        ["距离条件"] = {["最小距离"] = 0, ["最大距离"] = 1000},
        ["冷却时间"] = 0,
        ["是否AOE"] = false,
        ["只反击来源"] = true,
        ["反击特效"] = "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapTargetArt.mdl",
        ["特效附着点"] = "origin"
    })
    local _____53CD_51FB_6570_91CF = _____83B7_53D6_53CD_51FB_6570_91CF(_____53CD_51FB_5355_4F4D)
    debugLogForce(
        _____6A21_5757_540D,
        "基本反击测试: 注册成功 实例ID=",
        _____5B9E_4F8BID,
        "反击数量=",
        _____53CD_51FB_6570_91CF
    )
    createDelayedCall(
        1,
        function()
            _____6A21_62DF_653B_51FB(_____6D4B_8BD5_653B_51FB_80051, _____53CD_51FB_5355_4F4D, 100)
            debugLogForce(_____6A21_5757_540D, "已模拟攻击，触发反击")
            createDelayedCall(5, _____6E05_7406_6D4B_8BD5_5355_4F4D)
        end
    )
end
--- 测试AOE反击
local function _____6D4B_8BD5AOE_53CD_51FB()
    local _____53CD_51FB_5355_4F4D = _____83B7_53D6_6D4B_8BD5_5927_6CD5_5E08()
    if not _____53CD_51FB_5355_4F4D then
        debugLogForce(_____6A21_5757_540D, "错误：未找到大法师")
        return
    end
    _____6E05_7406_6D4B_8BD5_5355_4F4D()
    local baseX = GetUnitX(_____53CD_51FB_5355_4F4D)
    local baseY = GetUnitY(_____53CD_51FB_5355_4F4D)
    _____6D4B_8BD5_653B_51FB_80051 = _____521B_5EFA_654C_4EBA_5355_4F4D(baseX + 150, baseY, _____6B65_5175ID)
    _____6D4B_8BD5_653B_51FB_80052 = _____521B_5EFA_654C_4EBA_5355_4F4D(baseX + 200, baseY + 100, _____6B65_5175ID)
    _____6D4B_8BD5_653B_51FB_80053 = _____521B_5EFA_654C_4EBA_5355_4F4D(baseX + 250, baseY - 50, _____6B65_5175ID)
    _____6CE8_518C_53CD_51FB({
        ["反击来源"] = _____53CD_51FB_5355_4F4D,
        ["反击类型"] = _____53CD_51FB_7C7B_578B["任意伤害"],
        ["伤害计算方式"] = _____53CD_51FB_4F24_5BB3_7C7B_578B["固定值"],
        ["伤害值"] = 30,
        ["距离条件"] = {["最小距离"] = 0, ["最大距离"] = 500},
        ["冷却时间"] = 0,
        ["是否AOE"] = true,
        ["AOE半径"] = 400,
        ["只反击来源"] = false,
        ["反击特效"] = "Abilities\\Spells\\NightElf\\Regeneration\\RegenerationTarget.mdl",
        ["特效附着点"] = "origin"
    })
    debugLogForce(_____6A21_5757_540D, "AOE反击测试: 已注册，AOE半径400")
    createDelayedCall(
        1,
        function()
            _____6A21_62DF_653B_51FB(_____6D4B_8BD5_653B_51FB_80051, _____53CD_51FB_5355_4F4D, 80)
            debugLogForce(_____6A21_5757_540D, "已模拟攻击，触发AOE反击")
            createDelayedCall(5, _____6E05_7406_6D4B_8BD5_5355_4F4D)
        end
    )
end
--- 测试百分比反击
local function _____6D4B_8BD5_767E_5206_6BD4_53CD_51FB()
    local _____53CD_51FB_5355_4F4D = _____83B7_53D6_6D4B_8BD5_5927_6CD5_5E08()
    if not _____53CD_51FB_5355_4F4D then
        debugLogForce(_____6A21_5757_540D, "错误：未找到大法师")
        return
    end
    _____6E05_7406_6D4B_8BD5_5355_4F4D()
    local x = GetUnitX(_____53CD_51FB_5355_4F4D) + 200
    local y = GetUnitY(_____53CD_51FB_5355_4F4D)
    _____6D4B_8BD5_653B_51FB_80051 = _____521B_5EFA_654C_4EBA_5355_4F4D(x, y, _____6B65_5175ID)
    _____6CE8_518C_53CD_51FB({
        ["反击来源"] = _____53CD_51FB_5355_4F4D,
        ["反击类型"] = _____53CD_51FB_7C7B_578B["任意伤害"],
        ["伤害计算方式"] = _____53CD_51FB_4F24_5BB3_7C7B_578B["百分比"],
        ["伤害值"] = 0.5,
        ["距离条件"] = {["最小距离"] = 0, ["最大距离"] = 1000},
        ["冷却时间"] = 0,
        ["是否AOE"] = false,
        ["只反击来源"] = true
    })
    debugLogForce(_____6A21_5757_540D, "百分比反击测试: 反击伤害=受到伤害的50%")
    createDelayedCall(
        1,
        function()
            _____6A21_62DF_653B_51FB(_____6D4B_8BD5_653B_51FB_80051, _____53CD_51FB_5355_4F4D, 100)
            createDelayedCall(5, _____6E05_7406_6D4B_8BD5_5355_4F4D)
        end
    )
end
--- 测试仅攻击反击
local function _____6D4B_8BD5_4EC5_653B_51FB_53CD_51FB()
    local _____53CD_51FB_5355_4F4D = _____83B7_53D6_6D4B_8BD5_5927_6CD5_5E08()
    if not _____53CD_51FB_5355_4F4D then
        debugLogForce(_____6A21_5757_540D, "错误：未找到大法师")
        return
    end
    _____6E05_7406_6D4B_8BD5_5355_4F4D()
    local x = GetUnitX(_____53CD_51FB_5355_4F4D) + 200
    local y = GetUnitY(_____53CD_51FB_5355_4F4D)
    _____6D4B_8BD5_653B_51FB_80051 = _____521B_5EFA_654C_4EBA_5355_4F4D(x, y, _____6B65_5175ID)
    _____6CE8_518C_53CD_51FB({
        ["反击来源"] = _____53CD_51FB_5355_4F4D,
        ["反击类型"] = _____53CD_51FB_7C7B_578B["仅攻击"],
        ["伤害计算方式"] = _____53CD_51FB_4F24_5BB3_7C7B_578B["固定值"],
        ["伤害值"] = 40,
        ["距离条件"] = {},
        ["冷却时间"] = 0,
        ["是否AOE"] = false,
        ["只反击来源"] = true
    })
    debugLogForce(_____6A21_5757_540D, "仅攻击反击测试: 只有普攻触发")
    createDelayedCall(3, _____6E05_7406_6D4B_8BD5_5355_4F4D)
end
--- 聊天命令回调
local function ____on_804A_59291050_547D_4EE4()
    debugLogForce(_____6A21_5757_540D, "执行测试: 基本反击")
    _____6D4B_8BD5_57FA_672C_53CD_51FB()
end
local function ____on_804A_59291051_547D_4EE4()
    debugLogForce(_____6A21_5757_540D, "执行测试: AOE反击")
    _____6D4B_8BD5AOE_53CD_51FB()
end
local function ____on_804A_59291052_547D_4EE4()
    debugLogForce(_____6A21_5757_540D, "执行测试: 百分比反击")
    _____6D4B_8BD5_767E_5206_6BD4_53CD_51FB()
end
local function ____on_804A_59291053_547D_4EE4()
    debugLogForce(_____6A21_5757_540D, "执行测试: 仅攻击反击")
    _____6D4B_8BD5_4EC5_653B_51FB_53CD_51FB()
end
local function ____on_804A_59291059_547D_4EE4()
    debugLogForce(_____6A21_5757_540D, "清理所有测试单位")
    _____6E05_7406_6D4B_8BD5_5355_4F4D()
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("1050", ____on_804A_59291050_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("1051", ____on_804A_59291051_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("1052", ____on_804A_59291052_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("1053", ____on_804A_59291053_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("1059", ____on_804A_59291059_547D_4EE4)
debugLogForce(_____6A21_5757_540D, "已注册测试命令: 1050-基本反击, 1051-AOE反击, 1052-百分比反击, 1053-仅攻击反击, 1059-清理")
return ____exports
