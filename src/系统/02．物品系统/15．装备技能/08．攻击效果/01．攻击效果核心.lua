--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____on_653B_51FB_6548_679C_5EF6_8FDF_4F24_5BB3, ____on_653B_51FB_6548_679C_6301_7EED_4F24_5BB3Tick, ____on_653B_51FB_6548_679C_4E34_65F6_5C5E_6027_7ED3_675F, getServerTime, _____5EF6_8FDF_4F24_5BB3_961F_5217, _____6301_7EED_4F24_5BB3_5217_8868, _____4E34_65F6_5C5E_6027_961F_5217
local ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.02．攻击效果注册表")
local _____83B7_53D6_653B_51FB_6548_679C_914D_7F6E_5217_8868 = ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868["获取攻击效果配置列表"]
local ____01_FF0E_653B_51FB_6548_679C_5DE5_5177 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.01．攻击效果工具")
local _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位持有攻击效果装备"]
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位有效存活"]
local _____5355_4F4D_662F_7CBE_82F1_76EE_6807 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位是精英目标"]
local _____653B_51FB_8005_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击者类型满足"]
local _____5355_4F4D_6B66_5668_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位武器类型满足"]
local _____662F_5426_653B_51FB_6548_679C_5168_5C40_8DF3_8FC7 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["是否攻击效果全局跳过"]
local _____8DDD_79BB_6EE1_8DB3_9650_5236 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["距离满足限制"]
local _____547D_4E2D_6982_7387_901A_8FC7 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["命中概率通过"]
local _____53D6_653B_51FB_529B = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取攻击力"]
local _____53D6_529B_91CF = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取力量"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取最大生命"]
local _____53D6_6700_5927_9B54_6CD5 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取最大魔法"]
local _____653B_51FB_6548_679C_9020_6210_4F24_5BB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击效果造成伤害"]
local _____653B_51FB_6548_679C_6CBB_7597_751F_547D_9B54_6CD5 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击效果治疗生命魔法"]
local _____653B_51FB_6548_679C_51CF_5C11_751F_547D_9B54_6CD5 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击效果减少生命魔法"]
local _____83B7_53D6_654C_65B9_8303_56F4_5355_4F4D = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["获取敌方范围单位"]
local _____64AD_653E_76EE_6807_7279_6548 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["播放目标特效"]
local _____64AD_653E_5355_4F4D_5750_6807_7279_6548 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["播放单位坐标特效"]
local _____65BD_52A0_653B_51FB_6548_679C_51CF_901F = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["施加攻击效果减速"]
local _____65BD_52A0_653B_51FB_6548_679C_7729_6655 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["施加攻击效果眩晕"]
local _____65BD_52A0_653B_51FB_6548_679C_51FB_98DE = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["施加攻击效果击飞"]
local _____4E34_65F6_4FEE_6539_653B_901F = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["临时修改攻速"]
local _____4E34_65F6_4FEE_6539_62A4_7532 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["临时修改护甲"]
function ____on_653B_51FB_6548_679C_5EF6_8FDF_4F24_5BB3()
    while #_____5EF6_8FDF_4F24_5BB3_961F_5217 > 0 do
        do
            local record = table.remove(_____5EF6_8FDF_4F24_5BB3_961F_5217, 1)
            if record == nil then
                goto __continue87
            end
            _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(record.source, record.target, record.amount, record.damageType)
        end
        ::__continue87::
    end
end
function ____on_653B_51FB_6548_679C_6301_7EED_4F24_5BB3Tick()
    local now = getServerTime()
    local write = 0
    do
        local i = 0
        while i < #_____6301_7EED_4F24_5BB3_5217_8868 do
            do
                local record = _____6301_7EED_4F24_5BB3_5217_8868[i + 1]
                if record == nil or not _____5355_4F4D_6709_6548_5B58_6D3B(record.source) or not _____5355_4F4D_6709_6548_5B58_6D3B(record.target) or record.remainTicks <= 0 then
                    goto __continue91
                end
                if now >= record.nextTime then
                    if record.effect ~= "" then
                        _____64AD_653E_76EE_6807_7279_6548(record.target, record.effect)
                    end
                    _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(record.source, record.target, record.amount, record.damageType)
                    record.remainTicks = record.remainTicks - 1
                    record.nextTime = now + record.intervalMs
                end
                if record.remainTicks > 0 then
                    _____6301_7EED_4F24_5BB3_5217_8868[write + 1] = record
                    write = write + 1
                end
            end
            ::__continue91::
            i = i + 1
        end
    end
    while #_____6301_7EED_4F24_5BB3_5217_8868 > write do
        table.remove(_____6301_7EED_4F24_5BB3_5217_8868)
    end
end
function ____on_653B_51FB_6548_679C_4E34_65F6_5C5E_6027_7ED3_675F()
    local record = table.remove(_____4E34_65F6_5C5E_6027_961F_5217, 1)
    if record == nil then
        return
    end
    if record.type == "攻速" then
        _____4E34_65F6_4FEE_6539_653B_901F(record.unit, record.value)
    else
        _____4E34_65F6_4FEE_6539_62A4_7532(record.unit, record.value)
    end
end
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C = ____require_result_0["延后一帧执行伤害派生效果"]
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
getServerTime = ____require_result_2.getServerTime
_____5EF6_8FDF_4F24_5BB3_961F_5217 = {}
_____6301_7EED_4F24_5BB3_5217_8868 = {}
_____4E34_65F6_5C5E_6027_961F_5217 = {}
local _____653B_51FB_6548_679C_51B7_5374 = {}
local _____5DF2_521D_59CB_5316 = false
local _____6301_7EED_4F24_5BB3Tick_5DF2_6CE8_518C = false
local function _____7EDD_5BF9_503C(value)
    return value < 0 and -value or value
end
local function _____5411_4E0B_53D6_6574(value)
    local jass = require("jass.common")
    local R2I = jass.R2I
    return R2I(value)
end
local function _____53D6_51B7_5374_952E(_____914D_7F6E, unit)
    local jass = require("jass.common")
    local GetHandleId = jass.GetHandleId
    if unit == nil or unit == 0 then
        return ""
    end
    return (_____914D_7F6E["装备名"] .. ":") .. tostring(GetHandleId(unit))
end
local function _____51B7_5374_901A_8FC7(_____914D_7F6E, unit)
    if _____914D_7F6E["冷却毫秒"] == nil or _____914D_7F6E["冷却毫秒"] <= 0 then
        return true
    end
    local key = _____53D6_51B7_5374_952E(_____914D_7F6E, unit)
    if key == "" then
        return false
    end
    local now = getServerTime()
    local last = _____653B_51FB_6548_679C_51B7_5374[key]
    if last ~= nil and now - last < _____914D_7F6E["冷却毫秒"] then
        return false
    end
    _____653B_51FB_6548_679C_51B7_5374[key] = now
    return true
end
local function _____57FA_7840_6761_4EF6_901A_8FC7(_____914D_7F6E, ctx)
    if not _____5355_4F4D_6709_6548_5B58_6D3B(ctx.source) or not _____5355_4F4D_6709_6548_5B58_6D3B(ctx.target) then
        return false
    end
    if _____914D_7F6E["仅普通攻击"] == true and not (ctx.snapshot ~= nil and ctx.snapshot.isNormalAttack == true) then
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
    if not _____547D_4E2D_6982_7387_901A_8FC7(_____914D_7F6E["概率"]) then
        return false
    end
    if not _____51B7_5374_901A_8FC7(_____914D_7F6E, ctx.source) then
        return false
    end
    return true
end
local function _____8BA1_7B97_4F24_5BB3(_____914D_7F6E, ctx)
    local amount = _____914D_7F6E["固定伤害"] or 0
    if _____914D_7F6E["攻击系数"] ~= nil then
        amount = amount + _____53D6_653B_51FB_529B(ctx.source) * _____914D_7F6E["攻击系数"]
    end
    if _____914D_7F6E["力量系数"] ~= nil then
        amount = amount + _____53D6_529B_91CF(ctx.source) * _____914D_7F6E["力量系数"]
    end
    if _____914D_7F6E["生命系数"] ~= nil then
        amount = amount + _____53D6_6700_5927_751F_547D(ctx.target) * _____914D_7F6E["生命系数"]
    end
    if _____914D_7F6E["伤害倍率"] ~= nil then
        amount = amount + ctx.applied * _____914D_7F6E["伤害倍率"]
    end
    return amount
end
local function _____6267_884C_53CD_51FB_4F24_5BB3(_____914D_7F6E, ctx)
    local amount = _____8BA1_7B97_4F24_5BB3(_____914D_7F6E, {source = ctx.target, target = ctx.source, applied = ctx.applied, snapshot = ctx.snapshot})
    _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(ctx.target, ctx.source, amount, _____914D_7F6E["伤害类型"])
end
local function _____6267_884C_989D_5916_4F24_5BB3(_____914D_7F6E, ctx)
    local amount = _____8BA1_7B97_4F24_5BB3(_____914D_7F6E, ctx)
    local _____8D44_6E90_5077_53D6_540C_65F6_9020_6210_4F24_5BB3 = _____914D_7F6E["固定伤害"] ~= nil or _____914D_7F6E["攻击系数"] ~= nil or _____914D_7F6E["力量系数"] ~= nil or _____914D_7F6E["生命系数"] ~= nil
    if _____914D_7F6E["效果类型"] ~= "资源偷取" or _____8D44_6E90_5077_53D6_540C_65F6_9020_6210_4F24_5BB3 then
        _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(ctx.source, ctx.target, amount, _____914D_7F6E["伤害类型"])
    end
    if (_____914D_7F6E["治疗生命"] or 0) > 0 or (_____914D_7F6E["恢复魔法"] or 0) > 0 then
        _____653B_51FB_6548_679C_6CBB_7597_751F_547D_9B54_6CD5(ctx.source, ctx.source, _____914D_7F6E["治疗生命"] or 0, _____914D_7F6E["恢复魔法"] or 0)
    end
    if (_____914D_7F6E["抽取生命比例"] or 0) > 0 or (_____914D_7F6E["抽取魔法比例"] or 0) > 0 then
        local life = _____53D6_6700_5927_751F_547D(ctx.target) * (_____914D_7F6E["抽取生命比例"] or 0)
        local mana = _____53D6_6700_5927_9B54_6CD5(ctx.target) * (_____914D_7F6E["抽取魔法比例"] or 0)
        _____653B_51FB_6548_679C_51CF_5C11_751F_547D_9B54_6CD5(ctx.target, life, mana)
        _____653B_51FB_6548_679C_6CBB_7597_751F_547D_9B54_6CD5(ctx.source, ctx.source, life, mana)
    end
    if _____914D_7F6E["效果类型"] == "资源偷取" and (_____914D_7F6E["伤害倍率"] or 0) > 0 then
        local steal = ctx.applied * (_____914D_7F6E["伤害倍率"] or 0)
        _____653B_51FB_6548_679C_51CF_5C11_751F_547D_9B54_6CD5(ctx.target, 0, steal)
        _____653B_51FB_6548_679C_6CBB_7597_751F_547D_9B54_6CD5(ctx.source, ctx.source, steal, 0)
    end
end
local function _____6267_884C_8303_56F4_4F24_5BB3(_____914D_7F6E, ctx)
    local radius = _____914D_7F6E["范围"] or 0
    if not (radius > 0) then
        return
    end
    local list = _____83B7_53D6_654C_65B9_8303_56F4_5355_4F4D(ctx.source, ctx.target, radius, true)
    local amount = _____8BA1_7B97_4F24_5BB3(_____914D_7F6E, ctx)
    do
        local i = 0
        while i < #list do
            _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(ctx.source, list[i + 1], amount, _____914D_7F6E["伤害类型"])
            i = i + 1
        end
    end
end
local function _____6CE8_518C_6301_7EED_4F24_5BB3Tick()
    if _____6301_7EED_4F24_5BB3Tick_5DF2_6CE8_518C then
        return
    end
    _____6301_7EED_4F24_5BB3Tick_5DF2_6CE8_518C = true
    addPeriodicCallback(100, ____on_653B_51FB_6548_679C_6301_7EED_4F24_5BB3Tick)
end
local function _____6267_884C_6301_7EED_4F24_5BB3(_____914D_7F6E, ctx)
    local duration = _____914D_7F6E["持续时间"] or 0
    local interval = _____914D_7F6E["间隔"] or 1
    if not (duration > 0) or not (interval > 0) then
        return
    end
    local ticks = _____5411_4E0B_53D6_6574(duration / interval)
    if not (ticks > 0) then
        return
    end
    _____6301_7EED_4F24_5BB3_5217_8868[#_____6301_7EED_4F24_5BB3_5217_8868 + 1] = {
        source = ctx.source,
        target = ctx.target,
        amount = _____8BA1_7B97_4F24_5BB3(_____914D_7F6E, ctx),
        damageType = _____914D_7F6E["伤害类型"],
        nextTime = getServerTime() + interval * 1000,
        remainTicks = ticks,
        intervalMs = interval * 1000,
        slow = _____914D_7F6E["减速"] or 0,
        effect = _____914D_7F6E["特效"] or ""
    }
    _____6CE8_518C_6301_7EED_4F24_5BB3Tick()
    if (_____914D_7F6E["减速"] or 0) > 0 then
        _____65BD_52A0_653B_51FB_6548_679C_51CF_901F(ctx.source, ctx.target, _____914D_7F6E["减速"] or 0, duration)
    end
end
local function _____6267_884C_4F4E_8840_65A9_6740(_____914D_7F6E, ctx)
    local maxLife = _____53D6_6700_5927_751F_547D(ctx.target)
    if not (maxLife > 0) then
        return
    end
    local line = _____5355_4F4D_662F_7CBE_82F1_76EE_6807(ctx.target) and (_____914D_7F6E["精英斩杀线"] or _____914D_7F6E["普通斩杀线"] or 0) or (_____914D_7F6E["普通斩杀线"] or 0)
    if not (line > 0) then
        return
    end
    if _____53D6_5F53_524D_751F_547D(ctx.target) / maxLife > line then
        return
    end
    _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(ctx.source, ctx.target, maxLife, _____914D_7F6E["伤害类型"])
end
local function _____6267_884C_8303_56F4_51FB_98DE(_____914D_7F6E, ctx)
    local radius = _____914D_7F6E["范围"] or 0
    local list = _____83B7_53D6_654C_65B9_8303_56F4_5355_4F4D(ctx.source, ctx.target, radius, true)
    local amount = _____8BA1_7B97_4F24_5BB3(_____914D_7F6E, ctx)
    do
        local i = 0
        while i < #list do
            local unit = list[i + 1]
            _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(ctx.source, unit, amount, _____914D_7F6E["伤害类型"])
            _____65BD_52A0_653B_51FB_6548_679C_51FB_98DE(ctx.source, unit, _____914D_7F6E["持续时间"] or 1.5)
            _____65BD_52A0_653B_51FB_6548_679C_7729_6655(ctx.source, unit, _____914D_7F6E["持续时间"] or 1.5)
            i = i + 1
        end
    end
end
local function _____6267_884C_4E34_65F6_653B_901F(_____914D_7F6E, ctx)
    local value = _____914D_7F6E["攻速加成"] or 0
    if value == 0 then
        return
    end
    _____4E34_65F6_4FEE_6539_653B_901F(ctx.source, value)
    _____4E34_65F6_5C5E_6027_961F_5217[#_____4E34_65F6_5C5E_6027_961F_5217 + 1] = {unit = ctx.source, type = "攻速", value = -value}
    addDelayedCallback((_____914D_7F6E["持续时间"] or 2) * 1000, ____on_653B_51FB_6548_679C_4E34_65F6_5C5E_6027_7ED3_675F)
    _____6267_884C_8303_56F4_4F24_5BB3(_____914D_7F6E, ctx)
end
local function _____6267_884C_62A4_7532_524A_51CF(_____914D_7F6E, ctx)
    local value = _____7EDD_5BF9_503C(_____914D_7F6E["固定伤害"] or 0)
    if not (value > 0) then
        return
    end
    _____4E34_65F6_4FEE_6539_62A4_7532(ctx.target, -value)
    _____4E34_65F6_5C5E_6027_961F_5217[#_____4E34_65F6_5C5E_6027_961F_5217 + 1] = {unit = ctx.target, type = "护甲", value = value}
    addDelayedCallback((_____914D_7F6E["持续时间"] or 5) * 1000, ____on_653B_51FB_6548_679C_4E34_65F6_5C5E_6027_7ED3_675F)
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
    local effectCtx = _____914D_7F6E["触发侧"] == "受击者" and _____914D_7F6E["效果类型"] ~= "反击伤害" and ({source = ctx.target, target = ctx.source, applied = ctx.applied, snapshot = ctx.snapshot}) or ctx
    if _____914D_7F6E["特效"] ~= nil and _____914D_7F6E["特效"] ~= "" then
        _____64AD_653E_76EE_6807_7279_6548(effectCtx.target, _____914D_7F6E["特效"])
    end
    if _____914D_7F6E["点特效"] ~= nil and _____914D_7F6E["点特效"] ~= "" then
        _____64AD_653E_5355_4F4D_5750_6807_7279_6548(effectCtx.target, _____914D_7F6E["点特效"], _____914D_7F6E["点特效缩放"])
    end
    if _____914D_7F6E["效果类型"] == "反击伤害" then
        _____6267_884C_53CD_51FB_4F24_5BB3(_____914D_7F6E, ctx)
    elseif _____914D_7F6E["效果类型"] == "额外伤害" then
        _____6267_884C_989D_5916_4F24_5BB3(_____914D_7F6E, effectCtx)
    elseif _____914D_7F6E["效果类型"] == "范围伤害" then
        _____6267_884C_8303_56F4_4F24_5BB3(_____914D_7F6E, effectCtx)
    elseif _____914D_7F6E["效果类型"] == "持续伤害" then
        _____6267_884C_6301_7EED_4F24_5BB3(_____914D_7F6E, effectCtx)
    elseif _____914D_7F6E["效果类型"] == "低血斩杀" then
        _____6267_884C_4F4E_8840_65A9_6740(_____914D_7F6E, effectCtx)
    elseif _____914D_7F6E["效果类型"] == "范围击飞" then
        _____6267_884C_8303_56F4_51FB_98DE(_____914D_7F6E, effectCtx)
    elseif _____914D_7F6E["效果类型"] == "临时攻速" then
        _____6267_884C_4E34_65F6_653B_901F(_____914D_7F6E, effectCtx)
    elseif _____914D_7F6E["效果类型"] == "护甲削减" then
        _____6267_884C_62A4_7532_524A_51CF(_____914D_7F6E, effectCtx)
    elseif _____914D_7F6E["效果类型"] == "资源偷取" then
        _____6267_884C_989D_5916_4F24_5BB3(_____914D_7F6E, effectCtx)
    end
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
                    goto __continue72
                end
                _____6267_884C_653B_51FB_6548_679C_914D_7F6E(cfg, ctx)
            end
            ::__continue72::
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
                    goto __continue79
                end
                if cfg["效果类型"] ~= "转换火焰伤害" then
                    goto __continue79
                end
                if context.isNormalAttack ~= true or context.isPhysicalDamage ~= true then
                    goto __continue79
                end
                if not _____653B_51FB_8005_7C7B_578B_6EE1_8DB3(context.attacker, cfg["攻击者类型"]) then
                    goto __continue79
                end
                if not _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907(context.attacker, cfg["装备名"]) then
                    goto __continue79
                end
                local amount = result * (cfg["伤害倍率"] or 0.8)
                if amount > 0 then
                    _____5EF6_8FDF_4F24_5BB3_961F_5217[#_____5EF6_8FDF_4F24_5BB3_961F_5217 + 1] = {source = context.attacker, target = context.target, amount = amount, damageType = cfg["伤害类型"]}
                    _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C(____on_653B_51FB_6548_679C_5EF6_8FDF_4F24_5BB3)
                end
                result = 0
            end
            ::__continue79::
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
