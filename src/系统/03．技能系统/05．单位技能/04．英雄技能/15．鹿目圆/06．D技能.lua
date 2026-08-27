local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____9500_6BC1D_8868_73B0, _____6E05_7406D_8868_73B0, removePeriodicCallback, _____53D6_5355_4F4DID, _____9500_6BC1_70B9_7279_6548, ____D_8868_73B0_8868, ____D_7279_6548_7248_672C_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.00．配置")
local _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["鹿目圆单位技能配置"]
local ____01_FF0E_72B6_6001_4E0E_88AB_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.01．状态与被动")
local _____662F_9E7F_76EE_5706 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["是鹿目圆"]
local _____662F_9E7F_76EE_5706_5706_795E = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["是鹿目圆圆神"]
local _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆伤害无视魔抗"]
local _____9E7F_76EE_5706_6CBB_7597_53CB_519B = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆治疗友军"]
local _____6FC0_6D3B_9E7F_76EE_5706_5706_73AF_5F3A_5316 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["激活鹿目圆圆环强化"]
local _____83B7_53D6_9E7F_76EE_5706_5706_73AF_5F3A_5316_5C42_6570 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["获取鹿目圆圆环强化层数"]
local _____6D88_8017_9E7F_76EE_5706_5706_73AF_5F3A_5316 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["消耗鹿目圆圆环强化"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____9500_6BC1D_8868_73B0(hero)
    if hero == nil or hero == 0 then
        return
    end
    local id = _____53D6_5355_4F4DID(hero)
    local state = ____D_8868_73B0_8868[id]
    if state ~= nil then
        if state["周期ID"] ~= 0 then
            removePeriodicCallback(state["周期ID"])
        end
        if state["特效"] ~= nil and state["特效"] ~= 0 then
            _____9500_6BC1_70B9_7279_6548(state["特效"])
        end
        __TS__Delete(____D_8868_73B0_8868, id)
    end
    __TS__Delete(____D_7279_6548_7248_672C_8868, id)
end
function _____6E05_7406D_8868_73B0(variable)
    local data = variable
    if data == nil then
        return
    end
    local id = _____53D6_5355_4F4DID(data.hero)
    if id == 0 or ____D_7279_6548_7248_672C_8868[id] ~= data.version then
        return
    end
    _____9500_6BC1D_8868_73B0(data.hero)
end
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.02．攻击效果监听")
local _____6CE8_518C_666E_653B_653B_51FB_6548_679C_76D1_542C = ____require_result_1["注册普攻攻击效果监听"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.06．魔法恢复")
local _____9B54_6CD5_589E_51CF = ____require_result_3["魔法增减"]
local ____require_result_4 = require("系统.05．Buff系统.05．Buff清除函数")
local _____79FB_9664_5355_4F4D_8D1F_9762Buff = ____require_result_4["移除单位负面Buff"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_5["施加快速控制Buff"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____require_result_6["施加临时属性效果"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_7["开始击退"]
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_8.getEnemyUnitsInRange
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_9["读取单位攻击力"]
_____53D6_5355_4F4DID = ____require_result_9["取单位ID"]
local _____5355_4F4D_5B58_6D3B = ____require_result_9["单位存活"]
local _____6781_5750_6807X = ____require_result_9["极坐标X"]
local _____6781_5750_6807Y = ____require_result_9["极坐标Y"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
_____9500_6BC1_70B9_7279_6548 = ____require_result_10["销毁点特效"]
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_11.createTimedEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitAlly = jass.IsUnitAlly
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitStateJapi = japi.GetUnitState
local _____914D_7F6E = _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E
--- 播放地图预载全局音效（源 PlaySoundAtPointBJ/OnUnitBJ gg_snd_*）
local function _____64AD_653ED_5168_5C40_97F3_6548(soundKey)
    if soundKey == "" then
        return
    end
    local sound = jglobals[soundKey]
    if sound == nil or sound == 0 then
        return
    end
    jass:StartSound(sound)
end
____D_8868_73B0_8868 = {}
____D_7279_6548_7248_672C_8868 = {}
--- 源 Func011T：特效每 tick 移到 英雄+40 码（facing+90）位置，Z=240
local function ____D_73AF_7ED5Tick(variable)
    local state = variable
    if state == nil then
        return
    end
    local hero = state["英雄"]
    if not _____5355_4F4D_5B58_6D3B(hero) or _____83B7_53D6_9E7F_76EE_5706_5706_73AF_5F3A_5316_5C42_6570(hero) <= 0 then
        _____9500_6BC1D_8868_73B0(hero)
        return
    end
    if state["特效"] == nil or state["特效"] == 0 then
        return
    end
    local _____73AF_7ED5_89D2_5EA6 = jass:GetUnitFacing(hero) + 90
    local x = _____6781_5750_6807X(
        GetUnitX(hero),
        _____73AF_7ED5_89D2_5EA6,
        _____914D_7F6E.D["环绕距离"]
    )
    local y = _____6781_5750_6807Y(
        GetUnitY(hero),
        _____73AF_7ED5_89D2_5EA6,
        _____914D_7F6E.D["环绕距离"]
    )
    japi:DzSetEffectPos(state["特效"], x, y, _____914D_7F6E.D["环绕高度"])
end
local function _____64AD_653ED_8868_73B0(hero)
    local id = _____53D6_5355_4F4DID(hero)
    if id == 0 then
        return
    end
    _____9500_6BC1D_8868_73B0(hero)
    local version = (____D_7279_6548_7248_672C_8868[id] or 0) + 1
    ____D_7279_6548_7248_672C_8868[id] = version
    local goddess = _____662F_9E7F_76EE_5706_5706_795E(hero)
    local effect = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = goddess and _____914D_7F6E.D["圆神特效"] or _____914D_7F6E.D["普通特效"],
        X = GetUnitX(hero),
        Y = GetUnitY(hero),
        Z = _____914D_7F6E.D["特效高度"],
        ["面向角度"] = 270,
        ["缩放"] = goddess and _____914D_7F6E.D["圆神特效缩放"] or _____914D_7F6E.D["普通特效缩放"],
        ["持续秒"] = _____914D_7F6E.D["持续秒"]
    })
    local state = {["英雄"] = hero, ["特效"] = effect, ["周期ID"] = 0}
    ____D_8868_73B0_8868[id] = state
    state["周期ID"] = addPeriodicCallback(_____914D_7F6E.D["环绕周期毫秒"], ____D_73AF_7ED5Tick, state)
    addDelayedCallback(_____914D_7F6E.D["持续秒"] * 1000, _____6E05_7406D_8868_73B0, {hero = hero, version = version})
end
local function _____662FD_5408_6CD5_76EE_6807(target)
    return _____5355_4F4D_5B58_6D3B(target) and IsUnitType(target, UNIT_TYPE_MECHANICAL) ~= true and IsUnitType(target, UNIT_TYPE_ANCIENT) ~= true
end
local function _____83B7_53D6D_5165_53E3(hero)
    return _____662F_9E7F_76EE_5706(hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653ED(_entry, caster)
    local layers = _____6FC0_6D3B_9E7F_76EE_5706_5706_73AF_5F3A_5316(caster)
    if layers <= 0 then
        return
    end
    _____64AD_653ED_5168_5C40_97F3_6548(_____914D_7F6E.D["施放音效键"])
    if layers >= 2 then
        local maxMana = GetUnitStateJapi(caster, UNIT_STATE_MAX_MANA)
        if maxMana > 0 then
            _____9B54_6CD5_589E_51CF(caster, -maxMana * _____914D_7F6E.D["二次使用魔法消耗比例"])
        end
    end
    _____64AD_653ED_8868_73B0(caster)
end
local function ____D_654C_65B9_7ED3_7B97(source, target, layers)
    local second = layers >= 2
    createTimedEffect(
        _____914D_7F6E.D["敌方命中特效"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        1.5
    )
    createTimedEffect(
        second and _____914D_7F6E.D["二次敌方特效"] or _____914D_7F6E.D["一次敌方特效"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        2
    )
    if second then
        createTimedEffect(
            _____914D_7F6E.D["二次敌方追加特效"],
            GetUnitX(target),
            GetUnitY(target),
            0,
            2
        )
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(
            source,
            target,
            2,
            _____914D_7F6E.D["二次沉默秒"],
            "鹿目圆-圆环之力",
            "技能"
        )
        local targetAttack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(target)
        if targetAttack > 0 then
            _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(target, _____914D_7F6E.D["二次沉默秒"] * 1000, {{["类型"] = "攻击", ["数值"] = -targetAttack * _____914D_7F6E.D["二次减攻击比例"]}})
        end
    end
    local maxMana = GetUnitStateJapi(target, UNIT_STATE_MAX_MANA)
    if maxMana > 0 then
        local _____4FDD_7559_6BD4_4F8B = second and _____914D_7F6E.D["敌方魔法保留比例二次"] or _____914D_7F6E.D["敌方魔法保留比例一次"]
        local _____76EE_6807_9B54_6CD5 = maxMana * _____4FDD_7559_6BD4_4F8B
        local _____5F53_524D_9B54_6CD5 = GetUnitStateJapi(target, jass.UNIT_STATE_MANA)
        local delta = _____76EE_6807_9B54_6CD5 - _____5F53_524D_9B54_6CD5
        if delta ~= 0 then
            _____9B54_6CD5_589E_51CF(target, delta)
        end
    end
    local sourceAttack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(source)
    local damageRatio = second and _____914D_7F6E.D["二次攻击力伤害比例"] or _____914D_7F6E.D["一次攻击力伤害比例"]
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害"] = sourceAttack * damageRatio,
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "普攻强化",
        ["技能ID"] = _____914D_7F6E["技能"].D["类型ID"],
        ["标签"] = "鹿目圆-D-圆环之力",
        ["参与技能伤害加成"] = true,
        ["忽略魔法抗性"] = _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297(source)
    })
end
local function ____D_53CB_65B9_4F4E_751F_547D_51FB_9000(source, ally)
    createTimedEffect(
        _____914D_7F6E.D["击退特效"],
        GetUnitX(ally),
        GetUnitY(ally),
        0,
        1
    )
    _____64AD_653ED_5168_5C40_97F3_6548(_____914D_7F6E.D["击退音效键"])
    local enemies = getEnemyUnitsInRange(
        source,
        GetUnitX(ally),
        GetUnitY(ally),
        _____914D_7F6E.D["击退范围"]
    )
    do
        local i = 0
        while i < #enemies do
            do
                local enemy = enemies[i + 1]
                if not _____662FD_5408_6CD5_76EE_6807(enemy) then
                    goto __continue32
                end
                _____5F00_59CB_51FB_9000(enemy, {
                    ["来源单位"] = ally,
                    ["距离"] = _____914D_7F6E.D["击退距离"],
                    ["持续时间"] = 0.3,
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["位移特效"] = ""
                })
            end
            ::__continue32::
            i = i + 1
        end
    end
end
local function ____D_53CB_65B9_7ED3_7B97(source, target, layers)
    local second = layers >= 2
    local maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
    local life = GetUnitState(target, UNIT_STATE_LIFE)
    local _____9AD8_751F_547D = maxLife > 0 and life >= maxLife * _____914D_7F6E.D["击退生命阈值比例"]
    local healRatio = second and _____914D_7F6E.D["二次友军治疗攻击力比例"] or _____914D_7F6E.D["一次友军治疗攻击力比例"]
    local healAmount = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(source) * healRatio
    _____9E7F_76EE_5706_6CBB_7597_53CB_519B(source, target, healAmount, 0)
    if second then
        _____79FB_9664_5355_4F4D_8D1F_9762Buff(target, false)
        if _____9AD8_751F_547D then
            ____D_53CB_65B9_4F4E_751F_547D_51FB_9000(source, target)
        end
    end
end
local function ____D_666E_653B_6761_4EF6(ctx)
    return ctx ~= nil and ctx.isNormalAttack == true and _____662F_9E7F_76EE_5706(ctx.source) and _____83B7_53D6_9E7F_76EE_5706_5706_73AF_5F3A_5316_5C42_6570(ctx.source) > 0 and _____662FD_5408_6CD5_76EE_6807(ctx.target)
end
local function ____D_666E_653B_547D_4E2D(ctx)
    local source = ctx.source
    local target = ctx.target
    local layers = _____6D88_8017_9E7F_76EE_5706_5706_73AF_5F3A_5316(source)
    if layers <= 0 then
        return
    end
    _____9500_6BC1D_8868_73B0(source)
    local owner = GetOwningPlayer(source)
    if IsUnitEnemy(target, owner) == true then
        ____D_654C_65B9_7ED3_7B97(source, target, layers)
    elseif IsUnitAlly(target, owner) == true then
        ____D_53CB_65B9_7ED3_7B97(source, target, layers)
    end
end
local function _____6CE8_518CD_5355_4F4D_7C7B_578B(unitTypeId)
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "鹿目圆-圆环之力",
        ["单位类型ID"] = unitTypeId,
        ["技能ID"] = _____914D_7F6E["技能"].D["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6D_5165_53E3,
        ["释放技能"] = _____91CA_653ED,
        ["创建独立技能实例"] = false
    })
end
_____6CE8_518CD_5355_4F4D_7C7B_578B(_____914D_7F6E["单位"]["普通类型ID"])
_____6CE8_518CD_5355_4F4D_7C7B_578B(_____914D_7F6E["单位"]["圆神类型ID"])
_____6CE8_518C_666E_653B_653B_51FB_6548_679C_76D1_542C({["名称"] = "鹿目圆-圆环之力普攻", ["允许技能普攻"] = false, ["条件"] = ____D_666E_653B_6761_4EF6, ["命中后"] = ____D_666E_653B_547D_4E2D})
return ____exports
