--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯音效配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.16．灼热层数工具")
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177["施加巴尔扎罗斯灼热"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.index")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_2["创建可攻击机制单位"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.index")
local _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668 = ____require_result_3["创建血量节点触发器"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.03．Boss战场地点位")
local _____521B_5EFABoss_6218_573A_5730_70B9_4F4D_96C6 = ____require_result_4["创建Boss战场地点位集"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_6.addPeriodicCallback
local removePeriodicCallback = ____require_result_6.removePeriodicCallback
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local CreateItem = jass.CreateItem
local Player = jass.Player
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local EXSetEffectZ = japi.EXSetEffectZ
local EXSetEffectSize = japi.EXSetEffectSize
local function _____53D6_573A_5730_4E2D_5FC3(context)
    local boss = context["Boss单位"]
    local points = _____521B_5EFABoss_6218_573A_5730_70B9_4F4D_96C6(
        context["战斗区域组"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    local center = points["取中心"](points)
    return {X = center.X, Y = center.Y}
end
local function _____64AD_653E_5730_6838Tick_7279_6548(x, y)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["地核召唤"]
    local paths = {config["Tick冲击波路径"], config["Tick叠加冲击波路径"]}
    do
        local i = 0
        while i < #paths do
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = paths[i + 1],
                X = x,
                Y = y,
                Z = config["Tick特效高度"],
                ["缩放"] = config["Tick特效缩放"],
                ["持续秒"] = config["Tick特效持续秒"]
            })
            i = i + 1
        end
    end
end
local function _____5730_6838_53E0_52A0_5168_573A_707C_70ED(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            local hero = heroes[i + 1]
            if _____5355_4F4D_6709_6548(hero) then
                _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(hero, _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["地核召唤"]["Tick灼热层数"])
            end
            i = i + 1
        end
    end
end
local function _____6389_843D_51B7_5374_6C34_6676(x, y)
    local itemId = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["地核召唤"]["冷却水晶物品ID"])
    if itemId <= 0 then
        return
    end
    CreateItem(itemId, x, y)
end
local function _____505C_6B62_5730_6838(state)
    if state.stopped then
        return
    end
    state.stopped = true
    if state.tickId ~= 0 then
        removePeriodicCallback(state.tickId)
        state.tickId = 0
    end
end
local function ____on_5730_6838Tick(state)
    if state.stopped then
        return
    end
    local core = state.coreUnit
    if not _____5355_4F4D_6709_6548(core) then
        _____505C_6B62_5730_6838(state)
        return
    end
    _____64AD_653E_5730_6838Tick_7279_6548(
        GetUnitX(core),
        GetUnitY(core)
    )
    _____5730_6838_53E0_52A0_5168_573A_707C_70ED(state.context)
end
local function _____521B_5EFA_5730_6838_5355_4F4D(context, x, y)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["地核召唤"]
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    local state = {context = context, coreUnit = nil, tickId = 0, stopped = false}
    local core = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "巴尔扎罗斯-不稳定地核",
        ["主人单位"] = boss,
        ["所属玩家"] = Player(PLAYER_NEUTRAL_AGGRESSIVE),
        ["单位类型"] = config["地核单位ID"],
        ["单位名称"] = config["地核单位名称"],
        ["模型路径"] = config["地核模型路径"],
        X = x,
        Y = y,
        ["最大生命"] = maxLife * config["地核生命Boss最大生命比例"],
        ["生命值受小怪倍率"] = false,
        ["飞行高度"] = config["地核飞行高度"],
        ["缩放"] = config["地核缩放"],
        ["on死亡"] = function(_____5355_4F4D)
            _____505C_6B62_5730_6838(state)
            _____6389_843D_51B7_5374_6C34_6676(
                GetUnitX(_____5355_4F4D),
                GetUnitY(_____5355_4F4D)
            )
        end
    })
    if core == nil or not _____5355_4F4D_6709_6548(core["单位"]) then
        return
    end
    state.coreUnit = core["单位"]
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["地核召唤"]["地核出现"], x, y, _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    state.tickId = addPeriodicCallback(
        config["Tick秒"] * 1000,
        function()
            ____on_5730_6838Tick(state)
        end
    )
    local ____self_8 = context["清理"]
    ____self_8["登记周期回调"](____self_8, "巴尔扎罗斯-地核Tick", state.tickId)
end
____exports["释放巴尔扎罗斯地核召唤"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["地核召唤"]
    local center = _____53D6_573A_5730_4E2D_5FC3(context)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = center.X,
        Y = center.Y,
        ["半径"] = config["预警半径"],
        ["持续时间"] = config["施法硬直秒"],
        ["来源单位"] = boss
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = center.X,
        ["目标Y"] = center.Y,
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "大招",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "地核召唤")
        end,
        ["on生效"] = function()
            _____521B_5EFA_5730_6838_5355_4F4D(context, center.X, center.Y)
        end
    })
end
____exports["初始化巴尔扎罗斯地核召唤节点"] = function(context)
    if context["地核召唤节点已初始化"] then
        return
    end
    context["地核召唤节点已初始化"] = true
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["地核召唤"]
    _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668({
        ["清理"] = context["清理"],
        ["名称"] = "巴尔扎罗斯-地核召唤血量节点",
        ["单位"] = context["Boss单位"],
        ["节点列表"] = {
            {
                ID = "地核召唤-70",
                ["百分比"] = config["触发生命比例"][1],
                ["on触发"] = function()
                    ____exports["释放巴尔扎罗斯地核召唤"](context)
                end
            },
            {
                ID = "地核召唤-40",
                ["百分比"] = config["触发生命比例"][2],
                ["on触发"] = function()
                    ____exports["释放巴尔扎罗斯地核召唤"](context)
                end
            }
        }
    })
end
____exports["注册巴尔扎罗斯地核召唤"] = function()
end
return ____exports
