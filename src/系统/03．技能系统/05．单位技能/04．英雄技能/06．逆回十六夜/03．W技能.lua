--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.06．逆回十六夜.00．配置")
local _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["逆回十六夜单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_1.Sound3DII_UnitPlayReuse
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_2["开始击退"]
local _____5F00_59CB_51B2_950B = ____require_result_2["开始冲锋"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成AOE技能伤害"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_4.getEnemyUnitsInRange
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_5["施加眩晕"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_6["两点角度"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ____W_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"])
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
local function _____91CA_653E_91CD_62F3_51FB_98DE(_context, unit, _____6280_80FD_5B9E_4F8BID)
    local target = GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local cfg = _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E.W
    local angle = _____4E24_70B9_89D2_5EA6(
        GetUnitX(unit),
        GetUnitY(unit),
        GetUnitX(target),
        GetUnitY(target)
    )
    local attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit)
    local startAnimationIndex = cfg["起手动作编号"][GetRandomInt(0, #cfg["起手动作编号"] - 1) + 1]
    SetUnitAnimationByIndex(unit, startAnimationIndex)
    SetUnitTimeScale(unit, cfg["动作速度"])
    _____64AD_653EW_5168_5C40_97F3_6548(unit, cfg["全局音效键"])
    Sound3DII_UnitPlayReuse(cfg["附加音效路径"], unit, cfg["附加音效裁断距离"])
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = unit,
        ["目标"] = target,
        ["伤害"] = attack * cfg["第一段攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        attack = true,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["参与技能伤害加成"] = true,
        ["标签"] = "逆回十六夜-重拳击飞-第一段"
    })
    _____65BD_52A0_7729_6655(
        unit,
        target,
        cfg["短暂眩晕秒"],
        "重拳击飞",
        "技能"
    )
    local function ____on_7B2C_4E00_6BB5_7ED3_675F()
        if not _____5355_4F4D_5B58_6D3B(unit) or not _____5355_4F4D_5B58_6D3B(target) then
            return
        end
        local function ____on_8D34_8FD1_7ED3_675F()
            if not _____5355_4F4D_5B58_6D3B(unit) or not _____5355_4F4D_5B58_6D3B(target) then
                return
            end
            SetUnitAnimationByIndex(unit, cfg["第二段动作编号"])
            Sound3DII_UnitPlayReuse(cfg["第二段音效路径"], unit, cfg["第二段音效裁断距离"])
            local targets = getEnemyUnitsInRange(
                unit,
                GetUnitX(target),
                GetUnitY(target),
                cfg["第二段搜索半径"]
            )
            do
                local i = 0
                while i < #targets do
                    local enemy = targets[i + 1]
                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                        ["来源"] = unit,
                        ["目标"] = enemy,
                        ["伤害"] = attack * cfg["第二段攻击力倍率"],
                        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                        attack = true,
                        ["来源类型"] = "单位技能",
                        ["技能ID"] = ____W_6280_80FD_7C7B_578BID,
                        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                        ["参与技能伤害加成"] = true,
                        ["标签"] = "逆回十六夜-重拳击飞-第二段"
                    })
                    local function ____on_649E_5899()
                        if _____5355_4F4D_5B58_6D3B(enemy) then
                            _____65BD_52A0_7729_6655(
                                unit,
                                enemy,
                                cfg["撞墙眩晕秒"],
                                "重拳击飞-撞墙",
                                "技能"
                            )
                        end
                    end
                    _____5F00_59CB_51FB_9000(enemy, {
                        ["角度"] = angle,
                        ["距离"] = cfg["第二段击退距离"],
                        ["持续时间"] = cfg["第二段击退持续秒"],
                        ["主单位"] = unit,
                        ["主单位死亡时中断"] = false,
                        ["检查地形"] = true,
                        ["暂停单位"] = false,
                        ["禁用碰撞"] = true,
                        ["撞墙回调"] = ____on_649E_5899
                    })
                    i = i + 1
                end
            end
        end
        _____5F00_59CB_51B2_950B(
            unit,
            {
                ["目标X"] = GetUnitX(target),
                ["目标Y"] = GetUnitY(target),
                ["距离"] = cfg["第一段击退距离"],
                ["持续时间"] = cfg["贴近持续秒"],
                ["检查地形"] = true,
                ["暂停单位"] = true,
                ["禁用碰撞"] = true,
                ["朝向跟随位移"] = true,
                ["结束回调"] = ____on_8D34_8FD1_7ED3_675F
            }
        )
    end
    _____5F00_59CB_51FB_9000(target, {
        ["角度"] = angle,
        ["距离"] = cfg["第一段击退距离"],
        ["持续时间"] = cfg["第一段击退持续秒"],
        ["主单位"] = unit,
        ["检查地形"] = true,
        ["暂停单位"] = false,
        ["禁用碰撞"] = true,
        ["结束回调"] = ____on_7B2C_4E00_6BB5_7ED3_675F
    })
    local function ____onW_52A8_4F5C_6062_590D()
        if unit ~= nil and unit ~= 0 then
            SetUnitTimeScale(unit, 1)
        end
    end
    addDelayedCallback((cfg["第一段击退持续秒"] + cfg["贴近持续秒"] + cfg["第二段击退持续秒"]) * 1000, ____onW_52A8_4F5C_6062_590D)
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
