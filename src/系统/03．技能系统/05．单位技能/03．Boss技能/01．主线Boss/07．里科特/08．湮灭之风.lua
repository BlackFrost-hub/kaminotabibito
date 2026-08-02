local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
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
local stringToFourCC = ____13_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____8DDD_79BB_5E73_65B9XY = ____13_FF0E_516C_5171_5DE5_5177["距离平方XY"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____01_FF0E_6301_7EED_5371_9669_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
local _____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____01_FF0E_6301_7EED_5371_9669_533A_57DF["创建持续危险区域"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local ShowUnit = jass.ShowUnit
local GetRandomInt = jass.GetRandomInt
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_1.createTimedEffect
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_2["获取Boss技能随机敌对英雄"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_3["施加快速控制Buff"]
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_3["施加快速减速Buff"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_5.X_FixUnitStandingSafe
local X_RestoreUnitStandingSafe = ____require_result_5.X_RestoreUnitStandingSafe
local _____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6E6E_706D_4E4B_98CE_6280_80FDID = stringToFourCC(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之风"]["技能槽位"])
local _____5F53_524D_6E6E_706D_98CE_573A_8868 = {}
local _____5DF2_6CE8_518C = false
local function _____7ED3_675F_6E6E_706D_4E4B_98CE(data)
    if data["已结束"] then
        return
    end
    data["已结束"] = true
    if _____5F53_524D_6E6E_706D_98CE_573A_8868[data.BossID] == data then
        __TS__Delete(_____5F53_524D_6E6E_706D_98CE_573A_8868, data.BossID)
    end
    if data["区域实例"] ~= nil then
        local _____533A_57DF_5B9E_4F8B = data["区域实例"]
        data["区域实例"] = nil
        _____533A_57DF_5B9E_4F8B["销毁"]()
    end
    local boss = data.context["Boss单位"]
    if boss == nil or boss == 0 then
        return
    end
    ShowUnit(boss, true)
    if data["已锁定移动"] then
        X_RestoreUnitStandingSafe(boss)
    end
end
local function _____6E05_7406_6E6E_706D_4E4B_98CE(value)
    local data = value
    if data ~= nil then
        _____7ED3_675F_6E6E_706D_4E4B_98CE(data)
    end
end
local function _____65BD_52A0_6E6E_706D_4E4B_98CE_968F_673A_63A7_5236(boss, hero)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之风"]
    local roll = GetRandomInt(0, 2)
    if roll == 0 then
        _____65BD_52A0_7729_6655(boss, hero, cfg["随机眩晕秒"])
    elseif roll == 1 then
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, hero, 2, cfg["随机控制持续秒"])
    else
        _____65BD_52A0_5FEB_901F_51CF_901FBuff(
            boss,
            hero,
            cfg["随机减速比例"],
            cfg["随机减速比例"],
            cfg["随机减速秒"]
        )
    end
end
local function _____7ED3_7B97_6E6E_706D_4E4B_98CE_4E00_8DF3(data)
    local context = data.context
    local boss = context["Boss单位"]
    if data["已结束"] or not _____5355_4F4D_6709_6548(boss) then
        _____7ED3_675F_6E6E_706D_4E4B_98CE(data)
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之风"]
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    local radius2 = cfg["半径"] * cfg["半径"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue17
                end
                if _____8DDD_79BB_5E73_65B9XY(
                    GetUnitX(hero),
                    GetUnitY(hero),
                    bx,
                    by
                ) > radius2 then
                    goto __continue17
                end
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____6E6E_706D_4E4B_98CE_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害公式"] = {["来源攻击力比例"] = cfg["Boss攻击力比例"]},
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    weaponType = WEAPON_TYPE_WHOKNOWS
                })
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, hero, 2, cfg["沉默秒"])
            end
            ::__continue17::
            i = i + 1
        end
    end
    local randomHero = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, boss, cfg["半径"])
    if _____5355_4F4D_6709_6548(randomHero) then
        _____65BD_52A0_6E6E_706D_4E4B_98CE_968F_673A_63A7_5236(boss, randomHero)
    end
end
____exports["释放里科特湮灭之风"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之风"]
    local bossId = GetHandleId(boss)
    local current = _____5F53_524D_6E6E_706D_98CE_573A_8868[bossId]
    if current ~= nil then
        _____7ED3_675F_6E6E_706D_4E4B_98CE(current)
    end
    local stage = _____5237_65B0_91CC_79D1_7279_9636_6BB5(context)
    _____64AD_653E_91CC_79D1_7279_53F0_8BCD(boss, "湮灭之风")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["湮灭之风"]["风场展开"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    createTimedEffect(
        cfg["扩散特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        cfg["扩散特效持续秒"]
    )
    createTimedEffect(
        cfg["风场特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        cfg["风场特效持续秒"]
    )
    local _____5E94_9501_5B9A_79FB_52A8 = stage < 3
    if _____5E94_9501_5B9A_79FB_52A8 then
        X_FixUnitStandingSafe(boss)
        ShowUnit(boss, false)
    end
    local data = {context = context, BossID = bossId, ["已锁定移动"] = _____5E94_9501_5B9A_79FB_52A8, ["已结束"] = false}
    _____5F53_524D_6E6E_706D_98CE_573A_8868[bossId] = data
    data["区域实例"] = _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["锚点单位"] = boss,
        ["半径"] = cfg["半径"],
        ["持续时间"] = cfg["持续秒"],
        ["检测间隔"] = cfg["tick秒"],
        ["所有者"] = boss,
        ["影响目标"] = "敌方",
        ["提示圈"] = {
            ["类型"] = "圆形",
            ["锚点单位"] = boss,
            ["半径"] = cfg["半径"],
            ["持续时间"] = cfg["持续秒"],
            ["可手动销毁"] = true
        },
        ["on周期"] = function()
            _____7ED3_7B97_6E6E_706D_4E4B_98CE_4E00_8DF3(data)
        end,
        ["on销毁"] = function()
            _____7ED3_675F_6E6E_706D_4E4B_98CE(data)
        end
    })
    local ____self_6 = context["清理"]
    ____self_6["登记清理"](____self_6, "里科特-湮灭之风移动锁", _____6E05_7406_6E6E_706D_4E4B_98CE, data)
    if stage >= 3 then
        _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
            ["名称"] = "里科特-湮灭之风施法",
            ["施法者"] = boss,
            ["硬直秒"] = cfg["施法硬直秒"],
            ["生效延迟秒"] = cfg["持续秒"],
            ["动画编号"] = 8,
            ["动画速度"] = cfg["动画速度"],
            ["后续动画编号"] = 9,
            ["后续动画速度"] = 1,
            ["后续动画延迟毫秒"] = cfg["施法动作原始时长秒"] * 1000 / cfg["动画速度"],
            ["恢复动画编号"] = 3,
            ["清理"] = context["清理"],
            ["on生效"] = function()
            end
        })
    end
end
local function ____on_91CC_79D1_7279_6E6E_706D_4E4B_98CE_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6E6E_706D_4E4B_98CE_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____91CC_79D1_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放里科特湮灭之风"](context)
end
____exports["注册里科特湮灭之风"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "08．湮灭之风",
        ["单位类型ID"] = _____91CC_79D1_7279_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6E6E_706D_4E4B_98CE_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_91CC_79D1_7279_6E6E_706D_4E4B_98CE_65BD_6CD5(boss, _____6E6E_706D_4E4B_98CE_6280_80FDID)
        end
    })
end
return ____exports
