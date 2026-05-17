--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Boss战伤害统计
-- 
-- 对齐：JASS/jass复制粘贴/伤害显示.j 末尾统计逻辑
-- - 玩家对 Boss战单位造成伤害 -> 累计到玩家「造成伤害」
-- - Boss战单位对玩家（非召唤物）造成伤害 -> 累计到玩家「承受伤害」
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDUserDataSet = ____require_result_0.YDUserDataSet
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local GetOwningPlayer = jass.GetOwningPlayer
local IsPlayerInForce = jass.IsPlayerInForce
local IsUnitType = jass.IsUnitType
local GetUnitState = jass.GetUnitState
local R2I = jass.R2I
local UNIT_TYPE_SUMMONED = jass.UNIT_TYPE_SUMMONED
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____Boss_6218_8868 = "Boss战"
local ____Boss_6218_5355_4F4D = "单位"
local _____73A9_5BB6_7EC4_8868 = "玩家"
local _____73A9_5BB6_7EC4_52BF_529B = "玩家组"
local _____9020_6210_4F24_5BB3 = "造成伤害"
local _____627F_53D7_4F24_5BB3 = "承受伤害"
local _____5DF2_521D_59CB_5316 = false
local function _____6700_5C0F_5B9E_6570(a, b)
    if a <= b then
        return a
    end
    return b
end
local function _____8F6C_4E3A_7EDF_8BA1_6574_6570_4F24_5BB3(applied)
    if not (applied > 0) then
        return 0
    end
    return R2I(applied)
end
local function _____6DFB_52A0_73A9_5BB6_7EDF_8BA1(whichPlayer, attrName, delta)
    if whichPlayer == nil or not (delta > 0) then
        return
    end
    local current = YDUserDataGet(
        nil,
        "player",
        whichPlayer,
        attrName,
        "real"
    )
    local base = type(current) == "number" and current or 0
    YDUserDataSet(
        nil,
        "player",
        whichPlayer,
        attrName,
        "real",
        base + delta
    )
end
local function ____Boss_6218_6700_7EC8_4F24_5BB3(target, attacker, applied)
    if target == nil or attacker == nil then
        return
    end
    local damageInt = _____8F6C_4E3A_7EDF_8BA1_6574_6570_4F24_5BB3(applied)
    if damageInt <= 0 then
        return
    end
    local bossBattleUnit = YDUserDataGet(
        nil,
        "string",
        ____Boss_6218_8868,
        ____Boss_6218_5355_4F4D,
        "unit"
    )
    if bossBattleUnit == nil then
        return
    end
    local playerForce = YDUserDataGet(
        nil,
        "string",
        _____73A9_5BB6_7EC4_8868,
        _____73A9_5BB6_7EC4_52BF_529B,
        "force"
    )
    if playerForce == nil then
        return
    end
    if target == bossBattleUnit then
        local attackerPlayer = GetOwningPlayer(attacker)
        if IsPlayerInForce(attackerPlayer, playerForce) then
            local dealt = _____6700_5C0F_5B9E_6570(
                GetUnitState(target, UNIT_STATE_LIFE),
                damageInt
            )
            _____6DFB_52A0_73A9_5BB6_7EDF_8BA1(attackerPlayer, _____9020_6210_4F24_5BB3, dealt)
        end
    end
    if attacker == bossBattleUnit and not IsUnitType(target, UNIT_TYPE_SUMMONED) then
        local targetPlayer = GetOwningPlayer(target)
        if IsPlayerInForce(targetPlayer, playerForce) then
            local taken = _____6700_5C0F_5B9E_6570(
                GetUnitState(attacker, UNIT_STATE_LIFE),
                damageInt
            )
            _____6DFB_52A0_73A9_5BB6_7EDF_8BA1(targetPlayer, _____627F_53D7_4F24_5BB3, taken)
        end
    end
end
function ____exports.initBossBattleDamageStats()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerAppliedFinalDamageListener(____Boss_6218_6700_7EC8_4F24_5BB3)
end
return ____exports
