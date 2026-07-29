--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____64AD_653E_51FA_751F_7279_6548, _____53D6_7CBE_7075_7BAD_9635_76EE_6807_6743_91CD, _____8BFB_53D6_7CBE_7075_7BAD_9635Boss_653B_51FB_529B, _____9009_62E9_7CBE_7075_7BAD_9635_5C04_51FB_76EE_6807, _____521B_5EFA_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635_53EC_5524_7269, ____on_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635_751F_6548, _____521B_5EFA_53EC_5524_7269, _____521B_5EFA_70B9_7279_6548, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____6CE8_518C_7AD9_6869_5F39_5E55_5C04_51FB_5355_4F4D, _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex, getBuffRuntime, GetUnitStateJapi, GetUnitTypeId, GetUnitX, GetUnitY, UNIT_STATE_MAX_LIFE, _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID, _____7CBE_7075_7BAD_9635_6280_80FDID
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建瑟兰迪尔上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.00．配置")
local _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["瑟兰迪尔单位技能配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
function _____64AD_653E_51FA_751F_7279_6548(x, y)
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", X = x, Y = y, ["持续秒"] = 1})
end
function _____53D6_7CBE_7075_7BAD_9635_76EE_6807_6743_91CD(target)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["精灵箭阵"]
    local markConfig = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["执法印记"]
    local weight = config["普通目标权重"]
    if getBuffRuntime(target, markConfig.BuffID) ~= nil then
        weight = weight + config["标记目标额外权重"]
    end
    return weight
end
function _____8BFB_53D6_7CBE_7075_7BAD_9635Boss_653B_51FB_529B(boss)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["精灵箭阵"]
    local attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss)
    if attack > 0 then
        return attack
    end
    return config["Boss攻击力兜底"]
end
function _____9009_62E9_7CBE_7075_7BAD_9635_5C04_51FB_76EE_6807(shooter, _boss)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["精灵箭阵"]
    if not _____5355_4F4D_6709_6548(shooter) then
        return nil
    end
    local searchRadius = config["索敌半径"] > 0 and config["索敌半径"] or config["弹幕最大飞行距离"]
    return _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex(
        _boss,
        shooter,
        searchRadius,
        nil,
        nil,
        _____53D6_7CBE_7075_7BAD_9635_76EE_6807_6743_91CD
    )
end
function _____521B_5EFA_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635_53EC_5524_7269(boss)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["精灵箭阵"]
    if boss == nil or boss == 0 then
        return
    end
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local hp = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * config["生命倍率"]
    local damage = _____8BFB_53D6_7CBE_7075_7BAD_9635Boss_653B_51FB_529B(boss) * config["伤害倍率"]
    local spawnDistance = config["出生距离"] > 360 and 360 or config["出生距离"]
    local offsets = {{spawnDistance, 0}, {-spawnDistance, 0}, {0, spawnDistance}, {0, -spawnDistance}}
    do
        local i = 0
        while i < config["数量"] do
            local offset = offsets[i % #offsets + 1]
            local summonX = x + offset[1]
            local summonY = y + offset[2]
            _____64AD_653E_51FA_751F_7279_6548(summonX, summonY)
            local summon = _____521B_5EFA_53EC_5524_7269({
                ["主人单位"] = boss,
                ["单位类型"] = config["单位类型"],
                ["单位名称"] = config["单位名称"],
                ["模型文件"] = config["模型文件"],
                X = summonX,
                Y = summonY,
                ["持续时间"] = config["持续秒"],
                ["生命值"] = hp,
                ["生命值受小怪倍率"] = false,
                ["飞行高度"] = 10
            })
            if summon ~= nil and summon ~= 0 then
                _____6CE8_518C_7AD9_6869_5F39_5E55_5C04_51FB_5355_4F4D({
                    ["射手单位"] = summon,
                    ["来源单位"] = boss,
                    ["持续秒"] = config["持续秒"],
                    ["攻击间隔秒"] = config["攻击间隔秒"],
                    ["出手延迟秒"] = config["出手延迟秒"],
                    ["伤害值"] = damage,
                    ["弹道模型"] = config["弹道模型"],
                    ["弹道速度"] = config["弹道速度"],
                    ["命中半径"] = config["弹幕命中半径"],
                    ["最大飞行距离"] = config["弹幕最大飞行距离"],
                    ["飞行高度"] = config["弹幕飞行高度"],
                    ["起射偏移"] = config["弹幕起射偏移"],
                    ["弹道缩放"] = config["弹道缩放"],
                    ["攻击动画名"] = "attack",
                    ["攻击动画速度"] = config["攻击动画速度"],
                    ["选择目标"] = _____9009_62E9_7CBE_7075_7BAD_9635_5C04_51FB_76EE_6807
                })
            end
            i = i + 1
        end
    end
end
____exports["释放瑟兰迪尔精灵箭阵"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["精灵箭阵"]
    local boss = context["Boss单位"]
    if boss == nil or boss == 0 then
        return
    end
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["施法动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "精灵箭阵")
        end,
        ["on生效"] = function()
            _____521B_5EFA_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635_53EC_5524_7269(boss)
        end
    })
end
function ____on_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____7CBE_7075_7BAD_9635_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放瑟兰迪尔精灵箭阵"](context)
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
_____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_2["读取单位攻击力"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_3["启动基础施法时间线"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.25．站桩弹幕射击单位.01．站桩弹幕射击单位")
_____6CE8_518C_7AD9_6869_5F39_5E55_5C04_51FB_5355_4F4D = ____require_result_4["注册站桩弹幕射击单位"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex = ____require_result_5["获取Boss技能最近敌对英雄Ex"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
getBuffRuntime = ____require_result_6.getBuffRuntime
local jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local AddSpecialEffect = jass.AddSpecialEffect
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
_____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____7CBE_7075_7BAD_9635_6280_80FDID = stringToFourCC(_____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["精灵箭阵"]["技能槽位"])
local _____7CBE_7075_7BAD_9635_5DF2_6CE8_518C = false
____exports["注册瑟兰迪尔精灵箭阵"] = function()
    if _____7CBE_7075_7BAD_9635_5DF2_6CE8_518C then
        return
    end
    _____7CBE_7075_7BAD_9635_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "瑟兰迪尔精灵箭阵",
        ["单位类型ID"] = _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7CBE_7075_7BAD_9635_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635_751F_6548(boss, _____7CBE_7075_7BAD_9635_6280_80FDID)
        end
    })
end
return ____exports
