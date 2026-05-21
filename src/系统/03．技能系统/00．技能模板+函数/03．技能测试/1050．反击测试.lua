--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.13．反击.index")
local _____6CE8_518C_53CD_51FB = ____index["注册反击"]
local _____79FB_9664_53CD_51FB = ____index["移除反击"]
local _____53CD_51FB_7C7B_578B = ____index["反击类型"]
local _____53CD_51FB_4F24_5BB3_7C7B_578B = ____index["反击伤害类型"]
--- 反击系统测试
-- 
-- 输入 1050：给大法师注册反击效果，所有伤害他的敌人被反击30点伤害
-- 输入 1059：清理反击效果
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_1.debugLogForce
local function _____83B7_53D6_5927_6CD5_5E08()
    return require("jass.globals").gg_unit_Hamg_0002
end
local function ____on_804A_59291050_547D_4EE4()
    local _____5927_6CD5_5E08 = _____83B7_53D6_5927_6CD5_5E08()
    if not _____5927_6CD5_5E08 then
        debugLogForce("反击测试", "未找到大法师")
        return
    end
    _____6CE8_518C_53CD_51FB({
        ["反击来源"] = _____5927_6CD5_5E08,
        ["反击类型"] = _____53CD_51FB_7C7B_578B["任意伤害"],
        ["伤害计算方式"] = _____53CD_51FB_4F24_5BB3_7C7B_578B["固定值"],
        ["伤害值"] = 30,
        ["距离条件"] = {},
        ["冷却时间"] = 0,
        ["是否AOE"] = false,
        ["只反击来源"] = true
    })
    debugLogForce("反击测试", "大法师已获得反击能力，任何伤害他的敌人将被反击30点伤害")
end
local function ____on_804A_59291059_547D_4EE4()
    local _____5927_6CD5_5E08 = _____83B7_53D6_5927_6CD5_5E08()
    if _____5927_6CD5_5E08 then
        _____79FB_9664_53CD_51FB(_____5927_6CD5_5E08)
    end
    debugLogForce("反击测试", "已移除大法师反击效果")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("1050", ____on_804A_59291050_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C("1059", ____on_804A_59291059_547D_4EE4)
debugLogForce("反击测试", "已注册命令: 1050-注册反击, 1059-清理")
return ____exports
