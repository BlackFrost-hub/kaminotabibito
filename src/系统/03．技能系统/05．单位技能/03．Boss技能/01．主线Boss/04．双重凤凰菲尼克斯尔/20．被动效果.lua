--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建菲尼克斯尔上下文"]
local _____83B7_53D6_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取菲尼克斯尔上下文"]
local _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8FD0_884C_65F6 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册菲尼克斯尔运行时"]
local ____05_FF0E_6C38_6052_51B0_6838_4E0E_5BFC_7BA1 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.05．永恒冰核与导管")
local _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6C38_6052_51B0_6838_4E0E_5BFC_7BA1 = ____05_FF0E_6C38_6052_51B0_6838_4E0E_5BFC_7BA1["初始化菲尼克斯尔永恒冰核与导管"]
local ____18_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.18．技能入口")
local _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_6280_80FD_7ED3_6784 = ____18_FF0E_6280_80FD_5165_53E3["注册菲尼克斯尔技能结构"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具")
local stringToFourCC = ____19_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5F53_524D_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["取最大生命"]
local ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.11．条件伤害修正")
local _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63 = ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63["创建条件伤害修正"]
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_0["注册Boss自动技能启动监听"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local _____83B7_53D6_5355_4F4DBuff_5C42_6570 = ____require_result_1["获取单位Buff层数"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____83F2_5C3C_514B_65AF_5C14_88AB_52A8_5DF2_6CE8_518C = false
local _____83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63_5DF2_6CE8_518C = false
local _____83F2_5C3C_514B_65AF_5C14_6838_5FC3_4E0E_8F6E_56DE_4FDD_62A4_5DF2_6CE8_518C = false
local function ____on_83F2_5C3C_514B_65AF_5C14Boss_542F_52A8(_____542F_52A8_4E0A_4E0B_6587)
    local context = _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(_____542F_52A8_4E0A_4E0B_6587["Boss单位"])
    if context ~= nil then
        _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6C38_6052_51B0_6838_4E0E_5BFC_7BA1(context)
    end
end
local function _____662F_83F2_5C3C_514B_65AF_5C14_5BFC_7BA1_7834_5C01_76EE_6807(damageContext)
    local ____temp_2
    if damageContext ~= nil then
        ____temp_2 = damageContext.target
    else
        ____temp_2 = nil
    end
    local target = ____temp_2
    return target ~= nil and target ~= 0 and GetUnitTypeId(target) == _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID
end
local function _____83F2_5C3C_514B_65AF_5C14_5BFC_7BA1_7834_5C01_627F_4F24_4FEE_6B63(damageContext)
    local target = damageContext.target
    local layers = _____83B7_53D6_5355_4F4DBuff_5C42_6570(target, _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["导管破封"])
    if layers <= 0 then
        return damageContext.currentDamage
    end
    return damageContext.currentDamage * (1 + layers * _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["每根导管承伤提高"])
end
local function _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63()
    if _____83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63_5DF2_6CE8_518C then
        return
    end
    _____83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63_5DF2_6CE8_518C = true
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "菲尼克斯尔导管破封承伤", ["优先级"] = 15, ["条件"] = _____662F_83F2_5C3C_514B_65AF_5C14_5BFC_7BA1_7834_5C01_76EE_6807, ["修正"] = _____83F2_5C3C_514B_65AF_5C14_5BFC_7BA1_7834_5C01_627F_4F24_4FEE_6B63})
end
local function _____662F_83F2_5C3C_514B_65AF_5C14Boss_6838_5FC3_66B4_9732_76EE_6807(damageContext)
    local ____temp_3
    if damageContext ~= nil then
        ____temp_3 = damageContext.target
    else
        ____temp_3 = nil
    end
    local target = ____temp_3
    local context = _____83B7_53D6_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(target)
    return context ~= nil and context["怨火核心暴露中"] == true
end
local function _____83F2_5C3C_514B_65AF_5C14_6838_5FC3_66B4_9732_627F_4F24_4FEE_6B63(damageContext)
    return damageContext.currentDamage * 3
end
local function _____662F_83F2_5C3C_514B_65AF_5C14Boss_8F6E_56DE_4FDD_62A4_76EE_6807(damageContext)
    local ____temp_4
    if damageContext ~= nil then
        ____temp_4 = damageContext.target
    else
        ____temp_4 = nil
    end
    local target = ____temp_4
    local context = _____83B7_53D6_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(target)
    return context ~= nil and target == context.Boss
end
local function _____83F2_5C3C_514B_65AF_5C14_8F6E_56DE_9501_8840_4FEE_6B63(damageContext)
    local target = damageContext.target
    local context = _____83B7_53D6_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(target)
    if context == nil then
        return damageContext.currentDamage
    end
    if context["当前形态"] == "永恒轮回" then
        return 0
    end
    local maxLife = _____53D6_6700_5927_751F_547D(target)
    local currentLife = _____53D6_5F53_524D_751F_547D(target)
    local thresholdLife = maxLife * _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["永恒轮回触发生命比例"]
    if currentLife <= thresholdLife then
        return 0
    end
    if currentLife - damageContext.currentDamage <= thresholdLife then
        return currentLife - thresholdLife
    end
    return damageContext.currentDamage
end
local function _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_6838_5FC3_4E0E_8F6E_56DE_4FDD_62A4()
    if _____83F2_5C3C_514B_65AF_5C14_6838_5FC3_4E0E_8F6E_56DE_4FDD_62A4_5DF2_6CE8_518C then
        return
    end
    _____83F2_5C3C_514B_65AF_5C14_6838_5FC3_4E0E_8F6E_56DE_4FDD_62A4_5DF2_6CE8_518C = true
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "菲尼克斯尔-怨火核心暴露承伤", ["优先级"] = 16, ["条件"] = _____662F_83F2_5C3C_514B_65AF_5C14Boss_6838_5FC3_66B4_9732_76EE_6807, ["修正"] = _____83F2_5C3C_514B_65AF_5C14_6838_5FC3_66B4_9732_627F_4F24_4FEE_6B63})
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "菲尼克斯尔-永恒轮回锁血", ["优先级"] = 90, ["条件"] = _____662F_83F2_5C3C_514B_65AF_5C14Boss_8F6E_56DE_4FDD_62A4_76EE_6807, ["修正"] = _____83F2_5C3C_514B_65AF_5C14_8F6E_56DE_9501_8840_4FEE_6B63})
end
____exports["注册菲尼克斯尔被动效果"] = function()
    if _____83F2_5C3C_514B_65AF_5C14_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____83F2_5C3C_514B_65AF_5C14_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8FD0_884C_65F6()
    _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_6280_80FD_7ED3_6784()
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63()
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_6838_5FC3_4E0E_8F6E_56DE_4FDD_62A4()
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({["名称"] = "菲尼克斯尔运行时上下文绑定", ["单位类型ID"] = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID, ["on启动"] = ____on_83F2_5C3C_514B_65AF_5C14Boss_542F_52A8})
end
____exports["注册菲尼克斯尔被动效果"]()
return ____exports
