local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5355_4F4D_6709_6548, _____53D6_76EE_6807X, _____53D6_76EE_6807Y, _____8BA1_7B97_671D_5411, _____53D6_5F53_524D_671D_5411, GetUnitX, GetUnitY, GetUnitFacing, IsUnitType, Atan2, UNIT_TYPE_DEAD, RAD_TO_DEG
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____53D6_76EE_6807X(_____53C2_6570)
    if _____5355_4F4D_6709_6548(_____53C2_6570["目标单位"]) then
        return GetUnitX(_____53C2_6570["目标单位"])
    end
    return _____53C2_6570["目标X"]
end
function _____53D6_76EE_6807Y(_____53C2_6570)
    if _____5355_4F4D_6709_6548(_____53C2_6570["目标单位"]) then
        return GetUnitY(_____53C2_6570["目标单位"])
    end
    return _____53C2_6570["目标Y"]
end
function _____8BA1_7B97_671D_5411(_____53C2_6570, _____9ED8_8BA4_671D_5411)
    local caster = _____53C2_6570["施法者"]
    if not _____5355_4F4D_6709_6548(caster) then
        return _____9ED8_8BA4_671D_5411
    end
    local targetX = _____53D6_76EE_6807X(_____53C2_6570)
    local targetY = _____53D6_76EE_6807Y(_____53C2_6570)
    if targetX == nil or targetY == nil then
        return _____9ED8_8BA4_671D_5411
    end
    return Atan2(
        targetY - GetUnitY(caster),
        targetX - GetUnitX(caster)
    ) * RAD_TO_DEG
end
function _____53D6_5F53_524D_671D_5411(_____5B9E_4F8B)
    local _____53C2_6570 = _____5B9E_4F8B["参数"]
    if _____53C2_6570["面向模式"] == "不处理" then
        return GetUnitFacing(_____53C2_6570["施法者"])
    end
    if _____53C2_6570["面向模式"] == "持续追踪目标" then
        return _____8BA1_7B97_671D_5411(_____53C2_6570, _____5B9E_4F8B["锁定朝向"])
    end
    return _____5B9E_4F8B["锁定朝向"]
end
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local _____8C03_6574_5355_4F4D_786C_76F4_65F6_95F4 = ____require_result_1["调整单位硬直时间"]
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
IsUnitType = jass.IsUnitType
Atan2 = jass.Atan2
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local EXSetUnitFacing = japi.EXSetUnitFacing
RAD_TO_DEG = 57.29577951308232
local DEG_TO_RAD = 0.017453292519943295
local _____6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B_8868 = {}
local _____6301_7EED_65BD_6CD5_53D1_5C04ID_5E8F_53F7 = 0
local _____6301_7EED_65BD_6CD5_53D1_5C04_9A71_52A8ID = 0
local function _____8BBE_7F6E_671D_5411(unit, facing)
    if not _____5355_4F4D_6709_6548(unit) then
        return
    end
    SetUnitFacing(unit, facing)
    if EXSetUnitFacing ~= nil then
        EXSetUnitFacing(unit, facing * DEG_TO_RAD)
    end
end
local function _____64AD_653E_6301_7EED_65BD_6CD5_52A8_753B(_____53C2_6570)
    local caster = _____53C2_6570["施法者"]
    if not _____5355_4F4D_6709_6548(caster) then
        return
    end
    SetUnitTimeScale(caster, _____53C2_6570["动画速度"] or 1)
    if _____53C2_6570["动画序列"] ~= nil then
        SetUnitAnimationByIndex(caster, _____53C2_6570["动画序列"])
        return
    end
    if _____53C2_6570["动画名"] ~= nil and _____53C2_6570["动画名"] ~= "" then
        SetUnitAnimation(caster, _____53C2_6570["动画名"])
    end
end
local function _____53D6_4E0A_4E0B_6587(_____5B9E_4F8B, now)
    local elapsedMs = now - _____5B9E_4F8B["开始毫秒"]
    local totalMs = _____5B9E_4F8B["结束毫秒"] - _____5B9E_4F8B["开始毫秒"]
    local _____5DF2_8FDB_884C_79D2 = elapsedMs > 0 and elapsedMs / 1000 or 0
    local _____8FDB_5EA6 = totalMs > 0 and elapsedMs / totalMs or 1
    if _____8FDB_5EA6 < 0 then
        _____8FDB_5EA6 = 0
    end
    if _____8FDB_5EA6 > 1 then
        _____8FDB_5EA6 = 1
    end
    return {
        ID = _____5B9E_4F8B.ID,
        ["施法者"] = _____5B9E_4F8B["参数"]["施法者"],
        ["已进行秒"] = _____5DF2_8FDB_884C_79D2,
        ["进度"] = _____8FDB_5EA6,
        ["当前朝向"] = _____53D6_5F53_524D_671D_5411(_____5B9E_4F8B),
        ["发射次数"] = _____5B9E_4F8B["发射次数"]
    }
end
local function _____7ED3_675F_6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    if _____5B9E_4F8B["已结束"] then
        return
    end
    _____5B9E_4F8B["已结束"] = true
    __TS__Delete(_____6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B_8868, _____5B9E_4F8B.ID)
    local caster = _____5B9E_4F8B["参数"]["施法者"]
    if _____539F_56E0 ~= "完成" and _____5B9E_4F8B["参数"]["中断时解除硬直"] == true and _____5355_4F4D_6709_6548(caster) then
        _____8C03_6574_5355_4F4D_786C_76F4_65F6_95F4(caster, 1, 9999)
    end
    if _____5B9E_4F8B["参数"]["结束后恢复动画"] ~= false and _____5355_4F4D_6709_6548(caster) then
        SetUnitTimeScale(caster, 1)
        SetUnitAnimationByIndex(caster, 0)
    end
    local ____on_7ED3_675F = _____5B9E_4F8B["参数"]["on结束"]
    if ____on_7ED3_675F ~= nil then
        ____on_7ED3_675F(
            _____53D6_4E0A_4E0B_6587(
                _____5B9E_4F8B,
                getServerTime()
            ),
            _____539F_56E0
        )
    end
end
local function _____9A71_52A8_6301_7EED_65BD_6CD5_53D1_5C04()
    local now = getServerTime()
    local hasActive = false
    for key in pairs(_____6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B_8868) do
        do
            local _____5B9E_4F8B = _____6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B_8868[key]
            if _____5B9E_4F8B == nil or _____5B9E_4F8B["已结束"] then
                goto __continue29
            end
            hasActive = true
            local caster = _____5B9E_4F8B["参数"]["施法者"]
            if not _____5355_4F4D_6709_6548(caster) then
                _____7ED3_675F_6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B(_____5B9E_4F8B, "施法者死亡")
                goto __continue29
            end
            local facing = _____53D6_5F53_524D_671D_5411(_____5B9E_4F8B)
            if _____5B9E_4F8B["参数"]["面向模式"] ~= "不处理" then
                _____8BBE_7F6E_671D_5411(caster, facing)
            end
            local ctx = _____53D6_4E0A_4E0B_6587(_____5B9E_4F8B, now)
            local onTick = _____5B9E_4F8B["参数"].onTick
            if onTick ~= nil then
                onTick(ctx)
            end
            local ____on_53D1_5C04 = _____5B9E_4F8B["参数"]["on发射"]
            while ____on_53D1_5C04 ~= nil and now >= _____5B9E_4F8B["下次发射毫秒"] and _____5B9E_4F8B["下次发射毫秒"] <= _____5B9E_4F8B["发射结束毫秒"] do
                _____5B9E_4F8B["发射次数"] = _____5B9E_4F8B["发射次数"] + 1
                ____on_53D1_5C04(_____53D6_4E0A_4E0B_6587(_____5B9E_4F8B, now))
                _____5B9E_4F8B["下次发射毫秒"] = _____5B9E_4F8B["下次发射毫秒"] + _____5B9E_4F8B["发射间隔毫秒"]
                if _____5B9E_4F8B["发射间隔毫秒"] <= 0 then
                    break
                end
            end
            if now >= _____5B9E_4F8B["结束毫秒"] then
                _____7ED3_675F_6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B(_____5B9E_4F8B, "完成")
            end
        end
        ::__continue29::
    end
    if not hasActive and _____6301_7EED_65BD_6CD5_53D1_5C04_9A71_52A8ID > 0 then
        removePeriodicCallback(_____6301_7EED_65BD_6CD5_53D1_5C04_9A71_52A8ID)
        _____6301_7EED_65BD_6CD5_53D1_5C04_9A71_52A8ID = 0
    end
end
local function _____786E_4FDD_6301_7EED_65BD_6CD5_53D1_5C04_9A71_52A8(intervalMs)
    if _____6301_7EED_65BD_6CD5_53D1_5C04_9A71_52A8ID > 0 then
        return
    end
    _____6301_7EED_65BD_6CD5_53D1_5C04_9A71_52A8ID = addPeriodicCallback(intervalMs, _____9A71_52A8_6301_7EED_65BD_6CD5_53D1_5C04)
end
____exports["启动持续施法发射"] = function(_____53C2_6570)
    local caster = _____53C2_6570["施法者"]
    if not _____5355_4F4D_6709_6548(caster) then
        return 0
    end
    local now = getServerTime()
    local totalMs = _____53C2_6570["总持续秒"] > 0 and _____53C2_6570["总持续秒"] * 1000 or 0
    if totalMs <= 0 then
        return 0
    end
    local fireStartMs = _____53C2_6570["发射开始秒"] > 0 and _____53C2_6570["发射开始秒"] * 1000 or 0
    local fireEndMs = _____53C2_6570["发射结束秒"] > _____53C2_6570["发射开始秒"] and _____53C2_6570["发射结束秒"] * 1000 or fireStartMs
    local fireIntervalMs = _____53C2_6570["发射间隔秒"] > 0 and _____53C2_6570["发射间隔秒"] * 1000 or 100
    local lockedFacing = _____8BA1_7B97_671D_5411(
        _____53C2_6570,
        GetUnitFacing(caster)
    )
    _____6301_7EED_65BD_6CD5_53D1_5C04ID_5E8F_53F7 = _____6301_7EED_65BD_6CD5_53D1_5C04ID_5E8F_53F7 + 1
    local id = _____6301_7EED_65BD_6CD5_53D1_5C04ID_5E8F_53F7
    local _____5B9E_4F8B = {
        ID = id,
        ["参数"] = _____53C2_6570,
        ["开始毫秒"] = now,
        ["结束毫秒"] = now + totalMs,
        ["发射开始毫秒"] = now + fireStartMs,
        ["发射结束毫秒"] = now + fireEndMs,
        ["发射间隔毫秒"] = fireIntervalMs,
        ["下次发射毫秒"] = now + fireStartMs,
        ["发射次数"] = 0,
        ["锁定朝向"] = lockedFacing,
        ["已结束"] = false
    }
    _____6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B_8868[id] = _____5B9E_4F8B
    if _____53C2_6570["面向模式"] ~= "不处理" then
        _____8BBE_7F6E_671D_5411(caster, lockedFacing)
    end
    if _____53C2_6570["硬直"] ~= false then
        _____5F00_59CB_786C_76F4(caster, _____53C2_6570["总持续秒"])
    end
    _____64AD_653E_6301_7EED_65BD_6CD5_52A8_753B(_____53C2_6570)
    local ____on_5F00_59CB = _____53C2_6570["on开始"]
    if ____on_5F00_59CB ~= nil then
        ____on_5F00_59CB(_____53D6_4E0A_4E0B_6587(_____5B9E_4F8B, now))
    end
    local intervalMs = _____53C2_6570["Tick间隔毫秒"] ~= nil and _____53C2_6570["Tick间隔毫秒"] > 0 and _____53C2_6570["Tick间隔毫秒"] or 30
    _____786E_4FDD_6301_7EED_65BD_6CD5_53D1_5C04_9A71_52A8(intervalMs)
    return id
end
____exports["停止持续施法发射"] = function(ID, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    local _____5B9E_4F8B = _____6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B_8868[ID]
    if _____5B9E_4F8B == nil then
        return false
    end
    _____7ED3_675F_6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    return true
end
____exports["单位是否正在持续施法发射"] = function(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return false
    end
    for key in pairs(_____6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B_8868) do
        local _____5B9E_4F8B = _____6301_7EED_65BD_6CD5_53D1_5C04_5B9E_4F8B_8868[key]
        if _____5B9E_4F8B ~= nil and _____5B9E_4F8B["参数"]["施法者"] == unit and not _____5B9E_4F8B["已结束"] then
            return true
        end
    end
    return false
end
return ____exports
