local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00．配置")
local _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["藤原妹红单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00A．表现工具")
local _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放藤原妹红单位音效"]
local _____64AD_653E_85E4_539F_59B9_7EA2_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放藤原妹红配置动作"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红点特效"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_5355_4F4D_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红单位特效"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红移动特效"]
local _____66F4_65B0_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["更新藤原妹红移动特效"]
local _____9500_6BC1_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["销毁藤原妹红移动特效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____04_FF0EE_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.04．E技能")
local _____5173_95ED_85E4_539F_59B9_7EA2_7B26_5361_6A21_5F0F = ____04_FF0EE_6280_80FD["关闭藤原妹红符卡模式"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_1["开始冲锋"]
local _____5F00_59CB_51FB_9000 = ____require_result_1["开始击退"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成批量AOE技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_3["施加眩晕"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_4["开始硬直"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____require_result_5["读取单位最大生命"]
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_5["两点角度"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_6.getEnemyUnitsInRange
local ____require_result_7 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_7.YDWESetUnitAbilityStateSafe
local ____require_result_8 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_8.registerDeathListener
local ____require_result_9 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitVertexColorBJ = ____require_result_9.SetUnitVertexColorBJ
local stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____666E_901AQ_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通Q技能ID"])
local _____666E_901AQ_4E8C_6BB5_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通Q二段技能ID"])
local _____7B26_5361Q_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡Q技能ID"])
local _____65E0_654C_6280_80FDID = stringToFourCCSafe("Avul")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPathing = jass.SetUnitPathing
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local IsUnitType = jass.IsUnitType
local IsUnitRace = jass.IsUnitRace
local Cos = jass.Cos
local Sin = jass.Sin
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local RACE_DEMON = jass.RACE_DEMON
local DEG_TO_RAD = 0.017453292519943295
local _____666E_901AQ_4E0A_4E0B_6587_8868 = {}
local _____7B26_5361Q_4E0A_4E0B_6587_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____6263_9664_6700_5927_751F_547D(unit, ratio)
    local currentLife = GetUnitState(unit, UNIT_STATE_LIFE)
    local damage = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(unit) * ratio
    local nextLife = currentLife - damage
    SetUnitState(unit, UNIT_STATE_LIFE, nextLife > 0 and nextLife or 0)
end
local function _____5207_6362_81F3_666E_901AQ_4E8C_6BB5(caster)
    local owner = GetOwningPlayer(caster)
    SetPlayerAbilityAvailable(owner, _____666E_901AQ_6280_80FDID, false)
    UnitAddAbility(caster, _____666E_901AQ_4E8C_6BB5_6280_80FDID)
    SetPlayerAbilityAvailable(owner, _____666E_901AQ_4E8C_6BB5_6280_80FDID, true)
end
local function _____6062_590D_666E_901AQ_5F62_6001(variable)
    local caster = variable
    if caster == nil or caster == 0 then
        return
    end
    local owner = GetOwningPlayer(caster)
    SetPlayerAbilityAvailable(owner, _____666E_901AQ_6280_80FDID, true)
    UnitRemoveAbility(caster, _____666E_901AQ_4E8C_6BB5_6280_80FDID)
end
local function _____666E_901AQ_79FB_52A8_8868_73B0Tick(variable)
    local context = variable
    if context == nil or context["凤凰特效"] == nil or not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通Q"]
    local x = GetUnitX(context["施法者"])
    local y = GetUnitY(context["施法者"])
    _____66F4_65B0_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(context["凤凰特效"], x, y)
    _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(cfg["移动特效"], x, y)
end
local function _____666E_901AQ_547D_4E2D_8FC7_6EE4(_movingUnit, target, _moveId)
    return _____5355_4F4D_5B58_6D3B(target) and IsUnitType(target, UNIT_TYPE_ANCIENT) ~= true and IsUnitType(target, UNIT_TYPE_MECHANICAL) ~= true and IsUnitType(target, UNIT_TYPE_STRUCTURE) ~= true
end
local function _____666E_901AQ_547D_4E2D(caster, target, _moveId)
    local context = _____666E_901AQ_4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(caster)]
    if context == nil or not _____666E_901AQ_547D_4E2D_8FC7_6EE4(caster, target, _moveId) then
        return
    end
    local ____context__547D_4E2D_5355_4F4D_5217_8868_10 = context["命中单位列表"]
    ____context__547D_4E2D_5355_4F4D_5217_8868_10[#____context__547D_4E2D_5355_4F4D_5217_8868_10 + 1] = target
    _____65BD_52A0_7729_6655(
        caster,
        target,
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通Q"]["命中控制秒"],
        "藤原妹红-不死鸟附体",
        "技能"
    )
end
local function _____51C6_5907_666E_901AQ_4F24_5BB3(target, _index, variable)
    local context = variable
    if context == nil or not _____5355_4F4D_5B58_6D3B(target) then
        return nil
    end
    local effects = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通Q"]["命中特效"]
    do
        local i = 0
        while i < #effects do
            _____521B_5EFA_85E4_539F_59B9_7EA2_5355_4F4D_7279_6548(target, effects[i + 1], effects[i + 1]["挂点"])
            i = i + 1
        end
    end
    return {
        ["伤害"] = context["伤害"],
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS
    }
end
local function _____5904_7406_666E_901AQ_51B2_950B_7ED3_675F(caster, reason, moveId)
    local handleId = _____53D6_5355_4F4D_53E5_67C4ID(caster)
    local context = _____666E_901AQ_4E0A_4E0B_6587_8868[handleId]
    if context == nil or context["位移ID"] ~= moveId then
        return
    end
    __TS__Delete(_____666E_901AQ_4E0A_4E0B_6587_8868, handleId)
    if context["移动表现回调ID"] ~= 0 then
        removePeriodicCallback(context["移动表现回调ID"])
    end
    _____9500_6BC1_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(context["凤凰特效"])
    UnitRemoveAbility(caster, _____65E0_654C_6280_80FDID)
    SetUnitPathing(caster, true)
    SetUnitVertexColorBJ(
        caster,
        100,
        100,
        100,
        0
    )
    if not _____5355_4F4D_5B58_6D3B(caster) or reason == "死亡" or reason == "主单位死亡" then
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通Q"]
    _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(
        cfg["结束特效"],
        GetUnitX(caster),
        GetUnitY(caster)
    )
    if #context["命中单位列表"] == 0 then
        YDWESetUnitAbilityStateSafe(caster, _____666E_901AQ_6280_80FDID, 1, cfg["无命中冷却秒"])
        return
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = context["命中单位列表"],
        ["伤害"] = context["伤害"],
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____666E_901AQ_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "藤原妹红-不死鸟附体",
        ["每目标处理器"] = _____51C6_5907_666E_901AQ_4F24_5BB3,
        ["变量"] = context
    })
end
local function _____91CA_653E_85E4_539F_59B9_7EA2_666E_901AQ(_context, caster, skillInstanceId)
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通Q"]
    _____6263_9664_6700_5927_751F_547D(caster, cfg["生命消耗最大生命比例"])
    _____5207_6362_81F3_666E_901AQ_4E8C_6BB5(caster)
    _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    local startX = GetUnitX(caster)
    local startY = GetUnitY(caster)
    local targetX = GetSpellTargetX()
    local targetY = GetSpellTargetY()
    local direction = _____4E24_70B9_89D2_5EA6(startX, startY, targetX, targetY)
    local context = {
        ["施法者"] = caster,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) + _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(caster) * cfg["命中伤害最大生命倍率"],
        ["命中单位列表"] = {},
        ["移动表现回调ID"] = 0,
        ["位移ID"] = 0,
        ["技能实例ID"] = skillInstanceId
    }
    context["凤凰特效"] = _____521B_5EFA_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(cfg["凤凰特效"], startX, startY, direction)
    UnitAddAbility(caster, _____65E0_654C_6280_80FDID)
    SetUnitVertexColorBJ(
        caster,
        100,
        100,
        100,
        100
    )
    SetUnitPathing(caster, false)
    _____666E_901AQ_4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(caster)] = context
    _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(cfg["移动特效"], startX, startY)
    context["移动表现回调ID"] = addPeriodicCallback(cfg["移动特效"]["触发间隔秒"] * 1000, _____666E_901AQ_79FB_52A8_8868_73B0Tick, context)
    context["位移ID"] = _____5F00_59CB_51B2_950B(caster, {
        ["角度"] = direction,
        ["距离"] = cfg["最大移动距离"],
        ["每秒速度"] = cfg["每次移动距离"] / (cfg["移动间隔毫秒"] * 0.001),
        ["持续时间"] = cfg["最大移动秒"],
        ["检查地形"] = true,
        ["朝向跟随位移"] = true,
        ["暂停单位"] = false,
        ["禁用碰撞"] = true,
        ["命中半径"] = cfg["捕捉范围"],
        ["只命中敌人"] = true,
        ["允许重复命中"] = false,
        ["命中后结束"] = false,
        ["命中过滤"] = _____666E_901AQ_547D_4E2D_8FC7_6EE4,
        ["命中回调"] = _____666E_901AQ_547D_4E2D,
        ["结束回调"] = _____5904_7406_666E_901AQ_51B2_950B_7ED3_675F
    })
    if context["位移ID"] <= 0 then
        _____5904_7406_666E_901AQ_51B2_950B_7ED3_675F(caster, "中断", context["位移ID"])
    end
    addDelayedCallback(cfg["形态恢复秒"] * 1000, _____6062_590D_666E_901AQ_5F62_6001, caster)
end
local function _____666E_901AQ_4E8C_6BB5_76EE_6807_8FC7_6EE4(target)
    return _____5355_4F4D_5B58_6D3B(target) and IsUnitType(target, UNIT_TYPE_ANCIENT) ~= true and IsUnitType(target, UNIT_TYPE_MECHANICAL) ~= true
end
local function _____51C6_5907_666E_901AQ_4E8C_6BB5_4F24_5BB3(target, _index, variable)
    local context = variable
    if context == nil or not _____666E_901AQ_4E8C_6BB5_76EE_6807_8FC7_6EE4(target) then
        return nil
    end
    local isHeroOrDemon = IsUnitType(target, UNIT_TYPE_HERO) == true or IsUnitRace(target, RACE_DEMON) == true
    local multiplier = isHeroOrDemon and context["配置"]["伤害英雄恶魔攻击力倍率"] or context["配置"]["伤害普通敌人攻击力倍率"]
    return {
        ["伤害"] = context["攻击力"] * multiplier,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS
    }
end
local function _____666E_901AQ_4E8C_6BB5_547D_4E2D_540E(target, _index, success, variable)
    local context = variable
    if not success or context == nil or not _____666E_901AQ_4E8C_6BB5_76EE_6807_8FC7_6EE4(target) then
        return
    end
    _____65BD_52A0_7729_6655(
        context["施法者"],
        target,
        context["配置"]["控制秒"],
        "藤原妹红-超高温羽毛",
        "技能"
    )
    _____5F00_59CB_51FB_9000(target, {
        ["来源单位"] = context["施法者"],
        ["主单位"] = context["施法者"],
        ["主单位死亡时中断"] = true,
        ["距离"] = context["配置"]["击退距离"],
        ["持续时间"] = context["配置"]["击退持续秒"],
        ["检查地形"] = true,
        ["禁用碰撞"] = true,
        ["暂停单位"] = false
    })
end
local function _____91CA_653E_85E4_539F_59B9_7EA2_666E_901AQ_4E8C_6BB5(_context, caster, skillInstanceId)
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通Q二段"]
    _____6263_9664_6700_5927_751F_547D(caster, cfg["生命消耗最大生命比例"])
    _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local angleStep = cfg["环形特效间隔角度"] * DEG_TO_RAD
    do
        local i = 1
        while i <= 9 do
            local angle = i * angleStep
            do
                local j = 0
                while j < #cfg["环形特效半径列表"] do
                    local radius = cfg["环形特效半径列表"][j + 1]
                    _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(
                        {["模型路径"] = cfg["环形特效模型路径"], Z = 0, ["缩放"] = cfg["环形特效缩放"], ["持续秒"] = cfg["环形特效持续秒"]},
                        x + radius * Cos(angle),
                        y + radius * Sin(angle)
                    )
                    j = j + 1
                end
            end
            i = i + 1
        end
    end
    local context = {
        ["施法者"] = caster,
        ["配置"] = cfg,
        ["攻击力"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    }
    local targets = getEnemyUnitsInRange(caster, x, y, cfg["搜索范围"])
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____666E_901AQ_4E8C_6BB5_6280_80FDID,
        ["技能实例ID"] = skillInstanceId,
        ["标签"] = "藤原妹红-超高温羽毛",
        ["每目标处理器"] = _____51C6_5907_666E_901AQ_4E8C_6BB5_4F24_5BB3,
        ["每目标结算后处理器"] = _____666E_901AQ_4E8C_6BB5_547D_4E2D_540E,
        ["变量"] = context
    })
    _____6062_590D_666E_901AQ_5F62_6001(caster)
end
local function _____7B26_5361Q_547D_4E2D_8FC7_6EE4(target, caster)
    return target ~= nil and target ~= 0 and target ~= caster and _____5355_4F4D_5B58_6D3B(target) and IsUnitType(target, UNIT_TYPE_ANCIENT) ~= true and IsUnitType(target, UNIT_TYPE_MECHANICAL) ~= true and IsUnitType(target, UNIT_TYPE_STRUCTURE) ~= true
end
local function _____8BB0_5F55_7B26_5361Q_76EE_6807(context, target)
    local targetId = _____53D6_5355_4F4D_53E5_67C4ID(target)
    if targetId == 0 or context["灼烧单位表"][targetId] == true then
        return false
    end
    context["灼烧单位表"][targetId] = true
    local ____context__707C_70E7_5355_4F4D_5217_8868_11 = context["灼烧单位列表"]
    ____context__707C_70E7_5355_4F4D_5217_8868_11[#____context__707C_70E7_5355_4F4D_5217_8868_11 + 1] = target
    return true
end
local function _____51C6_5907_7B26_5361Q_9996_6B21_4F24_5BB3(target, _index, variable)
    local context = variable
    if context == nil or not _____7B26_5361Q_547D_4E2D_8FC7_6EE4(target, context["施法者"]) then
        return nil
    end
    return {
        ["伤害"] = context["伤害"] * _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡Q"]["首次伤害攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS
    }
end
local function _____51C6_5907_7B26_5361Q_707C_70E7_4F24_5BB3(target, _index, variable)
    local context = variable
    if context == nil or not _____7B26_5361Q_547D_4E2D_8FC7_6EE4(target, context["施法者"]) then
        return nil
    end
    local effects = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡Q"]["灼烧命中特效"]
    do
        local i = 0
        while i < #effects do
            _____521B_5EFA_85E4_539F_59B9_7EA2_5355_4F4D_7279_6548(target, effects[i + 1], effects[i + 1]["挂点"])
            i = i + 1
        end
    end
    return {
        ["伤害"] = context["伤害"] * _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡Q"]["灼烧伤害攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS
    }
end
local function _____7B26_5361Q_707C_70E7Tick(variable)
    local context = variable
    if context == nil then
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡Q"]
    if context["灼烧次数"] >= cfg["灼烧次数"] then
        if context["灼烧回调ID"] ~= 0 then
            removePeriodicCallback(context["灼烧回调ID"])
        end
        context["灼烧回调ID"] = 0
        __TS__Delete(
            _____7B26_5361Q_4E0A_4E0B_6587_8868,
            _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
        )
        return
    end
    context["灼烧次数"] = context["灼烧次数"] + 1
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = context["灼烧单位列表"],
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____7B26_5361Q_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "藤原妹红-符卡Q灼烧",
        ["每目标处理器"] = _____51C6_5907_7B26_5361Q_707C_70E7_4F24_5BB3,
        ["变量"] = context
    })
end
local function _____6E05_7406_7B26_5361Q(context)
    if context["移动回调ID"] ~= 0 then
        removePeriodicCallback(context["移动回调ID"])
    end
    context["移动回调ID"] = 0
    if context["灼烧回调ID"] ~= 0 then
        removePeriodicCallback(context["灼烧回调ID"])
    end
    context["灼烧回调ID"] = 0
    _____9500_6BC1_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(context["凤凰特效"])
    __TS__Delete(
        _____7B26_5361Q_4E0A_4E0B_6587_8868,
        _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    )
end
local function _____7B26_5361Q_79FB_52A8Tick(variable)
    local context = variable
    if context == nil then
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡Q"]
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406_7B26_5361Q(context)
        return
    end
    if context["已移动秒"] >= cfg["最大移动秒"] then
        if context["移动回调ID"] ~= 0 then
            removePeriodicCallback(context["移动回调ID"])
        end
        context["移动回调ID"] = 0
        if #context["灼烧单位列表"] > 0 then
            context["灼烧回调ID"] = addPeriodicCallback(cfg["灼烧间隔秒"] * 1000, _____7B26_5361Q_707C_70E7Tick, context)
        else
            __TS__Delete(
                _____7B26_5361Q_4E0A_4E0B_6587_8868,
                _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
            )
            _____9500_6BC1_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(context["凤凰特效"])
        end
        return
    end
    local step = cfg["每次移动距离"]
    local radians = context["方向角"] * DEG_TO_RAD
    context.X = context.X + step * Cos(radians)
    context.Y = context.Y + step * Sin(radians)
    context["已移动秒"] = context["已移动秒"] + cfg["移动间隔毫秒"] * 0.001
    _____66F4_65B0_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(context["凤凰特效"], context.X, context.Y)
    do
        local i = 0
        while i < #cfg["移动特效"] do
            _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(cfg["移动特效"][i + 1], context.X, context.Y)
            i = i + 1
        end
    end
    local candidates = getEnemyUnitsInRange(context["施法者"], context.X, context.Y, cfg["捕捉范围"])
    local newTargets = {}
    do
        local i = 0
        while i < #candidates do
            local target = candidates[i + 1]
            if _____7B26_5361Q_547D_4E2D_8FC7_6EE4(target, context["施法者"]) and _____8BB0_5F55_7B26_5361Q_76EE_6807(context, target) then
                newTargets[#newTargets + 1] = target
            end
            i = i + 1
        end
    end
    if #newTargets > 0 then
        _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
            ["来源"] = context["施法者"],
            ["目标列表"] = newTargets,
            ["伤害类型"] = DAMAGE_TYPE_FIRE,
            attack = false,
            ranged = false,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["技能ID"] = _____7B26_5361Q_6280_80FDID,
            ["技能实例ID"] = context["技能实例ID"],
            ["标签"] = "藤原妹红-符卡Q首次命中",
            ["每目标处理器"] = _____51C6_5907_7B26_5361Q_9996_6B21_4F24_5BB3,
            ["变量"] = context
        })
    end
end
local function _____5F00_59CB_7B26_5361Q_79FB_52A8(variable)
    local context = variable
    if context == nil or not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        if context ~= nil then
            _____6E05_7406_7B26_5361Q(context)
        end
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡Q"]
    context["凤凰特效"] = _____521B_5EFA_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(cfg["凤凰特效"], context.X, context.Y, context["方向角"])
    context["移动回调ID"] = addPeriodicCallback(cfg["移动间隔毫秒"], _____7B26_5361Q_79FB_52A8Tick, context)
end
local function _____91CA_653E_85E4_539F_59B9_7EA2_7B26_5361Q(_context, caster, skillInstanceId)
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡Q"]
    _____5173_95ED_85E4_539F_59B9_7EA2_7B26_5361_6A21_5F0F(caster, true)
    _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    local startX = GetUnitX(caster)
    local startY = GetUnitY(caster)
    local direction = _____4E24_70B9_89D2_5EA6(
        startX,
        startY,
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    _____5F00_59CB_786C_76F4(caster, cfg["硬直秒"])
    _____64AD_653E_85E4_539F_59B9_7EA2_914D_7F6E_52A8_4F5C(caster, cfg["动作编号"], cfg["动作速度"])
    SetUnitFacing(caster, direction)
    local context = {
        ["施法者"] = caster,
        X = startX,
        Y = startY,
        ["方向角"] = direction,
        ["已移动秒"] = 0,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster),
        ["移动回调ID"] = 0,
        ["灼烧回调ID"] = 0,
        ["灼烧次数"] = 0,
        ["灼烧单位表"] = {},
        ["灼烧单位列表"] = {},
        ["技能实例ID"] = skillInstanceId
    }
    _____7B26_5361Q_4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(caster)] = context
    addDelayedCallback(cfg["启动延迟秒"] * 1000, _____5F00_59CB_7B26_5361Q_79FB_52A8, context)
end
local function _____85E4_539F_59B9_7EA2Q_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(dyingUnit)
    local normalContext = _____666E_901AQ_4E0A_4E0B_6587_8868[unitId]
    if normalContext ~= nil then
        if normalContext["移动表现回调ID"] ~= 0 then
            removePeriodicCallback(normalContext["移动表现回调ID"])
        end
        _____9500_6BC1_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(normalContext["凤凰特效"])
        __TS__Delete(_____666E_901AQ_4E0A_4E0B_6587_8868, unitId)
    end
    local cardContext = _____7B26_5361Q_4E0A_4E0B_6587_8868[unitId]
    if cardContext ~= nil then
        _____6E05_7406_7B26_5361Q(cardContext)
    end
end
local function _____83B7_53D6_85E4_539F_59B9_7EA2_6280_80FD_4E0A_4E0B_6587(unit)
    return unit
end
____exports["注册藤原妹红Q技能"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-不死鸟附体",
        ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____666E_901AQ_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_85E4_539F_59B9_7EA2_6280_80FD_4E0A_4E0B_6587,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["技能实例持续秒"],
        ["释放技能"] = _____91CA_653E_85E4_539F_59B9_7EA2_666E_901AQ
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-超高温羽毛",
        ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____666E_901AQ_4E8C_6BB5_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_85E4_539F_59B9_7EA2_6280_80FD_4E0A_4E0B_6587,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["技能实例持续秒"],
        ["释放技能"] = _____91CA_653E_85E4_539F_59B9_7EA2_666E_901AQ_4E8C_6BB5
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-符卡Q",
        ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7B26_5361Q_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_85E4_539F_59B9_7EA2_6280_80FD_4E0A_4E0B_6587,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["技能实例持续秒"],
        ["释放技能"] = _____91CA_653E_85E4_539F_59B9_7EA2_7B26_5361Q
    })
    registerDeathListener(_____85E4_539F_59B9_7EA2Q_5355_4F4D_6B7B_4EA1)
end
____exports["注册藤原妹红Q技能"]()
____exports["藤原妹红Q技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["普通Q"] = "位移系统冲锋命中记录，结束时统一火焰伤害并恢复技能形态",
    ["普通Q二段"] = "配置化环形表现、分目标伤害倍率、眩晕与击退",
    ["符卡Q"] = "纯凤凰表现特效投射，首次命中后每秒三次灼烧"
}
return ____exports
