--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____64AD_653E_58A8_6C41_5730_9762_7279_6548, _____5355_4F4D_5728_58A8_6C41_533A_57DF_5185, _____53D1_5C04_58A8_6C41_8D1D_585E_5C14_55B7_5410, _____7ED3_7B97_58A8_6C41_533A_57DF_4F24_5BB3, _____53D6_58A8_6C41_533A_57DF_540E_7EED_6267_884C_6B21_6570, _____542F_52A8_58A8_6C41_533A_57DF_5468_671F, _____5F00_59CB_58A8_6C41_6B8B_7559_533A_57DF, _____7ED3_7B97_58A8_6C41_533A_57DF_4E00_8DF3, GetUnitX, GetUnitY, GetUnitFlyHeight, GetRandomReal, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____521B_5EFA_70B9_7279_6548, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____6EE1_8DB3_5C5E_6027_6297_6027_95E8_69DB, _____65BD_52A0_6218_6597_89C6_91CE_538B_5236, _____65BD_52A0_5FEB_901F_63A7_5236Buff, registerManualBuff, _____5361_745F_62C9BuffID, _____58A8_6C41_55B7_5410_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.00．配置")
local _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["卡瑟拉单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建卡瑟拉上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local _____5361_745F_62C9_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉音效配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____14_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5355_4F4D_95F4_89D2_5EA6 = ____14_FF0E_516C_5171_5DE5_5177["取单位间角度"]
local _____53D6_5750_6807_89D2_5EA6 = ____14_FF0E_516C_5171_5DE5_5177["取坐标角度"]
local _____8DDD_79BB_5E73_65B9XY = ____14_FF0E_516C_5171_5DE5_5177["距离平方XY"]
local _____89D2_5EA6_5DEE = ____14_FF0E_516C_5171_5DE5_5177["角度差"]
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_4E8C_9636_8D1D_585E_5C14XYZ_8F68_8FF9 = ____index["创建二阶贝塞尔XYZ轨迹"]
local _____521B_5EFA_539F_751F_5F39_5E55 = ____index["创建原生弹幕"]
local ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.22．限次周期执行器")
local _____521B_5EFA_9650_6B21_5468_671F_6267_884C_5668 = ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668["创建限次周期执行器"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算BossAOE技能伤害"]
function _____64AD_653E_58A8_6C41_5730_9762_7279_6548(context, x, y)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local model = cfg["墨汁残留模型路径"]
    if model == "" then
        return
    end
    local effect = _____521B_5EFA_70B9_7279_6548({["模型路径"] = model, X = x, Y = y})
    local ____self_10 = context["清理"]
    ____self_10["登记限时特效"](____self_10, "卡瑟拉-墨汁地面残留", effect, cfg["残留秒"] * 1000)
end
function _____5355_4F4D_5728_58A8_6C41_533A_57DF_5185(unit, area)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local ux = GetUnitX(unit)
    local uy = GetUnitY(unit)
    if not area["是否喷吐阶段"] then
        local _____6B8B_7559_534A_5F84_5E73_65B9 = cfg["残留半径"] * cfg["残留半径"]
        return _____8DDD_79BB_5E73_65B9XY(ux, uy, area["地面残留X"], area["地面残留Y"]) <= _____6B8B_7559_534A_5F84_5E73_65B9
    end
    local _____6247_5F62_534A_5F84_5E73_65B9 = cfg["扇形半径"] * cfg["扇形半径"]
    if _____8DDD_79BB_5E73_65B9XY(ux, uy, area["起点X"], area["起点Y"]) > _____6247_5F62_534A_5F84_5E73_65B9 then
        return false
    end
    local angle = _____53D6_5750_6807_89D2_5EA6(area["起点X"], area["起点Y"], ux, uy)
    return _____89D2_5EA6_5DEE(angle, area["方向角"]) <= cfg["扇形角度"] * 0.5
end
function _____53D1_5C04_58A8_6C41_8D1D_585E_5C14_55B7_5410(context, originX, originY, baseAngle)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local model = cfg["墨汁抛射模型路径"]
    if model == "" then
        return
    end
    local shotAngle = baseAngle + GetRandomReal(-cfg["扇形角度"] * 0.35, cfg["扇形角度"] * 0.35)
    local startX = originX
    local startY = originY
    local startZ = GetUnitFlyHeight(boss) + cfg["喷吐起点高度"]
    local endDist = cfg["扇形半径"] * GetRandomReal(0.55, 0.95)
    local endX = _____6781_5750_6807X(originX, shotAngle, endDist)
    local endY = _____6781_5750_6807Y(originY, shotAngle, endDist)
    local endZ = cfg["喷吐终点高度"]
    local midX = (startX + endX) * 0.5
    local midY = (startY + endY) * 0.5
    local sideBend = GetRandomReal(-cfg["喷吐侧弯距离"], cfg["喷吐侧弯距离"])
    local controlX = _____6781_5750_6807X(midX, shotAngle + 90, sideBend)
    local controlY = _____6781_5750_6807Y(midY, shotAngle + 90, sideBend)
    local controlZ = cfg["喷吐控制高度"]
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        ["载体模式"] = "特效",
        X = startX,
        Y = startY,
        ["方向角"] = shotAngle,
        ["速度"] = 0,
        ["生命周期"] = cfg["喷吐飞行秒"],
        ["命中半径"] = 0,
        ["碰撞消失"] = false,
        ["禁用碰撞"] = true,
        ["不可阻挡"] = true,
        ["飞行高度"] = startZ,
        ["附加特效1"] = {["模型"] = model, ["跟随轨迹俯仰"] = true, ["缩放"] = cfg["喷吐弹幕缩放"] * 3},
        ["轨迹采样器"] = _____521B_5EFA_4E8C_9636_8D1D_585E_5C14XYZ_8F68_8FF9(
            startX,
            startY,
            startZ,
            controlX,
            controlY,
            controlZ,
            endX,
            endY,
            endZ
        ),
        ["on到达目标点"] = function()
            _____64AD_653E_58A8_6C41_5730_9762_7279_6548(context, endX, endY)
        end
    })
end
function _____7ED3_7B97_58A8_6C41_533A_57DF_4F24_5BB3(area)
    local boss = area.context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local affected = {}
    local damagePerTick = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["每秒Boss攻击力比例"]
    if area["是否喷吐阶段"] then
        damagePerTick = damagePerTick / 10
    end
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) or not _____5355_4F4D_5728_58A8_6C41_533A_57DF_5185(hero, area) then
                    goto __continue17
                end
                local resisted = _____6EE1_8DB3_5C5E_6027_6297_6027_95E8_69DB(hero, "水", cfg["水抗门槛"], true)
                local factor = resisted and cfg["达标效果倍率"] or 1
                _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____58A8_6C41_55B7_5410_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = damagePerTick * factor,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_COLD,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = "卡瑟拉墨汁喷吐"
                })
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, hero, 2, cfg["tick秒"] * factor)
                registerManualBuff(
                    hero,
                    _____5361_745F_62C9BuffID["墨汁遮蔽"],
                    cfg["tick秒"] + 0.2,
                    factor,
                    {sourceName = "卡瑟拉-墨汁遮蔽"}
                )
                affected[#affected + 1] = hero
            end
            ::__continue17::
            i = i + 1
        end
    end
    if #affected > 0 then
        _____65BD_52A0_6218_6597_89C6_91CE_538B_5236({
            ["名称"] = "卡瑟拉-墨汁视野压制",
            ["来源单位"] = boss,
            ["目标列表"] = affected,
            ["持续时间"] = cfg["tick秒"] + 0.2,
            ["视野减少值"] = cfg["视野降低"],
            BuffID = _____5361_745F_62C9BuffID["墨汁遮蔽"],
            ["叠加键"] = "卡瑟拉-墨汁遮蔽"
        })
    end
end
function _____53D6_58A8_6C41_533A_57DF_540E_7EED_6267_884C_6B21_6570(_____603B_6267_884C_6B21_6570)
    local _____540E_7EED_6267_884C_6B21_6570 = _____603B_6267_884C_6B21_6570 - 1
    return _____540E_7EED_6267_884C_6B21_6570 > 0 and _____540E_7EED_6267_884C_6B21_6570 or 0
end
function _____542F_52A8_58A8_6C41_533A_57DF_5468_671F(area, _____540D_79F0)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local _____55B7_5410_9636_6BB5 = area["是否喷吐阶段"]
    local _____603B_6267_884C_6B21_6570 = _____55B7_5410_9636_6BB5 and cfg["持续秒"] / 0.1 or cfg["残留秒"] / cfg["tick秒"]
    local _____5468_671F_95F4_9694_6BEB_79D2 = _____55B7_5410_9636_6BB5 and 0.1 * 1000 or cfg["tick秒"] * 1000
    return _____521B_5EFA_9650_6B21_5468_671F_6267_884C_5668({
        ["名称"] = _____540D_79F0,
        ["间隔毫秒"] = _____5468_671F_95F4_9694_6BEB_79D2,
        ["最大执行次数"] = _____53D6_58A8_6C41_533A_57DF_540E_7EED_6267_884C_6B21_6570(_____603B_6267_884C_6B21_6570),
        ["变量"] = area,
        ["清理"] = area.context["清理"],
        onTick = function(______6267_884C_6B21_6570, variable)
            return variable ~= nil and _____7ED3_7B97_58A8_6C41_533A_57DF_4E00_8DF3(variable)
        end
    })
end
function _____5F00_59CB_58A8_6C41_6B8B_7559_533A_57DF(area)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    _____64AD_653E_58A8_6C41_5730_9762_7279_6548(area.context, area["地面残留X"], area["地面残留Y"])
    area["是否喷吐阶段"] = false
    area["剩余跳数"] = cfg["残留秒"] / cfg["tick秒"]
    local _____5468_671F = _____542F_52A8_58A8_6C41_533A_57DF_5468_671F(area, "卡瑟拉-墨汁残留周期")
    area["周期"] = _____5468_671F
    local _____7EE7_7EED_6267_884C = _____7ED3_7B97_58A8_6C41_533A_57DF_4E00_8DF3(area)
    if not _____7EE7_7EED_6267_884C and area["周期"] == _____5468_671F then
        _____5468_671F["停止"](_____5468_671F)
    end
end
function _____7ED3_7B97_58A8_6C41_533A_57DF_4E00_8DF3(area)
    local boss = area.context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or area["剩余跳数"] <= 0 then
        if area["是否喷吐阶段"] then
            _____5F00_59CB_58A8_6C41_6B8B_7559_533A_57DF(area)
        end
        return false
    end
    area["剩余跳数"] = area["剩余跳数"] - 1
    if area["是否喷吐阶段"] then
        _____53D1_5C04_58A8_6C41_8D1D_585E_5C14_55B7_5410(area.context, area["起点X"], area["起点Y"], area["方向角"])
    end
    _____7ED3_7B97_58A8_6C41_533A_57DF_4F24_5BB3(area)
    if area["剩余跳数"] <= 0 and area["是否喷吐阶段"] then
        _____5F00_59CB_58A8_6C41_6B8B_7559_533A_57DF(area)
        return false
    end
    return true
end
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetRandomReal = jass.GetRandomReal
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_2["启动基础施法时间线"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_4["获取Boss技能随机敌对英雄"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.13．属性抗性门槛")
_____6EE1_8DB3_5C5E_6027_6297_6027_95E8_69DB = ____require_result_5["满足属性抗性门槛"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.10．战斗视野压制")
_____65BD_52A0_6218_6597_89C6_91CE_538B_5236 = ____require_result_6["施加战斗视野压制"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_7["施加快速控制Buff"]
local ____require_result_8 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_8.registerManualBuff
local ____require_result_9 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.02．卡瑟拉")
_____5361_745F_62C9BuffID = ____require_result_9["卡瑟拉BuffID"]
local _____5361_745F_62C9_5355_4F4D_7C7B_578BID = stringToFourCC(_____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____58A8_6C41_55B7_5410_6280_80FDID = stringToFourCC(_____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____53D6_58A8_6C41_55B7_5410_76EE_6807(boss)
    local spellTarget = GetSpellTargetUnit()
    if _____5355_4F4D_6709_6548(spellTarget) then
        return spellTarget
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, boss, 1400)
end
local function _____5F00_59CB_58A8_6C41_55B7_5410_533A_57DF(context, x, y, angle, groundX, groundY)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local area = {
        context = context,
        ["起点X"] = x,
        ["起点Y"] = y,
        ["方向角"] = angle,
        ["剩余跳数"] = cfg["持续秒"] / 0.1,
        ["周期"] = nil,
        ["是否喷吐阶段"] = true,
        ["地面残留X"] = groundX,
        ["地面残留Y"] = groundY
    }
    local _____5468_671F = _____542F_52A8_58A8_6C41_533A_57DF_5468_671F(area, "卡瑟拉-墨汁喷吐周期")
    area["周期"] = _____5468_671F
    local _____7EE7_7EED_6267_884C = _____7ED3_7B97_58A8_6C41_533A_57DF_4E00_8DF3(area)
    if not _____7EE7_7EED_6267_884C and area["周期"] == _____5468_671F then
        _____5468_671F["停止"](_____5468_671F)
    end
end
____exports["释放卡瑟拉墨汁喷吐"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____53D6_58A8_6C41_55B7_5410_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local angle = _____53D6_5355_4F4D_95F4_89D2_5EA6(boss, target)
    local effectX = _____6781_5750_6807X(bx, angle, cfg["扇形半径"] * 0.45)
    local effectY = _____6781_5750_6807Y(by, angle, cfg["扇形半径"] * 0.45)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "扇形",
        X = bx,
        Y = by,
        ["半径"] = cfg["扇形半径"],
        ["扇形角度"] = cfg["扇形角度"],
        ["朝向"] = angle,
        ["持续时间"] = cfg["持续秒"],
        ["来源单位"] = boss
    })
    _____64AD_653E_58A8_6C41_5730_9762_7279_6548(context, effectX, effectY)
    _____5F00_59CB_58A8_6C41_55B7_5410_533A_57DF(
        context,
        bx,
        by,
        angle,
        effectX,
        effectY
    )
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "卡瑟拉-墨汁喷吐",
        ["施法者"] = boss,
        ["目标X"] = targetX,
        ["目标Y"] = targetY,
        ["生效前重新面向"] = false,
        ["硬直秒"] = cfg["持续秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["恢复动画编号"] = 5,
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["持续秒"],
            ["颜色ID"] = cfg["吟唱条颜色ID"],
            ["标题文本"] = cfg["吟唱条标题文本"],
            ["提示文本"] = cfg["吟唱条提示文本"]
        },
        ["清理"] = context["清理"],
        ["播放台词"] = function()
            _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "墨汁喷吐")
            _____64AD_653EBoss_5750_6807_97F3_6548(_____5361_745F_62C9_97F3_6548_914D_7F6E["墨汁喷吐"]["主段"], bx, by, _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"])
        end,
        ["on生效"] = function()
        end
    })
end
local function ____on_5361_745F_62C9_58A8_6C41_55B7_5410_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____58A8_6C41_55B7_5410_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5361_745F_62C9_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放卡瑟拉墨汁喷吐"](context)
end
____exports["注册卡瑟拉墨汁喷吐"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "05．墨汁喷吐",
        ["单位类型ID"] = _____5361_745F_62C9_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____58A8_6C41_55B7_5410_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5361_745F_62C9_58A8_6C41_55B7_5410_65BD_6CD5(boss, _____58A8_6C41_55B7_5410_6280_80FDID)
        end
    })
end
return ____exports
