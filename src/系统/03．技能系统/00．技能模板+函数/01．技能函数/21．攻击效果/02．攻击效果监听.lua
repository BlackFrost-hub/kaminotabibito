--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____on_666E_653B_653B_51FB_6548_679C_4F24_5BB3_4E8B_4EF6, ____on_6700_7EC8_4F24_5BB3_653B_51FB_6548_679C_4E8B_4EF6, ____dispatch_666E_653B_653B_51FB_6548_679C_76D1_542C_5668, ____dispatch_6700_7EC8_4F24_5BB3_76D1_542C_5668, _____666E_653B_76D1_542C_5217_8868, _____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868
local ____01_FF0E_653B_51FB_6548_679C_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．攻击效果状态")
local _____653B_51FB_6548_679C_662F_5426_5728_51B7_5374_4E2D = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果是否在冷却中"]
local _____653B_51FB_6548_679C_8FDB_5165_51B7_5374 = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果进入冷却"]
local _____653B_51FB_6548_679C_5F00_59CB_6267_884C = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果开始执行"]
local _____653B_51FB_6548_679C_7ED3_675F_6267_884C = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果结束执行"]
function ____on_666E_653B_653B_51FB_6548_679C_4F24_5BB3_4E8B_4EF6(target, damage, damageType, fromDotTickBatch, source, isNormalAttack)
    if target == nil or target == 0 then
        return
    end
    if not (damage > 0) then
        return
    end
    if fromDotTickBatch == true then
        return
    end
    local ____source_2 = source
    if ____source_2 == nil then
        ____source_2 = nil
    end
    local ctx = {
        source = ____source_2,
        target = target,
        damage = damage,
        damageType = damageType,
        fromDotTickBatch = false,
        isNormalAttack = isNormalAttack == true
    }
    ____dispatch_666E_653B_653B_51FB_6548_679C_76D1_542C_5668(ctx)
end
function ____on_6700_7EC8_4F24_5BB3_653B_51FB_6548_679C_4E8B_4EF6(target, attacker, applied, snapshot)
    if target == nil or target == 0 then
        return
    end
    if not (applied > 0) then
        return
    end
    local ____attacker_3 = attacker
    if ____attacker_3 == nil then
        ____attacker_3 = nil
    end
    local ctx = {source = ____attacker_3, target = target, applied = applied, snapshot = snapshot}
    ____dispatch_6700_7EC8_4F24_5BB3_76D1_542C_5668(ctx)
end
function ____dispatch_666E_653B_653B_51FB_6548_679C_76D1_542C_5668(ctx)
    do
        local i = 0
        while i < #_____666E_653B_76D1_542C_5217_8868 do
            do
                local _____5B9E_4F8B = _____666E_653B_76D1_542C_5217_8868[i + 1]
                if _____5B9E_4F8B == nil then
                    goto __continue15
                end
                if _____5B9E_4F8B["条件"] ~= nil and _____5B9E_4F8B["条件"](ctx) == false then
                    goto __continue15
                end
                if ctx.isNormalAttack ~= true then
                    goto __continue15
                end
                if _____653B_51FB_6548_679C_662F_5426_5728_51B7_5374_4E2D(_____5B9E_4F8B["名称"], ctx.source, _____5B9E_4F8B["冷却毫秒"] or 0) then
                    goto __continue15
                end
                if not _____653B_51FB_6548_679C_5F00_59CB_6267_884C(_____5B9E_4F8B["名称"], ctx.source) then
                    goto __continue15
                end
                do
                    local ____try, ____error = pcall(function()
                        _____653B_51FB_6548_679C_8FDB_5165_51B7_5374(_____5B9E_4F8B["名称"], ctx.source)
                        _____5B9E_4F8B["命中后"](ctx)
                    end)
                    do
                        _____653B_51FB_6548_679C_7ED3_675F_6267_884C(_____5B9E_4F8B["名称"], ctx.source)
                    end
                    if not ____try then
                        error(____error, 0)
                    end
                end
            end
            ::__continue15::
            i = i + 1
        end
    end
end
function ____dispatch_6700_7EC8_4F24_5BB3_76D1_542C_5668(ctx)
    do
        local i = 0
        while i < #_____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 do
            do
                local _____5B9E_4F8B = _____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868[i + 1]
                if _____5B9E_4F8B == nil then
                    goto __continue25
                end
                if _____5B9E_4F8B["条件"] ~= nil and _____5B9E_4F8B["条件"](ctx) == false then
                    goto __continue25
                end
                if _____653B_51FB_6548_679C_662F_5426_5728_51B7_5374_4E2D(_____5B9E_4F8B["名称"], ctx.source, _____5B9E_4F8B["冷却毫秒"] or 0) then
                    goto __continue25
                end
                if not _____653B_51FB_6548_679C_5F00_59CB_6267_884C(_____5B9E_4F8B["名称"], ctx.source) then
                    goto __continue25
                end
                do
                    local ____try, ____error = pcall(function()
                        _____653B_51FB_6548_679C_8FDB_5165_51B7_5374(_____5B9E_4F8B["名称"], ctx.source)
                        _____5B9E_4F8B["命中后"](ctx)
                    end)
                    do
                        _____653B_51FB_6548_679C_7ED3_675F_6267_884C(_____5B9E_4F8B["名称"], ctx.source)
                    end
                    if not ____try then
                        error(____error, 0)
                    end
                end
            end
            ::__continue25::
            i = i + 1
        end
    end
end
local ____require_result_0 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_0.registerDamageCallback
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
_____666E_653B_76D1_542C_5217_8868 = {}
_____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 = {}
local _____666E_653B_76D1_542C_5DF2_6CE8_518C = false
local _____6700_7EC8_4F24_5BB3_76D1_542C_5DF2_6CE8_518C = false
local function _____786E_4FDD_666E_653B_76D1_542C_5DF2_6CE8_518C()
    if _____666E_653B_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____666E_653B_76D1_542C_5DF2_6CE8_518C = true
    registerDamageCallback(____on_666E_653B_653B_51FB_6548_679C_4F24_5BB3_4E8B_4EF6)
end
local function _____786E_4FDD_6700_7EC8_4F24_5BB3_76D1_542C_5DF2_6CE8_518C()
    if _____6700_7EC8_4F24_5BB3_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6700_7EC8_4F24_5BB3_76D1_542C_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_6700_7EC8_4F24_5BB3_653B_51FB_6548_679C_4E8B_4EF6)
end
____exports["注册普攻攻击效果监听"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or not _____53C2_6570["名称"] or _____53C2_6570["命中后"] == nil then
        return
    end
    _____666E_653B_76D1_542C_5217_8868[#_____666E_653B_76D1_542C_5217_8868 + 1] = _____53C2_6570
    _____786E_4FDD_666E_653B_76D1_542C_5DF2_6CE8_518C()
end
____exports["注册最终伤害攻击效果监听"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or not _____53C2_6570["名称"] or _____53C2_6570["命中后"] == nil then
        return
    end
    _____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868[#_____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 + 1] = _____53C2_6570
    _____786E_4FDD_6700_7EC8_4F24_5BB3_76D1_542C_5DF2_6CE8_518C()
end
return ____exports
