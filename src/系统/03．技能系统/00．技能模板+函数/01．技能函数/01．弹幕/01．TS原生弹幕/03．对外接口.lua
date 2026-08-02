local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local CreateUnit = ____01_FF0E_5171_4EAB.CreateUnit
local _____9ED8_8BA4_5F39_5E55_5355_4F4D_7C7B_578B = ____01_FF0E_5171_4EAB["默认弹幕单位类型"]
local DzGetColor = ____01_FF0E_5171_4EAB.DzGetColor
local DzSetEffectAnimation = ____01_FF0E_5171_4EAB.DzSetEffectAnimation
local DzPlayEffectAnimation = ____01_FF0E_5171_4EAB.DzPlayEffectAnimation
local DzSetEffectVertexColor = ____01_FF0E_5171_4EAB.DzSetEffectVertexColor
local DzSetEffectPos = ____01_FF0E_5171_4EAB.DzSetEffectPos
local EXEffectMatScale = ____01_FF0E_5171_4EAB.EXEffectMatScale
local DzSetUnitModel = ____01_FF0E_5171_4EAB.DzSetUnitModel
local EC_CreateEffect = ____01_FF0E_5171_4EAB.EC_CreateEffect
local GetOwningPlayer = ____01_FF0E_5171_4EAB.GetOwningPlayer
local GetUnitFacing = ____01_FF0E_5171_4EAB.GetUnitFacing
local GetUnitX = ____01_FF0E_5171_4EAB.GetUnitX
local GetUnitY = ____01_FF0E_5171_4EAB.GetUnitY
local Player = ____01_FF0E_5171_4EAB.Player
local SetUnitFlyHeight = ____01_FF0E_5171_4EAB.SetUnitFlyHeight
local SetUnitPathing = ____01_FF0E_5171_4EAB.SetUnitPathing
local SetUnitPosition = ____01_FF0E_5171_4EAB.SetUnitPosition
local SetUnitScale = ____01_FF0E_5171_4EAB.SetUnitScale
local UNIT_TYPE_ANCIENT = ____01_FF0E_5171_4EAB.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = ____01_FF0E_5171_4EAB.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_TAUREN = ____01_FF0E_5171_4EAB.UNIT_TYPE_TAUREN
local UnitAddAbility = ____01_FF0E_5171_4EAB.UnitAddAbility
local UnitAddType = ____01_FF0E_5171_4EAB.UnitAddType
local UnitRemoveAbility = ____01_FF0E_5171_4EAB.UnitRemoveAbility
local UnitRemoveType = ____01_FF0E_5171_4EAB.UnitRemoveType
local _____8757_866B_6280_80FDID = ____01_FF0E_5171_4EAB["蝗虫技能ID"]
local CosBJ = ____01_FF0E_5171_4EAB.CosBJ
local SinBJ = ____01_FF0E_5171_4EAB.SinBJ
local _____53D6_53E5_67C4ID = ____01_FF0E_5171_4EAB["取句柄ID"]
local ____02_FF0E_6CE8_518C_8868 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.02．注册表")
local _____5206_914D_539F_751F_5F39_5E55ID = ____02_FF0E_6CE8_518C_8868["分配原生弹幕ID"]
local _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B = ____02_FF0E_6CE8_518C_8868["获取原生弹幕实例"]
local _____6CE8_518C_539F_751F_5F39_5E55_5B9E_4F8B = ____02_FF0E_6CE8_518C_8868["注册原生弹幕实例"]
local _____5355_4F4D_5230_539F_751F_5F39_5E55ID = ____02_FF0E_6CE8_518C_8868["单位到原生弹幕ID"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.02．事件.index")
local _____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6 = ____index["触发原生弹幕STES事件"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．命中.index")
local _____521B_5EFA_5F39_5E55_547D_4E2D_89C4_5219_72B6_6001 = ____index["创建弹幕命中规则状态"]
local _____91CD_7F6E_5F39_5E55_547D_4E2D_89C4_5219_72B6_6001 = ____index["重置弹幕命中规则状态"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.04．驱动.index")
local _____7ED3_675F_539F_751F_5F39_5E55_5B9E_4F8B = ____index["结束原生弹幕实例"]
local _____786E_4FDD_539F_751F_5F39_5E55_9A71_52A8 = ____index["确保原生弹幕驱动"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.05．死亡事件.index")
local _____786E_4FDD_5F39_5E55_6B7B_4EA1_4E8B_4EF6_76D1_542C = ____index["确保弹幕死亡事件监听"]
____exports["销毁原生弹幕"] = function(_____5F39_5E55ID, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动销毁"
    end
    local _____5B9E_4F8B = _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B(_____5F39_5E55ID)
    if _____5B9E_4F8B == nil then
        return
    end
    _____7ED3_675F_539F_751F_5F39_5E55_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
end
____exports["造成原生弹幕阻挡伤害"] = function(_____5F39_5E55ID, _____4F24_5BB3_503C, _____6765_6E90_5355_4F4D)
    local _____5B9E_4F8B = _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B(_____5F39_5E55ID)
    if _____5B9E_4F8B == nil or _____5B9E_4F8B["已结束"] then
        return false
    end
    if _____5B9E_4F8B["弹幕单位"] == nil or _____5B9E_4F8B["弹幕单位"] == 0 then
        return false
    end
    if _____4F24_5BB3_503C <= 0 then
        return false
    end
    if _____5B9E_4F8B["参数"]["不可阻挡"] == true then
        return false
    end
    _____5B9E_4F8B["剩余生命"] = _____5B9E_4F8B["剩余生命"] - _____4F24_5BB3_503C
    local _____56DE_8C03 = _____5B9E_4F8B["参数"]["on阻挡"]
    if _____56DE_8C03 ~= nil then
        local ____6765_6E90_5355_4F4D_3 = _____6765_6E90_5355_4F4D
        if ____6765_6E90_5355_4F4D_3 == nil then
            ____6765_6E90_5355_4F4D_3 = nil
        end
        _____56DE_8C03(____6765_6E90_5355_4F4D_3, _____4F24_5BB3_503C, _____5F39_5E55ID)
    end
    local ____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6_6 = _____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6
    local ____opt_4 = _____5B9E_4F8B["参数"].STES
    ____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6_6(____opt_4 and ____opt_4["阻挡事件名"], _____5B9E_4F8B, {["来源单位"] = _____6765_6E90_5355_4F4D, ["伤害值"] = _____4F24_5BB3_503C})
    if _____5B9E_4F8B["参数"]["被阻挡时销毁"] == true or _____5B9E_4F8B["参数"]["弹幕生命值"] ~= nil and _____5B9E_4F8B["剩余生命"] <= 0 then
        _____7ED3_675F_539F_751F_5F39_5E55_5B9E_4F8B(_____5B9E_4F8B, "被阻挡")
        return true
    end
    return false
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index")
local _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB = ____require_result_0["按英雄技能距离修正上下文修正距离"]
local function _____89E3_6790_5F39_5E55_73A9_5BB6(_____53C2_6570)
    if _____53C2_6570["所属玩家"] ~= nil and _____53C2_6570["所属玩家"] ~= 0 then
        return _____53C2_6570["所属玩家"]
    end
    if _____53C2_6570["所有者"] ~= nil and _____53C2_6570["所有者"] ~= 0 then
        return GetOwningPlayer(_____53C2_6570["所有者"])
    end
    return Player(15)
end
local function _____89E3_6790_5F39_5E55X(_____53C2_6570)
    if _____53C2_6570.X ~= nil then
        return _____53C2_6570.X
    end
    if _____53C2_6570["所有者"] ~= nil and _____53C2_6570["所有者"] ~= 0 then
        return GetUnitX(_____53C2_6570["所有者"])
    end
    return 0
end
local function _____89E3_6790_5F39_5E55Y(_____53C2_6570)
    if _____53C2_6570.Y ~= nil then
        return _____53C2_6570.Y
    end
    if _____53C2_6570["所有者"] ~= nil and _____53C2_6570["所有者"] ~= 0 then
        return GetUnitY(_____53C2_6570["所有者"])
    end
    return 0
end
local function _____89E3_6790_5F39_5E55_65B9_5411(_____53C2_6570)
    if _____53C2_6570["方向角"] ~= nil then
        return _____53C2_6570["方向角"]
    end
    if _____53C2_6570["所有者"] ~= nil and _____53C2_6570["所有者"] ~= 0 then
        return GetUnitFacing(_____53C2_6570["所有者"])
    end
    return 0
end
local function _____521B_5EFA_6216_53D6_5F97_5F39_5E55_5355_4F4D(_____53C2_6570, x, y, face)
    if _____53C2_6570["载体模式"] == "特效" then
        return nil
    end
    if _____53C2_6570["弹幕单位"] ~= nil and _____53C2_6570["弹幕单位"] ~= 0 then
        return _____53C2_6570["弹幕单位"]
    end
    return CreateUnit(
        _____89E3_6790_5F39_5E55_73A9_5BB6(_____53C2_6570),
        _____53C2_6570["弹幕单位类型"] or _____9ED8_8BA4_5F39_5E55_5355_4F4D_7C7B_578B,
        x,
        y,
        face
    )
end
local function _____6FC0_6D3B_975E_725B_5934_4EBA_5F39_5E55_53EF_9009_53D6(_____5B9E_4F8B)
    if _____5B9E_4F8B["弹幕单位"] == nil or _____5B9E_4F8B["弹幕单位"] == 0 then
        return
    end
    if _____5B9E_4F8B["参数"]["不可阻挡"] == true then
        return
    end
    local face = _____5B9E_4F8B["当前方向角"]
    local x = _____5B9E_4F8B["当前X"] + CosBJ(face)
    local y = _____5B9E_4F8B["当前Y"] + SinBJ(face)
    SetUnitPosition(_____5B9E_4F8B["弹幕单位"], x, y)
    _____5B9E_4F8B["当前X"] = x
    _____5B9E_4F8B["当前Y"] = y
end
local function _____5F39_5E55_53EF_88AB_653B_51FB_6467_6BC1(_____53C2_6570)
    return _____53C2_6570["可被攻击摧毁"] == true or _____53C2_6570["可被摧毁"] == true
end
local function _____9650_5236_5F39_5E55_7279_6548_989C_8272_5B57_8282(value)
    if value < 0 then
        return 0
    end
    if value > 255 then
        return 255
    end
    return value
end
local function _____8BBE_7F6E_5F39_5E55_9644_52A0_7279_6548_989C_8272(effect, _____53C2_6570)
    if _____53C2_6570["红"] == nil or _____53C2_6570["绿"] == nil or _____53C2_6570["蓝"] == nil then
        return
    end
    DzSetEffectVertexColor(
        effect,
        DzGetColor(
            _____9650_5236_5F39_5E55_7279_6548_989C_8272_5B57_8282(_____53C2_6570["透明度"] or 255),
            _____9650_5236_5F39_5E55_7279_6548_989C_8272_5B57_8282(_____53C2_6570["红"]),
            _____9650_5236_5F39_5E55_7279_6548_989C_8272_5B57_8282(_____53C2_6570["绿"]),
            _____9650_5236_5F39_5E55_7279_6548_989C_8272_5B57_8282(_____53C2_6570["蓝"])
        )
    )
end
local function _____521D_59CB_5316_5F39_5E55_5355_4F4D_7C7B_522B(_____53C2_6570, _____5F39_5E55_5355_4F4D)
    UnitAddType(_____5F39_5E55_5355_4F4D, UNIT_TYPE_ANCIENT)
    UnitAddType(_____5F39_5E55_5355_4F4D, UNIT_TYPE_MECHANICAL)
    if _____53C2_6570["不可阻挡"] == true then
        UnitAddType(_____5F39_5E55_5355_4F4D, UNIT_TYPE_TAUREN)
    else
        UnitRemoveType(_____5F39_5E55_5355_4F4D, UNIT_TYPE_TAUREN)
    end
    if _____5F39_5E55_53EF_88AB_653B_51FB_6467_6BC1(_____53C2_6570) then
        UnitRemoveAbility(_____5F39_5E55_5355_4F4D, _____8757_866B_6280_80FDID)
    else
        UnitAddAbility(_____5F39_5E55_5355_4F4D, _____8757_866B_6280_80FDID)
    end
end
local function _____521B_5EFA_5F39_5E55_9644_52A0_7279_6548(_____53C2_6570, x, y, z, face, _____7279_6548_53C2_6570)
    if _____7279_6548_53C2_6570 == nil or _____7279_6548_53C2_6570["模型"] == "" then
        return nil
    end
    local scale = _____7279_6548_53C2_6570["缩放"] or (_____7279_6548_53C2_6570["跟随主弹幕参数"] == true and (_____53C2_6570["缩放"] or 1) or 1)
    local effect = EC_CreateEffect(
        _____7279_6548_53C2_6570["模型"],
        x,
        y,
        z,
        face + (_____7279_6548_53C2_6570["朝向角偏移"] or 0),
        scale,
        _____7279_6548_53C2_6570["动画速度"] or 1,
        -1
    )
    if effect == nil or effect == 0 then
        return nil
    end
    DzSetEffectPos(effect, x, y, z)
    if _____7279_6548_53C2_6570["动画索引"] ~= nil then
        if DzSetEffectAnimation ~= nil then
            DzSetEffectAnimation(effect, _____7279_6548_53C2_6570["动画索引"], 0)
        end
    end
    if _____7279_6548_53C2_6570["动画名称"] ~= nil and DzPlayEffectAnimation ~= nil then
        DzPlayEffectAnimation(effect, _____7279_6548_53C2_6570["动画名称"], _____7279_6548_53C2_6570["动画链接"] or "")
    end
    if _____7279_6548_53C2_6570["缩放X"] ~= nil or _____7279_6548_53C2_6570["缩放Y"] ~= nil or _____7279_6548_53C2_6570["缩放Z"] ~= nil then
        local _____7EDF_4E00_7F29_653E = scale
        EXEffectMatScale(effect, _____7279_6548_53C2_6570["缩放X"] or _____7EDF_4E00_7F29_653E, _____7279_6548_53C2_6570["缩放Y"] or _____7EDF_4E00_7F29_653E, _____7279_6548_53C2_6570["缩放Z"] or _____7EDF_4E00_7F29_653E)
    end
    _____8BBE_7F6E_5F39_5E55_9644_52A0_7279_6548_989C_8272(effect, _____7279_6548_53C2_6570)
    return effect
end
local function _____521D_59CB_5316_5F39_5E55_8868_73B0(_____53C2_6570, _____5F39_5E55_5355_4F4D, x, y, z, face)
    if _____5F39_5E55_5355_4F4D ~= nil and _____5F39_5E55_5355_4F4D ~= 0 then
        _____521D_59CB_5316_5F39_5E55_5355_4F4D_7C7B_522B(_____53C2_6570, _____5F39_5E55_5355_4F4D)
        if _____53C2_6570["模型"] ~= nil and _____53C2_6570["模型"] ~= "" and DzSetUnitModel ~= nil then
            DzSetUnitModel(_____5F39_5E55_5355_4F4D, _____53C2_6570["模型"])
        end
        local _____7F29_653E = _____53C2_6570["缩放"] or 1
        if _____7F29_653E > 0 then
            SetUnitScale(_____5F39_5E55_5355_4F4D, _____7F29_653E, _____7F29_653E, _____7F29_653E)
        end
        if _____53C2_6570["飞行高度"] ~= nil then
            SetUnitFlyHeight(_____5F39_5E55_5355_4F4D, _____53C2_6570["飞行高度"], 0)
        end
        if _____53C2_6570["禁用碰撞"] ~= false then
            SetUnitPathing(_____5F39_5E55_5355_4F4D, false)
        end
    end
    local legacyEffect = _____53C2_6570["附着特效模型"] ~= nil and _____53C2_6570["附着特效模型"] ~= "" and ({["模型"] = _____53C2_6570["附着特效模型"], ["附着点"] = _____53C2_6570["附着点"]}) or nil
    return {
        _____521B_5EFA_5F39_5E55_9644_52A0_7279_6548(
            _____53C2_6570,
            x,
            y,
            z,
            face,
            _____53C2_6570["附加特效1"] or legacyEffect
        ),
        _____521B_5EFA_5F39_5E55_9644_52A0_7279_6548(
            _____53C2_6570,
            x,
            y,
            z,
            face,
            _____53C2_6570["附加特效2"]
        )
    }
end
local function _____5F52_4E00_5316_5F39_5E55_8DDD_79BB_53C2_6570(_____53C2_6570)
    if _____53C2_6570["最大距离"] == nil or _____53C2_6570["最大距离"] <= 0 then
        return _____53C2_6570
    end
    return __TS__ObjectAssign(
        {},
        _____53C2_6570,
        {["最大距离"] = _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB(_____53C2_6570["最大距离"], _____53C2_6570["英雄技能距离修正"], "弹幕飞行距离")}
    )
end
local function _____521B_5EFA_5F39_5E55_5B9E_4F8B_5BF9_8C61(_____5B9E_4F8B)
    return {
        ["弹幕ID"] = _____5B9E_4F8B.id,
        ["弹幕单位"] = _____5B9E_4F8B["弹幕单位"],
        ["弹幕特效1"] = _____5B9E_4F8B["附加特效1"],
        ["弹幕特效2"] = _____5B9E_4F8B["附加特效2"],
        ["获取剩余生命"] = function()
            local _____5F53_524D = _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B(_____5B9E_4F8B.id)
            return _____5F53_524D ~= nil and _____5F53_524D["剩余生命"] or 0
        end,
        ["造成阻挡伤害"] = function(_____4F24_5BB3_503C, _____6765_6E90_5355_4F4D)
            return ____exports["造成原生弹幕阻挡伤害"](_____5B9E_4F8B.id, _____4F24_5BB3_503C, _____6765_6E90_5355_4F4D)
        end,
        ["销毁"] = function(_____539F_56E0)
            ____exports["销毁原生弹幕"](_____5B9E_4F8B.id, _____539F_56E0 or "手动销毁")
        end
    }
end
____exports["创建原生弹幕"] = function(_____53C2_6570)
    _____53C2_6570 = _____5F52_4E00_5316_5F39_5E55_8DDD_79BB_53C2_6570(_____53C2_6570)
    local x = _____89E3_6790_5F39_5E55X(_____53C2_6570)
    local y = _____89E3_6790_5F39_5E55Y(_____53C2_6570)
    local face = _____89E3_6790_5F39_5E55_65B9_5411(_____53C2_6570)
    local z = _____53C2_6570["飞行高度"] or 0
    local _____5F39_5E55_5355_4F4D = _____521B_5EFA_6216_53D6_5F97_5F39_5E55_5355_4F4D(_____53C2_6570, x, y, face)
    local id = _____5206_914D_539F_751F_5F39_5E55ID()
    local _____5B9E_4F8B = {
        id = id,
        ["参数"] = _____53C2_6570,
        ["弹幕单位"] = _____5F39_5E55_5355_4F4D,
        ["当前X"] = x,
        ["当前Y"] = y,
        ["当前Z"] = z,
        ["当前方向角"] = face,
        ["当前速度"] = _____53C2_6570["速度"],
        ["当前伤害值"] = _____53C2_6570["伤害值"] or 0,
        ["已飞行距离"] = 0,
        ["已运行时间"] = 0,
        ["剩余生命"] = _____53C2_6570["弹幕生命值"] or 0,
        ["弹射次数"] = 0,
        ["已结束"] = false,
        ["附加特效1"] = nil,
        ["附加特效2"] = nil,
        ["命中规则状态"] = nil
    }
    local _____9644_52A0_7279_6548 = _____521D_59CB_5316_5F39_5E55_8868_73B0(
        _____53C2_6570,
        _____5F39_5E55_5355_4F4D,
        x,
        y,
        z,
        face
    )
    _____5B9E_4F8B["附加特效1"] = _____9644_52A0_7279_6548[1]
    _____5B9E_4F8B["附加特效2"] = _____9644_52A0_7279_6548[2]
    _____6FC0_6D3B_975E_725B_5934_4EBA_5F39_5E55_53EF_9009_53D6(_____5B9E_4F8B)
    _____5B9E_4F8B["命中规则状态"] = _____521B_5EFA_5F39_5E55_547D_4E2D_89C4_5219_72B6_6001(_____5B9E_4F8B)
    _____6CE8_518C_539F_751F_5F39_5E55_5B9E_4F8B(
        _____5B9E_4F8B,
        _____53D6_53E5_67C4ID(_____5F39_5E55_5355_4F4D)
    )
    if _____5F39_5E55_5355_4F4D ~= nil and _____5F39_5E55_5355_4F4D ~= 0 then
        _____786E_4FDD_5F39_5E55_6B7B_4EA1_4E8B_4EF6_76D1_542C()
    end
    _____786E_4FDD_539F_751F_5F39_5E55_9A71_52A8()
    return _____521B_5EFA_5F39_5E55_5B9E_4F8B_5BF9_8C61(_____5B9E_4F8B)
end
____exports["获取原生弹幕"] = function(_____5F39_5E55ID)
    return _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B(_____5F39_5E55ID)
end
____exports["获取单位原生弹幕ID"] = function(_____5355_4F4D)
    local id = _____5355_4F4D_5230_539F_751F_5F39_5E55ID[_____53D6_53E5_67C4ID(_____5355_4F4D)]
    return id or 0
end
____exports["重置原生弹幕命中记录"] = function(_____5F39_5E55ID)
    local _____5B9E_4F8B = _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B(_____5F39_5E55ID)
    if _____5B9E_4F8B == nil or _____5B9E_4F8B["已结束"] then
        return false
    end
    _____91CD_7F6E_5F39_5E55_547D_4E2D_89C4_5219_72B6_6001(_____5B9E_4F8B)
    return true
end
____exports["按单位造成原生弹幕阻挡伤害"] = function(_____5F39_5E55_5355_4F4D, _____4F24_5BB3_503C, _____6765_6E90_5355_4F4D)
    local id = ____exports["获取单位原生弹幕ID"](_____5F39_5E55_5355_4F4D)
    if id <= 0 then
        return false
    end
    return ____exports["造成原生弹幕阻挡伤害"](id, _____4F24_5BB3_503C, _____6765_6E90_5355_4F4D)
end
return ____exports
