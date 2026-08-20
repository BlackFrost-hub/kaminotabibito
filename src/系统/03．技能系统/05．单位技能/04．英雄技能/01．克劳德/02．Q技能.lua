local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local ____exports = {}
local _____76EE_6807_5408_6CD5, _____83B7_53D6_5355_4F4D_62E5_6709_8005, _____5224_65AD_5355_4F4D_7C7B_578B, _____5224_65AD_654C_5BF9, _____654C_65B9_5355_4F4D_7C7B_578B, _____673A_68B0_5355_4F4D_7C7B_578B
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．克劳德.00．配置")
local _____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["克劳德单位技能配置"]
local ____00A_FF0E_8054_52A8_72B6_6001 = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．克劳德.00A．联动状态")
local _____6D88_8017_7A7A_7259Q_8054_52A8 = ____00A_FF0E_8054_52A8_72B6_6001["消耗空牙Q联动"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
function _____76EE_6807_5408_6CD5(caster, target)
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    if _____5224_65AD_5355_4F4D_7C7B_578B(target, _____654C_65B9_5355_4F4D_7C7B_578B) or _____5224_65AD_5355_4F4D_7C7B_578B(target, _____673A_68B0_5355_4F4D_7C7B_578B) then
        return false
    end
    return _____5224_65AD_654C_5BF9(
        target,
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster)
    )
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_1["减少魔法值"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成批量AOE技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_3["开始击退"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口")
local _____5F00_59CB_8DF3_8DC3_4F5C_4E3A_88AB_51FB_9000_51FB_98DE = ____require_result_4["开始跳跃作为被击退击飞"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_5["施加眩晕"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.04．护甲降低")
local _____65BD_52A0_5355_4F53_62A4_7532_964D_4F4EBuff = ____require_result_6["施加单体护甲降低Buff"]
local ____require_result_7 = require("系统.04．伤害系统.00．伤害计算.01．属性读取")
local ____getTargetArmor_666E_901A_7248 = ____require_result_7.getTargetArmor
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_8["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_8["移除单位暂停"]
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_SetUnitMovableSafe = ____require_result_9.X_SetUnitMovableSafe
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_10["获取范围敌军"]
local _____5728_5750_6807_64AD_653E_7279_6548 = ____require_result_10["在坐标播放特效"]
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_11["创建点特效"]
local ____require_result_12 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_12.YDWETimerDestroyEffectSafe
local ____require_result_13 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
local CreateFloatTextAtPoint = ____require_result_13.CreateFloatTextAtPoint
local ____require_result_14 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_14["创建原生弹幕"]
local _____83B7_53D6_539F_751F_5F39_5E55 = ____require_result_14["获取原生弹幕"]
local _____9500_6BC1_539F_751F_5F39_5E55 = ____require_result_14["销毁原生弹幕"]
local ____require_result_15 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_15.registerDeathListener
local ____require_result_16 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_16.registerSpellEffectListener
local ____require_result_17 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_17.stringToFourCCSafe
local ____require_result_18 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_18.debugLogForce
local _____6A21_5757_540D = "克劳德-Q"
local _____65BD_6CD5_6682_505C_6765_6E90 = "克劳德-Q-施法"
local ____require_result_19 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundOnUnitBJ = ____require_result_19.PlaySoundOnUnitBJ
local _____83B7_53D6_53E5_67C4ID = jass.GetHandleId
local _____83B7_53D6_6280_80FD_76EE_6807_5355_4F4D = jass.GetSpellTargetUnit
local _____83B7_53D6_6280_80FD_76EE_6807X = jass.GetSpellTargetX
local _____83B7_53D6_6280_80FD_76EE_6807Y = jass.GetSpellTargetY
local _____83B7_53D6_5355_4F4DX = jass.GetUnitX
local _____83B7_53D6_5355_4F4DY = jass.GetUnitY
local _____83B7_53D6_5355_4F4D_7C7B_578BID = jass.GetUnitTypeId
_____83B7_53D6_5355_4F4D_62E5_6709_8005 = jass.GetOwningPlayer
local _____83B7_53D6_5355_4F4D_72B6_6001 = jass.GetUnitState
_____5224_65AD_5355_4F4D_7C7B_578B = jass.IsUnitType
_____5224_65AD_654C_5BF9 = jass.IsUnitEnemy
local _____8BBE_7F6E_65F6_95F4_6D41_901F = jass.SetUnitTimeScale
local _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6 = jass.SetUnitFlyHeight
local _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6 = jass.GetUnitFlyHeight
local _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6 = jass.GetUnitDefaultFlyHeight
local _____8BBE_7F6E_5355_4F4DX = jass.SetUnitX
local _____8BBE_7F6E_5355_4F4DY = jass.SetUnitY
local _____5224_65AD_5730_5F62_53EF_884C_8D70 = jass.IsTerrainPathable
local _____968F_673A_5B9E_6570 = jass.GetRandomReal
local _____8BBE_7F6E_52A8_4F5C = jass.SetUnitAnimationByIndex
local _____8BBE_7F6E_6280_80FD_53EF_7528 = jass.SetPlayerAbilityAvailable
local _____6DFB_52A0_6280_80FD = jass.UnitAddAbility
local _____79FB_9664_6280_80FD = jass.UnitRemoveAbility
local _____8BA1_7B97_4F59_5F26 = jass.Cos
local _____8BA1_7B97_6B63_5F26 = jass.Sin
local _____89D2_5EA6_8F6C_5F27_5EA6 = jass.bj_DEGTORAD
local _____6700_5927_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MAX_MANA
local _____5F53_524D_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MANA
_____654C_65B9_5355_4F4D_7C7B_578B = jass.UNIT_TYPE_ANCIENT
_____673A_68B0_5355_4F4D_7C7B_578B = jass.UNIT_TYPE_MECHANICAL
local _____653B_51FB_7C7B_578B = jass.ATTACK_TYPE_NORMAL
local _____9B54_6CD5_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_MAGIC
local _____672A_77E5_6B66_5668_7C7B_578B = jass.WEAPON_TYPE_WHOKNOWS
local _____666E_901A_4F24_5BB3_7C7B_578B = jass.DAMAGE_TYPE_NORMAL
local _____53EF_884C_8D70_8DEF_5F84_7C7B_578B = jass.PATHING_TYPE_WALKABILITY
local _____914D_7F6E = _____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E.Q
local _____8054_52A8_914D_7F6E = _____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E.W
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____514B_52B3_5FB7_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____521D_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["初段技能ID"])
local _____4E8C_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["二段技能ID"])
local _____4E09_6BB5_6280_80FDID = stringToFourCCSafe(_____914D_7F6E["三段技能ID"])
local _____72B6_6001_8868 = {}
local _____5F39_5E55_72B6_6001_8868 = {}
local ____Q_547D_4E2D_8868_73B0_8868 = {}
local _____4E0B_4E00_4E2AQ_547D_4E2D_8868_73B0ID = 0
local ____Q_547D_4E2D_8868_73B0_9A71_52A8ID = 0
local function _____521B_5EFAQ_547D_4E2D_8868_73B0(caster, target, _____6A21_5F0F, _____65B9_5411_89D2)
    _____4E0B_4E00_4E2AQ_547D_4E2D_8868_73B0ID = _____4E0B_4E00_4E2AQ_547D_4E2D_8868_73B0ID + 1
    local id = _____4E0B_4E00_4E2AQ_547D_4E2D_8868_73B0ID
    local _____8868_73B0 = {
        ["施法者"] = caster,
        ["目标"] = target,
        ["模式"] = _____6A21_5F0F,
        Tick = 0,
        ["累计毫秒"] = 0,
        ["初始X"] = _____83B7_53D6_5355_4F4DX(target),
        ["初始Y"] = _____83B7_53D6_5355_4F4DY(target),
        ["方向角"] = _____65B9_5411_89D2,
        ["总伤害"] = _____6A21_5F0F == "二段乱斩" and _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E["二段伤害倍率"] or 0,
        ["已结算伤害"] = {}
    }
    ____Q_547D_4E2D_8868_73B0_8868[id] = _____8868_73B0
    return _____8868_73B0
end
local function _____6E05_7406Q_547D_4E2D_8868_73B0(id)
    local _____8868_73B0 = ____Q_547D_4E2D_8868_73B0_8868[id]
    if _____8868_73B0 == nil then
        return
    end
    if _____5355_4F4D_5B58_6D3B(_____8868_73B0["目标"]) then
        _____79FB_9664_5355_4F4D_6682_505C(
            _____8868_73B0["目标"],
            "克劳德-Q-命中表现-" .. tostring(id)
        )
        _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
            _____8868_73B0["目标"],
            _____83B7_53D6_5355_4F4D_9ED8_8BA4_98DE_884C_9AD8_5EA6(_____8868_73B0["目标"]),
            0
        )
        _____8BBE_7F6E_65F6_95F4_6D41_901F(_____8868_73B0["目标"], 1)
        _____8BBE_7F6E_52A8_4F5C(_____8868_73B0["目标"], 0)
    end
    __TS__Delete(____Q_547D_4E2D_8868_73B0_8868, id)
end
local function ____Q_547D_4E2D_8868_73B0Tick(id, _____95F4_9694_6BEB_79D2)
    local _____8868_73B0 = ____Q_547D_4E2D_8868_73B0_8868[id]
    if _____8868_73B0 == nil or not _____5355_4F4D_5B58_6D3B(_____8868_73B0["目标"]) or not _____5355_4F4D_5B58_6D3B(_____8868_73B0["施法者"]) then
        _____6E05_7406Q_547D_4E2D_8868_73B0(id)
        return
    end
    _____8868_73B0["累计毫秒"] = _____8868_73B0["累计毫秒"] + 10
    if _____8868_73B0["累计毫秒"] < _____95F4_9694_6BEB_79D2 then
        return
    end
    _____8868_73B0["累计毫秒"] = 0
    local target = _____8868_73B0["目标"]
    local source = "克劳德-Q-命中表现-" .. tostring(id)
    if _____8868_73B0["模式"] == "初段上升" or _____8868_73B0["模式"] == "初段下降" then
        _____8868_73B0.Tick = _____8868_73B0.Tick + 1
        local delta = _____8868_73B0["模式"] == "初段上升" and _____914D_7F6E["初段每Tick高度"] or -_____914D_7F6E["初段每Tick高度"]
        _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
            target,
            _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(target) + delta,
            0
        )
        if _____8868_73B0.Tick >= _____914D_7F6E["初段升降Tick数"] then
            if _____8868_73B0["模式"] == "初段上升" then
                _____8868_73B0["模式"] = "初段下降"
                _____8868_73B0.Tick = 0
            else
                _____6E05_7406Q_547D_4E2D_8868_73B0(id)
            end
        end
        return
    end
    if _____8868_73B0["模式"] == "二段乱斩" then
        _____8868_73B0.Tick = _____8868_73B0.Tick + 1
        local _____65A9_51FB_9762_5411_89D2_5EA6 = _____968F_673A_5B9E_6570(0, 360)
        local angle = _____65A9_51FB_9762_5411_89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6
        local radius = _____968F_673A_5B9E_6570(_____914D_7F6E["二段乱斩随机半径最小值"], _____914D_7F6E["二段乱斩随机半径最大值"])
        local x = _____8868_73B0["初始X"] + _____8BA1_7B97_4F59_5F26(angle) * radius
        local y = _____8868_73B0["初始Y"] + _____8BA1_7B97_6B63_5F26(angle) * radius
        if not _____5224_65AD_5730_5F62_53EF_884C_8D70(x, y, _____53EF_884C_8D70_8DEF_5F84_7C7B_578B) then
            _____8BBE_7F6E_5355_4F4DX(target, x)
            _____8BBE_7F6E_5355_4F4DY(target, y)
        end
        local targets = _____83B7_53D6_8303_56F4_654C_519B(_____8868_73B0["施法者"], x, y, 100)
        local _____8FDB_5EA6_503C = _____8868_73B0.Tick / _____914D_7F6E["二段乱斩Tick数"]
        local _____5F53_524D_8FDB_5EA6 = _____8FDB_5EA6_503C > 1 and 1 or _____8FDB_5EA6_503C
        local _____5F53_524D_5E94_7ED3_7B97_603B_989D = _____8868_73B0["总伤害"] * _____5F53_524D_8FDB_5EA6
        local _____5F85_7ED3_7B97_76EE_6807 = {}
        local _____5F85_7ED3_7B97_4F24_5BB3 = {}
        for ____, hitTarget in ipairs(targets) do
            do
                if not _____76EE_6807_5408_6CD5(_____8868_73B0["施法者"], hitTarget) then
                    goto __continue15
                end
                local targetId = _____83B7_53D6_53E5_67C4ID(hitTarget)
                local _____5DF2_7ED3_7B97 = _____8868_73B0["已结算伤害"][targetId] or 0
                local _____672C_6B21_4F24_5BB3 = _____5F53_524D_5E94_7ED3_7B97_603B_989D - _____5DF2_7ED3_7B97
                if _____672C_6B21_4F24_5BB3 <= 0 then
                    goto __continue15
                end
                _____8868_73B0["已结算伤害"][targetId] = _____5DF2_7ED3_7B97 + _____672C_6B21_4F24_5BB3
                _____5F85_7ED3_7B97_76EE_6807[#_____5F85_7ED3_7B97_76EE_6807 + 1] = hitTarget
                _____5F85_7ED3_7B97_4F24_5BB3[#_____5F85_7ED3_7B97_4F24_5BB3 + 1] = _____672C_6B21_4F24_5BB3
            end
            ::__continue15::
        end
        do
            local index = 0
            while index < #_____5F85_7ED3_7B97_76EE_6807 do
                _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = _____8868_73B0["施法者"],
                    ["目标列表"] = {_____5F85_7ED3_7B97_76EE_6807[index + 1]},
                    ["伤害"] = _____5F85_7ED3_7B97_4F24_5BB3[index + 1],
                    ["伤害类型"] = _____9B54_6CD5_4F24_5BB3_7C7B_578B,
                    attack = true,
                    ranged = false,
                    attackType = _____653B_51FB_7C7B_578B,
                    weaponType = _____672A_77E5_6B66_5668_7C7B_578B,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = _____4E8C_6BB5_6280_80FDID,
                    ["标签"] = "克劳德-Q-二段剑气切割"
                })
                index = index + 1
            end
        end
        local _____65A9_51FBZ = _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(target) + _____968F_673A_5B9E_6570(_____914D_7F6E["二段乱斩随机高度最小值"], _____914D_7F6E["二段乱斩随机高度最大值"])
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E["二段乱斩特效模型"],
            X = x,
            Y = y,
            Z = _____65A9_51FBZ,
            ["面向角度"] = _____65A9_51FB_9762_5411_89D2_5EA6,
            ["缩放"] = _____914D_7F6E["二段乱斩特效缩放"],
            ["动画速度"] = _____914D_7F6E["二段乱斩特效速度"],
            ["持续秒"] = _____914D_7F6E["二段乱斩特效持续秒"]
        })
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E["二段乱斩叠加特效模型"],
            X = x,
            Y = y,
            Z = _____65A9_51FBZ,
            ["面向角度"] = _____65A9_51FB_9762_5411_89D2_5EA6,
            ["缩放"] = _____914D_7F6E["二段乱斩叠加特效缩放"],
            ["动画速度"] = _____914D_7F6E["二段乱斩叠加特效速度"],
            ["持续秒"] = _____914D_7F6E["二段乱斩叠加特效持续秒"]
        })
        if _____8868_73B0.Tick >= _____914D_7F6E["二段乱斩Tick数"] then
            _____6E05_7406Q_547D_4E2D_8868_73B0(id)
        end
        return
    end
    _____8868_73B0.Tick = _____8868_73B0.Tick + 1
    local delta = _____8868_73B0["模式"] == "三段上升" and _____914D_7F6E["三段每Tick高度"] or -_____914D_7F6E["三段每Tick高度"]
    _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(
        target,
        _____83B7_53D6_5355_4F4D_98DE_884C_9AD8_5EA6(target) + delta,
        0
    )
    local x = _____83B7_53D6_5355_4F4DX(target) + _____8BA1_7B97_4F59_5F26(_____8868_73B0["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["三段每Tick前进距离"]
    local y = _____83B7_53D6_5355_4F4DY(target) + _____8BA1_7B97_6B63_5F26(_____8868_73B0["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["三段每Tick前进距离"]
    if not _____5224_65AD_5730_5F62_53EF_884C_8D70(x, y, _____53EF_884C_8D70_8DEF_5F84_7C7B_578B) then
        _____8BBE_7F6E_5355_4F4DX(target, x)
        _____8BBE_7F6E_5355_4F4DY(target, y)
    end
    if _____8868_73B0.Tick >= (_____8868_73B0["模式"] == "三段上升" and _____914D_7F6E["三段升降Tick数"] or _____914D_7F6E["三段下降Tick数"]) then
        if _____8868_73B0["模式"] == "三段上升" then
            _____8868_73B0["模式"] = "三段下降"
            _____8868_73B0.Tick = 0
        else
            _____6E05_7406Q_547D_4E2D_8868_73B0(id)
        end
    end
end
local function ____Q_547D_4E2D_8868_73B0_9A71_52A8()
    for key in pairs(____Q_547D_4E2D_8868_73B0_8868) do
        do
            local id = __TS__Number(key)
            local _____8868_73B0 = ____Q_547D_4E2D_8868_73B0_8868[id]
            if _____8868_73B0 == nil then
                goto __continue27
            end
            local _____95F4_9694_6BEB_79D2 = (_____8868_73B0["模式"] == "初段上升" or _____8868_73B0["模式"] == "初段下降" or _____8868_73B0["模式"] == "二段乱斩" or _____8868_73B0["模式"] == "三段上升") and _____914D_7F6E["初段升降间隔秒"] * 1000 or _____914D_7F6E["三段下降间隔秒"] * 1000
            ____Q_547D_4E2D_8868_73B0Tick(id, _____95F4_9694_6BEB_79D2)
        end
        ::__continue27::
    end
    if #__TS__ObjectKeys(____Q_547D_4E2D_8868_73B0_8868) == 0 and ____Q_547D_4E2D_8868_73B0_9A71_52A8ID > 0 then
        removePeriodicCallback(____Q_547D_4E2D_8868_73B0_9A71_52A8ID)
        ____Q_547D_4E2D_8868_73B0_9A71_52A8ID = 0
    end
end
local function _____542F_52A8Q_547D_4E2D_8868_73B0(caster, target, _____6A21_5F0F, _____65B9_5411_89D2, _____95F4_9694_79D2)
    local _____8868_73B0 = _____521B_5EFAQ_547D_4E2D_8868_73B0(caster, target, _____6A21_5F0F, _____65B9_5411_89D2)
    local id = _____4E0B_4E00_4E2AQ_547D_4E2D_8868_73B0ID
    _____6DFB_52A0_5355_4F4D_6682_505C(
        target,
        "克劳德-Q-命中表现-" .. tostring(id)
    )
    _____8BBE_7F6E_65F6_95F4_6D41_901F(target, _____914D_7F6E["命中动作速度"])
    _____8BBE_7F6E_52A8_4F5C(target, 2)
    _____8868_73B0["累计毫秒"] = 0
    if ____Q_547D_4E2D_8868_73B0_9A71_52A8ID == 0 then
        ____Q_547D_4E2D_8868_73B0_9A71_52A8ID = addPeriodicCallback(10, ____Q_547D_4E2D_8868_73B0_9A71_52A8)
    end
end
local function _____8BFB_53D6_76EE_6807_62A4_7532(target)
    return ____getTargetArmor_666E_901A_7248(nil, target)
end
local function _____83B7_53D6_6216_521B_5EFAQ_72B6_6001(unit)
    local id = _____83B7_53D6_53E5_67C4ID(unit)
    local state = _____72B6_6001_8868[id]
    if state == nil then
        state = {
            ["施法者"] = unit,
            ["阶段"] = 0,
            ["进行中"] = false,
            ["等待输入"] = false,
            ["代次"] = 0,
            ["蓄力回调ID"] = 0,
            ["施法硬直回调ID"] = 0,
            ["施法硬直代次"] = 0,
            ["蓄力站桩中"] = false,
            ["追加输入次数"] = 0,
            ["目标单位"] = nil,
            ["目标X"] = 0,
            ["目标Y"] = 0,
            ["方向角"] = 0,
            ["弹幕ID"] = 0,
            ["路径特效累计秒"] = 0,
            ["空牙联动"] = false,
            ["空牙联动方向"] = 0
        }
        _____72B6_6001_8868[id] = state
    end
    return state
end
local function _____64AD_653EQ_97F3_6548(caster, _____5F3A_5316)
    local key = _____5F3A_5316 and _____914D_7F6E["强化音效键"] or _____914D_7F6E["初段音效键"]
    local sound = jglobals[key]
    if sound ~= nil then
        PlaySoundOnUnitBJ(sound, 100, caster)
    end
end
local function _____64AD_653EQ_84C4_529B_8868_73B0(caster, count)
    local text = count > 2 and _____914D_7F6E["蓄力超出提示"] or tostring(count) .. "Hit"
    local x = _____83B7_53D6_5355_4F4DX(caster)
    local y = _____83B7_53D6_5355_4F4DY(caster)
    CreateFloatTextAtPoint(x, y, text, {
        size = _____914D_7F6E["蓄力文字大小"],
        height = _____914D_7F6E["蓄力文字高度"],
        red = 100,
        green = 20,
        blue = 20,
        alpha = 0,
        duration = 1,
        speedX = 0,
        speedY = 0.1
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["蓄力特效模型"],
        X = x,
        Y = y,
        Z = 0,
        ["动画速度"] = _____914D_7F6E["蓄力特效速度"],
        ["持续秒"] = 1
    })
end
local function ____Q_662F_5426_9501_5B9A_76EE_6807(state)
    return not state["空牙联动"] and state["目标单位"] ~= nil and state["目标单位"] ~= 0
end
local function _____8FC7_6EE4Q_5F39_5E55_76EE_6807(target, projectileId)
    local state = _____5F39_5E55_72B6_6001_8868[projectileId]
    if state == nil then
        return false
    end
    if ____Q_662F_5426_9501_5B9A_76EE_6807(state) then
        return target == state["目标单位"] and _____76EE_6807_5408_6CD5(state["施法者"], target)
    end
    return _____76EE_6807_5408_6CD5(state["施法者"], target)
end
local function _____64AD_653EQ_7206_70B8(caster, x, y, radius, damage, state)
    _____5728_5750_6807_64AD_653E_7279_6548(
        nil,
        _____914D_7F6E["爆炸模型"],
        x,
        y,
        0,
        _____914D_7F6E["爆炸缩放"],
        1.5
    )
    local targets = _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, radius)
    local validTargets = {}
    for ____, target in ipairs(targets) do
        if _____76EE_6807_5408_6CD5(caster, target) then
            validTargets[#validTargets + 1] = target
        end
    end
    if #validTargets == 0 then
        return
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = validTargets,
        ["伤害"] = damage,
        ["伤害类型"] = _____9B54_6CD5_4F24_5BB3_7C7B_578B,
        attack = true,
        ranged = false,
        attackType = _____653B_51FB_7C7B_578B,
        weaponType = _____672A_77E5_6B66_5668_7C7B_578B,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____521D_6BB5_6280_80FDID,
        ["技能实例ID"] = state["技能实例ID"],
        ["标签"] = "克劳德-Q-剑气爆炸"
    })
end
local function _____5904_7406Q_547D_4E2D(target, projectileId)
    local state = _____5F39_5E55_72B6_6001_8868[projectileId]
    if state == nil or not state["进行中"] then
        debugLogForce(
            _____6A21_5757_540D,
            "命中回调 状态无效",
            "弹幕ID",
            projectileId,
            "目标",
            target == nil and "nil" or _____83B7_53D6_53E5_67C4ID(target)
        )
        return
    end
    local caster = state["施法者"]
    debugLogForce(
        _____6A21_5757_540D,
        "命中回调进入",
        "弹幕ID",
        projectileId,
        "阶段",
        state["阶段"],
        "目标",
        target == nil and "nil" or _____83B7_53D6_53E5_67C4ID(target),
        "空牙联动",
        state["空牙联动"]
    )
    if not _____5355_4F4D_5B58_6D3B(caster) or not _____76EE_6807_5408_6CD5(caster, target) then
        debugLogForce(
            _____6A21_5757_540D,
            "命中回调 施法者或目标不合法",
            "施法者存活",
            _____5355_4F4D_5B58_6D3B(caster),
            "目标ID",
            target == nil and "nil" or _____83B7_53D6_53E5_67C4ID(target)
        )
        return
    end
    if state["空牙联动"] then
        _____65BD_52A0_7729_6655(
            caster,
            target,
            _____8054_52A8_914D_7F6E["空牙Q联动击飞秒"],
            "克劳德-空牙联动Q-击飞",
            "技能"
        )
        _____5F00_59CB_51FB_9000(target, {
            ["角度"] = state["空牙联动方向"],
            ["距离"] = _____8054_52A8_914D_7F6E["空牙Q联动击退距离"],
            ["持续时间"] = _____8054_52A8_914D_7F6E["空牙Q联动击飞秒"],
            ["检查地形"] = true,
            ["暂停单位"] = false,
            ["禁用碰撞"] = true,
            ["来源单位"] = caster
        })
        local armor = _____8BFB_53D6_76EE_6807_62A4_7532(target)
        if armor > 0 then
            _____65BD_52A0_5355_4F53_62A4_7532_964D_4F4EBuff(
                caster,
                target,
                {
                    BuffID = _____8054_52A8_914D_7F6E["空牙Q联动护甲BuffID"],
                    ["持续时间"] = _____8054_52A8_914D_7F6E["空牙Q联动护甲降低秒"],
                    ["护甲"] = armor * _____8054_52A8_914D_7F6E["空牙Q联动护甲降低比例"],
                    ["叠加键"] = "克劳德-空牙联动Q-" .. tostring(_____83B7_53D6_53E5_67C4ID(caster)),
                    ["效果来源名称"] = "克劳德-空牙联动Q",
                    ["效果来源类型"] = "技能"
                }
            )
        end
        return
    end
    if state["阶段"] == 0 then
        debugLogForce(
            _____6A21_5757_540D,
            "命中结算 初段",
            "目标",
            _____83B7_53D6_53E5_67C4ID(target),
            "施放击飞/爆炸"
        )
        _____65BD_52A0_7729_6655(
            caster,
            target,
            _____914D_7F6E["基础击飞秒"],
            "克劳德-Q-基础击飞",
            "技能"
        )
        _____542F_52A8Q_547D_4E2D_8868_73B0(
            caster,
            target,
            "初段上升",
            state["方向角"],
            _____914D_7F6E["初段升降间隔秒"]
        )
        _____5F00_59CB_51FB_9000(target, {
            ["角度"] = state["方向角"],
            ["距离"] = _____914D_7F6E["基础击飞距离"],
            ["持续时间"] = _____914D_7F6E["基础击飞秒"],
            ["检查地形"] = true,
            ["暂停单位"] = false,
            ["禁用碰撞"] = true,
            ["来源单位"] = caster
        })
        if state["目标单位"] ~= nil then
            local projectile = _____83B7_53D6_539F_751F_5F39_5E55(projectileId)
            if projectile ~= nil then
                _____64AD_653EQ_7206_70B8(
                    caster,
                    projectile["当前X"],
                    projectile["当前Y"],
                    _____914D_7F6E["指定目标爆炸范围"],
                    _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E["普通伤害倍率"],
                    state
                )
                _____9500_6BC1_539F_751F_5F39_5E55(projectileId, "命中消失")
            end
        end
    elseif state["阶段"] == 1 then
        debugLogForce(
            _____6A21_5757_540D,
            "命中结算 二段",
            "目标",
            _____83B7_53D6_53E5_67C4ID(target)
        )
        _____65BD_52A0_7729_6655(
            caster,
            target,
            _____914D_7F6E["二段控制秒"],
            "克劳德-Q-二段切割",
            "技能"
        )
        _____542F_52A8Q_547D_4E2D_8868_73B0(
            caster,
            target,
            "二段乱斩",
            state["方向角"],
            _____914D_7F6E["二段乱斩间隔秒"]
        )
    else
        debugLogForce(
            _____6A21_5757_540D,
            "命中结算 三段",
            "目标",
            _____83B7_53D6_53E5_67C4ID(target),
            "施放同方向跳跃击飞"
        )
        _____8BBE_7F6E_52A8_4F5C(target, 2)
        _____8BBE_7F6E_65F6_95F4_6D41_901F(target, _____914D_7F6E["命中动作速度"])
        _____5F00_59CB_8DF3_8DC3_4F5C_4E3A_88AB_51FB_9000_51FB_98DE(target, {
            ["角度"] = state["方向角"],
            ["距离"] = _____914D_7F6E["三段跳跃距离"],
            ["持续时间"] = _____914D_7F6E["三段跳跃持续秒"],
            ["跳跃高度"] = _____914D_7F6E["三段跳跃高度"],
            ["主单位"] = caster,
            ["主单位死亡时中断"] = true,
            ["暂停单位"] = true,
            ["朝向跟随跳跃"] = true
        })
    end
end
local function _____5904_7406Q_5230_8FBE_7EC8_70B9(projectileId)
    local state = _____5F39_5E55_72B6_6001_8868[projectileId]
    if state == nil or not state["进行中"] or state["阶段"] ~= 0 or state["空牙联动"] then
        debugLogForce(
            _____6A21_5757_540D,
            "到达终点 条件不符 忽略",
            "弹幕ID",
            projectileId,
            "状态存在",
            state ~= nil,
            "阶段",
            state and state["阶段"],
            "空牙联动",
            state and state["空牙联动"]
        )
        return
    end
    local projectile = _____83B7_53D6_539F_751F_5F39_5E55(projectileId)
    if projectile == nil then
        debugLogForce(_____6A21_5757_540D, "到达终点 弹幕对象不存在", "弹幕ID", projectileId)
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "到达终点 结算爆炸",
        "弹幕ID",
        projectileId,
        "X",
        projectile["当前X"],
        "Y",
        projectile["当前Y"]
    )
    _____64AD_653EQ_7206_70B8(
        state["施法者"],
        projectile["当前X"],
        projectile["当前Y"],
        state["目标单位"] ~= nil and _____914D_7F6E["指定目标爆炸范围"] or _____914D_7F6E["普通末端范围"],
        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(state["施法者"]) * _____914D_7F6E["普通伤害倍率"],
        state
    )
end
local function ____Q_5F39_5E55Tick(instance, _delta)
    local projectileId = instance.id
    local state = _____5F39_5E55_72B6_6001_8868[projectileId]
    if state == nil or not state["进行中"] or state["阶段"] ~= 2 then
        return
    end
    state["路径特效累计秒"] = state["路径特效累计秒"] + _delta
    if state["路径特效累计秒"] < _____914D_7F6E["路径特效间隔秒"] then
        return
    end
    state["路径特效累计秒"] = state["路径特效累计秒"] - _____914D_7F6E["路径特效间隔秒"]
    local _____5251_6C14_7279_6548 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["剑气模型"],
        X = instance["当前X"],
        Y = instance["当前Y"],
        Z = 0,
        ["缩放"] = _____914D_7F6E["强化缩放"]
    })
    if _____5251_6C14_7279_6548 ~= nil and _____5251_6C14_7279_6548 ~= 0 then
        YDWETimerDestroyEffectSafe(_____914D_7F6E["路径特效持续秒"], _____5251_6C14_7279_6548)
    end
    local _____9644_52A0_7279_6548 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E["路径附加模型"],
        X = instance["当前X"],
        Y = instance["当前Y"],
        Z = 0,
        ["缩放"] = _____914D_7F6E["路径附加缩放"]
    })
    if _____9644_52A0_7279_6548 ~= nil and _____9644_52A0_7279_6548 ~= 0 then
        YDWETimerDestroyEffectSafe(_____914D_7F6E["路径特效持续秒"], _____9644_52A0_7279_6548)
    end
end
local function _____6E05_7406Q_65BD_6CD5_786C_76F4(state)
    if state["施法硬直回调ID"] ~= 0 then
        removeDelayedCallback(state["施法硬直回调ID"])
        state["施法硬直回调ID"] = 0
    end
    state["施法硬直代次"] = 0
    if state["施法者"] ~= nil and state["施法者"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(state["施法者"], _____65BD_6CD5_6682_505C_6765_6E90)
    end
end
local function _____6E05_7406Q_72B6_6001(state, _____4FDD_7559_65BD_6CD5_786C_76F4)
    if _____4FDD_7559_65BD_6CD5_786C_76F4 == nil then
        _____4FDD_7559_65BD_6CD5_786C_76F4 = false
    end
    if not state["进行中"] then
        if not _____4FDD_7559_65BD_6CD5_786C_76F4 then
            _____6E05_7406Q_65BD_6CD5_786C_76F4(state)
        end
        return
    end
    state["进行中"] = false
    state["等待输入"] = false
    state["代次"] = state["代次"] + 1
    local caster = state["施法者"]
    debugLogForce(
        _____6A21_5757_540D,
        "清理Q状态",
        "施法者",
        (caster == nil or caster == 0) and "nil" or _____83B7_53D6_53E5_67C4ID(caster),
        "阶段",
        state["阶段"],
        "弹幕ID",
        state["弹幕ID"]
    )
    if state["蓄力回调ID"] ~= 0 then
        removeDelayedCallback(state["蓄力回调ID"])
        state["蓄力回调ID"] = 0
    end
    if not _____4FDD_7559_65BD_6CD5_786C_76F4 then
        _____6E05_7406Q_65BD_6CD5_786C_76F4(state)
    end
    if state["弹幕ID"] ~= 0 then
        local projectileId = state["弹幕ID"]
        state["弹幕ID"] = 0
        __TS__Delete(_____5F39_5E55_72B6_6001_8868, projectileId)
        if _____83B7_53D6_539F_751F_5F39_5E55(projectileId) ~= nil then
            _____9500_6BC1_539F_751F_5F39_5E55(projectileId, "手动销毁")
        end
    end
    if caster ~= nil and caster ~= 0 then
        if state["蓄力站桩中"] then
            X_SetUnitMovableSafe(caster, true)
        end
        if not _____4FDD_7559_65BD_6CD5_786C_76F4 then
            _____79FB_9664_5355_4F4D_6682_505C(caster, _____65BD_6CD5_6682_505C_6765_6E90)
        end
        _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, 1)
        _____8BBE_7F6E_6280_80FD_53EF_7528(
            _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
            _____521D_6BB5_6280_80FDID,
            true
        )
        _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
        _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
        _____8BBE_7F6E_6280_80FD_53EF_7528(
            _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
            _____4E8C_6BB5_6280_80FDID,
            false
        )
        _____8BBE_7F6E_6280_80FD_53EF_7528(
            _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
            _____4E09_6BB5_6280_80FDID,
            false
        )
    end
    state["蓄力站桩中"] = false
    state["追加输入次数"] = 0
    state["阶段"] = 0
    state["技能实例ID"] = nil
    state["空牙联动"] = false
    state["空牙联动方向"] = 0
end
local function ____Q_65BD_6CD5_786C_76F4_7ED3_675F(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil then
        return
    end
    local state = _____53C2_6570["状态"]
    if state["施法硬直代次"] ~= _____53C2_6570["代次"] then
        return
    end
    state["施法硬直回调ID"] = 0
    state["施法硬直代次"] = 0
    if state["施法者"] == nil or state["施法者"] == 0 then
        return
    end
    _____79FB_9664_5355_4F4D_6682_505C(state["施法者"], _____65BD_6CD5_6682_505C_6765_6E90)
    debugLogForce(
        _____6A21_5757_540D,
        "Q施法硬直结束",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(state["施法者"]),
        "阶段",
        state["阶段"],
        "追加输入次数",
        state["追加输入次数"]
    )
end
local function ____Q_5F39_5E55_7ED3_675F(_reason, projectileId)
    local state = _____5F39_5E55_72B6_6001_8868[projectileId]
    __TS__Delete(_____5F39_5E55_72B6_6001_8868, projectileId)
    debugLogForce(
        _____6A21_5757_540D,
        "Q弹幕结束",
        "弹幕ID",
        projectileId,
        "原因",
        _reason,
        "状态存在",
        state ~= nil
    )
    if state == nil then
        return
    end
    state["弹幕ID"] = 0
    if not state["等待输入"] then
        _____6E05_7406Q_72B6_6001(state, state["施法硬直回调ID"] ~= 0)
    end
end
local function _____53D1_5C04Q(state)
    if not state["进行中"] or not _____5355_4F4D_5B58_6D3B(state["施法者"]) then
        debugLogForce(
            _____6A21_5757_540D,
            "发射Q 前置不满足 清理",
            "进行中",
            state["进行中"],
            "施法者存活",
            _____5355_4F4D_5B58_6D3B(state["施法者"])
        )
        _____6E05_7406Q_72B6_6001(state)
        return
    end
    local caster = state["施法者"]
    local startX = _____83B7_53D6_5355_4F4DX(caster) + _____8BA1_7B97_4F59_5F26(state["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["发射起点偏移"]
    local startY = _____83B7_53D6_5355_4F4DY(caster) + _____8BA1_7B97_6B63_5F26(state["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____914D_7F6E["发射起点偏移"]
    local _____9501_5B9A_76EE_6807 = ____Q_662F_5426_9501_5B9A_76EE_6807(state)
    local targeted = _____9501_5B9A_76EE_6807 and _____76EE_6807_5408_6CD5(caster, state["目标单位"])
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (state["空牙联动"] and _____8054_52A8_914D_7F6E["空牙Q联动伤害倍率"] or (state["阶段"] == 0 and _____914D_7F6E["普通伤害倍率"] or (state["阶段"] == 1 and _____914D_7F6E["二段伤害倍率"] or _____914D_7F6E["三段伤害倍率"])))
    debugLogForce(
        _____6A21_5757_540D,
        "发射Q",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "阶段",
        state["阶段"],
        "追加输入次数",
        state["追加输入次数"],
        "空牙联动",
        state["空牙联动"],
        "锁定目标",
        _____9501_5B9A_76EE_6807,
        "追踪目标",
        targeted,
        "方向角",
        state["方向角"],
        "伤害",
        damage
    )
    _____64AD_653EQ_97F3_6548(caster, state["空牙联动"] or state["阶段"] > 0)
    if state["施法硬直回调ID"] ~= 0 then
        _____6E05_7406Q_65BD_6CD5_786C_76F4(state)
    end
    local _____65BD_6CD5_6682_505C_6210_529F = _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____65BD_6CD5_6682_505C_6765_6E90)
    _____8BBE_7F6E_52A8_4F5C(caster, state["空牙联动"] and _____914D_7F6E["强化动作索引"] or (state["阶段"] == 0 and _____914D_7F6E["初段动作索引"] or _____914D_7F6E["强化动作索引"]))
    state["施法硬直代次"] = state["代次"]
    state["施法硬直回调ID"] = addDelayedCallback(_____914D_7F6E["施法硬直秒"] * 1000, ____Q_65BD_6CD5_786C_76F4_7ED3_675F, {["状态"] = state, ["代次"] = state["代次"]})
    debugLogForce(
        _____6A21_5757_540D,
        "Q正式发射施法硬直",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "暂停成功",
        _____65BD_6CD5_6682_505C_6210_529F,
        "阶段",
        state["阶段"],
        "追加输入次数",
        state["追加输入次数"]
    )
    local ____521B_5EFA_539F_751F_5F39_5E55_38 = _____521B_5EFA_539F_751F_5F39_5E55
    local ____state__65B9_5411_89D2_26 = state["方向角"]
    local ____914D_7F6E__98DE_884C_901F_5EA6_27 = _____914D_7F6E["飞行速度"]
    local ____914D_7F6E__751F_547D_5468_671F_79D2_28 = _____914D_7F6E["生命周期秒"]
    local ____914D_7F6E__6700_5927_8DDD_79BB_29 = _____914D_7F6E["最大距离"]
    local ____temp_30 = state["阶段"] == 2 and _____914D_7F6E["三段碰撞半径"] or (targeted and _____914D_7F6E["指定目标碰撞半径"] or _____914D_7F6E["普通碰撞半径"])
    local ____temp_31 = not state["空牙联动"] and state["阶段"] == 0 and targeted
    local ____temp_32 = state["阶段"] == 0 and _____914D_7F6E["初段缩放"] or _____914D_7F6E["强化缩放"]
    local ____temp_33 = state["阶段"] <= 1 and ({["模型"] = _____914D_7F6E["剑气模型"], ["缩放"] = _____914D_7F6E["初段缩放"]}) or nil
    local ____state__7A7A_7259_8054_52A8_24
    if state["空牙联动"] then
        ____state__7A7A_7259_8054_52A8_24 = _____666E_901A_4F24_5BB3_7C7B_578B
    else
        ____state__7A7A_7259_8054_52A8_24 = _____9B54_6CD5_4F24_5BB3_7C7B_578B
    end
    local ____state__6280_80FD_5B9E_4F8BID_34 = state["技能实例ID"]
    local ____temp_35 = state["空牙联动"] and "克劳德-空牙联动Q" or "克劳德-Q-剑气"
    local ____temp_36 = state["阶段"] == 1 and _____9501_5B9A_76EE_6807 and "单体" or "AOE"
    local ____temp_37 = targeted and "追踪" or "直线"
    local ____targeted_25
    if targeted then
        ____targeted_25 = state["目标单位"]
    else
        ____targeted_25 = nil
    end
    local projectile = ____521B_5EFA_539F_751F_5F39_5E55_38({
        ["所有者"] = caster,
        ["载体模式"] = "特效",
        X = startX,
        Y = startY,
        ["方向角"] = ____state__65B9_5411_89D2_26,
        ["速度"] = ____914D_7F6E__98DE_884C_901F_5EA6_27,
        ["生命周期"] = ____914D_7F6E__751F_547D_5468_671F_79D2_28,
        ["最大距离"] = ____914D_7F6E__6700_5927_8DDD_79BB_29,
        ["命中半径"] = ____temp_30,
        ["影响目标"] = "敌方",
        ["每单位最大命中次数"] = 1,
        ["碰撞消失"] = ____temp_31,
        ["不可阻挡"] = true,
        ["缩放"] = ____temp_32,
        ["附加特效1"] = ____temp_33,
        ["伤害值"] = damage,
        ["伤害类型"] = ____state__7A7A_7259_8054_52A8_24,
        attack = true,
        ["攻击类型"] = _____653B_51FB_7C7B_578B,
        ["武器类型"] = _____672A_77E5_6B66_5668_7C7B_578B,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____521D_6BB5_6280_80FDID,
        ["技能实例ID"] = ____state__6280_80FD_5B9E_4F8BID_34,
        ["技能标签"] = ____temp_35,
        ["伤害形态"] = ____temp_36,
        ["轨迹类型"] = ____temp_37,
        ["指定目标"] = ____targeted_25,
        ["目标筛选"] = _____8FC7_6EE4Q_5F39_5E55_76EE_6807,
        ["on命中"] = _____5904_7406Q_547D_4E2D,
        onTick = ____Q_5F39_5E55Tick,
        ["on到达目标点"] = _____5904_7406Q_5230_8FBE_7EC8_70B9,
        ["on结束"] = ____Q_5F39_5E55_7ED3_675F
    })
    state["弹幕ID"] = projectile["弹幕ID"]
    _____5F39_5E55_72B6_6001_8868[projectile["弹幕ID"]] = state
end
local function ____Q_84C4_529B_5B8C_6210(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil then
        return
    end
    local state = _____53C2_6570["状态"]
    debugLogForce(
        _____6A21_5757_540D,
        "Q蓄力完成",
        "进行中",
        state["进行中"],
        "阶段",
        state["阶段"],
        "追加输入次数",
        state["追加输入次数"],
        "代次",
        _____53C2_6570["代次"],
        "当前代次",
        state["代次"]
    )
    if not state["进行中"] or state["代次"] ~= _____53C2_6570["代次"] then
        return
    end
    state["蓄力回调ID"] = 0
    state["等待输入"] = false
    local caster = state["施法者"]
    if state["蓄力站桩中"] then
        state["蓄力站桩中"] = false
        X_SetUnitMovableSafe(caster, true)
    end
    _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____4E8C_6BB5_6280_80FDID,
        false
    )
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____4E09_6BB5_6280_80FDID,
        false
    )
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, 1)
    _____53D1_5C04Q(state)
end
local function _____6D88_8017Q_8FFD_52A0_9B54_6CD5(caster)
    local maxMana = _____83B7_53D6_5355_4F4D_72B6_6001(caster, _____6700_5927_9B54_6CD5_72B6_6001) or 0
    local cost = maxMana * 0.1
    local mana = _____83B7_53D6_5355_4F4D_72B6_6001(caster, _____5F53_524D_9B54_6CD5_72B6_6001) or 0
    debugLogForce(
        _____6A21_5757_540D,
        "Q追加魔耗判断",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "需求",
        cost,
        "当前蓝",
        mana
    )
    if cost <= 0 or mana < cost then
        debugLogForce(
            _____6A21_5757_540D,
            "Q追加魔耗不足 返回false",
            "需求",
            cost,
            "当前蓝",
            mana
        )
        return false
    end
    _____51CF_5C11_9B54_6CD5_503C(caster, cost, false, false)
    return true
end
local function _____91CA_653EQ_521D_6BB5(state, caster, skillInstanceId)
    debugLogForce(
        _____6A21_5757_540D,
        "释放Q初段 进入",
        "施法者",
        caster == nil and "nil" or _____83B7_53D6_53E5_67C4ID(caster),
        "已在进行",
        state["进行中"],
        "追加输入次数",
        state["追加输入次数"],
        "技能实例ID",
        skillInstanceId
    )
    if state["进行中"] then
        return
    end
    _____6E05_7406Q_65BD_6CD5_786C_76F4(state)
    state["施法者"] = caster
    state["代次"] = state["代次"] + 1
    local _____5F53_524D_4EE3_6B21 = state["代次"]
    local _____7A7A_7259_8054_52A8 = _____6D88_8017_7A7A_7259Q_8054_52A8(caster)
    if _____7A7A_7259_8054_52A8 ~= nil then
        state["阶段"] = 2
        state["进行中"] = true
        state["等待输入"] = false
        state["蓄力站桩中"] = false
        state["目标单位"] = nil
        state["目标X"] = _____83B7_53D6_5355_4F4DX(caster) + _____8BA1_7B97_4F59_5F26(_____7A7A_7259_8054_52A8["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____8054_52A8_914D_7F6E["冲锋距离"]
        state["目标Y"] = _____83B7_53D6_5355_4F4DY(caster) + _____8BA1_7B97_6B63_5F26(_____7A7A_7259_8054_52A8["方向角"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____8054_52A8_914D_7F6E["冲锋距离"]
        state["方向角"] = _____7A7A_7259_8054_52A8["方向角"]
        state["技能实例ID"] = skillInstanceId
        state["空牙联动"] = true
        state["空牙联动方向"] = _____7A7A_7259_8054_52A8["方向角"]
        debugLogForce(
            _____6A21_5757_540D,
            "释放Q初段 走空牙联动",
            "方向角",
            _____7A7A_7259_8054_52A8["方向角"],
            "目标X",
            state["目标X"],
            "目标Y",
            state["目标Y"]
        )
        state["蓄力回调ID"] = addDelayedCallback(10, ____Q_84C4_529B_5B8C_6210, {["状态"] = state, ["代次"] = _____5F53_524D_4EE3_6B21})
        return
    end
    state["空牙联动"] = false
    state["空牙联动方向"] = 0
    state["阶段"] = 0
    state["追加输入次数"] = 0
    state["进行中"] = true
    state["等待输入"] = true
    state["目标单位"] = _____83B7_53D6_6280_80FD_76EE_6807_5355_4F4D()
    state["目标X"] = _____83B7_53D6_6280_80FD_76EE_6807X()
    state["目标Y"] = _____83B7_53D6_6280_80FD_76EE_6807Y()
    state["方向角"] = _____4E24_70B9_89D2_5EA6(
        _____83B7_53D6_5355_4F4DX(caster),
        _____83B7_53D6_5355_4F4DY(caster),
        state["目标X"],
        state["目标Y"]
    )
    if state["目标单位"] ~= nil and _____76EE_6807_5408_6CD5(caster, state["目标单位"]) then
        state["目标X"] = _____83B7_53D6_5355_4F4DX(state["目标单位"])
        state["目标Y"] = _____83B7_53D6_5355_4F4DY(state["目标单位"])
        state["方向角"] = _____4E24_70B9_89D2_5EA6(
            _____83B7_53D6_5355_4F4DX(caster),
            _____83B7_53D6_5355_4F4DY(caster),
            state["目标X"],
            state["目标Y"]
        )
    else
        state["目标单位"] = nil
    end
    debugLogForce(
        _____6A21_5757_540D,
        "释放Q初段 正常路径",
        "目标单位",
        state["目标单位"] == nil and "nil" or _____83B7_53D6_53E5_67C4ID(state["目标单位"]),
        "目标X",
        state["目标X"],
        "目标Y",
        state["目标Y"],
        "方向角",
        state["方向角"]
    )
    state["技能实例ID"] = skillInstanceId
    state["路径特效累计秒"] = 0
    local owner = _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster)
    _____8BBE_7F6E_6280_80FD_53EF_7528(owner, _____521D_6BB5_6280_80FDID, false)
    _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
    _____6DFB_52A0_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    _____8BBE_7F6E_6280_80FD_53EF_7528(owner, _____4E8C_6BB5_6280_80FDID, true)
    _____8BBE_7F6E_6280_80FD_53EF_7528(owner, _____4E09_6BB5_6280_80FDID, false)
    state["蓄力站桩中"] = true
    X_SetUnitMovableSafe(caster, false)
    _____8BBE_7F6E_65F6_95F4_6D41_901F(caster, 2)
    state["蓄力回调ID"] = addDelayedCallback(_____914D_7F6E["蓄力秒"] * 1000, ____Q_84C4_529B_5B8C_6210, {["状态"] = state, ["代次"] = _____5F53_524D_4EE3_6B21})
end
local function _____91CA_653EQ_4E8C_6BB5(state, caster)
    debugLogForce(
        _____6A21_5757_540D,
        "释放Q二段 进入",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "技能ID",
        _____4E8C_6BB5_6280_80FDID,
        "进行中",
        state["进行中"],
        "阶段",
        state["阶段"],
        "追加输入次数",
        state["追加输入次数"]
    )
    if not state["进行中"] or not state["等待输入"] or state["阶段"] ~= 0 or not _____6D88_8017Q_8FFD_52A0_9B54_6CD5(caster) then
        return
    end
    state["阶段"] = 1
    state["追加输入次数"] = state["追加输入次数"] + 1
    _____64AD_653EQ_84C4_529B_8868_73B0(caster, 1)
    debugLogForce(
        _____6A21_5757_540D,
        "释放Q二段 成功进入阶段1",
        "实际追加输入次数",
        state["追加输入次数"],
        "阶段",
        state["阶段"]
    )
    _____79FB_9664_6280_80FD(caster, _____4E8C_6BB5_6280_80FDID)
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____4E8C_6BB5_6280_80FDID,
        false
    )
    _____6DFB_52A0_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____4E09_6BB5_6280_80FDID,
        true
    )
end
local function _____91CA_653EQ_4E09_6BB5(state, caster)
    debugLogForce(
        _____6A21_5757_540D,
        "释放Q三段 进入",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(caster),
        "技能ID",
        _____4E09_6BB5_6280_80FDID,
        "进行中",
        state["进行中"],
        "阶段",
        state["阶段"],
        "追加输入次数",
        state["追加输入次数"]
    )
    if not state["进行中"] or not state["等待输入"] or state["阶段"] ~= 1 or not _____6D88_8017Q_8FFD_52A0_9B54_6CD5(caster) then
        return
    end
    state["阶段"] = 2
    state["追加输入次数"] = state["追加输入次数"] + 1
    state["等待输入"] = false
    _____64AD_653EQ_84C4_529B_8868_73B0(caster, 2)
    debugLogForce(
        _____6A21_5757_540D,
        "释放Q三段 成功进入阶段2",
        "实际追加输入次数",
        state["追加输入次数"],
        "阶段",
        state["阶段"]
    )
    _____79FB_9664_6280_80FD(caster, _____4E09_6BB5_6280_80FDID)
    _____8BBE_7F6E_6280_80FD_53EF_7528(
        _____83B7_53D6_5355_4F4D_62E5_6709_8005(caster),
        _____4E09_6BB5_6280_80FDID,
        false
    )
end
local function ____Q_521D_6BB5_53EF_91CA_653E(state, _caster)
    return not state["进行中"]
end
local function ____Q_4E8C_6BB5_53EF_91CA_653E(state, _caster)
    return state["进行中"] and state["等待输入"] and state["阶段"] == 0
end
local function ____Q_4E09_6BB5_53EF_91CA_653E(state, _caster)
    return state["进行中"] and state["等待输入"] and state["阶段"] == 1
end
local function _____514B_52B3_5FB7Q_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 or _____83B7_53D6_5355_4F4D_7C7B_578BID(dyingUnit) ~= _____5355_4F4D_7C7B_578BID then
        return
    end
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(dyingUnit)]
    debugLogForce(
        _____6A21_5757_540D,
        "克劳德Q死亡清理",
        "死亡单位",
        _____83B7_53D6_53E5_67C4ID(dyingUnit),
        "状态存在",
        state ~= nil
    )
    if state ~= nil then
        _____6E05_7406Q_72B6_6001(state)
    end
end
local function _____8BB0_5F55_514B_52B3_5FB7Q_6280_80FD_4E8B_4EF6(castingUnit, spellAbilityId)
    if castingUnit == nil or castingUnit == 0 or _____83B7_53D6_5355_4F4D_7C7B_578BID(castingUnit) ~= _____5355_4F4D_7C7B_578BID then
        return
    end
    if spellAbilityId ~= _____521D_6BB5_6280_80FDID and spellAbilityId ~= _____4E8C_6BB5_6280_80FDID and spellAbilityId ~= _____4E09_6BB5_6280_80FDID then
        return
    end
    local state = _____72B6_6001_8868[_____83B7_53D6_53E5_67C4ID(castingUnit)]
    debugLogForce(
        _____6A21_5757_540D,
        "技能事件诊断",
        "实际技能ID",
        spellAbilityId,
        "预期初段ID",
        _____521D_6BB5_6280_80FDID,
        "预期二段ID",
        _____4E8C_6BB5_6280_80FDID,
        "预期三段ID",
        _____4E09_6BB5_6280_80FDID,
        "阶段",
        state and state["阶段"],
        "等待输入",
        state and state["等待输入"],
        "追加输入次数",
        state and state["追加输入次数"]
    )
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-破晃击",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____521D_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAQ_72B6_6001,
    ["可释放"] = ____Q_521D_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653EQ_521D_6BB5,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 3
})
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-破晃击二段",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____4E8C_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAQ_72B6_6001,
    ["可释放"] = ____Q_4E8C_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653EQ_4E8C_6BB5,
    ["创建独立技能实例"] = false
})
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "克劳德-破晃击三段",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = _____4E09_6BB5_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAQ_72B6_6001,
    ["可释放"] = ____Q_4E09_6BB5_53EF_91CA_653E,
    ["释放技能"] = _____91CA_653EQ_4E09_6BB5,
    ["创建独立技能实例"] = false
})
registerDeathListener(_____514B_52B3_5FB7Q_6B7B_4EA1_6E05_7406)
registerSpellEffectListener(_____8BB0_5F55_514B_52B3_5FB7Q_6280_80FD_4E8B_4EF6)
return ____exports
