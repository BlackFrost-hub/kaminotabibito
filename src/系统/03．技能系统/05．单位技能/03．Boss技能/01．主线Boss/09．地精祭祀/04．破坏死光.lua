--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.00．配置")
local _____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["地精祭祀单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建地精祭祀上下文"]
local _____83B7_53D6_5730_7CBE_796D_7940_8303_56F4_76EE_6807 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取地精祭祀范围目标"]
local _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["地精祭祀单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.02．数值与表现配置")
local _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["地精祭祀技能配置"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellChannelListener = ____require_result_0.registerSpellChannelListener
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_2["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_2["关闭吟唱条"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_3.createTimedUnitEffect
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5730_7CBE_796D_7940_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____7834_574F_6B7B_5149_6280_80FDID = stringToFourCCSafe(_____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["破坏死光"])
local _____5730_7CBE_796D_7940_7834_574F_6B7B_5149_5DF2_6CE8_518C = false
local function _____7ED3_7B97_5730_7CBE_796D_7940_7834_574F_6B7B_5149(_____4E0A_4E0B_6587, _____76EE_6807_5355_4F4D)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B(boss) or not _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        return false
    end
    local _____914D_7F6E = _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["破坏死光"]
    local _____7ED3_7B97X = GetUnitX(_____76EE_6807_5355_4F4D)
    local _____7ED3_7B97Y = GetUnitY(_____76EE_6807_5355_4F4D)
    local _____76EE_6807_5217_8868 = _____83B7_53D6_5730_7CBE_796D_7940_8303_56F4_76EE_6807(
        boss,
        _____7ED3_7B97X,
        _____7ED3_7B97Y,
        _____914D_7F6E["作用半径"],
        _____914D_7F6E["最大飞行高度"]
    )
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            local _____76EE_6807 = _____76EE_6807_5217_8868[i + 1]
            createTimedUnitEffect(_____76EE_6807, _____914D_7F6E["目标特效挂点"], _____914D_7F6E["目标特效路径"], _____914D_7F6E["目标特效持续秒"])
            _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                ["来源"] = boss,
                ["目标"] = _____76EE_6807,
                ["技能ID"] = _____7834_574F_6B7B_5149_6280_80FDID,
                ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["Boss攻击力比例"], ["目标最大生命比例"] = _____914D_7F6E["目标最大生命比例"]},
                attack = false,
                ranged = false,
                attackType = ATTACK_TYPE_NORMAL,
                ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["标签"] = "地精祭祀·破坏死光"
            })
            i = i + 1
        end
    end
    return true
end
local function _____521B_5EFA_7834_574F_6B7B_5149_6D4B_8BD5_7ED3_7B97_56DE_8C03(_____6570_636E)
    local function ____on_7834_574F_6B7B_5149_6D4B_8BD5_7ED3_7B97()
        _____7ED3_7B97_5730_7CBE_796D_7940_7834_574F_6B7B_5149(_____6570_636E["上下文"], _____6570_636E["目标单位"])
    end
    return ____on_7834_574F_6B7B_5149_6D4B_8BD5_7ED3_7B97
end
____exports["释放地精祭祀破坏死光"] = function(_____4E0A_4E0B_6587, _____76EE_6807_5355_4F4D)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B(boss) or not _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        return false
    end
    local _____914D_7F6E = _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["破坏死光"]
    local _____6570_636E = {["上下文"] = _____4E0A_4E0B_6587, ["目标单位"] = _____76EE_6807_5355_4F4D}
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "地精祭祀-破坏死光-测试释放",
        ["施法者"] = boss,
        ["目标单位"] = _____76EE_6807_5355_4F4D,
        ["硬直秒"] = _____914D_7F6E["通魔施法秒"],
        ["生效延迟秒"] = _____914D_7F6E["通魔施法秒"],
        ["动画名"] = _____914D_7F6E["动作名称"],
        ["吟唱条"] = {
            ["通道"] = _____914D_7F6E["读条通道"],
            ["总时长"] = _____914D_7F6E["通魔施法秒"],
            ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
            ["标题文本"] = _____914D_7F6E["读条标题"],
            ["提示文本"] = _____914D_7F6E["读条提示"]
        },
        ["on生效"] = _____521B_5EFA_7834_574F_6B7B_5149_6D4B_8BD5_7ED3_7B97_56DE_8C03(_____6570_636E),
        ["清理"] = _____4E0A_4E0B_6587["清理"],
        ["施法者死亡时取消"] = true,
        ["目标失效时取消"] = true,
        ["生效前重新面向"] = true
    })
    return true
end
local function ____on_5730_7CBE_796D_7940_7834_574F_6B7B_5149_51C6_5907(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____7834_574F_6B7B_5149_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____5730_7CBE_796D_7940_5355_4F4D_7C7B_578BID then
        return
    end
    local _____914D_7F6E = _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["破坏死光"]
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["通魔施法秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
end
local function ____on_5730_7CBE_796D_7940_7834_574F_6B7B_5149_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____7834_574F_6B7B_5149_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____5730_7CBE_796D_7940_5355_4F4D_7C7B_578BID then
        return
    end
    _____5173_95ED_541F_5531_6761(_____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["破坏死光"]["读条通道"])
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587(castingUnit)
    if _____4E0A_4E0B_6587 ~= nil then
        _____7ED3_7B97_5730_7CBE_796D_7940_7834_574F_6B7B_5149(
            _____4E0A_4E0B_6587,
            GetSpellTargetUnit()
        )
    end
end
____exports["注册地精祭祀破坏死光"] = function()
    if _____5730_7CBE_796D_7940_7834_574F_6B7B_5149_5DF2_6CE8_518C then
        return
    end
    _____5730_7CBE_796D_7940_7834_574F_6B7B_5149_5DF2_6CE8_518C = true
    registerSpellChannelListener(____on_5730_7CBE_796D_7940_7834_574F_6B7B_5149_51C6_5907)
    registerSpellEffectListener(____on_5730_7CBE_796D_7940_7834_574F_6B7B_5149_751F_6548)
end
return ____exports
