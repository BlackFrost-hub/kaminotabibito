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
____exports["清理镜像夹击投影"] = function(context)
    local projection = context["镜像夹击句柄"]
    context["镜像夹击句柄"] = nil
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
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPathing = jass.SetUnitPathing
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local UnitAddAbility = jass.UnitAddAbility
AddSpecialEffect = jass.AddSpecialEffect
DestroyEffect = jass.DestroyEffect
local CosBJ = jass.CosBJ
local SinBJ = jass.SinBJ
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local _____8757_866B_6280_80FDID = 1097625443
_____5206_8EAB_6B8B_5F71_8DEF_5F84 = "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx"
local _____6295_5F71_79FB_52A8_95F4_9694_6BEB_79D2 = 30
local function _____6E05_7406_6307_5B9A_955C_50CF_6295_5F71(context, projection)
    if context["镜像夹击句柄"] == projection then
        context["镜像夹击句柄"] = nil
    end
    if not _____5355_4F4D_6709_6548(projection) then
        return
    end
    _____64AD_653E_9650_65F6_70B9_7279_6548(
        _____5206_8EAB_6B8B_5F71_8DEF_5F84,
        GetUnitX(projection),
        GetUnitY(projection),
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["英灵投影收束秒"]
    )
    RemoveUnit(projection)
end
local function _____63A8_8FDB_955C_50CF_6295_5F71(data)
    if data.context["镜像夹击句柄"] ~= data.projection or not _____5355_4F4D_6709_6548(data.projection) then
        removePeriodicCallback(data["周期ID"])
        return
    end
    data["当前步数"] = data["当前步数"] + 1
    local progress = data["当前步数"] / data["总步数"]
    SetUnitX(data.projection, data["起点X"] + (data["终点X"] - data["起点X"]) * progress)
    SetUnitY(data.projection, data["起点Y"] + (data["终点Y"] - data["起点Y"]) * progress)
    if data["当前步数"] >= data["总步数"] then
        removePeriodicCallback(data["周期ID"])
    end
end
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
    SetUnitAcquireRange(projection, 0)
    SetUnitPathing(projection, false)
    SetUnitFacing(projection, face)
    context["镜像夹击句柄"] = projection
    _____64AD_653E_9650_65F6_70B9_7279_6548(_____5206_8EAB_6B8B_5F71_8DEF_5F84, x, y, cfg["英灵投影出现残影秒"])
    return projection
end
--- 本体移动由公共调度器负责；这里负责对侧投影、攻击动画与第二段基础伤害窗口。
-- 调用者必须在两个结算回调中自行排除控制、血印、吸血和其他二次触发。
____exports["施放镜像夹击"] = function(context, _____53C2_6570)
    local cleanUp, projection
    function cleanUp()
        _____6E05_7406_6307_5B9A_955C_50CF_6295_5F71(context, projection)
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return nil
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local directionX = CosBJ(_____53C2_6570["本体朝向"])
    local directionY = SinBJ(_____53C2_6570["本体朝向"])
    local startX = _____53C2_6570["中心X"] + directionX * cfg["镜像夹击投影距离"]
    local startY = _____53C2_6570["中心Y"] + directionY * cfg["镜像夹击投影距离"]
    local endX = _____53C2_6570["中心X"] - directionX * cfg["镜像夹击投影越过距离"]
    local endY = _____53C2_6570["中心Y"] - directionY * cfg["镜像夹击投影越过距离"]
    projection = _____521B_5EFA_955C_50CF_5939_51FB_6295_5F71(context, startX, startY, _____53C2_6570["本体朝向"] + 180)
    if not _____5355_4F4D_6709_6548(projection) then
        return projection
    end
    SetUnitAnimation(boss, "attack")
    SetUnitAnimation(projection, "attack")
    if _____53C2_6570["本体结算"] ~= nil then
        _____53C2_6570["本体结算"]()
    end
    local data = {
        context = context,
        projection = projection,
        ["起点X"] = startX,
        ["起点Y"] = startY,
        ["终点X"] = endX,
        ["终点Y"] = endY,
        ["总步数"] = math.max(
            1,
            math.ceil(cfg["镜像夹击投影突进秒"] * 1000 / _____6295_5F71_79FB_52A8_95F4_9694_6BEB_79D2)
        ),
        ["当前步数"] = 0,
        ["周期ID"] = 0
    }
    local _____7A81_8FDB_8D77_6B65_7B49_5F85_6BEB_79D2 = math.max(0, (cfg["镜像夹击第二段延迟秒"] - cfg["镜像夹击投影突进秒"]) * 1000)
    addDelayedCallback(
        _____7A81_8FDB_8D77_6B65_7B49_5F85_6BEB_79D2,
        function()
            if context["镜像夹击句柄"] ~= projection or not _____5355_4F4D_6709_6548(projection) then
                return
            end
            data["周期ID"] = addPeriodicCallback(
                _____6295_5F71_79FB_52A8_95F4_9694_6BEB_79D2,
                function()
                    _____63A8_8FDB_955C_50CF_6295_5F71(data)
                end
            )
        end
    )
    addDelayedCallback(
        cfg["镜像夹击第二段延迟秒"] * 1000,
        function()
            if context["镜像夹击句柄"] ~= projection or not _____5355_4F4D_6709_6548(projection) then
                return
            end
            if _____53C2_6570["投影结算"] ~= nil then
                _____53C2_6570["投影结算"]()
            end
        end
    )
    addDelayedCallback(
        (cfg["镜像夹击第二段延迟秒"] + cfg["英灵投影收束秒"]) * 1000,
        function()
            cleanUp()
        end
    )
    return projection
end
____exports["镜像夹击技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = false,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = true,
    ["语义"] = "本体由公共调度器突进，夏提雅女武神投影从对侧穿过目标并延迟结算；两段只结算基础伤害。"
}
return ____exports
