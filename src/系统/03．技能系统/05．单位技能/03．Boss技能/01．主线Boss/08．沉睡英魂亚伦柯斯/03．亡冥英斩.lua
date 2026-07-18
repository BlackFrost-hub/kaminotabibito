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
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local _____80F6_56CA_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.胶囊区域")
local _____5355_4F4D_662F_5426_5728_80F6_56CA_533A_57DF = _____80F6_56CA_533A_57DF["单位是否在胶囊区域"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local SquareRoot = jass.SquareRoot
local Atan2 = jass.Atan2
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local _____4EA1_51A5_82F1_65A9_6280_80FDKey = "亡冥英斩"
local function _____9020_6210_4EA1_51A5_82F1_65A9_4F24_5BB3(source, target, attackRatio, lifeRatio, tag)
    local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(source, target, {["来源攻击力比例"] = attackRatio, ["目标最大生命比例"] = lifeRatio})
    _____9020_6210AOE_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害"] = damage,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "Boss技能",
        ["标签"] = tag
    })
end
local function _____7ED3_675F_4EA1_51A5_82F1_65A9(context)
    if context["当前大型技能"] == _____4EA1_51A5_82F1_65A9_6280_80FDKey then
        context["当前大型技能"] = nil
    end
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
    local trace = AddSpecialEffect(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["归魂剑痕特效路径"], (startX + endX) * 0.5, (startY + endY) * 0.5)
    if trace ~= nil and trace ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["P3归魂延迟秒"] + 0.4, trace)
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
            local effect = AddSpecialEffect(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["归魂剑痕特效路径"], endX, endY)
            if effect ~= nil and effect ~= 0 then
                YDWETimerDestroyEffectSafe(0.8, effect)
            end
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            do
                local i = 0
                while i < #heroes do
                    local target = heroes[i + 1]
                    if _____5355_4F4D_662F_5426_5728_80F6_56CA_533A_57DF(
                        target,
                        startX,
                        startY,
                        endX,
                        endY,
                        cfg["路径宽度"]
                    ) then
                        _____9020_6210_4EA1_51A5_82F1_65A9_4F24_5BB3(
                            boss,
                            target,
                            cfg["P3归魂伤害攻击力比例"],
                            cfg["P3归魂伤害目标最大生命比例"],
                            "亚伦柯斯·亡冥英斩-归魂回斩"
                        )
                    end
                    i = i + 1
                end
            end
            _____7ED3_675F_4EA1_51A5_82F1_65A9(context)
        end
    )
    local ____self_5 = context["清理"]
    ____self_5["登记延迟回调"](____self_5, "亚伦柯斯-归魂回斩", delayedId)
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
    local totalDuration = cfg["前摇秒"] + cfg["推进秒"] + (isP3 and cfg["P3归魂延迟秒"] or 0)
    context["当前大型技能"] = _____4EA1_51A5_82F1_65A9_6280_80FDKey
    context["普通机制忙碌到Ms"] = getServerTime() + (totalDuration + 0.4) * 1000
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
    local ____self_6 = context["清理"]
    ____self_6["登记延迟回调"](____self_6, "亚伦柯斯-亡冥英斩前摇", delayedId)
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
    ["语义"] = "公共直线预警后由Boss本体沿路径冲锋，每个目标最多命中一次；P3沿实际冲锋路径延迟反向归魂结算。"
}
return ____exports
