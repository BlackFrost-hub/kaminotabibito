local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.00．公共")
local _____585E_62C9_516C_5171 = ____00_FF0E_516C_5171["塞拉公共"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯音效配置"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____585E_62C9_516C_5171_0 = _____585E_62C9_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____585E_62C9_516C_5171_0["巴尔扎罗斯单位技能配置"]
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____585E_62C9_516C_5171_0["巴尔扎罗斯技能数值配置"]
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____585E_62C9_516C_5171_0["播放巴尔扎罗斯台词"]
local registerManualBuff = ____585E_62C9_516C_5171_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____585E_62C9_516C_5171_0["移除单位指定Buff"]
local registerDamageModifier = ____585E_62C9_516C_5171_0.registerDamageModifier
local getServerTime = ____585E_62C9_516C_5171_0.getServerTime
local GetUnitX = ____585E_62C9_516C_5171_0.GetUnitX
local GetUnitY = ____585E_62C9_516C_5171_0.GetUnitY
local SetUnitAnimationByIndex = ____585E_62C9_516C_5171_0.SetUnitAnimationByIndex
local SetUnitTimeScale = ____585E_62C9_516C_5171_0.SetUnitTimeScale
local _____5355_4F4D_6709_6548 = ____585E_62C9_516C_5171_0["单位有效"]
local _____53D6_5355_4F4DID = ____585E_62C9_516C_5171_0["取单位ID"]
local _____585E_62C9_5F62_6001_8868 = ____585E_62C9_516C_5171_0["塞拉形态表"]
local _____96F6_5EA6_9886_57DF_51CF_4F24_5230_671FMs_8868 = ____585E_62C9_516C_5171_0["零度领域减伤到期Ms表"]
local _____585E_62C9_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
____exports["切换塞拉形态"] = function(context, next, _____64AD_653E_53F0_8BCD)
    local sera = context["塞拉"]
    if not _____5355_4F4D_6709_6548(sera) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["元素转换"]
    local seraId = _____53D6_5355_4F4DID(sera)
    context["塞拉当前形态"] = next
    _____585E_62C9_5F62_6001_8868[seraId] = next
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(sera, next == "火焰" and _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["塞拉冰霜形态"] or _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["塞拉火焰形态"])
    registerManualBuff(
        sera,
        next == "火焰" and _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["塞拉火焰形态"] or _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["塞拉冰霜形态"],
        config["周期秒"] + config["Buff持续补偿秒"],
        1,
        {sourceName = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["塞拉"]["名称"]}
    )
    SetUnitTimeScale(sera, config["动画速度"])
    SetUnitAnimationByIndex(sera, config["动画编号"])
    _____64AD_653EBoss_5750_6807_97F3_6548(
        next == "火焰" and _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["塞拉"]["冰转火"] or _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["塞拉"]["火转冰"],
        GetUnitX(sera),
        GetUnitY(sera),
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    if _____64AD_653E_53F0_8BCD then
        _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(context["Boss单位"], "元素转换")
    end
end
local function _____585E_62C9_4F24_5BB3_4FEE_6B63(context)
    local now = getServerTime()
    local attackerId = _____53D6_5355_4F4DID(context.attacker)
    if attackerId ~= 0 then
        local ____until = _____96F6_5EA6_9886_57DF_51CF_4F24_5230_671FMs_8868[attackerId] or 0
        if ____until > 0 and now <= ____until then
            return context.currentDamage * (1 - _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["绝对零度领域"]["造成伤害降低比例"])
        end
        if ____until > 0 and now > ____until then
            __TS__Delete(_____96F6_5EA6_9886_57DF_51CF_4F24_5230_671FMs_8868, attackerId)
        end
    end
    local targetId = _____53D6_5355_4F4DID(context.target)
    local ____temp_1
    if targetId ~= 0 then
        ____temp_1 = _____585E_62C9_5F62_6001_8868[targetId]
    else
        ____temp_1 = nil
    end
    local form = ____temp_1
    if form == "火焰" and context.isWaterDamage == true then
        return context.currentDamage * (1 + _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["元素转换"]["受到克制伤害提高"])
    end
    if form == "冰霜" and context.isFireDamage == true then
        return context.currentDamage * (1 + _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["元素转换"]["受到克制伤害提高"])
    end
    return context.currentDamage
end
____exports["确保塞拉伤害修正"] = function()
    if _____585E_62C9_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C then
        return
    end
    _____585E_62C9_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = true
    registerDamageModifier(_____585E_62C9_4F24_5BB3_4FEE_6B63, 65)
end
return ____exports
