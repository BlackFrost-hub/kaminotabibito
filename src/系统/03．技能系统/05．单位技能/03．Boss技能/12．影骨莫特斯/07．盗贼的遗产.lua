--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建影骨莫特斯上下文"]
local _____5237_65B0_5F71_9AA8_76D7_8D3C_9057_4EA7Buff = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新影骨盗贼遗产Buff"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯表现配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.08．台词播放")
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放影骨莫特斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local AddSpecialEffect = jass.AddSpecialEffect
local GetRandomInt = jass.GetRandomInt
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local GetPlayerState = jass.GetPlayerState
local SetPlayerState = jass.SetPlayerState
local PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_2["创建可攻击机制单位"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．物品技能工具")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_4["临时调整攻击"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.01．Boss.10．影骨莫特斯")
local _____5F71_9AA8_83AB_7279_65AFBuffID = ____require_result_7["影骨莫特斯BuffID"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local GS_Suspend = ____require_result_8.GS_Suspend
local _____5F71_9AA8_5355_4F4D_7C7B_578BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____76D7_8D3C_9057_4EA7_6280_80FDID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["盗贼的遗产"])
local _____5DF2_6CE8_518C_76D7_8D3C_9057_4EA7 = false
local function _____7ED9Boss_53E0_52A0_76D7_8D3C_9057_4EA7(context)
    context["已开启遗产宝箱数"] = context["已开启遗产宝箱数"] + 1
    local bonus = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["Boss单位"]) * _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["每个宝箱Boss攻击提高"]
    _____4E34_65F6_8C03_6574_653B_51FB(context["Boss单位"], bonus)
    _____5237_65B0_5F71_9AA8_76D7_8D3C_9057_4EA7Buff(context)
end
local function _____5B9D_7BB1_5956_52B1_91D1_5E01(opener)
    local owner = GetOwningPlayer(opener)
    local gold = GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD)
    SetPlayerState(
        owner,
        PLAYER_STATE_RESOURCE_GOLD,
        gold + GetRandomInt(180, 520)
    )
end
local function _____5B9D_7BB1_9677_9631(opener, x, y)
    if not _____5355_4F4D_6709_6548(opener) then
        return
    end
    AddSpecialEffect(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["宝箱出现"], x, y)
    local life = GetUnitState(opener, UNIT_STATE_LIFE)
    SetUnitState(opener, UNIT_STATE_LIFE, life > 300 and life - 300 or 1)
    GS_Suspend(opener, 1.5)
    registerManualBuff(
        opener,
        _____5F71_9AA8_83AB_7279_65AFBuffID["阴影陷阱眩晕"],
        1.5,
        1,
        {sourceName = "影骨-宝箱陷阱"}
    )
end
local function _____5F00_542F_5F71_9AA8_5B9D_7BB1(context, opener, x, y)
    _____7ED9Boss_53E0_52A0_76D7_8D3C_9057_4EA7(context)
    local roll = GetRandomInt(1, 100)
    if roll <= 30 then
        AddSpecialEffect(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["骸骨符咒拾取"], x, y)
    elseif roll <= 55 then
        if _____5355_4F4D_6709_6548(opener) then
            _____5B9D_7BB1_5956_52B1_91D1_5E01(opener)
        end
    elseif roll <= 90 then
        AddSpecialEffect(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["宝箱出现"], x, y)
    else
        _____5B9D_7BB1_9677_9631(opener, x, y)
    end
end
local function _____521B_5EFA_5F71_9AA8_5B9D_7BB1(context, index)
    local point = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["宝箱点"][index + 1]
    if point == nil then
        return
    end
    AddSpecialEffect(_____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["宝箱出现"], point.X, point.Y)
    _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "影骨-盗贼遗产宝箱",
        ["主人单位"] = context["Boss单位"],
        ["所属玩家"] = GetOwningPlayer(context["Boss单位"]),
        ["单位类型"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["宝箱单位类型"],
        ["模型路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["盗贼遗产宝箱"],
        X = point.X,
        Y = point.Y,
        ["朝向"] = point["朝向"],
        ["最大生命"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["宝箱生命值"],
        ["on死亡"] = function(_unit, killer)
            _____5F00_542F_5F71_9AA8_5B9D_7BB1(context, killer, point.X, point.Y)
        end
    })
end
local function _____91CA_653E_5F71_9AA8_76D7_8D3C_9057_4EA7(context)
    if context["遗产宝箱已生成"] then
        return
    end
    context["遗产宝箱已生成"] = true
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(context["Boss单位"], "盗贼的遗产")
    local count = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["宝箱数量"]
    do
        local i = 0
        while i < count do
            local id = addDelayedCallback(
                i * 500,
                function()
                    _____521B_5EFA_5F71_9AA8_5B9D_7BB1(context, i)
                end
            )
            local ____self_9 = context["清理"]
            ____self_9["登记延迟回调"](____self_9, "影骨-盗贼遗产宝箱", id)
            i = i + 1
        end
    end
end
local function ____on_5F71_9AA8_76D7_8D3C_9057_4EA7_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____76D7_8D3C_9057_4EA7_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5F71_9AA8_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context ~= nil then
        _____91CA_653E_5F71_9AA8_76D7_8D3C_9057_4EA7(context)
    end
end
____exports["注册影骨莫特斯盗贼的遗产"] = function()
    if _____5DF2_6CE8_518C_76D7_8D3C_9057_4EA7 then
        return
    end
    _____5DF2_6CE8_518C_76D7_8D3C_9057_4EA7 = true
    registerSpellEffectListener(____on_5F71_9AA8_76D7_8D3C_9057_4EA7_65BD_6CD5)
end
return ____exports
