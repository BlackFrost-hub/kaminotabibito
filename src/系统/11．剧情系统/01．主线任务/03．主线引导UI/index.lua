--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4E3B_7EBF_5F15_5BFC_6846_67B6 = require("系统.11．剧情系统.01．主线任务.03．主线引导UI.02．主线引导框架")
local _____521B_5EFA_4E3B_7EBF_5F15_5BFC_5E27 = ____02_FF0E_4E3B_7EBF_5F15_5BFC_6846_67B6["创建主线引导帧"]
local _____521B_5EFA_4E3B_7EBF_5F15_5BFC_6309_94AE = ____02_FF0E_4E3B_7EBF_5F15_5BFC_6846_67B6["创建主线引导按钮"]
local ____03_FF0E_4E3B_7EBF_5F15_5BFC_6267_884C = require("系统.11．剧情系统.01．主线任务.03．主线引导UI.03．主线引导执行")
local ____on_4E3B_7EBF_5F15_5BFC_6309_94AE_70B9_51FB = ____03_FF0E_4E3B_7EBF_5F15_5BFC_6267_884C["on主线引导按钮点击"]
--- 初始化主线引导 UI
-- 创建 UI 帧并注册按钮点击回调（sync=true）
____exports["初始化主线引导UI"] = function()
    _____521B_5EFA_4E3B_7EBF_5F15_5BFC_5E27()
    _____521B_5EFA_4E3B_7EBF_5F15_5BFC_6309_94AE(____on_4E3B_7EBF_5F15_5BFC_6309_94AE_70B9_51FB)
end
return ____exports
