--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____E_65BD_52A0_4FDD_62A4_8109_51B2, jass, registerManualBuff, registerDamageModifier, unregisterDamageModifier, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____5355_4F4D_5B58_6D3B, addDelayedCallback
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.00．配置")
local _____7231_871C_8389_96C5_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅技能配置"]
local _____7231_871C_8389_96C5E_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅E配置"]
local ____20_FF0E_7231_871C_8389_96C5 = require("系统.05．Buff系统.03．Buff表.02．英雄.20．爱蜜莉雅")
local _____7231_871C_8389_96C5BuffID = ____20_FF0E_7231_871C_8389_96C5["爱蜜莉雅BuffID"]
local ____27_FF0E_6218_6597_6280_80FD_5B9E_4F8B_751F_547D_5468_671F_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____27_FF0E_6218_6597_6280_80FD_5B9E_4F8B_751F_547D_5468_671F_5DE5_5382["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____27_FF0E_6218_6597_6280_80FD_5B9E_4F8B_751F_547D_5468_671F_5DE5_5382["查询战斗技能实例"]
local ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.02．公共状态与冰晶")
local _____64AD_653E_7231_871C_8389_96C5_52A8_4F5C = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["播放爱蜜莉雅动作"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.00．配置")
local _____7231_871C_8389_96C5_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["爱蜜莉雅动作槽"]
local ____03_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.03．被动效果")
local _____521B_5EFA_7231_871C_8389_96C5_573A_4E0A_51B0_6676 = ____03_FF0E_88AB_52A8_6548_679C["创建爱蜜莉雅场上冰晶"]
function ____E_65BD_52A0_4FDD_62A4_8109_51B2(_____65BD_6CD5_8005, X, Y, _____6280_80FD_5B9E_4F8BID)
    local _____62A4_76FE_503C = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7231_871C_8389_96C5E_914D_7F6E["保护脉冲护盾攻击力倍率"]
    local _____6301_7EED_79D2 = _____7231_871C_8389_96C5E_914D_7F6E["保护脉冲持续秒"]
    local _____7EC4 = jass:CreateGroup()
    jass:GroupEnumUnitsInRange(
        _____7EC4,
        X,
        Y,
        260,
        nil
    )
    while true do
        do
            local u = jass:FirstOfGroup(_____7EC4)
            if u == nil or u == 0 then
                break
            end
            jass:GroupRemoveUnit(_____7EC4, u)
            if not _____5355_4F4D_5B58_6D3B(u) then
                goto __continue35
            end
            if not jass:IsUnitAlly(
                u,
                jass:GetOwningPlayer(_____65BD_6CD5_8005)
            ) then
                goto __continue35
            end
            if u == _____65BD_6CD5_8005 then
                goto __continue35
            end
            local _____5269_4F59 = _____62A4_76FE_503C
            local _____4FEE_9970ID = registerDamageModifier(
                function(context)
                    if context.target ~= u then
                        return context.currentDamage
                    end
                    if _____5269_4F59 <= 0 then
                        return context.currentDamage
                    end
                    local _____5438_6536 = context.currentDamage > _____5269_4F59 and _____5269_4F59 or context.currentDamage
                    _____5269_4F59 = _____5269_4F59 - _____5438_6536
                    return context.currentDamage - _____5438_6536
                end,
                900
            )
            registerManualBuff(u, _____7231_871C_8389_96C5BuffID["冰晶护身"], _____6301_7EED_79D2, _____62A4_76FE_503C)
            addDelayedCallback(
                _____6301_7EED_79D2 * 1000,
                function()
                    unregisterDamageModifier(_____4FEE_9970ID)
                end
            )
        end
        ::__continue35::
    end
    jass:DestroyGroup(_____7EC4)
    local ____ = _____6280_80FD_5B9E_4F8BID
end
jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
registerDamageModifier = ____require_result_1.registerDamageModifier
unregisterDamageModifier = ____require_result_1.unregisterDamageModifier
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_2["造成技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_3["开始冲锋"]
local _____505C_6B62_4F4D_79FB = ____require_result_3["停止位移"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local createUnitEffect = ____require_result_4.createUnitEffect
local destroyUnitEffect = ____require_result_4.destroyUnitEffect
local _____8BBE_7F6E_7279_6548_7F29_653E = ____require_result_4["设置特效缩放"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_5["注册单位技能壳监听"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
_____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_6["两点角度"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.25．限时二段技能壳")
local _____521B_5EFA_9650_65F6_4E8C_6BB5_6280_80FD_58F3 = ____require_result_7["创建限时二段技能壳"]
local _____786E_8BA4_9650_65F6_4E8C_6BB5_6280_80FD_58F3 = ____require_result_7["确认限时二段技能壳"]
local _____6E05_7406_9650_65F6_4E8C_6BB5_6280_80FD_58F3 = ____require_result_7["清理限时二段技能壳"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.02．公共状态与冰晶")
local _____6D88_8D39_7231_871C_8389_96C5D_5F3A_5316 = ____require_result_8["消费爱蜜莉雅D强化"]
local platformAbilityApi = require("平台扩展API取值")
local platformAbilityAction = require("平台扩展API动作")
local ____require_result_9 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_9.addDelayedCallback
local _____82F1_96C4_5355_4F4D_7C7B_578BID = jass:FourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E["单位类型ID"])
local ____E_6280_80FD_7C7B_578BID = jass:FourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E.E["技能ID"])
local _____62A4_76FE_7279_6548_952E = "爱蜜莉雅E护盾"
local function _____65BD_52A0_843D_70B9_51B0_7206(_____65BD_6CD5_8005, X, Y, _____6280_80FD_5B9E_4F8BID, _____4F24_5BB3_503C)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7231_871C_8389_96C5E_914D_7F6E["落点冰爆模型"],
        X = X,
        Y = Y,
        Z = _____7231_871C_8389_96C5E_914D_7F6E["表现"]["落点冰爆"]["高度"],
        ["缩放"] = _____7231_871C_8389_96C5E_914D_7F6E["表现"]["落点冰爆"]["缩放"],
        ["持续秒"] = _____7231_871C_8389_96C5E_914D_7F6E["表现"]["落点冰爆"]["持续秒"]
    })
    local _____76EE_6807_7EC4 = jass:CreateGroup()
    jass:GroupEnumUnitsInRange(
        _____76EE_6807_7EC4,
        X,
        Y,
        180,
        nil
    )
    while true do
        do
            local u = jass:FirstOfGroup(_____76EE_6807_7EC4)
            if u == nil or u == 0 then
                break
            end
            jass:GroupRemoveUnit(_____76EE_6807_7EC4, u)
            if u == _____65BD_6CD5_8005 or not _____5355_4F4D_5B58_6D3B(u) then
                goto __continue3
            end
            if not jass:IsUnitEnemy(
                u,
                jass:GetOwningPlayer(_____65BD_6CD5_8005)
            ) then
                goto __continue3
            end
            _____9020_6210_6280_80FD_4F24_5BB3({
                ["来源"] = _____65BD_6CD5_8005,
                ["目标"] = u,
                ["伤害"] = _____4F24_5BB3_503C,
                ["伤害类型"] = DAMAGE_TYPE_COLD,
                ["攻击类型"] = ATTACK_TYPE_NORMAL,
                ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "单位技能",
                ["技能ID"] = ____E_6280_80FD_7C7B_578BID,
                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                ["标签"] = "爱蜜莉雅-E冰爆",
                ["伤害形态"] = "AOE",
                ["参与技能伤害加成"] = true
            })
        end
        ::__continue3::
    end
    jass:DestroyGroup(_____76EE_6807_7EC4)
end
local function _____7ED3_675FE_62A4_76FE_5206_652F(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____5206_652F)
    local _____6570_636E = _____63A7_5236_5668["数据"]
    if _____6570_636E == nil or _____6570_636E["已结束"] then
        return
    end
    _____6570_636E["已结束"] = true
    if _____5206_652F == "提前" and _____6570_636E["位移ID"] ~= 0 then
        _____505C_6B62_4F4D_79FB(_____6570_636E["位移ID"], "中断")
    end
    if _____6570_636E["修饰ID"] ~= 0 then
        unregisterDamageModifier(_____6570_636E["修饰ID"])
    end
    if _____6570_636E["二段壳"] ~= nil then
        _____6E05_7406_9650_65F6_4E8C_6BB5_6280_80FD_58F3(_____6570_636E["二段壳"])
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_8005, _____7231_871C_8389_96C5BuffID["冰晶护身"])
    destroyUnitEffect(_____65BD_6CD5_8005, _____62A4_76FE_7279_6548_952E)
    if _____5206_652F == "破盾" then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____7231_871C_8389_96C5E_914D_7F6E["破盾裂纹模型"],
            X = GetUnitX(_____65BD_6CD5_8005),
            Y = GetUnitY(_____65BD_6CD5_8005),
            Z = _____7231_871C_8389_96C5E_914D_7F6E["表现"]["破盾裂纹"]["高度"],
            ["缩放"] = _____7231_871C_8389_96C5E_914D_7F6E["表现"]["破盾裂纹"]["缩放"],
            ["持续秒"] = _____7231_871C_8389_96C5E_914D_7F6E["表现"]["破盾裂纹"]["持续秒"]
        })
    end
    _____65BD_52A0_843D_70B9_51B0_7206(
        _____65BD_6CD5_8005,
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        _____6280_80FD_5B9E_4F8BID,
        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7231_871C_8389_96C5E_914D_7F6E["破盾伤害攻击力倍率"]
    )
    _____63A7_5236_5668["完成"](_____63A7_5236_5668)
end
local function _____91CA_653EE_51B0_6676_62A4_8EAB(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        return
    end
    _____64AD_653E_7231_871C_8389_96C5_52A8_4F5C(_____65BD_6CD5_8005, _____7231_871C_8389_96C5_52A8_4F5C_69FD.E)
    local _____6D3B_8DC3_5217_8868 = _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "E护盾")
    do
        local i = 0
        while i < #_____6D3B_8DC3_5217_8868 do
            _____7ED3_675FE_62A4_76FE_5206_652F(_____65BD_6CD5_8005, _____6D3B_8DC3_5217_8868[i + 1], _____6280_80FD_5B9E_4F8BID, "提前")
            return
        end
    end
    local _____62A4_76FE_503C = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7231_871C_8389_96C5E_914D_7F6E["护盾攻击力倍率"]
    local _____6570_636E = {
        ["护盾剩余"] = _____62A4_76FE_503C,
        ["修饰ID"] = 0,
        ["位移ID"] = 0,
        ["已结束"] = false,
        ["二段壳"] = nil
    }
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "E护盾",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(______539F_56E0, _c)
            if _____6570_636E["已结束"] then
                return
            end
            _____6570_636E["已结束"] = true
            if _____6570_636E["位移ID"] ~= 0 then
                _____505C_6B62_4F4D_79FB(_____6570_636E["位移ID"], "中断")
            end
            if _____6570_636E["修饰ID"] ~= 0 then
                unregisterDamageModifier(_____6570_636E["修饰ID"])
            end
            if _____6570_636E["二段壳"] ~= nil then
                _____6E05_7406_9650_65F6_4E8C_6BB5_6280_80FD_58F3(_____6570_636E["二段壳"])
            end
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_8005, _____7231_871C_8389_96C5BuffID["冰晶护身"])
            destroyUnitEffect(_____65BD_6CD5_8005, _____62A4_76FE_7279_6548_952E)
        end
    })
    _____6570_636E["修饰ID"] = registerDamageModifier(
        function(context)
            if _____6570_636E["已结束"] then
                return context.currentDamage
            end
            if context.target ~= _____65BD_6CD5_8005 then
                return context.currentDamage
            end
            if _____6570_636E["护盾剩余"] <= 0 then
                return context.currentDamage
            end
            local _____5438_6536 = context.currentDamage > _____6570_636E["护盾剩余"] and _____6570_636E["护盾剩余"] or context.currentDamage
            _____6570_636E["护盾剩余"] = _____6570_636E["护盾剩余"] - _____5438_6536
            if _____6570_636E["护盾剩余"] <= 0 then
                addDelayedCallback(
                    0,
                    function()
                        _____7ED3_675FE_62A4_76FE_5206_652F(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, "破盾")
                    end
                )
            end
            return context.currentDamage - _____5438_6536
        end,
        1000
    )
    registerManualBuff(_____65BD_6CD5_8005, _____7231_871C_8389_96C5BuffID["冰晶护身"], _____7231_871C_8389_96C5E_914D_7F6E["护盾持续秒"], _____62A4_76FE_503C)
    local _____62A4_76FE_7279_6548 = createUnitEffect(
        _____65BD_6CD5_8005,
        "origin",
        _____7231_871C_8389_96C5E_914D_7F6E["护盾模型"],
        _____7231_871C_8389_96C5E_914D_7F6E["表现"]["护盾"]["持续秒"],
        _____62A4_76FE_7279_6548_952E
    )
    _____8BBE_7F6E_7279_6548_7F29_653E(_____62A4_76FE_7279_6548, _____7231_871C_8389_96C5E_914D_7F6E["表现"]["护盾"]["缩放"])
    local _____81EA_7136_7ED3_675F_5EF6_8FDF = addDelayedCallback(
        _____7231_871C_8389_96C5E_914D_7F6E["护盾持续秒"] * 1000,
        function()
            _____7ED3_675FE_62A4_76FE_5206_652F(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, "自然")
        end
    )
    _____63A7_5236_5668["登记延迟回调"](_____81EA_7136_7ED3_675F_5EF6_8FDF)
    _____6570_636E["二段壳"] = _____521B_5EFA_9650_65F6_4E8C_6BB5_6280_80FD_58F3({
        ["名称"] = "爱蜜莉雅-E二段",
        ["单位"] = _____65BD_6CD5_8005,
        ["一段技能ID"] = ____E_6280_80FD_7C7B_578BID,
        ["二段技能ID"] = jass:FourCC(_____7231_871C_8389_96C5E_914D_7F6E["二段技能ID"]),
        ["持续秒"] = _____7231_871C_8389_96C5E_914D_7F6E["护盾持续秒"]
    })
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____65B9_5411 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        _____76EE_6807X,
        _____76EE_6807Y
    )
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7231_871C_8389_96C5E_914D_7F6E["冰面路径模型"],
        X = GetUnitX(_____65BD_6CD5_8005),
        Y = GetUnitY(_____65BD_6CD5_8005),
        Z = _____7231_871C_8389_96C5E_914D_7F6E["表现"]["冰面路径"]["高度"],
        ["面向角度"] = _____65B9_5411,
        ["缩放"] = _____7231_871C_8389_96C5E_914D_7F6E["表现"]["冰面路径"]["缩放"],
        ["持续秒"] = _____7231_871C_8389_96C5E_914D_7F6E["表现"]["冰面路径"]["持续秒"]
    })
    _____6570_636E["位移ID"] = _____5F00_59CB_51B2_950B(
        _____65BD_6CD5_8005,
        {
            ["距离"] = _____7231_871C_8389_96C5E_914D_7F6E["位移距离"],
            ["每秒速度"] = _____7231_871C_8389_96C5E_914D_7F6E["位移速度"],
            ["角度"] = _____65B9_5411,
            ["检查地形"] = true,
            ["朝向跟随位移"] = true,
            ["暂停单位"] = false,
            ["撞墙回调"] = function(_____5355_4F4D, ______4F4D_79FBID)
                local _____6700_5927_51B7_5374 = platformAbilityApi["技能_获取技能最大冷却时间"](_____5355_4F4D, ____E_6280_80FD_7C7B_578BID)
                platformAbilityAction["技能_设置技能冷却时间"](_____5355_4F4D, ____E_6280_80FD_7C7B_578BID, _____7231_871C_8389_96C5E_914D_7F6E["短惩罚冷却秒"], _____6700_5927_51B7_5374)
            end,
            ["结束回调"] = function(_____5355_4F4D, ______539F_56E0, ______4F4D_79FBID)
                if _____6570_636E["已结束"] then
                    return
                end
                local _____843D_70B9X = GetUnitX(_____5355_4F4D)
                local _____843D_70B9Y = GetUnitY(_____5355_4F4D)
                _____65BD_52A0_843D_70B9_51B0_7206(
                    _____65BD_6CD5_8005,
                    _____843D_70B9X,
                    _____843D_70B9Y,
                    _____6280_80FD_5B9E_4F8BID,
                    _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7231_871C_8389_96C5E_914D_7F6E["落点冰爆伤害攻击力倍率"]
                )
                if _____7231_871C_8389_96C5E_914D_7F6E["落点生成冰晶"] then
                    _____521B_5EFA_7231_871C_8389_96C5_573A_4E0A_51B0_6676(
                        _____65BD_6CD5_8005,
                        "E",
                        _____843D_70B9X,
                        _____843D_70B9Y,
                        _____7231_871C_8389_96C5E_914D_7F6E["落点冰晶持续秒"]
                    )
                end
                if _____6D88_8D39_7231_871C_8389_96C5D_5F3A_5316(_____65BD_6CD5_8005) then
                    ____E_65BD_52A0_4FDD_62A4_8109_51B2(_____65BD_6CD5_8005, _____843D_70B9X, _____843D_70B9Y, _____6280_80FD_5B9E_4F8BID)
                end
                _____6570_636E["位移ID"] = 0
            end
        }
    )
end
local function _____91CA_653EE_4E8C_6BB5_8F93_5165(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        return
    end
    local _____6D3B_8DC3_5217_8868 = _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "E护盾")
    do
        local i = 0
        while i < #_____6D3B_8DC3_5217_8868 do
            _____7ED3_675FE_62A4_76FE_5206_652F(_____65BD_6CD5_8005, _____6D3B_8DC3_5217_8868[i + 1], _____6280_80FD_5B9E_4F8BID, "提前")
            return
        end
    end
end
____exports["注册爱蜜莉雅E"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "爱蜜莉雅-冰晶护身（E）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7231_871C_8389_96C5_6280_80FD_914D_7F6E.E["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EE_51B0_6676_62A4_8EAB,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____7231_871C_8389_96C5E_914D_7F6E["护盾持续秒"] + 2
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "爱蜜莉雅-E二段输入（ASE2）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7231_871C_8389_96C5E_914D_7F6E["二段技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EE_4E8C_6BB5_8F93_5165,
        ["创建独立技能实例"] = false
    })
end
return ____exports
