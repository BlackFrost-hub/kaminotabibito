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
local _____4E3B_952E_76D8_52A0_53F7_952E = 187
local _____4E3B_952E_76D8_51CF_53F7_952E = 189
local _____6570_5B57_5C0F_952E_76D8_52A0_53F7_952E = 107
local _____6570_5B57_5C0F_952E_76D8_51CF_53F7_952E = 109
local CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET
local AdjustCameraField = jass.AdjustCameraField
local _____5DF2_521D_59CB_5316 = false
local function _____62AC_9AD8_955C_5934(self)
    AdjustCameraField(CAMERA_FIELD_ZOFFSET, _____955C_5934_9AD8_5EA6_6B65_957F, 0)
end
local function _____964D_4F4E_955C_5934(self)
    AdjustCameraField(CAMERA_FIELD_ZOFFSET, -_____955C_5934_9AD8_5EA6_6B65_957F, 0)
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
