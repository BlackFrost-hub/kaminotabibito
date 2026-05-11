--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____index["创建原生弹幕"]
local _____521B_5EFA_9501_5B9A_5355_4F4D_4E8C_9636_8D1D_585E_5C14_52A0_901F_5EA6XYZ_8F68_8FF9 = ____index["创建锁定单位二阶贝塞尔加速度XYZ轨迹"]
--- 贝塞尔锁定加速度测试
-- 
-- 输入 "1013"：
-- - 搜索 gg_unit_Hamg_0002 附近敌人作为锁定终点。
-- - 发射锁定单位二阶贝塞尔 XYZ 弹幕。
-- - 初速 260，飞行 250 码后开始加速度 650。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_2.isUnitEnemy
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitName = jass.GetUnitName
local GetHandleId = jass.GetHandleId
local SquareRoot = jass.SquareRoot
local Cos = jass.Cos
local Sin = jass.Sin
local _____6A21_5757_540D = "贝塞尔锁定加速度测试"
local _____6D4B_8BD5_547D_4EE4 = "1013"
local _____641C_7D22_534A_5F84 = 1000
local _____5DF2_6CE8_518C = false
local function _____67E5_627E_6700_8FD1_654C_4EBA(_____6765_6E90_5355_4F4D)
    local x = GetUnitX(_____6765_6E90_5355_4F4D)
    local y = GetUnitY(_____6765_6E90_5355_4F4D)
    local _____5019_9009 = getUnitsInRange(x, y, _____641C_7D22_534A_5F84)
    local _____6700_4F73_76EE_6807 = nil
    local _____6700_4F73_8DDD_79BB = 0
    do
        local i = 0
        while i < #_____5019_9009 do
            do
                local _____5355_4F4D = _____5019_9009[i + 1]
                if not isUnitEnemy(_____5355_4F4D, _____6765_6E90_5355_4F4D) then
                    goto __continue4
                end
                local dx = GetUnitX(_____5355_4F4D) - x
                local dy = GetUnitY(_____5355_4F4D) - y
                local _____8DDD_79BB = SquareRoot(dx * dx + dy * dy)
                if _____6700_4F73_76EE_6807 == nil or _____8DDD_79BB < _____6700_4F73_8DDD_79BB then
                    _____6700_4F73_76EE_6807 = _____5355_4F4D
                    _____6700_4F73_8DDD_79BB = _____8DDD_79BB
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
    return _____6700_4F73_76EE_6807
end
local function _____524D_65B9X(_____5355_4F4D, distance)
    local angle = GetUnitFacing(_____5355_4F4D) * jass.bj_DEGTORAD
    return GetUnitX(_____5355_4F4D) + Cos(angle) * distance
end
local function _____524D_65B9Y(_____5355_4F4D, distance)
    local angle = GetUnitFacing(_____5355_4F4D) * jass.bj_DEGTORAD
    return GetUnitY(_____5355_4F4D) + Sin(angle) * distance
end
local function _____9501_5B9A_8D1D_585E_5C14__547D_4E2D(_____76EE_6807_5355_4F4D, _____5F39_5E55ID)
    debugLogForce(
        _____6A21_5757_540D,
        "命中锁定弹幕",
        "弹幕ID=",
        _____5F39_5E55ID,
        "目标=",
        GetUnitName(_____76EE_6807_5355_4F4D),
        "#",
        GetHandleId(_____76EE_6807_5355_4F4D)
    )
end
local function _____9501_5B9A_8D1D_585E_5C14__5230_8FBE(_____5F39_5E55ID, _____539F_56E0)
    debugLogForce(
        _____6A21_5757_540D,
        "到达目标点",
        "弹幕ID=",
        _____5F39_5E55ID,
        "原因=",
        _____539F_56E0
    )
end
local function _____9501_5B9A_8D1D_585E_5C14__7ED3_675F(_____539F_56E0, _____5F39_5E55ID)
    debugLogForce(
        _____6A21_5757_540D,
        "结束",
        "弹幕ID=",
        _____5F39_5E55ID,
        "原因=",
        _____539F_56E0
    )
end
local function ____on_804A_59291013_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local _____76EE_6807 = _____67E5_627E_6700_8FD1_654C_4EBA(_____5927_6CD5_5E08)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：附近未找到敌人")
        return
    end
    local startX = _____524D_65B9X(_____5927_6CD5_5E08, 80)
    local startY = _____524D_65B9Y(_____5927_6CD5_5E08, 80)
    local ctrlX = _____524D_65B9X(_____5927_6CD5_5E08, 420)
    local ctrlY = _____524D_65B9Y(_____5927_6CD5_5E08, 420)
    local _____5B9E_4F8B = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____5927_6CD5_5E08,
        X = startX,
        Y = startY,
        ["方向角"] = GetUnitFacing(_____5927_6CD5_5E08),
        ["速度"] = 0,
        ["生命周期"] = 8,
        ["命中半径"] = 110,
        ["碰撞消失"] = true,
        ["伤害值"] = 55,
        ["影响目标"] = "敌方",
        ["模型"] = "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
        ["轨迹采样器"] = _____521B_5EFA_9501_5B9A_5355_4F4D_4E8C_9636_8D1D_585E_5C14_52A0_901F_5EA6XYZ_8F68_8FF9(
            startX,
            startY,
            80,
            ctrlX,
            ctrlY,
            420,
            _____76EE_6807,
            80,
            260,
            650,
            250
        ),
        ["on命中单位"] = _____9501_5B9A_8D1D_585E_5C14__547D_4E2D,
        ["on到达目标点"] = _____9501_5B9A_8D1D_585E_5C14__5230_8FBE,
        ["on结束"] = _____9501_5B9A_8D1D_585E_5C14__7ED3_675F
    })
    debugLogForce(
        _____6A21_5757_540D,
        "已发射锁定加速度贝塞尔弹幕",
        "弹幕ID=",
        _____5B9E_4F8B["弹幕ID"],
        "目标=",
        GetUnitName(_____76EE_6807),
        "#",
        GetHandleId(_____76EE_6807)
    )
end
local function _____6CE8_518C_804A_59291013_6D4B_8BD5()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    local trig = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        trig,
        Player(0),
        _____6D4B_8BD5_547D_4EE4,
        true
    )
    TriggerAddAction(trig, ____on_804A_59291013_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "发射锁定加速度贝塞尔弹幕")
end
_____6CE8_518C_804A_59291013_6D4B_8BD5()
return ____exports
