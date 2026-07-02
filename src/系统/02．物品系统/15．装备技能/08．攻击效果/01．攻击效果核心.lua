--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____on_653B_51FB_6548_679C_5EF6_8FDF_4F24_5BB3, _____5EF6_8FDF_4F24_5BB3_961F_5217
local ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.02．攻击效果注册表")
local _____83B7_53D6_653B_51FB_6548_679C_914D_7F6E_5217_8868 = ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868["获取攻击效果配置列表"]
local ____01_FF0E_653B_51FB_6548_679C_5DE5_5177 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.01．攻击效果工具")
local _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位持有攻击效果装备"]
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位有效存活"]
local _____653B_51FB_8005_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击者类型满足"]
local _____5355_4F4D_6B66_5668_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位武器类型满足"]
local _____662F_5426_653B_51FB_6548_679C_5168_5C40_8DF3_8FC7 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["是否攻击效果全局跳过"]
local _____8DDD_79BB_6EE1_8DB3_9650_5236 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["距离满足限制"]
local _____547D_4E2D_6982_7387_901A_8FC7 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["命中概率通过"]
local ____01_FF0E_653B_51FB_6548_679C_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．攻击效果状态")
local _____653B_51FB_6548_679C_662F_5426_5728_51B7_5374_4E2D = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果是否在冷却中"]
local _____653B_51FB_6548_679C_8FDB_5165_51B7_5374 = ____01_FF0E_653B_51FB_6548_679C_72B6_6001["攻击效果进入冷却"]
local ____01_FF0E_914D_7F6E_578B_653B_51FB_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.index")
local _____6267_884C_914D_7F6E_578B_653B_51FB_6548_679C_914D_7F6E = ____01_FF0E_914D_7F6E_578B_653B_51FB_6548_679C["执行配置型攻击效果配置"]
local _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3 = ____01_FF0E_914D_7F6E_578B_653B_51FB_6548_679C["配置型攻击效果造成伤害"]
function ____on_653B_51FB_6548_679C_5EF6_8FDF_4F24_5BB3()
    while #_____5EF6_8FDF_4F24_5BB3_961F_5217 > 0 do
        do
            local record = table.remove(_____5EF6_8FDF_4F24_5BB3_961F_5217, 1)
            if record == nil then
                goto __continue41
            end
            _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3(record.source, record.target, record.amount, record.damageType)
        end
        ::__continue41::
    end
end
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C = ____require_result_0["延后一帧执行伤害派生效果"]
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7 = ____require_result_2["装备触发概率通过"]
_____5EF6_8FDF_4F24_5BB3_961F_5217 = {}
local _____5DF2_521D_59CB_5316 = false
local function _____51B7_5374_901A_8FC7(_____914D_7F6E, unit)
    if _____914D_7F6E["冷却毫秒"] == nil or _____914D_7F6E["冷却毫秒"] <= 0 then
        return true
    end
    if _____653B_51FB_6548_679C_662F_5426_5728_51B7_5374_4E2D(_____914D_7F6E["装备名"], unit, _____914D_7F6E["冷却毫秒"]) then
        return false
    end
    _____653B_51FB_6548_679C_8FDB_5165_51B7_5374(_____914D_7F6E["装备名"], unit)
    return true
end
local function _____6982_7387_901A_8FC7(chance, source)
    return _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7(chance, source)
end
local function _____4F24_5BB3_5FEB_7167_662F_7EAF_666E_653B(snapshot)
    return snapshot ~= nil and snapshot.isNormalAttack == true and snapshot.isSkillAttack ~= true and snapshot.isSkillDamage ~= true
end
local function _____57FA_7840_6761_4EF6_901A_8FC7(_____914D_7F6E, ctx)
    if not _____5355_4F4D_6709_6548_5B58_6D3B(ctx.source) or not _____5355_4F4D_6709_6548_5B58_6D3B(ctx.target) then
        return false
    end
    if _____914D_7F6E["仅普通攻击"] == true and not _____4F24_5BB3_5FEB_7167_662F_7EAF_666E_653B(ctx.snapshot) then
        return false
    end
    if _____914D_7F6E["仅物理"] == true and not (ctx.snapshot ~= nil and ctx.snapshot.isPhysicalDamage == true) then
        return false
    end
    if not _____653B_51FB_8005_7C7B_578B_6EE1_8DB3(ctx.source, _____914D_7F6E["攻击者类型"]) then
        return false
    end
    if not _____5355_4F4D_6B66_5668_7C7B_578B_6EE1_8DB3(ctx.source, _____914D_7F6E["需要武器类型"]) then
        return false
    end
    if not _____8DDD_79BB_6EE1_8DB3_9650_5236(ctx.source, ctx.target, _____914D_7F6E["最小距离"], _____914D_7F6E["最大距离"]) then
        return false
    end
    local _____6982_7387_503C = _____914D_7F6E["概率计算"] ~= nil and _____914D_7F6E["概率计算"](ctx) or _____914D_7F6E["概率"]
    if not _____547D_4E2D_6982_7387_901A_8FC7(_____6982_7387_503C, ctx.source) then
        return false
    end
    if not _____51B7_5374_901A_8FC7(_____914D_7F6E, ctx.source) then
        return false
    end
    return true
end
local function _____6267_884C_653B_51FB_6548_679C_914D_7F6E(_____914D_7F6E, ctx)
    if _____914D_7F6E["触发侧"] == "攻击者" and not _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907(ctx.source, _____914D_7F6E["装备名"]) then
        return
    end
    if _____914D_7F6E["触发侧"] == "受击者" and not _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907(ctx.target, _____914D_7F6E["装备名"]) then
        return
    end
    if not _____57FA_7840_6761_4EF6_901A_8FC7(_____914D_7F6E, ctx) then
        return
    end
    local effectCtx = _____914D_7F6E["触发侧"] == "受击者" and ({source = ctx.target, target = ctx.source, applied = ctx.applied, snapshot = ctx.snapshot}) or ctx
    _____6267_884C_914D_7F6E_578B_653B_51FB_6548_679C_914D_7F6E(_____914D_7F6E, effectCtx, _____6982_7387_901A_8FC7)
end
local function ____on_653B_51FB_6548_679C_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied >= 1) then
        return
    end
    if snapshot ~= nil and snapshot.isTrueDamage == true then
        return
    end
    if snapshot ~= nil and snapshot.isNormalAttack ~= true and snapshot.isSkillAttack ~= true then
        return
    end
    if _____662F_5426_653B_51FB_6548_679C_5168_5C40_8DF3_8FC7(attacker, snapshot) then
        return
    end
    local ctx = {source = attacker, target = target, applied = applied, snapshot = snapshot}
    local list = _____83B7_53D6_653B_51FB_6548_679C_914D_7F6E_5217_8868()
    do
        local i = 0
        while i < #list do
            do
                local cfg = list[i + 1]
                if cfg == nil or cfg["触发侧"] == "伤害修正" then
                    goto __continue26
                end
                _____6267_884C_653B_51FB_6548_679C_914D_7F6E(cfg, ctx)
            end
            ::__continue26::
            i = i + 1
        end
    end
end
local function ____on_653B_51FB_6548_679C_4F24_5BB3_4FEE_6B63(context)
    local result = context.currentDamage
    if not (result >= 1) then
        return result
    end
    if context.isTrueDamage == true then
        return result
    end
    if _____662F_5426_653B_51FB_6548_679C_5168_5C40_8DF3_8FC7(context.attacker) then
        return result
    end
    local list = _____83B7_53D6_653B_51FB_6548_679C_914D_7F6E_5217_8868()
    do
        local i = 0
        while i < #list do
            do
                local cfg = list[i + 1]
                if cfg == nil or cfg["触发侧"] ~= "伤害修正" then
                    goto __continue33
                end
                if cfg["效果类型"] ~= "转换火焰伤害" then
                    goto __continue33
                end
                if not _____4F24_5BB3_5FEB_7167_662F_7EAF_666E_653B(context) or context.isPhysicalDamage ~= true then
                    goto __continue33
                end
                if not _____653B_51FB_8005_7C7B_578B_6EE1_8DB3(context.attacker, cfg["攻击者类型"]) then
                    goto __continue33
                end
                if not _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907(context.attacker, cfg["装备名"]) then
                    goto __continue33
                end
                local amount = result * (cfg["伤害倍率"] or 0.8)
                if amount > 0 then
                    _____5EF6_8FDF_4F24_5BB3_961F_5217[#_____5EF6_8FDF_4F24_5BB3_961F_5217 + 1] = {source = context.attacker, target = context.target, amount = amount, damageType = cfg["伤害类型"]}
                    _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C(____on_653B_51FB_6548_679C_5EF6_8FDF_4F24_5BB3)
                end
                result = 0
            end
            ::__continue33::
            i = i + 1
        end
    end
    return result
end
____exports["init攻击效果事件"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerAppliedFinalDamageListener(____on_653B_51FB_6548_679C_6700_7EC8_4F24_5BB3)
    registerDamageModifier(____on_653B_51FB_6548_679C_4F24_5BB3_4FEE_6B63, 30)
end
____exports["init攻击效果事件"]()
return ____exports
