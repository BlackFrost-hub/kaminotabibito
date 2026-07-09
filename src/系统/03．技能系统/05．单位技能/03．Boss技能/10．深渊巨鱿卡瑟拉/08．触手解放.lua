--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____5237_65B0_5361_745F_62C9_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新卡瑟拉阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local _____5361_745F_62C9_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉音效配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local ShowUnit = jass.ShowUnit
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_2["创建可攻击机制单位"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____4E34_65F6_8C03_6574_62A4_7532 = ____require_result_3["临时调整护甲"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____7533_8BF7_5355_4F4D_6682_505C_5360_7528 = ____require_result_4["申请单位暂停占用"]
local _____91CA_653E_5355_4F4D_6682_505C_5360_7528 = ____require_result_4["释放单位暂停占用"]
local _____5361_745F_62C9_89E6_624B_89E3_653E_6682_505C_6765_6E90 = "Boss:Kasela:触手解放"
local function _____6CBB_7597Boss_6700_5927_751F_547D_6BD4_4F8B(boss, ratio)
    if not _____5355_4F4D_6709_6548(boss) or not (ratio > 0) then
        return
    end
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    local life = GetUnitState(boss, UNIT_STATE_LIFE)
    local next = life + maxLife * ratio
    SetUnitState(boss, UNIT_STATE_LIFE, next > maxLife and maxLife or next)
end
local function _____64AD_653E_6F5C_5165_7279_6548(x, y)
    local model = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手解放"]["潜入特效路径"]
    if model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    DestroyEffect(effect)
end
local function _____56DE_5F52_5361_745F_62C9(data, success)
    if data["已结束"] then
        return
    end
    data["已结束"] = true
    local context = data.context
    local boss = context["Boss单位"]
    context["Boss潜入中"] = false
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    ShowUnit(boss, true)
    _____91CA_653E_5355_4F4D_6682_505C_5360_7528(boss, _____5361_745F_62C9_89E6_624B_89E3_653E_6682_505C_6765_6E90)
    _____64AD_653E_6F5C_5165_7279_6548(
        GetUnitX(boss),
        GetUnitY(boss)
    )
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手解放"]
    if success then
        _____64AD_653EBoss_5750_6807_97F3_6548(
            _____5361_745F_62C9_97F3_6548_914D_7F6E["触手解放"]["成功破甲"],
            GetUnitX(boss),
            GetUnitY(boss),
            _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"]
        )
        local armorDown = data["击破数量"] * cfg["每条破甲比例"] * 100
        if armorDown > 0 then
            _____4E34_65F6_8C03_6574_62A4_7532(boss, -armorDown)
        end
    else
        _____64AD_653EBoss_5750_6807_97F3_6548(
            _____5361_745F_62C9_97F3_6548_914D_7F6E["触手解放"]["失败回血"],
            GetUnitX(boss),
            GetUnitY(boss),
            _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"]
        )
        _____6CBB_7597Boss_6700_5927_751F_547D_6BD4_4F8B(boss, cfg["失败回血比例"])
    end
end
local function ____on_5DE8_578B_89E6_624B_6B7B_4EA1(data)
    if data["已结束"] then
        return
    end
    data["击破数量"] = data["击破数量"] + 1
    if data["击破数量"] >= data["总数量"] then
        _____56DE_5F52_5361_745F_62C9(data, true)
    end
end
local function _____521B_5EFA_5DE8_578B_89E6_624B(data, angle)
    local context = data.context
    local boss = context["Boss单位"]
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手解放"]
    local x = _____6781_5750_6807X(
        GetUnitX(boss),
        angle,
        650
    )
    local y = _____6781_5750_6807Y(
        GetUnitY(boss),
        angle,
        650
    )
    _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "卡瑟拉-解放巨型触手",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = "hfoo",
        ["模型路径"] = cfg["巨型触手模型路径"],
        X = x,
        Y = y,
        ["朝向"] = angle + 180,
        ["最大生命"] = cfg["巨型触手生命值"],
        ["缩放"] = cfg["巨型触手缩放"],
        ["持续时间"] = cfg["限时秒"] + 2,
        ["on死亡"] = function()
            ____on_5DE8_578B_89E6_624B_6B7B_4EA1(data)
        end
    })
end
____exports["尝试触发卡瑟拉触手解放"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    if context["触手解放已触发"] or context["Boss潜入中"] then
        return
    end
    if _____5237_65B0_5361_745F_62C9_9636_6BB5(context) < 3 then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手解放"]
    context["触手解放已触发"] = true
    context["Boss潜入中"] = true
    _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "触手解放")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5361_745F_62C9_97F3_6548_914D_7F6E["触手解放"]["Boss下潜"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["标识"],
        ["音效路径列表"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["音效路径列表"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["裁断距离"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"],
        ["冷却Ms"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["转阶段触发概率百分比"]
    })
    _____64AD_653E_6F5C_5165_7279_6548(
        GetUnitX(boss),
        GetUnitY(boss)
    )
    ShowUnit(boss, false)
    _____7533_8BF7_5355_4F4D_6682_505C_5360_7528(boss, _____5361_745F_62C9_89E6_624B_89E3_653E_6682_505C_6765_6E90)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "双环",
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["半径"] = 720,
        ["持续时间"] = cfg["限时秒"],
        ["来源单位"] = boss
    })
    local data = {context = context, ["已结束"] = false, ["击破数量"] = 0, ["总数量"] = cfg["触手数量"]}
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5361_745F_62C9_97F3_6548_914D_7F6E["触手解放"]["巨型触手出水"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    do
        local i = 0
        while i < cfg["触手数量"] do
            _____521B_5EFA_5DE8_578B_89E6_624B(data, i * 90)
            i = i + 1
        end
    end
    local id = addDelayedCallback(
        cfg["限时秒"] * 1000,
        function()
            if not data["已结束"] then
                _____56DE_5F52_5361_745F_62C9(data, false)
            end
        end
    )
    local ____self_5 = context["清理"]
    ____self_5["登记延迟回调"](____self_5, "卡瑟拉-触手解放限时", id)
end
____exports["注册卡瑟拉触手解放"] = function()
end
return ____exports
