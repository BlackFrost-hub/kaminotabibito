local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____02_FF0E_62A4_76FE_5B9E_4F8B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.02．护盾实例")
local _____83B7_53D6_5355_4F4D_603B_62A4_76FE_503C = ____02_FF0E_62A4_76FE_5B9E_4F8B["获取单位总护盾值"]
local _____53D6_53E5_67C4ID = ____02_FF0E_62A4_76FE_5B9E_4F8B["取句柄ID"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
local offTick10ms = ____require_result_0.offTick10ms
local GetHandleId = jass.GetHandleId
local Player = jass.Player
local CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitScale = jass.SetUnitScale
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitVertexColor = jass.SetUnitVertexColor
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local R2I = jass.R2I
local SHIELD_BAR_UNIT_ID = 1935827314
local SHIELD_BAR_OWNER_PLAYER_ID = 4
local DEFAULT_HEIGHT_OFFSET = 100
local UNIT_ALIVE_LIFE = 0.405
local COLOR_DEFAULT = {r = 100, g = 200, b = 255, a = 255}
local COLOR_PHYSICAL = {r = 180, g = 100, b = 30, a = 255}
local COLOR_MAGICAL = {r = 30, g = 30, b = 180, a = 255}
local COLOR_GENERAL = {r = 200, g = 200, b = 200, a = 255}
local _____62A4_76FE_6761_6620_5C04 = __TS__New(Map)
local _____5DF2_6CE8_518C_8BA1_65F6_5668 = false
local function _____5355_4F4D_5B58_6D3B(u)
    if u == nil or u == 0 then
        return false
    end
    if GetUnitTypeId(u) == 0 then
        return false
    end
    if IsUnitType(u, jass.UNIT_TYPE_DEAD) then
        return false
    end
    return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
local function _____88C1_526A_5230_5B57_8282(value)
    if value <= 0 then
        return 0
    end
    if value >= 255 then
        return 255
    end
    return R2I(value)
end
local function _____5B9E_6570_8F6C_6574_6570(value)
    return R2I(value)
end
local function _____8BBE_7F6E_62A4_76FE_6761_4F4D_7F6E(_____6570_636E)
    if not _____5355_4F4D_5B58_6D3B(_____6570_636E["护盾条单位"]) or not _____5355_4F4D_5B58_6D3B(_____6570_636E["跟随单位"]) then
        return
    end
    SetUnitX(
        _____6570_636E["护盾条单位"],
        GetUnitX(_____6570_636E["跟随单位"])
    )
    SetUnitY(
        _____6570_636E["护盾条单位"],
        GetUnitY(_____6570_636E["跟随单位"])
    )
    SetUnitFlyHeight(
        _____6570_636E["护盾条单位"],
        GetUnitFlyHeight(_____6570_636E["跟随单位"]) + _____6570_636E["高度偏移"],
        0
    )
end
local function _____8BBE_7F6E_62A4_76FE_6761_989C_8272(_____6570_636E, _____989C_8272)
    if not _____5355_4F4D_5B58_6D3B(_____6570_636E["护盾条单位"]) then
        return
    end
    SetUnitVertexColor(
        _____6570_636E["护盾条单位"],
        _____88C1_526A_5230_5B57_8282(_____989C_8272.r),
        _____88C1_526A_5230_5B57_8282(_____989C_8272.g),
        _____88C1_526A_5230_5B57_8282(_____989C_8272.b),
        _____88C1_526A_5230_5B57_8282(_____989C_8272.a)
    )
    _____6570_636E["当前颜色"] = _____989C_8272
end
local function _____8BBE_7F6E_62A4_76FE_6761_6BD4_4F8B(_____6570_636E, _____6BD4_4F8B)
    if not _____5355_4F4D_5B58_6D3B(_____6570_636E["护盾条单位"]) then
        return
    end
    local _____5E27_7D22_5F15 = _____5B9E_6570_8F6C_6574_6570(_____6BD4_4F8B * 99)
    if _____5E27_7D22_5F15 < 0 then
        _____5E27_7D22_5F15 = 0
    end
    if _____5E27_7D22_5F15 > 99 then
        _____5E27_7D22_5F15 = 99
    end
    if type(SetUnitAnimationByIndex) == "function" then
        SetUnitAnimationByIndex(_____6570_636E["护盾条单位"], _____5E27_7D22_5F15)
    end
end
local function _____7ACB_5373_79FB_9664_62A4_76FE_6761_5355_4F4D(_____62A4_76FE_6761_5355_4F4D)
    if _____62A4_76FE_6761_5355_4F4D == nil or _____62A4_76FE_6761_5355_4F4D == 0 then
        return
    end
    if GetUnitTypeId(_____62A4_76FE_6761_5355_4F4D) == 0 then
        return
    end
    RemoveUnit(_____62A4_76FE_6761_5355_4F4D)
end
local function _____79FB_9664_62A4_76FE_6761(_____5355_4F4DID)
    local _____6570_636E = _____62A4_76FE_6761_6620_5C04:get(_____5355_4F4DID)
    if _____6570_636E == nil then
        return
    end
    _____7ACB_5373_79FB_9664_62A4_76FE_6761_5355_4F4D(_____6570_636E["护盾条单位"])
    _____62A4_76FE_6761_6620_5C04:delete(_____5355_4F4DID)
end
local function _____66F4_65B0_6240_6709_62A4_76FE_6761_4F4D_7F6E()
    for ____, ____value in __TS__Iterator(_____62A4_76FE_6761_6620_5C04) do
        local _____5355_4F4DID = ____value[1]
        local _____6570_636E = ____value[2]
        do
            if not _____5355_4F4D_5B58_6D3B(_____6570_636E["跟随单位"]) or not _____5355_4F4D_5B58_6D3B(_____6570_636E["护盾条单位"]) then
                _____79FB_9664_62A4_76FE_6761(_____5355_4F4DID)
                goto __continue25
            end
            _____8BBE_7F6E_62A4_76FE_6761_4F4D_7F6E(_____6570_636E)
            local _____5F53_524D_603B_62A4_76FE = _____83B7_53D6_5355_4F4D_603B_62A4_76FE_503C(_____5355_4F4DID)
            if _____5F53_524D_603B_62A4_76FE <= 0 then
                _____79FB_9664_62A4_76FE_6761(_____5355_4F4DID)
                goto __continue25
            end
            if _____5F53_524D_603B_62A4_76FE > _____6570_636E["初始总护盾"] then
                _____6570_636E["初始总护盾"] = _____5F53_524D_603B_62A4_76FE
            end
            local _____6BD4_4F8B = _____6570_636E["初始总护盾"] > 0 and _____5F53_524D_603B_62A4_76FE / _____6570_636E["初始总护盾"] or 1
            _____8BBE_7F6E_62A4_76FE_6761_6BD4_4F8B(_____6570_636E, _____6BD4_4F8B)
            if _____6570_636E["颜色恢复倒计时"] > 0 then
                _____6570_636E["颜色恢复倒计时"] = _____6570_636E["颜色恢复倒计时"] - 0.02
                if _____6570_636E["颜色恢复倒计时"] <= 0 then
                    _____8BBE_7F6E_62A4_76FE_6761_989C_8272(_____6570_636E, COLOR_DEFAULT)
                end
            end
            if _____6570_636E["颜色恢复倒计时"] > 0 then
                _____6570_636E["颜色恢复倒计时"] = _____6570_636E["颜色恢复倒计时"] - 0.02
                if _____6570_636E["颜色恢复倒计时"] <= 0 then
                    _____8BBE_7F6E_62A4_76FE_6761_989C_8272(_____6570_636E, COLOR_DEFAULT)
                end
            end
        end
        ::__continue25::
    end
    if _____62A4_76FE_6761_6620_5C04.size == 0 and _____5DF2_6CE8_518C_8BA1_65F6_5668 then
        _____5DF2_6CE8_518C_8BA1_65F6_5668 = false
        offTick10ms(_____66F4_65B0_6240_6709_62A4_76FE_6761_4F4D_7F6E)
    end
end
local function _____786E_4FDD_6CE8_518C_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_8BA1_65F6_5668 = true
    onTick10ms(_____66F4_65B0_6240_6709_62A4_76FE_6761_4F4D_7F6E)
end
--- 创建或更新护盾条
____exports["创建护盾条"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    local _____5DF2_6709 = _____62A4_76FE_6761_6620_5C04:get(_____5355_4F4DID)
    if _____5DF2_6709 ~= nil then
        _____5DF2_6709["初始总护盾"] = _____83B7_53D6_5355_4F4D_603B_62A4_76FE_503C(_____5355_4F4DID)
        return
    end
    local x = GetUnitX(_____5355_4F4D)
    local y = GetUnitY(_____5355_4F4D)
    local owner = Player(SHIELD_BAR_OWNER_PLAYER_ID)
    local _____62A4_76FE_6761_5355_4F4D = CreateUnit(
        owner,
        SHIELD_BAR_UNIT_ID,
        x,
        y,
        0
    )
    if not _____5355_4F4D_5B58_6D3B(_____62A4_76FE_6761_5355_4F4D) then
        return
    end
    SetUnitScale(_____62A4_76FE_6761_5355_4F4D, 1, 1, 1)
    if type(SetUnitAnimationByIndex) == "function" then
        SetUnitAnimationByIndex(_____62A4_76FE_6761_5355_4F4D, 0)
    end
    SetUnitVertexColor(
        _____62A4_76FE_6761_5355_4F4D,
        _____88C1_526A_5230_5B57_8282(COLOR_DEFAULT.r),
        _____88C1_526A_5230_5B57_8282(COLOR_DEFAULT.g),
        _____88C1_526A_5230_5B57_8282(COLOR_DEFAULT.b),
        _____88C1_526A_5230_5B57_8282(COLOR_DEFAULT.a)
    )
    local _____521D_59CB_603B_62A4_76FE = _____83B7_53D6_5355_4F4D_603B_62A4_76FE_503C(_____5355_4F4DID)
    local _____6570_636E = {
        ["护盾条单位"] = _____62A4_76FE_6761_5355_4F4D,
        ["跟随单位"] = _____5355_4F4D,
        ["跟随单位ID"] = _____5355_4F4DID,
        ["高度偏移"] = DEFAULT_HEIGHT_OFFSET,
        ["当前颜色"] = COLOR_DEFAULT,
        ["颜色恢复倒计时"] = 0,
        ["初始总护盾"] = _____521D_59CB_603B_62A4_76FE
    }
    _____62A4_76FE_6761_6620_5C04:set(_____5355_4F4DID, _____6570_636E)
    _____8BBE_7F6E_62A4_76FE_6761_4F4D_7F6E(_____6570_636E)
    _____786E_4FDD_6CE8_518C_8BA1_65F6_5668()
end
--- 删除护盾条
____exports["删除护盾条"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    _____79FB_9664_62A4_76FE_6761(_____5355_4F4DID)
end
--- 护盾条闪色（受击反馈）
-- 
-- @param 伤害类型 0=其他/通用, 1=物理, 2=魔法
____exports["护盾条闪色"] = function(_____5355_4F4D, _____4F24_5BB3_7C7B_578B)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    local _____6570_636E = _____62A4_76FE_6761_6620_5C04:get(_____5355_4F4DID)
    if _____6570_636E == nil then
        return
    end
    local _____989C_8272
    if _____4F24_5BB3_7C7B_578B == 1 then
        _____989C_8272 = COLOR_PHYSICAL
    elseif _____4F24_5BB3_7C7B_578B == 2 then
        _____989C_8272 = COLOR_MAGICAL
    else
        _____989C_8272 = COLOR_GENERAL
    end
    _____8BBE_7F6E_62A4_76FE_6761_989C_8272(_____6570_636E, _____989C_8272)
    _____6570_636E["颜色恢复倒计时"] = 0.3
end
--- 检查单位是否有护盾条
____exports["是否有护盾条"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    return _____62A4_76FE_6761_6620_5C04:has(_____5355_4F4DID)
end
--- 清除所有护盾条
____exports["清除所有护盾条"] = function()
    for ____, ____value in __TS__Iterator(_____62A4_76FE_6761_6620_5C04) do
        local _____5355_4F4DID = ____value[1]
        _____79FB_9664_62A4_76FE_6761(_____5355_4F4DID)
    end
    _____62A4_76FE_6761_6620_5C04:clear()
    if _____5DF2_6CE8_518C_8BA1_65F6_5668 then
        _____5DF2_6CE8_518C_8BA1_65F6_5668 = false
        offTick10ms(_____66F4_65B0_6240_6709_62A4_76FE_6761_4F4D_7F6E)
    end
end
--- 供伤害系统调用的闪色入口
local function _____62A4_76FE_6761_95EA_8272_5165_53E3(_____5355_4F4D, _____4F24_5BB3_7C7B_578B)
    ____exports["护盾条闪色"](_____5355_4F4D, _____4F24_5BB3_7C7B_578B)
end
local g = _G
if type(g._shieldBarFlashColor) ~= "function" then
    g._shieldBarFlashColor = _____62A4_76FE_6761_95EA_8272_5165_53E3
end
return ____exports
