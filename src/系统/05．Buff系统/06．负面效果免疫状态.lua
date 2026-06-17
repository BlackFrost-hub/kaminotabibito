local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UnitAddType = jass.UnitAddType
local UnitRemoveType = jass.UnitRemoveType
local UNIT_TYPE_SAPPER = jass.UNIT_TYPE_SAPPER
local _____8D1F_9762_6548_679C_514D_75AB_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____7C7B_578B_5339_914D(typeName, typePrefix)
    if type(typeName) ~= "string" or typeName == "" or typePrefix == "" then
        return false
    end
    return __TS__StringSubstring(typeName, 0, #typePrefix) == typePrefix
end
local function _____8303_56F4_5305_542B(_____914D_7F6E_8303_56F4, _____76EE_6807_8303_56F4)
    if _____914D_7F6E_8303_56F4 == nil then
        return _____76EE_6807_8303_56F4 == "全部负面"
    end
    if type(_____914D_7F6E_8303_56F4) == "string" then
        return _____914D_7F6E_8303_56F4 == _____76EE_6807_8303_56F4
    end
    do
        local i = 0
        while i < #_____914D_7F6E_8303_56F4 do
            if _____914D_7F6E_8303_56F4[i + 1] == _____76EE_6807_8303_56F4 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____53D6_6216_5EFA_8D1F_9762_6548_679C_514D_75AB_884C(_____5355_4F4D)
    local hid = _____53D6_5355_4F4D_53E5_67C4(_____5355_4F4D)
    if hid == 0 then
        return nil
    end
    local row = _____8D1F_9762_6548_679C_514D_75AB_8868[hid]
    if row == nil then
        row = {
            ["单位"] = _____5355_4F4D,
            ["原本是自爆工兵"] = IsUnitType(_____5355_4F4D, UNIT_TYPE_SAPPER) == true,
            ["全部负面免疫到期"] = 0,
            ["控制负面免疫到期"] = 0,
            ["魔法负面免疫到期"] = 0
        }
        _____8D1F_9762_6548_679C_514D_75AB_8868[hid] = row
    else
        row["单位"] = _____5355_4F4D
    end
    return row
end
local function _____884C_662F_5426_4ECD_6709_8D1F_9762_6548_679C_514D_75AB(row, now)
    return row["全部负面免疫到期"] > now or row["控制负面免疫到期"] > now or row["魔法负面免疫到期"] > now
end
local function _____5C1D_8BD5_6E05_7406_8D1F_9762_6548_679C_514D_75AB_884C(_____5355_4F4D)
    local hid = _____53D6_5355_4F4D_53E5_67C4(_____5355_4F4D)
    if hid == 0 then
        return
    end
    local row = _____8D1F_9762_6548_679C_514D_75AB_8868[hid]
    if row == nil then
        return
    end
    local now = getServerTime()
    if _____884C_662F_5426_4ECD_6709_8D1F_9762_6548_679C_514D_75AB(row, now) then
        return
    end
    if not row["原本是自爆工兵"] then
        UnitRemoveType(row["单位"], UNIT_TYPE_SAPPER)
    end
    __TS__Delete(_____8D1F_9762_6548_679C_514D_75AB_8868, hid)
end
local function ____on_8D1F_9762_6548_679C_514D_75AB_5230_671F()
    local now = getServerTime()
    for key in pairs(_____8D1F_9762_6548_679C_514D_75AB_8868) do
        local hid = key
        local row = _____8D1F_9762_6548_679C_514D_75AB_8868[hid]
        if row ~= nil and not _____884C_662F_5426_4ECD_6709_8D1F_9762_6548_679C_514D_75AB(row, now) then
            if not row["原本是自爆工兵"] then
                UnitRemoveType(row["单位"], UNIT_TYPE_SAPPER)
            end
            __TS__Delete(_____8D1F_9762_6548_679C_514D_75AB_8868, hid)
        end
    end
end
____exports["施加单位负面效果免疫"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____53C2_6570)
    if _____53C2_6570 == nil then
        _____53C2_6570 = {}
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or not (_____6301_7EED_65F6_95F4 > 0) then
        return
    end
    local row = _____53D6_6216_5EFA_8D1F_9762_6548_679C_514D_75AB_884C(_____5355_4F4D)
    if row == nil then
        return
    end
    local now = getServerTime()
    local ____until = now + _____6301_7EED_65F6_95F4 * 1000
    local _____8303_56F4 = _____53C2_6570["范围"]
    if _____8303_56F4_5305_542B(_____8303_56F4, "全部负面") then
        row["全部负面免疫到期"] = row["全部负面免疫到期"] > ____until and row["全部负面免疫到期"] or ____until
    end
    if _____8303_56F4_5305_542B(_____8303_56F4, "控制") then
        row["控制负面免疫到期"] = row["控制负面免疫到期"] > ____until and row["控制负面免疫到期"] or ____until
    end
    if _____8303_56F4_5305_542B(_____8303_56F4, "魔法负面") then
        row["魔法负面免疫到期"] = row["魔法负面免疫到期"] > ____until and row["魔法负面免疫到期"] or ____until
    end
    if _____53C2_6570["同步原生技能目标免疫"] ~= false then
        UnitAddType(_____5355_4F4D, UNIT_TYPE_SAPPER)
    end
    addDelayedCallback(_____6301_7EED_65F6_95F4 * 1000 + 50, ____on_8D1F_9762_6548_679C_514D_75AB_5230_671F)
end
____exports["施加单位控制负面效果免疫"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____540C_6B65_539F_751F_6280_80FD_76EE_6807_514D_75AB)
    if _____540C_6B65_539F_751F_6280_80FD_76EE_6807_514D_75AB == nil then
        _____540C_6B65_539F_751F_6280_80FD_76EE_6807_514D_75AB = true
    end
    ____exports["施加单位负面效果免疫"](_____5355_4F4D, _____6301_7EED_65F6_95F4, {["范围"] = "控制", ["同步原生技能目标免疫"] = _____540C_6B65_539F_751F_6280_80FD_76EE_6807_514D_75AB})
end
____exports["施加单位魔法负面效果免疫"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____540C_6B65_539F_751F_6280_80FD_76EE_6807_514D_75AB)
    if _____540C_6B65_539F_751F_6280_80FD_76EE_6807_514D_75AB == nil then
        _____540C_6B65_539F_751F_6280_80FD_76EE_6807_514D_75AB = true
    end
    ____exports["施加单位负面效果免疫"](_____5355_4F4D, _____6301_7EED_65F6_95F4, {["范围"] = "魔法负面", ["同步原生技能目标免疫"] = _____540C_6B65_539F_751F_6280_80FD_76EE_6807_514D_75AB})
end
____exports["清除单位负面效果免疫"] = function(_____5355_4F4D)
    local hid = _____53D6_5355_4F4D_53E5_67C4(_____5355_4F4D)
    if hid == 0 then
        return
    end
    local row = _____8D1F_9762_6548_679C_514D_75AB_8868[hid]
    if row == nil then
        return
    end
    row["全部负面免疫到期"] = 0
    row["控制负面免疫到期"] = 0
    row["魔法负面免疫到期"] = 0
    _____5C1D_8BD5_6E05_7406_8D1F_9762_6548_679C_514D_75AB_884C(_____5355_4F4D)
end
____exports["单位是否免疫负面效果类型"] = function(_____5355_4F4D, typeName)
    local hid = _____53D6_5355_4F4D_53E5_67C4(_____5355_4F4D)
    if hid == 0 then
        return false
    end
    local row = _____8D1F_9762_6548_679C_514D_75AB_8868[hid]
    if row == nil then
        return false
    end
    local now = getServerTime()
    if not _____884C_662F_5426_4ECD_6709_8D1F_9762_6548_679C_514D_75AB(row, now) then
        _____5C1D_8BD5_6E05_7406_8D1F_9762_6548_679C_514D_75AB_884C(_____5355_4F4D)
        return false
    end
    if row["全部负面免疫到期"] > now and _____7C7B_578B_5339_914D(typeName, "Debuff:") then
        return true
    end
    if row["控制负面免疫到期"] > now and _____7C7B_578B_5339_914D(typeName, "Debuff:control") then
        return true
    end
    if row["魔法负面免疫到期"] > now and _____7C7B_578B_5339_914D(typeName, "Debuff:magic") then
        return true
    end
    return false
end
____exports["单位是否免疫负面效果BuffID"] = function(_____5355_4F4D, buffID)
    local meta = buffTableMod.buffs[buffID]
    return ____exports["单位是否免疫负面效果类型"](_____5355_4F4D, meta and meta.type)
end
return ____exports
