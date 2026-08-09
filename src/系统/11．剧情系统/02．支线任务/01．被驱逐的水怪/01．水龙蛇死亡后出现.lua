--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5165_53E3_914D_7F6E = require("系统.11．剧情系统.02．支线任务.01．被驱逐的水怪.00．入口配置")
local _____88AB_9A71_9010_7684_6C34_602A_5165_53E3_914D_7F6E = ____00_FF0E_5165_53E3_914D_7F6E["被驱逐的水怪入口配置"]
local _____88AB_9A71_9010_7684_6C34_602ANPC_914D_7F6E_5217_8868 = ____00_FF0E_5165_53E3_914D_7F6E["被驱逐的水怪NPC配置列表"]
local _____88AB_9A71_9010_7684_6C34_602A_4EFB_52A1_914D_7F6E_5217_8868 = ____00_FF0E_5165_53E3_914D_7F6E["被驱逐的水怪任务配置列表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
local _____6309_4EFB_52A1ID_521B_5EFANPC = ____require_result_2["按任务ID创建NPC"]
local _____6309_4EFB_52A1ID_67E5_627E_5DF2_521B_5EFANPC = ____require_result_2["按任务ID查找已创建NPC"]
local ____require_result_3 = require("系统.11．剧情系统.02．支线任务.00A．动态支线注册")
local _____6CE8_518C_52A8_6001_652F_7EBF_914D_7F6E = ____require_result_3["注册动态支线配置"]
local GetUnitTypeId = jass.GetUnitTypeId
local _____6C34_9F99_86C7_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____88AB_9A71_9010_7684_6C34_602A_5165_53E3_914D_7F6E["前置Boss单位ID"])
local _____5DF2_6CE8_518C_6C34_9F99_86C7_6B7B_4EA1_5165_53E3 = false
local function ____on_6C34_9F99_86C7_6B7B_4EA1(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if GetUnitTypeId(dyingUnit) ~= _____6C34_9F99_86C7_5355_4F4D_7C7B_578BID then
        return
    end
    if _____6309_4EFB_52A1ID_67E5_627E_5DF2_521B_5EFANPC(_____88AB_9A71_9010_7684_6C34_602A_5165_53E3_914D_7F6E["任务ID"]) ~= nil then
        return
    end
    if not _____6CE8_518C_52A8_6001_652F_7EBF_914D_7F6E(_____88AB_9A71_9010_7684_6C34_602A_4EFB_52A1_914D_7F6E_5217_8868[1], _____88AB_9A71_9010_7684_6C34_602ANPC_914D_7F6E_5217_8868[1]) then
        return
    end
    _____6309_4EFB_52A1ID_521B_5EFANPC(_____88AB_9A71_9010_7684_6C34_602A_5165_53E3_914D_7F6E["任务ID"])
end
____exports["注册水龙蛇死亡后出现沃利尔斯"] = function()
    if _____5DF2_6CE8_518C_6C34_9F99_86C7_6B7B_4EA1_5165_53E3 then
        return
    end
    _____5DF2_6CE8_518C_6C34_9F99_86C7_6B7B_4EA1_5165_53E3 = true
    registerDeathListener(____on_6C34_9F99_86C7_6B7B_4EA1)
end
return ____exports
