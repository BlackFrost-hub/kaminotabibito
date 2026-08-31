local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____7ED3_675FW_65BD_6CD5, _____5904_7406W_7B2C_4E8C_6BB5_76EE_6807, _____79FB_52A8W_7B2C_4E8C_6BB5_76EE_6807, _____9006_56DE_5341_516D_591CW_7B2C_4E8C_6BB5AOETick, _____9006_56DE_5341_516D_591CW_7B2C_4E8C_6BB5_81EA_8EAB_79FB_52A8Tick, addPeriodicCallback, removePeriodicCallback, _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321, _____79FB_9664_5355_4F4D_6682_505C, _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3, getEnemyUnitsInRange, _____65BD_52A0_7729_6655, _____5355_4F4D_5B58_6D3B, GetUnitX, GetUnitY, SetUnitFlyHeight, SetUnitX, SetUnitY, SetUnitFacing, GetHandleId, SetUnitTimeScale, DAMAGE_TYPE_ENHANCED, ____W_6280_80FD_7C7B_578BID, ____W_6682_505C_6765_6E90, ____W_5F53_524D_65BD_6CD5_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.06．逆回十六夜.00．配置")
local _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["逆回十六夜单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____7ED3_675FW_65BD_6CD5(record)
    if not record.active then
        return
    end
    record.active = false
    if record["阶段回调ID"] > 0 then
        removePeriodicCallback(record["阶段回调ID"])
        record["阶段回调ID"] = 0
    end
    if record["第二段AOE回调ID"] > 0 then
        removePeriodicCallback(record["第二段AOE回调ID"])
        record["第二段AOE回调ID"] = 0
    end
    local unitId = record.unit ~= nil and record.unit ~= 0 and GetHandleId(record.unit) or 0
    if unitId > 0 and ____W_5F53_524D_65BD_6CD5_8868[unitId] == record then
        __TS__Delete(____W_5F53_524D_65BD_6CD5_8868, unitId)
    end
    if _____5355_4F4D_5B58_6D3B(record.unit) then
        _____79FB_9664_5355_4F4D_6682_505C(record.unit, ____W_6682_505C_6765_6E90)
        SetUnitFlyHeight(record.unit, record.initialFlyHeight, 0)
        SetUnitTimeScale(record.unit, 1)
    end
end
function _____5904_7406W_7B2C_4E8C_6BB5_76EE_6807(target, _index, variable)
    local record = variable
    if record == nil or not record.active or not _____5355_4F4D_5B58_6D3B(target) then
        return nil
    end
    local targetId = GetHandleId(target)
    if record["已命中目标"][targetId] or record["已撞墙目标"][targetId] then
        return nil
    end
    record["已命中目标"][targetId] = true
    local ____record__7B2C_4E8C_6BB5_76EE_6807_5217_8868_11 = record["第二段目标列表"]
    ____record__7B2C_4E8C_6BB5_76EE_6807_5217_8868_11[#____record__7B2C_4E8C_6BB5_76EE_6807_5217_8868_11 + 1] = target
    _____65BD_52A0_7729_6655(
        record.unit,
        target,
        _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W["第二段眩晕秒"],
        "重拳击飞-第二段",
        "技能"
    )
    return {}
end
function _____79FB_52A8W_7B2C_4E8C_6BB5_76EE_6807(record)
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W
    do
        local i = 0
        while i < #record["第二段目标列表"] do
            do
                local target = record["第二段目标列表"][i + 1]
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue18
                end
                local targetId = GetHandleId(target)
                if record["已撞墙目标"][targetId] then
                    goto __continue18
                end
                local result = _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321({
                    ["起点X"] = GetUnitX(target),
                    ["起点Y"] = GetUnitY(target),
                    ["角度度"] = record.angle,
                    ["单步距离"] = cfg["第二段每次移动距离"],
                    ["步数"] = 1,
                    ["检测单位"] = target
                })
                if result["是否提前停止"] then
                    record["已撞墙目标"][targetId] = true
                    _____65BD_52A0_7729_6655(
                        record.unit,
                        target,
                        cfg["撞墙眩晕秒"],
                        "重拳击飞-撞墙",
                        "技能"
                    )
                    goto __continue18
                end
                SetUnitFacing(target, record.angle)
                SetUnitX(target, result["最终X"])
                SetUnitY(target, result["最终Y"])
            end
            ::__continue18::
            i = i + 1
        end
    end
end
function _____9006_56DE_5341_516D_591CW_7B2C_4E8C_6BB5AOETick(variable)
    local record = variable
    if record == nil or not record.active then
        return
    end
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W
    if not _____5355_4F4D_5B58_6D3B(record.unit) or not _____5355_4F4D_5B58_6D3B(record.target) then
        _____7ED3_675FW_65BD_6CD5(record)
        return
    end
    if record["第二段循环计数"] >= cfg["第二段循环次数"] then
        _____7ED3_675FW_65BD_6CD5(record)
        return
    end
    record["第二段循环计数"] = record["第二段循环计数"] + 1
    local targets = getEnemyUnitsInRange(
        record.unit,
        GetUnitX(record.target),
        GetUnitY(record.target),
        cfg["第二段搜索半径"]
    )
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = record.unit,
        ["目标列表"] = targets,
        ["伤害"] = record.attack * cfg["第二段攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        attack = false,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = record.skillInstanceId,
        ["参与技能伤害加成"] = true,
        ["标签"] = "逆回十六夜-重拳击飞-第二段",
        ["每目标处理器"] = _____5904_7406W_7B2C_4E8C_6BB5_76EE_6807,
        ["变量"] = record
    })
    _____79FB_52A8W_7B2C_4E8C_6BB5_76EE_6807(record)
end
function _____9006_56DE_5341_516D_591CW_7B2C_4E8C_6BB5_81EA_8EAB_79FB_52A8Tick(variable)
    local record = variable
    if record == nil or not record.active then
        return
    end
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W
    if not _____5355_4F4D_5B58_6D3B(record.unit) or not _____5355_4F4D_5B58_6D3B(record.target) then
        _____7ED3_675FW_65BD_6CD5(record)
        return
    end
    if record["循环计数"] >= cfg["贴近循环次数"] then
        if record["阶段回调ID"] > 0 then
            removePeriodicCallback(record["阶段回调ID"])
        end
        record["阶段回调ID"] = 0
        _____79FB_9664_5355_4F4D_6682_505C(record.unit, ____W_6682_505C_6765_6E90)
        SetUnitTimeScale(record.unit, 1)
        record["阶段"] = "第二段AOE"
        record["循环计数"] = 0
        record["第二段AOE回调ID"] = addPeriodicCallback(cfg["第二段循环间隔秒"] * 1000, _____9006_56DE_5341_516D_591CW_7B2C_4E8C_6BB5AOETick, record)
        return
    end
    record["循环计数"] = record["循环计数"] + 1
    local result = _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321({
        ["起点X"] = GetUnitX(record.unit),
        ["起点Y"] = GetUnitY(record.unit),
        ["角度度"] = record.angle,
        ["单步距离"] = cfg["贴近每次移动距离"],
        ["步数"] = 1,
        ["检测单位"] = record.unit
    })
    if result["是否提前停止"] then
        record["循环计数"] = cfg["贴近循环次数"]
        SetUnitTimeScale(record.unit, 1)
        return
    end
    SetUnitFacing(record.unit, record.angle)
    SetUnitX(record.unit, result["最终X"])
    SetUnitY(record.unit, result["最终Y"])
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.07．YDWETimerDestroyUnit")
local YDWETimerDestroyUnit = ____require_result_2.YDWETimerDestroyUnit
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进")
_____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321 = ____require_result_3["沿角度步进直到地形阻挡"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_5["造成单体技能伤害"]
_____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_5["造成批量AOE技能伤害"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
getEnemyUnitsInRange = ____require_result_6.getEnemyUnitsInRange
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
_____65BD_52A0_7729_6655 = ____require_result_7["施加眩晕"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_8["读取单位攻击力"]
_____5355_4F4D_5B58_6D3B = ____require_result_8["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_8["两点角度"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local ____require_result_10 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_10.Sound3DII_UnitPlayReuse
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
SetUnitFlyHeight = jass.SetUnitFlyHeight
SetUnitX = jass.SetUnitX
SetUnitY = jass.SetUnitY
SetUnitFacing = jass.SetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
GetHandleId = jass.GetHandleId
local GetRandomInt = jass.GetRandomInt
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
____W_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"])
____W_6682_505C_6765_6E90 = "逆回十六夜-重拳击飞"
____W_5F53_524D_65BD_6CD5_8868 = {}
local function _____83B7_53D6W_4E0A_4E0B_6587(unit)
    return {unit = unit}
end
local function _____64AD_653EW_5168_5C40_97F3_6548(unit, soundKey)
    local soundHandle = jglobals[soundKey]
    if unit == nil or unit == 0 or soundHandle == nil or soundHandle == 0 then
        return
    end
    jass.AttachSoundToUnit(soundHandle, unit)
    jass.SetSoundVolume(soundHandle, 127)
    jass.StartSound(soundHandle)
end
local function _____521B_5EFAW_8868_73B0_5355_4F4D(owner, typeId, x, y, facing)
    local _____8868_73B0_5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        stringToFourCCSafe(typeId),
        x,
        y,
        facing
    )
    if _____8868_73B0_5355_4F4D ~= nil and _____8868_73B0_5355_4F4D ~= 0 then
        YDWETimerDestroyUnit(_____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W["表现单位持续秒"], _____8868_73B0_5355_4F4D)
    end
    return _____8868_73B0_5355_4F4D
end
local function _____8FDB_5165W_7B2C_4E8C_6BB5(record)
    if not record.active or not _____5355_4F4D_5B58_6D3B(record.unit) or not _____5355_4F4D_5B58_6D3B(record.target) then
        _____7ED3_675FW_65BD_6CD5(record)
        return
    end
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W
    local owner = GetOwningPlayer(record.unit)
    _____521B_5EFAW_8868_73B0_5355_4F4D(
        owner,
        cfg["第二段起始特效单位类型ID"],
        GetUnitX(record.target),
        GetUnitY(record.target),
        record.angle + 90
    )
    local _____98DE_8E22_7279_6548 = _____521B_5EFAW_8868_73B0_5355_4F4D(
        owner,
        cfg["飞踢特效单位类型ID"],
        GetUnitX(record.unit),
        GetUnitY(record.unit),
        record.angle + 90
    )
    if _____98DE_8E22_7279_6548 ~= nil and _____98DE_8E22_7279_6548 ~= 0 then
        SetUnitTimeScale(_____98DE_8E22_7279_6548, cfg["飞踢特效动作速度"])
        SetUnitFlyHeight(_____98DE_8E22_7279_6548, record.initialFlyHeight, 0)
    end
    record["阶段"] = "第二段自身移动"
    record["循环计数"] = 0
    record["阶段回调ID"] = addPeriodicCallback(cfg["第一段循环间隔秒"] * 1000, _____9006_56DE_5341_516D_591CW_7B2C_4E8C_6BB5_81EA_8EAB_79FB_52A8Tick, record)
end
local function _____9006_56DE_5341_516D_591CW_7B2C_4E00_6BB5_547D_4E2D(record)
    if record == nil or not record.active then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(record.unit) or not _____5355_4F4D_5B58_6D3B(record.target) then
        _____7ED3_675FW_65BD_6CD5(record)
        return
    end
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W
    _____521B_5EFAW_8868_73B0_5355_4F4D(
        GetOwningPlayer(record.unit),
        cfg["第一段命中特效单位类型ID"],
        GetUnitX(record.unit),
        GetUnitY(record.unit),
        record.angle + 90
    )
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = record.unit,
        ["目标"] = record.target,
        ["伤害"] = record.attack * cfg["第一段攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        attack = true,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = record.skillInstanceId,
        ["参与技能伤害加成"] = true,
        ["标签"] = "逆回十六夜-重拳击飞-第一段"
    })
    SetUnitAnimationByIndex(record.unit, cfg["第二段动作编号"])
    Sound3DII_UnitPlayReuse(cfg["第二段音效路径"], record.unit, cfg["第二段音效裁断距离"])
    addDelayedCallback(cfg["第二段前延迟秒"] * 1000, _____8FDB_5165W_7B2C_4E8C_6BB5, record)
end
local function _____9006_56DE_5341_516D_591CW_7B2C_4E00_6BB5_76EE_6807_79FB_52A8Tick(variable)
    local record = variable
    if record == nil or not record.active then
        return
    end
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W
    if not _____5355_4F4D_5B58_6D3B(record.unit) or not _____5355_4F4D_5B58_6D3B(record.target) then
        _____7ED3_675FW_65BD_6CD5(record)
        return
    end
    if record["循环计数"] >= cfg["第一段循环次数"] then
        if record["阶段回调ID"] > 0 then
            removePeriodicCallback(record["阶段回调ID"])
        end
        record["阶段回调ID"] = 0
        _____9006_56DE_5341_516D_591CW_7B2C_4E00_6BB5_547D_4E2D(record)
        return
    end
    record["循环计数"] = record["循环计数"] + 1
    local targetX = GetUnitX(record.target)
    local targetY = GetUnitY(record.target)
    local result = _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321({
        ["起点X"] = targetX,
        ["起点Y"] = targetY,
        ["角度度"] = record.angle,
        ["单步距离"] = cfg["第一段每次移动距离"],
        ["步数"] = 1,
        ["检测单位"] = record.target
    })
    if not result["是否提前停止"] then
        SetUnitFacing(record.target, record.angle)
        SetUnitX(record.target, result["最终X"])
        SetUnitY(record.target, result["最终Y"])
    end
end
local function _____9006_56DE_5341_516D_591CW_542F_52A8(variable)
    local record = variable
    if record == nil or not record.active or not _____5355_4F4D_5B58_6D3B(record.unit) or not _____5355_4F4D_5B58_6D3B(record.target) then
        if record ~= nil then
            _____7ED3_675FW_65BD_6CD5(record)
        end
        return
    end
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W
    record.initialFlyHeight = GetUnitFlyHeight(record.unit)
    record.angle = _____4E24_70B9_89D2_5EA6(
        GetUnitX(record.unit),
        GetUnitY(record.unit),
        GetUnitX(record.target),
        GetUnitY(record.target)
    )
    record.attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(record.unit)
    _____6DFB_52A0_5355_4F4D_6682_505C(record.unit, ____W_6682_505C_6765_6E90)
    SetUnitTimeScale(record.unit, cfg["动作速度"])
    local actionIndex = cfg["起手动作编号"][GetRandomInt(0, #cfg["起手动作编号"] - 1) + 1]
    SetUnitAnimationByIndex(record.unit, actionIndex)
    _____521B_5EFAW_8868_73B0_5355_4F4D(
        GetOwningPlayer(record.unit),
        cfg["第一段起手特效单位类型ID"],
        GetUnitX(record.target),
        GetUnitY(record.target),
        record.angle + 90
    )
    _____65BD_52A0_7729_6655(
        record.unit,
        record.target,
        cfg["短暂眩晕秒"],
        "重拳击飞",
        "技能"
    )
    _____64AD_653EW_5168_5C40_97F3_6548(record.unit, cfg["全局音效键"])
    Sound3DII_UnitPlayReuse(cfg["附加音效路径"], record.unit, cfg["附加音效裁断距离"])
    record["阶段"] = "第一段目标移动"
    record["循环计数"] = 0
    record["阶段回调ID"] = addPeriodicCallback(cfg["第一段循环间隔秒"] * 1000, _____9006_56DE_5341_516D_591CW_7B2C_4E00_6BB5_76EE_6807_79FB_52A8Tick, record)
end
local function _____91CA_653E_91CD_62F3_51FB_98DE(_context, unit, _____6280_80FD_5B9E_4F8BID)
    local target = GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(unit) or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local unitId = GetHandleId(unit)
    local existing = ____W_5F53_524D_65BD_6CD5_8868[unitId]
    if existing ~= nil then
        _____7ED3_675FW_65BD_6CD5(existing)
    end
    local record = {
        unit = unit,
        target = target,
        active = true,
        angle = 0,
        initialFlyHeight = 0,
        attack = 0,
        skillInstanceId = _____6280_80FD_5B9E_4F8BID,
        ["阶段回调ID"] = 0,
        ["阶段"] = "第一段目标移动",
        ["循环计数"] = 0,
        ["第二段AOE回调ID"] = 0,
        ["第二段循环计数"] = 0,
        ["已命中目标"] = {},
        ["已撞墙目标"] = {},
        ["第二段目标列表"] = {}
    }
    ____W_5F53_524D_65BD_6CD5_8868[unitId] = record
    addDelayedCallback(_____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W["启动延迟秒"] * 1000, _____9006_56DE_5341_516D_591CW_542F_52A8, record)
end
____exports["注册逆回十六夜W"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "逆回十六夜-重拳击飞",
        ["单位类型ID"] = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
        ["技能ID"] = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6W_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_91CD_62F3_51FB_98DE,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能"
    })
end
____exports["注册逆回十六夜W"]()
return ____exports
