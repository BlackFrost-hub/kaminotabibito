--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____533A_57DF_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.04．区域效果.区域效果")
local _____521B_5EFA_533A_57DF_6548_679C = _____533A_57DF_6548_679C["创建区域效果"]
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local createDelayedCall = ____require_result_0.createDelayedCall
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setBuff = ____require_result_1.SFB_setBuff
local SFB_setSlow = ____require_result_1.SFB_setSlow
local _____542F_7528_6D4B_8BD5 = true
local _____5F53_524D_6D4B_8BD5_5355_4F4D
local function _____663E_793A_533A_57DF_6D4B_8BD5_6587_672C(message, duration)
    DisplayTimedTextToPlayer(
        Player(0),
        0,
        0,
        duration,
        message
    )
end
local function _____533A_57DF_6548_679C_6D4B_8BD5__8FDB_5165(_____5355_4F4D)
    local _____6D4B_8BD5_5355_4F4D = _____5F53_524D_6D4B_8BD5_5355_4F4D
    if _____6D4B_8BD5_5355_4F4D == nil or _____6D4B_8BD5_5355_4F4D == 0 or _____5355_4F4D == nil or _____5355_4F4D == 0 or _____5355_4F4D == _____6D4B_8BD5_5355_4F4D then
        return
    end
    SFB_setSlow(
        _____6D4B_8BD5_5355_4F4D,
        _____5355_4F4D,
        0,
        30,
        1
    )
    _____663E_793A_533A_57DF_6D4B_8BD5_6587_672C("进入区域，减速1秒", 3)
end
local function _____533A_57DF_6548_679C_6D4B_8BD5__79BB_5F00(_____5355_4F4D)
    local _____6D4B_8BD5_5355_4F4D = _____5F53_524D_6D4B_8BD5_5355_4F4D
    if _____6D4B_8BD5_5355_4F4D == nil or _____6D4B_8BD5_5355_4F4D == 0 or _____5355_4F4D == nil or _____5355_4F4D == 0 or _____5355_4F4D == _____6D4B_8BD5_5355_4F4D then
        return
    end
    SFB_setBuff(_____6D4B_8BD5_5355_4F4D, _____5355_4F4D, 0, 1)
    _____663E_793A_533A_57DF_6D4B_8BD5_6587_672C("离开区域，眩晕1秒", 3)
end
local function _____533A_57DF_6548_679C_6D4B_8BD5__9500_6BC1()
    _____663E_793A_533A_57DF_6D4B_8BD5_6587_672C("区域效果已结束", 3)
end
local function _____533A_57DF_6548_679C_6D4B_8BD5__521B_5EFA()
    local _____6D4B_8BD5_5355_4F4D = _____5F53_524D_6D4B_8BD5_5355_4F4D
    if _____6D4B_8BD5_5355_4F4D == nil or _____6D4B_8BD5_5355_4F4D == 0 then
        return
    end
    _____521B_5EFA_533A_57DF_6548_679C({
        X = GetUnitX(_____6D4B_8BD5_5355_4F4D),
        Y = GetUnitY(_____6D4B_8BD5_5355_4F4D),
        ["半径"] = 400,
        ["持续时间"] = 10,
        ["检测间隔"] = 1,
        ["影响目标"] = "全部",
        ["所有者"] = _____6D4B_8BD5_5355_4F4D,
        ["周期伤害"] = 50,
        ["on进入"] = _____533A_57DF_6548_679C_6D4B_8BD5__8FDB_5165,
        ["on离开"] = _____533A_57DF_6548_679C_6D4B_8BD5__79BB_5F00,
        ["on销毁"] = _____533A_57DF_6548_679C_6D4B_8BD5__9500_6BC1
    })
    _____663E_793A_533A_57DF_6D4B_8BD5_6587_672C("区域效果测试：完整效果已创建", 5)
end
if _____542F_7528_6D4B_8BD5 then
    local _____6D4B_8BD5_5355_4F4D = g.gg_unit_Hamg_0002
    if _____6D4B_8BD5_5355_4F4D then
        _____5F53_524D_6D4B_8BD5_5355_4F4D = _____6D4B_8BD5_5355_4F4D
        createDelayedCall(2, _____533A_57DF_6548_679C_6D4B_8BD5__521B_5EFA)
    end
end
return ____exports
