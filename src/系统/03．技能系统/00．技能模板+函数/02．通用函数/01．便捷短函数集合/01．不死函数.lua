local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 便捷短函数 - 不死、等一次性效果
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local _____4E0D_6B7B_96C6_5408 = {}
local function ____on_4E0D_6B7B_4F24_5BB3_4FEE_6B63(context)
    local target = context.target
    if target == nil or target == 0 then
        return context.currentDamage
    end
    local _____5355_4F4DID = GetHandleId(target)
    if _____5355_4F4DID == 0 then
        return context.currentDamage
    end
    if _____4E0D_6B7B_96C6_5408[_____5355_4F4DID] == nil then
        return context.currentDamage
    end
    local _____5F53_524D_8840_91CF = GetUnitState(target, jass.UNIT_STATE_LIFE)
    if _____5F53_524D_8840_91CF - context.currentDamage < 1 then
        return _____5F53_524D_8840_91CF - 1
    end
    return context.currentDamage
end
local _____4FEE_6B63_5668_5DF2_6CE8_518C = false
local function _____786E_4FDD_4FEE_6B63_5668_6CE8_518C()
    if _____4FEE_6B63_5668_5DF2_6CE8_518C then
        return
    end
    _____4FEE_6B63_5668_5DF2_6CE8_518C = true
    registerDamageModifier(____on_4E0D_6B7B_4F24_5BB3_4FEE_6B63, 60)
end
--- 令单位进入不死状态，受到致命伤害时保留1点血量。
-- 需调用方自行管理生命周期（搭配Buff到期回调等调用 移除单位不死）。
____exports["令单位不死"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    _____786E_4FDD_4FEE_6B63_5668_6CE8_518C()
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    _____4E0D_6B7B_96C6_5408[_____5355_4F4DID] = true
end
--- 移除单位的不死状态。
____exports["移除单位不死"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    __TS__Delete(_____4E0D_6B7B_96C6_5408, _____5355_4F4DID)
end
--- 查询单位是否处于不死状态。
____exports["单位是否不死"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    return _____5355_4F4DID ~= 0 and _____4E0D_6B7B_96C6_5408[_____5355_4F4DID] ~= nil
end
return ____exports
