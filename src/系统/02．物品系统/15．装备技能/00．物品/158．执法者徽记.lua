--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.02．攻击效果注册表")
local _____6CE8_518C_653B_51FB_6548_679C_914D_7F6E = ____02_FF0E_653B_51FB_6548_679C_6CE8_518C_8868["注册攻击效果配置"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_5355_4F4D_5BF9_5355_4F4D_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取单位对单位冷却键"]
local _____88C5_5907_51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却就绪"]
local _____8FDB_5165_88C5_5907_51B7_5374 = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_0["施加扩展控制"]
local function _____6267_884C_6267_6CD5_8005_5FBD_8BB0_6C89_9ED8(ctx)
    local key = _____53D6_5355_4F4D_5BF9_5355_4F4D_51B7_5374_952E(ctx.source, ctx.target, "执法者徽记")
    if not _____88C5_5907_51B7_5374_5C31_7EEA(key) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374(key, 8)
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
