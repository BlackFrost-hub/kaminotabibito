local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____03_FF0E_6EF4_7BA1_957F_67AA_8FDE_51FB = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.03．滴管长枪连击")
local _____5237_65B0_590F_63D0_96C5_730E_8840_8FDE_51FBBuff = ____03_FF0E_6EF4_7BA1_957F_67AA_8FDE_51FB["刷新夏提雅猎血连击Buff"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____09_FF0E_82F1_7075_6218_4E59_5973 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.09．英灵战乙女")
local _____83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71 = ____09_FF0E_82F1_7075_6218_4E59_5973["获取夏提雅英灵投影"]
local _____5C1D_8BD5_89E6_53D1_82F1_7075_6218_4E59_5973_590D_523B = ____09_FF0E_82F1_7075_6218_4E59_5973["尝试触发英灵战乙女复刻"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_541F_5531_6761 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.19．吟唱条")
local _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761 = ____19_FF0E_541F_5531_6761["显示夏提雅常规吟唱条"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_1["造成AOE技能伤害"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("平台扩展API动作")
local _____7279_6548_663E_793A__9690_85CF = ____require_result_3["特效显示_隐藏"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.冲锋残影表现")
local _____5F00_59CB_51B2_950B_5E76_9644_5E26_6B8B_5F71_8868_73B0 = ____require_result_4["开始冲锋并附带残影表现"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local ____require_result_6 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_6.CosBJ
local SinBJ = ____require_result_6.SinBJ
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitPosition = jass.SetUnitPosition
local SetUnitFacing = jass.SetUnitFacing
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local GetRandomReal = jass.GetRandomReal
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local function _____9690_85CF_5E76_9500_6BC1_6EF4_7BA1_7A7F_5FC3_547D_4E2D_7279_6548(effect)
    if effect == nil or effect == 0 then
        return
    end
    _____7279_6548_663E_793A__9690_85CF(effect, false)
    DestroyEffect(effect)
end
local function _____5F00_59CB_6EF4_7BA1_7A7F_5FC3_51B2_950B(unit, moveConfig, facing, _____52A8_753B_901F_5EA6)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管穿心"]
    return _____5F00_59CB_51B2_950B_5E76_9644_5E26_6B8B_5F71_8868_73B0(
        unit,
        __TS__ObjectAssign({}, moveConfig, {["位移特效"] = ""}),
        {
            ["残影模型"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["滴管长枪拖尾特效路径"],
            ["残影生成间隔"] = cfg["拖尾特效生成间隔秒"],
            ["残影生命周期"] = cfg["拖尾特效生命周期秒"],
            ["残影透明度"] = 255,
            ["残影朝向"] = facing,
            ["动画速度"] = _____52A8_753B_901F_5EA6
        }
    )
end
local function _____5C1D_8BD5_5B89_6392_6EF4_7BA1_7A7F_5FC3_82F1_7075_590D_523B(context, lockedX, lockedY)
    local projection = _____83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71(context)
    if not _____5355_4F4D_6709_6548(projection) then
        debugLogForce("夏提雅-滴管穿心", "英灵复刻跳过：投影无效")
        return
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管穿心"]
    local p2 = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local startX = GetUnitX(projection)
    local startY = GetUnitY(projection)
    local dx = lockedX - startX
    local dy = lockedY - startY
    local rawDistance = SquareRoot(dx * dx + dy * dy)
    if not (rawDistance > 1) then
        local bossX = GetUnitX(context["Boss单位"])
        local bossY = GetUnitY(context["Boss单位"])
        local bossDx = lockedX - bossX
        local bossDy = lockedY - bossY
        local bossDistance = SquareRoot(bossDx * bossDx + bossDy * bossDy)
        if not (bossDistance > 1) then
            debugLogForce("夏提雅-滴管穿心", "英灵复刻跳过：Boss与目标重合", "distance=", rawDistance)
            return
        end
        local fallbackFacing = Atan2(bossDy, bossDx) * RAD_TO_DEG
        startX = lockedX + CosBJ(fallbackFacing) * p2["英灵常驻距离"]
        startY = lockedY + SinBJ(fallbackFacing) * p2["英灵常驻距离"]
        SetUnitPosition(projection, startX, startY)
        SetUnitFacing(projection, fallbackFacing + 180)
        dx = lockedX - startX
        dy = lockedY - startY
        rawDistance = SquareRoot(dx * dx + dy * dy)
        debugLogForce(
            "夏提雅-滴管穿心",
            "英灵复刻重置起点",
            "distance=",
            rawDistance,
            "facing=",
            fallbackFacing
        )
    end
    local distance = rawDistance < cfg["最大距离"] and rawDistance or cfg["最大距离"]
    local ratio = distance / rawDistance
    local endX = startX + dx * ratio
    local endY = startY + dy * ratio
    local facing = Atan2(dy, dx) * RAD_TO_DEG
    local delay = GetRandomReal(p2["英灵复刻延迟最小秒"], p2["英灵复刻延迟最大秒"])
    local started = _____5C1D_8BD5_89E6_53D1_82F1_7075_6218_4E59_5973_590D_523B(
        context,
        "滴管穿心",
        {
            X = startX,
            Y = startY,
            ["朝向"] = facing,
            ["延迟秒"] = delay,
            ["复刻结算"] = function()
                _____5F00_59CB_786C_76F4(projection, cfg["冲锋秒"])
                _____5F00_59CB_6EF4_7BA1_7A7F_5FC3_51B2_950B(
                    projection,
                    {
                        ["目标X"] = endX,
                        ["目标Y"] = endY,
                        ["距离"] = distance,
                        ["持续时间"] = cfg["冲锋秒"],
                        ["检查地形"] = true,
                        ["暂停单位"] = false,
                        ["禁用碰撞"] = true,
                        ["命中半径"] = cfg["命中半径"],
                        ["只命中敌人"] = true,
                        ["允许重复命中"] = false,
                        ["命中后结束"] = false,
                        ["动画序号"] = p2["英灵复刻冲锋动画编号"],
                        ["命中回调"] = function(_source, hit)
                            local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(context["Boss单位"], hit, {["来源攻击力比例"] = cfg["伤害攻击力比例"] * p2["英灵复刻伤害比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"] * p2["英灵复刻伤害比例"]})
                            _____9020_6210AOE_6280_80FD_4F24_5BB3({
                                ["来源"] = context["Boss单位"],
                                ["目标"] = hit,
                                ["伤害"] = damage,
                                attack = false,
                                ranged = false,
                                attackType = ATTACK_TYPE_NORMAL,
                                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                                weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                                ["来源类型"] = "Boss技能",
                                ["标签"] = "夏提雅·英灵复刻-滴管穿心"
                            })
                        end
                    },
                    facing,
                    p2["英灵复刻冲锋动画速度"]
                )
            end
        }
    )
    debugLogForce(
        "夏提雅-滴管穿心",
        "英灵复刻安排",
        "started=",
        started,
        "distance=",
        distance,
        "facing=",
        facing,
        "delay=",
        delay
    )
    if started then
        _____521B_5EFA_6280_80FD_63D0_793A_5708({
            ["类型"] = "方向直线",
            X = startX,
            Y = startY,
            ["宽度"] = cfg["路径宽度"],
            ["长度"] = distance,
            ["朝向"] = facing,
            ["持续时间"] = delay,
            ["来源单位"] = context["Boss单位"]
        })
    end
end
____exports["释放夏提雅滴管穿心"] = function(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        debugLogForce(
            "夏提雅-滴管穿心",
            "本体释放拒绝",
            "boss=",
            _____5355_4F4D_6709_6548(boss),
            "target=",
            _____5355_4F4D_6709_6548(target),
            "ended=",
            context["挑战已结束"],
            "largeSkill=",
            context["当前大型技能"]
        )
        return false
    end
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "滴管穿心")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["滴管穿心突进"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管穿心"]
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local dx = targetX - startX
    local dy = targetY - startY
    local rawDistance = SquareRoot(dx * dx + dy * dy)
    if not (rawDistance > 1) then
        debugLogForce("夏提雅-滴管穿心", "本体释放拒绝：目标距离过小", "distance=", rawDistance)
        return false
    end
    local distance = rawDistance < cfg["最大距离"] and rawDistance or cfg["最大距离"]
    local ratio = distance / rawDistance
    local endX = startX + dx * ratio
    local endY = startY + dy * ratio
    local facing = Atan2(dy, dx) * RAD_TO_DEG
    SetUnitFacing(boss, facing)
    _____5F00_59CB_786C_76F4(boss, cfg["预警秒"])
    _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761(cfg["预警秒"], cfg["吟唱条颜色ID"], cfg["吟唱条标题文本"], cfg["吟唱条提示文本"])
    context["普通机制忙碌到Ms"] = getServerTime() + (cfg["预警秒"] + cfg["冲锋秒"]) * 1000
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = startX,
        Y = startY,
        ["宽度"] = cfg["路径宽度"],
        ["长度"] = distance,
        ["朝向"] = facing,
        ["持续时间"] = cfg["预警秒"],
        ["来源单位"] = boss
    })
    local mainTargetId = GetHandleId(target)
    local delayedId = addDelayedCallback(
        cfg["预警秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
                return
            end
            local chargeId = _____5F00_59CB_6EF4_7BA1_7A7F_5FC3_51B2_950B(
                boss,
                {
                    ["目标X"] = endX,
                    ["目标Y"] = endY,
                    ["距离"] = distance,
                    ["持续时间"] = cfg["冲锋秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["命中半径"] = cfg["命中半径"],
                    ["只命中敌人"] = true,
                    ["允许重复命中"] = false,
                    ["命中后结束"] = false,
                    ["命中回调"] = function(source, hit)
                        _____64AD_653EBoss_5750_6807_97F3_6548(
                            _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["滴管穿心汲血"],
                            GetUnitX(hit),
                            GetUnitY(hit),
                            _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
                        )
                        local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(source, hit, {["来源攻击力比例"] = cfg["伤害攻击力比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"]})
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["来源"] = source,
                            ["目标"] = hit,
                            ["伤害"] = damage,
                            attack = false,
                            ranged = false,
                            attackType = ATTACK_TYPE_NORMAL,
                            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                            weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                            ["来源类型"] = "Boss技能",
                            ["标签"] = "夏提雅·滴管穿心"
                        })
                        local effect = AddSpecialEffect(
                            _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["滴管穿心命中特效路径"],
                            GetUnitX(hit),
                            GetUnitY(hit)
                        )
                        if effect ~= nil and effect ~= 0 then
                            addDelayedCallback(cfg["命中特效持续秒"] * 1000, _____9690_85CF_5E76_9500_6BC1_6EF4_7BA1_7A7F_5FC3_547D_4E2D_7279_6548, effect)
                        end
                        if GetHandleId(hit) == mainTargetId then
                            context["当前猎血目标"] = hit
                            context["当前猎血段数"] = 1
                            context["猎血段数过期时间Ms"] = getServerTime() + _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]["连击过期秒"] * 1000
                            _____5237_65B0_590F_63D0_96C5_730E_8840_8FDE_51FBBuff(context)
                        end
                    end,
                    ["开始回调"] = function()
                        _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["冲锋秒"], ["恢复动画编号"] = 0})
                    end,
                    ["结束回调"] = function(_source, reason)
                        if reason == "完成" or reason == "撞墙" then
                            _____5C1D_8BD5_5B89_6392_6EF4_7BA1_7A7F_5FC3_82F1_7075_590D_523B(context, targetX, targetY)
                        end
                    end
                },
                facing
            )
            debugLogForce(
                "夏提雅-滴管穿心",
                "本体冲锋启动",
                "chargeId=",
                chargeId,
                "facing=",
                facing,
                "distance=",
                distance
            )
            if chargeId == 0 then
                context["普通机制忙碌到Ms"] = getServerTime()
            end
        end
    )
    local ____self_7 = context["清理"]
    ____self_7["登记延迟回调"](____self_7, "夏提雅-滴管穿心预警", delayedId)
    return true
end
____exports["滴管穿心技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = true,
    ["语义"] = "锁定目标当前位置并沿预警路径突进；路径每个目标只结算一次，主目标命中后建立猎血第一段。"
}
return ____exports
