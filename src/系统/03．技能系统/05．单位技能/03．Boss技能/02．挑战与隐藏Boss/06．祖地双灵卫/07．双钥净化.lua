--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____05_FF0E_7956_5730_53CC_7075_536B = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.05．祖地双灵卫")
local _____7956_5730_53CC_7075_536BBuffID = ____05_FF0E_7956_5730_53CC_7075_536B["祖地双灵卫BuffID"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local jass = require("jass.common")
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local function _____9500_6BC1_8282_70B9_7279_6548(node)
    if node["特效"] ~= nil and node["特效"] ~= 0 then
        DestroyEffect(node["特效"])
    end
    node["特效"] = nil
end
local function _____53D6_8282_70B9_8868_73B0_8DEF_5F84(node)
    local resources = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["双钥净化"]
    if node["阶段"] == "破壳" then
        return resources["节点污染外壳特效路径"]
    end
    if node["阶段"] == "校准" then
        return resources["节点校准特效路径"]
    end
    if node["阶段"] == "已净化" then
        return resources["节点净化完成特效路径"]
    end
    return ""
end
local function _____5237_65B0_8282_70B9_8868_73B0(node)
    if node["表现阶段"] == node["阶段"] then
        return
    end
    _____9500_6BC1_8282_70B9_7279_6548(node)
    node["表现阶段"] = node["阶段"]
    local path = _____53D6_8282_70B9_8868_73B0_8DEF_5F84(node)
    if path ~= "" then
        node["特效"] = AddSpecialEffect(path, node.X, node.Y)
    end
end
local function _____767B_8BB0_8282_70B9_7EDF_4E00_6E05_7406(context)
    if context["净化节点清理已登记"] then
        return
    end
    context["净化节点清理已登记"] = true
    local ____self_2 = context["清理"]
    ____self_2["登记清理"](
        ____self_2,
        "祖地双灵卫-P3净化节点",
        function()
            do
                local i = 0
                while i < #context["净化节点列表"] do
                    _____9500_6BC1_8282_70B9_7279_6548(context["净化节点列表"][i + 1])
                    i = i + 1
                end
            end
        end
    )
end
local function _____5F53_524D_8282_70B9(context)
    local index = context["当前净化节点序号"] - 1
    return index >= 0 and index < #context["净化节点列表"] and context["净化节点列表"][index + 1] or nil
end
____exports["推进祖地双灵卫下一个净化节点"] = function(context)
    if context["已净化节点数量"] >= _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化节点数量"] then
        context["当前净化节点序号"] = 0
        return
    end
    context["当前净化节点序号"] = context["已净化节点数量"] + 1
    local node = _____5F53_524D_8282_70B9(context)
    if node ~= nil and node["阶段"] ~= "已净化" then
        node["阶段"] = "破壳"
        node["校准截止Ms"] = 0
        node["重试允许Ms"] = getServerTime() + 900
        _____5237_65B0_8282_70B9_8868_73B0(node)
    end
end
____exports["更新祖地双灵卫双钥净化"] = function(context, now)
    if now == nil then
        now = getServerTime()
    end
    if context["战斗已结束"] or context["阶段"] ~= "P3双蚀共鸣" then
        return
    end
    _____767B_8BB0_8282_70B9_7EDF_4E00_6E05_7406(context)
    local node = _____5F53_524D_8282_70B9(context)
    if node == nil then
        return
    end
    if node["阶段"] == "校准" and node["校准截止Ms"] <= 0 then
        node["校准截止Ms"] = now + _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["校准阶段窗口秒"] * 1000
    end
    if node["阶段"] == "校准" and now >= node["校准截止Ms"] then
        node["阶段"] = "破壳"
        node["校准截止Ms"] = 0
        node["重试允许Ms"] = now + _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["失败重试冷却秒"] * 1000
    end
    if node["阶段"] == "已净化" and node["表现阶段"] ~= "已净化" then
        if context["已净化节点数量"] < node["序号"] then
            context["已净化节点数量"] = node["序号"]
        end
        if context["已净化节点数量"] > _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化节点数量"] then
            context["已净化节点数量"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化节点数量"]
        end
        context["P3共鸣层数"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化节点数量"] - context["已净化节点数量"]
        if context["P3共鸣层数"] < 0 then
            context["P3共鸣层数"] = 0
        end
        context["净化易伤到Ms"] = now + _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化后易伤秒"] * 1000
        local units = {context["赤誓灵卫单位"], context["苍影灵卫单位"]}
        do
            local i = 0
            while i < #units do
                if context["P3共鸣层数"] > 0 then
                    registerManualBuff(
                        units[i + 1],
                        _____7956_5730_53CC_7075_536BBuffID["双蚀共鸣"],
                        3600,
                        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["P3每层共鸣减伤比例"] * 100,
                        {stack = context["P3共鸣层数"], sourceName = "祖地双灵卫-双蚀共鸣"}
                    )
                else
                    _____79FB_9664_5355_4F4D_6307_5B9ABuff(units[i + 1], _____7956_5730_53CC_7075_536BBuffID["双蚀共鸣"])
                end
                registerManualBuff(
                    units[i + 1],
                    _____7956_5730_53CC_7075_536BBuffID["净化反冲"],
                    _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化后易伤秒"],
                    _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化后易伤比例"] * 100,
                    {sourceName = "祖地双灵卫-净化反冲"}
                )
                i = i + 1
            end
        end
        context["封门误判待触发"] = true
        context["大型机制忙碌到Ms"] = now + 800
    end
    _____5237_65B0_8282_70B9_8868_73B0(node)
end
____exports["双钥净化机制状态"] = {
    ["类型"] = "P3联合核心机制",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "先引导裂誓战躯踏碎节点外壳，再让无面祷影的灵魂潮穿过节点完成校准。",
    ["实现要求"] = "每次只激活一个节点，破壳与校准使用不同颜色和时间窗；失败后允许重试，不能永久锁死。"
}
return ____exports
