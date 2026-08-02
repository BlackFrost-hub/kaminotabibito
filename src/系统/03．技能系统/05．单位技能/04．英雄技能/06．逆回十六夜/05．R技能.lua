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
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.03．线性升降系统")
local _____5F00_59CB_7EBF_6027_5347_964D = ____require_result_1["开始线性升降"]
local _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D = ____require_result_1["停止单位线性升降"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_2["开始冲锋"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧")
local _____5F00_59CB_65E0_654C_5E27 = ____require_result_3["开始无敌帧"]
local _____53D6_6D88_65E0_654C_5E27 = ____require_result_3["取消无敌帧"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_5["造成AOE技能伤害"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_6.getEnemyUnitsInRange
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_7["施加眩晕"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_8["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_8["单位存活"]
local _____8DDD_79BBXY = ____require_result_8["距离XY"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
local ____require_result_10 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_10.Sound3DII_UnitPlayReuse
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_11.stringToFourCCSafe
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local GetHeroStr = jass.GetHeroStr
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local ResetUnitAnimation = jass.ResetUnitAnimation
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ____R_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["R技能ID"])
local ____R_6682_505C_6765_6E90 = "逆回十六夜-全力飞踢"
local function _____64AD_653E_5168_529B_98DE_8E22_97F3_6548(unit, soundKey)
    local soundHandle = jglobals[soundKey]
    if unit == nil or unit == 0 or soundHandle == nil or soundHandle == 0 then
        return
    end
    jass.AttachSoundToUnit(soundHandle, unit)
    jass.SetSoundVolume(soundHandle, 127)
    jass.StartSound(soundHandle)
end
local ____R_65BD_6CD5_8868 = {}
local function _____83B7_53D6R_4E0A_4E0B_6587(unit)
    return {unit = unit}
end
local function _____7ED3_675FR_65BD_6CD5(record)
    if not record.active then
        return
    end
    record.active = false
    _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D(record.unit, "中断")
    _____79FB_9664_5355_4F4D_6682_505C(record.unit, ____R_6682_505C_6765_6E90)
    _____53D6_6D88_65E0_654C_5E27(record.invincibleId)
    if record.unit ~= nil and record.unit ~= 0 then
        SetUnitFlyHeight(record.unit, record.initialFlyHeight, 0)
        SetUnitTimeScale(record.unit, 1)
        ResetUnitAnimation(record.unit)
    end
    local id = record.unit ~= nil and record.unit ~= 0 and jass.GetHandleId(record.unit) or 0
    if id ~= 0 and ____R_65BD_6CD5_8868[id] == record then
        __TS__Delete(____R_65BD_6CD5_8868, id)
    end
end
local function _____91CA_653E_5168_529B_98DE_8E22(_context, unit, _____6280_80FD_5B9E_4F8BID)
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.R
    local unitId = jass.GetHandleId(unit)
    local existing = ____R_65BD_6CD5_8868[unitId]
    if existing ~= nil then
        _____7ED3_675FR_65BD_6CD5(existing)
    end
    local startX = GetUnitX(unit)
    local startY = GetUnitY(unit)
    local rawTargetX = GetSpellTargetX()
    local rawTargetY = GetSpellTargetY()
    local distance = _____8DDD_79BBXY(startX, startY, rawTargetX, rawTargetY)
    local ratio = distance > cfg["最大位移距离"] and distance > 0 and cfg["最大位移距离"] / distance or 1
    local targetX = startX + (rawTargetX - startX) * ratio
    local targetY = startY + (rawTargetY - startY) * ratio
    local record = {
        unit = unit,
        active = true,
        invincibleId = _____5F00_59CB_65E0_654C_5E27(unit, cfg["蓄力秒"] + cfg["升空持续秒"] + cfg["停空持续秒"] + cfg["飞行持续秒"] + 1),
        targetX = targetX,
        targetY = targetY,
        initialFlyHeight = GetUnitFlyHeight(unit),
        damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * cfg["攻击力倍率"] + GetHeroStr(unit, true) * cfg["力量倍率"],
        skillInstanceId = _____6280_80FD_5B9E_4F8BID
    }
    ____R_65BD_6CD5_8868[unitId] = record
    _____64AD_653E_5168_529B_98DE_8E22_97F3_6548(unit, cfg["全局音效键"])
    _____6DFB_52A0_5355_4F4D_6682_505C(unit, ____R_6682_505C_6765_6E90)
    SetUnitTimeScale(unit, cfg["动作速度"])
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg["蓄力落点特效"], X = targetX, Y = targetY, ["持续秒"] = cfg["蓄力秒"]})
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg["起跳特效"], X = startX, Y = startY, ["持续秒"] = cfg["蓄力秒"]})
    local function ____on_5168_529B_98DE_8E22_524D_51B2()
        if not record.active or not _____5355_4F4D_5B58_6D3B(unit) then
            _____7ED3_675FR_65BD_6CD5(record)
            return
        end
        _____79FB_9664_5355_4F4D_6682_505C(unit, ____R_6682_505C_6765_6E90)
        SetUnitAnimationByIndex(unit, cfg["起跳动作编号"])
        _____5F00_59CB_7EBF_6027_5347_964D(unit, {["持续时间"] = cfg["飞行持续秒"], ["高度变化"] = -cfg["跳跃高度"], ["暂停单位"] = false})
        local function ____on_5168_529B_98DE_8E22_843D_5730(caster, reason)
            if record.active and _____5355_4F4D_5B58_6D3B(caster) and (reason == "完成" or reason == "阻挡") then
                local x = GetUnitX(caster)
                local y = GetUnitY(caster)
                Sound3DII_UnitPlayReuse(cfg["落地音效路径"], caster, cfg["落地音效裁断距离"])
                _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg["命中特效A"], X = x, Y = y, ["持续秒"] = 1.5})
                _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = cfg["命中特效B"],
                    X = x,
                    Y = y,
                    ["缩放"] = 2,
                    ["持续秒"] = 1.5
                })
                _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg["命中特效C"], X = x, Y = y, ["持续秒"] = 1.5})
                local targets = getEnemyUnitsInRange(caster, x, y, cfg["落地半径"])
                do
                    local i = 0
                    while i < #targets do
                        local target = targets[i + 1]
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["来源"] = caster,
                            ["目标"] = target,
                            ["伤害"] = record.damage,
                            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                            ["来源类型"] = "单位技能",
                            ["技能ID"] = ____R_6280_80FD_7C7B_578BID,
                            ["技能实例ID"] = record.skillInstanceId,
                            ["参与技能伤害加成"] = true,
                            ["标签"] = "逆回十六夜-全力飞踢"
                        })
                        _____65BD_52A0_7729_6655(
                            caster,
                            target,
                            cfg["眩晕秒"],
                            "全力飞踢",
                            "技能"
                        )
                        i = i + 1
                    end
                end
            end
            _____7ED3_675FR_65BD_6CD5(record)
        end
        _____5F00_59CB_51B2_950B(
            unit,
            {
                ["目标X"] = record.targetX,
                ["目标Y"] = record.targetY,
                ["距离"] = _____8DDD_79BBXY(
                    GetUnitX(unit),
                    GetUnitY(unit),
                    record.targetX,
                    record.targetY
                ),
                ["持续时间"] = cfg["飞行持续秒"],
                ["检查地形"] = true,
                ["暂停单位"] = true,
                ["禁用碰撞"] = true,
                ["朝向跟随位移"] = true,
                ["结束回调"] = ____on_5168_529B_98DE_8E22_843D_5730
            }
        )
    end
    local function ____on_5168_529B_98DE_8E22_5347_7A7A_7ED3_675F(caster, reason)
        if not record.active or not _____5355_4F4D_5B58_6D3B(caster) or reason ~= "完成" then
            _____7ED3_675FR_65BD_6CD5(record)
            return
        end
        SetUnitAnimationByIndex(caster, cfg["飞踢动作编号"])
        _____6DFB_52A0_5355_4F4D_6682_505C(caster, ____R_6682_505C_6765_6E90)
        addDelayedCallback(cfg["停空持续秒"] * 1000, ____on_5168_529B_98DE_8E22_524D_51B2)
    end
    local function ____on_5168_529B_98DE_8E22_84C4_529B_7ED3_675F()
        if not record.active or not _____5355_4F4D_5B58_6D3B(unit) then
            _____7ED3_675FR_65BD_6CD5(record)
            return
        end
        _____79FB_9664_5355_4F4D_6682_505C(unit, ____R_6682_505C_6765_6E90)
        _____5F00_59CB_7EBF_6027_5347_964D(unit, {["持续时间"] = cfg["升空持续秒"], ["高度变化"] = cfg["跳跃高度"], ["暂停单位"] = true, ["结束回调"] = ____on_5168_529B_98DE_8E22_5347_7A7A_7ED3_675F})
    end
    addDelayedCallback(cfg["蓄力秒"] * 1000, ____on_5168_529B_98DE_8E22_84C4_529B_7ED3_675F)
end
____exports["注册逆回十六夜R"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "逆回十六夜-全力飞踢",
        ["单位类型ID"] = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
        ["技能ID"] = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["R技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6R_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5168_529B_98DE_8E22,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 5
    })
end
____exports["注册逆回十六夜R"]()
return ____exports
