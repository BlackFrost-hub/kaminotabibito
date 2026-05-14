local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local _____7ACB_5373_79FB_9664_8FDB_5EA6_6761_5355_4F4D, _____79FB_9664_8FDB_5EA6_6761_7279_6548, RemoveUnit, GetUnitTypeId, _____8FDB_5EA6_6761_6620_5C04, _____5355_4F4D_8FDB_5EA6_6761_6620_5C04
function _____7ACB_5373_79FB_9664_8FDB_5EA6_6761_5355_4F4D(_____8FDB_5EA6_6761_5355_4F4D)
    if _____8FDB_5EA6_6761_5355_4F4D == nil or _____8FDB_5EA6_6761_5355_4F4D == 0 then
        return
    end
    if GetUnitTypeId(_____8FDB_5EA6_6761_5355_4F4D) == 0 then
        return
    end
    RemoveUnit(_____8FDB_5EA6_6761_5355_4F4D)
end
function _____79FB_9664_8FDB_5EA6_6761_7279_6548(_____8FDB_5EA6_6761_5355_4F4D)
    if _____8FDB_5EA6_6761_5355_4F4D == nil or _____8FDB_5EA6_6761_5355_4F4D == 0 then
        return
    end
    local _____6570_636E = _____8FDB_5EA6_6761_6620_5C04:get(_____8FDB_5EA6_6761_5355_4F4D)
    if _____6570_636E ~= nil then
        _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:delete(_____6570_636E["跟随单位ID"])
    end
    _____8FDB_5EA6_6761_6620_5C04:delete(_____8FDB_5EA6_6761_5355_4F4D)
    _____7ACB_5373_79FB_9664_8FDB_5EA6_6761_5355_4F4D(_____8FDB_5EA6_6761_5355_4F4D)
end
--- 进度条特效模块（施法进度条）
-- 
-- 说明：
-- 1. 不使用 `特效绑定系统.ts`
-- 2. 不使用 `AddSpecialEffectTarget` / `AddSpecialEffectTargetUnitBJ`
-- 3. 当前实现改为直接创建物编单位 `e011`（父 id: `ewsp`）
-- 4. 进度条颜色、动画速度、动画序号都通过单位接口控制
-- 5. 销毁时直接 `RemoveUnit`，不是延迟特效回收
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
local offTick10ms = ____require_result_0.offTick10ms
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_1.debugLogForce
local _____8C03_8BD5_6A21_5757_540D = "进度条特效"
local PROGRESSBAR_UNIT_ID = 1697657137
local PROGRESSBAR_OWNER_PLAYER_ID = 4
local DEFAULT_HEIGHT_OFFSET = 275
local DEFAULT_SCALE = 1
local DEFAULT_ANIM_INDEX = 0
local DEFAULT_COLOR_RGBA = {r = 255, g = 255, b = 0, a = 255}
local UNIT_ALIVE_LIFE = 0.405
local GetHandleId = jass.GetHandleId
local Player = jass.Player
local CreateUnit = jass.CreateUnit
RemoveUnit = jass.RemoveUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
GetUnitTypeId = jass.GetUnitTypeId
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitScale = jass.SetUnitScale
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitVertexColor = jass.SetUnitVertexColor
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
_____8FDB_5EA6_6761_6620_5C04 = __TS__New(Map)
_____5355_4F4D_8FDB_5EA6_6761_6620_5C04 = __TS__New(Map)
local _____5DF2_6CE8_518C_8BA1_65F6_5668 = false
local function _____53D6_53E5_67C4ID(h)
    if h == nil or h == 0 then
        return 0
    end
    return GetHandleId(h)
end
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
    return jass.R2I(value)
end
local function _____8BBE_7F6E_8FDB_5EA6_6761_4F4D_7F6E(_____8FDB_5EA6_6761_5355_4F4D, _____8DDF_968F_5355_4F4D, _____9AD8_5EA6_504F_79FB)
    if not _____5355_4F4D_5B58_6D3B(_____8FDB_5EA6_6761_5355_4F4D) or not _____5355_4F4D_5B58_6D3B(_____8DDF_968F_5355_4F4D) then
        return
    end
    SetUnitX(
        _____8FDB_5EA6_6761_5355_4F4D,
        GetUnitX(_____8DDF_968F_5355_4F4D)
    )
    SetUnitY(
        _____8FDB_5EA6_6761_5355_4F4D,
        GetUnitY(_____8DDF_968F_5355_4F4D)
    )
    SetUnitFlyHeight(
        _____8FDB_5EA6_6761_5355_4F4D,
        GetUnitFlyHeight(_____8DDF_968F_5355_4F4D) + _____9AD8_5EA6_504F_79FB,
        0
    )
end
local function _____66F4_65B0_6240_6709_8FDB_5EA6_6761_4F4D_7F6E()
    for ____, ____value in __TS__Iterator(_____8FDB_5EA6_6761_6620_5C04) do
        local _____8FDB_5EA6_6761_5355_4F4D = ____value[1]
        local _____6570_636E = ____value[2]
        do
            if not _____5355_4F4D_5B58_6D3B(_____6570_636E["跟随单位"]) or not _____5355_4F4D_5B58_6D3B(_____8FDB_5EA6_6761_5355_4F4D) then
                _____79FB_9664_8FDB_5EA6_6761_7279_6548(_____8FDB_5EA6_6761_5355_4F4D)
                goto __continue17
            end
            _____8BBE_7F6E_8FDB_5EA6_6761_4F4D_7F6E(_____8FDB_5EA6_6761_5355_4F4D, _____6570_636E["跟随单位"], _____6570_636E["高度偏移"])
        end
        ::__continue17::
    end
    if _____8FDB_5EA6_6761_6620_5C04.size == 0 and _____5DF2_6CE8_518C_8BA1_65F6_5668 then
        _____5DF2_6CE8_518C_8BA1_65F6_5668 = false
        offTick10ms(_____66F4_65B0_6240_6709_8FDB_5EA6_6761_4F4D_7F6E)
    end
end
local function _____786E_4FDD_6CE8_518C_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_8BA1_65F6_5668 = true
    onTick10ms(_____66F4_65B0_6240_6709_8FDB_5EA6_6761_4F4D_7F6E)
end
____exports["创建进度条特效"] = function(_____5355_4F4D, _____9009_9879)
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) then
        return nil
    end
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return nil
    end
    local _____5DF2_6709_8FDB_5EA6_6761 = _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:get(_____5355_4F4DID)
    if _____5DF2_6709_8FDB_5EA6_6761 ~= nil then
        _____79FB_9664_8FDB_5EA6_6761_7279_6548(_____5DF2_6709_8FDB_5EA6_6761)
    end
    local _____9AD8_5EA6_504F_79FB = _____9009_9879 and _____9009_9879["高度偏移"] or DEFAULT_HEIGHT_OFFSET
    local _____7F29_653E = _____9009_9879 and _____9009_9879["缩放"] or DEFAULT_SCALE
    local _____52A8_753B_5E8F_53F7 = _____9009_9879 and _____9009_9879["动画序号"] or DEFAULT_ANIM_INDEX
    local _____52A8_753B_901F_5EA6 = _____9009_9879 and _____9009_9879["动画速度"]
    local _____989C_8272 = _____9009_9879 and _____9009_9879["颜色"] or DEFAULT_COLOR_RGBA
    local x = GetUnitX(_____5355_4F4D)
    local y = GetUnitY(_____5355_4F4D)
    local owner = Player(PROGRESSBAR_OWNER_PLAYER_ID)
    local _____8FDB_5EA6_6761_5355_4F4D = CreateUnit(
        owner,
        PROGRESSBAR_UNIT_ID,
        x,
        y,
        0
    )
    if not _____5355_4F4D_5B58_6D3B(_____8FDB_5EA6_6761_5355_4F4D) then
        return nil
    end
    SetUnitScale(_____8FDB_5EA6_6761_5355_4F4D, _____7F29_653E, _____7F29_653E, _____7F29_653E)
    if type(SetUnitAnimationByIndex) == "function" then
        SetUnitAnimationByIndex(_____8FDB_5EA6_6761_5355_4F4D, _____52A8_753B_5E8F_53F7)
    end
    if _____52A8_753B_901F_5EA6 ~= nil and _____52A8_753B_901F_5EA6 > 0 then
        SetUnitTimeScale(_____8FDB_5EA6_6761_5355_4F4D, _____52A8_753B_901F_5EA6)
    end
    SetUnitVertexColor(
        _____8FDB_5EA6_6761_5355_4F4D,
        _____88C1_526A_5230_5B57_8282(_____989C_8272.r),
        _____88C1_526A_5230_5B57_8282(_____989C_8272.g),
        _____88C1_526A_5230_5B57_8282(_____989C_8272.b),
        _____88C1_526A_5230_5B57_8282(_____989C_8272.a)
    )
    _____8BBE_7F6E_8FDB_5EA6_6761_4F4D_7F6E(_____8FDB_5EA6_6761_5355_4F4D, _____5355_4F4D, _____9AD8_5EA6_504F_79FB)
    local _____6570_636E = {["进度条单位"] = _____8FDB_5EA6_6761_5355_4F4D, ["跟随单位"] = _____5355_4F4D, ["跟随单位ID"] = _____5355_4F4DID, ["高度偏移"] = _____9AD8_5EA6_504F_79FB}
    _____8FDB_5EA6_6761_6620_5C04:set(_____8FDB_5EA6_6761_5355_4F4D, _____6570_636E)
    _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:set(_____5355_4F4DID, _____8FDB_5EA6_6761_5355_4F4D)
    _____786E_4FDD_6CE8_518C_8BA1_65F6_5668()
    debugLogForce(
        _____8C03_8BD5_6A21_5757_540D,
        "创建进度条单位成功",
        "unitId=",
        _____5355_4F4DID,
        "animSpeed=",
        _____52A8_753B_901F_5EA6 or "default"
    )
    return _____8FDB_5EA6_6761_5355_4F4D
end
____exports["销毁进度条特效"] = function(_____8FDB_5EA6_6761_5355_4F4D)
    _____79FB_9664_8FDB_5EA6_6761_7279_6548(_____8FDB_5EA6_6761_5355_4F4D)
end
____exports["销毁单位进度条特效"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    local _____8FDB_5EA6_6761_5355_4F4D = _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:get(_____5355_4F4DID)
    if _____8FDB_5EA6_6761_5355_4F4D ~= nil then
        _____79FB_9664_8FDB_5EA6_6761_7279_6548(_____8FDB_5EA6_6761_5355_4F4D)
    end
    if _____8FDB_5EA6_6761_6620_5C04.size == 0 and _____5DF2_6CE8_518C_8BA1_65F6_5668 then
        _____5DF2_6CE8_518C_8BA1_65F6_5668 = false
        offTick10ms(_____66F4_65B0_6240_6709_8FDB_5EA6_6761_4F4D_7F6E)
    end
end
____exports["是否存在进度条特效"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:has(_____53D6_53E5_67C4ID(_____5355_4F4D))
end
____exports["获取单位进度条特效"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:get(_____53D6_53E5_67C4ID(_____5355_4F4D))
end
____exports["清除所有进度条特效"] = function()
    for ____, ____value in __TS__Iterator(_____8FDB_5EA6_6761_6620_5C04) do
        local _____8FDB_5EA6_6761_5355_4F4D = ____value[1]
        _____7ACB_5373_79FB_9664_8FDB_5EA6_6761_5355_4F4D(_____8FDB_5EA6_6761_5355_4F4D)
    end
    _____8FDB_5EA6_6761_6620_5C04:clear()
    _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:clear()
    if _____5DF2_6CE8_518C_8BA1_65F6_5668 then
        _____5DF2_6CE8_518C_8BA1_65F6_5668 = false
        offTick10ms(_____66F4_65B0_6240_6709_8FDB_5EA6_6761_4F4D_7F6E)
    end
end
local g = _G
if type(g["创建进度条特效"]) ~= "function" then
    g["创建进度条特效"] = ____exports["创建进度条特效"]
end
if type(g["销毁单位进度条特效"]) ~= "function" then
    g["销毁单位进度条特效"] = ____exports["销毁单位进度条特效"]
end
return ____exports
