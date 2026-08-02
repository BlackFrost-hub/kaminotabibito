--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local KEY_STATE = ____index.KEY_STATE
local registerKeyEventByCode = ____index.registerKeyEventByCode
--- 镜头高度控制
-- 
-- 主键盘和数字小键盘的 +/- 每次调整本地玩家镜头高度 200。
local jass = require("jass.common")
local _____955C_5934_9AD8_5EA6_6B65_957F = 200
local _____9ED8_8BA4_955C_5934_9AD8_5EA6_504F_79FB = 0
local ____Boss_6D4B_8BD5_955C_5934_9AD8_5EA6_504F_79FB = _____9ED8_8BA4_955C_5934_9AD8_5EA6_504F_79FB + 400
local _____4E3B_952E_76D8_52A0_53F7_952E = 187
local _____4E3B_952E_76D8_51CF_53F7_952E = 189
local _____6570_5B57_5C0F_952E_76D8_52A0_53F7_952E = 107
local _____6570_5B57_5C0F_952E_76D8_51CF_53F7_952E = 109
local CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET
local GetCameraField = jass.GetCameraField
local SetCameraField = jass.SetCameraField
local GetLocalPlayer = jass.GetLocalPlayer
local _____5DF2_521D_59CB_5316 = false
____exports["按步长调整本地镜头高度"] = function(_____6B65_6570)
    local _____5F53_524D_955C_5934_9AD8_5EA6 = GetCameraField(CAMERA_FIELD_ZOFFSET)
    SetCameraField(CAMERA_FIELD_ZOFFSET, _____5F53_524D_955C_5934_9AD8_5EA6 + _____6B65_6570 * _____955C_5934_9AD8_5EA6_6B65_957F, 0)
end
--- 只调整指定玩家的本地镜头，避免传送时影响其他玩家。
____exports["按步长调整玩家镜头高度"] = function(_____73A9_5BB6, _____6B65_6570)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 or GetLocalPlayer() ~= _____73A9_5BB6 then
        return
    end
    ____exports["按步长调整本地镜头高度"](_____6B65_6570)
end
local function _____62AC_9AD8_955C_5934(self)
    ____exports["按步长调整本地镜头高度"](1)
end
local function _____964D_4F4E_955C_5934(self)
    ____exports["按步长调整本地镜头高度"](-1)
end
--- Boss 测试场景使用，每次都固定设置为默认镜头高度以上 400。
____exports["抬高Boss测试镜头"] = function()
    SetCameraField(CAMERA_FIELD_ZOFFSET, ____Boss_6D4B_8BD5_955C_5934_9AD8_5EA6_504F_79FB, 0)
end
function ____exports.init()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerKeyEventByCode(
        nil,
        _____4E3B_952E_76D8_52A0_53F7_952E,
        KEY_STATE.UP,
        false,
        _____62AC_9AD8_955C_5934
    )
    registerKeyEventByCode(
        nil,
        _____6570_5B57_5C0F_952E_76D8_52A0_53F7_952E,
        KEY_STATE.UP,
        false,
        _____62AC_9AD8_955C_5934
    )
    registerKeyEventByCode(
        nil,
        _____4E3B_952E_76D8_51CF_53F7_952E,
        KEY_STATE.UP,
        false,
        _____964D_4F4E_955C_5934
    )
    registerKeyEventByCode(
        nil,
        _____6570_5B57_5C0F_952E_76D8_51CF_53F7_952E,
        KEY_STATE.UP,
        false,
        _____964D_4F4E_955C_5934
    )
end
return ____exports
