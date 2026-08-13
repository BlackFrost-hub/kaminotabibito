local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.06．逆回十六夜.00．配置")
local _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["逆回十六夜单位技能配置"]
local ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["调整玩家属性"]
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664 = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["执行非伤害生命移除"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.04．伤害系统.05．闪避系统.01．闪避核心")
local registerDodgeBypassPredicate = ____require_result_2.registerDodgeBypassPredicate
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local registerPlayerHeroListener = ____require_result_3.registerPlayerHeroListener
local getRegisteredPlayerHero = ____require_result_3.getRegisteredPlayerHero
local GetUnitTypeId = jass.GetUnitTypeId
local Player = jass.Player
local _____5341_516D_591C_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____5DF2_7ED1_5B9A_73A9_5BB6 = {}
local function _____662F_9006_56DE_5341_516D_591C(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == _____5341_516D_591C_5355_4F4D_7C7B_578BID
end
local function _____66F4_65B0_5341_516D_591C_88AB_52A8_5C5E_6027(player, hero)
    if player == nil or player == 0 then
        return
    end
    local playerId = jass:GetPlayerId(player)
    local shouldApply = _____662F_9006_56DE_5341_516D_591C(hero)
    local applied = _____5DF2_7ED1_5B9A_73A9_5BB6[playerId] == true
    if shouldApply == applied then
        return
    end
    local direction = shouldApply and 1 or -1
    _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "眩晕抗性", _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["被动"]["眩晕抗性"] * direction)
    _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "被暴击率", _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["被动"]["被暴击率减少"] * direction)
    if shouldApply then
        _____5DF2_7ED1_5B9A_73A9_5BB6[playerId] = true
    else
        __TS__Delete(_____5DF2_7ED1_5B9A_73A9_5BB6, playerId)
    end
end
local function _____5341_516D_591C_975E_666E_653B_95EA_907F_8C41_514D(context)
    local ____662F_9006_56DE_5341_516D_591C_7 = _____662F_9006_56DE_5341_516D_591C
    local ____opt_result_6
    if context ~= nil then
        ____opt_result_6 = context.attacker
    end
    local ____662F_9006_56DE_5341_516D_591C_7_result_11 = ____662F_9006_56DE_5341_516D_591C_7(____opt_result_6)
    if ____662F_9006_56DE_5341_516D_591C_7_result_11 then
        local ____opt_result_10
        if context ~= nil then
            ____opt_result_10 = context.isNormalAttack
        end
        ____662F_9006_56DE_5341_516D_591C_7_result_11 = ____opt_result_10 ~= true
    end
    return ____662F_9006_56DE_5341_516D_591C_7_result_11
end
local function ____on_5341_516D_591C_6700_7EC8_7269_7406_4F24_5BB3(target, attacker, applied, snapshot)
    local ____temp_15 = not _____662F_9006_56DE_5341_516D_591C(attacker) or not (applied > 0)
    if not ____temp_15 then
        local ____opt_result_14
        if snapshot ~= nil then
            ____opt_result_14 = snapshot.isPhysicalDamage
        end
        ____temp_15 = ____opt_result_14 ~= true
    end
    if ____temp_15 then
        return
    end
    _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({["目标"] = target, ["数值"] = applied * _____9006_56DE_5341_516D_591C_5355_4F4D_6280_80FD_914D_7F6E["被动"]["物理伤害额外扣血比例"], ["不致死"] = false, ["显示文字"] = true})
end
local function _____521D_59CB_5316_5DF2_6709_5341_516D_591C_5C5E_6027()
    do
        local i = 0
        while i < 16 do
            local player = Player(i)
            _____66F4_65B0_5341_516D_591C_88AB_52A8_5C5E_6027(
                player,
                getRegisteredPlayerHero(player)
            )
            i = i + 1
        end
    end
end
____exports["注册逆回十六夜被动"] = function()
    registerPlayerHeroListener(_____66F4_65B0_5341_516D_591C_88AB_52A8_5C5E_6027)
    registerDodgeBypassPredicate(_____5341_516D_591C_975E_666E_653B_95EA_907F_8C41_514D)
    registerAppliedFinalDamageListener(____on_5341_516D_591C_6700_7EC8_7269_7406_4F24_5BB3)
    _____521D_59CB_5316_5DF2_6709_5341_516D_591C_5C5E_6027()
end
____exports["注册逆回十六夜被动"]()
return ____exports
