--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.07．安斯艾尔.00．配置")
local _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安斯艾尔单位技能配置"]
local ____01_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.07．安斯艾尔.01．被动效果")
local _____6FC0_6D3B_5B89_65AF_827E_5C14_5723_5149_9644_9B54 = ____01_FF0E_88AB_52A8_6548_679C["激活安斯艾尔圣光附魔"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local function _____83B7_53D6Q_4E0A_4E0B_6587(unit)
    return {unit = unit}
end
local function _____64AD_653EQ_914D_7F6E_8868_73B0(unit)
    local cfg = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q
    if cfg["动作编号"] >= 0 then
        SetUnitTimeScale(unit, cfg["动作速度"])
        SetUnitAnimationByIndex(unit, cfg["动作编号"])
    end
    if cfg["全局音效键"] == "" then
        return
    end
    local sound = jglobals[cfg["全局音效键"]]
    if sound == nil or sound == 0 then
        return
    end
    jass.AttachSoundToUnit(sound, unit)
    jass.SetSoundVolume(sound, 127)
    jass.StartSound(sound)
end
local function _____91CA_653E_5723_5149_9644_9B54(_context, unit)
    _____64AD_653EQ_914D_7F6E_8868_73B0(unit)
    _____6FC0_6D3B_5B89_65AF_827E_5C14_5723_5149_9644_9B54(unit)
end
____exports["注册安斯艾尔Q"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "安斯艾尔-圣光附魔",
        ["单位类型ID"] = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
        ["技能ID"] = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6Q_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5723_5149_9644_9B54,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q["持续秒"]
    })
end
____exports["注册安斯艾尔Q"]()
return ____exports
