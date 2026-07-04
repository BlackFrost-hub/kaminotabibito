local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171 = require("系统.02．物品系统.15．装备技能.00．物品.154．第二章后段Boss战利品公共")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["单位持有第二章后段Boss战利品"]
local _____662F_6280_80FD_4F24_5BB3 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["是技能伤害"]
local _____662F_5143_7D20_4F24_5BB3 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["是元素伤害"]
local _____53D6_5355_4F4DID = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["取单位ID"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["造成装备伤害"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["播放单位特效"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["第二章后段Boss战利品装备名"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["装备伤害类型"]
local _____88C5_5907_5C0F_7279_6548 = ____154_FF0E_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_516C_5171["装备小特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local _____6E7F_75D5_5230_671F_8868 = {}
local function ____on_5361_745F_62C9_6DF1_6E0A_6CD5_5178_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) or not _____662F_6280_80FD_4F24_5BB3(snapshot) then
        return
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(attacker, _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["卡瑟拉深渊法典"]) then
        return
    end
    local targetId = _____53D6_5355_4F4DID(target)
    if targetId == 0 then
        return
    end
    if _____662F_5143_7D20_4F24_5BB3(snapshot, _____88C5_5907_4F24_5BB3_7C7B_578B["水"]) then
        _____6E7F_75D5_5230_671F_8868[targetId] = getServerTime() + 6000
        _____64AD_653E_5355_4F4D_7279_6548(_____88C5_5907_5C0F_7279_6548["湿痕"], target, "origin", 1.2)
        return
    end
    if not _____662F_5143_7D20_4F24_5BB3(snapshot, _____88C5_5907_4F24_5BB3_7C7B_578B["闪电"]) then
        return
    end
    if (_____6E7F_75D5_5230_671F_8868[targetId] or 0) < getServerTime() then
        return
    end
    __TS__Delete(_____6E7F_75D5_5230_671F_8868, targetId)
    _____9020_6210_88C5_5907_4F24_5BB3(attacker, target, applied * 0.22, _____88C5_5907_4F24_5BB3_7C7B_578B["闪电"])
end
registerAppliedFinalDamageListener(____on_5361_745F_62C9_6DF1_6E0A_6CD5_5178_4F24_5BB3)
return ____exports
