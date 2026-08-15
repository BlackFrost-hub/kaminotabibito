local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.00．配置")
local _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["鹿目圆单位技能配置"]
local ____01_FF0E_72B6_6001_4E0E_88AB_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.01．状态与被动")
local _____662F_9E7F_76EE_5706 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["是鹿目圆"]
local _____662F_9E7F_76EE_5706_5706_795E = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["是鹿目圆圆神"]
local _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆伤害无视魔抗"]
local _____9E7F_76EE_5706_6CBB_7597_53CB_519B = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆治疗友军"]
local _____6D88_8017_9E7F_76EE_5706W_7ACB_5373_6EE1_84C4_6807_8BB0 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["消耗鹿目圆W立即满蓄标记"]
local _____6D88_8017_9E7F_76EE_5706_5706_73AF_5F3A_5316 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["消耗鹿目圆圆环强化"]
local ____10_FF0E_9E7F_76EE_5706 = require("系统.05．Buff系统.03．Buff表.02．英雄.10．鹿目圆")
local _____9E7F_76EE_5706BuffID = ____10_FF0E_9E7F_76EE_5706["鹿目圆BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local _____5145_80FD_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = _____5145_80FD_7CFB_7EDF["开始充能"]
local _____505C_6B62_5145_80FD = _____5145_80FD_7CFB_7EDF["停止充能"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_2["结束独立技能伤害实例"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_3["创建单位并登记排泄安全"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_4.getUnitsInRange
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_5["两点角度"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_6.createTimedUnitEffect
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitState = jass.GetUnitState
local GetUnitMoveSpeed = jass.GetUnitMoveSpeed
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local SetUnitMoveSpeed = jass.SetUnitMoveSpeed
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitScale = jass.SetUnitScale
local RemoveUnit = jass.RemoveUnit
local IsUnitType = jass.IsUnitType
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitAlly = jass.IsUnitAlly
local Cos = jass.Cos
local Sin = jass.Sin
local ____jass_bj_DEGTORAD_7 = jass.bj_DEGTORAD
if ____jass_bj_DEGTORAD_7 == nil then
    ____jass_bj_DEGTORAD_7 = 0.017453292519943295
end
local bj_DEGTORAD = ____jass_bj_DEGTORAD_7
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____914D_7F6E = _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E
local ____W_84C4_529B_4E0A_4E0B_6587_8868 = {}
local ____W_5F85_53D1_7248_672C = 0
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____53D6_5355_4F4DID(unit)
    return (unit == nil or unit == 0) and 0 or GetHandleId(unit)
end
local function _____79FB_9664_5355_4F4D_58F3(unit)
    if unit ~= nil and unit ~= 0 then
        RemoveUnit(unit)
    end
end
local function _____5207_6362W_6280_80FD(hero, _____53EF_53D1_5C04)
    if hero == nil or hero == 0 then
        return
    end
    local owner = GetOwningPlayer(hero)
    SetPlayerAbilityAvailable(owner, _____914D_7F6E["技能"]["W蓄力"]["类型ID"], not _____53EF_53D1_5C04)
    SetPlayerAbilityAvailable(owner, _____914D_7F6E["技能"]["W发射"]["类型ID"], _____53EF_53D1_5C04)
end
local function _____6E05_7406W_84C4_529B_4E0A_4E0B_6587(context)
    if context["阶段"] == "结束" then
        return
    end
    context["阶段"] = "结束"
    local chargeId = context["充能ID"]
    context["充能ID"] = 0
    if chargeId ~= 0 then
        _____505C_6B62_5145_80FD(chargeId)
    end
    _____79FB_9664_5355_4F4D_58F3(context["蓄力箭"])
    context["蓄力箭"] = nil
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____9E7F_76EE_5706BuffID["因果之矢蓄力"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____9E7F_76EE_5706BuffID["因果之矢待发"])
    if context["施法者"] ~= nil and context["施法者"] ~= 0 then
        SetUnitMoveSpeed(context["施法者"], context["原移动速度"])
        _____5207_6362W_6280_80FD(context["施法者"], false)
    end
    local id = _____53D6_5355_4F4DID(context["施法者"])
    if id ~= 0 and ____W_84C4_529B_4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(____W_84C4_529B_4E0A_4E0B_6587_8868, id)
    end
end
local function ____W_5F85_53D1_5230_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    local context = data.context
    if context["阶段"] ~= "待发" or context["待发版本"] ~= data.version then
        return
    end
    _____6E05_7406W_84C4_529B_4E0A_4E0B_6587(context)
end
local function _____5237_65B0W_84C4_529B_8868_73B0(context)
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) or not _____5355_4F4D_5B58_6D3B(context["蓄力箭"]) then
        return
    end
    local full = _____914D_7F6E.W["满蓄力秒"]
    local progress = context["已蓄力秒"] >= full and 1 or context["已蓄力秒"] / full
    local scale = _____914D_7F6E.W["蓄力箭基础缩放"] + (_____914D_7F6E.W["蓄力箭满蓄力缩放"] - _____914D_7F6E.W["蓄力箭基础缩放"]) * progress
    SetUnitX(
        context["蓄力箭"],
        GetUnitX(context["施法者"])
    )
    SetUnitY(
        context["蓄力箭"],
        GetUnitY(context["施法者"])
    )
    SetUnitFacing(
        context["蓄力箭"],
        GetUnitFacing(context["施法者"])
    )
    SetUnitFlyHeight(
        context["蓄力箭"],
        _____662F_9E7F_76EE_5706_5706_795E(context["施法者"]) and _____914D_7F6E.W["圆神蓄力箭高度"] or _____914D_7F6E.W["蓄力箭高度"],
        0
    )
    SetUnitScale(context["蓄力箭"], scale, scale, scale)
end
local function ____W_5145_80FD_5468_671F(unit, chargeId, elapsed)
    local context = ____W_84C4_529B_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(unit)]
    if context == nil or context["充能ID"] ~= chargeId or context["阶段"] ~= "蓄力" then
        return
    end
    context["已蓄力秒"] = context["立即满蓄"] and _____914D_7F6E.W["满蓄力秒"] or elapsed
    if context["已蓄力秒"] >= _____914D_7F6E.W["最低蓄力秒"] then
        _____5207_6362W_6280_80FD(unit, true)
    end
    _____5237_65B0W_84C4_529B_8868_73B0(context)
end
local function ____W_5145_80FD_5B8C_6210(unit, chargeId)
    local context = ____W_84C4_529B_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(unit)]
    if context == nil or context["充能ID"] ~= chargeId or context["阶段"] ~= "蓄力" then
        return
    end
    context["充能ID"] = 0
    context["已蓄力秒"] = _____914D_7F6E.W["满蓄力秒"]
    context["阶段"] = "待发"
    ____W_5F85_53D1_7248_672C = ____W_5F85_53D1_7248_672C + 1
    context["待发版本"] = ____W_5F85_53D1_7248_672C
    _____5237_65B0W_84C4_529B_8868_73B0(context)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____9E7F_76EE_5706BuffID["因果之矢蓄力"])
    registerManualBuff(
        unit,
        _____9E7F_76EE_5706BuffID["因果之矢待发"],
        _____914D_7F6E.W["满蓄力后保留秒"],
        1,
        {sourceUnit = unit, effectSourceName = "因果之矢", effectSourceType = "技能"}
    )
    _____5207_6362W_6280_80FD(unit, true)
    addDelayedCallback(_____914D_7F6E.W["满蓄力后保留秒"] * 1000, ____W_5F85_53D1_5230_671F, {context = context, version = context["待发版本"]})
end
local function ____W_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local context = ____W_84C4_529B_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(unit)]
    if context == nil or context["充能ID"] ~= chargeId then
        return
    end
    context["充能ID"] = 0
    if reason == "完成" or context["阶段"] == "发射中" or context["阶段"] == "结束" then
        return
    end
    _____6E05_7406W_84C4_529B_4E0A_4E0B_6587(context)
end
local function _____83B7_53D6W_84C4_529B_5165_53E3(hero)
    return _____662F_9E7F_76EE_5706(hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653EW_84C4_529B(_entry, caster)
    if not _____5355_4F4D_5B58_6D3B(caster) or not _____662F_9E7F_76EE_5706(caster) then
        return
    end
    local id = _____53D6_5355_4F4DID(caster)
    local old = ____W_84C4_529B_4E0A_4E0B_6587_8868[id]
    if old ~= nil then
        _____6E05_7406W_84C4_529B_4E0A_4E0B_6587(old)
    end
    local arrow = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        GetOwningPlayer(caster),
        _____914D_7F6E["单位壳"]["W蓄力箭"],
        GetUnitX(caster),
        GetUnitY(caster),
        GetUnitFacing(caster)
    )
    if arrow == nil or arrow == 0 then
        return
    end
    local immediate = _____6D88_8017_9E7F_76EE_5706W_7ACB_5373_6EE1_84C4_6807_8BB0(caster)
    local context = {
        ["施法者"] = caster,
        ["阶段"] = "蓄力",
        ["充能ID"] = 0,
        ["原移动速度"] = GetUnitMoveSpeed(caster),
        ["蓄力箭"] = arrow,
        ["已蓄力秒"] = immediate and _____914D_7F6E.W["满蓄力秒"] or 0,
        ["立即满蓄"] = immediate,
        ["待发版本"] = 0
    }
    ____W_84C4_529B_4E0A_4E0B_6587_8868[id] = context
    SetUnitMoveSpeed(caster, _____914D_7F6E.W["蓄力移动速度"])
    _____5207_6362W_6280_80FD(caster, immediate)
    _____5237_65B0W_84C4_529B_8868_73B0(context)
    registerManualBuff(
        caster,
        _____9E7F_76EE_5706BuffID["因果之矢蓄力"],
        immediate and 0.1 or _____914D_7F6E.W["满蓄力秒"],
        1,
        {sourceUnit = caster, effectSourceName = "因果之矢", effectSourceType = "技能"}
    )
    do
        local i = 0
        while i < #_____914D_7F6E.W["起手特效"] do
            createTimedUnitEffect(caster, "origin", _____914D_7F6E.W["起手特效"][i + 1], 1)
            i = i + 1
        end
    end
    context["充能ID"] = _____5F00_59CB_5145_80FD(caster, {
        ["持续时间"] = immediate and 0.02 or _____914D_7F6E.W["满蓄力秒"],
        ["强制硬直"] = false,
        ["指令中断"] = false,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = _____914D_7F6E.W["周期间隔毫秒"] / 1000,
        ["周期回调"] = ____W_5145_80FD_5468_671F,
        ["充能完成回调"] = ____W_5145_80FD_5B8C_6210,
        ["结束回调"] = ____W_5145_80FD_7ED3_675F
    })
    if context["充能ID"] == 0 then
        _____6E05_7406W_84C4_529B_4E0A_4E0B_6587(context)
    end
end
local function _____662FW_5408_6CD5_78B0_649E_5355_4F4D(unit)
    return _____5355_4F4D_5B58_6D3B(unit) and IsUnitType(unit, UNIT_TYPE_MECHANICAL) ~= true and IsUnitType(unit, UNIT_TYPE_ANCIENT) ~= true
end
local function _____7ED3_675FW_5F39_9053(context)
    if context["周期ID"] ~= 0 then
        removePeriodicCallback(context["周期ID"])
        context["周期ID"] = 0
    end
    _____79FB_9664_5355_4F4D_58F3(context["箭单位"])
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
end
local function _____63A8_8FDBW_5F39_9053(variable)
    local context = variable
    if context == nil then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["箭单位"]) or context["剩余Tick"] <= 0 then
        _____7ED3_675FW_5F39_9053(context)
        return
    end
    local radians = context["方向"] * bj_DEGTORAD
    local x = GetUnitX(context["箭单位"]) + Cos(radians) * _____914D_7F6E.W["弹道步长"]
    local y = GetUnitY(context["箭单位"]) + Sin(radians) * _____914D_7F6E.W["弹道步长"]
    SetUnitX(context["箭单位"], x)
    SetUnitY(context["箭单位"], y)
    context["剩余Tick"] = context["剩余Tick"] - 1
    local owner = GetOwningPlayer(context["施法者"])
    local targets = getUnitsInRange(x, y, _____914D_7F6E.W["碰撞半径"])
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if target == context["施法者"] or not _____662FW_5408_6CD5_78B0_649E_5355_4F4D(target) then
                    goto __continue41
                end
                local targetId = _____53D6_5355_4F4DID(target)
                if context["已命中"][targetId] == true then
                    goto __continue41
                end
                if IsUnitEnemy(target, owner) == true then
                    context["已命中"][targetId] = true
                    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                        ["来源"] = context["施法者"],
                        ["目标"] = target,
                        ["伤害"] = context["伤害"],
                        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                        attack = true,
                        ranged = true,
                        attackType = ATTACK_TYPE_NORMAL,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "单位技能",
                        ["技能ID"] = _____914D_7F6E["技能"]["W发射"]["类型ID"],
                        ["技能实例ID"] = context["技能实例ID"],
                        ["标签"] = "鹿目圆-W-因果之矢",
                        ["参与技能伤害加成"] = true,
                        ["忽略魔法抗性"] = context["忽略魔抗"]
                    })
                elseif IsUnitAlly(target, owner) == true then
                    context["已命中"][targetId] = true
                    _____9E7F_76EE_5706_6CBB_7597_53CB_519B(context["施法者"], target, context["治疗"], 0)
                end
            end
            ::__continue41::
            i = i + 1
        end
    end
    if context["剩余Tick"] <= 0 then
        _____7ED3_675FW_5F39_9053(context)
    end
end
local function _____83B7_53D6W_53D1_5C04_5165_53E3(hero)
    return _____662F_9E7F_76EE_5706(hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653EW_53D1_5C04(_entry, caster, _____6280_80FD_5B9E_4F8BID)
    local context = ____W_84C4_529B_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(caster)]
    if context == nil or _____6280_80FD_5B9E_4F8BID == nil or context["阶段"] == "结束" or context["已蓄力秒"] < _____914D_7F6E.W["最低蓄力秒"] then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    local targetX = GetSpellTargetX()
    local targetY = GetSpellTargetY()
    local startX = GetUnitX(caster)
    local startY = GetUnitY(caster)
    local direction = _____4E24_70B9_89D2_5EA6(startX, startY, targetX, targetY)
    local chargeRate = context["已蓄力秒"] >= _____914D_7F6E.W["满蓄力秒"] and 1 or (context["已蓄力秒"] - _____914D_7F6E.W["最低蓄力秒"]) / (_____914D_7F6E.W["满蓄力秒"] - _____914D_7F6E.W["最低蓄力秒"])
    local normalizedCharge = chargeRate > 0 and chargeRate or 0
    local dLayers = _____6D88_8017_9E7F_76EE_5706_5706_73AF_5F3A_5316(caster)
    local dMultiplier = 1 + dLayers * _____914D_7F6E.W["D伤害额外比例"]
    local attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    local damageRatio = _____914D_7F6E.W["最低伤害攻击力比例"] + (_____914D_7F6E.W["满伤害攻击力比例"] - _____914D_7F6E.W["最低伤害攻击力比例"]) * normalizedCharge
    local healRatio = _____914D_7F6E.W["最低治疗攻击力比例"] + (_____914D_7F6E.W["满治疗攻击力比例"] - _____914D_7F6E.W["最低治疗攻击力比例"]) * normalizedCharge
    local projectileTicks = _____914D_7F6E.W["最低弹道Tick"] + jass.R2I(_____914D_7F6E.W["满蓄力额外弹道Tick"] * normalizedCharge + 0.5)
    context["阶段"] = "发射中"
    local chargeId = context["充能ID"]
    context["充能ID"] = 0
    if chargeId ~= 0 then
        _____505C_6B62_5145_80FD(chargeId)
    end
    _____79FB_9664_5355_4F4D_58F3(context["蓄力箭"])
    context["蓄力箭"] = nil
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, _____9E7F_76EE_5706BuffID["因果之矢蓄力"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, _____9E7F_76EE_5706BuffID["因果之矢待发"])
    SetUnitMoveSpeed(caster, context["原移动速度"])
    _____5207_6362W_6280_80FD(caster, false)
    __TS__Delete(
        ____W_84C4_529B_4E0A_4E0B_6587_8868,
        _____53D6_5355_4F4DID(caster)
    )
    context["阶段"] = "结束"
    local arrow = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        GetOwningPlayer(caster),
        _____914D_7F6E["单位壳"]["W发射箭"],
        startX,
        startY,
        direction
    )
    if arrow == nil or arrow == 0 then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    local scale = _____914D_7F6E.W["发射箭基础缩放"] + _____914D_7F6E.W["发射箭满蓄力额外缩放"] * normalizedCharge
    SetUnitFacing(arrow, direction)
    SetUnitFlyHeight(arrow, _____914D_7F6E.W["发射箭高度"], 0)
    SetUnitScale(arrow, scale, scale, scale)
    local projectile = {
        ["施法者"] = caster,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["箭单位"] = arrow,
        ["方向"] = direction,
        ["剩余Tick"] = projectileTicks,
        ["伤害"] = attack * damageRatio * dMultiplier,
        ["治疗"] = attack * healRatio,
        ["忽略魔抗"] = _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297(caster),
        ["已命中"] = {},
        ["周期ID"] = 0
    }
    projectile["周期ID"] = addPeriodicCallback(_____914D_7F6E.W["弹道间隔毫秒"], _____63A8_8FDBW_5F39_9053, projectile)
end
local function _____6CE8_518CW_5355_4F4D_7C7B_578B(unitTypeId)
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "鹿目圆-因果之矢蓄力",
        ["单位类型ID"] = unitTypeId,
        ["技能ID"] = _____914D_7F6E["技能"]["W蓄力"]["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6W_84C4_529B_5165_53E3,
        ["释放技能"] = _____91CA_653EW_84C4_529B,
        ["创建独立技能实例"] = false
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "鹿目圆-因果之矢发射",
        ["单位类型ID"] = unitTypeId,
        ["技能ID"] = _____914D_7F6E["技能"]["W发射"]["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6W_53D1_5C04_5165_53E3,
        ["释放技能"] = _____91CA_653EW_53D1_5C04,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 3
    })
end
_____6CE8_518CW_5355_4F4D_7C7B_578B(_____914D_7F6E["单位"]["普通类型ID"])
_____6CE8_518CW_5355_4F4D_7C7B_578B(_____914D_7F6E["单位"]["圆神类型ID"])
return ____exports
