local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local _____5361_745F_62C9_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉音效配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____64AD_653E_5361_745F_62C9_9650_65F6_52A8_4F5C = ____14_FF0E_516C_5171_5DE5_5177["播放卡瑟拉限时动作"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____02_FF0E_9650_65F6_6467_6BC1_76EE_6807_7EC4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.02．限时摧毁目标组")
local _____521B_5EFA_9650_65F6_6467_6BC1_76EE_6807_7EC4 = ____02_FF0E_9650_65F6_6467_6BC1_76EE_6807_7EC4["创建限时摧毁目标组"]
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_0.doHeal
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local ShowUnit = jass.ShowUnit
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____4E34_65F6_8C03_6574_62A4_7532 = ____require_result_4["临时调整护甲"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_5["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_5["移除单位暂停"]
local ____require_result_6 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_6["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_6["关闭吟唱条"]
local _____5361_745F_62C9_89E6_624B_89E3_653E_6682_505C_6765_6E90 = "Boss:Kasela:触手解放"
local function _____6CBB_7597Boss_6700_5927_751F_547D_6BD4_4F8B(boss, ratio)
    if not _____5355_4F4D_6709_6548(boss) or not (ratio > 0) then
        return
    end
    doHeal({
        HealSource = boss,
        HealTarget = boss,
        HealAmount = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * ratio,
        ItemHeal = false,
        HealEffect = false
    })
end
local function _____64AD_653E_6F5C_5165_7279_6548(x, y)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手解放"]
    local model = cfg["潜入特效路径"]
    if model ~= "" then
        local effect = AddSpecialEffect(model, x, y)
        DestroyEffect(effect)
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["潜入回归能量爆闪特效模型路径"],
        X = x,
        Y = y,
        ["缩放"] = cfg["潜入回归叠加特效缩放"],
        ["持续秒"] = cfg["潜入回归叠加特效持续秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["潜入回归水柱特效模型路径"],
        X = x,
        Y = y,
        ["缩放"] = cfg["潜入回归叠加特效缩放"],
        ["持续秒"] = cfg["潜入回归叠加特效持续秒"]
    })
end
local function _____56DE_5F52_5361_745F_62C9(data, success)
    if data["已结束"] then
        return
    end
    data["已结束"] = true
    _____5173_95ED_541F_5531_6761("大招")
    local context = data.context
    local boss = context["Boss单位"]
    context["Boss潜入中"] = false
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    ShowUnit(boss, true)
    _____79FB_9664_5355_4F4D_6682_505C(boss, _____5361_745F_62C9_89E6_624B_89E3_653E_6682_505C_6765_6E90)
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
local function ____on_5DE8_578B_89E6_624B_76EE_6807_7ED3_675F(______76EE_6807, _____539F_56E0, _____53D8_91CF)
    local data = _____53D8_91CF
    if data == nil or data["已结束"] then
        return
    end
    if _____539F_56E0 ~= "机制清理" and _____539F_56E0 ~= "主动销毁" then
        data["击破数量"] = data["击破数量"] + 1
    end
end
local function ____on_5361_745F_62C9_89E6_624B_89E3_653E_76EE_6807_7EC4_7ED3_675F(_____662F_5426_6210_529F, ______5269_4F59_6570_91CF, _____53D8_91CF, _____539F_56E0)
    local data = _____53D8_91CF
    if data == nil or data["已结束"] then
        return
    end
    if _____539F_56E0 == "机制清理" or _____539F_56E0 == "主动结束" then
        data["已结束"] = true
        _____5173_95ED_541F_5531_6761("大招")
        data.context["Boss潜入中"] = false
        return
    end
    _____56DE_5F52_5361_745F_62C9(data, _____662F_5426_6210_529F)
end
local function _____521B_5EFA_5DE8_578B_89E6_624B_53C2_6570(context, angle)
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
    return {
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
        ["固定站桩"] = true,
        ["持续时间"] = cfg["限时秒"] + 2
    }
end
local function _____6267_884C_5361_745F_62C9_6F5C_5165_4E0E_89E6_624B_89E3_653E(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not context["Boss潜入中"] then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手解放"]
    _____64AD_653E_6F5C_5165_7279_6548(
        GetUnitX(boss),
        GetUnitY(boss)
    )
    ShowUnit(boss, false)
    _____6DFB_52A0_5355_4F4D_6682_505C(boss, _____5361_745F_62C9_89E6_624B_89E3_653E_6682_505C_6765_6E90)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "双环",
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["半径"] = 720,
        ["持续时间"] = cfg["限时秒"],
        ["来源单位"] = boss
    })
    _____663E_793A_5927_62DB_541F_5531_6761({["总时长"] = cfg["限时秒"], ["颜色ID"] = cfg["吟唱条颜色ID"], ["标题文本"] = cfg["吟唱条标题文本"], ["提示文本"] = cfg["吟唱条提示文本"]})
    local data = {context = context, ["已结束"] = false, ["击破数量"] = 0}
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5361_745F_62C9_97F3_6548_914D_7F6E["触手解放"]["巨型触手出水"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    local _____76EE_6807_5217_8868 = {}
    do
        local i = 0
        while i < cfg["触手数量"] do
            _____76EE_6807_5217_8868[#_____76EE_6807_5217_8868 + 1] = _____521B_5EFA_5DE8_578B_89E6_624B_53C2_6570(context, i * 90)
            i = i + 1
        end
    end
    local _____76EE_6807_7EC4 = _____521B_5EFA_9650_65F6_6467_6BC1_76EE_6807_7EC4({
        ["清理"] = context["清理"],
        ["名称"] = "卡瑟拉-触手解放巨型触手组",
        ["持续秒"] = cfg["限时秒"],
        ["目标列表"] = _____76EE_6807_5217_8868,
        ["变量"] = data,
        ["on目标结束"] = ____on_5DE8_578B_89E6_624B_76EE_6807_7ED3_675F,
        ["on结束"] = ____on_5361_745F_62C9_89E6_624B_89E3_653E_76EE_6807_7EC4_7ED3_675F
    })
    data["目标组"] = _____76EE_6807_7EC4
    local _____89E6_624B_7279_6548_914D_7F6E = {["模型路径"] = cfg["巨型触手出现特效模型路径"], ["缩放"] = cfg["巨型触手出现特效缩放"], ["持续秒"] = cfg["巨型触手出现特效持续秒"]}
    do
        local i = 0
        while i < #_____76EE_6807_7EC4["目标单位列表"] do
            do
                local _____76EE_6807 = _____76EE_6807_7EC4["目标单位列表"][i + 1]
                if not _____5355_4F4D_6709_6548(_____76EE_6807["单位"]) then
                    goto __continue24
                end
                _____521B_5EFA_70B9_7279_6548(__TS__ObjectAssign(
                    {},
                    _____89E6_624B_7279_6548_914D_7F6E,
                    {
                        X = GetUnitX(_____76EE_6807["单位"]),
                        Y = GetUnitY(_____76EE_6807["单位"])
                    }
                ))
            end
            ::__continue24::
            i = i + 1
        end
    end
end
____exports["触发卡瑟拉触手解放"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    if context["触手解放已触发"] or context["Boss潜入中"] then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手解放"]
    context["触手解放已触发"] = true
    context["Boss潜入中"] = true
    _____64AD_653E_5361_745F_62C9_9650_65F6_52A8_4F5C(boss, cfg["动画编号"], cfg["动画速度"], cfg["动作原始时长秒"])
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
    local _____6F5C_5165ID = addDelayedCallback(
        cfg["动作原始时长秒"] * 1000,
        function()
            _____6267_884C_5361_745F_62C9_6F5C_5165_4E0E_89E6_624B_89E3_653E(context)
        end
    )
    local ____self_7 = context["清理"]
    ____self_7["登记延迟回调"](____self_7, "卡瑟拉-触手解放潜入", _____6F5C_5165ID)
end
return ____exports
