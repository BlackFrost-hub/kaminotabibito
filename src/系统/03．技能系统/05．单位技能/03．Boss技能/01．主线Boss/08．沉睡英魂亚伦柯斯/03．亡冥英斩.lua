--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.02．数值与表现配置")
local _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["亚伦柯斯正式设计配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.11．台词播放")
local _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放亚伦柯斯台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51B2_950B = _____51FB_9000_7CFB_7EDF["开始冲锋"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local _____521B_5EFA_76F4_7EBF_5B9A_70B9_8F68_8FF9 = ____01_FF0ETS_539F_751F_5F39_5E55["创建直线定点轨迹"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_GetPointZ = ____require_result_4.EC_GetPointZ
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitFacing = jass.SetUnitFacing
local IsUnitType = jass.IsUnitType
local SquareRoot = jass.SquareRoot
local Atan2 = jass.Atan2
local AddSpecialEffect = jass.AddSpecialEffect
local EXSetEffectXY = japi.EXSetEffectXY
local EXSetEffectZ = japi.EXSetEffectZ
local EXSetEffectSize = japi.EXSetEffectSize
local EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local EXEffectMatScale = japi.EXEffectMatScale
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local _____4EA1_51A5_82F1_65A9_6280_80FDKey = "亡冥英斩"
local function _____9020_6210_4EA1_51A5_82F1_65A9_4F24_5BB3(source, target, attackRatio, lifeRatio, tag)
    _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害公式"] = {["来源攻击力比例"] = attackRatio, ["目标最大生命比例"] = lifeRatio},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["标签"] = tag
    })
end
local function _____7ED3_675F_4EA1_51A5_82F1_65A9(context)
    if context["当前大型技能"] == _____4EA1_51A5_82F1_65A9_6280_80FDKey then
        context["当前大型技能"] = nil
    end
end
local function _____9500_6BC1_5F52_9B42_56DE_65A9_5F39_5E55(_____5F39_5E55)
    if _____5F39_5E55 ~= nil and _____5F39_5E55["销毁"] ~= nil then
        _____5F39_5E55["销毁"](_____5F39_5E55, "手动销毁")
    end
end
local function _____4E9A_4F26_67EF_65AF_5F52_9B42_76EE_6807_5141_8BB8(boss, target)
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            if heroes[i + 1] == target then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____5B89_6392P3_5F52_9B42_56DE_65A9(context, startX, startY, endX, endY, distance, reverseFacing)
    local boss = context["Boss单位"]
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["亡冥英斩"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = endX,
        Y = endY,
        ["宽度"] = cfg["路径宽度"],
        ["长度"] = distance,
        ["朝向"] = reverseFacing,
        ["持续时间"] = cfg["P3归魂延迟秒"],
        ["来源单位"] = boss
    })
    local traceX = (startX + endX) * 0.5
    local traceY = (startY + endY) * 0.5
    local trace = AddSpecialEffect(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["归魂剑痕特效路径"], traceX, traceY)
    if trace ~= nil and trace ~= 0 then
        EXSetEffectXY(trace, traceX, traceY)
        EXSetEffectZ(
            trace,
            EC_GetPointZ(traceX, traceY)
        )
        EXEffectMatRotateZ(trace, reverseFacing + cfg["P3剑痕朝向修正角度"])
        EXEffectMatScale(trace, distance / cfg["P3剑痕模型基准长度"], cfg["路径宽度"] / cfg["P3剑痕模型基准宽度"], 1)
        local ____self_5 = context["清理"]
        ____self_5["登记限时特效"](____self_5, "亚伦柯斯-归魂剑痕", trace, (cfg["P3归魂延迟秒"] + cfg["P3归魂推进秒"] + 0.1) * 1000)
    end
    local delayedId = addDelayedCallback(
        cfg["P3归魂延迟秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] or context["阶段"] ~= "P3最后的誓约" then
                _____7ED3_675F_4EA1_51A5_82F1_65A9(context)
                return
            end
            _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["P3归魂动画编号"], ["持续秒"] = 1, ["恢复动画编号"] = 1})
            _____64AD_653EBoss_5750_6807_97F3_6548(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效"]["归魂剑痕"], endX, endY, _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效默认裁断距离"])
            local _____5F39_5E55 = _____521B_5EFA_539F_751F_5F39_5E55({
                ["所有者"] = boss,
                ["载体模式"] = "特效",
                X = endX,
                Y = endY,
                ["方向角"] = reverseFacing,
                ["速度"] = distance / cfg["P3归魂推进秒"],
                ["生命周期"] = cfg["P3归魂推进秒"],
                ["最大距离"] = distance,
                ["轨迹采样器"] = _____521B_5EFA_76F4_7EBF_5B9A_70B9_8F68_8FF9(endX, endY, startX, startY),
                ["命中半径"] = cfg["路径宽度"] * 0.5,
                ["影响目标"] = "敌方",
                ["每单位最大命中次数"] = 1,
                ["碰撞消失"] = false,
                ["禁用碰撞"] = true,
                ["附加特效1"] = {
                    ["模型"] = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["归魂剑痕特效路径"],
                    ["跟随主弹幕参数"] = true,
                    ["缩放X"] = distance / cfg["P3剑痕模型基准长度"],
                    ["缩放Y"] = cfg["路径宽度"] / cfg["P3剑痕模型基准宽度"],
                    ["缩放Z"] = 1,
                    ["朝向角偏移"] = cfg["P3剑痕朝向修正角度"]
                },
                ["目标筛选"] = function(target)
                    return _____4E9A_4F26_67EF_65AF_5F52_9B42_76EE_6807_5141_8BB8(boss, target)
                end,
                ["on命中"] = function(target)
                    if not _____5355_4F4D_6709_6548(target) then
                        return
                    end
                    _____9020_6210_4EA1_51A5_82F1_65A9_4F24_5BB3(
                        boss,
                        target,
                        cfg["P3归魂伤害攻击力比例"],
                        cfg["P3归魂伤害目标最大生命比例"],
                        "亚伦柯斯·亡冥英斩-归魂回斩"
                    )
                end,
                ["on结束"] = function()
                    _____7ED3_675F_4EA1_51A5_82F1_65A9(context)
                end
            })
            local ____self_6 = context["清理"]
            ____self_6["登记清理"](____self_6, "亚伦柯斯-归魂回斩弹幕", _____9500_6BC1_5F52_9B42_56DE_65A9_5F39_5E55, _____5F39_5E55)
        end
    )
    local ____self_7 = context["清理"]
    ____self_7["登记延迟回调"](____self_7, "亚伦柯斯-归魂回斩", delayedId)
end
____exports["释放亚伦柯斯亡冥英斩"] = function(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["战斗已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["亡冥英斩"]
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local dx = GetUnitX(target) - startX
    local dy = GetUnitY(target) - startY
    local rawDistance = SquareRoot(dx * dx + dy * dy)
    if not (rawDistance > 1) then
        return false
    end
    local distance = rawDistance < cfg["推进距离"] and rawDistance or cfg["推进距离"]
    local ratio = distance / rawDistance
    local endX = startX + dx * ratio
    local endY = startY + dy * ratio
    local facing = Atan2(dy, dx) * RAD_TO_DEG
    local isP3 = context["阶段"] == "P3最后的誓约"
    local totalDuration = cfg["前摇秒"] + cfg["推进秒"] + (isP3 and cfg["P3归魂延迟秒"] + cfg["P3归魂推进秒"] or 0)
    SetUnitFacing(boss, facing)
    context["当前大型技能"] = _____4EA1_51A5_82F1_65A9_6280_80FDKey
    context["普通机制忙碌到Ms"] = getServerTime() + (totalDuration + 0.4) * 1000
    _____5F00_59CB_786C_76F4(boss, cfg["前摇秒"])
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["前摇动画编号"], ["持续秒"] = cfg["前摇秒"], ["恢复动画"] = false})
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = startX,
        Y = startY,
        ["宽度"] = cfg["路径宽度"],
        ["长度"] = distance,
        ["朝向"] = facing,
        ["持续时间"] = cfg["前摇秒"],
        ["来源单位"] = boss
    })
    local charge = AddSpecialEffect(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["亡冥英斩蓄势特效路径"], startX, startY)
    if charge ~= nil and charge ~= 0 then
        EXEffectMatRotateZ(charge, facing)
        YDWETimerDestroyEffectSafe(cfg["前摇秒"] + 0.2, charge)
    end
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(boss, isP3 and "亡冥英斩归魂" or "亡冥英斩")
    _____64AD_653EBoss_5750_6807_97F3_6548(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效"]["亡冥英斩蓄势"], startX, startY, _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效默认裁断距离"])
    local delayedId = addDelayedCallback(
        cfg["前摇秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                _____7ED3_675F_4EA1_51A5_82F1_65A9(context)
                return
            end
            local chargeId = _____5F00_59CB_51B2_950B(
                boss,
                {
                    ["目标X"] = endX,
                    ["目标Y"] = endY,
                    ["距离"] = distance,
                    ["持续时间"] = cfg["推进秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["位移特效"] = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["亡冥英斩轨迹特效路径"],
                    ["附加位移特效"] = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["亡冥英斩附加轨迹特效路径"],
                    ["命中半径"] = cfg["命中半径"],
                    ["只命中敌人"] = true,
                    ["允许重复命中"] = false,
                    ["命中后结束"] = false,
                    ["命中回调"] = function(source, hit)
                        _____64AD_653EBoss_5750_6807_97F3_6548(
                            _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效"]["亡冥英斩突进命中"],
                            GetUnitX(hit),
                            GetUnitY(hit),
                            _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效默认裁断距离"]
                        )
                        _____9020_6210_4EA1_51A5_82F1_65A9_4F24_5BB3(
                            source,
                            hit,
                            cfg["伤害攻击力比例"],
                            cfg["伤害目标最大生命比例"],
                            "亚伦柯斯·亡冥英斩"
                        )
                        local effect = AddSpecialEffect(
                            _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["亡冥英斩命中特效路径"],
                            GetUnitX(hit),
                            GetUnitY(hit)
                        )
                        if effect ~= nil and effect ~= 0 then
                            YDWETimerDestroyEffectSafe(0.6, effect)
                        end
                        local overlay = AddSpecialEffect(
                            _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["亡冥英斩附加命中特效路径"],
                            GetUnitX(hit),
                            GetUnitY(hit)
                        )
                        if overlay ~= nil and overlay ~= 0 then
                            YDWETimerDestroyEffectSafe(0.6, overlay)
                        end
                    end,
                    ["开始回调"] = function()
                        _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["推进秒"] + 0.2, ["恢复动画编号"] = 1})
                    end,
                    ["结束回调"] = function(_source, reason)
                        local actualEndX = GetUnitX(boss)
                        local actualEndY = GetUnitY(boss)
                        if isP3 and (reason == "完成" or reason == "撞墙") then
                            local actualDx = actualEndX - startX
                            local actualDy = actualEndY - startY
                            local actualDistance = SquareRoot(actualDx * actualDx + actualDy * actualDy)
                            if actualDistance > 1 then
                                _____5B89_6392P3_5F52_9B42_56DE_65A9(
                                    context,
                                    startX,
                                    startY,
                                    actualEndX,
                                    actualEndY,
                                    actualDistance,
                                    facing + 180
                                )
                            else
                                _____7ED3_675F_4EA1_51A5_82F1_65A9(context)
                            end
                        else
                            _____7ED3_675F_4EA1_51A5_82F1_65A9(context)
                        end
                    end
                }
            )
            if chargeId == 0 then
                _____7ED3_675F_4EA1_51A5_82F1_65A9(context)
            end
        end
    )
    local ____self_8 = context["清理"]
    ____self_8["登记延迟回调"](____self_8, "亚伦柯斯-亡冥英斩前摇", delayedId)
    return true
end
____exports["亡冥英斩迁移状态"] = {
    ["旧技能ID"] = "A0F4",
    ["通用技能壳ID"] = "AT00",
    ["已保留旧原型语义"] = true,
    ["已完成TS实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = true,
    ["语义"] = "公共直线预警后由Boss本体沿路径冲锋，每个目标最多命中一次；P3剑痕按实际路径定向拉伸，并从终点向起点真实移动完成归魂结算。"
}
return ____exports
