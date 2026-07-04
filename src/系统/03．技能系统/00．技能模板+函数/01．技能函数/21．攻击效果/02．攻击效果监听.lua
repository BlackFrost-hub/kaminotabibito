--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____on_6700_7EC8_4F24_5BB3_653B_51FB_6548_679C_4E8B_4EF6, ____dispatch_666E_653B_653B_51FB_6548_679C_76D1_542C_5668, ____dispatch_6700_7EC8_4F24_5BB3_76D1_542C_5668, _____666E_653B_76D1_542C_5217_8868, _____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868
local ____01_FF0E_653B_51FB_6548_679C_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．攻击效果状态")
local _____653B_51FB_6548_679C_662F_5426_5728_51B7_5374_4E2D = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果是否在冷却中"]
local _____653B_51FB_6548_679C_8FDB_5165_51B7_5374 = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果进入冷却"]
local _____653B_51FB_6548_679C_5F00_59CB_6267_884C = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果开始执行"]
local _____653B_51FB_6548_679C_7ED3_675F_6267_884C = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果结束执行"]
function ____on_6700_7EC8_4F24_5BB3_653B_51FB_6548_679C_4E8B_4EF6(target, attacker, applied, snapshot)
    if target == nil or target == 0 then
        return
    end
    if not (applied > 0) then
        return
    end
    local ____attacker_1 = attacker
    if ____attacker_1 == nil then
        ____attacker_1 = nil
    end
    local ____target_3 = target
    local ____applied_4 = applied
    local ____temp_2
    if snapshot ~= nil and snapshot.rawDamageType ~= nil then
        ____temp_2 = snapshot.rawDamageType
    else
        ____temp_2 = 0
    end
    local _____666E_653B_4E0A_4E0B_6587 = {
        source = ____attacker_1,
        target = ____target_3,
        damage = ____applied_4,
        damageType = ____temp_2,
        fromDotTickBatch = false,
        isNormalAttack = snapshot ~= nil and snapshot.isNormalAttack == true,
        snapshot = snapshot
    }
    ____dispatch_666E_653B_653B_51FB_6548_679C_76D1_542C_5668(_____666E_653B_4E0A_4E0B_6587)
    local ____attacker_5 = attacker
    if ____attacker_5 == nil then
        ____attacker_5 = nil
    end
    local ctx = {source = ____attacker_5, target = target, applied = applied, snapshot = snapshot}
    ____dispatch_6700_7EC8_4F24_5BB3_76D1_542C_5668(ctx)
end
function ____dispatch_666E_653B_653B_51FB_6548_679C_76D1_542C_5668(ctx)
    do
        local i = 0
        while i < #_____666E_653B_76D1_542C_5217_8868 do
            do
                local _____5B9E_4F8B = _____666E_653B_76D1_542C_5217_8868[i + 1]
                if _____5B9E_4F8B == nil then
                    goto __continue9
                end
                if _____5B9E_4F8B["条件"] ~= nil and _____5B9E_4F8B["条件"](ctx) == false then
                    goto __continue9
                end
                if ctx.isNormalAttack ~= true then
                    goto __continue9
                end
                local ____temp_11 = _____5B9E_4F8B["允许技能普攻"] ~= true
                if ____temp_11 then
                    local ____opt_6 = ctx.snapshot
                    if ____opt_6 ~= nil then
                        ____opt_6 = ____opt_6.isSkillAttack
                    end
                    local ____temp_10 = ____opt_6 == true
                    if not ____temp_10 then
                        local ____opt_8 = ctx.snapshot
                        if ____opt_8 ~= nil then
                            ____opt_8 = ____opt_8.isSkillDamage
                        end
                        ____temp_10 = ____opt_8 == true
                    end
                    ____temp_11 = ____temp_10
                end
                if ____temp_11 then
                    goto __continue9
                end
                if _____653B_51FB_6548_679C_662F_5426_5728_51B7_5374_4E2D(_____5B9E_4F8B["名称"], ctx.source, _____5B9E_4F8B["冷却毫秒"] or 0) then
                    goto __continue9
                end
                if not _____653B_51FB_6548_679C_5F00_59CB_6267_884C(_____5B9E_4F8B["名称"], ctx.source) then
                    goto __continue9
                end
                do
                    local ____try, ____error = pcall(function()
                        _____653B_51FB_6548_679C_8FDB_5165_51B7_5374(_____5B9E_4F8B["名称"], ctx.source, _____5B9E_4F8B["冷却毫秒"] or 0)
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
            ::__continue9::
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
                    goto __continue20
                end
                if _____5B9E_4F8B["条件"] ~= nil and _____5B9E_4F8B["条件"](ctx) == false then
                    goto __continue20
                end
                if _____653B_51FB_6548_679C_662F_5426_5728_51B7_5374_4E2D(_____5B9E_4F8B["名称"], ctx.source, _____5B9E_4F8B["冷却毫秒"] or 0) then
                    goto __continue20
                end
                if not _____653B_51FB_6548_679C_5F00_59CB_6267_884C(_____5B9E_4F8B["名称"], ctx.source) then
                    goto __continue20
                end
                do
                    local ____try, ____error = pcall(function()
                        _____653B_51FB_6548_679C_8FDB_5165_51B7_5374(_____5B9E_4F8B["名称"], ctx.source, _____5B9E_4F8B["冷却毫秒"] or 0)
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
            ::__continue20::
            i = i + 1
        end
    end
end
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
_____666E_653B_76D1_542C_5217_8868 = {}
_____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 = {}
local _____6700_7EC8_4F24_5BB3_76D1_542C_5DF2_6CE8_518C = false
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
    _____786E_4FDD_6700_7EC8_4F24_5BB3_76D1_542C_5DF2_6CE8_518C()
end
____exports["注册最终伤害攻击效果监听"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or not _____53C2_6570["名称"] or _____53C2_6570["命中后"] == nil then
        return
    end
    _____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868[#_____6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 + 1] = _____53C2_6570
    _____786E_4FDD_6700_7EC8_4F24_5BB3_76D1_542C_5DF2_6CE8_518C()
end
return ____exports
