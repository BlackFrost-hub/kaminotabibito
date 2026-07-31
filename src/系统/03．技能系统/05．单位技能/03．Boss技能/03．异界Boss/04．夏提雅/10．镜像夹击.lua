--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local GetUnitX, GetUnitY, RemoveUnit, createTimedEffect, _____5206_8EAB_6B8B_5F71_8DEF_5F84
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____09_FF0E_82F1_7075_6218_4E59_5973 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.09．英灵战乙女")
local _____6E05_7406_82F1_7075_6218_4E59_5973_6295_5F71 = ____09_FF0E_82F1_7075_6218_4E59_5973["清理英灵战乙女投影"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51B2_950B = _____51FB_9000_7CFB_7EDF["开始冲锋"]
local _____505C_6B62_5355_4F4D_4F4D_79FB = _____51FB_9000_7CFB_7EDF["停止单位位移"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.01．多阶段技能编排.06．技能阶段链执行器")
local _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建立即执行阶段"]
local _____521B_5EFA_5EF6_8FDF_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建延迟阶段"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____19_FF0E_541F_5531_6761 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.19．吟唱条")
local _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761 = ____19_FF0E_541F_5531_6761["显示夏提雅常规吟唱条"]
____exports["清理镜像夹击投影"] = function(context)
    local projection = context["镜像夹击句柄"]
    context["镜像夹击句柄"] = nil
    if _____5355_4F4D_6709_6548(projection) then
        createTimedEffect(
            _____5206_8EAB_6B8B_5F71_8DEF_5F84,
            GetUnitX(projection),
            GetUnitY(projection),
            0,
            _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["英灵投影收束秒"]
        )
        RemoveUnit(projection)
    end
end
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_0.CosBJ
local SinBJ = ____require_result_0.SinBJ
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
RemoveUnit = jass.RemoveUnit
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAcquireRange = jass.SetUnitAcquireRange
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitPathing = jass.SetUnitPathing
local UnitAddAbility = jass.UnitAddAbility
local UnitAddType = jass.UnitAddType
local ConvertUnitState = jass.ConvertUnitState
local IssueImmediateOrder = jass.IssueImmediateOrder
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local GetHandleId = jass.GetHandleId
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local UNIT_TYPE_TAUREN = jass.UNIT_TYPE_TAUREN
local SetUnitStateJapi = japi.SetUnitState
local DzUnitDisableAttack = japi.DzUnitDisableAttack
local _____653B_51FB_8303_56F4_72B6_6001 = 22
local _____653B_51FB_95F4_9694_72B6_6001 = 37
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_1["创建召唤物"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedEffect = ____require_result_3.createTimedEffect
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_4["创建技能提示圈"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_5["造成AOE技能伤害"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_6["施加快速减速Buff"]
local _____8757_866B_6280_80FDID = 1097625443
_____5206_8EAB_6B8B_5F71_8DEF_5F84 = "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx"
local RAD_TO_DEG = 57.29577951308232
local _____955C_50CF_5939_51FB_6280_80FDKey = "镜像夹击"
local function _____521B_5EFA_955C_50CF_5939_51FB_6295_5F71(context, x, y, face)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return nil
    end
    ____exports["清理镜像夹击投影"](context)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local projection = _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = boss,
        ["单位名称"] = "夏提雅·镜像投影",
        X = x,
        Y = y,
        ["朝向"] = face,
        ["持续时间"] = cfg["镜像夹击第二段延迟秒"] + cfg["镜像夹击投影突进秒"] + cfg["英灵投影收束秒"],
        ["模型文件"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["英灵战乙女模型路径"],
        ["缩放"] = cfg["英灵投影缩放"],
        ["透明度"] = cfg["英灵投影透明度"],
        ["红"] = cfg["英灵投影红"],
        ["绿"] = cfg["英灵投影绿"],
        ["蓝"] = cfg["英灵投影蓝"],
        ["索敌范围"] = 0
    })
    if not _____5355_4F4D_6709_6548(projection) then
        return projection
    end
    UnitAddAbility(projection, _____8757_866B_6280_80FDID)
    UnitAddType(projection, UNIT_TYPE_TAUREN)
    SetUnitAcquireRange(projection, 0)
    SetUnitStateJapi(
        projection,
        ConvertUnitState(_____653B_51FB_8303_56F4_72B6_6001),
        0
    )
    SetUnitStateJapi(
        projection,
        ConvertUnitState(_____653B_51FB_95F4_9694_72B6_6001),
        99
    )
    if DzUnitDisableAttack ~= nil then
        DzUnitDisableAttack(projection, true)
    end
    IssueImmediateOrder(projection, "stop")
    SetUnitPathing(projection, false)
    SetUnitFacing(projection, face)
    context["镜像夹击句柄"] = projection
    createTimedEffect(
        _____5206_8EAB_6B8B_5F71_8DEF_5F84,
        x,
        y,
        0,
        cfg["英灵投影出现残影秒"]
    )
    return projection
end
--- 本体移动由公共调度器负责；这里创建对侧投影并启动本体结算。
-- 调用者必须在两个结算回调中自行排除控制、血印、吸血和其他二次触发。
____exports["施放镜像夹击"] = function(context, _____53C2_6570)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return nil
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local directionX = CosBJ(_____53C2_6570["本体朝向"])
    local directionY = SinBJ(_____53C2_6570["本体朝向"])
    local startX = _____53C2_6570["中心X"] + directionX * cfg["镜像夹击投影距离"]
    local startY = _____53C2_6570["中心Y"] + directionY * cfg["镜像夹击投影距离"]
    local projection = _____521B_5EFA_955C_50CF_5939_51FB_6295_5F71(context, startX, startY, _____53C2_6570["本体朝向"] + 180)
    if not _____5355_4F4D_6709_6548(projection) then
        return projection
    end
    if _____53C2_6570["本体结算"] ~= nil then
        _____53C2_6570["本体结算"]()
    end
    return projection
end
local function _____542F_52A8_955C_50CF_5939_51FB_6295_5F71_51B2_950B(context, projection, endX, endY, _____53C2_6570)
    if context["镜像夹击句柄"] ~= projection or not _____5355_4F4D_6709_6548(projection) then
        return
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local startX = GetUnitX(projection)
    local startY = GetUnitY(projection)
    local chargeDistance = SquareRoot((endX - startX) * (endX - startX) + (endY - startY) * (endY - startY))
    _____5F00_59CB_51B2_950B(
        projection,
        {
            ["目标X"] = endX,
            ["目标Y"] = endY,
            ["距离"] = chargeDistance,
            ["持续时间"] = cfg["镜像夹击投影突进秒"],
            ["检查地形"] = true,
            ["暂停单位"] = false,
            ["禁用碰撞"] = true,
            ["位移特效"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["滴管长枪拖尾特效路径"],
            ["命中半径"] = cfg["镜像夹击路径宽度"] * 0.5,
            ["只命中敌人"] = true,
            ["允许重复命中"] = false,
            ["命中后结束"] = false,
            ["命中回调"] = function(_source, hit)
                if _____53C2_6570["投影命中"] ~= nil then
                    _____53C2_6570["投影命中"](hit)
                end
            end,
            ["开始回调"] = function()
                _____5F00_59CB_786C_76F4(projection, cfg["镜像夹击投影突进秒"])
                SetUnitAnimationByIndex(projection, cfg["英灵复刻冲锋动画编号"])
            end,
            ["结束回调"] = function()
                if _____53C2_6570["投影结算"] ~= nil then
                    _____53C2_6570["投影结算"]()
                end
            end
        }
    )
end
local function _____9020_6210_955C_50CF_5939_51FB_4F24_5BB3(context, target, ratio, tag)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(context["Boss单位"], target, {["来源攻击力比例"] = cfg["镜像夹击本体伤害攻击力比例"] * ratio, ["目标最大生命比例"] = cfg["镜像夹击本体伤害目标最大生命比例"] * ratio})
    _____9020_6210AOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["Boss单位"],
        ["目标"] = target,
        ["伤害"] = damage,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "Boss技能",
        ["标签"] = tag
    })
end
local function _____7ED3_675F_955C_50CF_5939_51FB(context, _____6267_884CID)
    if _____6267_884CID ~= nil and _____6267_884CID ~= 0 and context["镜像夹击执行ID"] ~= _____6267_884CID then
        return
    end
    _____505C_6B62_5355_4F4D_4F4D_79FB(context["Boss单位"], "中断")
    _____505C_6B62_5355_4F4D_4F4D_79FB(context["镜像夹击句柄"], "中断")
    ____exports["清理镜像夹击投影"](context)
    if context["当前大型技能"] == _____955C_50CF_5939_51FB_6280_80FDKey then
        context["当前大型技能"] = nil
    end
    context["镜像夹击执行器"] = nil
    context["镜像夹击执行ID"] = 0
end
____exports["释放夏提雅镜像夹击"] = function(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["挑战已结束"] or context["阶段"] ~= "P2英灵战乙女" or context["当前大型技能"] ~= nil then
        return false
    end
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "镜像夹击")
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    local centerX = GetUnitX(target)
    local centerY = GetUnitY(target)
    local dx = centerX - bossX
    local dy = centerY - bossY
    local rawDistance = SquareRoot(dx * dx + dy * dy)
    if not (rawDistance > 1) or rawDistance > cfg["镜像夹击本体最大距离"] then
        return false
    end
    local facing = Atan2(dy, dx) * RAD_TO_DEG
    SetUnitFacing(boss, facing)
    local directionX = CosBJ(facing)
    local directionY = SinBJ(facing)
    local bodyEndX = centerX + directionX * cfg["镜像夹击投影越过距离"]
    local bodyEndY = centerY + directionY * cfg["镜像夹击投影越过距离"]
    local bodyDistance = rawDistance + cfg["镜像夹击投影越过距离"]
    local mirrorStartX = centerX + directionX * cfg["镜像夹击投影距离"]
    local mirrorStartY = centerY + directionY * cfg["镜像夹击投影距离"]
    local mirrorEndX = centerX - directionX * cfg["镜像夹击投影越过距离"]
    local mirrorEndY = centerY - directionY * cfg["镜像夹击投影越过距离"]
    local mirrorDistance = cfg["镜像夹击投影距离"] + cfg["镜像夹击投影越过距离"]
    local totalSeconds = cfg["镜像夹击预警秒"] + cfg["镜像夹击第二段延迟秒"] + cfg["镜像夹击投影突进秒"] + cfg["镜像夹击恢复窗口秒"]
    local mainTargetId = GetHandleId(target)
    local previousExecutor = context["镜像夹击执行器"]
    if previousExecutor ~= nil and previousExecutor["是否运行中"](previousExecutor) then
        previousExecutor["停止"](previousExecutor, nil, "中断")
    end
    context["镜像夹击执行器"] = nil
    context["镜像夹击执行ID"] = 0
    local projection = nil
    local executor = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "夏提雅-镜像夹击", ["清理"] = context["清理"], ["互斥组"] = "夏提雅大型技能"})
    context["当前大型技能"] = _____955C_50CF_5939_51FB_6280_80FDKey
    context["普通机制忙碌到Ms"] = getServerTime() + totalSeconds * 1000
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
    context["镜像夹击执行器"] = executor
    local executionId = 0
    executionId = executor["开始"](
        executor,
        {
            key = _____955C_50CF_5939_51FB_6280_80FDKey,
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = (totalSeconds + 1) * 1000,
            ["阶段列表"] = {
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        _____5F00_59CB_786C_76F4(boss, cfg["镜像夹击预警秒"])
                        _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761(cfg["镜像夹击预警秒"], cfg["镜像夹击吟唱条颜色ID"], cfg["镜像夹击吟唱条标题文本"], cfg["镜像夹击吟唱条提示文本"])
                        _____6E05_7406_82F1_7075_6218_4E59_5973_6295_5F71(context)
                        _____521B_5EFA_6280_80FD_63D0_793A_5708({
                            ["类型"] = "方向直线",
                            X = bossX,
                            Y = bossY,
                            ["宽度"] = cfg["镜像夹击路径宽度"],
                            ["长度"] = bodyDistance,
                            ["朝向"] = facing,
                            ["持续时间"] = cfg["镜像夹击预警秒"],
                            ["来源单位"] = boss
                        })
                        _____521B_5EFA_6280_80FD_63D0_793A_5708({
                            ["类型"] = "方向直线",
                            X = mirrorStartX,
                            Y = mirrorStartY,
                            ["宽度"] = cfg["镜像夹击路径宽度"],
                            ["长度"] = mirrorDistance,
                            ["朝向"] = facing + 180,
                            ["持续时间"] = cfg["镜像夹击预警秒"] + cfg["镜像夹击第二段延迟秒"],
                            ["来源单位"] = boss
                        })
                    end,
                    "双路径预警"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["镜像夹击预警秒"] * 1000, "镜像夹击预警"),
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        if context["当前大型技能"] ~= _____955C_50CF_5939_51FB_6280_80FDKey or context["阶段"] ~= "P2英灵战乙女" then
                            return
                        end
                        projection = ____exports["施放镜像夹击"](
                            context,
                            {
                                ["中心X"] = centerX,
                                ["中心Y"] = centerY,
                                ["本体朝向"] = facing,
                                ["本体结算"] = function()
                                    _____5F00_59CB_51B2_950B(
                                        boss,
                                        {
                                            ["目标X"] = bodyEndX,
                                            ["目标Y"] = bodyEndY,
                                            ["距离"] = bodyDistance,
                                            ["持续时间"] = cfg["镜像夹击投影突进秒"],
                                            ["检查地形"] = true,
                                            ["暂停单位"] = true,
                                            ["禁用碰撞"] = true,
                                            ["位移特效"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["滴管长枪拖尾特效路径"],
                                            ["命中半径"] = cfg["镜像夹击路径宽度"] * 0.5,
                                            ["只命中敌人"] = true,
                                            ["允许重复命中"] = false,
                                            ["命中后结束"] = false,
                                            ["命中回调"] = function(_source, hit)
                                                _____9020_6210_955C_50CF_5939_51FB_4F24_5BB3(context, hit, 1, "夏提雅·镜像夹击-本体")
                                                if GetHandleId(hit) == mainTargetId then
                                                    context["当前猎血目标"] = hit
                                                    context["当前猎血段数"] = 1
                                                    context["猎血段数过期时间Ms"] = getServerTime() + _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]["连击过期秒"] * 1000
                                                end
                                            end,
                                            ["开始回调"] = function()
                                                SetUnitAnimationByIndex(boss, cfg["镜像夹击本体动画编号"])
                                            end
                                        }
                                    )
                                end
                            }
                        )
                    end,
                    "本体冲锋与投影排队"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["镜像夹击第二段延迟秒"] * 1000, "英灵冲锋等待"),
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        if context["当前大型技能"] ~= _____955C_50CF_5939_51FB_6280_80FDKey or context["阶段"] ~= "P2英灵战乙女" then
                            return
                        end
                        _____542F_52A8_955C_50CF_5939_51FB_6295_5F71_51B2_950B(
                            context,
                            projection,
                            mirrorEndX,
                            mirrorEndY,
                            {
                                ["中心X"] = centerX,
                                ["中心Y"] = centerY,
                                ["本体朝向"] = facing,
                                ["投影命中"] = function(hit)
                                    _____9020_6210_955C_50CF_5939_51FB_4F24_5BB3(context, hit, cfg["镜像夹击投影伤害比例"], "夏提雅·镜像夹击-英灵")
                                    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                                        boss,
                                        hit,
                                        0,
                                        cfg["镜像夹击减速比例"],
                                        cfg["镜像夹击减速秒"]
                                    )
                                end
                            }
                        )
                    end,
                    "英灵冲锋"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5((cfg["镜像夹击投影突进秒"] + cfg["镜像夹击恢复窗口秒"]) * 1000, "英灵冲锋与恢复窗口")
            },
            ["结束回调"] = function()
                _____7ED3_675F_955C_50CF_5939_51FB(context, executionId)
            end
        }
    )
    context["镜像夹击执行ID"] = executionId
    if executionId == 0 then
        _____7ED3_675F_955C_50CF_5939_51FB(context)
        return false
    end
    return true
end
____exports["镜像夹击技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = true,
    ["语义"] = "固定组合时间轴同时预警两条交叉路径，本体先冲锋，女武神投影延迟1.1秒后从对侧穿过目标；投影只结算基础伤害与短暂减速。"
}
return ____exports
