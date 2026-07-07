--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.01．场地配置")
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3_914D_7F6E = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心配置"]
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心X"]
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心Y"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚腐化感染配置"]
local _____7C73_4E9A_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚音效配置"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_3["创建召唤物"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_4["开始硬直"]
local ____require_result_5 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761 = ____require_result_5["显示致命惩罚吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_5["关闭吟唱条"]
local ____require_result_6 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_6["广播单位提示"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_7["创建循环点特效"]
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_8.X_FixUnitStandingSafe
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local KillUnit = jass.KillUnit
local RemoveUnit = jass.RemoveUnit
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____7EC8_6781_6C61_67D3_6838_5FC3_4E0A_4E0B_6587_8868 = {}
local _____7C73_4E9A_7EC8_6781_6C61_67D3_5DF2_6CE8_518C = false
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
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
        ["缩放"] = 1.6,
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
        ["缩放"] = 1.2,
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
local function _____521B_5EFA_7EC8_6781_6C61_67D3_6838_5FC3(context, point, hp)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    local core = _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = context["Boss单位"],
        ["所属玩家"] = GetOwningPlayer(context["Boss单位"]),
        ["单位类型"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["腐化核心单位ID"],
        ["单位名称"] = "终极污染核心",
        ["模型文件"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["终极污染核心模型"],
        X = point.x,
        Y = point.y,
        ["持续时间"] = config["引导秒"] + 2,
        ["飞行高度"] = config["核心浮空高度"],
        ["生命值"] = hp,
        ["生命值受小怪倍率"] = false,
        ["攻击力"] = 0,
        ["攻击范围"] = 0,
        ["索敌范围"] = 0,
        ["缩放"] = config["核心缩放"]
    })
    if not _____5355_4F4D_6709_6548(core) then
        return core
    end
    X_FixUnitStandingSafe(core)
    local id = _____53D6_5355_4F4DID(core)
    if id ~= 0 then
        _____7EC8_6781_6C61_67D3_6838_5FC3_4E0A_4E0B_6587_8868[id] = context
    end
    local ____context__7EC8_6781_6C61_67D3_6838_5FC3_5217_8868_9 = context["终极污染核心列表"]
    ____context__7EC8_6781_6C61_67D3_6838_5FC3_5217_8868_9[#____context__7EC8_6781_6C61_67D3_6838_5FC3_5217_8868_9 + 1] = core
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
            return context["终极污染引导中"] and _____5355_4F4D_6709_6548(core)
        end
    })
    return core
end
local function _____521B_5EFA_7EC8_6781_6C61_67D3_6838_5FC3_7EC4(context)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    local maxLife = GetUnitState(context["Boss单位"], UNIT_STATE_MAX_LIFE)
    local hp = maxLife * config["核心生命Boss最大生命比例"]
    local points = _____53D6_6838_5FC3_51FA_751F_70B9_8868()
    local count = config["核心数量"] < #points and config["核心数量"] or #points
    context["终极污染核心列表"] = {}
    do
        local i = 0
        while i < count do
            _____521B_5EFA_7EC8_6781_6C61_67D3_6838_5FC3(context, points[i + 1], hp)
            i = i + 1
        end
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(context["Boss单位"], "打碎所有腐化核心，打断终极污染！", 4200)
    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 2)
end
local function _____8BB0_5F55_7EC8_6781_6C61_67D3_53E0_5C42(context, target, count)
    local id = _____53D6_5355_4F4DID(target)
    if id == 0 then
        return
    end
    context["终极污染本次叠层表"][id] = (context["终极污染本次叠层表"][id] or 0) + count
end
local function _____6E05_9000_7EC8_6781_6C61_67D3_672C_6B21_53E0_5C42(context)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            local hero = heroes[i + 1]
            local id = _____53D6_5355_4F4DID(hero)
            local count = context["终极污染本次叠层表"][id] or 0
            if count > 0 then
                local ____self_10 = context["腐化层数控制器"]
                ____self_10["减少"](____self_10, hero, count, "终极污染打断清退")
            end
            i = i + 1
        end
    end
    context["终极污染本次叠层表"] = {}
end
local function _____6E05_7406_7EC8_6781_6C61_67D3_6838_5FC3(context)
    local cores = context["终极污染核心列表"]
    do
        local i = 0
        while i < #cores do
            local core = cores[i + 1]
            local id = _____53D6_5355_4F4DID(core)
            if id ~= 0 then
                _____7EC8_6781_6C61_67D3_6838_5FC3_4E0A_4E0B_6587_8868[id] = nil
            end
            if _____5355_4F4D_6709_6548(core) then
                RemoveUnit(core)
            end
            i = i + 1
        end
    end
    context["终极污染核心列表"] = {}
end
____exports["清理米亚终极污染"] = function(context)
    context["终极污染引导中"] = false
    context["终极污染开始Ms"] = 0
    context["终极污染结束Ms"] = 0
    _____6E05_7406_7EC8_6781_6C61_67D3_6838_5FC3(context)
    context["终极污染本次叠层表"] = {}
    _____5173_95ED_541F_5531_6761("致命惩罚")
end
local function _____7EC8_6781_6C61_67D3_662F_5426_5168_90E8_6838_5FC3_6B7B_4EA1(context)
    local cores = context["终极污染核心列表"]
    if #cores <= 0 then
        return false
    end
    do
        local i = 0
        while i < #cores do
            if _____5355_4F4D_6709_6548(cores[i + 1]) then
                return false
            end
            i = i + 1
        end
    end
    return true
end
local function _____6253_65AD_7EC8_6781_6C61_67D3(context)
    if not context["终极污染引导中"] then
        return
    end
    context["终极污染引导中"] = false
    _____5173_95ED_541F_5531_6761("致命惩罚")
    _____6E05_9000_7EC8_6781_6C61_67D3_672C_6B21_53E0_5C42(context)
    _____6E05_7406_7EC8_6781_6C61_67D3_6838_5FC3(context)
    if _____5355_4F4D_6709_6548(context["Boss单位"]) then
        SetUnitTimeScale(context["Boss单位"], 1)
        _____5F00_59CB_786C_76F4(context["Boss单位"], _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]["打断Boss虚弱秒"])
        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 8)
    end
end
local function _____7EC8_6781_6C61_67D3_6838_5FC3_6B7B_4EA1(dyingUnit, _killingUnit)
    local id = _____53D6_5355_4F4DID(dyingUnit)
    if id == 0 then
        return
    end
    local context = _____7EC8_6781_6C61_67D3_6838_5FC3_4E0A_4E0B_6587_8868[id]
    if context == nil then
        return
    end
    _____7EC8_6781_6C61_67D3_6838_5FC3_4E0A_4E0B_6587_8868[id] = nil
    if not context["终极污染引导中"] then
        return
    end
    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 6)
    if _____7EC8_6781_6C61_67D3_662F_5426_5168_90E8_6838_5FC3_6B7B_4EA1(context) then
        _____6253_65AD_7EC8_6781_6C61_67D3(context)
        return
    end
    local alive = 0
    do
        local i = 0
        while i < #context["终极污染核心列表"] do
            if _____5355_4F4D_6709_6548(context["终极污染核心列表"][i + 1]) then
                alive = alive + 1
            end
            i = i + 1
        end
    end
    if alive == 1 then
        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 7)
    end
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
                    goto __continue49
                end
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, hero, config["每秒全场腐化层数"], "终极污染引导")
                _____8BB0_5F55_7EC8_6781_6C61_67D3_53E0_5C42(context, hero, config["每秒全场腐化层数"])
            end
            ::__continue49::
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
    SetUnitTimeScale(context["Boss单位"], 1)
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
                    goto __continue54
                end
                local ____self_11 = context["腐化层数控制器"]
                ____self_11["设置"](____self_11, hero, _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E["最大层数"], "终极污染完成")
                if GetUnitState(hero, UNIT_STATE_LIFE) > 0 then
                    KillUnit(hero)
                end
            end
            ::__continue54::
            i = i + 1
        end
    end
    context["终极污染本次叠层表"] = {}
end
local function _____5B89_6392_7EC8_6781_6C61_67D3_65F6_70B9(context)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    SetUnitTimeScale(context["Boss单位"], 1)
    SetUnitAnimationByIndex(context["Boss单位"], 5)
    addDelayedCallback(
        3330,
        function()
            if not context["终极污染引导中"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                return
            end
            SetUnitTimeScale(context["Boss单位"], 1)
            SetUnitAnimationByIndex(context["Boss单位"], 5)
        end
    )
    addDelayedCallback(
        6660,
        function()
            if not context["终极污染引导中"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                return
            end
            SetUnitTimeScale(context["Boss单位"], 1)
            SetUnitAnimationByIndex(context["Boss单位"], 5)
        end
    )
    do
        local i = 1
        while i <= config["引导秒"] do
            addDelayedCallback(
                i * 1000,
                function()
                    _____7EC8_6781_6C61_67D3_6BCF_79D2_53E0_5C42(context)
                end
            )
            i = i + 1
        end
    end
    addDelayedCallback(
        2000,
        function()
            if context["终极污染引导中"] then
                _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 3)
            end
        end
    )
    addDelayedCallback(
        4000,
        function()
            if context["终极污染引导中"] then
                _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 4)
            end
        end
    )
    addDelayedCallback(
        6000,
        function()
            if context["终极污染引导中"] then
                _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 5)
            end
        end
    )
    addDelayedCallback(
        config["引导秒"] * 1000,
        function()
            _____5B8C_6210_7EC8_6781_6C61_67D3(context)
        end
    )
end
local function _____542F_52A8_7EC8_6781_6C61_67D3(context)
    if context["终极污染引导中"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    context["终极污染引导中"] = true
    context["终极污染开始Ms"] = 0
    context["终极污染结束Ms"] = config["引导秒"] * 1000
    context["终极污染本次叠层表"] = {}
    _____5F00_59CB_786C_76F4(context["Boss单位"], config["引导秒"])
    _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761({["总时长"] = config["引导秒"], ["颜色ID"] = 4, ["标题文本"] = "终极污染", ["提示文本"] = "击碎全部腐化核心，否则全场腐化满层并死亡"})
    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "终极污染", 0)
    _____64AD_653E_7EC8_6781_6C61_67D3_5F15_5BFC_8868_73B0(context)
    _____521B_5EFA_7EC8_6781_6C61_67D3_6838_5FC3_7EC4(context)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____7C73_4E9A_97F3_6548_914D_7F6E["终极污染"]["开始引导"],
        _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
        _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
        _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5B89_6392_7EC8_6781_6C61_67D3_65F6_70B9(context)
end
____exports["注册米亚终极污染"] = function()
    if _____7C73_4E9A_7EC8_6781_6C61_67D3_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_7EC8_6781_6C61_67D3_5DF2_6CE8_518C = true
    registerDeathListener(_____7EC8_6781_6C61_67D3_6838_5FC3_6B7B_4EA1)
end
____exports["尝试触发米亚终极污染"] = function(context)
    if context["阶段"] ~= 3 or context["终极污染引导中"] then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    local trigger = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]["触发生命比例"]
    if not context["已触发终极污染30"] and ratio <= trigger[1] then
        context["已触发终极污染30"] = true
        _____542F_52A8_7EC8_6781_6C61_67D3(context)
        return
    end
    if not context["已触发终极污染15"] and ratio <= trigger[2] then
        context["已触发终极污染15"] = true
        _____542F_52A8_7EC8_6781_6C61_67D3(context)
    end
end
return ____exports
