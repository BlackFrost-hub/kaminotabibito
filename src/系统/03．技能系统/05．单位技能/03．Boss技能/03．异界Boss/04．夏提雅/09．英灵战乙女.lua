local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local GetUnitX, GetUnitY, RemoveUnit, createTimedEffect, _____5206_8EAB_6B8B_5F71_8DEF_5F84
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_541F_5531_6761 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.19．吟唱条")
local _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761 = ____19_FF0E_541F_5531_6761["显示夏提雅常规吟唱条"]
____exports["清理英灵战乙女投影"] = function(context)
    local projection = context["英灵战乙女句柄"]
    context["英灵战乙女句柄"] = nil
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
    context["英灵战乙女已登场"] = false
end
local jass = require("jass.common")
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
RemoveUnit = jass.RemoveUnit
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAcquireRange = jass.SetUnitAcquireRange
local SetUnitPathing = jass.SetUnitPathing
local UnitAddAbility = jass.UnitAddAbility
local Atan2 = jass.Atan2
local CosBJ = jass.CosBJ
local SinBJ = jass.SinBJ
local GetRandomReal = jass.GetRandomReal
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedEffect = ____require_result_3.createTimedEffect
local _____8757_866B_6280_80FDID = 1097625443
_____5206_8EAB_6B8B_5F71_8DEF_5F84 = "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx"
--- 只创建表现投影；不创建 AI、普攻或任何伤害。
____exports["创建夏提雅英灵投影"] = function(context, x, y, face, duration)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return nil
    end
    ____exports["清理英灵战乙女投影"](context)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local projection = _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = boss,
        ["单位名称"] = "夏提雅·英灵投影",
        X = x,
        Y = y,
        ["朝向"] = face,
        ["持续时间"] = duration + cfg["英灵投影收束秒"],
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
    SetUnitAcquireRange(projection, 0)
    SetUnitPathing(projection, false)
    context["英灵战乙女句柄"] = projection
    createTimedEffect(
        _____5206_8EAB_6B8B_5F71_8DEF_5F84,
        x,
        y,
        0,
        cfg["英灵投影出现残影秒"]
    )
    return projection
end
____exports["获取夏提雅英灵投影"] = function(context)
    local _____5355_4F4D_6709_6548_result_4
    if _____5355_4F4D_6709_6548(context["英灵战乙女句柄"]) then
        _____5355_4F4D_6709_6548_result_4 = context["英灵战乙女句柄"]
    else
        _____5355_4F4D_6709_6548_result_4 = nil
    end
    return _____5355_4F4D_6709_6548_result_4
end
____exports["启动夏提雅英灵战乙女阶段"] = function(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["阶段"] ~= "P2英灵战乙女" then
        return false
    end
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "英灵战乙女")
    if _____5355_4F4D_6709_6548(context["英灵战乙女句柄"]) then
        context["英灵战乙女已登场"] = true
        return true
    end
    local facing = Atan2(
        GetUnitY(target) - GetUnitY(boss),
        GetUnitX(target) - GetUnitX(boss)
    ) * 57.29577951308232
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    SetUnitFacing(boss, facing)
    _____5F00_59CB_786C_76F4(boss, cfg["英灵登场演出秒"])
    _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761(cfg["英灵登场演出秒"], cfg["英灵登场吟唱条颜色ID"], cfg["英灵登场吟唱条标题文本"], cfg["英灵登场吟唱条提示文本"])
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["英灵登场动画编号"], ["持续秒"] = cfg["英灵登场演出秒"], ["恢复动画编号"] = 0})
    context["普通机制忙碌到Ms"] = getServerTime() + cfg["英灵登场演出秒"] * 1000
    local distance = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["英灵常驻距离"]
    local projection = ____exports["创建夏提雅英灵投影"](
        context,
        GetUnitX(target) + CosBJ(facing) * distance,
        GetUnitY(target) + SinBJ(facing) * distance,
        facing + 180,
        3600
    )
    context["英灵战乙女已登场"] = _____5355_4F4D_6709_6548(projection)
    return context["英灵战乙女已登场"]
end
--- 供公共调度器调用：投影只在延迟点执行传入的基础伤害结算，
-- 不复制控制、血印、吸血、装备和其他二次触发。
____exports["触发英灵战乙女复刻"] = function(context, _____53C2_6570)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local delay = _____53C2_6570["延迟秒"] or cfg["英灵复刻延迟最小秒"]
    local ____exports__83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71_result_5 = ____exports["获取夏提雅英灵投影"](context)
    if ____exports__83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71_result_5 == nil then
        ____exports__83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71_result_5 = ____exports["创建夏提雅英灵投影"](
            context,
            _____53C2_6570.X,
            _____53C2_6570.Y,
            _____53C2_6570["朝向"],
            3600
        )
    end
    local projection = ____exports__83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71_result_5
    if not _____5355_4F4D_6709_6548(projection) then
        return projection
    end
    SetUnitFacing(projection, _____53C2_6570["朝向"])
    local delayedId = addDelayedCallback(
        delay * 1000,
        function()
            _____64AD_653EBoss_5750_6807_97F3_6548(
                _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["英灵战乙女"],
                GetUnitX(context["Boss单位"]),
                GetUnitY(context["Boss单位"]),
                _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
            )
            if context["英灵战乙女句柄"] ~= projection or not _____5355_4F4D_6709_6548(projection) then
                return
            end
            SetUnitAnimation(projection, "attack")
            if _____53C2_6570["复刻结算"] ~= nil then
                _____53C2_6570["复刻结算"]()
            end
        end
    )
    local ____self_6 = context["清理"]
    ____self_6["登记延迟回调"](____self_6, "夏提雅-英灵战乙女复刻", delayedId)
    return projection
end
____exports["尝试触发英灵战乙女复刻"] = function(context, skillKey, _____53C2_6570)
    if context["阶段"] ~= "P2英灵战乙女" or context["挑战已结束"] or not _____5355_4F4D_6709_6548(context["英灵战乙女句柄"]) then
        return false
    end
    local now = getServerTime()
    if now < context["英灵复刻冷却到Ms"] or context["上次英灵复刻技能"] == skillKey then
        return false
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    context["英灵复刻冷却到Ms"] = now + cfg["英灵复刻内部冷却秒"] * 1000
    context["上次英灵复刻技能"] = skillKey
    ____exports["触发英灵战乙女复刻"](
        context,
        __TS__ObjectAssign(
            {},
            _____53C2_6570,
            {["延迟秒"] = _____53C2_6570["延迟秒"] or GetRandomReal(cfg["英灵复刻延迟最小秒"], cfg["英灵复刻延迟最大秒"])}
        )
    )
    return true
end
____exports["英灵战乙女机制状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "P2固定延迟镜像",
    ["语义"] = "英灵使用夏提雅女武神模型作为半透明投影；没有独立AI和普通攻击，只在公共调度指定时延迟复刻基础伤害。"
}
return ____exports
