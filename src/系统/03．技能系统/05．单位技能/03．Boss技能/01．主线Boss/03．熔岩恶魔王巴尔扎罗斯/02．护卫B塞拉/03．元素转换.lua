local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.00．公共")
local _____585E_62C9_516C_5171 = ____00_FF0E_516C_5171["塞拉公共"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯音效配置"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.11．条件伤害修正")
local _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63 = ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63["创建条件伤害修正"]
local ____585E_62C9_516C_5171_0 = _____585E_62C9_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____585E_62C9_516C_5171_0["巴尔扎罗斯单位技能配置"]
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____585E_62C9_516C_5171_0["巴尔扎罗斯技能数值配置"]
local _____64AD_653E_585E_62C9_53F0_8BCD = ____585E_62C9_516C_5171_0["播放塞拉台词"]
local registerManualBuff = ____585E_62C9_516C_5171_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____585E_62C9_516C_5171_0["移除单位指定Buff"]
local getServerTime = ____585E_62C9_516C_5171_0.getServerTime
local GetUnitX = ____585E_62C9_516C_5171_0.GetUnitX
local GetUnitY = ____585E_62C9_516C_5171_0.GetUnitY
local _____5355_4F4D_6709_6548 = ____585E_62C9_516C_5171_0["单位有效"]
local _____53D6_5355_4F4DID = ____585E_62C9_516C_5171_0["取单位ID"]
local _____585E_62C9_5F62_6001_8868 = ____585E_62C9_516C_5171_0["塞拉形态表"]
local _____96F6_5EA6_9886_57DF_51CF_4F24_5230_671FMs_8868 = ____585E_62C9_516C_5171_0["零度领域减伤到期Ms表"]
local japi = require("jass.japi")
local DzSetUnitMissileModel = japi.DzSetUnitMissileModel
local DzSetUnitMissileArc = japi.DzSetUnitMissileArc
local DzSetUnitMissileSpeed = japi.DzSetUnitMissileSpeed
local _____585E_62C9_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local _____585E_62C9_5F62_6001_5F39_9053_6A21_578BJAPI_4E34_65F6_7981_7528 = false
local _____585E_62C9_5F62_6001_5F39_9053_5F27_5EA6JAPI_4E34_65F6_7981_7528 = false
local _____585E_62C9_5F62_6001_5F39_9053_901F_5EA6JAPI_4E34_65F6_7981_7528 = false
local function _____5E94_7528_585E_62C9_5F62_6001_5F39_9053(sera, next)
    local config = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["塞拉"]
    local model = next == "火焰" and config["火焰普攻弹道模型"] or config["默认普攻弹道模型"]
    if not _____585E_62C9_5F62_6001_5F39_9053_6A21_578BJAPI_4E34_65F6_7981_7528 and DzSetUnitMissileModel ~= nil then
        DzSetUnitMissileModel(sera, model)
    end
    if not _____585E_62C9_5F62_6001_5F39_9053_5F27_5EA6JAPI_4E34_65F6_7981_7528 and DzSetUnitMissileArc ~= nil then
        DzSetUnitMissileArc(sera, config["普攻弹道弧度"])
    end
    if not _____585E_62C9_5F62_6001_5F39_9053_901F_5EA6JAPI_4E34_65F6_7981_7528 and DzSetUnitMissileSpeed ~= nil then
        DzSetUnitMissileSpeed(sera, config["普攻弹道速度"])
    end
end
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
    _____5E94_7528_585E_62C9_5F62_6001_5F39_9053(sera, next)
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = sera,
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["持续秒"] = config["动画播放秒"],
        ["恢复动画编号"] = config["恢复动画编号"]
    })
    _____64AD_653EBoss_5750_6807_97F3_6548(
        next == "火焰" and _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["塞拉"]["冰转火"] or _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["塞拉"]["火转冰"],
        GetUnitX(sera),
        GetUnitY(sera),
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    if _____64AD_653E_53F0_8BCD then
        _____64AD_653E_585E_62C9_53F0_8BCD(sera, next == "火焰" and "元素转换火焰" or "元素转换冰霜")
    end
end
local function _____6EE1_8DB3_585E_62C9_4F24_5BB3_4FEE_6B63_6761_4EF6(context)
    local attackerId = _____53D6_5355_4F4DID(context.attacker)
    if attackerId ~= 0 and (_____96F6_5EA6_9886_57DF_51CF_4F24_5230_671FMs_8868[attackerId] or 0) > 0 then
        return true
    end
    local targetId = _____53D6_5355_4F4DID(context.target)
    local ____temp_1
    if targetId ~= 0 then
        ____temp_1 = _____585E_62C9_5F62_6001_8868[targetId]
    else
        ____temp_1 = nil
    end
    local form = ____temp_1
    return form == "火焰" and context.isWaterDamage == true or form == "冰霜" and context.isFireDamage == true
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
    local ____temp_2
    if targetId ~= 0 then
        ____temp_2 = _____585E_62C9_5F62_6001_8868[targetId]
    else
        ____temp_2 = nil
    end
    local form = ____temp_2
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
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "塞拉元素转换伤害修正", ["优先级"] = 65, ["条件"] = _____6EE1_8DB3_585E_62C9_4F24_5BB3_4FEE_6B63_6761_4EF6, ["修正"] = _____585E_62C9_4F24_5BB3_4FEE_6B63})
end
return ____exports
