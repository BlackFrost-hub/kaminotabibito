local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.00．公共")
local _____585E_62C9_516C_5171 = ____00_FF0E_516C_5171["塞拉公共"]
local ____585E_62C9_516C_5171_0 = _____585E_62C9_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____585E_62C9_516C_5171_0["巴尔扎罗斯技能数值配置"]
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____585E_62C9_516C_5171_0["播放巴尔扎罗斯台词"]
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____585E_62C9_516C_5171_0["施加巴尔扎罗斯灼热"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____585E_62C9_516C_5171_0["读取单位攻击力"]
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____585E_62C9_516C_5171_0["启动基础施法时间线"]
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____585E_62C9_516C_5171_0["创建技能提示圈"]
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____585E_62C9_516C_5171_0["施加快速减速Buff"]
local _____521B_5EFA_539F_751F_5F39_5E55 = ____585E_62C9_516C_5171_0["创建原生弹幕"]
local getUnitsInRange = ____585E_62C9_516C_5171_0.getUnitsInRange
local isUnitEnemy = ____585E_62C9_516C_5171_0.isUnitEnemy
local CosBJ = ____585E_62C9_516C_5171_0.CosBJ
local SinBJ = ____585E_62C9_516C_5171_0.SinBJ
local GetUnitX = ____585E_62C9_516C_5171_0.GetUnitX
local GetUnitY = ____585E_62C9_516C_5171_0.GetUnitY
local GetUnitState = ____585E_62C9_516C_5171_0.GetUnitState
local GetUnitFlyHeight = ____585E_62C9_516C_5171_0.GetUnitFlyHeight
local SquareRoot = ____585E_62C9_516C_5171_0.SquareRoot
local UNIT_STATE_MAX_LIFE = ____585E_62C9_516C_5171_0.UNIT_STATE_MAX_LIFE
local DAMAGE_TYPE_FIRE = ____585E_62C9_516C_5171_0.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_COLD = ____585E_62C9_516C_5171_0.DAMAGE_TYPE_COLD
local _____5355_4F4D_6709_6548 = ____585E_62C9_516C_5171_0["单位有效"]
local _____53D6_65B9_5411_89D2 = ____585E_62C9_516C_5171_0["取方向角"]
local _____53D6_5F62_6001_6280_80FD_500D_7387 = ____585E_62C9_516C_5171_0["取形态技能倍率"]
local _____521B_5EFA_585E_62C9_70B9_7279_6548 = ____585E_62C9_516C_5171_0["创建塞拉点特效"]
local _____9020_6210_585E_62C9Boss_6280_80FD_4F24_5BB3 = ____585E_62C9_516C_5171_0["造成塞拉Boss技能伤害"]
local _____5F31_8FFD_8E2A_5F39_4F53_72B6_6001_8868 = ____585E_62C9_516C_5171_0["弱追踪弹体状态表"]
local function _____8BA1_7B97_51B0_7403_4F24_5BB3(context, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["冰焰双星"]
    local sera = context["塞拉"]
    return (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(sera) * config["冰球伤害攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["冰球伤害目标最大生命比例"]) * config["冰球伤害总倍率"] * _____53D6_5F62_6001_6280_80FD_500D_7387(context, "冰霜")
end
local function _____8BA1_7B97_706B_7403_4F24_5BB3(context, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["冰焰双星"]
    local sera = context["塞拉"]
    return (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(sera) * config["火球伤害攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["火球伤害目标最大生命比例"]) * config["火球伤害总倍率"] * _____53D6_5F62_6001_6280_80FD_500D_7387(context, "火焰")
end
local function _____7ED3_7B97_51B0_7130AOE(context, hitUnit, _____7C7B_578B)
    local sera = context["塞拉"]
    if not _____5355_4F4D_6709_6548(sera) or not _____5355_4F4D_6709_6548(hitUnit) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["冰焰双星"]
    local x = GetUnitX(hitUnit)
    local y = GetUnitY(hitUnit)
    if _____7C7B_578B == "冰霜" then
        _____521B_5EFA_585E_62C9_70B9_7279_6548(
            config["冰球命中特效路径"],
            x,
            y,
            config["冰球命中特效高度"],
            config["冰球命中特效缩放"],
            1.2
        )
    else
        _____521B_5EFA_585E_62C9_70B9_7279_6548(
            config["火球命中特效路径"],
            x,
            y,
            config["火球命中特效高度"],
            config["火球命中特效缩放"],
            1.2
        )
    end
    local targets = getUnitsInRange(x, y, config["命中AOE半径"])
    do
        local i = 0
        while i < #targets do
            do
                local unit = targets[i + 1]
                if not _____5355_4F4D_6709_6548(unit) or not isUnitEnemy(unit, sera) then
                    goto __continue9
                end
                if _____7C7B_578B == "冰霜" then
                    _____9020_6210_585E_62C9Boss_6280_80FD_4F24_5BB3(
                        sera,
                        unit,
                        _____8BA1_7B97_51B0_7403_4F24_5BB3(context, unit),
                        DAMAGE_TYPE_COLD,
                        "AOE"
                    )
                    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                        sera,
                        unit,
                        config["冰球减速比例"],
                        config["冰球减速比例"],
                        config["冰球减速持续秒"]
                    )
                else
                    _____9020_6210_585E_62C9Boss_6280_80FD_4F24_5BB3(
                        sera,
                        unit,
                        _____8BA1_7B97_706B_7403_4F24_5BB3(context, unit),
                        DAMAGE_TYPE_FIRE,
                        "AOE"
                    )
                    _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(unit, config["火球灼热层数"])
                end
            end
            ::__continue9::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_51B0_7130_5F31_8FFD_8E2A_66F2_7EBF_8F68_8FF9(startX, startY, startZ, controlX, controlY, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["冰焰双星"]
    return function(_____5B9E_4F8B, delta)
        local _____72B6_6001 = _____5F31_8FFD_8E2A_5F39_4F53_72B6_6001_8868[_____5B9E_4F8B.id]
        if _____72B6_6001 == nil then
            _____72B6_6001 = {["锁定"] = false, ["锁定角"] = _____5B9E_4F8B["当前方向角"]}
            _____5F31_8FFD_8E2A_5F39_4F53_72B6_6001_8868[_____5B9E_4F8B.id] = _____72B6_6001
        end
        if not _____72B6_6001["锁定"] and _____5B9E_4F8B["已运行时间"] <= config["弱追踪秒"] and _____5355_4F4D_6709_6548(target) then
            local t = _____5B9E_4F8B["已运行时间"] / config["弱追踪秒"]
            local endX = GetUnitX(target)
            local endY = GetUnitY(target)
            local x01 = startX + (controlX - startX) * t
            local y01 = startY + (controlY - startY) * t
            local x12 = controlX + (endX - controlX) * t
            local y12 = controlY + (endY - controlY) * t
            local x = x01 + (x12 - x01) * t
            local y = y01 + (y12 - y01) * t
            return {
                X = x,
                Y = y,
                Z = startZ,
                ["方向角"] = _____53D6_65B9_5411_89D2(_____5B9E_4F8B["当前X"], _____5B9E_4F8B["当前Y"], x, y),
                ["完成"] = false
            }
        end
        if not _____72B6_6001["锁定"] then
            _____72B6_6001["锁定"] = true
            if _____5355_4F4D_6709_6548(target) then
                _____72B6_6001["锁定角"] = _____53D6_65B9_5411_89D2(
                    _____5B9E_4F8B["当前X"],
                    _____5B9E_4F8B["当前Y"],
                    GetUnitX(target),
                    GetUnitY(target)
                )
            end
        end
        return {
            X = _____5B9E_4F8B["当前X"] + CosBJ(_____72B6_6001["锁定角"]) * _____5B9E_4F8B["当前速度"] * delta,
            Y = _____5B9E_4F8B["当前Y"] + SinBJ(_____72B6_6001["锁定角"]) * _____5B9E_4F8B["当前速度"] * delta,
            Z = startZ,
            ["方向角"] = _____72B6_6001["锁定角"],
            ["完成"] = false
        }
    end
end
local function _____53D1_5C04_51B0_7130_5F39_4F53(context, target, _____7C7B_578B, side)
    local sera = context["塞拉"]
    if not _____5355_4F4D_6709_6548(sera) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["冰焰双星"]
    local angle = _____53D6_65B9_5411_89D2(
        GetUnitX(sera),
        GetUnitY(sera),
        GetUnitX(target),
        GetUnitY(target)
    )
    local sideAngle = angle + 90 * side
    local startX = GetUnitX(sera) + CosBJ(angle) * config["发射前向偏移"] + CosBJ(sideAngle) * config["发射侧向偏移"]
    local startY = GetUnitY(sera) + SinBJ(angle) * config["发射前向偏移"] + SinBJ(sideAngle) * config["发射侧向偏移"]
    local controlX = startX + CosBJ(angle) * config["曲线控制前移"] + CosBJ(sideAngle) * config["曲线控制侧移"]
    local controlY = startY + SinBJ(angle) * config["曲线控制前移"] + SinBJ(sideAngle) * config["曲线控制侧移"]
    local startZ = GetUnitFlyHeight(sera) + config["飞行高度"]
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = sera,
        X = startX,
        Y = startY,
        ["方向角"] = angle,
        ["速度"] = config["飞行速度"],
        ["轨迹采样器"] = _____521B_5EFA_51B0_7130_5F31_8FFD_8E2A_66F2_7EBF_8F68_8FF9(
            startX,
            startY,
            startZ,
            controlX,
            controlY,
            target
        ),
        ["命中半径"] = config["弹体命中半径"],
        ["生命周期"] = config["生命周期秒"],
        ["碰撞消失"] = true,
        ["最大距离"] = config["最大飞行距离"],
        ["模型"] = _____7C7B_578B == "冰霜" and config["冰球模型路径"] or config["火球模型路径"],
        ["附着特效模型"] = _____7C7B_578B == "冰霜" and config["冰球模型路径"] or config["火球模型路径"],
        ["缩放"] = _____7C7B_578B == "冰霜" and config["冰球缩放"] or config["火球缩放"],
        ["飞行高度"] = startZ,
        ["影响目标"] = "敌方",
        ["最大总命中次数"] = 1,
        ["每单位最大命中次数"] = 1,
        ["伤害值"] = 0,
        ["on命中"] = function(hitUnit)
            _____7ED3_7B97_51B0_7130AOE(context, hitUnit, _____7C7B_578B)
        end,
        ["on结束"] = function(______539F_56E0, _____5F39_5E55ID)
            __TS__Delete(_____5F31_8FFD_8E2A_5F39_4F53_72B6_6001_8868, _____5F39_5E55ID)
        end
    })
end
____exports["释放冰焰双星"] = function(context, target)
    local sera = context["塞拉"]
    if not _____5355_4F4D_6709_6548(sera) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["冰焰双星"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = GetUnitX(target),
        Y = GetUnitY(target),
        ["半径"] = config["目标预警半径"],
        ["持续时间"] = config["施法硬直秒"]
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = sera,
        ["目标单位"] = target,
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(context["Boss单位"], "冰焰双星")
        end,
        ["on生效"] = function()
            _____53D1_5C04_51B0_7130_5F39_4F53(context, target, "冰霜", 1)
            _____53D1_5C04_51B0_7130_5F39_4F53(context, target, "火焰", -1)
        end
    })
end
return ____exports
