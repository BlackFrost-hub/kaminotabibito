--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____6E05_9000_7EC8_6781_6C61_67D3_672C_6B21_53E0_5C42, _____6E05_7406_7EC8_6781_6C61_67D3_6838_5FC3, _____6267_884C_7EC8_6781_6C61_67D3_6253_65AD, _____6253_65AD_7EC8_6781_6C61_67D3, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____5F00_59CB_786C_76F4, _____5173_95ED_541F_5531_6761, SetUnitTimeScale
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置")
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3_914D_7F6E = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心配置"]
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心X"]
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心Y"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚腐化感染配置"]
local _____7C73_4E9A_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚音效配置"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
local ____02_FF0E_9650_65F6_6467_6BC1_76EE_6807_7EC4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.02．限时摧毁目标组")
local _____521B_5EFA_9650_65F6_6467_6BC1_76EE_6807_7EC4 = ____02_FF0E_9650_65F6_6467_6BC1_76EE_6807_7EC4["创建限时摧毁目标组"]
function _____6E05_9000_7EC8_6781_6C61_67D3_672C_6B21_53E0_5C42(context)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            local hero = heroes[i + 1]
            local id = _____53D6_5355_4F4DID(hero)
            local count = context["终极污染本次叠层表"][id] or 0
            if count > 0 then
                local ____self_7 = context["腐化层数控制器"]
                ____self_7["减少"](____self_7, hero, count, "终极污染打断清退")
            end
            i = i + 1
        end
    end
    context["终极污染本次叠层表"] = {}
end
function _____6E05_7406_7EC8_6781_6C61_67D3_6838_5FC3(context)
    local _____6838_5FC3_7EC4 = context["终极污染核心组"]
    context["终极污染核心组"] = nil
    if _____6838_5FC3_7EC4 ~= nil then
        _____6838_5FC3_7EC4["结束"](_____6838_5FC3_7EC4, false, "机制清理")
    end
end
function _____6267_884C_7EC8_6781_6C61_67D3_6253_65AD(context)
    if not context["终极污染引导中"] then
        return
    end
    context["终极污染引导中"] = false
    _____5173_95ED_541F_5531_6761("致命惩罚")
    _____6E05_9000_7EC8_6781_6C61_67D3_672C_6B21_53E0_5C42(context)
    _____6E05_7406_7EC8_6781_6C61_67D3_6838_5FC3(context)
    if _____5355_4F4D_6709_6548(context["Boss单位"]) then
        SetUnitTimeScale(context["Boss单位"], _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]["恢复动画速度"])
        _____5F00_59CB_786C_76F4(context["Boss单位"], _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]["打断Boss虚弱秒"])
        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 8)
    end
end
function _____6253_65AD_7EC8_6781_6C61_67D3(context)
    if not context["终极污染引导中"] then
        return
    end
    local ____opt_10 = context["终极污染组合执行器"]
    if (____opt_10 and ____opt_10["停止"](____opt_10, nil, "中断")) == true then
        return
    end
    _____6267_884C_7EC8_6781_6C61_67D3_6253_65AD(context)
end
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_0["获取Boss技能敌对英雄列表"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local ____require_result_2 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761 = ____require_result_2["显示致命惩罚吟唱条"]
_____5173_95ED_541F_5531_6761 = ____require_result_2["关闭吟唱条"]
local ____require_result_3 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_3["广播单位提示"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_4["创建循环点特效"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local KillUnit = jass.KillUnit
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local function _____53D6_6838_5FC3_51FA_751F_70B9_8868()
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    local inset = config["核心内缩距离"]
    local platform = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3_914D_7F6E()
    return {{x = platform["左"] + inset, y = platform["下"] + inset}, {x = platform["右"] - inset, y = platform["下"] + inset}, {x = platform["左"] + inset, y = platform["上"] - inset}, {x = platform["右"] - inset, y = platform["上"] - inset}}
end
local function _____64AD_653E_7EC8_6781_6C61_67D3_5F15_5BFC_8868_73B0(context)
    local boss = context["Boss单位"]
    local seconds = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]["引导秒"]
    _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["终极污染Boss引导"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        Z = 20,
        ["缩放"] = 3.2,
        ["总持续秒"] = seconds,
        ["重建间隔秒"] = 3,
        ["单次持续秒"] = 2.9,
        ["存活条件"] = function()
            return context["终极污染引导中"] and _____5355_4F4D_6709_6548(context["Boss单位"])
        end
    })
    _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["终极污染中心柱"],
        X = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
        Y = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
        Z = 0,
        ["缩放"] = 2.4,
        ["总持续秒"] = seconds,
        ["重建间隔秒"] = 3,
        ["单次持续秒"] = 2.9,
        ["存活条件"] = function()
            return context["终极污染引导中"] and _____5355_4F4D_6709_6548(context["Boss单位"])
        end
    })
    _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = "war3mapImported\\[ake]gaopin.mdx",
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        Z = 80,
        ["缩放"] = 1.1,
        ["总持续秒"] = seconds,
        ["重建间隔秒"] = 3,
        ["单次持续秒"] = 2.9,
        ["存活条件"] = function()
            return context["终极污染引导中"] and _____5355_4F4D_6709_6548(context["Boss单位"])
        end
    })
end
local function _____521B_5EFA_7EC8_6781_6C61_67D3_6838_5FC3_7EC4(context)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    local maxLife = GetUnitStateJapi(context["Boss单位"], UNIT_STATE_MAX_LIFE)
    local hp = maxLife * config["核心生命Boss最大生命比例"]
    local points = _____53D6_6838_5FC3_51FA_751F_70B9_8868()
    local count = config["核心数量"] < #points and config["核心数量"] or #points
    local _____76EE_6807_5217_8868 = {}
    do
        local i = 0
        while i < count do
            local point = points[i + 1]
            _____76EE_6807_5217_8868[#_____76EE_6807_5217_8868 + 1] = {
                ["主人单位"] = context["Boss单位"],
                ["所属玩家"] = GetOwningPlayer(context["Boss单位"]),
                ["单位类型"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["腐化核心单位ID"],
                ["单位名称"] = "米亚腐化核心",
                ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["终极污染核心模型"],
                X = point.x,
                Y = point.y,
                ["持续时间"] = config["引导秒"] + 2,
                ["飞行高度"] = config["核心浮空高度"],
                ["生命值"] = hp,
                ["生命值受小怪倍率"] = false,
                ["固定站桩"] = true,
                ["禁止普攻"] = true,
                ["攻击范围"] = 0,
                ["索敌范围"] = 0,
                ["缩放"] = config["核心缩放"]
            }
            i = i + 1
        end
    end
    local _____6838_5FC3_7EC4 = _____521B_5EFA_9650_65F6_6467_6BC1_76EE_6807_7EC4({
        ["名称"] = "米亚-终极污染核心组",
        ["清理"] = context["清理"],
        ["持续秒"] = config["引导秒"],
        ["目标列表"] = _____76EE_6807_5217_8868,
        ["on目标结束"] = function(______76EE_6807, _____539F_56E0)
            if not context["终极污染引导中"] then
                return
            end
            if _____539F_56E0 == "被击杀" or _____539F_56E0 == "自然到期" then
                _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 6)
            end
            local ____temp_6 = context["终极污染核心组"] ~= nil
            if ____temp_6 then
                local ____self_5 = context["终极污染核心组"]
                ____temp_6 = ____self_5["取剩余数量"](____self_5) == 1
            end
            if ____temp_6 then
                _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 7)
            end
        end,
        ["on全部摧毁"] = function()
            _____6253_65AD_7EC8_6781_6C61_67D3(context)
        end
    })
    context["终极污染核心组"] = _____6838_5FC3_7EC4
    do
        local i = 0
        while i < #_____6838_5FC3_7EC4["目标单位列表"] do
            local core = _____6838_5FC3_7EC4["目标单位列表"][i + 1]
            local point = points[i + 1]
            _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
                ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["终极污染核心附着"],
                X = point.x,
                Y = point.y,
                Z = config["核心浮空高度"],
                ["缩放"] = 1,
                ["总持续秒"] = config["引导秒"],
                ["重建间隔秒"] = 1,
                ["单次持续秒"] = 0.9,
                ["存活条件"] = function()
                    return context["终极污染引导中"] and core["是否存活"](core)
                end
            })
            i = i + 1
        end
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(
        context["Boss单位"],
        ((((((("终极污染开始，引导" .. tostring(config["引导秒"])) .. "秒，每秒全场增加") .. tostring(config["每秒全场腐化层数"])) .. "层腐化感染（") .. tostring(config["引导秒"])) .. "秒内击破全部") .. tostring(config["核心数量"])) .. "个腐化核心即可打断！）",
        4200
    )
    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 2)
end
local function _____8BB0_5F55_7EC8_6781_6C61_67D3_53E0_5C42(context, target, count)
    local id = _____53D6_5355_4F4DID(target)
    if id == 0 then
        return
    end
    context["终极污染本次叠层表"][id] = (context["终极污染本次叠层表"][id] or 0) + count
end
____exports["清理米亚终极污染"] = function(context)
    context["终极污染引导中"] = false
    local ____opt_8 = context["终极污染组合执行器"]
    if ____opt_8 ~= nil then
        ____opt_8["停止"](____opt_8, nil, "中断")
    end
    _____6E05_7406_7EC8_6781_6C61_67D3_6838_5FC3(context)
    context["终极污染本次叠层表"] = {}
    _____5173_95ED_541F_5531_6761("致命惩罚")
end
local function _____7EC8_6781_6C61_67D3_6BCF_79D2_53E0_5C42(context)
    if not context["终极污染引导中"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue36
                end
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, hero, config["每秒全场腐化层数"], "终极污染引导")
                _____8BB0_5F55_7EC8_6781_6C61_67D3_53E0_5C42(context, hero, config["每秒全场腐化层数"])
            end
            ::__continue36::
            i = i + 1
        end
    end
end
local function _____5B8C_6210_7EC8_6781_6C61_67D3(context)
    if not context["终极污染引导中"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    context["终极污染引导中"] = false
    _____5173_95ED_541F_5531_6761("致命惩罚")
    _____6E05_7406_7EC8_6781_6C61_67D3_6838_5FC3(context)
    SetUnitTimeScale(context["Boss单位"], _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]["恢复动画速度"])
    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 9)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____7C73_4E9A_97F3_6548_914D_7F6E["终极污染"]["引导完成"],
        _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
        _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
        _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["终极污染完成冲击"],
        X = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
        Y = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
        Z = 0,
        ["缩放"] = 4,
        ["持续秒"] = 2
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["终极污染完成毒爆"],
        X = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
        Y = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
        Z = 60,
        ["缩放"] = 1.5,
        ["持续秒"] = 2
    })
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue41
                end
                local ____self_12 = context["腐化层数控制器"]
                ____self_12["设置"](____self_12, hero, _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E["最大层数"], "终极污染完成")
                if GetUnitState(hero, UNIT_STATE_LIFE) > 0 then
                    KillUnit(hero)
                end
            end
            ::__continue41::
            i = i + 1
        end
    end
    context["终极污染本次叠层表"] = {}
end
local function _____521B_5EFA_7EC8_6781_6C61_67D3_65F6_95F4_8F74_4E8B_4EF6(context)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    local _____4E8B_4EF6_5217_8868 = {}
    do
        local _____79D2_6570 = 1
        while _____79D2_6570 <= config["引导秒"] do
            _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
                ["时点毫秒"] = _____79D2_6570 * 1000,
                ["名称"] = ("终极污染第" .. tostring(_____79D2_6570)) .. "秒叠层",
                ["执行"] = function()
                    _____7EC8_6781_6C61_67D3_6BCF_79D2_53E0_5C42(context)
                end
            }
            _____79D2_6570 = _____79D2_6570 + 1
        end
    end
    do
        local i = 0
        while i < #config["引导台词时点"] do
            local _____53F0_8BCD_4E8B_4EF6 = config["引导台词时点"][i + 1]
            _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
                ["时点毫秒"] = _____53F0_8BCD_4E8B_4EF6["时点Ms"],
                ["名称"] = "终极污染引导台词",
                ["执行"] = function()
                    if context["终极污染引导中"] then
                        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", _____53F0_8BCD_4E8B_4EF6["台词序号"])
                    end
                end
            }
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #config["动画重播时点Ms"] do
            _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
                ["时点毫秒"] = config["动画重播时点Ms"][i + 1],
                ["名称"] = "终极污染重播动作",
                ["执行"] = function()
                    if not context["终极污染引导中"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                        return
                    end
                    SetUnitTimeScale(context["Boss单位"], config["引导动画速度"])
                    SetUnitAnimationByIndex(context["Boss单位"], config["引导动画编号"])
                end
            }
            i = i + 1
        end
    end
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = config["引导秒"] * 1000,
        ["名称"] = "终极污染完成",
        ["执行"] = function()
            _____5B8C_6210_7EC8_6781_6C61_67D3(context)
        end
    }
    return _____4E8B_4EF6_5217_8868
end
local function _____542F_52A8_7EC8_6781_6C61_67D3_65F6_95F4_8F74(context)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    if context["终极污染组合执行器"] == nil then
        context["终极污染组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "米亚-终极污染", ["清理"] = context["清理"], ["互斥组"] = "米亚大型技能"})
    end
    local ____self_13 = context["终极污染组合执行器"]
    local _____6267_884CID = ____self_13["开始"](
        ____self_13,
        {
            key = "终极污染",
            ["单位"] = context["Boss单位"],
            ["上下文"] = context,
            ["最大持续毫秒"] = config["引导秒"] * 1000 + 1000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____521B_5EFA_7EC8_6781_6C61_67D3_65F6_95F4_8F74_4E8B_4EF6(context)),
            ["结束回调"] = function(event)
                if event["原因"] ~= "完成" and context["终极污染引导中"] then
                    _____6267_884C_7EC8_6781_6C61_67D3_6253_65AD(context)
                end
            end
        }
    )
    return _____6267_884CID ~= 0
end
local function _____542F_52A8_7EC8_6781_6C61_67D3(context)
    if context["终极污染引导中"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return false
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    if not _____542F_52A8_7EC8_6781_6C61_67D3_65F6_95F4_8F74(context) then
        return false
    end
    context["终极污染引导中"] = true
    context["终极污染本次叠层表"] = {}
    SetUnitTimeScale(context["Boss单位"], config["引导动画速度"])
    SetUnitAnimationByIndex(context["Boss单位"], config["引导动画编号"])
    _____5F00_59CB_786C_76F4(context["Boss单位"], config["引导秒"])
    _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761({
        ["总时长"] = config["引导秒"],
        ["颜色ID"] = 4,
        ["标题文本"] = "终极污染",
        ["提示文本"] = ((((("引导" .. tostring(config["引导秒"])) .. "秒，每秒全场增加") .. tostring(config["每秒全场腐化层数"])) .. "层腐化感染；击破全部") .. tostring(config["核心数量"])) .. "个核心即可打断（优先击破核心）。"
    })
    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 0)
    _____64AD_653E_7EC8_6781_6C61_67D3_5F15_5BFC_8868_73B0(context)
    _____521B_5EFA_7EC8_6781_6C61_67D3_6838_5FC3_7EC4(context)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____7C73_4E9A_97F3_6548_914D_7F6E["终极污染"]["开始引导"],
        _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
        _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
        _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    return true
end
____exports["触发米亚终极污染"] = function(context, _____9608_503C_5E8F_53F7)
    if context["阶段"] ~= 3 or context["终极污染引导中"] then
        return false
    end
    if _____9608_503C_5E8F_53F7 == 0 and context["已触发终极污染30"] then
        return false
    end
    if _____9608_503C_5E8F_53F7 == 1 and context["已触发终极污染15"] then
        return false
    end
    if not _____542F_52A8_7EC8_6781_6C61_67D3(context) then
        return false
    end
    if _____9608_503C_5E8F_53F7 == 0 then
        context["已触发终极污染30"] = true
    else
        context["已触发终极污染15"] = true
    end
    return true
end
return ____exports
