--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.00．配置")
local _____585E_62C9_65AF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞拉斯技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.08．对外接口")
local _____8C03_67E5Boss_5F31_70B9 = ____require_result_0["调查Boss弱点"]
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local function _____64AD_653E_5168_5C40_97F3_6548(unit, soundKey)
    local soundHandle = jglobals[soundKey]
    if unit == nil or unit == 0 or soundHandle == nil or soundHandle == 0 then
        return
    end
    jass.AttachSoundToUnit(soundHandle, unit)
    jass.SetSoundVolume(soundHandle, 127)
    jass.StartSound(soundHandle)
end
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetOwningPlayer = jass.GetOwningPlayer
local GetLocalPlayer = jass.GetLocalPlayer
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____914D_7F6E = _____585E_62C9_65AF_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local function _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587(unit)
    if unit == nil or unit == 0 then
        return nil
    end
    return {["施法者"] = unit}
end
local function _____672C_5730_63D0_793A_65BD_6CD5_8005(caster, _____6587_672C)
    local owner = GetOwningPlayer(caster)
    if owner == nil or owner == 0 then
        return
    end
    if GetLocalPlayer() == owner then
        DisplayTimedTextToPlayer(
            owner,
            0,
            0,
            _____914D_7F6E.D["提示持续秒"],
            _____6587_672C
        )
    end
end
local function _____91CA_653ED_8C03_67E5_5F31_70B9(_context, caster)
    local target = GetSpellTargetUnit()
    if target == nil or target == 0 then
        return
    end
    local _____5F53_524DBoss_5355_4F4D = YDUserDataGetSafe("string", "Boss战", "单位", "unit")
    if _____5F53_524DBoss_5355_4F4D == nil or _____5F53_524DBoss_5355_4F4D == 0 or _____5F53_524DBoss_5355_4F4D ~= target then
        _____672C_5730_63D0_793A_65BD_6CD5_8005(caster, _____914D_7F6E.D["错误提示"])
        return
    end
    _____64AD_653E_5168_5C40_97F3_6548(caster, _____914D_7F6E.D["音效键"])
    local result = _____8C03_67E5Boss_5F31_70B9(target, caster)
    if not result["成功"] then
        _____672C_5730_63D0_793A_65BD_6CD5_8005(caster, "调查结果：" .. result["原因"])
    end
end
____exports["注册塞拉斯D"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞拉斯-天赋技调查（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.D["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653ED_8C03_67E5_5F31_70B9,
        ["创建独立技能实例"] = false
    })
end
____exports["注册塞拉斯D"]()
____exports["塞拉斯D技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["伤害形态"] = "无伤害",
    ["效果"] = "调用 调查Boss弱点() 显现一个未显现弱点并削盾 1 点",
    ["失败分支"] = "单位无效/Boss状态不存在/弱点机制未启用/护盾破碎中/没有未显现弱点 → 本地提示"
}
return ____exports
