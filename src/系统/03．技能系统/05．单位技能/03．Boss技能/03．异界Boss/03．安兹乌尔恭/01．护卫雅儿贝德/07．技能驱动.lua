--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____02_FF0E_9ED1_7FFC_6A2A_626B = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.02．黑翼横扫")
local _____91CA_653E_96C5_513F_8D1D_5FB7_9ED1_7FFC_6A2A_626B = ____02_FF0E_9ED1_7FFC_6A2A_626B["释放雅儿贝德黑翼横扫"]
local ____03_FF0E_5B88_62A4_8005_4E4B_804C_8D23 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.03．守护者之职责")
local _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23 = ____03_FF0E_5B88_62A4_8005_4E4B_804C_8D23["释放雅儿贝德守护者之职责"]
local ____08_FF0E_5B88_62A4_56DE_5F52 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.08．守护回归")
local _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_56DE_5F52 = ____08_FF0E_5B88_62A4_56DE_5F52["释放雅儿贝德守护回归"]
local ____09_FF0E_62A4_536B_53CD_51FB = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.09．护卫反击")
local _____91CA_653E_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB = ____09_FF0E_62A4_536B_53CD_51FB["释放雅儿贝德护卫反击"]
local ____10_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.10．台词播放")
local _____64AD_653E_96C5_513F_8D1D_5FB7_53F0_8BCD = ____10_FF0E_53F0_8BCD_64AD_653E["播放雅儿贝德台词"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4 = ____require_result_0["获取Boss技能最近敌对英雄"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.04．Boss自动施法开关")
local ____Boss_81EA_52A8_65BD_6CD5_662F_5426_5F00_542F = ____require_result_2["Boss自动施法是否开启"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
____exports["推进雅儿贝德技能驱动"] = function(context)
    if not ____Boss_81EA_52A8_65BD_6CD5_662F_5426_5F00_542F() then
        return
    end
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return
    end
    if state["阶段状态"] == "失衡" or state["阶段状态"] == "已离场" then
        return
    end
    local ____opt_5 = state["独占状态"]
    local active = ____opt_5 and ____opt_5["取当前"](____opt_5)
    if active ~= nil and active.key ~= "雅儿贝德-守护者之职责" then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local guardDx = GetUnitX(albedo) - GetUnitX(context["安兹单位"])
    local guardDy = GetUnitY(albedo) - GetUnitY(context["安兹单位"])
    if guardDx * guardDx + guardDy * guardDy > cfg["守护回归触发距离"] * cfg["守护回归触发距离"] then
        if _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_56DE_5F52(context) then
            _____64AD_653E_96C5_513F_8D1D_5FB7_53F0_8BCD(albedo, "守护回归")
            return
        end
    end
    local cooldown = cfg["黑翼横扫冷却秒"] * (state["阶段状态"] == "狂怒护卫" and cfg["黑翼横扫狂怒冷却倍率"] or 1) * 1000
    local now = getServerTime()
    if now < state["上次普通技能Ms"] + cooldown then
        if active == nil and _____91CA_653E_96C5_513F_8D1D_5FB7_62A4_536B_53CD_51FB(context) then
            _____64AD_653E_96C5_513F_8D1D_5FB7_53F0_8BCD(albedo, "护卫反击")
        elseif active == nil and _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23(context) then
            _____64AD_653E_96C5_513F_8D1D_5FB7_53F0_8BCD(albedo, "守护者之职责")
        end
        return
    end
    local target = _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4(context["安兹单位"])
    if not _____5355_4F4D_6709_6548(target) then
        if active == nil then
            _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23(context)
        end
        return
    end
    local dx = GetUnitX(target) - GetUnitX(albedo)
    local dy = GetUnitY(target) - GetUnitY(albedo)
    if dx * dx + dy * dy <= cfg["黑翼横扫半径"] * cfg["黑翼横扫半径"] then
        if _____91CA_653E_96C5_513F_8D1D_5FB7_9ED1_7FFC_6A2A_626B(context, target) then
            _____64AD_653E_96C5_513F_8D1D_5FB7_53F0_8BCD(albedo, "黑翼横扫")
        end
    elseif active == nil then
        if _____91CA_653E_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23(context) then
            _____64AD_653E_96C5_513F_8D1D_5FB7_53F0_8BCD(albedo, "守护者之职责")
        end
    end
end
____exports["雅儿贝德技能驱动状态"] = {["已完成设计"] = true, ["已完成实现"] = true, ["已注册"] = true, ["语义"] = "根据安兹阶段、雅儿贝德生命、双方距离和共享大型技能锁选择护卫动作。"}
return ____exports
