--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹模型动画配置"]
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____08_FF0E_9AD8_9636_4EA1_7075_53EC_5524 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.08．高阶亡灵召唤")
local _____53D6_5B89_5179_4EA1_7075_7BAD_4F24_5BB3_500D_7387 = ____08_FF0E_9AD8_9636_4EA1_7075_53EC_5524["取安兹亡灵箭伤害倍率"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.01．多阶段技能编排.06．技能阶段链执行器")
local _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建立即执行阶段"]
local _____521B_5EFA_5EF6_8FDF_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建延迟阶段"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["点到线段距离平方"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____require_result_0["计算组合技能伤害"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_5["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_5["关闭吟唱条"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C = ____require_result_6["设置特效XYZ轴旋转"]
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_7.getServerTime
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local EXSetEffectSize = japi.EXSetEffectSize
local RAD_TO_DEG = 57.29577951308232
local _____65F6_95F4_505C_6B62_5927_578B_6280_80FDKey = "时间停止"
local _____65F6_95F4_505C_6B62_6682_505C_6765_6E90 = "安兹-时间停止"
local function _____53D6_65F6_95F4_505C_6B62_603B_65F6_957F_79D2()
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    return cfg["时间停止预展示秒"] + cfg["时间停止冻结秒"] + cfg["时间停止结算间隔秒"] * 2 + cfg["时间停止收尾秒"]
end
local function _____521B_5EFA_65F6_95F4_505C_6B62_9501_5B9A(context)
    local boss = context["安兹单位"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    if #heroes <= 0 then
        return nil
    end
    local start = GetRandomInt(0, #heroes - 1)
    local groundTarget = heroes[start + 1]
    local arrowTarget = heroes[(start + 1) % #heroes + 1]
    local lineTarget = heroes[(start + 2) % #heroes + 1]
    if not _____5355_4F4D_6709_6548(groundTarget) or not _____5355_4F4D_6709_6548(arrowTarget) or not _____5355_4F4D_6709_6548(lineTarget) then
        return nil
    end
    local ordinary = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["普通技能"]
    local originX = GetUnitX(boss)
    local originY = GetUnitY(boss)
    local angleRadians = Atan2(
        GetUnitY(lineTarget) - originY,
        GetUnitX(lineTarget) - originX
    )
    return {
        ["地面法阵X"] = GetUnitX(groundTarget),
        ["地面法阵Y"] = GetUnitY(groundTarget),
        ["魔法箭X"] = GetUnitX(arrowTarget),
        ["魔法箭Y"] = GetUnitY(arrowTarget),
        ["裂缝起点X"] = originX,
        ["裂缝起点Y"] = originY,
        ["裂缝终点X"] = originX + Cos(angleRadians) * ordinary["现实断裂路径长度"],
        ["裂缝终点Y"] = originY + Sin(angleRadians) * ordinary["现实断裂路径长度"],
        ["裂缝角度"] = angleRadians * RAD_TO_DEG
    }
end
local function _____521B_5EFA_65F6_95F4_505C_6B62_9884_8B66(instance)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local stage = cfg["阶段技能"]
    local ordinary = cfg["普通技能"]
    local locked = instance["锁定"]
    local groundDuration = stage["时间停止预展示秒"] + stage["时间停止冻结秒"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = locked["地面法阵X"],
        Y = locked["地面法阵Y"],
        ["半径"] = stage["时间停止地面法阵半径"],
        ["持续时间"] = groundDuration,
        ["来源单位"] = instance.context["安兹单位"]
    })
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = (locked["裂缝起点X"] + locked["裂缝终点X"]) * 0.5,
        Y = (locked["裂缝起点Y"] + locked["裂缝终点Y"]) * 0.5,
        ["宽度"] = ordinary["现实断裂路径宽度"],
        ["长度"] = ordinary["现实断裂路径长度"],
        ["朝向"] = locked["裂缝角度"],
        ["持续时间"] = groundDuration + stage["时间停止结算间隔秒"],
        ["来源单位"] = instance.context["安兹单位"]
    })
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = locked["魔法箭X"],
        Y = locked["魔法箭Y"],
        ["半径"] = ordinary["高阶魔法箭伤害半径"],
        ["持续时间"] = groundDuration + stage["时间停止结算间隔秒"] * 2,
        ["来源单位"] = instance.context["安兹单位"]
    })
end
local function _____521B_5EFA_65F6_95F4_505C_6B62_6301_7EED_8868_73B0(instance)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local boss = instance.context["安兹单位"]
    local clock = AddSpecialEffectTarget(cfg["表现资源"]["时间停止钟面特效路径"], boss, "origin")
    local gear = AddSpecialEffectTarget(cfg["表现资源"]["时间停止齿轮特效路径"], boss, "origin")
    if clock ~= nil and clock ~= 0 then
        EXSetEffectSize(clock, cfg["阶段技能"]["时间停止钟面缩放"])
        local ____instance__6301_7EED_7279_6548_5217_8868_8 = instance["持续特效列表"]
        ____instance__6301_7EED_7279_6548_5217_8868_8[#____instance__6301_7EED_7279_6548_5217_8868_8 + 1] = clock
    end
    if gear ~= nil and gear ~= 0 then
        EXSetEffectSize(gear, cfg["阶段技能"]["时间停止齿轮缩放"])
        local ____instance__6301_7EED_7279_6548_5217_8868_9 = instance["持续特效列表"]
        ____instance__6301_7EED_7279_6548_5217_8868_9[#____instance__6301_7EED_7279_6548_5217_8868_9 + 1] = gear
    end
end
local function _____51BB_7ED3_65F6_95F4_505C_6B62_73A9_5BB6(instance)
    local ____instance_context__6311_6218_5DF2_7ED3_675F_11 = instance.context["挑战已结束"]
    if not ____instance_context__6311_6218_5DF2_7ED3_675F_11 then
        local ____self_10 = instance.context["清理"]
        ____instance_context__6311_6218_5DF2_7ED3_675F_11 = ____self_10["已清理"](____self_10)
    end
    if ____instance_context__6311_6218_5DF2_7ED3_675F_11 then
        return
    end
    instance.context["时间停止中"] = true
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(instance.context["安兹单位"])
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue13
                end
                if _____6DFB_52A0_5355_4F4D_6682_505C(hero, _____65F6_95F4_505C_6B62_6682_505C_6765_6E90) then
                    local ____instance__6682_505C_5355_4F4D_5217_8868_12 = instance["暂停单位列表"]
                    ____instance__6682_505C_5355_4F4D_5217_8868_12[#____instance__6682_505C_5355_4F4D_5217_8868_12 + 1] = hero
                end
            end
            ::__continue13::
            i = i + 1
        end
    end
end
local function _____6062_590D_65F6_95F4_505C_6B62_73A9_5BB6(instance)
    do
        local i = 0
        while i < #instance["暂停单位列表"] do
            local hero = instance["暂停单位列表"][i + 1]
            if hero ~= nil and hero ~= 0 then
                _____79FB_9664_5355_4F4D_6682_505C(hero, _____65F6_95F4_505C_6B62_6682_505C_6765_6E90)
            end
            i = i + 1
        end
    end
    instance["暂停单位列表"] = {}
    instance.context["时间停止中"] = false
    _____5173_95ED_541F_5531_6761("大招")
end
local function _____9500_6BC1_65F6_95F4_505C_6B62_6301_7EED_8868_73B0(instance)
    do
        local i = 0
        while i < #instance["持续特效列表"] do
            local effect = instance["持续特效列表"][i + 1]
            if effect ~= nil and effect ~= 0 then
                DestroyEffect(effect)
            end
            i = i + 1
        end
    end
    instance["持续特效列表"] = {}
end
local function _____6E05_7406_65F6_95F4_505C_6B62_5B9E_4F8B(instance)
    if instance["已清理"] then
        return
    end
    instance["已清理"] = true
    _____6062_590D_65F6_95F4_505C_6B62_73A9_5BB6(instance)
    _____9500_6BC1_65F6_95F4_505C_6B62_6301_7EED_8868_73B0(instance)
    local context = instance.context
    if context["当前大型技能"] == _____65F6_95F4_505C_6B62_5927_578B_6280_80FDKey then
        context["当前大型技能"] = nil
        context["上次大型技能结束Ms"] = getServerTime()
    end
    local boss = context["安兹单位"]
    if _____5355_4F4D_6709_6548(boss) then
        SetUnitTimeScale(boss, 1)
        SetUnitAnimationByIndex(boss, _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E["待机编号"])
    end
end
local function _____64AD_653E_65F6_95F4_505C_6B62_7ED3_7B97_7279_6548(model, x, y, scale)
    return _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = model,
        X = x,
        Y = y,
        ["缩放"] = scale,
        ["持续秒"] = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]["时间停止结算特效持续秒"]
    })
end
local function _____9020_6210_65F6_95F4_505C_6B62_4F24_5BB3(boss, target, damage, tag)
    _____9020_6210AOE_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害"] = damage,
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_MAGIC,
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能",
        ["标签"] = tag
    })
end
local function _____7ED3_7B97_65F6_95F4_505C_6B62_5730_9762_6CD5_9635(instance)
    local context = instance.context
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local locked = instance["锁定"]
    _____64AD_653E_65F6_95F4_505C_6B62_7ED3_7B97_7279_6548(cfg["表现资源"]["时间停止地面法阵特效路径"], locked["地面法阵X"], locked["地面法阵Y"], cfg["阶段技能"]["时间停止地面法阵缩放"])
    local radius2 = cfg["阶段技能"]["时间停止地面法阵半径"] * cfg["阶段技能"]["时间停止地面法阵半径"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue33
                end
                local dx = GetUnitX(target) - locked["地面法阵X"]
                local dy = GetUnitY(target) - locked["地面法阵Y"]
                if dx * dx + dy * dy > radius2 then
                    goto __continue33
                end
                _____9020_6210_65F6_95F4_505C_6B62_4F24_5BB3(
                    boss,
                    target,
                    _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, target, {["来源攻击力比例"] = cfg["阶段技能"]["时间停止地面法阵伤害Boss攻击力比例"], ["目标最大生命比例"] = cfg["阶段技能"]["时间停止地面法阵伤害目标最大生命比例"]}),
                    "安兹·时间停止·地面法阵"
                )
            end
            ::__continue33::
            i = i + 1
        end
    end
end
local function _____7ED3_7B97_65F6_95F4_505C_6B62_73B0_5B9E_65AD_88C2(instance)
    local context = instance.context
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local ordinary = cfg["普通技能"]
    local locked = instance["锁定"]
    local effect = _____64AD_653E_65F6_95F4_505C_6B62_7ED3_7B97_7279_6548(cfg["表现资源"]["现实断裂特效路径"], (locked["裂缝起点X"] + locked["裂缝终点X"]) * 0.5, (locked["裂缝起点Y"] + locked["裂缝终点Y"]) * 0.5, ordinary["现实断裂特效缩放"])
    if effect ~= nil and effect ~= 0 then
        _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C(effect, {["Z轴角度"] = locked["裂缝角度"]})
    end
    local halfWidth2 = ordinary["现实断裂路径宽度"] * ordinary["现实断裂路径宽度"] * 0.25
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue40
                end
                if _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                    GetUnitX(target),
                    GetUnitY(target),
                    locked["裂缝起点X"],
                    locked["裂缝起点Y"],
                    locked["裂缝终点X"],
                    locked["裂缝终点Y"]
                ) > halfWidth2 then
                    goto __continue40
                end
                _____9020_6210_65F6_95F4_505C_6B62_4F24_5BB3(
                    boss,
                    target,
                    _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, target, {["来源攻击力比例"] = ordinary["现实断裂伤害Boss攻击力比例"], ["目标最大生命比例"] = ordinary["现实断裂伤害目标最大生命比例"]}),
                    "安兹·时间停止·现实断裂"
                )
            end
            ::__continue40::
            i = i + 1
        end
    end
end
local function _____7ED3_7B97_65F6_95F4_505C_6B62_9B54_6CD5_7BAD(instance)
    local context = instance.context
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local ordinary = cfg["普通技能"]
    local locked = instance["锁定"]
    _____64AD_653E_65F6_95F4_505C_6B62_7ED3_7B97_7279_6548(cfg["表现资源"]["高阶魔法箭特效路径"], locked["魔法箭X"], locked["魔法箭Y"], ordinary["高阶魔法箭特效缩放"])
    local radius2 = ordinary["高阶魔法箭伤害半径"] * ordinary["高阶魔法箭伤害半径"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue46
                end
                local dx = GetUnitX(target) - locked["魔法箭X"]
                local dy = GetUnitY(target) - locked["魔法箭Y"]
                if dx * dx + dy * dy > radius2 then
                    goto __continue46
                end
                _____9020_6210_65F6_95F4_505C_6B62_4F24_5BB3(
                    boss,
                    target,
                    _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(
                        boss,
                        target,
                        {
                            ["来源攻击力比例"] = ordinary["高阶魔法箭伤害Boss攻击力比例"],
                            ["目标最大生命比例"] = ordinary["高阶魔法箭伤害目标最大生命比例"],
                            ["总倍率"] = _____53D6_5B89_5179_4EA1_7075_7BAD_4F24_5BB3_500D_7387(context)
                        }
                    ),
                    "安兹·时间停止·高阶魔法箭"
                )
            end
            ::__continue46::
            i = i + 1
        end
    end
end
____exports["释放安兹时间停止"] = function(context)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= nil or context["时间停止中"] then
        return false
    end
    local locked = _____521B_5EFA_65F6_95F4_505C_6B62_9501_5B9A(context)
    if locked == nil then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    local executor = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "安兹·时间停止固定序列", ["清理"] = context["清理"], ["互斥组"] = "安兹大型技能"})
    local instance = {
        context = context,
        ["锁定"] = locked,
        ["暂停单位列表"] = {},
        ["持续特效列表"] = {},
        ["已清理"] = false
    }
    context["当前大型技能"] = _____65F6_95F4_505C_6B62_5927_578B_6280_80FDKey
    local ____self_13 = context["清理"]
    ____self_13["登记清理"](
        ____self_13,
        "安兹-时间停止实例",
        function()
            _____6E05_7406_65F6_95F4_505C_6B62_5B9E_4F8B(instance)
        end
    )
    local totalSeconds = _____53D6_65F6_95F4_505C_6B62_603B_65F6_957F_79D2()
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = boss,
        ["动画编号"] = cfg["时间停止动画编号"],
        ["动画速度"] = cfg["时间停止动画速度"],
        ["持续秒"] = totalSeconds,
        ["恢复动画编号"] = _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E["待机编号"]
    })
    _____663E_793A_5927_62DB_541F_5531_6761({
        ["通道"] = "大招",
        ["总时长"] = cfg["时间停止预展示秒"] + cfg["时间停止冻结秒"],
        ["颜色ID"] = 4,
        ["标题文本"] = "时间停止",
        ["提示文本"] = "所有危险位置已经锁定，冻结前寻找安全方向"
    })
    local executionId = executor["开始"](
        executor,
        {
            key = _____65F6_95F4_505C_6B62_5927_578B_6280_80FDKey,
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = (totalSeconds + 1) * 1000,
            ["阶段列表"] = {
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        _____521B_5EFA_65F6_95F4_505C_6B62_9884_8B66(instance)
                        _____521B_5EFA_65F6_95F4_505C_6B62_6301_7EED_8868_73B0(instance)
                    end,
                    "展示未来落点"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["时间停止预展示秒"] * 1000, "冻结前走位"),
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        _____51BB_7ED3_65F6_95F4_505C_6B62_73A9_5BB6(instance)
                    end,
                    "时间冻结"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["时间停止冻结秒"] * 1000, "冻结布置"),
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        _____6062_590D_65F6_95F4_505C_6B62_73A9_5BB6(instance)
                        _____7ED3_7B97_65F6_95F4_505C_6B62_5730_9762_6CD5_9635(instance)
                    end,
                    "地面法阵结算"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["时间停止结算间隔秒"] * 1000, "裂缝结算间隔"),
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        _____7ED3_7B97_65F6_95F4_505C_6B62_73B0_5B9E_65AD_88C2(instance)
                    end,
                    "现实断裂结算"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["时间停止结算间隔秒"] * 1000, "魔法箭结算间隔"),
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        _____7ED3_7B97_65F6_95F4_505C_6B62_9B54_6CD5_7BAD(instance)
                    end,
                    "魔法箭结算"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["时间停止收尾秒"] * 1000, "时间停止收尾")
            },
            ["结束回调"] = function()
                _____6E05_7406_65F6_95F4_505C_6B62_5B9E_4F8B(instance)
            end
        }
    )
    if executionId == 0 then
        _____6E05_7406_65F6_95F4_505C_6B62_5B9E_4F8B(instance)
        return false
    end
    return true
end
____exports["时间停止技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "阶段编排机制",
    ["语义"] = "停止前完整展示未来落点，冻结期间只布置，恢复后按固定顺序结算。",
    ["实现要求"] = "不得在冻结期间偷偷改变已展示的位置、方向或目标。"
}
return ____exports
