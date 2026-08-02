--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.06．逆回十六夜.00．配置")
local _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["逆回十六夜单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.03．线性升降系统")
local _____5F00_59CB_7EBF_6027_5347_964D = ____require_result_0["开始线性升降"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_1["开始击退"]
local _____5F00_59CB_51B2_950B = ____require_result_1["开始冲锋"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_3.getEnemyUnitsInRange
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_5["两点角度"]
local _____6781_5750_6807X = ____require_result_5["极坐标X"]
local _____6781_5750_6807Y = ____require_result_5["极坐标Y"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____require_result_5["点到线段距离平方"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local ____require_result_7 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_7.Sound3DII_UnitPlayReuse
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local ____E_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["E技能ID"])
local function _____64AD_653E_8DF3_8DC3_4E00_8E22_97F3_6548(unit, soundKey)
    local soundHandle = jglobals[soundKey]
    if unit == nil or unit == 0 or soundHandle == nil or soundHandle == 0 then
        return
    end
    jass.AttachSoundToUnit(soundHandle, unit)
    jass.SetSoundVolume(soundHandle, 127)
    jass.StartSound(soundHandle)
end
local function _____83B7_53D6E_4E0A_4E0B_6587(unit)
    return {unit = unit}
end
local function _____91CA_653E_8DF3_8DC3_4E00_8E22(_context, unit, _____6280_80FD_5B9E_4F8BID)
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.E
    local startX = GetUnitX(unit)
    local startY = GetUnitY(unit)
    local initialFlyHeight = GetUnitFlyHeight(unit)
    local angle = _____4E24_70B9_89D2_5EA6(
        startX,
        startY,
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    local endX = _____6781_5750_6807X(startX, angle, cfg["实际飞行距离"])
    local endY = _____6781_5750_6807Y(startY, angle, cfg["实际飞行距离"])
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * cfg["攻击力倍率"]
    SetUnitAnimationByIndex(unit, cfg["动作编号"])
    SetUnitTimeScale(unit, cfg["动作速度"])
    _____64AD_653E_8DF3_8DC3_4E00_8E22_97F3_6548(unit, cfg["全局音效键"])
    Sound3DII_UnitPlayReuse(cfg["附加音效路径"], unit, cfg["附加音效裁断距离"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["路径特效"],
        X = startX,
        Y = startY,
        ["Z轴角度"] = angle,
        ["缩放"] = 2,
        ["持续秒"] = 1.2
    })
    local function ____on_8DF3_8DC3_4E00_8E22_7ED3_675F(caster, reason)
        if not _____5355_4F4D_5B58_6D3B(caster) or reason ~= "完成" and reason ~= "阻挡" then
            return
        end
        SetUnitFlyHeight(caster, initialFlyHeight, 0)
        SetUnitTimeScale(caster, 1)
        local midX = (startX + endX) * 0.5
        local midY = (startY + endY) * 0.5
        local targets = getEnemyUnitsInRange(caster, midX, midY, cfg["实际飞行距离"] * 0.5 + cfg["路径命中半径"])
        local radiusSquared = cfg["路径命中半径"] * cfg["路径命中半径"]
        do
            local i = 0
            while i < #targets do
                do
                    local target = targets[i + 1]
                    if _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                        GetUnitX(target),
                        GetUnitY(target),
                        startX,
                        startY,
                        endX,
                        endY
                    ) > radiusSquared then
                        goto __continue9
                    end
                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                        ["来源"] = caster,
                        ["目标"] = target,
                        ["伤害"] = damage,
                        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                        ["来源类型"] = "单位技能",
                        ["技能ID"] = ____E_6280_80FD_7C7B_578BID,
                        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                        ["参与技能伤害加成"] = true,
                        ["标签"] = "逆回十六夜-跳跃一踢"
                    })
                    _____65BD_52A0_7729_6655(
                        caster,
                        target,
                        cfg["眩晕秒"],
                        "跳跃一踢",
                        "技能"
                    )
                    _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = cfg["命中特效"],
                        X = GetUnitX(target),
                        Y = GetUnitY(target),
                        ["持续秒"] = 1
                    })
                    _____5F00_59CB_51FB_9000(target, {
                        ["角度"] = angle,
                        ["距离"] = cfg["击退距离"],
                        ["持续时间"] = cfg["击退持续秒"],
                        ["主单位"] = caster,
                        ["检查地形"] = true,
                        ["暂停单位"] = false,
                        ["禁用碰撞"] = true
                    })
                end
                ::__continue9::
                i = i + 1
            end
        end
    end
    local function ____on_5347_7A7A_7ED3_675F(caster, reason)
        if not _____5355_4F4D_5B58_6D3B(caster) then
            return
        end
        if reason ~= "完成" then
            SetUnitFlyHeight(caster, initialFlyHeight, 0)
            SetUnitTimeScale(caster, 1)
            return
        end
        _____5F00_59CB_7EBF_6027_5347_964D(caster, {["持续时间"] = cfg["飞行持续秒"], ["高度变化"] = -cfg["跳跃高度"], ["暂停单位"] = false})
        _____5F00_59CB_51B2_950B(caster, {
            ["目标X"] = endX,
            ["目标Y"] = endY,
            ["距离"] = cfg["实际飞行距离"],
            ["持续时间"] = cfg["飞行持续秒"],
            ["检查地形"] = true,
            ["暂停单位"] = true,
            ["禁用碰撞"] = true,
            ["朝向跟随位移"] = true,
            ["结束回调"] = ____on_8DF3_8DC3_4E00_8E22_7ED3_675F
        })
    end
    _____5F00_59CB_7EBF_6027_5347_964D(unit, {["持续时间"] = cfg["升空持续秒"], ["高度变化"] = cfg["跳跃高度"], ["暂停单位"] = true, ["结束回调"] = ____on_5347_7A7A_7ED3_675F})
end
____exports["注册逆回十六夜E"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "逆回十六夜-跳跃一踢",
        ["单位类型ID"] = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
        ["技能ID"] = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["E技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6E_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_8DF3_8DC3_4E00_8E22,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能"
    })
end
____exports["注册逆回十六夜E"]()
return ____exports
