--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____6247_5F62_533A_57DF_6D4B_8BD5__654C_65B9_7B5B_9009, g
local ____09_FF0E_63D0_793A_7279_6548 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_7EA2_8272_6247_5F62_63D0_793A_5708 = ____09_FF0E_63D0_793A_7279_6548["创建红色扇形提示圈"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.index")
local _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____index["获取扇形区域单位"]
local ____02_FF0E_5355_4F4D_4E0E_8303_56F4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local isUnitEnemy = ____02_FF0E_5355_4F4D_4E0E_8303_56F4.isUnitEnemy
function _____6247_5F62_533A_57DF_6D4B_8BD5__654C_65B9_7B5B_9009(_____5355_4F4D)
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        return false
    end
    return isUnitEnemy(_____5355_4F4D, _____5927_6CD5_5E08)
end
--- 扇形区域测试
-- 
-- 输入"1005"后，以 `gg_unit_Hamg_0002` 为中心，
-- 按单位当前朝向创建一个红色扇形提示特效，并统计扇形内敌方单位数量。
local jass = require("jass.common")
g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6A21_5757_540D = "扇形区域测试"
local _____6D4B_8BD5_547D_4EE4 = "1005"
local _____6247_5F62_89D2_5EA6 = 90
local _____6247_5F62_5916_534A_5F84 = 512
local _____6247_5F62_6A21_578B_5C3A_5BF8 = 1
local _____6D4B_8BD5_4F24_5BB3 = 100
local function ____on_804A_59291005_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local x = GetUnitX(_____5927_6CD5_5E08)
    local y = GetUnitY(_____5927_6CD5_5E08)
    local _____671D_5411 = GetUnitFacing(_____5927_6CD5_5E08)
    _____521B_5EFA_7EA2_8272_6247_5F62_63D0_793A_5708(
        x,
        y,
        _____671D_5411,
        _____6247_5F62_6A21_578B_5C3A_5BF8,
        2
    )
    local _____547D_4E2D_5355_4F4D = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = x,
        Y = y,
        ["半径"] = _____6247_5F62_5916_534A_5F84,
        ["方向角"] = _____671D_5411,
        ["扇形角度"] = _____6247_5F62_89D2_5EA6,
        ["单位筛选"] = _____6247_5F62_533A_57DF_6D4B_8BD5__654C_65B9_7B5B_9009
    })
    for ____, _____5355_4F4D in ipairs(_____547D_4E2D_5355_4F4D) do
        UnitDamageTarget(
            _____5927_6CD5_5E08,
            _____5355_4F4D,
            _____6D4B_8BD5_4F24_5BB3,
            false,
            false,
            ATTACK_TYPE_NORMAL,
            DAMAGE_TYPE_NORMAL,
            WEAPON_TYPE_WHOKNOWS
        )
    end
    debugLogForce(
        _____6A21_5757_540D,
        "已创建扇形测试：朝向=",
        _____671D_5411,
        "扇形角=",
        _____6247_5F62_89D2_5EA6,
        "外半径=",
        _____6247_5F62_5916_534A_5F84,
        "敌方命中=",
        #_____547D_4E2D_5355_4F4D,
        "每个目标伤害=",
        _____6D4B_8BD5_4F24_5BB3
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291005_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "创建扇形提示特效并统计敌方单位")
return ____exports
