local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5355_4F4D_5B58_6D3B, _____5728_53EF_73A9_533A_57DF_5185, _____8BA1_7B97_5750_6807_8DDD_79BB, _____8BA1_7B97_671D_5411_89D2_5EA6, _____5C1D_8BD5_89E6_53D1_5230_8FBE_56DE_8C03, _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500, _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668, _____9500_6BC1_95EA_7535, _____66F4_65B0_95EA_7535, _____5185_90E8_79FB_9664_7275_5F15, _____7ED3_675F_7275_5F15_5B9E_4F8B, _____5C1D_8BD5_79FB_52A8_4E00_6B65, _____63A8_8FDB_7275_5F15_5B9E_4F8B, ____on_5438_9644_7275_5F15_7CFB_7EDFTick, jass, jglobals, X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY, offTick10ms, GetUnitX, GetUnitY, GetUnitTypeId, GetUnitState, IsUnitType, GetRectMinX, GetRectMinY, GetRectMaxX, GetRectMaxY, SetUnitX, SetUnitY, SetUnitFacing, PauseUnit, IsUnitPaused, SetUnitPathing, SquareRoot, Atan2, Cos, Sin, bj_RADTODEG, bj_DEGTORAD, AddLightning, MoveLightning, MoveLightningEx, DestroyLightning, CENTER_TIMER_TICKS, MAX_SUB_STEP, WALKABLE_TOLERANCE, UNIT_ALIVE_LIFE, _____6D3B_52A8_7275_5F15_5217_8868, _____7275_5F15_6620_5C04, _____5355_4F4D_5F53_524D_7275_5F15, _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668, ____tick_8BA1_6570
function _____5355_4F4D_5B58_6D3B(u)
    if u == nil or u == 0 then
        return false
    end
    if GetUnitTypeId(u) == 0 then
        return false
    end
    if IsUnitType(u, jass.UNIT_TYPE_DEAD) == true then
        return false
    end
    return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
function _____5728_53EF_73A9_533A_57DF_5185(x, y)
    return x >= GetRectMinX(jglobals.bj_mapInitialPlayableArea) and y >= GetRectMinY(jglobals.bj_mapInitialPlayableArea) and x <= GetRectMaxX(jglobals.bj_mapInitialPlayableArea) and y <= GetRectMaxY(jglobals.bj_mapInitialPlayableArea)
end
function _____8BA1_7B97_5750_6807_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return SquareRoot(dx * dx + dy * dy)
end
function _____8BA1_7B97_671D_5411_89D2_5EA6(x1, y1, x2, y2)
    return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG
end
function _____5C1D_8BD5_89E6_53D1_5230_8FBE_56DE_8C03(_____5B9E_4F8B, _____8DDD_79BB_4E2D_5FC3)
    if _____5B9E_4F8B["已触发到达回调"] or _____5B9E_4F8B["到达距离"] <= 0 then
        return false
    end
    if _____8DDD_79BB_4E2D_5FC3 > _____5B9E_4F8B["到达距离"] then
        return false
    end
    _____5B9E_4F8B["已触发到达回调"] = true
    if type(_____5B9E_4F8B["到达回调"]) == "function" then
        _____5B9E_4F8B["到达回调"](_____5B9E_4F8B["单位"], _____5B9E_4F8B.id)
    end
    return _____5B9E_4F8B["到达后结束"] == true
end
function _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
    if not _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____on_5438_9644_7275_5F15_7CFB_7EDFTick)
end
function _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668()
    if #_____6D3B_52A8_7275_5F15_5217_8868 ~= 0 then
        return
    end
    ____tick_8BA1_6570 = 0
    _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
end
function _____9500_6BC1_95EA_7535(_____5B9E_4F8B)
    local _____95EA_7535 = _____5B9E_4F8B["闪电句柄"]
    if _____95EA_7535 ~= nil and _____95EA_7535 ~= 0 and type(DestroyLightning) == "function" then
        DestroyLightning(_____95EA_7535)
    end
    _____5B9E_4F8B["闪电句柄"] = nil
end
function _____66F4_65B0_95EA_7535(_____5B9E_4F8B)
    if not _____5B9E_4F8B["启用闪电效果"] or type(AddLightning) ~= "function" then
        return
    end
    local _____5355_4F4DX = GetUnitX(_____5B9E_4F8B["单位"])
    local _____5355_4F4DY = GetUnitY(_____5B9E_4F8B["单位"])
    local _____4E2D_5FC3X = _____5B9E_4F8B["中心X"]
    local _____4E2D_5FC3Y = _____5B9E_4F8B["中心Y"]
    if _____5B9E_4F8B["闪电句柄"] == nil or _____5B9E_4F8B["闪电句柄"] == 0 then
        _____5B9E_4F8B["闪电句柄"] = AddLightning(
            _____5B9E_4F8B["闪电效果代码"],
            false,
            _____5355_4F4DX,
            _____5355_4F4DY,
            _____4E2D_5FC3X,
            _____4E2D_5FC3Y
        )
        return
    end
    if type(MoveLightningEx) == "function" then
        MoveLightningEx(
            _____5B9E_4F8B["闪电句柄"],
            false,
            _____5355_4F4DX,
            _____5355_4F4DY,
            _____5B9E_4F8B["闪电高度"],
            _____4E2D_5FC3X,
            _____4E2D_5FC3Y,
            _____5B9E_4F8B["闪电高度"]
        )
    elseif type(MoveLightning) == "function" then
        MoveLightning(
            _____5B9E_4F8B["闪电句柄"],
            false,
            _____5355_4F4DX,
            _____5355_4F4DY,
            _____4E2D_5FC3X,
            _____4E2D_5FC3Y
        )
    end
end
function _____5185_90E8_79FB_9664_7275_5F15(_____5B9E_4F8B)
    __TS__Delete(_____7275_5F15_6620_5C04, _____5B9E_4F8B.id)
    if _____5355_4F4D_5F53_524D_7275_5F15[_____5B9E_4F8B["单位ID"]] == _____5B9E_4F8B.id then
        __TS__Delete(_____5355_4F4D_5F53_524D_7275_5F15, _____5B9E_4F8B["单位ID"])
    end
    _____9500_6BC1_95EA_7535(_____5B9E_4F8B)
    local idx = _____5B9E_4F8B.listIndex
    local lastIdx = #_____6D3B_52A8_7275_5F15_5217_8868 - 1
    if idx ~= lastIdx then
        local last = _____6D3B_52A8_7275_5F15_5217_8868[lastIdx + 1]
        _____6D3B_52A8_7275_5F15_5217_8868[idx + 1] = last
        last.listIndex = idx
    end
    table.remove(_____6D3B_52A8_7275_5F15_5217_8868)
    _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668()
end
function _____7ED3_675F_7275_5F15_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    if _____7275_5F15_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
        return
    end
    if _____5B9E_4F8B["禁用碰撞"] then
        SetUnitPathing(_____5B9E_4F8B["单位"], true)
    end
    if _____5B9E_4F8B["暂停单位"] then
        PauseUnit(_____5B9E_4F8B["单位"], false)
    end
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____7275_5F15ID = _____5B9E_4F8B.id
    local _____7ED3_675F_56DE_8C03 = _____5B9E_4F8B["结束回调"]
    _____5185_90E8_79FB_9664_7275_5F15(_____5B9E_4F8B)
    if type(_____7ED3_675F_56DE_8C03) == "function" then
        _____7ED3_675F_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____7275_5F15ID)
    end
end
function _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____4F4D_79FB_8DDD_79BB)
    local _____5F53_524DX = GetUnitX(_____5B9E_4F8B["单位"])
    local _____5F53_524DY = GetUnitY(_____5B9E_4F8B["单位"])
    local _____8DDD_79BB_4E2D_5FC3 = _____8BA1_7B97_5750_6807_8DDD_79BB(_____5F53_524DX, _____5F53_524DY, _____5B9E_4F8B["中心X"], _____5B9E_4F8B["中心Y"])
    if _____5C1D_8BD5_89E6_53D1_5230_8FBE_56DE_8C03(_____5B9E_4F8B, _____8DDD_79BB_4E2D_5FC3) then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    if _____8DDD_79BB_4E2D_5FC3 <= _____5B9E_4F8B["最小距离"] then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____5B9E_9645_4F4D_79FB = _____4F4D_79FB_8DDD_79BB >= _____8DDD_79BB_4E2D_5FC3 - _____5B9E_4F8B["最小距离"] and _____8DDD_79BB_4E2D_5FC3 - _____5B9E_4F8B["最小距离"] or _____4F4D_79FB_8DDD_79BB
    if _____5B9E_9645_4F4D_79FB <= 0 then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____89D2_5EA6 = _____8BA1_7B97_671D_5411_89D2_5EA6(_____5F53_524DX, _____5F53_524DY, _____5B9E_4F8B["中心X"], _____5B9E_4F8B["中心Y"])
    local _____5F27_5EA6 = _____89D2_5EA6 * bj_DEGTORAD
    local _____65B0X = _____5F53_524DX + _____5B9E_9645_4F4D_79FB * Cos(_____5F27_5EA6)
    local _____65B0Y = _____5F53_524DY + _____5B9E_9645_4F4D_79FB * Sin(_____5F27_5EA6)
    if not _____5728_53EF_73A9_533A_57DF_5185(_____65B0X, _____65B0Y) then
        return {["停止"] = true, ["原因"] = "阻挡"}
    end
    if _____5B9E_4F8B["检查地形"] and not X_IsTerrainWalkable(nil, _____65B0X, _____65B0Y) then
        local ableDist = _____8BA1_7B97_5750_6807_8DDD_79BB(
            _____65B0X,
            _____65B0Y,
            X_GetAbleX(nil),
            X_GetAbleY(nil)
        )
        if ableDist > WALKABLE_TOLERANCE then
            return {["停止"] = true, ["原因"] = "阻挡"}
        end
    end
    SetUnitX(_____5B9E_4F8B["单位"], _____65B0X)
    SetUnitY(_____5B9E_4F8B["单位"], _____65B0Y)
    if _____5B9E_4F8B["朝向跟随牵引"] then
        SetUnitFacing(_____5B9E_4F8B["单位"], _____89D2_5EA6)
    end
    local _____65B0_8DDD_79BB_4E2D_5FC3 = _____8BA1_7B97_5750_6807_8DDD_79BB(_____65B0X, _____65B0Y, _____5B9E_4F8B["中心X"], _____5B9E_4F8B["中心Y"])
    if _____5C1D_8BD5_89E6_53D1_5230_8FBE_56DE_8C03(_____5B9E_4F8B, _____65B0_8DDD_79BB_4E2D_5FC3) then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    return {["停止"] = false}
end
function _____63A8_8FDB_7275_5F15_5B9E_4F8B(_____5B9E_4F8B)
    if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
        _____7ED3_675F_7275_5F15_5B9E_4F8B(_____5B9E_4F8B, "死亡")
        return
    end
    if _____5B9E_4F8B["主单位死亡时中断"] and _____5B9E_4F8B["主单位"] ~= nil and _____5B9E_4F8B["主单位"] ~= 0 and not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["主单位"]) then
        _____7ED3_675F_7275_5F15_5B9E_4F8B(_____5B9E_4F8B, "主单位死亡")
        return
    end
    if _____5B9E_4F8B["中心单位"] ~= nil and _____5B9E_4F8B["中心单位"] ~= 0 then
        if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["中心单位"]) then
            _____7ED3_675F_7275_5F15_5B9E_4F8B(_____5B9E_4F8B, "中心失效")
            return
        end
        _____5B9E_4F8B["中心X"] = GetUnitX(_____5B9E_4F8B["中心单位"])
        _____5B9E_4F8B["中心Y"] = GetUnitY(_____5B9E_4F8B["中心单位"])
    end
    if _____5B9E_4F8B["外部暂停时中断"] and not _____5B9E_4F8B["暂停单位"] and IsUnitPaused(_____5B9E_4F8B["单位"]) == true then
        _____7ED3_675F_7275_5F15_5B9E_4F8B(_____5B9E_4F8B, "中断")
        return
    end
    _____5B9E_4F8B["已运行Tick数"] = _____5B9E_4F8B["已运行Tick数"] + 1
    if _____5B9E_4F8B["已运行Tick数"] > _____5B9E_4F8B["持续Tick数"] then
        _____7ED3_675F_7275_5F15_5B9E_4F8B(_____5B9E_4F8B, "完成")
        return
    end
    local _____5269_4F59_4F4D_79FB = _____5B9E_4F8B["每Tick位移"]
    while _____5269_4F59_4F4D_79FB > 0 do
        local _____5B50_6B65_957F = _____5269_4F59_4F4D_79FB > MAX_SUB_STEP and MAX_SUB_STEP or _____5269_4F59_4F4D_79FB
        local _____7ED3_679C = _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____5B50_6B65_957F)
        if _____7ED3_679C["停止"] then
            _____7ED3_675F_7275_5F15_5B9E_4F8B(_____5B9E_4F8B, _____7ED3_679C["原因"] or "完成")
            return
        end
        _____5269_4F59_4F4D_79FB = _____5269_4F59_4F4D_79FB - _____5B50_6B65_957F
    end
    _____66F4_65B0_95EA_7535(_____5B9E_4F8B)
end
function ____on_5438_9644_7275_5F15_7CFB_7EDFTick()
    ____tick_8BA1_6570 = ____tick_8BA1_6570 + 1
    if ____tick_8BA1_6570 < CENTER_TIMER_TICKS then
        return
    end
    ____tick_8BA1_6570 = 0
    local i = 0
    while i < #_____6D3B_52A8_7275_5F15_5217_8868 do
        local _____5B9E_4F8B = _____6D3B_52A8_7275_5F15_5217_8868[i + 1]
        _____63A8_8FDB_7275_5F15_5B9E_4F8B(_____5B9E_4F8B)
        if _____6D3B_52A8_7275_5F15_5217_8868[i + 1] == _____5B9E_4F8B then
            i = i + 1
        end
    end
end
jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
X_IsTerrainWalkable = ____require_result_0.X_IsTerrainWalkable
X_GetAbleX = ____require_result_0.X_GetAbleX
X_GetAbleY = ____require_result_0.X_GetAbleY
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_1.onTick10ms
offTick10ms = ____require_result_1.offTick10ms
local GetHandleId = jass.GetHandleId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitTypeId = jass.GetUnitTypeId
GetUnitState = jass.GetUnitState
IsUnitType = jass.IsUnitType
GetRectMinX = jass.GetRectMinX
GetRectMinY = jass.GetRectMinY
GetRectMaxX = jass.GetRectMaxX
GetRectMaxY = jass.GetRectMaxY
SetUnitX = jass.SetUnitX
SetUnitY = jass.SetUnitY
SetUnitFacing = jass.SetUnitFacing
PauseUnit = jass.PauseUnit
IsUnitPaused = jass.IsUnitPaused
SetUnitPathing = jass.SetUnitPathing
SquareRoot = jass.SquareRoot
Atan2 = jass.Atan2
Cos = jass.Cos
Sin = jass.Sin
local R2I = jass.R2I
local ____jglobals_bj_RADTODEG_2 = jglobals.bj_RADTODEG
if ____jglobals_bj_RADTODEG_2 == nil then
    ____jglobals_bj_RADTODEG_2 = 57.29577951308232
end
bj_RADTODEG = ____jglobals_bj_RADTODEG_2
local ____jglobals_bj_DEGTORAD_3 = jglobals.bj_DEGTORAD
if ____jglobals_bj_DEGTORAD_3 == nil then
    ____jglobals_bj_DEGTORAD_3 = 0.017453292519943295
end
bj_DEGTORAD = ____jglobals_bj_DEGTORAD_3
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
AddLightning = jass.AddLightning
MoveLightning = jass.MoveLightning
MoveLightningEx = jass.MoveLightningEx
DestroyLightning = jass.DestroyLightning
local TICK_INTERVAL = 0.02
CENTER_TIMER_TICKS = 2
MAX_SUB_STEP = 31
WALKABLE_TOLERANCE = 8
UNIT_ALIVE_LIFE = 0.405
--- 常用闪电效果代码速查：
-- - CLPB：闪电链主闪电
-- - CLSB：闪电链次闪电
-- - DRAB：生命汲取
-- - DRAL：生命汲取（生命）
-- - DRAM：魔力汲取
-- - FORK：叉状闪电
-- - HWPB：治疗波主闪电
-- - HWSB：治疗波次闪电
-- - CHIM：闪电攻击
-- - LEAS：魔法束缚
-- - SPLK：灵魂锁链
-- - ROP：牵引绳子
-- - MFPB：魔力之焰
-- - AFOD：死亡之指
-- 
-- 其他技能如果需要改闪电表现，优先直接传 `闪电效果代码`。
____exports["闪电效果代码_闪电链主闪电"] = "CLPB"
____exports["闪电效果代码_闪电链次闪电"] = "CLSB"
____exports["闪电效果代码_生命汲取"] = "DRAB"
____exports["闪电效果代码_生命汲取生命"] = "DRAL"
____exports["闪电效果代码_魔力汲取"] = "DRAM"
____exports["闪电效果代码_叉状闪电"] = "FORK"
____exports["闪电效果代码_治疗波主闪电"] = "HWPB"
____exports["闪电效果代码_治疗波次闪电"] = "HWSB"
____exports["闪电效果代码_闪电攻击"] = "CHIM"
____exports["闪电效果代码_魔法束缚"] = "LEAS"
____exports["闪电效果代码_灵魂锁链"] = "SPLK"
____exports["闪电效果代码_牵引绳子"] = "ROP"
____exports["闪电效果代码_魔力之焰"] = "MFPB"
____exports["闪电效果代码_死亡之指"] = "AFOD"
local DEFAULT_LIGHTNING_CODE = ____exports["闪电效果代码_闪电链主闪电"]
_____6D3B_52A8_7275_5F15_5217_8868 = {}
_____7275_5F15_6620_5C04 = {}
_____5355_4F4D_5F53_524D_7275_5F15 = {}
local _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
local _____4E0B_4E00_4E2A_7275_5F15ID = 0
_____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
____tick_8BA1_6570 = 0
local function _____53D6_53E5_67C4ID(h)
    return h ~= nil and h ~= 0 and GetHandleId(h) or 0 or 0
end
local function _____6536_96C6_5355_4F4D_7EC4_6210_5458()
    local _____5355_4F4D = GetEnumUnit()
    if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 then
        _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58[#_____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 + 1] = _____5355_4F4D
    end
end
local function _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        return {}
    end
    _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    ForGroup(_____5355_4F4D_7EC4, _____6536_96C6_5355_4F4D_7EC4_6210_5458)
    local _____7ED3_679C = _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58
    _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    return _____7ED3_679C
end
local function _____8BA1_7B97_6BCFTick_4F4D_79FB(_____53C2_6570)
    if _____53C2_6570["每Tick位移"] ~= nil and _____53C2_6570["每Tick位移"] > 0 then
        return _____53C2_6570["每Tick位移"]
    end
    if _____53C2_6570["每秒速度"] ~= nil and _____53C2_6570["每秒速度"] > 0 then
        return _____53C2_6570["每秒速度"] * TICK_INTERVAL
    end
    return 10
end
local function _____8BA1_7B97_6301_7EEDTick_6570(_____53C2_6570)
    if _____53C2_6570["持续时间"] ~= nil and _____53C2_6570["持续时间"] > 0 then
        local ticks = R2I(_____53C2_6570["持续时间"] / TICK_INTERVAL + 0.0001)
        return ticks > 0 and ticks or 1
    end
    return 50
end
local function _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____on_5438_9644_7275_5F15_7CFB_7EDFTick)
end
local function _____7ED3_675F_7275_5F15ID(_____7275_5F15ID, _____539F_56E0)
    local _____5B9E_4F8B = _____7275_5F15_6620_5C04[_____7275_5F15ID]
    if not _____5B9E_4F8B then
        return false
    end
    _____7ED3_675F_7275_5F15_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    return true
end
local function _____89E3_6790_4E2D_5FC3_5750_6807(_____53C2_6570)
    if _____53C2_6570["中心单位"] ~= nil and _____53C2_6570["中心单位"] ~= 0 then
        return {
            x = GetUnitX(_____53C2_6570["中心单位"]),
            y = GetUnitY(_____53C2_6570["中心单位"])
        }
    end
    if _____53C2_6570["中心X"] ~= nil and _____53C2_6570["中心Y"] ~= nil then
        return {x = _____53C2_6570["中心X"], y = _____53C2_6570["中心Y"]}
    end
    return nil
end
local function _____521B_5EFA_7275_5F15_5B9E_4F8B(_____5355_4F4D, _____53C2_6570)
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) then
        return nil
    end
    if type(_____53C2_6570["目标筛选"]) == "function" and _____53C2_6570["目标筛选"](_____5355_4F4D) ~= true then
        return nil
    end
    local ____53C2_6570__4E3B_5355_4F4D_4 = _____53C2_6570["主单位"]
    if ____53C2_6570__4E3B_5355_4F4D_4 == nil then
        ____53C2_6570__4E3B_5355_4F4D_4 = _____53C2_6570["中心单位"]
    end
    local _____4E3B_5355_4F4D = ____53C2_6570__4E3B_5355_4F4D_4
    local _____4E2D_5FC3_5750_6807 = _____89E3_6790_4E2D_5FC3_5750_6807(_____53C2_6570)
    if not _____4E2D_5FC3_5750_6807 then
        return nil
    end
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return nil
    end
    local _____65E7_7275_5F15ID = _____5355_4F4D_5F53_524D_7275_5F15[_____5355_4F4DID]
    if _____65E7_7275_5F15ID ~= nil then
        _____7ED3_675F_7275_5F15ID(_____65E7_7275_5F15ID, "中断")
    end
    _____4E0B_4E00_4E2A_7275_5F15ID = _____4E0B_4E00_4E2A_7275_5F15ID + 1
    local _____5B9E_4F8B = {
        id = _____4E0B_4E00_4E2A_7275_5F15ID,
        listIndex = #_____6D3B_52A8_7275_5F15_5217_8868,
        ["单位"] = _____5355_4F4D,
        ["单位ID"] = _____5355_4F4DID,
        ["主单位"] = _____4E3B_5355_4F4D,
        ["主单位死亡时中断"] = _____53C2_6570["主单位死亡时中断"] ~= false,
        ["中心单位"] = _____53C2_6570["中心单位"],
        ["中心X"] = _____4E2D_5FC3_5750_6807.x,
        ["中心Y"] = _____4E2D_5FC3_5750_6807.y,
        ["每Tick位移"] = _____8BA1_7B97_6BCFTick_4F4D_79FB(_____53C2_6570),
        ["持续Tick数"] = _____8BA1_7B97_6301_7EEDTick_6570(_____53C2_6570),
        ["已运行Tick数"] = 0,
        ["最小距离"] = _____53C2_6570["最小距离"] ~= nil and _____53C2_6570["最小距离"] or 96,
        ["到达距离"] = _____53C2_6570["到达距离"] ~= nil and _____53C2_6570["到达距离"] or 0,
        ["到达后结束"] = _____53C2_6570["到达后结束"],
        ["到达回调"] = _____53C2_6570["到达回调"],
        ["已触发到达回调"] = false,
        ["检查地形"] = _____53C2_6570["检查地形"] ~= false,
        ["禁用碰撞"] = _____53C2_6570["禁用碰撞"] == true,
        ["暂停单位"] = _____53C2_6570["暂停单位"] == true,
        ["朝向跟随牵引"] = _____53C2_6570["朝向跟随牵引"] ~= false,
        ["外部暂停时中断"] = _____53C2_6570["外部暂停时中断"] == true,
        ["闪电效果代码"] = _____53C2_6570["闪电效果代码"] and _____53C2_6570["闪电效果代码"] ~= "" and _____53C2_6570["闪电效果代码"] or DEFAULT_LIGHTNING_CODE,
        ["闪电高度"] = _____53C2_6570["闪电高度"] ~= nil and _____53C2_6570["闪电高度"] or 60,
        ["启用闪电效果"] = _____53C2_6570["启用闪电效果"] ~= false,
        ["结束回调"] = _____53C2_6570["结束回调"],
        ["开始回调"] = _____53C2_6570["开始回调"]
    }
    if _____5B9E_4F8B["禁用碰撞"] then
        SetUnitPathing(_____5355_4F4D, false)
    end
    if _____5B9E_4F8B["暂停单位"] then
        PauseUnit(_____5355_4F4D, true)
    end
    _____6D3B_52A8_7275_5F15_5217_8868[#_____6D3B_52A8_7275_5F15_5217_8868 + 1] = _____5B9E_4F8B
    _____7275_5F15_6620_5C04[_____5B9E_4F8B.id] = _____5B9E_4F8B
    _____5355_4F4D_5F53_524D_7275_5F15[_____5355_4F4DID] = _____5B9E_4F8B.id
    _____66F4_65B0_95EA_7535(_____5B9E_4F8B)
    _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if type(_____53C2_6570["开始回调"]) == "function" then
        _____53C2_6570["开始回调"](_____5355_4F4D, _____5B9E_4F8B.id)
    end
    return _____5B9E_4F8B
end
____exports["开始牵引"] = function(_____5355_4F4D, _____53C2_6570)
    local _____5B9E_4F8B = _____521B_5EFA_7275_5F15_5B9E_4F8B(_____5355_4F4D, _____53C2_6570)
    return _____5B9E_4F8B and _____5B9E_4F8B.id or 0
end
____exports["开始单位组牵引"] = function(_____5355_4F4D_7EC4, _____53C2_6570)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)) do
        local _____7275_5F15ID = ____exports["开始牵引"](_____5355_4F4D, _____53C2_6570)
        if _____7275_5F15ID > 0 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____7275_5F15ID
        end
    end
    return _____7ED3_679C
end
____exports["停止牵引"] = function(_____7275_5F15ID)
    return _____7ED3_675F_7275_5F15ID(_____7275_5F15ID, "中断")
end
____exports["停止单位牵引"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____7275_5F15ID = _____5355_4F4D_5F53_524D_7275_5F15[_____5355_4F4DID]
    if _____7275_5F15ID == nil then
        return false
    end
    return ____exports["停止牵引"](_____7275_5F15ID)
end
____exports["单位是否正在被牵引"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    return _____5355_4F4DID ~= 0 and _____5355_4F4D_5F53_524D_7275_5F15[_____5355_4F4DID] ~= nil
end
____exports["获取单位当前牵引ID"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    return _____5355_4F4DID ~= 0 and (_____5355_4F4D_5F53_524D_7275_5F15[_____5355_4F4DID] or 0) or 0
end
____exports["获取活跃牵引数量"] = function()
    return #_____6D3B_52A8_7275_5F15_5217_8868
end
return ____exports
