local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____4ECE_533A_57DF_627F_4F24_5438_6536_573A_5217_8868_79FB_9664, _____5C1D_8BD5_5173_95ED_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668, _____79FB_9664_533A_57DF_627F_4F24_5438_6536_573A, ____on_533A_57DF_627F_4F24_5438_6536_573ATick, _____5355_4F4D_5728_5438_6536_573A_5185, _____8BA1_7B97_533A_57DF_627F_4F24_5438_6536_91CF, ____on_533A_57DF_627F_4F24_5438_6536_573A_6700_7EC8_4F24_5BB3, offTick10ms, GetUnitX, GetUnitY, IsUnitAlly, IsUnitOwnedByPlayer, GetUnitState, SetUnitState, DestroyEffect, UNIT_STATE_LIFE, _____533A_57DF_627F_4F24_5438_6536_573A_8868, _____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868, _____5DF2_6CE8_518C_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668
function _____4ECE_533A_57DF_627F_4F24_5438_6536_573A_5217_8868_79FB_9664(id)
    do
        local i = #_____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868 - 1
        while i >= 0 do
            if _____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868[i + 1] == id then
                __TS__ArraySplice(_____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868, i, 1)
                return
            end
            i = i - 1
        end
    end
end
function _____5C1D_8BD5_5173_95ED_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668()
    if not _____5DF2_6CE8_518C_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668 then
        return
    end
    if #_____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868 > 0 then
        return
    end
    _____5DF2_6CE8_518C_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668 = false
    offTick10ms(____on_533A_57DF_627F_4F24_5438_6536_573ATick)
end
function _____79FB_9664_533A_57DF_627F_4F24_5438_6536_573A(id, _____662F_5426_8017_5C3D)
    local _____5B9E_4F8B = _____533A_57DF_627F_4F24_5438_6536_573A_8868[id]
    if _____5B9E_4F8B == nil or _____5B9E_4F8B["已移除"] then
        return
    end
    _____5B9E_4F8B["已移除"] = true
    __TS__Delete(_____533A_57DF_627F_4F24_5438_6536_573A_8868, id)
    _____4ECE_533A_57DF_627F_4F24_5438_6536_573A_5217_8868_79FB_9664(id)
    if _____5B9E_4F8B["特效"] ~= nil and _____5B9E_4F8B["特效"] ~= 0 then
        DestroyEffect(_____5B9E_4F8B["特效"])
    end
    if _____5B9E_4F8B["参数"]["on结束"] ~= nil then
        _____5B9E_4F8B["参数"]["on结束"]({["场ID"] = id, ["施法单位"] = _____5B9E_4F8B["参数"]["施法单位"], ["是否耗尽"] = _____662F_5426_8017_5C3D})
    end
    _____5C1D_8BD5_5173_95ED_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668()
end
function ____on_533A_57DF_627F_4F24_5438_6536_573ATick()
    do
        local i = #_____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868 - 1
        while i >= 0 do
            do
                local id = _____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868[i + 1]
                local _____5B9E_4F8B = _____533A_57DF_627F_4F24_5438_6536_573A_8868[id]
                if _____5B9E_4F8B == nil or _____5B9E_4F8B["剩余吸收值"] <= 0 then
                    _____79FB_9664_533A_57DF_627F_4F24_5438_6536_573A(id, true)
                    goto __continue22
                end
                _____5B9E_4F8B["剩余时间"] = _____5B9E_4F8B["剩余时间"] - 0.01
                if _____5B9E_4F8B["剩余时间"] <= 0 then
                    _____79FB_9664_533A_57DF_627F_4F24_5438_6536_573A(id, false)
                end
            end
            ::__continue22::
            i = i - 1
        end
    end
    _____5C1D_8BD5_5173_95ED_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668()
end
function _____5355_4F4D_5728_5438_6536_573A_5185(_____5B9E_4F8B, unit)
    if unit == nil or unit == 0 then
        return false
    end
    local _____53C2_6570 = _____5B9E_4F8B["参数"]
    local dx = GetUnitX(unit) - _____53C2_6570.X
    local dy = GetUnitY(unit) - _____53C2_6570.Y
    if dx * dx + dy * dy > _____53C2_6570["作用半径"] * _____53C2_6570["作用半径"] then
        return false
    end
    local ____53C2_6570__53EA_5F71_54CD_53CB_519B_5 = _____53C2_6570["只影响友军"]
    if ____53C2_6570__53EA_5F71_54CD_53CB_519B_5 == nil then
        ____53C2_6570__53EA_5F71_54CD_53CB_519B_5 = true
    end
    if ____53C2_6570__53EA_5F71_54CD_53CB_519B_5 and not IsUnitAlly(unit, _____5B9E_4F8B["施法玩家"]) then
        local ____53C2_6570__5305_542B_540C_73A9_5BB6_5355_4F4D_6 = _____53C2_6570["包含同玩家单位"]
        if ____53C2_6570__5305_542B_540C_73A9_5BB6_5355_4F4D_6 == nil then
            ____53C2_6570__5305_542B_540C_73A9_5BB6_5355_4F4D_6 = true
        end
        if not ____53C2_6570__5305_542B_540C_73A9_5BB6_5355_4F4D_6 or not IsUnitOwnedByPlayer(unit, _____5B9E_4F8B["施法玩家"]) then
            return false
        end
    end
    return true
end
function _____8BA1_7B97_533A_57DF_627F_4F24_5438_6536_91CF(_____5B9E_4F8B, damage)
    if not (damage > 0) then
        return 0
    end
    if _____5B9E_4F8B["参数"]["吸收量限制为剩余值"] == true and damage > _____5B9E_4F8B["剩余吸收值"] then
        return _____5B9E_4F8B["剩余吸收值"]
    end
    return damage
end
function ____on_533A_57DF_627F_4F24_5438_6536_573A_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if target == nil or target == 0 or not (applied > 0) then
        return
    end
    do
        local i = #_____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868 - 1
        while i >= 0 do
            do
                local id = _____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868[i + 1]
                local _____5B9E_4F8B = _____533A_57DF_627F_4F24_5438_6536_573A_8868[id]
                if _____5B9E_4F8B == nil or _____5B9E_4F8B["剩余吸收值"] <= 0 then
                    _____79FB_9664_533A_57DF_627F_4F24_5438_6536_573A(id, true)
                    goto __continue36
                end
                if not _____5355_4F4D_5728_5438_6536_573A_5185(_____5B9E_4F8B, target) then
                    goto __continue36
                end
                if _____5B9E_4F8B["参数"]["可吸收单位"] ~= nil and not _____5B9E_4F8B["参数"]["可吸收单位"]({
                    ["场ID"] = id,
                    ["施法单位"] = _____5B9E_4F8B["参数"]["施法单位"],
                    ["受伤单位"] = target,
                    ["攻击者"] = attacker,
                    ["伤害快照"] = snapshot
                }) then
                    goto __continue36
                end
                local absorb = _____8BA1_7B97_533A_57DF_627F_4F24_5438_6536_91CF(_____5B9E_4F8B, applied)
                if not (absorb > 0) then
                    goto __continue36
                end
                SetUnitState(
                    target,
                    UNIT_STATE_LIFE,
                    GetUnitState(target, UNIT_STATE_LIFE) + absorb
                )
                _____5B9E_4F8B["剩余吸收值"] = _____5B9E_4F8B["剩余吸收值"] - absorb
                if _____5B9E_4F8B["参数"]["on吸收"] ~= nil then
                    _____5B9E_4F8B["参数"]["on吸收"]({
                        ["场ID"] = id,
                        ["施法单位"] = _____5B9E_4F8B["参数"]["施法单位"],
                        ["受伤单位"] = target,
                        ["攻击者"] = attacker,
                        ["本次伤害"] = applied,
                        ["吸收量"] = absorb,
                        ["剩余吸收值"] = _____5B9E_4F8B["剩余吸收值"],
                        ["伤害快照"] = snapshot
                    })
                end
                if _____5B9E_4F8B["剩余吸收值"] <= 0 then
                    _____79FB_9664_533A_57DF_627F_4F24_5438_6536_573A(id, true)
                end
            end
            ::__continue36::
            i = i - 1
        end
    end
end
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_1.onTick10ms
offTick10ms = ____require_result_1.offTick10ms
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_2.EC_CreateEffect
local jass = require("jass.common")
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
_____533A_57DF_627F_4F24_5438_6536_573A_8868 = {}
_____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868 = {}
local _____5DF2_6CE8_518C_533A_57DF_627F_4F24_5438_6536_573A_4F24_5BB3_76D1_542C = false
_____5DF2_6CE8_518C_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668 = false
local _____533A_57DF_627F_4F24_5438_6536_573A_63A7_5236_5668_5B9E_73B0 = __TS__Class()
_____533A_57DF_627F_4F24_5438_6536_573A_63A7_5236_5668_5B9E_73B0.name = "区域承伤吸收场控制器实现"
function _____533A_57DF_627F_4F24_5438_6536_573A_63A7_5236_5668_5B9E_73B0.prototype.____constructor(self, id)
    self.id = id
end
_____533A_57DF_627F_4F24_5438_6536_573A_63A7_5236_5668_5B9E_73B0.prototype["获取剩余吸收值"] = function(self)
    local ____opt_3 = _____533A_57DF_627F_4F24_5438_6536_573A_8868[self.id]
    return ____opt_3 and ____opt_3["剩余吸收值"] or 0
end
_____533A_57DF_627F_4F24_5438_6536_573A_63A7_5236_5668_5B9E_73B0.prototype["移除"] = function(self)
    _____79FB_9664_533A_57DF_627F_4F24_5438_6536_573A(self.id, false)
end
local function _____786E_4FDD_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668 = true
    onTick10ms(____on_533A_57DF_627F_4F24_5438_6536_573ATick)
end
local function _____786E_4FDD_533A_57DF_627F_4F24_5438_6536_573A_4F24_5BB3_76D1_542C()
    if _____5DF2_6CE8_518C_533A_57DF_627F_4F24_5438_6536_573A_4F24_5BB3_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_533A_57DF_627F_4F24_5438_6536_573A_4F24_5BB3_76D1_542C = true
    registerAppliedFinalDamageListener(____on_533A_57DF_627F_4F24_5438_6536_573A_6700_7EC8_4F24_5BB3)
end
____exports["创建区域承伤吸收场"] = function(_____53C2_6570)
    if _____53C2_6570["施法单位"] == nil or _____53C2_6570["施法单位"] == 0 then
        return nil
    end
    if not (_____53C2_6570["持续秒数"] > 0) or not (_____53C2_6570["作用半径"] > 0) or not (_____53C2_6570["吸收值"] > 0) then
        return nil
    end
    local effect = EC_CreateEffect(
        _____53C2_6570["特效路径"],
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____53C2_6570["特效高度"] or 0,
        _____53C2_6570["特效朝向"] or 0,
        _____53C2_6570["特效尺寸"] or 1,
        _____53C2_6570["特效速度"] or 1,
        -1
    )
    if effect == nil or effect == 0 then
        return nil
    end
    local id = GetHandleId(effect)
    if id <= 0 then
        DestroyEffect(effect)
        return nil
    end
    _____533A_57DF_627F_4F24_5438_6536_573A_8868[id] = {
        id = id,
        ["参数"] = _____53C2_6570,
        ["施法玩家"] = GetOwningPlayer(_____53C2_6570["施法单位"]),
        ["特效"] = effect,
        ["剩余时间"] = _____53C2_6570["持续秒数"],
        ["剩余吸收值"] = _____53C2_6570["吸收值"],
        ["已移除"] = false
    }
    _____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868[#_____533A_57DF_627F_4F24_5438_6536_573AID_5217_8868 + 1] = id
    _____786E_4FDD_533A_57DF_627F_4F24_5438_6536_573A_4F24_5BB3_76D1_542C()
    _____786E_4FDD_533A_57DF_627F_4F24_5438_6536_573A_8BA1_65F6_5668()
    return __TS__New(_____533A_57DF_627F_4F24_5438_6536_573A_63A7_5236_5668_5B9E_73B0, id)
end
return ____exports
