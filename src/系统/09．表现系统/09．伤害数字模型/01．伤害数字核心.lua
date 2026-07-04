local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local ____exports = {}
local _____5355_4F4D_5B58_6D3B, _____9500_6BC1_5355_4F4D_6570_5B57_7279_6548, _____79FB_9664_4F24_5BB3_6570_5B57_5B9E_4F8B, _____5C1D_8BD5_505C_6B62_8BA1_65F6_5668, _____9A71_52A8_4F24_5BB3_6570_5B57, offTick10ms, DestroyEffect, GetUnitX, GetUnitY, GetUnitFlyHeight, IsUnitType, UNIT_TYPE_DEAD, EXSetEffectXY, EXSetEffectZ, DzSetEffectScale, _____57FA_7840Z_504F_79FB, _____5DF2_6CE8_518CTick, _____5B9E_4F8B_8868, _____5B9E_4F8BID_5217_8868
function _____5355_4F4D_5B58_6D3B(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return not IsUnitType(unit, UNIT_TYPE_DEAD)
end
function _____9500_6BC1_5355_4F4D_6570_5B57_7279_6548(d)
    if d.effect == nil or d.effect == 0 then
        return
    end
    DestroyEffect(d.effect)
end
function _____79FB_9664_4F24_5BB3_6570_5B57_5B9E_4F8B(id)
    local inst = _____5B9E_4F8B_8868[id]
    if inst == nil then
        return
    end
    _____5B9E_4F8B_8868[id] = nil
    do
        local i = 0
        while i < #inst.effects do
            _____9500_6BC1_5355_4F4D_6570_5B57_7279_6548(inst.effects[i + 1])
            i = i + 1
        end
    end
    local idx = __TS__ArrayIndexOf(_____5B9E_4F8BID_5217_8868, id)
    if idx >= 0 then
        __TS__ArraySplice(_____5B9E_4F8BID_5217_8868, idx, 1)
    end
end
function _____5C1D_8BD5_505C_6B62_8BA1_65F6_5668()
    if not _____5DF2_6CE8_518CTick then
        return
    end
    if #_____5B9E_4F8BID_5217_8868 > 0 then
        return
    end
    _____5DF2_6CE8_518CTick = false
    offTick10ms(_____9A71_52A8_4F24_5BB3_6570_5B57)
end
function _____9A71_52A8_4F24_5BB3_6570_5B57()
    local i = 0
    while i < #_____5B9E_4F8BID_5217_8868 do
        do
            local id = _____5B9E_4F8BID_5217_8868[i + 1]
            local inst = _____5B9E_4F8B_8868[id]
            if inst == nil then
                __TS__ArraySplice(_____5B9E_4F8BID_5217_8868, i, 1)
                goto __continue76
            end
            if not _____5355_4F4D_5B58_6D3B(inst.target) then
                _____79FB_9664_4F24_5BB3_6570_5B57_5B9E_4F8B(id)
                goto __continue76
            end
            inst.elapsed = inst.elapsed + 0.01
            local t = inst.elapsed / inst.duration
            if t >= 1 then
                _____79FB_9664_4F24_5BB3_6570_5B57_5B9E_4F8B(id)
                goto __continue76
            end
            local x = GetUnitX(inst.target)
            local y = GetUnitY(inst.target)
            local z = GetUnitFlyHeight(inst.target) + _____57FA_7840Z_504F_79FB + inst.riseHeight * t
            do
                local k = 0
                while k < #inst.effects do
                    do
                        local d = inst.effects[k + 1]
                        if d.effect == nil or d.effect == 0 then
                            goto __continue81
                        end
                        if type(EXSetEffectXY) == "function" then
                            EXSetEffectXY(d.effect, x + d.xOffset, y)
                        end
                        if type(EXSetEffectZ) == "function" then
                            EXSetEffectZ(d.effect, z)
                        end
                        if d.popScale and type(DzSetEffectScale) == "function" then
                            local scaleFactor = 1
                            if t < 0.12 then
                                scaleFactor = 0.7 + t * 2.5
                            end
                            DzSetEffectScale(d.effect, d.scale * scaleFactor)
                        end
                    end
                    ::__continue81::
                    k = k + 1
                end
            end
            i = i + 1
        end
        ::__continue76::
    end
    _____5C1D_8BD5_505C_6B62_8BA1_65F6_5668()
end
--- 模型伤害数字显示（最小版）
-- 
-- - 数据源：伤害计算完成后的最终伤害（registerAppliedFinalDamageListener）
-- - 显示：按位模型 DmgNum_0..9
-- - 动画：中心计时器 10ms 驱动上浮与淡出后销毁
-- - 不使用 DzBindEffect，完全由坐标驱动
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.04．伤害系统.06．暴击系统.01．暴击核心")
local registerCritAppliedFinalDamageListener = ____require_result_2.registerCritAppliedFinalDamageListener
local ____require_result_3 = require("系统.04．伤害系统.05．闪避系统.01．闪避核心")
local registerDodgeAppliedFinalDamageListener = ____require_result_3.registerDodgeAppliedFinalDamageListener
local ____require_result_4 = require("系统.04．伤害系统.04．命中系统.01．命中核心")
local registerMissAppliedFinalDamageListener = ____require_result_4.registerMissAppliedFinalDamageListener
local AddSpecialEffect = jass.AddSpecialEffect
DestroyEffect = jass.DestroyEffect
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFlyHeight = jass.GetUnitFlyHeight
IsUnitType = jass.IsUnitType
local R2I = jass.R2I
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
EXSetEffectXY = japi.EXSetEffectXY
EXSetEffectZ = japi.EXSetEffectZ
local DzGetColor = japi.DzGetColor
local DzSetEffectVertexColor = japi.DzSetEffectVertexColor
local DzSetEffectAnimation = japi.DzSetEffectAnimation
DzSetEffectScale = japi.DzSetEffectScale
local DzSetEffectVisible = japi.DzSetEffectVisible
local _____5DF2_542F_7528 = true
local _____6A21_578B_57FA_7840_8DEF_5F84 = "UI\\DamageNumbers\\DmgNum_"
local _____6A21_578B_6269_5C55_540D = ".mdx"
local _____6A21_578B_52A8_753B_7D22_5F15 = 2
local _____6A21_578B_7F29_653E = 1.05
local _____6700_5C0F_663E_793A_4F24_5BB3 = 1
local _____4E0A_6D6E_6301_7EED_65F6_95F4 = 0.35
local _____4E0A_6D6E_9AD8_5EA6 = 80
local _____6570_5B57_95F4_8DDD = 24
local _____524D_7F00_6A21_578B_95F4_8DDD = 34
local _____524D_7F00_6A21_578B_7F29_653E = 1.15
_____57FA_7840Z_504F_79FB = 110
local _____66B4_51FB_524D_7F00_6A21_578B = "UI\\DamageNumbers\\DmgPfxC.mdx"
local _____95EA_907F_524D_7F00_6A21_578B = "UI\\DamageNumbers\\DmgPfxD.mdx"
local _____672A_547D_4E2D_524D_7F00_6A21_578B = "UI\\DamageNumbers\\DmgPfxM.mdx"
local _____98CE_6728_5C5E_6027_4F24_5BB3_989C_8272 = {r = 0, g = 255, b = 0}
local _____5DF2_521D_59CB_5316 = false
_____5DF2_6CE8_518CTick = false
local _____4E0B_4E00_4E2A_5B9E_4F8BID = 0
_____5B9E_4F8B_8868 = {}
_____5B9E_4F8BID_5217_8868 = {}
local _____7279_6B8A_6570_5B57_8DF3_8FC7_5217_8868 = {}
local function _____9650_5236_989C_8272_5B57_8282(value)
    if value <= 0 then
        return 0
    end
    if value >= 255 then
        return 255
    end
    return R2I(value)
end
local function _____8F6C_4E3A_663E_793A_6574_6570_4F24_5BB3(applied)
    if not (applied > 0) then
        return 0
    end
    return R2I(applied + 0.5)
end
local function _____6807_8BB0_8DF3_8FC7_666E_901A_6570_5B57(target, attacker, applied)
    local value = _____8F6C_4E3A_663E_793A_6574_6570_4F24_5BB3(applied)
    if value < _____6700_5C0F_663E_793A_4F24_5BB3 then
        return
    end
    _____7279_6B8A_6570_5B57_8DF3_8FC7_5217_8868[#_____7279_6B8A_6570_5B57_8DF3_8FC7_5217_8868 + 1] = {target = target, attacker = attacker, value = value}
end
local function _____6D88_8017_666E_901A_6570_5B57_8DF3_8FC7_6807_8BB0(target, attacker, value)
    do
        local i = 0
        while i < #_____7279_6B8A_6570_5B57_8DF3_8FC7_5217_8868 do
            do
                local record = _____7279_6B8A_6570_5B57_8DF3_8FC7_5217_8868[i + 1]
                if record == nil then
                    goto __continue11
                end
                if record.target ~= target or record.attacker ~= attacker or record.value ~= value then
                    goto __continue11
                end
                __TS__ArraySplice(_____7279_6B8A_6570_5B57_8DF3_8FC7_5217_8868, i, 1)
                return true
            end
            ::__continue11::
            i = i + 1
        end
    end
    return false
end
local function _____9009_53D6_4F24_5BB3_989C_8272(damageType)
    if damageType.isNormalAttack then
        return {r = 160, g = 82, b = 45}
    end
    if damageType.isTrueDamage then
        return {r = 255, g = 255, b = 255}
    end
    if damageType.isEnhancedDamage then
        return {r = 255, g = 140, b = 0}
    end
    if damageType.isFireDamage then
        return {r = 255, g = 66, b = 66}
    end
    if damageType.isWaterDamage then
        return {r = 80, g = 190, b = 255}
    end
    if damageType.isThunderDamage then
        return {r = 170, g = 220, b = 255}
    end
    if damageType.isMetalDamage then
        return {r = 255, g = 210, b = 80}
    end
    if damageType.isWoodDamage then
        return _____98CE_6728_5C5E_6027_4F24_5BB3_989C_8272
    end
    if damageType.isLightDamage then
        return {r = 255, g = 255, b = 170}
    end
    if damageType.isDarkDamage then
        return {r = 180, g = 130, b = 255}
    end
    if damageType.isPhysicalDamage then
        return {r = 160, g = 82, b = 45}
    end
    if damageType.isMagicDamage then
        return {r = 120, g = 140, b = 255}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_MIND then
        return {r = 255, g = 255, b = 155}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_ENHANCED then
        return {r = 255, g = 140, b = 0}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_FIRE then
        return {r = 255, g = 66, b = 66}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_COLD then
        return {r = 80, g = 190, b = 255}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_LIGHTNING then
        return {r = 170, g = 220, b = 255}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_POISON then
        return {r = 255, g = 210, b = 80}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_SLOW_POISON then
        return {r = 255, g = 210, b = 80}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_ACID then
        return {r = 255, g = 210, b = 80}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_DISEASE then
        return {r = 255, g = 210, b = 80}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_PLANT then
        return _____98CE_6728_5C5E_6027_4F24_5BB3_989C_8272
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_DIVINE then
        return {r = 255, g = 255, b = 170}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_SHADOW_STRIKE then
        return {r = 180, g = 130, b = 255}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_SONIC then
        return {r = 255, g = 160, b = 255}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_MAGIC then
        return {r = 120, g = 140, b = 255}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_NORMAL then
        return {r = 160, g = 82, b = 45}
    end
    if damageType.rawDamageType == jass.DAMAGE_TYPE_UNIVERSAL then
        return {r = 255, g = 255, b = 255}
    end
    return {r = 255, g = 255, b = 255}
end
local function _____786E_4FDD_8BA1_65F6_5668()
    if _____5DF2_6CE8_518CTick then
        return
    end
    _____5DF2_6CE8_518CTick = true
    onTick10ms(_____9A71_52A8_4F24_5BB3_6570_5B57)
end
local function _____521B_5EFA_6A21_578B_7279_6548(modelPath, x, y, z, color, scale, popScale)
    local effect = AddSpecialEffect(modelPath, x, y)
    if effect == nil or effect == 0 then
        return nil
    end
    if type(EXSetEffectZ) == "function" then
        EXSetEffectZ(effect, z)
    end
    if type(DzSetEffectVisible) == "function" then
        DzSetEffectVisible(effect, true)
    end
    if type(DzSetEffectScale) == "function" then
        DzSetEffectScale(effect, popScale and scale * 0.7 or scale)
    end
    if type(DzSetEffectAnimation) == "function" then
        DzSetEffectAnimation(effect, _____6A21_578B_52A8_753B_7D22_5F15, 0)
    end
    if color ~= nil and type(DzGetColor) == "function" and type(DzSetEffectVertexColor) == "function" then
        local colorValue = DzGetColor(
            255,
            _____9650_5236_989C_8272_5B57_8282(color.r),
            _____9650_5236_989C_8272_5B57_8282(color.g),
            _____9650_5236_989C_8272_5B57_8282(color.b)
        )
        DzSetEffectVertexColor(effect, colorValue)
    end
    return {effect = effect, xOffset = 0, scale = scale, popScale = popScale}
end
local function _____521B_5EFA_6570_5B57_7279_6548(digit, x, y, z, color)
    local modelPath = (_____6A21_578B_57FA_7840_8DEF_5F84 .. tostring(digit)) .. _____6A21_578B_6269_5C55_540D
    return _____521B_5EFA_6A21_578B_7279_6548(
        modelPath,
        x,
        y,
        z,
        color,
        _____6A21_578B_7F29_653E,
        false
    )
end
local function _____521B_5EFA_4F24_5BB3_6570_5B57_7EC4(target, amount, source, damageType, prefixModel)
    local hasAmount = amount >= _____6700_5C0F_663E_793A_4F24_5BB3
    local text = hasAmount and tostring(amount) or ""
    local len = #text
    if not hasAmount and prefixModel == nil then
        return
    end
    local startX = GetUnitX(target)
    local startY = GetUnitY(target)
    local startZ = GetUnitFlyHeight(target) + _____57FA_7840Z_504F_79FB
    local color = _____9009_53D6_4F24_5BB3_989C_8272(damageType)
    local effects = {}
    local left = -((len - 1) * _____6570_5B57_95F4_8DDD) / 2
    if prefixModel ~= nil then
        local prefixOffset = hasAmount and left - _____524D_7F00_6A21_578B_95F4_8DDD or 0
        local prefix = _____521B_5EFA_6A21_578B_7279_6548(
            prefixModel,
            startX + prefixOffset,
            startY,
            startZ,
            nil,
            _____524D_7F00_6A21_578B_7F29_653E,
            true
        )
        if prefix ~= nil then
            prefix.xOffset = prefixOffset
            effects[#effects + 1] = prefix
        end
    end
    do
        local i = 0
        while i < len do
            do
                local ch = __TS__StringCharAt(text, i)
                local digit = (string.byte(ch, 1) or 0 / 0) - 48
                if digit < 0 or digit > 9 then
                    left = left + _____6570_5B57_95F4_8DDD
                    goto __continue70
                end
                local x = startX + left
                local e = _____521B_5EFA_6570_5B57_7279_6548(
                    digit,
                    x,
                    startY,
                    startZ,
                    color
                )
                if e ~= nil then
                    e.xOffset = left
                    effects[#effects + 1] = e
                end
                left = left + _____6570_5B57_95F4_8DDD
            end
            ::__continue70::
            i = i + 1
        end
    end
    if #effects <= 0 then
        return
    end
    _____4E0B_4E00_4E2A_5B9E_4F8BID = _____4E0B_4E00_4E2A_5B9E_4F8BID + 1
    local id = _____4E0B_4E00_4E2A_5B9E_4F8BID
    _____5B9E_4F8B_8868[id] = {
        id = id,
        target = target,
        source = source,
        elapsed = 0,
        duration = _____4E0A_6D6E_6301_7EED_65F6_95F4,
        startX = startX,
        startY = startY,
        startZ = startZ,
        riseHeight = _____4E0A_6D6E_9AD8_5EA6,
        effects = effects
    }
    _____5B9E_4F8BID_5217_8868[#_____5B9E_4F8BID_5217_8868 + 1] = id
    _____786E_4FDD_8BA1_65F6_5668()
end
local function _____521B_5EFA_4F24_5BB3_6570_5B57(target, amount, source, damageType)
    _____521B_5EFA_4F24_5BB3_6570_5B57_7EC4(
        target,
        amount,
        source,
        damageType,
        nil
    )
end
local function _____5E94_7528_6700_7EC8_4F24_5BB3_65F6(target, attacker, applied, damageType)
    if not _____5DF2_542F_7528 then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local value = _____8F6C_4E3A_663E_793A_6574_6570_4F24_5BB3(applied)
    if value < _____6700_5C0F_663E_793A_4F24_5BB3 then
        return
    end
    if _____6D88_8017_666E_901A_6570_5B57_8DF3_8FC7_6807_8BB0(target, attacker, value) then
        return
    end
    _____521B_5EFA_4F24_5BB3_6570_5B57(target, value, attacker, damageType)
end
local function _____66B4_51FB_6700_7EC8_4F24_5BB3_663E_793A(record, applied, snapshot)
    if not _____5DF2_542F_7528 then
        return
    end
    local ____temp_5
    if record ~= nil then
        ____temp_5 = record.target
    else
        ____temp_5 = nil
    end
    local target = ____temp_5
    local ____temp_6
    if record ~= nil then
        ____temp_6 = record.attacker
    else
        ____temp_6 = nil
    end
    local attacker = ____temp_6
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local value = _____8F6C_4E3A_663E_793A_6574_6570_4F24_5BB3(applied)
    if value < _____6700_5C0F_663E_793A_4F24_5BB3 then
        return
    end
    _____6807_8BB0_8DF3_8FC7_666E_901A_6570_5B57(target, attacker, applied)
    _____521B_5EFA_4F24_5BB3_6570_5B57_7EC4(
        target,
        value,
        attacker,
        snapshot,
        _____66B4_51FB_524D_7F00_6A21_578B
    )
end
local function _____95EA_907F_6700_7EC8_4F24_5BB3_663E_793A(record, applied, snapshot)
    if not _____5DF2_542F_7528 then
        return
    end
    local ____temp_7
    if record ~= nil then
        ____temp_7 = record.target
    else
        ____temp_7 = nil
    end
    local target = ____temp_7
    local ____temp_8
    if record ~= nil then
        ____temp_8 = record.attacker
    else
        ____temp_8 = nil
    end
    local attacker = ____temp_8
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    if _____8F6C_4E3A_663E_793A_6574_6570_4F24_5BB3(applied) >= _____6700_5C0F_663E_793A_4F24_5BB3 then
        _____6807_8BB0_8DF3_8FC7_666E_901A_6570_5B57(target, attacker, applied)
    end
    _____521B_5EFA_4F24_5BB3_6570_5B57_7EC4(
        target,
        0,
        attacker,
        snapshot,
        _____95EA_907F_524D_7F00_6A21_578B
    )
end
local function _____672A_547D_4E2D_6700_7EC8_4F24_5BB3_663E_793A(record, _applied, snapshot)
    if not _____5DF2_542F_7528 then
        return
    end
    local ____temp_9
    if record ~= nil then
        ____temp_9 = record.attacker
    else
        ____temp_9 = nil
    end
    local attacker = ____temp_9
    local ____temp_10
    if record ~= nil then
        ____temp_10 = record.target
    else
        ____temp_10 = nil
    end
    local target = ____temp_10
    if not _____5355_4F4D_5B58_6D3B(attacker) then
        return
    end
    _____521B_5EFA_4F24_5BB3_6570_5B57_7EC4(
        attacker,
        0,
        target,
        snapshot,
        _____672A_547D_4E2D_524D_7F00_6A21_578B
    )
end
____exports["初始化伤害数字模型显示"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerCritAppliedFinalDamageListener(_____66B4_51FB_6700_7EC8_4F24_5BB3_663E_793A)
    registerDodgeAppliedFinalDamageListener(_____95EA_907F_6700_7EC8_4F24_5BB3_663E_793A)
    registerMissAppliedFinalDamageListener(_____672A_547D_4E2D_6700_7EC8_4F24_5BB3_663E_793A)
    registerAppliedFinalDamageListener(_____5E94_7528_6700_7EC8_4F24_5BB3_65F6)
end
function ____exports.initDamageNumberModelDisplay()
    ____exports["初始化伤害数字模型显示"]()
end
return ____exports
