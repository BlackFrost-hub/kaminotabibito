--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.02．攻击效果注册表")
local _____6CE8_518C_653B_51FB_6548_679C_914D_7F6E = ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868["注册攻击效果配置"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_0["施加扩展控制"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____6267_6CD5_8005_5FBD_8BB0_76EE_6807_51B7_5374 = {}
local function _____53D6_6267_6CD5_8005_5FBD_8BB0_51B7_5374_952E(source, target)
    if source == nil or source == 0 or target == nil or target == 0 then
        return ""
    end
    return (tostring(GetHandleId(source)) .. ":") .. tostring(GetHandleId(target))
end
local function _____6267_884C_6267_6CD5_8005_5FBD_8BB0_6C89_9ED8(ctx)
    local key = _____53D6_6267_6CD5_8005_5FBD_8BB0_51B7_5374_952E(ctx.source, ctx.target)
    if key == "" then
        return
    end
    local now = getServerTime()
    local last = _____6267_6CD5_8005_5FBD_8BB0_76EE_6807_51B7_5374[key]
    if last ~= nil and now - last < 8000 then
        return
    end
    _____6267_6CD5_8005_5FBD_8BB0_76EE_6807_51B7_5374[key] = now
    _____65BD_52A0_6269_5C55_63A7_5236(ctx.source, ctx.target, "silence", {["持续时间"] = 2})
end
_____6CE8_518C_653B_51FB_6548_679C_914D_7F6E({
    ["装备名"] = "执法者徽记",
    ["触发侧"] = "攻击者",
    ["效果类型"] = "额外伤害",
    ["仅普通攻击"] = true,
    ["概率"] = 0.1,
    ["自定义执行"] = _____6267_884C_6267_6CD5_8005_5FBD_8BB0_6C89_9ED8
})
return ____exports
