--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____on_914D_7F6E_578B_6301_7EED_4F24_5BB3Tick, getServerTime, _____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868
local ____02_FF0E_4F24_5BB3_8BA1_7B97 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.02．伤害计算")
local _____8BA1_7B97_914D_7F6E_578B_653B_51FB_6548_679C_4F24_5BB3 = ____02_FF0E_4F24_5BB3_8BA1_7B97["计算配置型攻击效果伤害"]
local ____01_FF0E_57FA_7840_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.01．基础工具")
local _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3 = ____01_FF0E_57FA_7840_5DE5_5177["配置型攻击效果造成伤害"]
local _____914D_7F6E_578B_5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_57FA_7840_5DE5_5177["配置型单位有效存活"]
local _____914D_7F6E_578B_64AD_653E_76EE_6807_7279_6548 = ____01_FF0E_57FA_7840_5DE5_5177["配置型播放目标特效"]
local _____914D_7F6E_578B_65BD_52A0_51CF_901F = ____01_FF0E_57FA_7840_5DE5_5177["配置型施加减速"]
function ____on_914D_7F6E_578B_6301_7EED_4F24_5BB3Tick()
    local now = getServerTime()
    local write = 0
    do
        local i = 0
        while i < #_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868 do
            do
                local record = _____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868[i + 1]
                if record == nil or not _____914D_7F6E_578B_5355_4F4D_6709_6548_5B58_6D3B(record.source) or not _____914D_7F6E_578B_5355_4F4D_6709_6548_5B58_6D3B(record.target) or record.remainTicks <= 0 then
                    goto __continue6
                end
                if now >= record.nextTime then
                    if record.effect ~= "" then
                        _____914D_7F6E_578B_64AD_653E_76EE_6807_7279_6548(record.target, record.effect)
                    end
                    _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3(record.source, record.target, record.amount, record.damageType)
                    record.remainTicks = record.remainTicks - 1
                    record.nextTime = now + record.intervalMs
                end
                if record.remainTicks > 0 then
                    _____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868[write + 1] = record
                    write = write + 1
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
    while #_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868 > write do
        table.remove(_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868)
    end
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
getServerTime = ____require_result_0.getServerTime
local R2I = jass.R2I
_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868 = {}
local _____914D_7F6E_578B_6301_7EED_4F24_5BB3Tick_5DF2_6CE8_518C = false
local function _____6CE8_518C_914D_7F6E_578B_6301_7EED_4F24_5BB3Tick()
    if _____914D_7F6E_578B_6301_7EED_4F24_5BB3Tick_5DF2_6CE8_518C then
        return
    end
    _____914D_7F6E_578B_6301_7EED_4F24_5BB3Tick_5DF2_6CE8_518C = true
    addPeriodicCallback(100, ____on_914D_7F6E_578B_6301_7EED_4F24_5BB3Tick)
end
____exports["执行配置型持续伤害"] = function(_____914D_7F6E, ctx)
    local duration = _____914D_7F6E["持续时间"] or 0
    local interval = _____914D_7F6E["间隔"] or 1
    if not (duration > 0) or not (interval > 0) then
        return
    end
    local ticks = R2I(duration / interval)
    if not (ticks > 0) then
        return
    end
    _____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868[#_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868 + 1] = {
        source = ctx.source,
        target = ctx.target,
        amount = _____8BA1_7B97_914D_7F6E_578B_653B_51FB_6548_679C_4F24_5BB3(_____914D_7F6E, ctx),
        damageType = _____914D_7F6E["伤害类型"],
        nextTime = getServerTime() + interval * 1000,
        remainTicks = ticks,
        intervalMs = interval * 1000,
        effect = _____914D_7F6E["特效"] or ""
    }
    _____6CE8_518C_914D_7F6E_578B_6301_7EED_4F24_5BB3Tick()
    if (_____914D_7F6E["减速"] or 0) > 0 then
        _____914D_7F6E_578B_65BD_52A0_51CF_901F(ctx.source, ctx.target, _____914D_7F6E["减速"] or 0, duration)
    end
end
return ____exports
