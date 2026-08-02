--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.06．逆回十六夜.00．配置")
local _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["逆回十六夜单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口")
local _____5F00_59CB_8DF3_8DC3 = ____require_result_0["开始跳跃"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.03．对外接口")
local _____5F00_59CB_7275_5F15 = ____require_result_1["开始牵引"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_3.getEnemyUnitsInRange
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local _____65BD_52A0_51CF_901F = ____require_result_4["施加减速"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local _____8DDD_79BBXY = ____require_result_5["距离XY"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
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
    jass.AttachSoundToUnit(soundHandle, unit)
    jass.SetSoundVolume(soundHandle, 127)
    jass.StartSound(soundHandle)
end
local function _____83B7_53D6Q_4E0A_4E0B_6587(unit)
    return {unit = unit}
end
local function _____91CA_653E_8DF3_8DC3_91CD_51FB(_context, unit, _____6280_80FD_5B9E_4F8BID)
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.Q
    local startX = GetUnitX(unit)
    local startY = GetUnitY(unit)
    local targetX = GetSpellTargetX()
    local targetY = GetSpellTargetY()
    local distance = _____8DDD_79BBXY(startX, startY, targetX, targetY)
    local actualDistance = distance < cfg["最大位移距离"] and distance or cfg["最大位移距离"]
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * cfg["攻击力倍率"] + GetHeroStr(unit, true) * cfg["力量倍率"]
    local function ____on_8DF3_8DC3_91CD_51FB_7ED3_675F(caster, reason)
        if not _____5355_4F4D_5B58_6D3B(caster) or reason ~= "完成" and reason ~= "阻挡" then
            return
        end
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
            ["缩放"] = cfg["落地特效缩放"],
            ["持续秒"] = 1.2
        })
        local targets = getEnemyUnitsInRange(caster, x, y, cfg["落地半径"])
        do
            local i = 0
            while i < #targets do
                local target = targets[i + 1]
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = caster,
                    ["目标"] = target,
                    ["伤害"] = damage,
                    ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
                    ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                    ["参与技能伤害加成"] = true,
                    ["标签"] = "逆回十六夜-跳跃重击"
                })
                _____65BD_52A0_51CF_901F(
                    caster,
                    target,
                    cfg["减速比例"],
                    cfg["减速持续秒"],
                    "跳跃重击",
                    "技能"
                )
                _____65BD_52A0_7729_6655(
                    caster,
                    target,
                    cfg["打断眩晕秒"],
                    "跳跃重击",
                    "技能"
                )
                _____5F00_59CB_7275_5F15(target, {
                    ["中心X"] = x,
                    ["中心Y"] = y,
                    ["主单位"] = caster,
                    ["主单位死亡时中断"] = true,
                    ["持续时间"] = cfg["牵引持续秒"],
                    ["每秒速度"] = cfg["牵引距离"] / cfg["牵引持续秒"],
                    ["最大牵引距离"] = cfg["牵引距离"],
                    ["到达距离"] = 32,
                    ["检查地形"] = true,
                    ["禁用碰撞"] = true,
                    ["暂停单位"] = false
                })
                i = i + 1
            end
        end
    end
    SetUnitAnimationByIndex(unit, cfg["动作编号"])
    SetUnitTimeScale(unit, cfg["动作速度"])
    _____5F00_59CB_8DF3_8DC3(unit, {
        ["目标X"] = targetX,
        ["目标Y"] = targetY,
        ["距离"] = actualDistance,
        ["持续时间"] = cfg["位移持续秒"],
        ["跳跃高度"] = cfg["跳跃高度"],
        ["暂停单位"] = true,
        ["朝向跟随跳跃"] = true,
        ["结束回调"] = ____on_8DF3_8DC3_91CD_51FB_7ED3_675F
    })
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
