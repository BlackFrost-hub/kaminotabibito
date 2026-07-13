local ____lualib = require("lualib_bundle")
local __TS__StringReplace = ____lualib.__TS__StringReplace
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_0.QuestMessageBJ
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_1.GetPlayersAll
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.index")
local _____589E_52A0_82F1_96C4_57FA_7840_5168_5C5E_6027 = ____require_result_4["增加英雄基础全属性"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.03．异界Boss战斗启动属性配置表.index")
local _____5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = ____require_result_5["异界Boss战斗启动属性配置表"]
local _____5F02_754CBoss_6B7B_4EA1_5956_52B1_63D0_793A_6587_6848_6A21_677F = ____require_result_5["异界Boss死亡奖励提示文案模板"]
local _____5F02_754CBoss_9ED8_8BA4_6B7B_4EA1_5956_52B1_57FA_7840_5168_5C5E_6027 = ____require_result_5["异界Boss默认死亡奖励基础全属性"]
local GetUnitTypeId = jass.GetUnitTypeId
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local _____5F53_524D_5F02_754CBoss_6B7B_4EA1_5956_52B1_503C = 0
local function _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
local function ____on_53D1_653E_5F02_754CBoss_6B7B_4EA1_5956_52B1_82F1_96C4()
    local unit = GetEnumUnit()
    if unit == nil or unit == 0 then
        return
    end
    _____589E_52A0_82F1_96C4_57FA_7840_5168_5C5E_6027(unit, _____5F53_524D_5F02_754CBoss_6B7B_4EA1_5956_52B1_503C)
end
local function _____83B7_53D6_5F02_754CBoss_6B7B_4EA1_5956_52B1_503C(bossUnit)
    local unitTypeId = GetUnitTypeId(bossUnit) or 0
    if unitTypeId == 0 then
        return 0
    end
    do
        local i = 0
        while i < #_____5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868[i + 1]
                if _____914D_7F6E["单位ID"] == nil or _____914D_7F6E["单位ID"] == "" then
                    goto __continue8
                end
                if stringToFourCCSafe(_____914D_7F6E["单位ID"]) ~= unitTypeId then
                    goto __continue8
                end
                return _____914D_7F6E["死亡后所有玩家英雄基础全属性"] or 0
            end
            ::__continue8::
            i = i + 1
        end
    end
    return 0
end
____exports["发放异界Boss死亡奖励"] = function(bossUnit)
    local _____5956_52B1_503C = _____83B7_53D6_5F02_754CBoss_6B7B_4EA1_5956_52B1_503C(bossUnit)
    if _____5956_52B1_503C <= 0 then
        return false
    end
    _____5F53_524D_5F02_754CBoss_6B7B_4EA1_5956_52B1_503C = _____5956_52B1_503C
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_53D1_653E_5F02_754CBoss_6B7B_4EA1_5956_52B1_82F1_96C4)
    end
    local _____63D0_793A_6587_672C = ("|cffffff00『系统提示』：|r|cffffcc99" .. __TS__StringReplace(
        _____5F02_754CBoss_6B7B_4EA1_5956_52B1_63D0_793A_6587_6848_6A21_677F,
        "{value}",
        tostring(_____5956_52B1_503C or _____5F02_754CBoss_9ED8_8BA4_6B7B_4EA1_5956_52B1_57FA_7840_5168_5C5E_6027)
    )) .. "|r"
    QuestMessageBJ(
        GetPlayersAll(),
        jglobals.bj_QUESTMESSAGE_ITEMACQUIRED,
        _____63D0_793A_6587_672C
    )
    _____5F53_524D_5F02_754CBoss_6B7B_4EA1_5956_52B1_503C = 0
    return true
end
return ____exports
