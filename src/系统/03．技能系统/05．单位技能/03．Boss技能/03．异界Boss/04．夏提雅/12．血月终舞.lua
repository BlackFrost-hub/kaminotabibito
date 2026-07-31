--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51B2_950B = _____51FB_9000_7CFB_7EDF["开始冲锋"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["执行战斗自身传送到坐标"]
local _____6247_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF = _____6247_5F62_533A_57DF["单位是否在扇形区域"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.01．多阶段技能编排.06．技能阶段链执行器")
local _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建立即执行阶段"]
local _____521B_5EFA_5EF6_8FDF_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建延迟阶段"]
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____03_FF0E_5BF9_5916_63A5_53E3["创建原生弹幕"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_3["读取Boss战运行上下文"]
local ____require_result_4 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_4["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_4["关闭吟唱条"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_5.getServerTime
local addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_6.YDWETimerDestroyEffectSafe
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_8 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_8.CosBJ
local SinBJ = ____require_result_8.SinBJ
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local GetRectCenterX = jass.GetRectCenterX
local GetRectCenterY = jass.GetRectCenterY
local GetRandomInt = jass.GetRandomInt
local GetRandomReal = jass.GetRandomReal
local Atan2 = jass.Atan2
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local AddSpecialEffect = jass.AddSpecialEffect
local EXSetEffectZ = japi.EXSetEffectZ
local EXSetEffectSize = japi.EXSetEffectSize
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local _____8840_6708_7EC8_821E_6280_80FDKey = "血月终舞"
local function _____53D6P3_8282_594F_500D_7387(context)
    return 1 / (1 + context["血宴层数"] * _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["血宴每层技能节奏提高"])
end
local function _____79FB_52A8_5230_573A_5730_4E2D_5FC3(boss)
    local battle = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(boss)
    local ____opt_result_11
    if battle ~= nil then
        ____opt_result_11 = battle["地点矩形"]
    end
    local rect = ____opt_result_11
    if rect ~= nil and rect ~= 0 then
        _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(
            boss,
            GetRectCenterX(rect),
            GetRectCenterY(rect)
        )
    end
end
local function _____521B_5EFA_7A7A_4E2D_8840_6708(x, y, duration)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3
    local main = AddSpecialEffect(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血月终舞特效路径"], x, y)
    local aux = AddSpecialEffect(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血月终舞辅助特效路径"], x, y)
    if main ~= nil and main ~= 0 then
        EXSetEffectZ(main, cfg["血月高度"])
        EXSetEffectSize(main, cfg["血月缩放"])
        YDWETimerDestroyEffectSafe(duration, main)
    end
    if aux ~= nil and aux ~= 0 then
        EXSetEffectZ(aux, cfg["血月高度"])
        EXSetEffectSize(aux, cfg["血月缩放"])
        YDWETimerDestroyEffectSafe(duration, aux)
    end
end
local function _____521B_5EFA_7EC8_821E_52A8_753B_91CD_64AD_65F6_70B9(duration, interval)
    local result = {}
    if not (interval > 0) then
        return result
    end
    do
        local elapsed = interval
        while elapsed < duration do
            result[#result + 1] = elapsed
            elapsed = elapsed + interval
        end
    end
    return result
end
local function _____64AD_653E_8840_6708_7EC8_821E_56FE3_7279_6548(x, y, facing, duration)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血月终舞图3特效路径"],
        X = x,
        Y = y,
        ["持续秒"] = duration,
        ["缩放"] = cfg["终舞图3特效缩放"],
        ["Z轴角度"] = facing,
        ["动画索引"] = 0
    })
end
local function _____53D6_8840_6708_7EC8_821E_6247_533A_4F24_5BB3_7C7B_578B()
    local ____type = GetRandomInt(1, 3)
    if ____type == 1 then
        return DAMAGE_TYPE_SHADOW_STRIKE
    end
    if ____type == 2 then
        return DAMAGE_TYPE_ENHANCED
    end
    return DAMAGE_TYPE_NORMAL
end
local function _____53D1_5C04_8840_6708_7EC8_821E_6247_533A_5F39_5E55(context, x, y, facing, _____6BCF_6247_533A_6301_7EED_79D2)
    local boss = context["Boss单位"]
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3
    local count = cfg["扇区弹幕数量"] > 0 and cfg["扇区弹幕数量"] or 1
    local _____53D1_5C04_95F4_9694_79D2 = _____6BCF_6247_533A_6301_7EED_79D2 > 0 and _____6BCF_6247_533A_6301_7EED_79D2 / count or cfg["扇区弹幕间隔秒"]
    local halfWidth = (count - 1) * cfg["扇区弹幕横向间距"] * 0.5
    do
        local i = 0
        while i < count do
            local _____5F39_5E55_4F24_5BB3_7C7B_578B = _____53D6_8840_6708_7EC8_821E_6247_533A_4F24_5BB3_7C7B_578B()
            local _____53D1_5C04_5EF6_8FDF_79D2 = i * _____53D1_5C04_95F4_9694_79D2
            local lateralOffset = i * cfg["扇区弹幕横向间距"] - halfWidth
            local startX = x - SinBJ(facing) * lateralOffset
            local startY = y + CosBJ(facing) * lateralOffset
            local _____7279_6548_5EF6_8FDFID = addDelayedCallback(
                _____53D1_5C04_5EF6_8FDF_79D2 * 1000,
                function()
                    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= _____8840_6708_7EC8_821E_6280_80FDKey then
                        return
                    end
                    _____64AD_653E_8840_6708_7EC8_821E_56FE3_7279_6548(x, y, facing, cfg["终舞图3特效持续秒"])
                end
            )
            local ____self_12 = context["清理"]
            ____self_12["登记延迟回调"](
                ____self_12,
                "夏提雅-血月终舞扇区图3-" .. tostring(i + 1),
                _____7279_6548_5EF6_8FDFID
            )
            local barrage = _____521B_5EFA_539F_751F_5F39_5E55({
                ["所有者"] = boss,
                ["载体模式"] = "单位",
                X = startX,
                Y = startY,
                ["方向角"] = facing,
                ["速度"] = cfg["扇区弹幕速度"],
                ["延迟发射"] = _____53D1_5C04_5EF6_8FDF_79D2,
                ["最大距离"] = cfg["扇区半径"],
                ["生命周期"] = cfg["扇区弹幕生命周期秒"],
                ["命中半径"] = cfg["扇区弹幕命中半径"],
                ["影响目标"] = "敌方",
                ["碰撞消失"] = false,
                ["每单位最大命中次数"] = 1,
                ["不可阻挡"] = true,
                ["禁用碰撞"] = true,
                ["显式改向后锁定方向"] = true,
                ["模型"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血月终舞图2弹幕特效路径"],
                ["缩放"] = cfg["扇区弹幕缩放"],
                ["攻击类型"] = ATTACK_TYPE_NORMAL,
                ["伤害类型"] = _____5F39_5E55_4F24_5BB3_7C7B_578B,
                ["武器类型"] = WEAPON_TYPE_METAL_HEAVY_SLICE,
                ["来源类型"] = "Boss技能",
                ["技能标签"] = "夏提雅·血月终舞-扇区弹幕",
                ["伤害形态"] = "AOE",
                ["目标筛选"] = function(target)
                    return _____5355_4F4D_6709_6548(target) and _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF(
                        target,
                        x,
                        y,
                        cfg["扇区半径"],
                        facing,
                        cfg["扇区角度"]
                    )
                end,
                ["on命中"] = function(target)
                    local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, target, {["来源攻击力比例"] = cfg["扇区伤害攻击力比例"], ["目标最大生命比例"] = cfg["扇区伤害目标最大生命比例"]}) / count
                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                        ["来源"] = boss,
                        ["目标"] = target,
                        ["伤害"] = damage,
                        attack = false,
                        ranged = true,
                        attackType = ATTACK_TYPE_NORMAL,
                        ["伤害类型"] = _____5F39_5E55_4F24_5BB3_7C7B_578B,
                        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                        ["来源类型"] = "Boss技能",
                        ["标签"] = "夏提雅·血月终舞-扇区弹幕"
                    })
                end
            })
            if barrage["弹幕单位"] ~= nil and barrage["弹幕单位"] ~= 0 then
                SetUnitAnimationByIndex(barrage["弹幕单位"], 0)
            end
            i = i + 1
        end
    end
end
local function _____53D1_5C04_8840_6708_7EC8_821E_4FEF_51B2_56FE2(boss, x, y, facing, duration)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3
    local barrage = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        ["载体模式"] = "单位",
        X = x,
        Y = y,
        ["方向角"] = facing,
        ["速度"] = cfg["终舞俯冲图2速度"],
        ["最大距离"] = cfg["终舞冲锋长度"],
        ["生命周期"] = duration,
        ["命中半径"] = 0,
        ["影响目标"] = "敌方",
        ["碰撞消失"] = false,
        ["不可阻挡"] = true,
        ["禁用碰撞"] = true,
        ["显式改向后锁定方向"] = true,
        ["模型"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血月终舞图2弹幕特效路径"],
        ["缩放"] = cfg["终舞俯冲图2缩放"]
    })
    if barrage["弹幕单位"] ~= nil and barrage["弹幕单位"] ~= 0 then
        SetUnitAnimationByIndex(barrage["弹幕单位"], 0)
    end
end
local function _____7ED3_675F_8840_6708_7EC8_821E(context)
    _____5173_95ED_541F_5531_6761("大招")
    if context["当前大型技能"] == _____8840_6708_7EC8_821E_6280_80FDKey then
        context["当前大型技能"] = nil
    end
end
____exports["释放夏提雅血月终舞"] = function(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["挑战已结束"] or context["阶段"] ~= "P3真祖血宴" or not context["P3转阶段已处理"] or context["血月终舞已释放"] or context["当前大型技能"] ~= nil then
        return false
    end
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "血月终舞")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["血月终舞启动"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3
    _____79FB_52A8_5230_573A_5730_4E2D_5FC3(boss)
    local centerX = GetUnitX(boss)
    local centerY = GetUnitY(boss)
    local finalFacing = Atan2(
        GetUnitY(target) - centerY,
        GetUnitX(target) - centerX
    ) * RAD_TO_DEG
    local endX = centerX + CosBJ(finalFacing) * cfg["终舞冲锋长度"]
    local endY = centerY + SinBJ(finalFacing) * cfg["终舞冲锋长度"]
    local pace = _____53D6P3_8282_594F_500D_7387(context)
    local sectorWarning = cfg["扇区预警秒"] * pace
    local sectorTotal = sectorWarning * 4
    local chargeDuration = cfg["终舞冲锋秒"] * pace
    local recovery = GetRandomReal(cfg["血月终舞回落最小秒"], cfg["血月终舞回落最大秒"])
    local activeDuration = sectorTotal + chargeDuration
    local totalDuration = activeDuration + recovery
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, finalFacing)
    local executor = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "夏提雅-血月终舞", ["清理"] = context["清理"], ["互斥组"] = "夏提雅大型技能"})
    context["血月终舞已释放"] = true
    context["当前大型技能"] = _____8840_6708_7EC8_821E_6280_80FDKey
    context["普通机制忙碌到Ms"] = getServerTime() + totalDuration * 1000
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
    local stages = {_____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
        function()
            _____5F00_59CB_786C_76F4(boss, sectorTotal)
            _____521B_5EFA_7A7A_4E2D_8840_6708(centerX, centerY, activeDuration + 0.5)
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "方向直线",
                X = centerX,
                Y = centerY,
                ["宽度"] = cfg["终舞冲锋宽度"],
                ["长度"] = cfg["终舞冲锋长度"],
                ["朝向"] = finalFacing,
                ["持续时间"] = sectorTotal,
                ["来源单位"] = boss
            })
        end,
        "血月与最终路径"
    )}
    do
        local i = 0
        while i < 4 do
            local sectorFacing = finalFacing + i * 90
            stages[#stages + 1] = _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                function()
                    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, sectorFacing)
                    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
                        ["单位"] = boss,
                        ["动画编号"] = cfg["终舞引导动画编号"],
                        ["持续秒"] = sectorWarning,
                        ["重播时点秒列表"] = _____521B_5EFA_7EC8_821E_52A8_753B_91CD_64AD_65F6_70B9(sectorWarning, cfg["终舞引导动画循环秒"]),
                        ["恢复动画编号"] = 0
                    })
                    _____53D1_5C04_8840_6708_7EC8_821E_6247_533A_5F39_5E55(
                        context,
                        centerX,
                        centerY,
                        sectorFacing,
                        sectorWarning
                    )
                    _____521B_5EFA_6280_80FD_63D0_793A_5708({
                        ["类型"] = "扇形",
                        X = centerX,
                        Y = centerY,
                        ["半径"] = cfg["扇区半径"],
                        ["扇形角度"] = cfg["扇区角度"],
                        ["朝向"] = sectorFacing,
                        ["持续时间"] = sectorWarning,
                        ["来源单位"] = boss
                    })
                end,
                ("第" .. tostring(i + 1)) .. "扇区预警"
            )
            stages[#stages + 1] = _____521B_5EFA_5EF6_8FDF_9636_6BB5(
                sectorWarning * 1000,
                ("第" .. tostring(i + 1)) .. "扇区前摇"
            )
            stages[#stages + 1] = _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                function()
                    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, sectorFacing)
                end,
                ("第" .. tostring(i + 1)) .. "扇区结算"
            )
            i = i + 1
        end
    end
    stages[#stages + 1] = _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
        function()
            if context["当前大型技能"] ~= _____8840_6708_7EC8_821E_6280_80FDKey or context["阶段"] ~= "P3真祖血宴" then
                return
            end
            _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, finalFacing)
            _____53D1_5C04_8840_6708_7EC8_821E_4FEF_51B2_56FE2(
                boss,
                centerX,
                centerY,
                finalFacing,
                chargeDuration
            )
            _____5F00_59CB_51B2_950B(
                boss,
                {
                    ["角度"] = finalFacing,
                    ["目标X"] = endX,
                    ["目标Y"] = endY,
                    ["距离"] = cfg["终舞冲锋长度"],
                    ["持续时间"] = chargeDuration,
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["位移特效"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["滴管长枪拖尾特效路径"],
                    ["命中半径"] = cfg["终舞冲锋宽度"] * 0.5,
                    ["只命中敌人"] = true,
                    ["允许重复命中"] = false,
                    ["命中后结束"] = false,
                    ["命中回调"] = function(_source, hit)
                        _____64AD_653EBoss_5750_6807_97F3_6548(
                            _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["血月终舞"],
                            GetUnitX(hit),
                            GetUnitY(hit),
                            _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
                        )
                        local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, hit, {["来源攻击力比例"] = cfg["终舞冲锋伤害攻击力比例"], ["目标最大生命比例"] = cfg["终舞冲锋伤害目标最大生命比例"]})
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["来源"] = boss,
                            ["目标"] = hit,
                            ["伤害"] = damage,
                            attack = false,
                            ranged = false,
                            attackType = ATTACK_TYPE_NORMAL,
                            ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                            weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                            ["来源类型"] = "Boss技能",
                            ["标签"] = "夏提雅·血月终舞-俯冲"
                        })
                    end,
                    ["开始回调"] = function()
                        _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, finalFacing)
                        SetUnitAnimationByIndex(boss, cfg["终舞冲锋动画编号"])
                    end
                }
            )
        end,
        "最终俯冲"
    )
    stages[#stages + 1] = _____521B_5EFA_5EF6_8FDF_9636_6BB5(chargeDuration * 1000, "最终俯冲")
    stages[#stages + 1] = _____521B_5EFA_5EF6_8FDF_9636_6BB5(recovery * 1000, "真祖回落期")
    _____663E_793A_5927_62DB_541F_5531_6761({
        ["通道"] = "大招",
        ["总时长"] = activeDuration,
        ["颜色ID"] = 2,
        ["标题文本"] = "血月终舞",
        ["提示文本"] = "依次避开血月扇区与提前锁定的最终冲锋路径"
    })
    local executionId = executor["开始"](
        executor,
        {
            key = _____8840_6708_7EC8_821E_6280_80FDKey,
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = (totalDuration + 1) * 1000,
            ["阶段列表"] = stages,
            ["结束回调"] = function()
                _____7ED3_675F_8840_6708_7EC8_821E(context)
            end
        }
    )
    if executionId == 0 then
        _____7ED3_675F_8840_6708_7EC8_821E(context)
        return false
    end
    return true
end
____exports["血月终舞技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = true,
    ["语义"] = "血月映照四个扇区依次结算，最后按提前锁定方向完成长枪俯冲。"
}
return ____exports
