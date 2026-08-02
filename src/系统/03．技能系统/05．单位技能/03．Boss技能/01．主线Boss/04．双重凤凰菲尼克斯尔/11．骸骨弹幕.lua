--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔音效配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具")
local _____5468_671F = ____19_FF0E_516C_5171_5DE5_5177["周期"]
local _____5EF6_8FDF = ____19_FF0E_516C_5171_5DE5_5177["延迟"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_516C_5171_5DE5_5177["单位存活"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____53D6_968F_673A_73A9_5BB6_82F1_96C4 = ____19_FF0E_516C_5171_5DE5_5177["取随机玩家英雄"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387 = ____19_FF0E_516C_5171_5DE5_5177["取菲尼克斯尔技能强度倍率"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587 = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔独立伤害上下文"]
local _____6DFB_52A0_5143_7D20_5C42_6570 = ____19_FF0E_516C_5171_5DE5_5177["添加元素层数"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
local _____663E_793A_5E38_89C4_8BFB_6761 = ____19_FF0E_516C_5171_5DE5_5177["显示常规读条"]
local _____5F00_59CB_65BD_6CD5_786C_76F4 = ____19_FF0E_516C_5171_5DE5_5177["开始施法硬直"]
local _____6781_5750_6807X = ____19_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_4E8C_9636_8D1D_585E_5C14XYZ_8F68_8FF9 = ____01_FF0ETS_539F_751F_5F39_5E55["创建二阶贝塞尔XYZ轨迹"]
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetRandomReal = jass.GetRandomReal
local Atan2 = jass.Atan2
local ____jass_bj_RADTODEG_0 = jass.bj_RADTODEG
if ____jass_bj_RADTODEG_0 == nil then
    ____jass_bj_RADTODEG_0 = 57.29577951308232
end
local bj_RADTODEG = ____jass_bj_RADTODEG_0
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local function _____53D6_5750_6807_671D_5411_89D2(fromX, fromY, toX, toY)
    return Atan2(toY - fromY, toX - fromX) * bj_RADTODEG
end
local function _____53D1_5C04_83F2_5C3C_514B_65AF_5C14_9AB8_9AA8_5F39_5E55_6CE2_6B21(context, _____4F24_5BB3_4E0A_4E0B_6587)
    local boss = context.Boss
    if not _____5355_4F4D_5B58_6D3B(boss) then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨弹幕"]
    local bossX = _____53D6_5355_4F4DX(boss)
    local bossY = _____53D6_5355_4F4DY(boss)
    local safeTarget = _____53D6_968F_673A_73A9_5BB6_82F1_96C4(boss)
    local safeAngle = _____5355_4F4D_5B58_6D3B(safeTarget) and _____53D6_5750_6807_671D_5411_89D2(
        bossX,
        bossY,
        _____53D6_5355_4F4DX(safeTarget),
        _____53D6_5355_4F4DY(safeTarget)
    ) or GetRandomReal(0, 360)
    local slotCount = config["每波数量"] + 1
    local angleStep = 360 / slotCount
    local waveHitCount = {}
    local angles = {}
    do
        local i = 0
        while i < config["每波数量"] do
            local angle = safeAngle + (i + 1) * angleStep
            angles[#angles + 1] = angle
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "方向直线",
                X = bossX,
                Y = bossY,
                ["宽度"] = config["弹体命中半径"] * 2,
                ["长度"] = config["半径"],
                ["朝向"] = angle,
                ["持续时间"] = config["读条秒"],
                ["来源单位"] = boss
            })
            i = i + 1
        end
    end
    _____5EF6_8FDF(
        config["读条秒"] * 1000,
        function()
            if not _____5355_4F4D_5B58_6D3B(boss) then
                return
            end
            local startZ = GetUnitFlyHeight(boss)
            local travelDistance = config["半径"] - config["发射前移"]
            local travelSeconds = travelDistance / config["弹体速度"]
            do
                local i = 0
                while i < #angles do
                    local angle = angles[i + 1]
                    local startX = _____6781_5750_6807X(bossX, config["发射前移"], angle)
                    local startY = _____6781_5750_6807Y(bossY, config["发射前移"], angle)
                    local endX = _____6781_5750_6807X(bossX, config["半径"], angle)
                    local endY = _____6781_5750_6807Y(bossY, config["半径"], angle)
                    local controlX = (startX + endX) * 0.5
                    local controlY = (startY + endY) * 0.5
                    _____521B_5EFA_539F_751F_5F39_5E55({
                        ["所有者"] = boss,
                        X = startX,
                        Y = startY,
                        ["方向角"] = angle,
                        ["速度"] = config["弹体速度"],
                        ["生命周期"] = travelSeconds,
                        ["命中半径"] = config["弹体命中半径"],
                        ["影响目标"] = "敌方",
                        ["碰撞消失"] = true,
                        ["每单位最大命中次数"] = 1,
                        ["最大总命中次数"] = 1,
                        ["禁用碰撞"] = true,
                        ["不可阻挡"] = true,
                        ["显式改向后锁定方向"] = true,
                        ["模型"] = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["骨羽"],
                        ["附加特效1"] = {
                            ["模型"] = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["骨羽叠加"],
                            ["附着点"] = "origin",
                            ["跟随主弹幕参数"] = true,
                            ["跟随轨迹俯仰"] = true,
                            ["缩放"] = config["骨矛叠加缩放"]
                        },
                        ["缩放"] = config["弹体缩放"],
                        ["飞行高度"] = startZ,
                        ["轨迹采样器"] = _____521B_5EFA_4E8C_9636_8D1D_585E_5C14XYZ_8F68_8FF9(
                            startX,
                            startY,
                            startZ,
                            controlX,
                            controlY,
                            startZ,
                            endX,
                            endY,
                            0
                        ),
                        ["on命中"] = function(target)
                            local targetId = GetHandleId(target)
                            local hitCount = waveHitCount[targetId] or 0
                            local repeatScale = hitCount > 0 and 0.5 or 1
                            waveHitCount[targetId] = hitCount + 1
                            _____64AD_653E_70B9_7279_6548(
                                _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["骨羽命中"],
                                _____53D6_5355_4F4DX(target),
                                _____53D6_5355_4F4DY(target),
                                config["命中特效持续秒"] * 1000
                            )
                            if _____5355_4F4D_5B58_6D3B(boss) and _____5355_4F4D_5B58_6D3B(target) then
                                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                    ["技能ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能ID"],
                                    ["技能实例ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能实例ID"],
                                    ["标签"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["标签"],
                                    ["来源"] = boss,
                                    ["目标"] = target,
                                    ["伤害公式"] = {
                                        ["来源攻击力比例"] = config["伤害Boss攻击力比例"],
                                        ["目标最大生命比例"] = config["伤害目标最大生命比例"],
                                        ["总倍率"] = _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387(boss) * repeatScale
                                    },
                                    ranged = true,
                                    attackType = ATTACK_TYPE_NORMAL,
                                    ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                                    weaponType = WEAPON_TYPE_WHOKNOWS
                                })
                            end
                            _____6DFB_52A0_5143_7D20_5C42_6570(target, "暗", config["怨火层数"])
                        end
                    })
                    i = i + 1
                end
            end
        end
    )
end
____exports["释放菲尼克斯尔骸骨弹幕"] = function(context)
    if context["当前形态"] ~= "第二形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["骸骨弹幕"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587("菲尼克斯尔骸骨弹幕", config["读条秒"] + config["波次数"] * config["波次间隔秒"] + 2)
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(context.Boss, "骸骨弹幕")
    _____5F00_59CB_65BD_6CD5_786C_76F4(context.Boss, config["读条秒"] + config["波次间隔秒"] * (config["波次数"] - 1))
    _____8BBE_7F6E_5355_4F4D_52A8_753B(context.Boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["弹幕攻击"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["弹幕攻击"]["倍速"])
    _____663E_793A_5E38_89C4_8BFB_6761(config["读条秒"], config["吟唱条颜色ID"], config["吟唱条标题文本"], config["吟唱条提示文本"])
    _____5EF6_8FDF(
        0,
        function()
            _____64AD_653EBoss_5750_6807_97F3_6548(
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["骸骨弹幕"]["起手层"],
                _____53D6_5355_4F4DX(context.Boss),
                _____53D6_5355_4F4DY(context.Boss),
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
            )
            _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["骸骨弹幕"]["飞射层"],
                _____53D6_5355_4F4DX(context.Boss),
                _____53D6_5355_4F4DY(context.Boss),
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["骸骨弹幕"]["飞射层延迟Ms"],
                _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
            )
            do
                local wave = 0
                while wave < config["波次数"] do
                    _____5EF6_8FDF(
                        wave * config["波次间隔秒"] * 1000,
                        function()
                            _____53D1_5C04_83F2_5C3C_514B_65AF_5C14_9AB8_9AA8_5F39_5E55_6CE2_6B21(context, _____4F24_5BB3_4E0A_4E0B_6587)
                        end
                    )
                    wave = wave + 1
                end
            end
        end
    )
end
____exports["初始化菲尼克斯尔骸骨弹幕节点"] = function(context)
    local timerId = _____5468_671F(
        14000,
        function()
            ____exports["释放菲尼克斯尔骸骨弹幕"](context)
        end
    )
    local ____self_7 = context["清理"]
    ____self_7["登记周期回调"](____self_7, "菲尼克斯尔-骸骨弹幕", timerId)
end
____exports["注册菲尼克斯尔骸骨弹幕"] = function()
end
return ____exports
