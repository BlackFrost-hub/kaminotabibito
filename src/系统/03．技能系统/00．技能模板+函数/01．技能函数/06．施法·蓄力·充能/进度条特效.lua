local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
--- 进度条特效模块（施法进度条）
-- 
-- 说明：
-- 1. 直接创建进度条特效并通过 Dz 绑定到单位 `overhead`
-- 2. 进度条颜色、动画速度、动画序号都通过特效接口控制
-- 3. 销毁前先解除 Dz 绑定，避免残留在单位附着点
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_0.EC_CreateEffect
local PROGRESSBAR_MODEL = "war3mapImported\\Progressbar.mdx"
local PROGRESSBAR_ATTACH_POINT = "overhead"
____exports["默认进度条高度偏移"] = 275
local DEFAULT_SCALE = 1.5
local DEFAULT_ANIM_INDEX = 0
local DEFAULT_COLOR_RGBA = {r = 255, g = 255, b = 0, a = 255}
local UNIT_ALIVE_LIFE = 0.405
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local DestroyEffect = jass.DestroyEffect
local DzBindEffect = japi.DzBindEffect
local DzUnbindEffect = japi.DzUnbindEffect
local DzSetEffectScale = japi.DzSetEffectScale
local DzSetEffectAnimation = japi.DzSetEffectAnimation
local DzSetEffectVertexColor = japi.DzSetEffectVertexColor
local DzGetColor = japi.DzGetColor
local _____8FDB_5EA6_6761_6620_5C04 = __TS__New(Map)
local _____5355_4F4D_8FDB_5EA6_6761_6620_5C04 = __TS__New(Map)
local function _____53D6_53E5_67C4ID(h)
    if h == nil or h == 0 then
        return 0
    end
    return GetHandleId(h)
end
local function _____83B7_53D6_6709_5E8F_8FDB_5EA6_6761_7279_6548ID_5217_8868()
    local ids = {}
    for ____, id in __TS__Iterator(_____8FDB_5EA6_6761_6620_5C04:keys()) do
        ids[#ids + 1] = id
    end
    __TS__ArraySort(
        ids,
        function(____, a, b) return a - b end
    )
    return ids
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
local function _____79FB_9664_8FDB_5EA6_6761_7279_6548(_____8FDB_5EA6_6761_7279_6548)
    if _____8FDB_5EA6_6761_7279_6548 == nil or _____8FDB_5EA6_6761_7279_6548 == 0 then
        return
    end
    local _____8FDB_5EA6_6761_7279_6548ID = _____53D6_53E5_67C4ID(_____8FDB_5EA6_6761_7279_6548)
    local _____6570_636E = _____8FDB_5EA6_6761_6620_5C04:get(_____8FDB_5EA6_6761_7279_6548ID)
    if _____6570_636E ~= nil then
        _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:delete(_____6570_636E["跟随单位ID"])
    end
    _____8FDB_5EA6_6761_6620_5C04:delete(_____8FDB_5EA6_6761_7279_6548ID)
    DzUnbindEffect(_____8FDB_5EA6_6761_7279_6548)
    DzSetEffectScale(_____8FDB_5EA6_6761_7279_6548, 0)
    DestroyEffect(_____8FDB_5EA6_6761_7279_6548)
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
    local _____7F29_653E = _____9009_9879 and _____9009_9879["缩放"] or DEFAULT_SCALE
    local _____52A8_753B_5E8F_53F7 = _____9009_9879 and _____9009_9879["动画序号"] or DEFAULT_ANIM_INDEX
    local _____52A8_753B_901F_5EA6 = _____9009_9879 and _____9009_9879["动画速度"]
    local _____989C_8272 = _____9009_9879 and _____9009_9879["颜色"] or DEFAULT_COLOR_RGBA
    local x = GetUnitX(_____5355_4F4D)
    local y = GetUnitY(_____5355_4F4D)
    local _____8FDB_5EA6_6761_7279_6548 = EC_CreateEffect(
        PROGRESSBAR_MODEL,
        x,
        y,
        0,
        0,
        _____7F29_653E,
        _____52A8_753B_901F_5EA6 or 1,
        -1
    )
    if _____8FDB_5EA6_6761_7279_6548 == nil or _____8FDB_5EA6_6761_7279_6548 == 0 then
        return nil
    end
    DzSetEffectAnimation(_____8FDB_5EA6_6761_7279_6548, _____52A8_753B_5E8F_53F7, 0)
    DzSetEffectVertexColor(
        _____8FDB_5EA6_6761_7279_6548,
        DzGetColor(
            _____88C1_526A_5230_5B57_8282(_____989C_8272.a),
            _____88C1_526A_5230_5B57_8282(_____989C_8272.r),
            _____88C1_526A_5230_5B57_8282(_____989C_8272.g),
            _____88C1_526A_5230_5B57_8282(_____989C_8272.b)
        )
    )
    DzBindEffect(_____5355_4F4D, PROGRESSBAR_ATTACH_POINT, _____8FDB_5EA6_6761_7279_6548)
    local _____6570_636E = {["进度条特效"] = _____8FDB_5EA6_6761_7279_6548, ["跟随单位"] = _____5355_4F4D, ["跟随单位ID"] = _____5355_4F4DID}
    _____8FDB_5EA6_6761_6620_5C04:set(
        _____53D6_53E5_67C4ID(_____8FDB_5EA6_6761_7279_6548),
        _____6570_636E
    )
    _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:set(_____5355_4F4DID, _____8FDB_5EA6_6761_7279_6548)
    return _____8FDB_5EA6_6761_7279_6548
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
    local _____8FDB_5EA6_6761_7279_6548ID_5217_8868 = _____83B7_53D6_6709_5E8F_8FDB_5EA6_6761_7279_6548ID_5217_8868()
    do
        local i = 0
        while i < #_____8FDB_5EA6_6761_7279_6548ID_5217_8868 do
            local _____6570_636E = _____8FDB_5EA6_6761_6620_5C04:get(_____8FDB_5EA6_6761_7279_6548ID_5217_8868[i + 1])
            if _____6570_636E ~= nil then
                DzUnbindEffect(_____6570_636E["进度条特效"])
                DzSetEffectScale(_____6570_636E["进度条特效"], 0)
                DestroyEffect(_____6570_636E["进度条特效"])
            end
            i = i + 1
        end
    end
    _____8FDB_5EA6_6761_6620_5C04:clear()
    _____5355_4F4D_8FDB_5EA6_6761_6620_5C04:clear()
end
local g = _G
if type(g["创建进度条特效"]) ~= "function" then
    g["创建进度条特效"] = ____exports["创建进度条特效"]
end
if type(g["销毁单位进度条特效"]) ~= "function" then
    g["销毁单位进度条特效"] = ____exports["销毁单位进度条特效"]
end
return ____exports
