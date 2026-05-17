--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 吟唱条系统 - 常量定义
local jass = require("jass.common")
local japi = require("jass.japi")
local DzCreateFrame = japi.DzCreateFrame
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetAnimate = japi.DzFrameSetAnimate
local DzFrameSetAnimateOffset = japi.DzFrameSetAnimateOffset
local DzFrameShow = japi.DzFrameShow
local DzGetGameUI = japi.DzGetGameUI
____exports["模块名"] = "吟唱条"
____exports["吟唱条步进秒"] = 0.01
____exports["UI坐标X"] = 0.549
____exports["UI坐标Y"] = 0.2
____exports["锚点CENTER"] = 4
____exports["框架名_前景"] = "吟唱条前景"
____exports["框架名_背景"] = "吟唱条背景"
____exports["框架名_标题"] = "吟唱条标题"
____exports["框架名_进度"] = "吟唱条进度"
____exports["框架名_分隔符"] = "吟唱条分隔符"
____exports["框架名_时间"] = "吟唱条时间"
____exports["框架名_提示"] = "吟唱条提示"
____exports["默认标题文本"] = "吟唱中"
____exports["默认提示文本"] = "场地技能："
____exports["分隔符文本"] = "/"
____exports["默认颜色ID"] = 5
____exports["颜色ID到前景模型"] = {
    [1] = "UI\\CastBar\\UI_shengmingzhi_gb2.mdx",
    [2] = "UI\\CastBar\\UI_shengmingzhi_t1.mdx",
    [3] = "UI\\CastBar\\UI_shengmingzhi_o2.mdx",
    [4] = "UI\\CastBar\\UI_shengmingzhi_r2.mdx",
    [5] = "UI\\CastBar\\UI_shengmingzhi_p2.mdx",
    [6] = "UI\\CastBar\\UI_shengmingzhi_g2.mdx",
    [7] = "UI\\CastBar\\UI_shengmingzhi_b2.mdx"
}
____exports["颜色ID到背景模型"] = {
    [1] = "UI\\CastBar\\UI_shengmingzhi-beijing_gb2.mdx",
    [2] = "UI\\CastBar\\UI_shengmingzhi-beijing_t1.mdx",
    [3] = "UI\\CastBar\\UI_shengmingzhi-beijing_o2.mdx",
    [4] = "UI\\CastBar\\UI_shengmingzhi-beijing_r2.mdx",
    [5] = "UI\\CastBar\\UI_shengmingzhi-beijing_p2.mdx",
    [6] = "UI\\CastBar\\UI_shengmingzhi-beijing_g2.mdx",
    [7] = "UI\\CastBar\\UI_shengmingzhi-beijing_b2.mdx"
}
____exports["获取前景模型"] = function(_____989C_8272ID)
    return ____exports["颜色ID到前景模型"][_____989C_8272ID] or ____exports["颜色ID到前景模型"][____exports["默认颜色ID"]]
end
____exports["获取背景模型"] = function(_____989C_8272ID)
    return ____exports["颜色ID到背景模型"][_____989C_8272ID] or ____exports["颜色ID到背景模型"][____exports["默认颜色ID"]]
end
return ____exports
