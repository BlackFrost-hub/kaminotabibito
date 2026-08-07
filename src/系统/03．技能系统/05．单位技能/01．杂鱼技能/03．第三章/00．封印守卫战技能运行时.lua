--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____6E05_7406_5C01_5370_5B88_536B_6218_654C_4EBA_673A_5236, removePeriodicCallback, unregisterDamageModifier, _____8FD0_884C_65F6_5468_671FID, _____4F24_5BB3_4FEE_6B63_5668ID, _____8FD0_884C_65F6_542F_52A8
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____521B_5EFA_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["创建封印守卫战敌人记录"]
local _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID = ____01_FF0E_5171_4EAB["封印守卫战第三章敌人单位ID"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____6E05_7A7A_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["清空封印守卫战敌人记录"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人列表"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____79FB_9664_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_5F15_7528 = ____01_FF0E_5171_4EAB["移除封印守卫战敌人记录引用"]
local _____8BBE_7F6E_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_6280_80FD_73AF_5883 = ____01_FF0E_5171_4EAB["设置封印守卫战第三章技能环境"]
local ____01_FF0E_7F1A_9B42_65A9 = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.02．失控英灵.01．缚魂斩")
local _____5237_65B0_5931_63A7_82F1_7075AI = ____01_FF0E_7F1A_9B42_65A9["刷新失控英灵AI"]
local _____5904_7406_5931_63A7_82F1_7075_666E_653B_547D_4E2D = ____01_FF0E_7F1A_9B42_65A9["处理失控英灵普攻命中"]
local ____01_FF0E_593A_7075_4EEA_5F0F = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.03．夺灵祭司.01．夺灵仪式")
local _____5237_65B0_593A_7075_796D_53F8AI = ____01_FF0E_593A_7075_4EEA_5F0F["刷新夺灵祭司AI"]
local _____6E05_7406_593A_7075_796D_53F8_673A_5236 = ____01_FF0E_593A_7075_4EEA_5F0F["清理夺灵祭司机制"]
local ____01_FF0E_951A_8680_81EA_7206 = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.04．锚蚀兽.01．锚蚀自爆")
local _____5237_65B0_951A_8680_517DAI = ____01_FF0E_951A_8680_81EA_7206["刷新锚蚀兽AI"]
local _____6E05_7406_951A_8680_517D_673A_5236 = ____01_FF0E_951A_8680_81EA_7206["清理锚蚀兽机制"]
local ____01_FF0E_65AD_8A93_5C04_730E = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.05．断誓猎手.01．断誓射猎")
local _____5237_65B0_65AD_8A93_730E_624BAI = ____01_FF0E_65AD_8A93_5C04_730E["刷新断誓猎手AI"]
local _____5237_65B0_65AD_8A93_730E_624B_6838_5FC3_538B_5236 = ____01_FF0E_65AD_8A93_5C04_730E["刷新断誓猎手核心压制"]
local _____4FEE_6B63_65AD_8A93_730E_624B_6838_5FC3_666E_653B = ____01_FF0E_65AD_8A93_5C04_730E["修正断誓猎手核心普攻"]
local _____6E05_7406_65AD_8A93_730E_624B_5168_5C40_673A_5236 = ____01_FF0E_65AD_8A93_5C04_730E["清理断誓猎手全局机制"]
local ____01_FF0E_6697_5F71_7D22_654C = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.01．黑暗残响.01．暗影索敌")
local _____5237_65B0_9ED1_6697_6B8B_54CDAI = ____01_FF0E_6697_5F71_7D22_654C["刷新黑暗残响AI"]
local _____6E05_7406_5168_90E8_9ED1_6697_6B8B_54CD_5F39_5E55 = ____01_FF0E_6697_5F71_7D22_654C["清理全部黑暗残响弹幕"]
local _____6E05_7406_9ED1_6697_6B8B_54CD_673A_5236 = ____01_FF0E_6697_5F71_7D22_654C["清理黑暗残响机制"]
local ____01_FF0E_88C2_8A93_58C1_5792 = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.02．裂誓重卫.01．裂誓壁垒")
local _____521D_59CB_5316_88C2_8A93_91CD_536B_673A_5236 = ____01_FF0E_88C2_8A93_58C1_5792["初始化裂誓重卫机制"]
local _____4FEE_6B63_88C2_8A93_91CD_536B_51CF_4F24 = ____01_FF0E_88C2_8A93_58C1_5792["修正裂誓重卫减伤"]
local _____5237_65B0_88C2_8A93_91CD_536BAI = ____01_FF0E_88C2_8A93_58C1_5792["刷新裂誓重卫AI"]
local _____6E05_7406_88C2_8A93_91CD_536B_673A_5236 = ____01_FF0E_88C2_8A93_58C1_5792["清理裂誓重卫机制"]
local ____01_FF0E_5931_5F8B_53F7_4EE4 = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.03．失律号令者.01．失律号令")
local _____4FEE_6B63_5931_5F8B_53F7_4EE4_51CF_4F24 = ____01_FF0E_5931_5F8B_53F7_4EE4["修正失律号令减伤"]
local _____5237_65B0_5168_90E8_53F7_4EE4_5F3A_5316 = ____01_FF0E_5931_5F8B_53F7_4EE4["刷新全部号令强化"]
local _____5237_65B0_5931_5F8B_53F7_4EE4_8005AI = ____01_FF0E_5931_5F8B_53F7_4EE4["刷新失律号令者AI"]
local _____6E05_7406_5168_90E8_5931_5F8B_53F7_4EE4_5F3A_5316 = ____01_FF0E_5931_5F8B_53F7_4EE4["清理全部失律号令强化"]
local _____6E05_7406_5931_5F8B_53F7_4EE4_8BB0_5F55 = ____01_FF0E_5931_5F8B_53F7_4EE4["清理失律号令记录"]
local ____01_FF0E_6F6E_5203_7A81_88AD = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.06．潮蚀巡鳞者.01．潮刃突袭")
local _____5237_65B0_6F6E_8680_5DE1_9CDE_8005AI = ____01_FF0E_6F6E_5203_7A81_88AD["刷新潮蚀巡鳞者AI"]
local _____6E05_7406_6F6E_8680_5DE1_9CDE_8005_673A_5236 = ____01_FF0E_6F6E_5203_7A81_88AD["清理潮蚀巡鳞者机制"]
local ____01_FF0E_788E_7901_6295_63B7 = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.04．碎礁投石手.01．碎礁投掷")
local _____5237_65B0_788E_7901_6295_77F3_624BAI = ____01_FF0E_788E_7901_6295_63B7["刷新碎礁投石手AI"]
local _____6E05_7406_788E_7901_6295_77F3_624B_673A_5236 = ____01_FF0E_788E_7901_6295_63B7["清理碎礁投石手机制"]
local ____01_FF0E_7075_6F6E_7977_5370 = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.05．灵潮祭司.01．灵潮祷印")
local _____5237_65B0_7075_6F6E_796D_53F8AI = ____01_FF0E_7075_6F6E_7977_5370["刷新灵潮祭司AI"]
local _____4FEE_6B63_6F6E_8680_62A4_6301_51CF_4F24 = ____01_FF0E_7075_6F6E_7977_5370["修正潮蚀护持减伤"]
local _____6E05_7406_7075_6F6E_796D_53F8_673A_5236 = ____01_FF0E_7075_6F6E_7977_5370["清理灵潮祭司机制"]
local ____01_FF0E_91D1_9CDE_51B2_9635 = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.06．金鳞执刑官.01．金鳞冲阵")
local _____5237_65B0_91D1_9CDE_6267_5211_5B98AI = ____01_FF0E_91D1_9CDE_51B2_9635["刷新金鳞执刑官AI"]
local _____4FEE_6B63_91CD_9CDE_62A4_4F53_51CF_4F24 = ____01_FF0E_91D1_9CDE_51B2_9635["修正重鳞护体减伤"]
local _____6E05_7406_91D1_9CDE_6267_5211_5B98_673A_5236 = ____01_FF0E_91D1_9CDE_51B2_9635["清理金鳞执刑官机制"]
local ____01_FF0E_6DF1_6E0A_56DE_6F6E = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.07．深渊鳞将.01．深渊回潮")
local _____5237_65B0_6DF1_6E0A_9CDE_5C06AI = ____01_FF0E_6DF1_6E0A_56DE_6F6E["刷新深渊鳞将AI"]
local _____6E05_7406_6DF1_6E0A_9CDE_5C06_673A_5236 = ____01_FF0E_6DF1_6E0A_56DE_6F6E["清理深渊鳞将机制"]
function _____6E05_7406_5C01_5370_5B88_536B_6218_654C_4EBA_673A_5236(record)
    if record["类型"] == "夺灵祭司" then
        _____6E05_7406_593A_7075_796D_53F8_673A_5236(record)
    elseif record["类型"] == "锚蚀兽" then
        _____6E05_7406_951A_8680_517D_673A_5236(record)
    elseif record["类型"] == "黑暗残响" then
        _____6E05_7406_9ED1_6697_6B8B_54CD_673A_5236(record)
    elseif record["类型"] == "裂誓重卫" then
        _____6E05_7406_88C2_8A93_91CD_536B_673A_5236(record)
    elseif record["类型"] == "失律号令者" then
        _____6E05_7406_5931_5F8B_53F7_4EE4_8BB0_5F55(record)
    elseif record["类型"] == "潮蚀巡鳞者" then
        _____6E05_7406_6F6E_8680_5DE1_9CDE_8005_673A_5236(record)
    elseif record["类型"] == "碎礁投石手" then
        _____6E05_7406_788E_7901_6295_77F3_624B_673A_5236(record)
    elseif record["类型"] == "灵潮祭司" then
        _____6E05_7406_7075_6F6E_796D_53F8_673A_5236(record)
    elseif record["类型"] == "金鳞执刑官" then
        _____6E05_7406_91D1_9CDE_6267_5211_5B98_673A_5236(record)
    elseif record["类型"] == "深渊鳞将" then
        _____6E05_7406_6DF1_6E0A_9CDE_5C06_673A_5236(record)
    elseif record["号令属性已施加"] then
        _____6E05_7406_5931_5F8B_53F7_4EE4_8BB0_5F55(record)
    end
end
____exports["停止封印守卫战第三章敌人技能"] = function()
    _____8FD0_884C_65F6_542F_52A8 = false
    if _____8FD0_884C_65F6_5468_671FID ~= 0 then
        removePeriodicCallback(_____8FD0_884C_65F6_5468_671FID)
    end
    _____8FD0_884C_65F6_5468_671FID = 0
    local list = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868()
    while #list > 0 do
        local record = list[#list]
        _____6E05_7406_5C01_5370_5B88_536B_6218_654C_4EBA_673A_5236(record)
        _____79FB_9664_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_5F15_7528(record)
    end
    _____6E05_7406_5168_90E8_9ED1_6697_6B8B_54CD_5F39_5E55()
    _____6E05_7406_5168_90E8_5931_5F8B_53F7_4EE4_5F3A_5316()
    _____6E05_7406_65AD_8A93_730E_624B_5168_5C40_673A_5236()
    _____6E05_7A7A_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55()
    _____8BBE_7F6E_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_6280_80FD_73AF_5883(nil)
    if _____4F24_5BB3_4FEE_6B63_5668ID ~= 0 then
        unregisterDamageModifier(_____4F24_5BB3_4FEE_6B63_5668ID)
    end
    _____4F24_5BB3_4FEE_6B63_5668ID = 0
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
unregisterDamageModifier = ____require_result_2.unregisterDamageModifier
local GetUnitTypeId = jass.GetUnitTypeId
local _____6280_80FD_8FD0_884C_65F6_5237_65B0_6BEB_79D2 = 100
local _____4F24_5BB3_4FEE_6B63_4F18_5148_7EA7 = 35
_____8FD0_884C_65F6_5468_671FID = 0
_____4F24_5BB3_4FEE_6B63_5668ID = 0
local _____5DF2_6CE8_518C_6700_7EC8_4F24_5BB3_76D1_542C = false
_____8FD0_884C_65F6_542F_52A8 = false
local function _____89E3_6790_5C01_5370_5B88_536B_6218_654C_4EBA_7C7B_578B(unit)
    local typeId = GetUnitTypeId(unit)
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["失控英灵"] then
        return "失控英灵"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["夺灵祭司"] then
        return "夺灵祭司"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["锚蚀兽"] then
        return "锚蚀兽"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["断誓猎手"] then
        return "断誓猎手"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["黑暗残响"] then
        return "黑暗残响"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["裂誓重卫"] then
        return "裂誓重卫"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["失律号令者"] then
        return "失律号令者"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["潮蚀巡鳞者"] then
        return "潮蚀巡鳞者"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["碎礁投石手"] then
        return "碎礁投石手"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["灵潮祭司"] then
        return "灵潮祭司"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["金鳞执刑官"] then
        return "金鳞执刑官"
    end
    if typeId == _____5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_5355_4F4DID["深渊鳞将"] then
        return "深渊鳞将"
    end
    return nil
end
local function _____521D_59CB_5316_5C01_5370_5B88_536B_6218_654C_4EBA_673A_5236(record, _____5F53_524D_6BEB_79D2)
    if record["类型"] == "黑暗残响" then
        record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + 1000
    elseif record["类型"] == "裂誓重卫" then
        record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + 1000
        _____521D_59CB_5316_88C2_8A93_91CD_536B_673A_5236(record)
    elseif record["类型"] == "失律号令者" then
        record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + 1500
    elseif record["类型"] == "潮蚀巡鳞者" then
        record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + 800
    elseif record["类型"] == "碎礁投石手" then
        record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + 1200
    elseif record["类型"] == "灵潮祭司" then
        record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + 1200
    elseif record["类型"] == "金鳞执刑官" then
        record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + 1000
    elseif record["类型"] == "深渊鳞将" then
        record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + 1400
    end
end
local function _____5237_65B0_5355_4E2A_5C01_5370_5B88_536B_6218_654C_4EBA(record, _____5F53_524D_6BEB_79D2)
    if record["类型"] == "失控英灵" then
        _____5237_65B0_5931_63A7_82F1_7075AI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "夺灵祭司" then
        _____5237_65B0_593A_7075_796D_53F8AI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "锚蚀兽" then
        _____5237_65B0_951A_8680_517DAI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "断誓猎手" then
        _____5237_65B0_65AD_8A93_730E_624BAI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "黑暗残响" then
        _____5237_65B0_9ED1_6697_6B8B_54CDAI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "裂誓重卫" then
        _____5237_65B0_88C2_8A93_91CD_536BAI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "失律号令者" then
        _____5237_65B0_5931_5F8B_53F7_4EE4_8005AI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "潮蚀巡鳞者" then
        _____5237_65B0_6F6E_8680_5DE1_9CDE_8005AI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "碎礁投石手" then
        _____5237_65B0_788E_7901_6295_77F3_624BAI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "灵潮祭司" then
        _____5237_65B0_7075_6F6E_796D_53F8AI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "金鳞执刑官" then
        _____5237_65B0_91D1_9CDE_6267_5211_5B98AI(record, _____5F53_524D_6BEB_79D2)
    elseif record["类型"] == "深渊鳞将" then
        _____5237_65B0_6DF1_6E0A_9CDE_5C06AI(record, _____5F53_524D_6BEB_79D2)
    end
end
local function ____on_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_6280_80FDTick()
    if not _____8FD0_884C_65F6_542F_52A8 then
        return
    end
    local now = getServerTime()
    local list = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868()
    local index = 0
    while index < #list do
        do
            local record = list[index + 1]
            if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
                _____6E05_7406_5C01_5370_5B88_536B_6218_654C_4EBA_673A_5236(record)
                _____79FB_9664_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_5F15_7528(record)
                goto __continue51
            end
            _____5237_65B0_5355_4E2A_5C01_5370_5B88_536B_6218_654C_4EBA(record, now)
            index = index + 1
        end
        ::__continue51::
    end
    _____5237_65B0_65AD_8A93_730E_624B_6838_5FC3_538B_5236(now)
    _____5237_65B0_5168_90E8_53F7_4EE4_5F3A_5316(now)
end
local function ____on_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not _____8FD0_884C_65F6_542F_52A8 then
        return
    end
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(attacker)
    if record == nil then
        return
    end
    if record["类型"] == "失控英灵" then
        _____5904_7406_5931_63A7_82F1_7075_666E_653B_547D_4E2D(
            record,
            target,
            applied,
            snapshot,
            getServerTime()
        )
    end
end
local function ____on_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_4F24_5BB3_4FEE_6B63(context)
    if not _____8FD0_884C_65F6_542F_52A8 or context == nil then
        local ____opt_result_5
        if context ~= nil then
            ____opt_result_5 = context.currentDamage
        end
        local ____opt_result_5_6 = ____opt_result_5
        if ____opt_result_5_6 == nil then
            ____opt_result_5_6 = 0
        end
        return ____opt_result_5_6
    end
    local damage = context.currentDamage
    local attackerRecord = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(context.attacker)
    if (attackerRecord and attackerRecord["类型"]) == "断誓猎手" then
        context.currentDamage = damage
        damage = _____4FEE_6B63_65AD_8A93_730E_624B_6838_5FC3_666E_653B(
            attackerRecord,
            context,
            getServerTime()
        )
    end
    context.currentDamage = damage
    damage = _____4FEE_6B63_88C2_8A93_91CD_536B_51CF_4F24(context)
    context.currentDamage = damage
    damage = _____4FEE_6B63_5931_5F8B_53F7_4EE4_51CF_4F24(context)
    context.currentDamage = damage
    damage = _____4FEE_6B63_6F6E_8680_62A4_6301_51CF_4F24(context)
    context.currentDamage = damage
    damage = _____4FEE_6B63_91CD_9CDE_62A4_4F53_51CF_4F24(context)
    return damage
end
local function _____786E_4FDD_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_4F24_5BB3_5165_53E3()
    if not _____5DF2_6CE8_518C_6700_7EC8_4F24_5BB3_76D1_542C then
        registerAppliedFinalDamageListener(____on_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_6700_7EC8_4F24_5BB3)
        _____5DF2_6CE8_518C_6700_7EC8_4F24_5BB3_76D1_542C = true
    end
    if _____4F24_5BB3_4FEE_6B63_5668ID == 0 then
        _____4F24_5BB3_4FEE_6B63_5668ID = registerDamageModifier(____on_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_4F24_5BB3_4FEE_6B63, _____4F24_5BB3_4FEE_6B63_4F18_5148_7EA7)
    end
end
____exports["启动封印守卫战第三章敌人技能"] = function(_____73AF_5883)
    if _____73AF_5883 == nil then
        return false
    end
    ____exports["停止封印守卫战第三章敌人技能"]()
    _____8BBE_7F6E_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_6280_80FD_73AF_5883(_____73AF_5883)
    _____8FD0_884C_65F6_542F_52A8 = true
    _____786E_4FDD_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_4F24_5BB3_5165_53E3()
    _____8FD0_884C_65F6_5468_671FID = addPeriodicCallback(_____6280_80FD_8FD0_884C_65F6_5237_65B0_6BEB_79D2, ____on_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_6280_80FDTick)
    return _____8FD0_884C_65F6_5468_671FID > 0
end
____exports["登记封印守卫战第三章敌人"] = function(unit)
    if not _____8FD0_884C_65F6_542F_52A8 or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    local ____type = _____89E3_6790_5C01_5370_5B88_536B_6218_654C_4EBA_7C7B_578B(unit)
    if ____type == nil then
        return false
    end
    local record = _____521B_5EFA_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(
        unit,
        ____type,
        getServerTime()
    )
    if record == nil then
        return false
    end
    _____521D_59CB_5316_5C01_5370_5B88_536B_6218_654C_4EBA_673A_5236(
        record,
        getServerTime()
    )
    return true
end
____exports["注销封印守卫战第三章敌人"] = function(unit)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil then
        return
    end
    _____6E05_7406_5C01_5370_5B88_536B_6218_654C_4EBA_673A_5236(record)
    _____79FB_9664_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_5F15_7528(record)
end
____exports["令封印守卫战敌人技能立即就绪"] = function(unit)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil then
        return false
    end
    record["下次技能毫秒"] = 0
    record["下次AI毫秒"] = 0
    return true
end
____exports["读取封印守卫战第三章敌人运行记录"] = function(unit)
    return _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
end
return ____exports
