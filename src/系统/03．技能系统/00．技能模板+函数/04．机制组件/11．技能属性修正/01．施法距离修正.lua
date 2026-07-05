local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__Delete = ____lualib.__TS__Delete
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseInt = ____lualib.__TS__ParseInt
local ____exports = {}
local _____8F6C_6280_80FDID, _____662F_6709_6548_82F1_96C4, _____53D6_5355_4F4DID, _____53D6_6280_80FD_952E, _____9650_5236_8DDD_79BB, platformAbilityAction, platformAbilityGetter, stringToFourCCSafe, GetHandleId, IsUnitType, UNIT_TYPE_HERO, _____82F1_96C4_6280_80FD_5168_5C40_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868, _____82F1_96C4_6280_80FD_5355_6280_80FD_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868, _____82F1_96C4_6280_80FD_65BD_6CD5_8DDD_79BB_914D_7F6E_8868
function _____8F6C_6280_80FDID(_____6280_80FDID)
    if _____6280_80FDID == nil then
        return 0
    end
    if type(_____6280_80FDID) == "number" then
        return _____6280_80FDID
    end
    return stringToFourCCSafe(_____6280_80FDID)
end
function _____662F_6709_6548_82F1_96C4(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_HERO) == true
end
function _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
function _____53D6_6280_80FD_952E(_____5355_4F4D, _____6280_80FDID)
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    local _____5B9E_9645_6280_80FDID = _____8F6C_6280_80FDID(_____6280_80FDID)
    if _____5355_4F4DID <= 0 or _____5B9E_9645_6280_80FDID <= 0 then
        return ""
    end
    return (tostring(_____5355_4F4DID) .. "#") .. tostring(_____5B9E_9645_6280_80FDID)
end
function _____9650_5236_8DDD_79BB(_____503C, _____6700_5C0F_8DDD_79BB, _____6700_5927_8DDD_79BB)
    local result = _____503C
    local min = _____6700_5C0F_8DDD_79BB or 0
    if result < min then
        result = min
    end
    if _____6700_5927_8DDD_79BB ~= nil and _____6700_5927_8DDD_79BB > min and result > _____6700_5927_8DDD_79BB then
        result = _____6700_5927_8DDD_79BB
    end
    return result
end
____exports["技能距离用途默认吃施法距离加成"] = function(_____7528_9014)
    return _____7528_9014 == "施法距离" or _____7528_9014 == "施法距离派生距离" or _____7528_9014 == "自身位移距离" or _____7528_9014 == "路径长度" or _____7528_9014 == "路径总长度" or _____7528_9014 == "直线长度" or _____7528_9014 == "矩形长度" or _____7528_9014 == "胶囊长度" or _____7528_9014 == "扇形半径" or _____7528_9014 == "弹幕飞行距离" or _____7528_9014 == "飞行最大距离" or _____7528_9014 == "投射物最大距离" or _____7528_9014 == "追踪最大距离" or _____7528_9014 == "目标点最大距离" or _____7528_9014 == "落点最大距离"
end
____exports["取英雄技能施法距离修正"] = function(_____5355_4F4D, _____6280_80FDID)
    if not _____662F_6709_6548_82F1_96C4(_____5355_4F4D) then
        return 0
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    local result = _____82F1_96C4_6280_80FD_5168_5C40_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868[_____5355_4F4DID] or 0
    local key = _____6280_80FDID ~= nil and _____53D6_6280_80FD_952E(_____5355_4F4D, _____6280_80FDID) or ""
    if key ~= "" then
        result = result + (_____82F1_96C4_6280_80FD_5355_6280_80FD_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868[key] or 0)
    end
    return result
end
____exports["取英雄技能修正距离"] = function(_____5355_4F4D, _____6280_80FDID, _____57FA_7840_8DDD_79BB, _____7528_9014, _____9009_9879)
    if not (_____57FA_7840_8DDD_79BB > 0) then
        return 0
    end
    local ____temp_3 = _____9009_9879 and _____9009_9879["吃施法距离加成"]
    if ____temp_3 == nil then
        ____temp_3 = ____exports["技能距离用途默认吃施法距离加成"](_____7528_9014)
    end
    local shouldApply = ____temp_3
    if not shouldApply then
        return _____9650_5236_8DDD_79BB(_____57FA_7840_8DDD_79BB, _____9009_9879 and _____9009_9879["最小距离"], _____9009_9879 and _____9009_9879["最大距离"])
    end
    local key = _____53D6_6280_80FD_952E(_____5355_4F4D, _____6280_80FDID)
    local ____temp_8
    if key ~= "" then
        ____temp_8 = _____82F1_96C4_6280_80FD_65BD_6CD5_8DDD_79BB_914D_7F6E_8868[key]
    else
        ____temp_8 = nil
    end
    local config = ____temp_8
    local min = _____9009_9879 and _____9009_9879["最小距离"] or config and config["最小距离"]
    local max = _____9009_9879 and _____9009_9879["最大距离"] or config and config["最大距离"]
    return _____9650_5236_8DDD_79BB(
        _____57FA_7840_8DDD_79BB + ____exports["取英雄技能施法距离修正"](_____5355_4F4D, _____6280_80FDID),
        min,
        max
    )
end
____exports["取英雄技能最终施法距离"] = function(_____5355_4F4D, _____6280_80FDID, _____57FA_7840_65BD_6CD5_8DDD_79BB)
    local key = _____53D6_6280_80FD_952E(_____5355_4F4D, _____6280_80FDID)
    local ____temp_23
    if key ~= "" then
        ____temp_23 = _____82F1_96C4_6280_80FD_65BD_6CD5_8DDD_79BB_914D_7F6E_8868[key]
    else
        ____temp_23 = nil
    end
    local config = ____temp_23
    local abilityId = _____8F6C_6280_80FDID(_____6280_80FDID)
    local base = _____57FA_7840_65BD_6CD5_8DDD_79BB or config and config["基础施法距离"] or (abilityId > 0 and platformAbilityGetter["技能_获取技能施法距离"](_____5355_4F4D, abilityId) or 0)
    return ____exports["取英雄技能修正距离"](
        _____5355_4F4D,
        abilityId,
        base,
        "施法距离",
        {["最小距离"] = config and config["最小距离"], ["最大距离"] = config and config["最大距离"]}
    )
end
____exports["刷新英雄技能物遍施法距离"] = function(_____5355_4F4D, _____6280_80FDID, _____57FA_7840_65BD_6CD5_8DDD_79BB)
    if not _____662F_6709_6548_82F1_96C4(_____5355_4F4D) then
        return false
    end
    local abilityId = _____8F6C_6280_80FDID(_____6280_80FDID)
    if abilityId <= 0 then
        return false
    end
    local key = _____53D6_6280_80FD_952E(_____5355_4F4D, abilityId)
    local ____temp_30
    if key ~= "" then
        ____temp_30 = _____82F1_96C4_6280_80FD_65BD_6CD5_8DDD_79BB_914D_7F6E_8868[key]
    else
        ____temp_30 = nil
    end
    local config = ____temp_30
    local base = _____57FA_7840_65BD_6CD5_8DDD_79BB or config and config["基础施法距离"]
    if not (base ~= nil and base > 0) then
        return false
    end
    local range = ____exports["取英雄技能最终施法距离"](_____5355_4F4D, abilityId, base)
    return platformAbilityAction["技能_设置技能施法距离"](_____5355_4F4D, abilityId, range)
end
____exports["刷新英雄单位全部技能施法距离"] = function(_____5355_4F4D)
    if not _____662F_6709_6548_82F1_96C4(_____5355_4F4D) then
        return
    end
    local prefix = tostring(_____53D6_5355_4F4DID(_____5355_4F4D)) .. "#"
    for key in pairs(_____82F1_96C4_6280_80FD_65BD_6CD5_8DDD_79BB_914D_7F6E_8868) do
        do
            if (string.find(key, prefix, nil, true) or 0) - 1 ~= 0 then
                goto __continue42
            end
            local config = _____82F1_96C4_6280_80FD_65BD_6CD5_8DDD_79BB_914D_7F6E_8868[key]
            if config == nil or config["同步物遍施法距离"] == false then
                goto __continue42
            end
            local abilityId = __TS__ParseInt(
                __TS__StringSubstring(key, #prefix),
                10
            )
            if abilityId > 0 then
                ____exports["刷新英雄技能物遍施法距离"](_____5355_4F4D, abilityId)
            end
        end
        ::__continue42::
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
platformAbilityAction = require("平台扩展API动作")
platformAbilityGetter = require("平台扩展API取值")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
GetHandleId = jass.GetHandleId
IsUnitType = jass.IsUnitType
UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
_____82F1_96C4_6280_80FD_5168_5C40_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868 = {}
_____82F1_96C4_6280_80FD_5355_6280_80FD_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868 = {}
_____82F1_96C4_6280_80FD_65BD_6CD5_8DDD_79BB_914D_7F6E_8868 = {}
____exports["取英雄技能施法距离派生距离"] = function(_____5355_4F4D, _____6280_80FDID, _____57FA_7840_8DDD_79BB, _____9009_9879)
    local ____exports__53D6_82F1_96C4_6280_80FD_4FEE_6B63_8DDD_79BB_22 = ____exports["取英雄技能修正距离"]
    local ____array_21 = __TS__SparseArrayNew(_____5355_4F4D, _____6280_80FDID, _____57FA_7840_8DDD_79BB, "施法距离派生距离")
    local ____temp_20 = _____9009_9879 or ({})
    local ____temp_19 = _____9009_9879 and _____9009_9879["吃施法距离加成"]
    if ____temp_19 == nil then
        ____temp_19 = true
    end
    __TS__SparseArrayPush(
        ____array_21,
        __TS__ObjectAssign({}, ____temp_20, {["吃施法距离加成"] = ____temp_19})
    )
    return ____exports__53D6_82F1_96C4_6280_80FD_4FEE_6B63_8DDD_79BB_22(__TS__SparseArraySpread(____array_21))
end
____exports["登记英雄技能施法距离配置"] = function(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E)
    if not _____662F_6709_6548_82F1_96C4(_____5355_4F4D) then
        return false
    end
    local abilityId = _____8F6C_6280_80FDID(_____6280_80FDID)
    local key = _____53D6_6280_80FD_952E(_____5355_4F4D, abilityId)
    if key == "" then
        return false
    end
    local base = _____914D_7F6E["基础施法距离"] or platformAbilityGetter["技能_获取技能施法距离"](_____5355_4F4D, abilityId)
    _____82F1_96C4_6280_80FD_65BD_6CD5_8DDD_79BB_914D_7F6E_8868[key] = __TS__ObjectAssign({}, _____914D_7F6E, {["基础施法距离"] = base > 0 and base or _____914D_7F6E["基础施法距离"]})
    if _____914D_7F6E["同步物遍施法距离"] ~= false then
        ____exports["刷新英雄技能物遍施法距离"](_____5355_4F4D, abilityId)
    end
    return true
end
____exports["取消登记英雄技能施法距离配置"] = function(_____5355_4F4D, _____6280_80FDID)
    local key = _____53D6_6280_80FD_952E(_____5355_4F4D, _____6280_80FDID)
    if key == "" then
        return
    end
    __TS__Delete(_____82F1_96C4_6280_80FD_65BD_6CD5_8DDD_79BB_914D_7F6E_8868, key)
    __TS__Delete(_____82F1_96C4_6280_80FD_5355_6280_80FD_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868, key)
end
____exports["设置英雄技能施法距离修正"] = function(_____5355_4F4D, _____4FEE_6B63_503C, _____5237_65B0)
    if _____5237_65B0 == nil then
        _____5237_65B0 = true
    end
    if not _____662F_6709_6548_82F1_96C4(_____5355_4F4D) then
        return
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    _____82F1_96C4_6280_80FD_5168_5C40_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868[_____5355_4F4DID] = _____4FEE_6B63_503C
    if _____5237_65B0 then
        ____exports["刷新英雄单位全部技能施法距离"](_____5355_4F4D)
    end
end
____exports["调整英雄技能施法距离修正"] = function(_____5355_4F4D, _____53D8_5316_503C, _____5237_65B0)
    if _____5237_65B0 == nil then
        _____5237_65B0 = true
    end
    ____exports["设置英雄技能施法距离修正"](
        _____5355_4F4D,
        ____exports["取英雄技能施法距离修正"](_____5355_4F4D) + _____53D8_5316_503C,
        _____5237_65B0
    )
end
____exports["设置指定英雄技能施法距离修正"] = function(_____5355_4F4D, _____6280_80FDID, _____4FEE_6B63_503C, _____5237_65B0)
    if _____5237_65B0 == nil then
        _____5237_65B0 = true
    end
    if not _____662F_6709_6548_82F1_96C4(_____5355_4F4D) then
        return
    end
    local key = _____53D6_6280_80FD_952E(_____5355_4F4D, _____6280_80FDID)
    if key == "" then
        return
    end
    _____82F1_96C4_6280_80FD_5355_6280_80FD_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868[key] = _____4FEE_6B63_503C
    if _____5237_65B0 then
        ____exports["刷新英雄技能物遍施法距离"](_____5355_4F4D, _____6280_80FDID)
    end
end
____exports["清除英雄技能施法距离修正"] = function(_____5355_4F4D, _____5237_65B0)
    if _____5237_65B0 == nil then
        _____5237_65B0 = true
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID <= 0 then
        return
    end
    __TS__Delete(_____82F1_96C4_6280_80FD_5168_5C40_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868, _____5355_4F4DID)
    local prefix = tostring(_____5355_4F4DID) .. "#"
    for key in pairs(_____82F1_96C4_6280_80FD_5355_6280_80FD_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868) do
        if (string.find(key, prefix, nil, true) or 0) - 1 == 0 then
            __TS__Delete(_____82F1_96C4_6280_80FD_5355_6280_80FD_65BD_6CD5_8DDD_79BB_4FEE_6B63_8868, key)
        end
    end
    if _____5237_65B0 then
        ____exports["刷新英雄单位全部技能施法距离"](_____5355_4F4D)
    end
end
return ____exports
