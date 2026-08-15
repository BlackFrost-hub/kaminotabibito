local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_5355_4F4D_53E5_67C4ID, _____6E05_7406D_4E0A_4E0B_6587, _____6E05_7406D_5230_671F, _____79FB_9664_5355_4F4D_6307_5B9ABuff, YDWESetUnitAbilityStateSafe, removeDelayedCallback, removePeriodicCallback, GetHandleId, RemoveUnit, SetUnitFlyHeight, _____914D_7F6E, ____E_6280_80FD_7C7B_578BID, _____4E0A_4E0B_6587_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.00．配置")
local _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["坂井悠二技能配置"]
local ____05_FF0E_5742_4E95_60A0_4E8C = require("系统.05．Buff系统.03．Buff表.02．英雄.05．坂井悠二")
local _____5742_4E95_60A0_4E8CBuffID = ____05_FF0E_5742_4E95_60A0_4E8C["坂井悠二BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
function _____6E05_7406D_4E0A_4E0B_6587(context)
    local caster = context["施法者"]
    if context["鼓舞回调ID"] ~= 0 then
        removePeriodicCallback(context["鼓舞回调ID"])
        context["鼓舞回调ID"] = 0
    end
    if context["马甲更新回调ID"] ~= 0 then
        removePeriodicCallback(context["马甲更新回调ID"])
        context["马甲更新回调ID"] = 0
    end
    if context["清理回调ID"] ~= 0 then
        removeDelayedCallback(context["清理回调ID"])
        context["清理回调ID"] = 0
    end
    if caster ~= nil and caster ~= 0 and _____5355_4F4D_5B58_6D3B(caster) then
        SetUnitFlyHeight(caster, context["施法前英雄飞行高度"], 0)
        YDWESetUnitAbilityStateSafe(caster, ____E_6280_80FD_7C7B_578BID, 1, _____914D_7F6E["结束恢复E冷却秒"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, _____5742_4E95_60A0_4E8CBuffID["D暗属性加成"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, _____5742_4E95_60A0_4E8CBuffID["D期间状态"])
    end
    for ____, ____value in ipairs(__TS__ObjectEntries(context["已鼓舞友军"])) do
        local hidStr = ____value[1]
        local _____5DF2_9F13_821E = ____value[2]
        do
            if not _____5DF2_9F13_821E then
                goto __continue16
            end
            local hid = __TS__Number(hidStr)
            local ____ = hid
        end
        ::__continue16::
    end
    if context["马甲一"] ~= nil and context["马甲一"] ~= 0 then
        RemoveUnit(context["马甲一"])
        context["马甲一"] = nil
    end
    do
        local i = 0
        while i < #context["马甲二"] do
            local _____9A6C_7532 = context["马甲二"][i + 1]
            if _____9A6C_7532 ~= nil and _____9A6C_7532 ~= 0 then
                RemoveUnit(_____9A6C_7532)
            end
            i = i + 1
        end
    end
    context["马甲二"] = {}
    context["已鼓舞友军"] = {}
    context["已启动"] = false
    local id = _____53D6_5355_4F4D_53E5_67C4ID(caster)
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
end
function _____6E05_7406D_5230_671F(context)
    local ctx = context
    if ctx ~= nil then
        _____6E05_7406D_4E0A_4E0B_6587(ctx)
    end
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWESetUnitAbilityStateSafe = ____require_result_1.YDWESetUnitAbilityStateSafe
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
removeDelayedCallback = ____require_result_2.removeDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
local GetHeroLevel = jass.GetHeroLevel
local GetHeroStr = jass.GetHeroStr
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local CreateUnit = jass.CreateUnit
RemoveUnit = jass.RemoveUnit
SetUnitFlyHeight = jass.SetUnitFlyHeight
local ____jass_GetUnitFlyHeight_4 = jass.GetUnitFlyHeight
if ____jass_GetUnitFlyHeight_4 == nil then
    ____jass_GetUnitFlyHeight_4 = function(_u) return 0 end
end
local GetUnitFlyHeight = ____jass_GetUnitFlyHeight_4
local SetUnitScale = jass.SetUnitScale
local SetUnitVertexColor = jass.SetUnitVertexColor
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local GetRandomReal = jass.GetRandomReal
local ForGroup = jass.ForGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local GetEnumUnit = jass.GetEnumUnit
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local ____jass_Filter_6 = jass.Filter
if ____jass_Filter_6 == nil then
    ____jass_Filter_6 = function(_f) return true end
end
local FilterBoolExpr = ____jass_Filter_6
local IsUnitAlly = jass.IsUnitAlly
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
_____914D_7F6E = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.D
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E["单位类型ID"]
local ____D_6280_80FDID_5B57_7B26_4E32 = _____914D_7F6E["技能ID"]
____E_6280_80FD_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.E["技能类型ID"]
_____4E0A_4E0B_6587_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____83B7_53D6D_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if id == 0 then
        return nil
    end
    return _____4E0A_4E0B_6587_8868[id]
end
local function _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if id == 0 then
        return nil
    end
    local current = _____4E0A_4E0B_6587_8868[id]
    if current ~= nil then
        return current
    end
    local created = {
        ["施法者"] = unit,
        ["已启动"] = false,
        ["鼓舞回调ID"] = 0,
        ["马甲更新回调ID"] = 0,
        ["清理回调ID"] = 0,
        ["施法前英雄飞行高度"] = 0,
        ["马甲一"] = nil,
        ["马甲二"] = {},
        ["已鼓舞友军"] = {}
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function _____6267_884C_9F13_821E(context)
    local ctx = context
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6E05_7406D_4E0A_4E0B_6587(ctx)
        return
    end
    local _____8303_56F4 = _____914D_7F6E["鼓舞"]["范围"]
    local owner = GetOwningPlayer(caster)
    local group = CreateGroup()
    GroupEnumUnitsInRange(
        group,
        GetUnitX(caster),
        GetUnitY(caster),
        _____8303_56F4,
        nil
    )
    ForGroup(
        group,
        function()
            local u = GetEnumUnit()
            if u == nil or u == 0 then
                return
            end
            if u == caster then
                return
            end
            if not IsUnitAlly(u, owner) then
                return
            end
            if IsUnitType(u, UNIT_TYPE_DEAD) or IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                return
            end
            if not _____5355_4F4D_5B58_6D3B(u) then
                return
            end
            registerManualBuff(
                u,
                _____5742_4E95_60A0_4E8CBuffID["D鼓舞"],
                _____914D_7F6E["持续秒"],
                _____914D_7F6E["鼓舞"]["攻击力基础倍率"],
                {["来源"] = caster, ["来源类型"] = "技能", ["标签"] = "坂井悠二-D-鼓舞"}
            )
            local hid = _____53D6_5355_4F4D_53E5_67C4ID(u)
            if hid ~= 0 then
                ctx["已鼓舞友军"][hid] = true
            end
        end
    )
    DestroyGroup(group)
end
local function _____66F4_65B0_9A6C_7532_4E8C_4F4D_7F6E(context)
    local ctx = context
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local _____4E2D_5FC3X = GetUnitX(caster)
    local _____4E2D_5FC3Y = GetUnitY(caster)
    local _____65BD_6CD5_8005_9762_5411 = GetUnitFacing(caster)
    do
        local i = 0
        while i < #ctx["马甲二"] do
            do
                local _____9A6C_7532 = ctx["马甲二"][i + 1]
                if _____9A6C_7532 == nil or _____9A6C_7532 == 0 then
                    goto __continue38
                end
                local _____521D_59CB = _____914D_7F6E["马甲二"]["初始"][i + 1]
                local ____521D_59CB__8DDD_79BB_7 = _____521D_59CB["距离"]
                if ____521D_59CB__8DDD_79BB_7 == nil then
                    ____521D_59CB__8DDD_79BB_7 = 600
                end
                local _____8DDD_79BB = ____521D_59CB__8DDD_79BB_7
                local ____521D_59CB__89D2_5EA6_8 = _____521D_59CB["角度"]
                if ____521D_59CB__89D2_5EA6_8 == nil then
                    ____521D_59CB__89D2_5EA6_8 = 0
                end
                local _____89D2_5EA6 = ____521D_59CB__89D2_5EA6_8 + _____65BD_6CD5_8005_9762_5411
                local _____5F27_5EA6 = _____89D2_5EA6 * (3.14159265358979 / 180)
                local x = _____4E2D_5FC3X + _____8DDD_79BB * math.cos(_____5F27_5EA6)
                local y = _____4E2D_5FC3Y + _____8DDD_79BB * math.sin(_____5F27_5EA6)
                SetUnitPosition(_____9A6C_7532, x, y)
                SetUnitFacing(_____9A6C_7532, _____89D2_5EA6 + 180)
            end
            ::__continue38::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_9A6C_7532(context)
    local caster = context["施法者"]
    local owner = GetOwningPlayer(caster)
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local _____65BD_6CD5_8005_9762_5411 = GetUnitFacing(caster)
    if _____914D_7F6E["马甲一"]["单位类型ID"] ~= "待查" then
        local _____56DBCC = stringToFourCC(_____914D_7F6E["马甲一"]["单位类型ID"])
        local _____9A6C_7532 = CreateUnit(
            owner,
            _____56DBCC,
            x,
            y,
            _____65BD_6CD5_8005_9762_5411
        )
        context["马甲一"] = _____9A6C_7532
        if _____9A6C_7532 ~= nil and _____9A6C_7532 ~= 0 then
            SetUnitAnimationByIndex(_____9A6C_7532, _____914D_7F6E["马甲一"]["动画编号"])
            SetUnitTimeScale(_____9A6C_7532, _____914D_7F6E["马甲一"]["时间缩放"])
            SetUnitScale(_____9A6C_7532, _____914D_7F6E["马甲一"]["缩放"], _____914D_7F6E["马甲一"]["缩放"], _____914D_7F6E["马甲一"]["缩放"])
            SetUnitVertexColor(
                _____9A6C_7532,
                _____914D_7F6E["马甲一"]["颜色"]["红"],
                _____914D_7F6E["马甲一"]["颜色"]["绿"],
                _____914D_7F6E["马甲一"]["颜色"]["蓝"],
                _____914D_7F6E["马甲一"]["颜色"]["透明度"]
            )
            SetUnitFlyHeight(
                _____9A6C_7532,
                _____914D_7F6E["马甲一"]["飞行高度增量"] + GetUnitFlyHeight(caster),
                0
            )
            AddSpecialEffectTarget(_____914D_7F6E["马甲一"]["特效"]["模型路径"], _____9A6C_7532, _____914D_7F6E["马甲一"]["特效"]["挂点"])
        end
    end
    do
        local i = 0
        while i < _____914D_7F6E["马甲二"]["数量"] do
            do
                if _____914D_7F6E["马甲二"]["单位类型ID"] == "待查" then
                    local ____context__9A6C_7532_4E8C_9 = context["马甲二"]
                    ____context__9A6C_7532_4E8C_9[#____context__9A6C_7532_4E8C_9 + 1] = nil
                    goto __continue44
                end
                local _____56DBCC = stringToFourCC(_____914D_7F6E["马甲二"]["单位类型ID"])
                local _____9A6C_7532 = CreateUnit(
                    owner,
                    _____56DBCC,
                    x,
                    y,
                    _____65BD_6CD5_8005_9762_5411
                )
                local ____context__9A6C_7532_4E8C_10 = context["马甲二"]
                ____context__9A6C_7532_4E8C_10[#____context__9A6C_7532_4E8C_10 + 1] = _____9A6C_7532
                if _____9A6C_7532 ~= nil and _____9A6C_7532 ~= 0 then
                    SetUnitAnimationByIndex(_____9A6C_7532, _____914D_7F6E["马甲二"]["动画编号"])
                    SetUnitTimeScale(_____9A6C_7532, _____914D_7F6E["马甲二"]["时间缩放"])
                    SetUnitScale(_____9A6C_7532, _____914D_7F6E["马甲二"]["缩放"], _____914D_7F6E["马甲二"]["缩放"], _____914D_7F6E["马甲二"]["缩放"])
                    SetUnitVertexColor(
                        _____9A6C_7532,
                        _____914D_7F6E["马甲二"]["颜色"]["红"],
                        _____914D_7F6E["马甲二"]["颜色"]["绿"],
                        _____914D_7F6E["马甲二"]["颜色"]["蓝"],
                        _____914D_7F6E["马甲二"]["颜色"]["透明度"]
                    )
                    SetUnitFlyHeight(
                        _____9A6C_7532,
                        _____914D_7F6E["马甲二"]["飞行高度增量"] + GetUnitFlyHeight(caster),
                        0
                    )
                    do
                        local j = 0
                        while j < #_____914D_7F6E["马甲二"]["特效"] do
                            local _____7279_6548_914D_7F6E = _____914D_7F6E["马甲二"]["特效"][j + 1]
                            AddSpecialEffectTarget(_____7279_6548_914D_7F6E["模型路径"], _____9A6C_7532, _____7279_6548_914D_7F6E["挂点"])
                            j = j + 1
                        end
                    end
                end
            end
            ::__continue44::
            i = i + 1
        end
    end
end
local function _____91CA_653ED_6280_80FD(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["已启动"] then
        return
    end
    local _____7B49_7EA7 = GetHeroLevel(caster)
    if _____7B49_7EA7 < _____914D_7F6E["条件"]["最低英雄等级"] then
        return
    end
    local _____529B_91CF = GetHeroStr(caster, true)
    if _____529B_91CF <= _____914D_7F6E["条件"]["最低力量"] then
        return
    end
    context["已启动"] = true
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["施法前英雄飞行高度"] = GetUnitFlyHeight(caster)
    SetUnitFlyHeight(caster, context["施法前英雄飞行高度"] + _____914D_7F6E["英雄飞行高度增量"], 0)
    registerManualBuff(
        caster,
        _____5742_4E95_60A0_4E8CBuffID["D期间状态"],
        _____914D_7F6E["持续秒"],
        1,
        {["来源"] = caster, ["来源类型"] = "技能", ["标签"] = "坂井悠二-D-状态"}
    )
    registerManualBuff(
        caster,
        _____5742_4E95_60A0_4E8CBuffID["D暗属性加成"],
        _____914D_7F6E["持续秒"],
        _____914D_7F6E["期间"]["暗属性伤害加成"],
        {["来源"] = caster, ["来源类型"] = "技能", ["标签"] = "坂井悠二-D-暗属性"}
    )
    YDWESetUnitAbilityStateSafe(caster, ____E_6280_80FD_7C7B_578BID, 1, _____914D_7F6E["期间"]["E技能冷却秒"])
    _____521B_5EFA_9A6C_7532(context)
    context["鼓舞回调ID"] = addPeriodicCallback(_____914D_7F6E["鼓舞"]["更新周期秒"] * 1000, _____6267_884C_9F13_821E, context)
    _____6267_884C_9F13_821E(context)
    context["马甲更新回调ID"] = addPeriodicCallback(_____914D_7F6E["马甲二"]["更新周期秒"] * 1000, _____66F4_65B0_9A6C_7532_4E8C_4F4D_7F6E, context)
    context["清理回调ID"] = addDelayedCallback(_____914D_7F6E["持续秒"] * 1000, _____6E05_7406D_5230_671F, context)
end
local function ____D_53EF_91CA_653E(context)
    return not context["已启动"] and context["鼓舞回调ID"] == 0
end
local function ____D_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____83B7_53D6D_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____6E05_7406D_4E0A_4E0B_6587(context)
    end
end
____exports["注册坂井悠二D"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "坂井悠二-祭礼之蛇（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = ____D_6280_80FDID_5B57_7B26_4E32,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587,
        ["可释放"] = ____D_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653ED_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____914D_7F6E["持续秒"] + 1
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____D_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册坂井悠二D"]()
____exports["坂井悠二D技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = false,
    ["伤害形态"] = "无直接伤害，提供 10秒强化状态 + 友军鼓舞",
    ["期间效果"] = "暗属性+30%、E冷却固定2.5秒、飞行高度+500、每1秒鼓舞800范围友军",
    ["前置条件"] = "等级≥40、力量>300（神门阶段==4 由外部状态判定）"
}
return ____exports
