--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_529F_80FD = require("系统.03．技能系统.05．动态技能说明.01．核心功能")
local ABILITY_DATA_TIP = ____01_FF0E_6838_5FC3_529F_80FD.ABILITY_DATA_TIP
local ABILITY_DATA_UBERTIP = ____01_FF0E_6838_5FC3_529F_80FD.ABILITY_DATA_UBERTIP
local getDynamicSkillTipText = ____01_FF0E_6838_5FC3_529F_80FD.getDynamicSkillTipText
local refreshUnitSkillTips = ____01_FF0E_6838_5FC3_529F_80FD.refreshUnitSkillTips
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local createDelayedCall = ____require_result_0.createDelayedCall
local ____require_result_1 = require("lib.扩展函数.封装函数.04．硬件输入.index")
local frameSetScriptByCode = ____require_result_1.frameSetScriptByCode
local ____require_result_2 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local EXGetUnitAbility = ____require_result_2.EXGetUnitAbility
local EXGetAbilityDataString = ____require_result_2.EXGetAbilityDataString
local EXSetAbilityDataString = ____require_result_2.EXSetAbilityDataString
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local getSoleSelectedUnitForPlayer = ____require_result_3.getSoleSelectedUnitForPlayer
local commandBarAbility = require("系统.03．技能系统.05．动态技能说明.07．命令卡技能槽位")
local FRAME_EVENT_MOUSE_ENTER = 2
local FRAME_EVENT_MOUSE_LEAVE = 3
local HOVER_INSTALL_RETRY_SEC = 0.1
local HOVER_INSTALL_MAX_ATTEMPTS = 50
local _____6280_80FD_6309_94AE_69FD_4F4D_8868 = {}
local _____5DF2_5B89_88C5_6280_80FD_6309_94AE_60AC_6D6E_4E8B_4EF6 = false
local _____5F53_524D_72B6_6001 = nil
local function _____83B7_53D6_5F53_524D_89E6_53D1Frame()
    local frame = japi.DzGetTriggerUIEventFrame()
    if frame and frame ~= 0 then
        return frame
    end
    return japi.DzGetMouseFocus()
end
local function _____83B7_53D6_672C_673A_552F_4E00_9009_4E2D_5355_4F4D()
    local _____672C_673A_73A9_5BB6 = jass.GetLocalPlayer()
    if not _____672C_673A_73A9_5BB6 or _____672C_673A_73A9_5BB6 == 0 then
        return nil
    end
    return getSoleSelectedUnitForPlayer(
        nil,
        jass.GetPlayerId(_____672C_673A_73A9_5BB6)
    )
end
local function _____89E3_6790_6280_80FD_6309_94AE_80FD_529BId(x, y)
    return commandBarAbility["读取命令卡按钮能力Id"](x, y)
end
local function _____6062_590D_5F53_524D_52AB_6301_6587_672C()
    if _____5F53_524D_72B6_6001 == nil then
        return
    end
    local ability = EXGetUnitAbility(nil, _____5F53_524D_72B6_6001.unit, _____5F53_524D_72B6_6001.abilityId)
    if ability then
        if _____5F53_524D_72B6_6001["改了名称"] then
            EXSetAbilityDataString(
                nil,
                ability,
                _____5F53_524D_72B6_6001.level,
                ABILITY_DATA_TIP,
                _____5F53_524D_72B6_6001["原始名称"]
            )
        end
        if _____5F53_524D_72B6_6001["改了说明"] then
            EXSetAbilityDataString(
                nil,
                ability,
                _____5F53_524D_72B6_6001.level,
                ABILITY_DATA_UBERTIP,
                _____5F53_524D_72B6_6001["原始说明"]
            )
        end
    end
    _____5F53_524D_72B6_6001 = nil
end
local function _____5E94_7528_52A8_6001_6280_80FD_6587_672C_52AB_6301(unit, abilityId)
    local ability = EXGetUnitAbility(nil, unit, abilityId)
    if not ability then
        return
    end
    local level = jass.GetUnitAbilityLevel(unit, abilityId) or 1
    EXSetAbilityDataString(
        nil,
        ability,
        level,
        ABILITY_DATA_UBERTIP,
        "【悬浮劫持测试】123456"
    )
    local _____52A8_6001_540D_79F0 = getDynamicSkillTipText(unit, abilityId, ABILITY_DATA_TIP)
    local _____52A8_6001_8BF4_660E = getDynamicSkillTipText(unit, abilityId, ABILITY_DATA_UBERTIP)
    if _____52A8_6001_540D_79F0 == nil and _____52A8_6001_8BF4_660E == nil then
        return
    end
    local _____539F_59CB_540D_79F0 = EXGetAbilityDataString(nil, ability, level, ABILITY_DATA_TIP) or ""
    local _____539F_59CB_8BF4_660E = EXGetAbilityDataString(nil, ability, level, ABILITY_DATA_UBERTIP) or ""
    local _____6539_4E86_540D_79F0 = _____52A8_6001_540D_79F0 ~= nil and _____52A8_6001_540D_79F0 ~= ""
    local _____6539_4E86_8BF4_660E = _____52A8_6001_8BF4_660E ~= nil and _____52A8_6001_8BF4_660E ~= ""
    if _____6539_4E86_540D_79F0 then
        EXSetAbilityDataString(
            nil,
            ability,
            level,
            ABILITY_DATA_TIP,
            _____52A8_6001_540D_79F0
        )
    end
    if _____6539_4E86_8BF4_660E then
        EXSetAbilityDataString(
            nil,
            ability,
            level,
            ABILITY_DATA_UBERTIP,
            _____52A8_6001_8BF4_660E
        )
    end
    _____5F53_524D_72B6_6001 = {
        unit = unit,
        abilityId = abilityId,
        level = level,
        ["原始名称"] = _____539F_59CB_540D_79F0,
        ["原始说明"] = _____539F_59CB_8BF4_660E,
        ["改了名称"] = _____6539_4E86_540D_79F0,
        ["改了说明"] = _____6539_4E86_8BF4_660E
    }
end
local function onSkillButtonHoverEnter()
    _____6062_590D_5F53_524D_52AB_6301_6587_672C()
    local frame = _____83B7_53D6_5F53_524D_89E6_53D1Frame()
    if not frame or frame == 0 then
        return
    end
    local _____69FD_4F4D = _____6280_80FD_6309_94AE_69FD_4F4D_8868[frame]
    if _____69FD_4F4D == nil then
        return
    end
    local unit = _____83B7_53D6_672C_673A_552F_4E00_9009_4E2D_5355_4F4D()
    if unit == nil or unit == 0 then
        return
    end
    local abilityId = _____89E3_6790_6280_80FD_6309_94AE_80FD_529BId(_____69FD_4F4D.x, _____69FD_4F4D.y)
    if not abilityId then
        return
    end
    jass.DisplayTextToPlayer(
        jass.GetLocalPlayer(),
        0,
        0,
        "HOVER_OK_" .. tostring(abilityId)
    )
    _____5E94_7528_52A8_6001_6280_80FD_6587_672C_52AB_6301(unit, abilityId)
end
local function onSkillButtonHoverLeave()
    _____6062_590D_5F53_524D_52AB_6301_6587_672C()
end
local function _____5B89_88C5_6280_80FD_6309_94AE_60AC_6D6E_4E8B_4EF6()
    if _____5DF2_5B89_88C5_6280_80FD_6309_94AE_60AC_6D6E_4E8B_4EF6 then
        return
    end
    _____5DF2_5B89_88C5_6280_80FD_6309_94AE_60AC_6D6E_4E8B_4EF6 = true
    do
        local y = 0
        while y <= 2 do
            do
                local x = 0
                while x <= 3 do
                    do
                        local frame = japi.DzFrameGetCommandBarButton(y, x)
                        if not frame or frame == 0 then
                            goto __continue28
                        end
                        if _____6280_80FD_6309_94AE_69FD_4F4D_8868[frame] ~= nil then
                            goto __continue28
                        end
                        _____6280_80FD_6309_94AE_69FD_4F4D_8868[frame] = {x = x, y = y}
                        frameSetScriptByCode(
                            nil,
                            frame,
                            FRAME_EVENT_MOUSE_ENTER,
                            onSkillButtonHoverEnter,
                            false
                        )
                        frameSetScriptByCode(
                            nil,
                            frame,
                            FRAME_EVENT_MOUSE_LEAVE,
                            onSkillButtonHoverLeave,
                            false
                        )
                    end
                    ::__continue28::
                    x = x + 1
                end
            end
            y = y + 1
        end
    end
end
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    if not whichPlayer or whichPlayer == 0 or not whichHero or whichHero == 0 then
        return
    end
    refreshUnitSkillTips(whichHero)
    _____5B89_88C5_6280_80FD_6309_94AE_60AC_6D6E_4E8B_4EF6()
end
return ____exports
