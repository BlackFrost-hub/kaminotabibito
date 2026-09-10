--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
____exports["熔浆鱼王单位ID"] = "n06O"
____exports["熔浆鱼王单位类型ID"] = stringToFourCCSafe(____exports["熔浆鱼王单位ID"])
--- 技能壳 ID。
____exports["熔岩冲击技能ID"] = "AUQ1"
____exports["熔岩冲击技能类型ID"] = stringToFourCCSafe(____exports["熔岩冲击技能ID"])
____exports["熔渊新星技能ID"] = "AUW1"
____exports["熔渊新星技能类型ID"] = stringToFourCCSafe(____exports["熔渊新星技能ID"])
--- Q：朝目标地点喷吐熔岩（点目标）。先铺预警圈，延迟后爆炸。
____exports["熔岩冲击配置"] = {
    ["冷却秒"] = 12,
    ["攻击倍率"] = 2,
    ["范围"] = 320,
    ["施法距离"] = 700,
    ["预警秒"] = 1,
    ["爆炸特效"] = "Common\\Effect\\Form\\Explosion\\dustwave.mdx",
    ["爆炸特效持续秒"] = 1.2
}
--- W：以自身为中心炸开熔岩（无目标），惩罚贴脸。先预警后爆炸。
____exports["熔渊新星配置"] = {
    ["冷却秒"] = 20,
    ["攻击倍率"] = 1.5,
    ["范围"] = 380,
    ["预警秒"] = 0.8,
    ["爆炸特效"] = "Common\\Effect\\Form\\Explosion\\ShalltearRebirthBurst.mdx",
    ["爆炸特效持续秒"] = 1.2
}
return ____exports
