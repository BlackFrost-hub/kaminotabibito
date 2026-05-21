local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____4ECE_5217_8868_79FB_9664_9B54_76FEID, _____5C1D_8BD5_5173_95ED_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668, _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE, ____on_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668Tick, _____53D7_4F24_5355_4F4D_5728_9B54_76FE_5185, _____5438_6536_4F7F_8005_9B54_8F6E_4F24_5BB3, ____on_4F7F_8005_9B54_8F6E_4F24_5BB3_4E8B_4EF6, offTick10ms, GetUnitX, GetUnitY, IsUnitAlly, IsUnitOwnedByPlayer, GetUnitState, SetUnitState, DestroyEffect, UNIT_STATE_LIFE, _____4F7F_8005_9B54_8F6E_9B54_76FE_8868, _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868, _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____4F7F_8005_9B54_8F6E_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["使者魔轮物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____4F7F_8005_9B54_8F6E_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["使者魔轮配置"]
function _____4ECE_5217_8868_79FB_9664_9B54_76FEID(id)
    do
        local i = #_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 - 1
        while i >= 0 do
            if _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868[i + 1] == id then
                __TS__ArraySplice(_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868, i, 1)
                return
            end
            i = i - 1
        end
    end
end
function _____5C1D_8BD5_5173_95ED_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
    if not _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    if #_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 > 0 then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____on_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668Tick)
end
function _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
    local _____5B9E_4F8B = _____4F7F_8005_9B54_8F6E_9B54_76FE_8868[id]
    if _____5B9E_4F8B == nil then
        return
    end
    __TS__Delete(_____4F7F_8005_9B54_8F6E_9B54_76FE_8868, id)
    _____4ECE_5217_8868_79FB_9664_9B54_76FEID(id)
    if _____5B9E_4F8B["特效"] ~= nil and _____5B9E_4F8B["特效"] ~= 0 then
        DestroyEffect(_____5B9E_4F8B["特效"])
    end
    _____5C1D_8BD5_5173_95ED_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
end
function ____on_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668Tick()
    do
        local i = #_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 - 1
        while i >= 0 do
            do
                local id = _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868[i + 1]
                local _____5B9E_4F8B = _____4F7F_8005_9B54_8F6E_9B54_76FE_8868[id]
                if _____5B9E_4F8B == nil or _____5B9E_4F8B["护盾值"] <= 0 then
                    _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
                    goto __continue34
                end
                _____5B9E_4F8B["剩余时间"] = _____5B9E_4F8B["剩余时间"] - 0.01
                if _____5B9E_4F8B["剩余时间"] <= 0 then
                    _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
                end
            end
            ::__continue34::
            i = i - 1
        end
    end
    _____5C1D_8BD5_5173_95ED_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
end
function _____53D7_4F24_5355_4F4D_5728_9B54_76FE_5185(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D)
    if _____53D7_4F24_5355_4F4D == nil or _____53D7_4F24_5355_4F4D == 0 then
        return false
    end
    local dx = GetUnitX(_____53D7_4F24_5355_4F4D) - _____5B9E_4F8B.x
    local dy = GetUnitY(_____53D7_4F24_5355_4F4D) - _____5B9E_4F8B.y
    if dx * dx + dy * dy > _____5B9E_4F8B["作用半径"] * _____5B9E_4F8B["作用半径"] then
        return false
    end
    if IsUnitAlly(_____53D7_4F24_5355_4F4D, _____5B9E_4F8B["施法玩家"]) then
        return true
    end
    return IsUnitOwnedByPlayer(_____53D7_4F24_5355_4F4D, _____5B9E_4F8B["施法玩家"])
end
function _____5438_6536_4F7F_8005_9B54_8F6E_4F24_5BB3(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D, _____4F24_5BB3_503C)
    SetUnitState(
        _____53D7_4F24_5355_4F4D,
        UNIT_STATE_LIFE,
        GetUnitState(_____53D7_4F24_5355_4F4D, UNIT_STATE_LIFE) + _____4F24_5BB3_503C
    )
    _____5B9E_4F8B["护盾值"] = _____5B9E_4F8B["护盾值"] - _____4F24_5BB3_503C
end
function ____on_4F7F_8005_9B54_8F6E_4F24_5BB3_4E8B_4EF6(_____53D7_4F24_5355_4F4D, ______653B_51FB_8005, _____4F24_5BB3_503C, _snapshot)
    if _____53D7_4F24_5355_4F4D == nil or _____53D7_4F24_5355_4F4D == 0 or not (_____4F24_5BB3_503C > 0) then
        return
    end
    do
        local i = #_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 - 1
        while i >= 0 do
            do
                local id = _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868[i + 1]
                local _____5B9E_4F8B = _____4F7F_8005_9B54_8F6E_9B54_76FE_8868[id]
                if _____5B9E_4F8B == nil or _____5B9E_4F8B["护盾值"] <= 0 then
                    _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
                    goto __continue47
                end
                if not _____53D7_4F24_5355_4F4D_5728_9B54_76FE_5185(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D) then
                    goto __continue47
                end
                _____5438_6536_4F7F_8005_9B54_8F6E_4F24_5BB3(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D, _____4F24_5BB3_503C)
                if _____5B9E_4F8B["护盾值"] <= 0 then
                    _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
                end
            end
            ::__continue47::
            i = i - 1
        end
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_1.onTick10ms
offTick10ms = ____require_result_1.offTick10ms
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_2.EC_CreateEffect
local GetItemTypeId = jass.GetItemTypeId
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
IsUnitAlly = jass.IsUnitAlly
IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
DestroyEffect = jass.DestroyEffect
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_3["监听指定物品获取丢弃"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.24．魔法吸收护盾")
local _____5F00_59CB_9B54_6CD5_5438_6536_62A4_76FE = ____require_result_4["开始魔法吸收护盾"]
local _____79FB_9664_5355_4F4D_9B54_6CD5_5438_6536_62A4_76FE = ____require_result_4["移除单位魔法吸收护盾"]
_____4F7F_8005_9B54_8F6E_9B54_76FE_8868 = {}
_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 = {}
local _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C = false
_____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 = false
local _____4F7F_8005_9B54_8F6E_88AB_52A8_6807_7B7E = "装备:使者魔轮:魔盾被动"
local _____4F7F_8005_9B54_8F6E_88AB_52A8_5B9E_4F8B_8868 = {}
local function _____662F_5426_4E3A_4F7F_8005_9B54_8F6E(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    if _____4F7F_8005_9B54_8F6E_7269_54C1ID <= 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____4F7F_8005_9B54_8F6E_7269_54C1ID
end
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____521B_5EFA_4F7F_8005_9B54_8F6E_88AB_52A8(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    local _____65E7_62A4_76FEID = _____4F7F_8005_9B54_8F6E_88AB_52A8_5B9E_4F8B_8868[_____5355_4F4DID]
    if _____65E7_62A4_76FEID ~= nil and _____65E7_62A4_76FEID > 0 then
        _____79FB_9664_5355_4F4D_9B54_6CD5_5438_6536_62A4_76FE(_____5355_4F4D, _____4F7F_8005_9B54_8F6E_88AB_52A8_6807_7B7E)
    end
    local _____62A4_76FEID = _____5F00_59CB_9B54_6CD5_5438_6536_62A4_76FE({
        ["单位"] = _____5355_4F4D,
        ["持续时间"] = 0,
        ["伤害吸收比例"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动魔法吸收比例"],
        ["每点魔法吸收伤害"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动每点魔法吸收伤害"],
        ["最低魔法百分比"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动最低魔法百分比"],
        ["最低魔法固定值"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动最低魔法固定值"],
        ["仅非物理伤害"] = true,
        ["是否有特效"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动是否有特效"],
        ["特效路径"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动特效路径"],
        ["特效挂点"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动特效挂点"],
        ["显示文本"] = false,
        ["标签"] = _____4F7F_8005_9B54_8F6E_88AB_52A8_6807_7B7E
    })
    if _____62A4_76FEID > 0 then
        _____4F7F_8005_9B54_8F6E_88AB_52A8_5B9E_4F8B_8868[_____5355_4F4DID] = _____62A4_76FEID
    end
end
local function _____79FB_9664_4F7F_8005_9B54_8F6E_88AB_52A8(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    local _____62A4_76FEID = _____4F7F_8005_9B54_8F6E_88AB_52A8_5B9E_4F8B_8868[_____5355_4F4DID]
    if _____62A4_76FEID ~= nil and _____62A4_76FEID > 0 then
        _____79FB_9664_5355_4F4D_9B54_6CD5_5438_6536_62A4_76FE(_____5355_4F4D, _____4F7F_8005_9B54_8F6E_88AB_52A8_6807_7B7E)
    end
    __TS__Delete(_____4F7F_8005_9B54_8F6E_88AB_52A8_5B9E_4F8B_8868, _____5355_4F4DID)
end
local function ____on_4F7F_8005_9B54_8F6E_88AB_52A8_83B7_53D6(_____5355_4F4D, ______7269_54C1, currentCount, previousCount)
    if not (currentCount > 0 and previousCount <= 0) then
        return
    end
    _____521B_5EFA_4F7F_8005_9B54_8F6E_88AB_52A8(_____5355_4F4D)
end
local function ____on_4F7F_8005_9B54_8F6E_88AB_52A8_4E22_5F03(_____5355_4F4D, ______7269_54C1, currentCount, previousCount)
    if not (currentCount <= 0 and previousCount > 0) then
        return
    end
    _____79FB_9664_4F7F_8005_9B54_8F6E_88AB_52A8(_____5355_4F4D)
end
local function _____521D_59CB_5316_4F7F_8005_9B54_8F6E_88AB_52A8()
    if _____4F7F_8005_9B54_8F6E_7269_54C1ID <= 0 then
        return
    end
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____4F7F_8005_9B54_8F6E_7269_54C1ID, ____on_4F7F_8005_9B54_8F6E_88AB_52A8_83B7_53D6, ____on_4F7F_8005_9B54_8F6E_88AB_52A8_4E22_5F03)
end
local function _____786E_4FDD_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____on_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668Tick)
end
local function _____786E_4FDD_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C()
    if _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C = true
    registerAppliedFinalDamageListener(____on_4F7F_8005_9B54_8F6E_4F24_5BB3_4E8B_4EF6)
end
local function _____6CE8_518C_4F7F_8005_9B54_8F6E_9B54_76FE(_____65BD_6CD5_5355_4F4D, x, y, _____62A4_76FE_503C)
    local _____7279_6548 = EC_CreateEffect(
        _____4F7F_8005_9B54_8F6E_914D_7F6E["特效路径"],
        x,
        y,
        0,
        0,
        _____4F7F_8005_9B54_8F6E_914D_7F6E["特效尺寸"],
        1,
        -1
    )
    if _____7279_6548 == nil or _____7279_6548 == 0 then
        return
    end
    local id = GetHandleId(_____7279_6548)
    if id <= 0 then
        DestroyEffect(_____7279_6548)
        return
    end
    _____4F7F_8005_9B54_8F6E_9B54_76FE_8868[id] = {
        id = id,
        ["施法单位"] = _____65BD_6CD5_5355_4F4D,
        ["施法玩家"] = GetOwningPlayer(_____65BD_6CD5_5355_4F4D),
        ["特效"] = _____7279_6548,
        x = x,
        y = y,
        ["剩余时间"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["持续时间"],
        ["作用半径"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["作用半径"],
        ["护盾值"] = _____62A4_76FE_503C
    }
    _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868[#_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 + 1] = id
    _____786E_4FDD_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C()
    _____786E_4FDD_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
end
____exports["处理使者魔轮使用"] = function(_____4E0A_4E0B_6587)
    if not _____662F_5426_4E3A_4F7F_8005_9B54_8F6E(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____6700_5927_9B54_6CD5 = GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MAX_MANA)
    local _____6D88_8017_9B54_6CD5 = _____6700_5927_9B54_6CD5 * _____4F7F_8005_9B54_8F6E_914D_7F6E["消耗魔法比例"]
    if not (_____6D88_8017_9B54_6CD5 > 0) then
        return
    end
    SetUnitState(
        _____65BD_6CD5_5355_4F4D,
        UNIT_STATE_MANA,
        GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MANA) - _____6D88_8017_9B54_6CD5
    )
    _____6CE8_518C_4F7F_8005_9B54_8F6E_9B54_76FE(_____65BD_6CD5_5355_4F4D, _____4E0A_4E0B_6587["目标X"], _____4E0A_4E0B_6587["目标Y"], _____6D88_8017_9B54_6CD5)
end
_____521D_59CB_5316_4F7F_8005_9B54_8F6E_88AB_52A8()
return ____exports
