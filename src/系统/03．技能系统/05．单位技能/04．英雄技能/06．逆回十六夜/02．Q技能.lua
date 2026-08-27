local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.06．逆回十六夜.00．配置")
local _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["逆回十六夜单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口")
local _____5F00_59CB_8DF3_8DC3 = ____require_result_1["开始跳跃"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.03．对外接口")
local _____5F00_59CB_7275_5F15 = ____require_result_2["开始牵引"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成批量AOE技能伤害"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_4.getEnemyUnitsInRange
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_5["施加眩晕"]
local _____65BD_52A0_51CF_901F = ____require_result_5["施加减速"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local _____8DDD_79BBXY = ____require_result_6["距离XY"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetHeroStr = jass.GetHeroStr
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local ____Q_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"])
local function _____64AD_653E_5355_4F4D_5168_5C40_97F3_6548(unit, soundKey)
    local soundHandle = jglobals[soundKey]
    if unit == nil or unit == 0 or soundHandle == nil or soundHandle == 0 then
        return
    end
    jass:AttachSoundToUnit(soundHandle, unit)
    jass:SetSoundVolume(soundHandle, 127)
    jass:StartSound(soundHandle)
end
local ____Q_8DF3_8DC3_8BB0_5F55_8868 = {}
local function _____83B7_53D6Q_4E0A_4E0B_6587(unit)
    return {unit = unit}
end
local function _____5904_7406_9006_56DE_5341_516D_591CQ_76EE_6807_7ED3_7B97_540E(target, _index, ______6210_529F, variable)
    local _____53D8_91CF = variable
    if _____53D8_91CF == nil then
        return
    end
    _____65BD_52A0_51CF_901F(
        _____53D8_91CF["施法者"],
        target,
        _____53D8_91CF["配置"]["减速比例"],
        _____53D8_91CF["配置"]["减速持续秒"],
        "跳跃重击",
        "技能"
    )
    _____65BD_52A0_7729_6655(
        _____53D8_91CF["施法者"],
        target,
        _____53D8_91CF["配置"]["打断眩晕秒"],
        "跳跃重击",
        "技能"
    )
    _____5F00_59CB_7275_5F15(target, {
        ["中心X"] = _____53D8_91CF["中心X"],
        ["中心Y"] = _____53D8_91CF["中心Y"],
        ["主单位"] = _____53D8_91CF["施法者"],
        ["主单位死亡时中断"] = true,
        ["持续时间"] = _____53D8_91CF["配置"]["牵引持续秒"],
        ["每秒速度"] = _____53D8_91CF["配置"]["牵引距离"] / _____53D8_91CF["配置"]["牵引持续秒"],
        ["最大牵引距离"] = _____53D8_91CF["配置"]["牵引距离"],
        ["到达距离"] = 32,
        ["检查地形"] = true,
        ["禁用碰撞"] = true,
        ["暂停单位"] = false
    })
end
local function _____64AD_653E_9006_56DE_5341_516D_591CQ_52A8_4F5C(unit, ______8DF3_8DC3ID)
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.Q
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return
    end
    SetUnitTimeScale(unit, cfg["动作速度"])
    SetUnitAnimationByIndex(unit, cfg["动作编号"])
end
local function _____5904_7406_9006_56DE_5341_516D_591CQ_8DF3_8DC3_7ED3_675F(caster, reason, jumpId)
    local record = ____Q_8DF3_8DC3_8BB0_5F55_8868[jumpId]
    __TS__Delete(____Q_8DF3_8DC3_8BB0_5F55_8868, jumpId)
    if record == nil or not _____5355_4F4D_5B58_6D3B(caster) or reason ~= "完成" and reason ~= "阻挡" then
        return
    end
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.Q
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    SetUnitTimeScale(caster, 1)
    do
        local i = 0
        while i < #cfg["全局音效键"] do
            _____64AD_653E_5355_4F4D_5168_5C40_97F3_6548(caster, cfg["全局音效键"][i + 1])
            i = i + 1
        end
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["落地特效"],
        X = x,
        Y = y,
        Z = record["初始飞行高度"],
        ["缩放"] = cfg["落地特效缩放"],
        ["持续秒"] = cfg["落地特效持续秒"]
    })
    local targets = getEnemyUnitsInRange(caster, x, y, cfg["落地半径"])
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害"] = record["伤害"],
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = record["技能实例ID"],
        ["参与技能伤害加成"] = true,
        ["标签"] = "逆回十六夜-跳跃重击",
        ["每目标结算后处理器"] = _____5904_7406_9006_56DE_5341_516D_591CQ_76EE_6807_7ED3_7B97_540E,
        ["变量"] = {["施法者"] = caster, ["中心X"] = x, ["中心Y"] = y, ["配置"] = cfg}
    })
end
local function _____542F_52A8_9006_56DE_5341_516D_591CQ_8DF3_8DC3(variable)
    local start = variable
    if start == nil or not _____5355_4F4D_5B58_6D3B(start.unit) then
        return
    end
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.Q
    local startX = GetUnitX(start.unit)
    local startY = GetUnitY(start.unit)
    local distance = _____8DDD_79BBXY(startX, startY, start.targetX, start.targetY)
    local actualDistance = distance < cfg["最大位移距离"] and distance or cfg["最大位移距离"]
    local record = {
        unit = start.unit,
        ["初始飞行高度"] = GetUnitFlyHeight(start.unit),
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(start.unit) * cfg["攻击力倍率"] + GetHeroStr(start.unit, true) * cfg["力量倍率"],
        ["技能实例ID"] = start["技能实例ID"]
    }
    local jumpId = _____5F00_59CB_8DF3_8DC3(start.unit, {
        ["目标X"] = start.targetX,
        ["目标Y"] = start.targetY,
        ["距离"] = actualDistance,
        ["持续时间"] = cfg["位移持续秒"],
        ["跳跃高度"] = cfg["跳跃高度"],
        ["暂停单位"] = true,
        ["朝向跟随跳跃"] = true,
        ["开始回调"] = _____64AD_653E_9006_56DE_5341_516D_591CQ_52A8_4F5C,
        ["结束回调"] = _____5904_7406_9006_56DE_5341_516D_591CQ_8DF3_8DC3_7ED3_675F
    })
    if jumpId > 0 then
        ____Q_8DF3_8DC3_8BB0_5F55_8868[jumpId] = record
    end
end
local function _____91CA_653E_8DF3_8DC3_91CD_51FB(_context, unit, _____6280_80FD_5B9E_4F8BID)
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.Q
    local targetX = GetSpellTargetX()
    local targetY = GetSpellTargetY()
    addDelayedCallback(cfg["启动延迟秒"] * 1000, _____542F_52A8_9006_56DE_5341_516D_591CQ_8DF3_8DC3, {unit = unit, targetX = targetX, targetY = targetY, ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID})
end
____exports["注册逆回十六夜Q"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "逆回十六夜-跳跃重击",
        ["单位类型ID"] = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
        ["技能ID"] = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6Q_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_8DF3_8DC3_91CD_51FB,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能"
    })
end
____exports["注册逆回十六夜Q"]()
return ____exports
