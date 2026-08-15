local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.05．一方通行.00．配置")
local _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["一方通行单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_1["开始击退"]
local _____505C_6B62_4F4D_79FB = ____require_result_1["停止位移"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.02．原地击飞系统")
local _____5F00_59CB_539F_5730_51FB_98DE = ____require_result_2["开始原地击飞"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_3["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_3["移除单位暂停"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_51CF_901F = ____require_result_4["施加减速"]
local _____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_5["造成单体技能伤害"]
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_5["造成批量AOE技能伤害"]
local ____require_result_6 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_6["减少魔法值"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_7["获取范围敌军"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_9.Sound3DII_UnitPlayReuse
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_10.registerDeathListener
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_11.stringToFourCCSafe
local cfg = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E
local ____W_914D_7F6E = cfg.W
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(cfg["单位类型ID"])
local ____W_6280_80FDID = stringToFourCCSafe(cfg["W技能ID"])
local ____W_4E8C_6BB5_6280_80FDID = stringToFourCCSafe(cfg["W二段技能ID"])
local ____jass_DAMAGE_TYPE_PLANT_12 = jass.DAMAGE_TYPE_PLANT
if ____jass_DAMAGE_TYPE_PLANT_12 == nil then
    ____jass_DAMAGE_TYPE_PLANT_12 = jass.DAMAGE_TYPE_MAGIC
end
local DAMAGE_TYPE_PLANT = ____jass_DAMAGE_TYPE_PLANT_12
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local GetHandleId = jass.GetHandleId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetOwningPlayer = jass.GetOwningPlayer
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local ResetUnitAnimation = jass.ResetUnitAnimation
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local IsUnitType = jass.IsUnitType
local IsUnitEnemy = jass.IsUnitEnemy
local CreateDestructable = jass.CreateDestructable
local RemoveDestructable = jass.RemoveDestructable
local GetRandomReal = jass.GetRandomReal
local ____require_result_13 = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进")
local _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321 = ____require_result_13["沿角度步进直到地形阻挡"]
local _____4E0A_4E0B_6587_8868 = {}
local function _____53D6_5355_4F4DID(unit)
    return (unit == nil or unit == 0) and 0 or (GetHandleId(unit) or 0)
end
local function _____83B7_53D6W_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    local ____temp_14
    if id == 0 then
        ____temp_14 = nil
    else
        ____temp_14 = _____4E0A_4E0B_6587_8868[id]
    end
    return ____temp_14
end
local function _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return nil
    end
    local old = _____4E0A_4E0B_6587_8868[id]
    if old ~= nil then
        return old
    end
    local created = {
        ["施法者"] = unit,
        ["已启动"] = false,
        ["二段窗口中"] = false,
        ["方向角"] = 0,
        ["目标X"] = 0,
        ["目标Y"] = 0,
        ["窗口回调ID"] = 0,
        ["位移ID"] = 0,
        ["二段回调ID"] = 0,
        ["二段次数"] = 0,
        ["已命中单位"] = {},
        ["暂停来源"] = "一方通行-W:" .. tostring(id),
        ["碰撞已发生"] = false
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function _____5220_9664W_8F85_52A9_72B6_6001(caster)
    jass.UnitRemoveAbility(caster, ____W_4E8C_6BB5_6280_80FDID)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____W_6280_80FDID,
        true
    )
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____W_4E8C_6BB5_6280_80FDID,
        false
    )
end
local function _____6E05_7406W_4E0A_4E0B_6587(context)
    if context["窗口回调ID"] ~= 0 then
        removeDelayedCallback(context["窗口回调ID"])
        context["窗口回调ID"] = 0
    end
    if context["位移ID"] ~= 0 then
        _____505C_6B62_4F4D_79FB(context["位移ID"], "中断")
        context["位移ID"] = 0
    end
    if context["二段回调ID"] ~= 0 then
        removePeriodicCallback(context["二段回调ID"])
        context["二段回调ID"] = 0
    end
    if context["施法者"] ~= nil and context["施法者"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["暂停来源"])
        _____5220_9664W_8F85_52A9_72B6_6001(context["施法者"])
        ResetUnitAnimation(context["施法者"])
    end
    context["已启动"] = false
    context["二段窗口中"] = false
    local id = _____53D6_5355_4F4DID(context["施法者"])
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
end
local function ____W_76EE_6807_5141_8BB8(caster, target)
    return _____5355_4F4D_5B58_6D3B(target) and target ~= caster and IsUnitEnemy(
        target,
        GetOwningPlayer(caster)
    ) and not IsUnitType(target, UNIT_TYPE_ANCIENT) and not IsUnitType(target, UNIT_TYPE_MECHANICAL) and not IsUnitType(target, UNIT_TYPE_STRUCTURE)
end
local function ____W_9020_6210_5355_4F53_4F24_5BB3(caster, target, damage, skillInstanceId)
    if not ____W_76EE_6807_5141_8BB8(caster, target) or damage <= 0 then
        return
    end
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标"] = target,
        ["伤害"] = damage,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FDID,
        ["技能实例ID"] = skillInstanceId,
        ["标签"] = "一方通行-W-矢量操作",
        ["参与技能伤害加成"] = true
    })
end
local function ____W_9020_6210AOE_4F24_5BB3(caster, x, y, radius, damage, skillInstanceId)
    local targets = _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, radius)
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FDID,
        ["技能实例ID"] = skillInstanceId,
        ["标签"] = "一方通行-W-范围矢量冲击",
        ["参与技能伤害加成"] = true,
        ["每目标处理器"] = function(target) return ____W_76EE_6807_5141_8BB8(caster, target) and ({["伤害"] = damage}) or nil end
    })
end
local function _____4E00_65B9_901A_884CW_5355_4F4D_76EE_6807_7ED3_7B97(context, target)
    local caster = context["施法者"]
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * ____W_914D_7F6E["目标伤害攻击力倍率"]
    ____W_9020_6210_5355_4F53_4F24_5BB3(caster, target, damage, context["技能实例ID"])
    if context["碰撞已发生"] and _____5355_4F4D_5B58_6D3B(target) then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = ____W_914D_7F6E["碰撞特效模型"],
            X = GetUnitX(target),
            Y = GetUnitY(target),
            Z = GetUnitFlyHeight(target),
            ["持续秒"] = 1
        })
        ____W_9020_6210AOE_4F24_5BB3(
            caster,
            GetUnitX(target),
            GetUnitY(target),
            ____W_914D_7F6E["碰撞范围"],
            _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * ____W_914D_7F6E["碰撞伤害攻击力倍率"],
            context["技能实例ID"]
        )
        _____65BD_52A0_7729_6655(
            caster,
            target,
            ____W_914D_7F6E["目标眩晕秒"],
            "一方通行-W-碰撞眩晕",
            "技能"
        )
    end
end
local function _____4E00_65B9_901A_884CW_5355_4F4D_76EE_6807(context, target)
    local caster = context["施法者"]
    context["已启动"] = true
    context["碰撞已发生"] = false
    Sound3DII_UnitPlayReuse(____W_914D_7F6E["施法音效路径"], caster, ____W_914D_7F6E["施法音效裁断距离"])
    if ____W_76EE_6807_5141_8BB8(caster, target) then
        _____65BD_52A0_51CF_901F(
            caster,
            target,
            ____W_914D_7F6E["目标减速比例"],
            ____W_914D_7F6E["目标减速秒"],
            "一方通行-W-目标减速",
            "技能"
        )
    end
    context["位移ID"] = _____5F00_59CB_51FB_9000(
        target,
        {
            ["来源单位"] = caster,
            ["距离"] = ____W_914D_7F6E["目标击退距离"],
            ["持续时间"] = ____W_914D_7F6E["目标击退持续秒"],
            ["检查地形"] = true,
            ["暂停单位"] = false,
            ["命中半径"] = ____W_914D_7F6E["目标碰撞半径"],
            ["只命中敌人"] = true,
            ["命中后结束"] = true,
            ["命中回调"] = function()
                context["碰撞已发生"] = true
            end,
            ["撞墙回调"] = function()
                context["碰撞已发生"] = true
            end,
            ["结束回调"] = function()
                context["位移ID"] = 0
                _____4E00_65B9_901A_884CW_5355_4F4D_76EE_6807_7ED3_7B97(context, target)
                _____6E05_7406W_4E0A_4E0B_6587(context)
            end
        }
    )
    if context["位移ID"] == 0 then
        _____4E00_65B9_901A_884CW_5355_4F4D_76EE_6807_7ED3_7B97(context, target)
        _____6E05_7406W_4E0A_4E0B_6587(context)
    end
end
local function _____4E00_65B9_901A_884CW_5730_9762_5355_51FB(context)
    local caster = context["施法者"]
    context["已启动"] = true
    Sound3DII_UnitPlayReuse(____W_914D_7F6E["施法音效路径"], caster, ____W_914D_7F6E["施法音效裁断距离"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = ____W_914D_7F6E["单击雷霆特效模型"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        Z = GetUnitFlyHeight(caster),
        ["持续秒"] = 1
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = ____W_914D_7F6E["单击沙尘特效模型"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        Z = GetUnitFlyHeight(caster),
        ["缩放"] = 1.4,
        ["持续秒"] = 1
    })
    local targets = _____83B7_53D6_8303_56F4_654C_519B(
        caster,
        GetUnitX(caster),
        GetUnitY(caster),
        ____W_914D_7F6E["地面单击范围"]
    )
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * ____W_914D_7F6E["地面单击伤害攻击力倍率"]
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害"] = damage,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "一方通行-W-地面单击",
        ["参与技能伤害加成"] = true,
        ["每目标处理器"] = function(target) return ____W_76EE_6807_5141_8BB8(caster, target) and ({["伤害"] = damage, ["伤害类型"] = DAMAGE_TYPE_PLANT}) or nil end,
        ["每目标结算后处理器"] = function(target)
            if ____W_76EE_6807_5141_8BB8(caster, target) then
                _____5F00_59CB_539F_5730_51FB_98DE(target, {
                    ["持续时间"] = ____W_914D_7F6E["地面击飞持续秒"],
                    ["最小高度"] = 25,
                    ["最大高度"] = 25,
                    ["持续特效模型"] = ____W_914D_7F6E["二段践踏特效模型"],
                    ["持续特效间隔"] = 0.2,
                    ["暂停单位"] = true,
                    ["主单位"] = caster
                })
            end
        end
    })
    _____6E05_7406W_4E0A_4E0B_6587(context)
end
local function _____521B_5EFA_4E00_65B9_901A_884CW_5730_5F62(x, y)
    local destructable = CreateDestructable(
        stringToFourCCSafe(____W_914D_7F6E["地形破坏物ID"]),
        x,
        y,
        GetRandomReal(0, 360),
        1,
        0
    )
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = ____W_914D_7F6E["二段践踏特效模型"], X = x, Y = y, ["持续秒"] = 1})
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = ____W_914D_7F6E["单击雷霆特效模型"], X = x, Y = y, ["持续秒"] = 1})
    if destructable ~= nil and destructable ~= 0 then
        addDelayedCallback(
            5000,
            function() return RemoveDestructable(destructable) end
        )
    end
end
local function _____4E00_65B9_901A_884CW_4E8C_6BB5Tick(variable)
    local context = variable
    if context == nil or not context["已启动"] or not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        if context ~= nil then
            _____6E05_7406W_4E0A_4E0B_6587(context)
        end
        return
    end
    if context["二段次数"] >= ____W_914D_7F6E["二段循环次数"] then
        _____6E05_7406W_4E0A_4E0B_6587(context)
        return
    end
    local caster = context["施法者"]
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local next = _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321({
        ["起点X"] = x,
        ["起点Y"] = y,
        ["角度度"] = context["方向角"],
        ["单步距离"] = ____W_914D_7F6E["二段每次移动距离"],
        ["步数"] = 1
    })
    if next["实际步数"] <= 0 then
        _____6E05_7406W_4E0A_4E0B_6587(context)
        return
    end
    jass.SetUnitX(caster, next["最终X"])
    jass.SetUnitY(caster, next["最终Y"])
    SetUnitFacing(caster, context["方向角"])
    context["二段次数"] = context["二段次数"] + 1
    if context["二段次数"] == 13 or context["二段次数"] == 26 or context["二段次数"] == 39 then
        _____521B_5EFA_4E00_65B9_901A_884CW_5730_5F62(next["最终X"], next["最终Y"])
    end
    local targets = _____83B7_53D6_8303_56F4_654C_519B(caster, next["最终X"], next["最终Y"], ____W_914D_7F6E["二段范围"])
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * ____W_914D_7F6E["二段伤害攻击力倍率"]
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "一方通行-W-地面双击",
        ["参与技能伤害加成"] = true,
        ["每目标处理器"] = function(target)
            local id = _____53D6_5355_4F4DID(target)
            if context["已命中单位"][id] or not ____W_76EE_6807_5141_8BB8(caster, target) then
                return nil
            end
            context["已命中单位"][id] = true
            return {["伤害"] = damage}
        end,
        ["每目标结算后处理器"] = function(target)
            if ____W_76EE_6807_5141_8BB8(caster, target) then
                _____65BD_52A0_51CF_901F(
                    caster,
                    target,
                    ____W_914D_7F6E["二段减速比例"],
                    ____W_914D_7F6E["二段减速秒"],
                    "一方通行-W-双击减速",
                    "技能"
                )
            end
        end
    })
end
local function _____4E00_65B9_901A_884CW_4E8C_6BB5(context, caster)
    if not context["二段窗口中"] or context["已启动"] then
        return
    end
    if context["窗口回调ID"] ~= 0 then
        removeDelayedCallback(context["窗口回调ID"])
        context["窗口回调ID"] = 0
    end
    context["二段窗口中"] = false
    context["已启动"] = true
    context["二段次数"] = 0
    context["已命中单位"] = {}
    local maxMana = jass.GetUnitState(caster, jass.UNIT_STATE_MAX_MANA) or 0
    _____51CF_5C11_9B54_6CD5_503C(caster, maxMana * ____W_914D_7F6E["二段追加魔耗比例"], false, false)
    _____79FB_9664_5355_4F4D_6682_505C(caster, context["暂停来源"])
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["暂停来源"])
    SetUnitAnimationByIndex(caster, 10)
    Sound3DII_UnitPlayReuse(____W_914D_7F6E["施法音效路径"], caster, ____W_914D_7F6E["施法音效裁断距离"])
    _____5220_9664W_8F85_52A9_72B6_6001(caster)
    context["二段回调ID"] = addPeriodicCallback(____W_914D_7F6E["二段周期毫秒"], _____4E00_65B9_901A_884CW_4E8C_6BB5Tick, context)
end
local function _____4E00_65B9_901A_884CW_5355_51FB_7A97_53E3_7ED3_675F(variable)
    local context = variable
    if context == nil or not context["二段窗口中"] or context["已启动"] then
        return
    end
    context["窗口回调ID"] = 0
    context["二段窗口中"] = false
    _____5220_9664W_8F85_52A9_72B6_6001(context["施法者"])
    _____4E00_65B9_901A_884CW_5730_9762_5355_51FB(context)
end
local function _____91CA_653E_4E00_65B9_901A_884CW(context, caster, skillInstanceId)
    if context["已启动"] or context["二段窗口中"] then
        return
    end
    context["技能实例ID"] = skillInstanceId
    local target = GetSpellTargetUnit()
    if target ~= nil and target ~= 0 then
        if ____W_76EE_6807_5141_8BB8(caster, target) then
            _____4E00_65B9_901A_884CW_5355_4F4D_76EE_6807(context, target)
        else
            _____6E05_7406W_4E0A_4E0B_6587(context)
        end
        return
    end
    context["二段窗口中"] = true
    context["方向角"] = _____4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    context["目标X"] = GetSpellTargetX()
    context["目标Y"] = GetSpellTargetY()
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["暂停来源"])
    SetUnitAnimationByIndex(caster, 10)
    jass.UnitAddAbility(caster, ____W_4E8C_6BB5_6280_80FDID)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____W_6280_80FDID,
        false
    )
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____W_4E8C_6BB5_6280_80FDID,
        true
    )
    context["窗口回调ID"] = addDelayedCallback(____W_914D_7F6E["二段窗口秒"] * 1000, _____4E00_65B9_901A_884CW_5355_51FB_7A97_53E3_7ED3_675F, context)
end
local function _____91CA_653E_4E00_65B9_901A_884CW_4E8C_6BB5(context, caster)
    _____4E00_65B9_901A_884CW_4E8C_6BB5(context, caster)
end
local function _____4E00_65B9_901A_884CW_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____83B7_53D6W_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____6E05_7406W_4E0A_4E0B_6587(context)
    end
end
____exports["注册一方通行W"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "一方通行-矢量操作(W)",
        ["单位类型ID"] = cfg["单位类型ID"],
        ["技能ID"] = cfg["W技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_4E00_65B9_901A_884CW,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 3
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "一方通行-矢量操作二段(W)",
        ["单位类型ID"] = cfg["单位类型ID"],
        ["技能ID"] = cfg["W二段技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_4E00_65B9_901A_884CW_4E8C_6BB5,
        ["创建独立技能实例"] = false
    })
    registerDeathListener(_____4E00_65B9_901A_884CW_5355_4F4D_6B7B_4EA1)
end
____exports["注册一方通行W"]()
return ____exports
