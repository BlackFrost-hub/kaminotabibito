--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_914D_7F6E_578B_6301_7EED_4F24_5BB3_5EFA_8BAE_68C0_67E5_95F4_9694, ____on_914D_7F6E_578B_6301_7EED_4F24_5BB3Tick, _____8BA1_7B97_6301_7EED_4F24_5BB3_6700_7EC8_503C, _____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868
local ____02_FF0E_4F24_5BB3_8BA1_7B97 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.02．伤害计算")
local _____8BA1_7B97_914D_7F6E_578B_653B_51FB_6548_679C_4F24_5BB3 = ____02_FF0E_4F24_5BB3_8BA1_7B97["计算配置型攻击效果伤害"]
local ____01_FF0E_57FA_7840_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.01．配置型攻击效果.01．基础工具")
local _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3 = ____01_FF0E_57FA_7840_5DE5_5177["配置型攻击效果造成伤害"]
local _____914D_7F6E_578B_5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_57FA_7840_5DE5_5177["配置型单位有效存活"]
local _____914D_7F6E_578B_64AD_653E_76EE_6807_7279_6548 = ____01_FF0E_57FA_7840_5DE5_5177["配置型播放目标特效"]
local _____914D_7F6E_578B_65BD_52A0_51CF_901F = ____01_FF0E_57FA_7840_5DE5_5177["配置型施加减速"]
function _____53D6_914D_7F6E_578B_6301_7EED_4F24_5BB3_5EFA_8BAE_68C0_67E5_95F4_9694(_nowMs)
    local _____6700_77ED_95F4_9694 = 0
    do
        local i = 0
        while i < #_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868 do
            local _____95F4_9694 = _____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868[i + 1].intervalMs
            if _____95F4_9694 > 0 and (_____6700_77ED_95F4_9694 == 0 or _____95F4_9694 < _____6700_77ED_95F4_9694) then
                _____6700_77ED_95F4_9694 = _____95F4_9694
            end
            i = i + 1
        end
    end
    return _____6700_77ED_95F4_9694
end
function ____on_914D_7F6E_578B_6301_7EED_4F24_5BB3Tick(now)
    local write = 0
    do
        local i = 0
        while i < #_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868 do
            do
                local record = _____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868[i + 1]
                if record == nil or not _____914D_7F6E_578B_5355_4F4D_6709_6548_5B58_6D3B(record.source) or not _____914D_7F6E_578B_5355_4F4D_6709_6548_5B58_6D3B(record.target) or record.remainTicks <= 0 then
                    goto __continue10
                end
                if now >= record.nextTime then
                    if record.effect ~= "" then
                        _____914D_7F6E_578B_64AD_653E_76EE_6807_7279_6548(record.target, record.effect)
                    end
                    local finalAmount = _____8BA1_7B97_6301_7EED_4F24_5BB3_6700_7EC8_503C(record.source, record.amount)
                    if finalAmount > 0 then
                        _____914D_7F6E_578B_653B_51FB_6548_679C_9020_6210_4F24_5BB3(
                            record.source,
                            record.target,
                            finalAmount,
                            record.damageType,
                            {["伤害形态"] = "单体", ["装备技能类型"] = "装备持续伤害"}
                        )
                    end
                    record.remainTicks = record.remainTicks - 1
                    record.nextTime = now + record.intervalMs
                end
                if record.remainTicks > 0 then
                    _____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868[write + 1] = record
                    write = write + 1
                end
            end
            ::__continue10::
            i = i + 1
        end
    end
    while #_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868 > write do
        table.remove(_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868)
    end
end
local ____require_result_0 = require("系统.04．伤害系统.07．持续伤害系统")
_____8BA1_7B97_6301_7EED_4F24_5BB3_6700_7EC8_503C = ____require_result_0["计算持续伤害最终值"]
local jass = require("jass.common")
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8 = ____require_result_2["创建自适应共享周期驱动"]
local R2I = jass.R2I
_____914D_7F6E_578B_6301_7EED_4F24_5BB3_5217_8868 = {}
local _____914D_7F6E_578B_6301_7EED_4F24_5BB3_9A71_52A8
local function _____6CE8_518C_914D_7F6E_578B_6301_7EED_4F24_5BB3Tick()
    if _____914D_7F6E_578B_6301_7EED_4F24_5BB3_9A71_52A8 == nil then
        _____914D_7F6E_578B_6301_7EED_4F24_5BB3_9A71_52A8 = _____521B_5EFA_81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8({["名称"] = "配置型攻击持续伤害驱动", ["最大检查间隔毫秒"] = 100, ["取建议检查间隔毫秒"] = _____53D6_914D_7F6E_578B_6301_7EED_4F24_5BB3_5EFA_8BAE_68C0_67E5_95F4_9694, onTick = ____on_914D_7F6E_578B_6301_7EED_4F24_5BB3Tick})
    end
    _____914D_7F6E_578B_6301_7EED_4F24_5BB3_9A71_52A8["刷新"](_____914D_7F6E_578B_6301_7EED_4F24_5BB3_9A71_52A8)
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
