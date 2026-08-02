--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 召唤物系统 - 核心创建与属性应用
local jass = require("jass.common")
local jglobals = require("jass.globals")
local japi = require("jass.japi")
local _____5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataSet = ____require_result_0.YDUserDataSet
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_3.stringToFourCC
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_5.X_FixUnitStandingSafe
local SetUnitState = jass.SetUnitState
local SetUnitStateJapi = japi.SetUnitState
local SetUnitVertexColor = jass.SetUnitVertexColor
local SetUnitPathing = jass.SetUnitPathing
local SetUnitAcquireRange = jass.SetUnitAcquireRange
local ConvertUnitState = jass.ConvertUnitState
local UnitApplyTimedLife = jass.UnitApplyTimedLife
local DzSetUnitMissileModel = japi.DzSetUnitMissileModel
local DzSetUnitMissileArc = japi.DzSetUnitMissileArc
local DzSetUnitMissileSpeed = japi.DzSetUnitMissileSpeed
local DzSetUnitMissileHoming = japi.DzSetUnitMissileHoming
local DzSetUnitName = japi.DzSetUnitName
local DzUnitDisableAttack = japi.DzUnitDisableAttack
local CreateUnit = _____5171_4EAB.CreateUnit
local GetHandleId = _____5171_4EAB.GetHandleId
local GetOwningPlayer = _____5171_4EAB.GetOwningPlayer
local RemoveUnit = _____5171_4EAB.RemoveUnit
local SetUnitFacing = _____5171_4EAB.SetUnitFacing
local SetUnitFlyHeight = _____5171_4EAB.SetUnitFlyHeight
local SetUnitScale = _____5171_4EAB.SetUnitScale
local UnitAddAbility = _____5171_4EAB.UnitAddAbility
local UnitRemoveAbility = _____5171_4EAB.UnitRemoveAbility
local DzSetUnitModel = _____5171_4EAB.DzSetUnitModel or japi.DzSetUnitModel
local UNIT_STATE_LIFE = _____5171_4EAB.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local AMRF = 1097691750
local ATTACK_POWER_STATE = 18
local ATTACK_RANGE_STATE = 22
local ARMOR_STATE = 32
local ATTACK_INTERVAL_STATE = 37
local DEFAULT_FLY_HEIGHT = 50
local _____6B7B_4EA1_5220_9664_5EF6_8FDF_79D2_6570 = 3
local _____6A21_5757_540D = "召唤物核心"
local DEFAULT_TIMED_LIFE_BUFF = stringToFourCC("BHwe")
local _____9650_65F6_53EC_5524_7269_5220_9664_8868 = {}
local _____5DF2_6CE8_518C_9650_65F6_53EC_5524_7269_5220_9664_76D1_542C = false
local function _____8BBE_7F6E_6700_540E_521B_5EFA_5355_4F4D(unit)
    _G.bj_lastCreatedUnit = unit
    jglobals.bj_lastCreatedUnit = unit
end
local function _____8BFB_53D6_5C0F_602A_751F_547D_500D_7387()
    local hp2 = jglobals.udg_HP2
    if type(hp2) == "number" and hp2 > 0 then
        return hp2
    end
    return 1
end
local function _____8D4B_4E88_98DE_884C_9AD8_5EA6_80FD_529B(unit)
    UnitAddAbility(unit, AMRF)
    UnitRemoveAbility(unit, AMRF)
end
local function _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(unit, height)
    _____8D4B_4E88_98DE_884C_9AD8_5EA6_80FD_529B(unit)
    SetUnitFlyHeight(unit, height, 0)
end
local function _____6267_884C_53EC_5524_7269_5EF6_8FDF_5220_9664(variable)
    local unit = variable
    if unit == nil or unit == 0 then
        return
    end
    RemoveUnit(unit)
end
local function ____on_9650_65F6_53EC_5524_7269_6B7B_4EA1_5220_9664(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_8005)
    if _____6B7B_4EA1_5355_4F4D == nil or _____6B7B_4EA1_5355_4F4D == 0 then
        return
    end
    local hid = GetHandleId(_____6B7B_4EA1_5355_4F4D)
    if _____9650_65F6_53EC_5524_7269_5220_9664_8868[hid] == nil then
        return
    end
    _____9650_65F6_53EC_5524_7269_5220_9664_8868[hid] = nil
    addDelayedCallback(_____6B7B_4EA1_5220_9664_5EF6_8FDF_79D2_6570 * 1000, _____6267_884C_53EC_5524_7269_5EF6_8FDF_5220_9664, _____6B7B_4EA1_5355_4F4D)
end
local function _____786E_4FDD_9650_65F6_53EC_5524_7269_5220_9664_76D1_542C()
    if _____5DF2_6CE8_518C_9650_65F6_53EC_5524_7269_5220_9664_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_9650_65F6_53EC_5524_7269_5220_9664_76D1_542C = true
    registerDeathListener(____on_9650_65F6_53EC_5524_7269_6B7B_4EA1_5220_9664)
end
local function _____5E94_7528_53EC_5524_7269_9650_65F6_751F_547D(unit, duration)
    if unit == nil or unit == 0 then
        return
    end
    if not (duration > 0) then
        return
    end
    _____786E_4FDD_9650_65F6_53EC_5524_7269_5220_9664_76D1_542C()
    _____9650_65F6_53EC_5524_7269_5220_9664_8868[GetHandleId(unit)] = true
    UnitApplyTimedLife(unit, DEFAULT_TIMED_LIFE_BUFF, duration)
end
local function _____5E94_7528_5355_4F4D_989C_8272(unit, _____53C2_6570)
    local alpha = _____53C2_6570["透明度"]
    local red = _____53C2_6570["红"]
    local green = _____53C2_6570["绿"]
    local blue = _____53C2_6570["蓝"]
    if alpha == nil and red == nil and green == nil and blue == nil then
        return
    end
    SetUnitVertexColor(
        unit,
        red or 255,
        green or 255,
        blue or 255,
        alpha or 255
    )
end
local function _____5E94_7528_53EC_5524_7269_5C5E_6027(unit, _____53C2_6570)
    if _____53C2_6570["朝向"] ~= nil then
        SetUnitFacing(unit, _____53C2_6570["朝向"])
    end
    if _____53C2_6570["单位名称"] ~= nil and _____53C2_6570["单位名称"] ~= "" and DzSetUnitName ~= nil then
        DzSetUnitName(unit, _____53C2_6570["单位名称"])
    end
    if _____53C2_6570["飞行高度"] ~= nil then
        _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(unit, _____53C2_6570["飞行高度"])
    end
    _____5E94_7528_5355_4F4D_989C_8272(unit, _____53C2_6570)
    if _____53C2_6570["模型文件"] ~= nil and _____53C2_6570["模型文件"] ~= "" and DzSetUnitModel ~= nil then
        DzSetUnitModel(unit, _____53C2_6570["模型文件"])
    end
    if _____53C2_6570["主人单位"] ~= nil and _____53C2_6570["主人单位"] ~= 0 then
        YDUserDataSet(
            nil,
            "unit",
            unit,
            "Master",
            "unit",
            _____53C2_6570["主人单位"]
        )
    end
    if _____53C2_6570["生命值"] ~= nil and _____53C2_6570["生命值"] > 0 then
        local scaledHp = _____53C2_6570["生命值"] * (_____53C2_6570["生命值受小怪倍率"] == false and 1 or _____8BFB_53D6_5C0F_602A_751F_547D_500D_7387())
        SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, scaledHp)
        SetUnitState(unit, UNIT_STATE_LIFE, scaledHp)
    end
    if _____53C2_6570["生命恢复"] ~= nil then
        YDUserDataSet(
            nil,
            "unit",
            unit,
            "生命恢复",
            "real",
            _____53C2_6570["生命恢复"]
        )
    end
    if _____53C2_6570["攻击力"] ~= nil and _____53C2_6570["攻击力"] > 0 then
        SetUnitStateJapi(
            unit,
            ConvertUnitState(ATTACK_POWER_STATE),
            _____53C2_6570["攻击力"]
        )
    end
    if _____53C2_6570["攻击间隔"] ~= nil and _____53C2_6570["攻击间隔"] > 0 then
        SetUnitStateJapi(
            unit,
            ConvertUnitState(ATTACK_INTERVAL_STATE),
            _____53C2_6570["攻击间隔"]
        )
    end
    if _____53C2_6570["攻击范围"] ~= nil and _____53C2_6570["攻击范围"] > 0 then
        SetUnitStateJapi(
            unit,
            ConvertUnitState(ATTACK_RANGE_STATE),
            _____53C2_6570["攻击范围"]
        )
    end
    if _____53C2_6570["固定站桩"] == true then
        X_FixUnitStandingSafe(unit)
    end
    if _____53C2_6570["禁止普攻"] == true and DzUnitDisableAttack ~= nil then
        DzUnitDisableAttack(unit, true)
    end
    if _____53C2_6570["添加技能"] ~= nil then
        do
            local i = 0
            while i < #_____53C2_6570["添加技能"] do
                local _____6280_80FDID = _____53C2_6570["添加技能"][i + 1]
                if _____6280_80FDID > 0 then
                    UnitAddAbility(unit, _____6280_80FDID)
                end
                i = i + 1
            end
        end
    end
    if _____53C2_6570["禁用路径"] == true then
        SetUnitPathing(unit, false)
    end
    if _____53C2_6570["普攻弹道模型"] ~= nil and _____53C2_6570["普攻弹道模型"] ~= "" and DzSetUnitMissileModel ~= nil then
        DzSetUnitMissileModel(unit, _____53C2_6570["普攻弹道模型"])
    end
    if _____53C2_6570["普攻弹道弧度"] ~= nil and DzSetUnitMissileArc ~= nil then
        DzSetUnitMissileArc(unit, _____53C2_6570["普攻弹道弧度"])
    end
    if _____53C2_6570["普攻弹道速度"] ~= nil and _____53C2_6570["普攻弹道速度"] > 0 and DzSetUnitMissileSpeed ~= nil then
        DzSetUnitMissileSpeed(unit, _____53C2_6570["普攻弹道速度"])
    end
    if _____53C2_6570["普攻弹道自导"] ~= nil and DzSetUnitMissileHoming ~= nil then
        DzSetUnitMissileHoming(unit, _____53C2_6570["普攻弹道自导"])
    end
    if _____53C2_6570["索敌范围"] ~= nil and _____53C2_6570["索敌范围"] > 0 then
        SetUnitAcquireRange(unit, _____53C2_6570["索敌范围"])
    end
    if _____53C2_6570["护甲"] ~= nil then
        SetUnitStateJapi(
            unit,
            ConvertUnitState(ARMOR_STATE),
            _____53C2_6570["护甲"]
        )
    end
    if _____53C2_6570["缩放"] ~= nil and _____53C2_6570["缩放"] > 0 then
        SetUnitScale(unit, _____53C2_6570["缩放"], _____53C2_6570["缩放"], _____53C2_6570["缩放"])
    end
end
____exports["创建召唤物核心"] = function(_____53C2_6570)
    local summon = _____53C2_6570["召唤物单位"]
    local created = false
    debugLogForce(
        _____6A21_5757_540D,
        "进入创建",
        "summon=",
        summon,
        "owner=",
        _____53C2_6570["所属玩家"],
        "master=",
        _____53C2_6570["主人单位"],
        "unitType=",
        _____53C2_6570["单位类型"],
        "x=",
        _____53C2_6570.X,
        "y=",
        _____53C2_6570.Y,
        "facing=",
        _____53C2_6570["朝向"]
    )
    if summon == nil or summon == 0 then
        local ____53C2_6570__6240_5C5E_73A9_5BB6_7 = _____53C2_6570["所属玩家"]
        if ____53C2_6570__6240_5C5E_73A9_5BB6_7 == nil then
            local ____temp_6
            if _____53C2_6570["主人单位"] ~= nil and _____53C2_6570["主人单位"] ~= 0 then
                ____temp_6 = GetOwningPlayer(_____53C2_6570["主人单位"])
            else
                ____temp_6 = nil
            end
            ____53C2_6570__6240_5C5E_73A9_5BB6_7 = ____temp_6
        end
        local owner = ____53C2_6570__6240_5C5E_73A9_5BB6_7
        if owner == nil or owner == 0 then
            debugLogForce(_____6A21_5757_540D, "创建失败：owner 无效", owner)
            return nil
        end
        if _____53C2_6570["单位类型"] == nil or _____53C2_6570["单位类型"] == 0 then
            debugLogForce(_____6A21_5757_540D, "创建失败：unitType 无效", _____53C2_6570["单位类型"])
            return nil
        end
        summon = CreateUnit(
            owner,
            _____53C2_6570["单位类型"],
            _____53C2_6570.X,
            _____53C2_6570.Y,
            _____53C2_6570["朝向"] or 0
        )
        if summon == nil or summon == 0 then
            debugLogForce(
                _____6A21_5757_540D,
                "CreateUnit 返回空",
                "owner=",
                owner,
                "unitType=",
                _____53C2_6570["单位类型"]
            )
            return nil
        end
        created = true
        _____8BBE_7F6E_6700_540E_521B_5EFA_5355_4F4D(summon)
        _____8BBE_7F6E_5355_4F4D_98DE_884C_9AD8_5EA6(summon, _____53C2_6570["飞行高度"] or DEFAULT_FLY_HEIGHT)
        debugLogForce(_____6A21_5757_540D, "CreateUnit 成功", "summon=", summon)
    end
    _____5E94_7528_53EC_5524_7269_5C5E_6027(summon, _____53C2_6570)
    if _____53C2_6570["持续时间"] ~= nil and _____53C2_6570["持续时间"] > 0 then
        _____5E94_7528_53EC_5524_7269_9650_65F6_751F_547D(summon, _____53C2_6570["持续时间"])
    end
    debugLogForce(
        _____6A21_5757_540D,
        "返回 summon=",
        summon,
        "created=",
        created
    )
    return summon
end
return ____exports
