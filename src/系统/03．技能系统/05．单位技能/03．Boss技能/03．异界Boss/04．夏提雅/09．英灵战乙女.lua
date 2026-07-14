--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____64AD_653E_9650_65F6_70B9_7279_6548, GetUnitX, GetUnitY, IsUnitType, RemoveUnit, AddSpecialEffect, DestroyEffect, UNIT_TYPE_DEAD, addDelayedCallback, _____5206_8EAB_6B8B_5F71_8DEF_5F84
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____64AD_653E_9650_65F6_70B9_7279_6548(model, x, y, duration)
    local effect = AddSpecialEffect(model, x, y)
    addDelayedCallback(
        duration * 1000,
        function()
            DestroyEffect(effect)
        end
    )
end
____exports["清理英灵战乙女投影"] = function(context)
    local projection = context["英灵战乙女句柄"]
    context["英灵战乙女句柄"] = nil
    if _____5355_4F4D_6709_6548(projection) then
        _____64AD_653E_9650_65F6_70B9_7279_6548(
            _____5206_8EAB_6B8B_5F71_8DEF_5F84,
            GetUnitX(projection),
            GetUnitY(projection),
            _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["英灵投影收束秒"]
        )
        RemoveUnit(projection)
    end
end
local jass = require("jass.common")
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
IsUnitType = jass.IsUnitType
RemoveUnit = jass.RemoveUnit
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAcquireRange = jass.SetUnitAcquireRange
local SetUnitPathing = jass.SetUnitPathing
local UnitAddAbility = jass.UnitAddAbility
AddSpecialEffect = jass.AddSpecialEffect
DestroyEffect = jass.DestroyEffect
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_1.addDelayedCallback
local _____8757_866B_6280_80FDID = 1097625443
_____5206_8EAB_6B8B_5F71_8DEF_5F84 = "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx"
local function _____79FB_9664_6307_5B9A_82F1_7075_6295_5F71(context, projection)
    if context["英灵战乙女句柄"] == projection then
        context["英灵战乙女句柄"] = nil
    end
    if _____5355_4F4D_6709_6548(projection) then
        _____64AD_653E_9650_65F6_70B9_7279_6548(
            _____5206_8EAB_6B8B_5F71_8DEF_5F84,
            GetUnitX(projection),
            GetUnitY(projection),
            _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["英灵投影收束秒"]
        )
        RemoveUnit(projection)
    end
end
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
    _____64AD_653E_9650_65F6_70B9_7279_6548(_____5206_8EAB_6B8B_5F71_8DEF_5F84, x, y, cfg["英灵投影出现残影秒"])
    return projection
end
--- 供公共调度器调用：投影只在延迟点执行传入的基础伤害结算，
-- 不复制控制、血印、吸血、装备和其他二次触发。
____exports["触发英灵战乙女复刻"] = function(context, _____53C2_6570)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local delay = _____53C2_6570["延迟秒"] or cfg["英灵复刻延迟最小秒"]
    local duration = _____53C2_6570["投影持续秒"] or delay + 0.8
    local projection = ____exports["创建夏提雅英灵投影"](
        context,
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____53C2_6570["朝向"],
        duration
    )
    if not _____5355_4F4D_6709_6548(projection) then
        return projection
    end
    SetUnitAnimation(projection, "attack")
    addDelayedCallback(
        delay * 1000,
        function()
            if context["英灵战乙女句柄"] ~= projection or not _____5355_4F4D_6709_6548(projection) then
                return
            end
            if _____53C2_6570["复刻结算"] ~= nil then
                _____53C2_6570["复刻结算"]()
            end
        end
    )
    addDelayedCallback(
        duration * 1000,
        function()
            _____79FB_9664_6307_5B9A_82F1_7075_6295_5F71(context, projection)
        end
    )
    return projection
end
____exports["英灵战乙女机制状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = false,
    ["类型"] = "P2固定延迟镜像",
    ["语义"] = "英灵使用夏提雅女武神模型作为半透明投影；没有独立AI和普通攻击，只在公共调度指定时延迟复刻基础伤害。"
}
return ____exports
