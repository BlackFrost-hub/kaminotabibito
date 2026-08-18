local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.18．云端.00．配置")
local _____4E91_7AEF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["云端技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.18．云端.01．状态表")
local _____4E91_7AEFE_662F_5426_51B7_5374_4E2D = ____01_FF0E_72B6_6001_8868["云端E是否冷却中"]
local _____8BBE_7F6E_4E91_7AEFE_51B7_5374 = ____01_FF0E_72B6_6001_8868["设置云端E冷却"]
local _____83B7_53D6_4E91_7AEF_72B6_6001 = ____01_FF0E_72B6_6001_8868["获取云端状态"]
local ____18_FF0E_4E91_7AEF = require("系统.05．Buff系统.03．Buff表.02．英雄.18．云端")
local _____4E91_7AEFBuffID = ____18_FF0E_4E91_7AEF["云端BuffID"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local ____require_result_1 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_1.registerDamageCallback
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_3["临时调整攻击"]
local _____4E34_65F6_8C03_6574_62A4_7532 = ____require_result_3["临时调整护甲"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_654F_6377 = ____require_result_4["读取单位敏捷"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_5.YDUserDataSetSafe
local ____require_result_6 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundOnUnitBJ = ____require_result_6.PlaySoundOnUnitBJ
local ____require_result_7 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
local CreateFloatTextOnUnit = ____require_result_7.CreateFloatTextOnUnit
local ____require_result_8 = require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示")
local _____767B_8BB0_88AB_52A8_6280_80FD_51B7_5374 = ____require_result_8["登记被动技能冷却"]
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitState = jass.GetUnitState
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitAlly = jass.IsUnitAlly
local IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local _____914D_7F6E = _____4E91_7AEF_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____E_7C7B_578BID = stringToFourCCSafe(_____914D_7F6E.E["技能ID"])
local function _____7ED3_675FE_89E6_53D1_51B7_5374(variable)
    local caster = variable
    if caster == nil or caster == 0 then
        return
    end
    _____8BBE_7F6E_4E91_7AEFE_51B7_5374(caster, false)
    _____767B_8BB0_88AB_52A8_6280_80FD_51B7_5374(caster, ____E_7C7B_578BID, 0)
    local record = _____83B7_53D6_4E91_7AEF_72B6_6001(caster)
    if record ~= nil then
        record["E冷却回调ID"] = 0
    end
end
local function _____56DE_6536E_589E_76CA(variable)
    local ctx = variable
    if ctx == nil or ctx["已回收"] == true then
        return
    end
    ctx["已回收"] = true
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 then
        return
    end
    if ctx["分支"] == "洞察" then
        local player = GetOwningPlayer(caster)
        local _____5F53_524D_66B4_51FB_7387 = __TS__Number(YDUserDataGetSafe("player", player, "暴击率", "real")) or 0
        local _____5F53_524D_66B4_51FB_4F24_5BB3 = __TS__Number(YDUserDataGetSafe("player", player, "暴击伤害", "real")) or 0
        YDUserDataSetSafe(
            "player",
            player,
            "暴击率",
            "real",
            _____5F53_524D_66B4_51FB_7387 - ctx["增量"]
        )
        YDUserDataSetSafe(
            "player",
            player,
            "暴击伤害",
            "real",
            _____5F53_524D_66B4_51FB_4F24_5BB3 - ctx["增量"]
        )
    elseif ctx["分支"] == "破势" then
        _____4E34_65F6_8C03_6574_653B_51FB(caster, -ctx["增量"])
    else
        _____4E34_65F6_8C03_6574_62A4_7532(caster, -ctx["增量"])
    end
end
local function _____5904_7406_65E0_53CC_5251_6CD5_89E6_53D1(unit, _damage, damageType, _fromDotTickBatch, source, isNormalAttack)
    if source == nil or source == 0 then
        return
    end
    if GetUnitTypeId(source) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    if isNormalAttack ~= true then
        return
    end
    if GetUnitAbilityLevel(source, ____E_7C7B_578BID) < 1 then
        return
    end
    local attackerPlayer = GetOwningPlayer(source)
    if IsUnitAlly(unit, attackerPlayer) or IsUnitOwnedByPlayer(unit, attackerPlayer) then
        return
    end
    if _____4E91_7AEFE_662F_5426_51B7_5374_4E2D(source) then
        return
    end
    _____8BBE_7F6E_4E91_7AEFE_51B7_5374(source, true)
    _____767B_8BB0_88AB_52A8_6280_80FD_51B7_5374(source, ____E_7C7B_578BID, _____914D_7F6E.E["触发冷却秒"])
    local record = _____83B7_53D6_4E91_7AEF_72B6_6001(source)
    if record ~= nil then
        if record["E冷却回调ID"] ~= 0 then
            removeDelayedCallback(record["E冷却回调ID"])
        end
        record["E冷却回调ID"] = addDelayedCallback(
            math.floor(_____914D_7F6E.E["触发冷却秒"] * 1000 + 0.5),
            _____7ED3_675FE_89E6_53D1_51B7_5374,
            source
        )
    end
    local ____e_97F3_6548_53E5_67C4 = jglobals[_____914D_7F6E.E["音效"]["全局音效键"]]
    if ____e_97F3_6548_53E5_67C4 ~= nil then
        PlaySoundOnUnitBJ(____e_97F3_6548_53E5_67C4, 100, source)
    end
    local _____7B49_7EA7 = GetUnitAbilityLevel(source, ____E_7C7B_578BID)
    local _____6700_5927_751F_547D = GetUnitState(unit, UNIT_STATE_MAX_LIFE)
    local _____751F_547D_767E_5206_6BD4 = _____6700_5927_751F_547D > 0 and GetUnitState(unit, UNIT_STATE_LIFE) / _____6700_5927_751F_547D * 100 or 0
    local ctx
    if _____751F_547D_767E_5206_6BD4 >= _____914D_7F6E.E["高生命阈值"] then
        CreateFloatTextOnUnit(unit, _____914D_7F6E.E["洞察"]["漂浮字"], {
            size = _____914D_7F6E.E["漂浮字"]["尺寸"],
            red = 255,
            green = 0,
            blue = 0,
            alpha = _____914D_7F6E.E["漂浮字"]["透明度"],
            duration = _____914D_7F6E.E["漂浮字"]["持续秒"],
            speedY = _____914D_7F6E.E["漂浮字"]["上浮速度"],
            height = 40
        })
        local _____63D0_5347 = _____914D_7F6E.E["洞察"]["每级暴击提升"] * _____7B49_7EA7
        local player = GetOwningPlayer(source)
        local _____5F53_524D_66B4_51FB_7387 = __TS__Number(YDUserDataGetSafe("player", player, "暴击率", "real")) or 0
        local _____5F53_524D_66B4_51FB_4F24_5BB3 = __TS__Number(YDUserDataGetSafe("player", player, "暴击伤害", "real")) or 0
        YDUserDataSetSafe(
            "player",
            player,
            "暴击率",
            "real",
            _____5F53_524D_66B4_51FB_7387 + _____63D0_5347
        )
        YDUserDataSetSafe(
            "player",
            player,
            "暴击伤害",
            "real",
            _____5F53_524D_66B4_51FB_4F24_5BB3 + _____63D0_5347
        )
        registerManualBuff(source, _____4E91_7AEFBuffID["无双洞察"], _____914D_7F6E.E["增益持续秒"], _____63D0_5347)
        ctx = {["施法者"] = source, ["分支"] = "洞察", ["增量"] = _____63D0_5347, ["已回收"] = false}
    elseif _____751F_547D_767E_5206_6BD4 <= _____914D_7F6E.E["低生命阈值"] then
        CreateFloatTextOnUnit(source, _____914D_7F6E.E["破势"]["漂浮字"], {
            size = _____914D_7F6E.E["漂浮字"]["尺寸"],
            red = 255,
            green = 0,
            blue = 0,
            alpha = _____914D_7F6E.E["漂浮字"]["透明度"],
            duration = _____914D_7F6E.E["漂浮字"]["持续秒"],
            speedY = _____914D_7F6E.E["漂浮字"]["上浮速度"],
            height = 40
        })
        local _____589E_91CF = math.floor(_____8BFB_53D6_5355_4F4D_654F_6377(source) * (_____914D_7F6E.E["破势"]["每级敏捷系数"] * _____7B49_7EA7))
        _____4E34_65F6_8C03_6574_653B_51FB(source, _____589E_91CF)
        registerManualBuff(source, _____4E91_7AEFBuffID["无双破势"], _____914D_7F6E.E["增益持续秒"], _____589E_91CF)
        ctx = {["施法者"] = source, ["分支"] = "破势", ["增量"] = _____589E_91CF, ["已回收"] = false}
    else
        CreateFloatTextOnUnit(source, _____914D_7F6E.E["御势"]["漂浮字"], {
            size = _____914D_7F6E.E["漂浮字"]["尺寸"],
            red = 0,
            green = 0,
            blue = 255,
            alpha = _____914D_7F6E.E["漂浮字"]["透明度"],
            duration = _____914D_7F6E.E["漂浮字"]["持续秒"],
            speedY = _____914D_7F6E.E["漂浮字"]["上浮速度"],
            height = 20
        })
        local _____589E_91CF = _____914D_7F6E.E["御势"]["每级护甲提升"] * _____7B49_7EA7
        _____4E34_65F6_8C03_6574_62A4_7532(source, _____589E_91CF)
        registerManualBuff(source, _____4E91_7AEFBuffID["无双御势"], _____914D_7F6E.E["增益持续秒"], _____589E_91CF)
        ctx = {["施法者"] = source, ["分支"] = "御势", ["增量"] = _____589E_91CF, ["已回收"] = false}
    end
    addDelayedCallback(
        math.floor(_____914D_7F6E.E["增益持续秒"] * 1000 + 0.5),
        _____56DE_6536E_589E_76CA,
        ctx
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册云端E"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerDamageCallback(_____5904_7406_65E0_53CC_5251_6CD5_89E6_53D1)
end
____exports["注册云端E"]()
return ____exports
