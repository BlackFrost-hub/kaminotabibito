--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 镜头高度控制
-- 
-- 主键盘和数字小键盘的 +/- 每次调整触发玩家镜头距离 200。
local jass = require("jass.common")
local japi = require("jass.japi")
local KEY_STATE = {UP = 1}
local _____955C_5934_9AD8_5EA6_6B65_957F = 200
local _____9ED8_8BA4_955C_5934_9AD8_5EA6 = 3000
local ____Boss_6D4B_8BD5_955C_5934_9AD8_5EA6 = _____9ED8_8BA4_955C_5934_9AD8_5EA6
local _____4E3B_952E_76D8_52A0_53F7_952E = 187
local _____4E3B_952E_76D8_51CF_53F7_952E = 189
local _____6570_5B57_5C0F_952E_76D8_52A0_53F7_952E = 107
local _____6570_5B57_5C0F_952E_76D8_51CF_53F7_952E = 109
local CAMERA_FIELD_TARGET_DISTANCE = jass.CAMERA_FIELD_TARGET_DISTANCE
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
local SetCameraFieldForPlayer = ____require_result_0.SetCameraFieldForPlayer
local DzGetTriggerKeyPlayer = japi.DzGetTriggerKeyPlayer
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local _____73A9_5BB6_955C_5934_6B65_6570 = {}
local _____5DF2_521D_59CB_5316 = false
____exports["按步长调整本地镜头高度"] = function(_____6B65_6570)
    local _____73A9_5BB6 = DzGetTriggerKeyPlayer()
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____73A9_5BB6ID = jass.GetPlayerId(_____73A9_5BB6)
    local _____65B0_6B65_6570 = (_____73A9_5BB6_955C_5934_6B65_6570[_____73A9_5BB6ID] or 0) + _____6B65_6570
    _____73A9_5BB6_955C_5934_6B65_6570[_____73A9_5BB6ID] = _____65B0_6B65_6570
    local _____65B0_9AD8_5EA6 = _____9ED8_8BA4_955C_5934_9AD8_5EA6 + _____65B0_6B65_6570 * _____955C_5934_9AD8_5EA6_6B65_957F
    SetCameraFieldForPlayer(_____73A9_5BB6, CAMERA_FIELD_TARGET_DISTANCE, _____65B0_9AD8_5EA6, 0)
    debugLogForce(
        "镜头高度控制",
        "按键回调成功",
        "playerId",
        _____73A9_5BB6ID,
        "step",
        _____6B65_6570,
        "zOffset",
        _____65B0_9AD8_5EA6
    )
end
--- 只调整指定玩家的本地镜头，避免传送时影响其他玩家。
____exports["按步长调整玩家镜头高度"] = function(_____73A9_5BB6, _____6B65_6570)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____73A9_5BB6ID = jass.GetPlayerId(_____73A9_5BB6)
    local _____65B0_6B65_6570 = (_____73A9_5BB6_955C_5934_6B65_6570[_____73A9_5BB6ID] or 0) + _____6B65_6570
    _____73A9_5BB6_955C_5934_6B65_6570[_____73A9_5BB6ID] = _____65B0_6B65_6570
    SetCameraFieldForPlayer(_____73A9_5BB6, CAMERA_FIELD_TARGET_DISTANCE, _____9ED8_8BA4_955C_5934_9AD8_5EA6 + _____65B0_6B65_6570 * _____955C_5934_9AD8_5EA6_6B65_957F, 0)
end
local function _____62AC_9AD8_955C_5934(self)
    ____exports["按步长调整本地镜头高度"](1)
end
local function _____964D_4F4E_955C_5934(self)
    ____exports["按步长调整本地镜头高度"](-1)
end
--- Boss 测试场景使用，每次都固定设置为默认镜头高度以上 400。
____exports["抬高Boss测试镜头"] = function()
    local _____73A9_5BB6 = DzGetTriggerKeyPlayer()
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____73A9_5BB6ID = jass.GetPlayerId(_____73A9_5BB6)
    _____73A9_5BB6_955C_5934_6B65_6570[_____73A9_5BB6ID] = 0
    SetCameraFieldForPlayer(_____73A9_5BB6, CAMERA_FIELD_TARGET_DISTANCE, ____Boss_6D4B_8BD5_955C_5934_9AD8_5EA6, 0)
end
function ____exports.init()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    local trigger = jass.CreateTrigger()
    japi.DzTriggerRegisterKeyEvent(
        trigger,
        _____4E3B_952E_76D8_52A0_53F7_952E,
        KEY_STATE.UP,
        true,
        nil
    )
    japi.DzTriggerRegisterKeyEvent(
        trigger,
        _____6570_5B57_5C0F_952E_76D8_52A0_53F7_952E,
        KEY_STATE.UP,
        true,
        nil
    )
    japi.DzTriggerRegisterKeyEvent(
        trigger,
        _____4E3B_952E_76D8_51CF_53F7_952E,
        KEY_STATE.UP,
        true,
        nil
    )
    japi.DzTriggerRegisterKeyEvent(
        trigger,
        _____6570_5B57_5C0F_952E_76D8_51CF_53F7_952E,
        KEY_STATE.UP,
        true,
        nil
    )
    jass.TriggerAddAction(
        trigger,
        function()
            local key = japi.DzGetTriggerKey()
            debugLogForce("镜头高度控制", "键盘触发", "key", key)
            if key == _____4E3B_952E_76D8_52A0_53F7_952E or key == _____6570_5B57_5C0F_952E_76D8_52A0_53F7_952E then
                _____62AC_9AD8_955C_5934(nil)
            end
            if key == _____4E3B_952E_76D8_51CF_53F7_952E or key == _____6570_5B57_5C0F_952E_76D8_51CF_53F7_952E then
                _____964D_4F4E_955C_5934(nil)
            end
        end
    )
end
return ____exports
