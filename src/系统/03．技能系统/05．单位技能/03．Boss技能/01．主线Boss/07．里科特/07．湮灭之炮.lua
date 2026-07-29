--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8C03_5EA6P3_7729_6655_70AE, GetUnitX, GetUnitY, GetRandomReal, addDelayedCallback, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____65BD_52A0_7729_6655
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.00．配置")
local _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["里科特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建里科特上下文"]
local _____5237_65B0_91CC_79D1_7279_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新里科特阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特数值与表现配置"]
local _____91CC_79D1_7279_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特音效配置"]
local ____10_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.10．台词播放")
local _____64AD_653E_91CC_79D1_7279_53F0_8BCD = ____10_FF0E_53F0_8BCD_64AD_653E["播放里科特台词"]
local ____13_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.13．公共工具")
local _____5355_4F4D_6709_6548 = ____13_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____64AD_653E_91CC_79D1_7279_65BD_6CD5_7EF4_6301_52A8_4F5C = ____13_FF0E_516C_5171_5DE5_5177["播放里科特施法维持动作"]
local stringToFourCC = ____13_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5750_6807_89D2_5EA6 = ____13_FF0E_516C_5171_5DE5_5177["取坐标角度"]
local _____6781_5750_6807X = ____13_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____13_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____13_FF0E_516C_5171_5DE5_5177["点到线段距离平方"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____14_FF0E_6301_7EED_65BD_6CD5_53D1_5C04 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.14．持续施法发射")
local _____542F_52A8_6301_7EED_65BD_6CD5_53D1_5C04 = ____14_FF0E_6301_7EED_65BD_6CD5_53D1_5C04["启动持续施法发射"]
local _____505C_6B62_6301_7EED_65BD_6CD5_53D1_5C04 = ____14_FF0E_6301_7EED_65BD_6CD5_53D1_5C04["停止持续施法发射"]
function _____8C03_5EA6P3_7729_6655_70AE(context, _____9636_6BB5, target)
    if _____9636_6BB5 < 3 then
        return
    end
    local boss = context["Boss单位"]
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    local randomDelay = GetRandomReal(0, cfg["P3眩晕炮随机延迟最大秒"])
    local warningId = addDelayedCallback(
        randomDelay * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
                return
            end
            local cx = GetUnitX(target)
            local cy = GetUnitY(target)
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "圆形",
                X = cx,
                Y = cy,
                ["半径"] = cfg["P3眩晕炮半径"],
                ["持续时间"] = cfg["P3眩晕炮延迟秒"],
                ["来源单位"] = boss
            })
            local resolveId = addDelayedCallback(
                cfg["P3眩晕炮延迟秒"] * 1000,
                function()
                    if not _____5355_4F4D_6709_6548(boss) then
                        return
                    end
                    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
                    local radius2 = cfg["P3眩晕炮半径"] * cfg["P3眩晕炮半径"]
                    do
                        local i = 0
                        while i < #heroes do
                            do
                                local hero = heroes[i + 1]
                                if not _____5355_4F4D_6709_6548(hero) then
                                    goto __continue31
                                end
                                local dx = GetUnitX(hero) - cx
                                local dy = GetUnitY(hero) - cy
                                if dx * dx + dy * dy <= radius2 then
                                    _____65BD_52A0_7729_6655(boss, hero, cfg["P3眩晕秒"])
                                end
                            end
                            ::__continue31::
                            i = i + 1
                        end
                    end
                end
            )
            local ____self_12 = context["清理"]
            ____self_12["登记延迟回调"](____self_12, "里科特-P3湮灭眩晕炮结算", resolveId)
        end
    )
    local ____self_13 = context["清理"]
    ____self_13["登记延迟回调"](____self_13, "里科特-P3湮灭眩晕炮预警", warningId)
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
local SetUnitScale = jass.SetUnitScale
local SetUnitVertexColor = jass.SetUnitVertexColor
local UnitAddAbility = jass.UnitAddAbility
local SetUnitPathing = jass.SetUnitPathing
GetRandomReal = jass.GetRandomReal
local DzSetUnitModel = japi.DzSetUnitModel
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_3.createTimedEffect
local _____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_4["创建技能提示圈"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.06．里科特")
local _____91CC_79D1_7279BuffID = ____require_result_7["里科特BuffID"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
_____65BD_52A0_7729_6655 = ____require_result_8["施加眩晕"]
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_9.X_FixUnitStandingSafe
local _____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6E6E_706D_4E4B_70AE_6280_80FDID = stringToFourCC(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]["技能槽位"])
local _____8757_866B_6280_80FDID = stringToFourCC("Aloc")
local _____5DF2_6CE8_518C = false
local function _____521B_5EFA_6E6E_706D_6295_5F71_5355_4F4D(boss, x, y, face)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    local projection = CreateUnit(
        GetOwningPlayer(boss),
        stringToFourCC(cfg["投影单位类型"]),
        x,
        y,
        face
    )
    if projection == nil or projection == 0 then
        return projection
    end
    DzSetUnitModel(projection, cfg["投影模型路径"])
    UnitAddAbility(projection, _____8757_866B_6280_80FDID)
    SetUnitPathing(projection, false)
    X_FixUnitStandingSafe(projection)
    SetUnitScale(projection, cfg["投影缩放"], cfg["投影缩放"], cfg["投影缩放"])
    SetUnitVertexColor(
        projection,
        160,
        210,
        255,
        cfg["投影透明度"]
    )
    createTimedEffect(
        cfg["出现特效路径"],
        x,
        y,
        0,
        cfg["出现特效持续秒"]
    )
    return projection
end
local function _____521B_5EFA_6E6E_706D_4E4B_70AE_9884_8B66(ctx, boss)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = ctx["起点X"],
        Y = ctx["起点Y"],
        ["宽度"] = 180,
        ["长度"] = cfg["射程"],
        ["朝向"] = ctx["当前朝向"],
        ["持续时间"] = cfg["tick秒"],
        ["来源单位"] = boss
    })
end
local function _____521B_5EFA_6E6E_706D_4E4B_70AE_5C04_7EBF(ctx, _____7EC8_70B9X, _____7EC8_70B9Y)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["射线特效路径"],
        X = _____7EC8_70B9X,
        Y = _____7EC8_70B9Y,
        Z = 0,
        ["Z轴角度"] = ctx["当前朝向"] + cfg["射线朝向偏移角度"],
        ["持续秒"] = cfg["射线持续秒"]
    })
end
local function _____7ED3_7B97_6E6E_706D_4E4B_70AE_4E00_8DF3(ctx)
    local data = ctx["数据"]
    local boss = data.context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        _____505C_6B62_6301_7EED_65BD_6CD5_53D1_5C04(ctx.ID, "中断")
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    local _____7EC8_70B9X = _____6781_5750_6807X(ctx["起点X"], ctx["当前朝向"], cfg["射程"])
    local _____7EC8_70B9Y = _____6781_5750_6807Y(ctx["起点Y"], ctx["当前朝向"], cfg["射程"])
    _____521B_5EFA_6E6E_706D_4E4B_70AE_9884_8B66(ctx, boss)
    _____521B_5EFA_6E6E_706D_4E4B_70AE_5C04_7EBF(ctx, _____7EC8_70B9X, _____7EC8_70B9Y)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["每跳Boss攻击力比例"]
    local radius2 = 90 * 90
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue9
                end
                local dist2 = _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                    GetUnitX(hero),
                    GetUnitY(hero),
                    ctx["起点X"],
                    ctx["起点Y"],
                    _____7EC8_70B9X,
                    _____7EC8_70B9Y
                )
                if dist2 <= radius2 then
                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                        ["技能ID"] = _____6E6E_706D_4E4B_70AE_6280_80FDID,
                        ["来源"] = boss,
                        ["目标"] = hero,
                        ["伤害"] = damage,
                        attack = false,
                        ranged = false,
                        attackType = ATTACK_TYPE_NORMAL,
                        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "Boss技能"
                    })
                end
            end
            ::__continue9::
            i = i + 1
        end
    end
end
local function _____7ED3_675F_6E6E_706D_6295_5F71_70AE_51FB(ctx)
    if ctx["施法者"] ~= nil and ctx["施法者"] ~= 0 then
        RemoveUnit(ctx["施法者"])
    end
end
local function _____5F00_59CB_6E6E_706D_6295_5F71_70AE_51FB(data)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    if not _____5355_4F4D_6709_6548(data["投影"]) or not _____5355_4F4D_6709_6548(data["目标"]) then
        if data["投影"] ~= nil and data["投影"] ~= 0 then
            RemoveUnit(data["投影"])
        end
        return
    end
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["湮灭之炮"]["射线开火"],
        GetUnitX(data["投影"]),
        GetUnitY(data["投影"]),
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    local id = _____542F_52A8_6301_7EED_65BD_6CD5_53D1_5C04({
        ["清理"] = data.context["清理"],
        ["名称"] = "里科特-湮灭之炮持续锁定",
        ["施法者"] = data["投影"],
        ["目标单位"] = data["目标"],
        ["目标失效时结束"] = true,
        ["面向模式"] = "持续追踪目标",
        ["总持续秒"] = cfg["锁定持续秒"],
        ["Tick间隔毫秒"] = cfg["tick秒"] * 1000,
        ["发射开始秒"] = cfg["tick秒"],
        ["发射结束秒"] = cfg["锁定持续秒"],
        ["发射间隔秒"] = cfg["tick秒"],
        ["处理动画"] = false,
        ["硬直"] = false,
        ["数据"] = data,
        ["on发射"] = _____7ED3_7B97_6E6E_706D_4E4B_70AE_4E00_8DF3,
        ["on结束"] = _____7ED3_675F_6E6E_706D_6295_5F71_70AE_51FB
    })
    if id == 0 then
        RemoveUnit(data["投影"])
    end
end
local function _____8C03_5EA6_5355_4E2A_6E6E_706D_6295_5F71(context, _____9636_6BB5, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    local angle = _____53D6_5750_6807_89D2_5EA6(
        GetUnitX(boss),
        GetUnitY(boss),
        GetUnitX(target),
        GetUnitY(target)
    )
    local px = _____6781_5750_6807X(
        GetUnitX(target),
        angle,
        cfg["投影距离"]
    )
    local py = _____6781_5750_6807Y(
        GetUnitY(target),
        angle,
        cfg["投影距离"]
    )
    local face = _____53D6_5750_6807_89D2_5EA6(
        px,
        py,
        GetUnitX(target),
        GetUnitY(target)
    )
    local projection = _____521B_5EFA_6E6E_706D_6295_5F71_5355_4F4D(boss, px, py, face)
    local delay = _____9636_6BB5 >= 2 and cfg["P2锁定前延迟秒"] or cfg["锁定前延迟秒"]
    if _____5355_4F4D_6709_6548(projection) then
        _____64AD_653E_91CC_79D1_7279_65BD_6CD5_7EF4_6301_52A8_4F5C(projection, delay + cfg["锁定持续秒"], cfg["动画速度"])
    end
    _____64AD_653EBoss_5750_6807_97F3_6548(_____91CC_79D1_7279_97F3_6548_914D_7F6E["湮灭之炮"]["投影锁定"], px, py, _____91CC_79D1_7279_97F3_6548_914D_7F6E["默认裁断距离"])
    local data = {context = context, ["投影"] = projection, ["目标"] = target}
    if projection ~= nil and projection ~= 0 then
        local ____self_10 = context["清理"]
        ____self_10["登记单位"](____self_10, "里科特-湮灭投影", projection)
    end
    registerManualBuff(
        target,
        _____91CC_79D1_7279BuffID["湮灭锁定"],
        delay + cfg["锁定持续秒"],
        1,
        {sourceName = "里科特-湮灭锁定"}
    )
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = px,
        Y = py,
        ["宽度"] = 180,
        ["长度"] = cfg["射程"],
        ["朝向"] = face,
        ["持续时间"] = delay,
        ["来源单位"] = boss
    })
    local id = addDelayedCallback(
        delay * 1000,
        function()
            _____5F00_59CB_6E6E_706D_6295_5F71_70AE_51FB(data)
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记延迟回调"](____self_11, "里科特-湮灭投影开炮", id)
    if _____5355_4F4D_6709_6548(projection) then
        _____8C03_5EA6P3_7729_6655_70AE(context, _____9636_6BB5, target)
    end
end
____exports["释放里科特湮灭之炮"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之炮"]
    local _____9636_6BB5 = _____5237_65B0_91CC_79D1_7279_9636_6BB5(context)
    local castDuration = _____9636_6BB5 >= 2 and cfg["P2锁定前延迟秒"] or cfg["锁定前延迟秒"]
    _____64AD_653E_91CC_79D1_7279_65BD_6CD5_7EF4_6301_52A8_4F5C(boss, castDuration, cfg["动画速度"])
    _____64AD_653E_91CC_79D1_7279_53F0_8BCD(boss, "湮灭之炮")
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            _____8C03_5EA6_5355_4E2A_6E6E_706D_6295_5F71(context, _____9636_6BB5, heroes[i + 1])
            i = i + 1
        end
    end
end
local function ____on_91CC_79D1_7279_6E6E_706D_4E4B_70AE_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6E6E_706D_4E4B_70AE_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____91CC_79D1_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放里科特湮灭之炮"](context)
end
____exports["注册里科特湮灭之炮"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "07．湮灭之炮",
        ["单位类型ID"] = _____91CC_79D1_7279_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6E6E_706D_4E4B_70AE_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_91CC_79D1_7279_6E6E_706D_4E4B_70AE_65BD_6CD5(boss, _____6E6E_706D_4E4B_70AE_6280_80FDID)
        end
    })
end
return ____exports
