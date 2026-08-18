--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00．配置")
local _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["八云紫单位技能配置"]
local ____01_FF0E_88C2_9699_7CFB_7EDF = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.07．公共与单位壳.01．裂隙系统")
local _____662F_516B_4E91_7D2B = ____01_FF0E_88C2_9699_7CFB_7EDF["是八云紫"]
local _____8BA1_7B97_88C2_9699_53EF_8FBE_7EC8_70B9 = ____01_FF0E_88C2_9699_7CFB_7EDF["计算裂隙可达终点"]
local _____521B_5EFA_516B_4E91_7D2B_88C2_9699 = ____01_FF0E_88C2_9699_7CFB_7EDF["创建八云紫裂隙"]
local _____68C0_67E5_516B_4E91_7D2BD_88C2_9699_653E_7F6E = ____01_FF0E_88C2_9699_7CFB_7EDF["检查八云紫D裂隙放置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00A．表现工具")
local _____64AD_653E_516B_4E91_7D2B_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放八云紫单位音效"]
local ____00B_FF0E_8BCA_65AD = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00B．诊断")
local _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7 = ____00B_FF0E_8BCA_65AD["八云紫诊断日志"]
local _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4 = ____00B_FF0E_8BCA_65AD["八云紫诊断句柄"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_2.registerSpellEffectListener
local ____require_result_3 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_3["技能_设置技能冷却时间"]
local ____require_result_4 = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4 = ____require_result_4["技能_获取技能最大冷却时间"]
local _____914D_7F6E = _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E
local ____D_6682_505C_6765_6E90 = "八云紫-D-间隙"
local function _____83B7_53D6D_4E0A_4E0B_6587(hero)
    return _____662F_516B_4E91_7D2B(hero) and ({["英雄"] = hero}) or nil
end
local function _____89E3_9664D_786C_76F4(variable)
    local hero = variable
    if hero ~= nil and hero ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(hero, ____D_6682_505C_6765_6E90)
    end
end
local function _____91CA_653ED(_context, hero, skillInstanceId)
    local startX = jass.GetUnitX(hero)
    local startY = jass.GetUnitY(hero)
    local ____end = _____8BA1_7B97_88C2_9699_53EF_8FBE_7EC8_70B9(
        startX,
        startY,
        jass.GetSpellTargetX(),
        jass.GetSpellTargetY()
    )
    local placement = _____68C0_67E5_516B_4E91_7D2BD_88C2_9699_653E_7F6E(hero, ____end.x, ____end.y)
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "D",
        "收到D施法",
        "英雄",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(hero),
        "英雄X",
        startX,
        "英雄Y",
        startY,
        "目标X",
        jass.GetSpellTargetX(),
        "目标Y",
        jass.GetSpellTargetY(),
        "可达X",
        ____end.x,
        "可达Y",
        ____end.y,
        "允许创建",
        placement["可创建"],
        "长期",
        placement["长期"],
        "持续秒",
        placement["持续秒"],
        "失败原因",
        placement["失败原因"] or "无",
        "技能实例ID",
        skillInstanceId or 0
    )
    if not placement["可创建"] then
        jass.DisplayTimedTextToPlayer(
            jass.GetOwningPlayer(hero),
            0,
            0,
            3,
            placement["失败原因"] or "无法在此处放置『间隙』。 "
        )
        _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(hero, _____914D_7F6E["技能"].D["类型ID"], 0, 5.5)
        return
    end
    do
        local i = 0
        while i < #_____914D_7F6E.D["展开音效键"] do
            _____64AD_653E_516B_4E91_7D2B_5355_4F4D_97F3_6548(hero, _____914D_7F6E.D["展开音效键"][i + 1])
            i = i + 1
        end
    end
    _____6DFB_52A0_5355_4F4D_6682_505C(hero, ____D_6682_505C_6765_6E90)
    jass.SetUnitAnimation(hero, _____914D_7F6E.D["施法动作"])
    local gap = _____521B_5EFA_516B_4E91_7D2B_88C2_9699(
        hero,
        ____end.x,
        ____end.y,
        _____914D_7F6E["技能"].D["类型ID"],
        skillInstanceId
    )
    local ____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7_11 = _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7
    local ____temp_10 = gap ~= nil and _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(gap["单位"]) or 0
    local ____temp_5
    if gap ~= nil then
        ____temp_5 = jass.GetUnitX(gap["单位"])
    else
        ____temp_5 = 0
    end
    local ____temp_6
    if gap ~= nil then
        ____temp_6 = jass.GetUnitY(gap["单位"])
    else
        ____temp_6 = 0
    end
    local ____temp_9 = gap and gap["长期"]
    if ____temp_9 == nil then
        ____temp_9 = false
    end
    ____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7_11(
        "D",
        "D创建间隙结果",
        "间隙",
        ____temp_10,
        "实际X",
        ____temp_5,
        "实际Y",
        ____temp_6,
        "长期",
        ____temp_9
    )
    addDelayedCallback(_____914D_7F6E.D["硬直秒"] * 1000, _____89E3_9664D_786C_76F4, hero)
end
local function _____76D1_542CD_5237_65B0(caster, spellAbilityId)
    if not _____662F_516B_4E91_7D2B(caster) or spellAbilityId == _____914D_7F6E["技能"].D["类型ID"] then
        return
    end
    local maxCooldown = _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4(caster, spellAbilityId) or 0
    if maxCooldown <= 6 then
        return
    end
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, _____914D_7F6E["技能"].D["类型ID"], 0, 5.5)
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "八云紫-间隙（D）",
    ["单位类型ID"] = _____914D_7F6E["单位"]["英雄类型ID"],
    ["技能ID"] = _____914D_7F6E["技能"].D["类型ID"],
    ["获取或创建上下文"] = _____83B7_53D6D_4E0A_4E0B_6587,
    ["释放技能"] = _____91CA_653ED,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 4
})
registerSpellEffectListener(_____76D1_542CD_5237_65B0)
return ____exports
