--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 英雄技能记录测试
-- 
-- 输入 "1024"：
-- 1. 打印当前测试英雄的 Q/W/E/R/D 记录
-- 2. 给测试英雄挂一个 SPELL_EFFECT 监听
-- 3. 之后每次施法，打印本次技能与当前整套记录
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local fourCCTools = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToStringRaw = fourCCTools.fourCCToString
local heroSkillRecord = require("系统.03．技能系统.05．动态技能说明.05．英雄技能记录")
local commandBarAbility = require("系统.03．技能系统.05．动态技能说明.07．命令卡技能槽位")
local ydweAbility = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWEGetUnitAbilityDataString = ydweAbility.YDWEGetUnitAbilityDataString
local unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local _____6A21_5757_540D = "英雄技能记录测试"
local _____6D4B_8BD5_547D_4EE4 = "1024"
local _____5DF2_6CE8_518C_804A_5929 = false
local _____6280_80FD_76D1_542C_89E6_53D1_5668 = nil
local _____5DF2_6302_76D1_542C_82F1_96C4id = 0
local function _____53D6_6280_80FDrawcode_6587_672C(abilityId)
    if abilityId == 0 then
        return "0"
    end
    return fourCCToStringRaw(fourCCTools, abilityId)
end
local function _____53D6_6280_80FD_70ED_952E_6587_672C(whichHero, abilityId)
    if whichHero == nil or whichHero == 0 or abilityId == 0 then
        return "-"
    end
    return YDWEGetUnitAbilityDataString(
        nil,
        whichHero,
        abilityId,
        1,
        ydweAbility.ABILITY_DATA_HOTKEY
    ) or "-"
end
local function _____53D6_547D_4EE4_5361_69FD_4F4D_6280_80FD(x, y)
    return commandBarAbility["读取命令卡按钮能力Id"](x, y)
end
local function _____6253_5370_547D_4EE4_5361_69FD_4F4D()
    debugLogForce(
        _____6A21_5757_540D,
        "命令卡槽位：",
        "Q=",
        _____53D6_6280_80FDrawcode_6587_672C(_____53D6_547D_4EE4_5361_69FD_4F4D_6280_80FD(0, 2)),
        "W=",
        _____53D6_6280_80FDrawcode_6587_672C(_____53D6_547D_4EE4_5361_69FD_4F4D_6280_80FD(1, 2)),
        "E=",
        _____53D6_6280_80FDrawcode_6587_672C(_____53D6_547D_4EE4_5361_69FD_4F4D_6280_80FD(2, 2)),
        "R=",
        _____53D6_6280_80FDrawcode_6587_672C(_____53D6_547D_4EE4_5361_69FD_4F4D_6280_80FD(3, 2)),
        "D=",
        _____53D6_6280_80FDrawcode_6587_672C(_____53D6_547D_4EE4_5361_69FD_4F4D_6280_80FD(0, 1))
    )
end
local function _____6253_5370_5F53_524D_8BB0_5F55(whichHero)
    local q = heroSkillRecord.getHeroRecordedSkill(whichHero, "Q")
    local w = heroSkillRecord.getHeroRecordedSkill(whichHero, "W")
    local e = heroSkillRecord.getHeroRecordedSkill(whichHero, "E")
    local r = heroSkillRecord.getHeroRecordedSkill(whichHero, "R")
    local d = heroSkillRecord.getHeroRecordedSkill(whichHero, "D")
    debugLogForce(
        _____6A21_5757_540D,
        "当前记录：",
        "Q=",
        _____53D6_6280_80FDrawcode_6587_672C(q),
        "W=",
        _____53D6_6280_80FDrawcode_6587_672C(w),
        "E=",
        _____53D6_6280_80FDrawcode_6587_672C(e),
        "R=",
        _____53D6_6280_80FDrawcode_6587_672C(r),
        "D=",
        _____53D6_6280_80FDrawcode_6587_672C(d)
    )
end
local function _____6253_5370_51B7_5374_663E_793A_5FEB_7167()
    local ____debugLogForce_2 = debugLogForce
    local ____self_1 = require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示")
    ____debugLogForce_2(
        _____6A21_5757_540D,
        "冷却显示快照：",
        ____self_1["获取QWERD冷却调试快照"](____self_1)
    )
end
local function ____on_6D4B_8BD5_82F1_96C4_65BD_6CD5()
    local whichHero = jass.GetTriggerUnit()
    if whichHero == nil or whichHero == 0 then
        return
    end
    local abilityId = jass.GetSpellAbilityId() or 0
    if abilityId == 0 then
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "本次施法：ability=",
        _____53D6_6280_80FDrawcode_6587_672C(abilityId),
        "hotkey=",
        _____53D6_6280_80FD_70ED_952E_6587_672C(whichHero, abilityId)
    )
    _____6253_5370_547D_4EE4_5361_69FD_4F4D()
    _____6253_5370_5F53_524D_8BB0_5F55(whichHero)
    _____6253_5370_51B7_5374_663E_793A_5FEB_7167()
end
local function _____6302_63A5_6D4B_8BD5_82F1_96C4_76D1_542C(whichHero)
    if whichHero == nil or whichHero == 0 then
        return
    end
    local heroId = jass.GetHandleId(whichHero) or 0
    if heroId == 0 then
        return
    end
    if _____5DF2_6302_76D1_542C_82F1_96C4id == heroId then
        return
    end
    if _____6280_80FD_76D1_542C_89E6_53D1_5668 == nil then
        _____6280_80FD_76D1_542C_89E6_53D1_5668 = CreateTrigger()
        TriggerAddAction(_____6280_80FD_76D1_542C_89E6_53D1_5668, ____on_6D4B_8BD5_82F1_96C4_65BD_6CD5)
    end
    unitSpecificEventCenter.registerUnitEventTrigger(_____6280_80FD_76D1_542C_89E6_53D1_5668, whichHero, jass.EVENT_UNIT_SPELL_EFFECT)
    _____5DF2_6302_76D1_542C_82F1_96C4id = heroId
end
local function ____on_804A_5929_6D4B_8BD5()
    local _____82F1_96C4 = g.gg_unit_Hamg_0002
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    heroSkillRecord.registerHeroSkillRecordHero(_____82F1_96C4)
    _____6302_63A5_6D4B_8BD5_82F1_96C4_76D1_542C(_____82F1_96C4)
    debugLogForce(_____6A21_5757_540D, "===== 英雄技能记录测试 =====")
    debugLogForce(_____6A21_5757_540D, "测试英雄handle：", _____82F1_96C4)
    debugLogForce(_____6A21_5757_540D, "提示：现在施放任意技能，会打印本次技能与当前Q/W/E/R/D记录")
    _____6253_5370_547D_4EE4_5361_69FD_4F4D()
    _____6253_5370_5F53_524D_8BB0_5F55(_____82F1_96C4)
    _____6253_5370_51B7_5374_663E_793A_5FEB_7167()
end
local function _____6CE8_518C_804A_5929_6D4B_8BD5()
    if _____5DF2_6CE8_518C_804A_5929 then
        return
    end
    _____5DF2_6CE8_518C_804A_5929 = true
    local trig = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        trig,
        Player(0),
        _____6D4B_8BD5_547D_4EE4,
        true
    )
    TriggerAddAction(trig, ____on_804A_5929_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4)
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
