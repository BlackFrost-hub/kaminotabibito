--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____143_FF0E_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_516C_5171 = require("系统.02．物品系统.15．装备技能.00．物品.143．第三章主线Boss战利品公共")
local _____5355_4F4D_6301_6709_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1 = ____143_FF0E_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_516C_5171["单位持有第三章主线Boss战利品"]
local _____662F_6280_80FD_4F24_5BB3_5FEB_7167 = ____143_FF0E_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_516C_5171["是技能伤害快照"]
local _____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_51B7_5374_4E2D = ____143_FF0E_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_516C_5171["第三章主线Boss战利品冷却中"]
local _____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_88C5_5907_540D = ____143_FF0E_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_516C_5171["第三章主线Boss战利品装备名"]
local _____53D6_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_51B7_5374_952E = ____143_FF0E_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_516C_5171["取第三章主线Boss战利品冷却键"]
local _____8BBE_7F6E_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_51B7_5374 = ____143_FF0E_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_516C_5171["设置第三章主线Boss战利品冷却"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位有效存活"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local _____6C38_6052_8F6E_56DE_6CD5_5178_51B7_5374_79D2_6570 = 2
local _____6C38_6052_8F6E_56DE_6CD5_5178_9644_52A0_4F24_5BB3 = 320
local function ____on_6C38_6052_8F6E_56DE_6CD5_5178_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    if not _____662F_6280_80FD_4F24_5BB3_5FEB_7167(snapshot) then
        return
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(attacker) or not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    if not _____5355_4F4D_6301_6709_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1(attacker, _____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_88C5_5907_540D["永恒轮回法典"]) then
        return
    end
    local key = _____53D6_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_51B7_5374_952E(attacker, "永恒轮回法典:轮回火印")
    if _____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_51B7_5374_4E2D(key) then
        return
    end
    _____8BBE_7F6E_7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_51B7_5374(key, _____6C38_6052_8F6E_56DE_6CD5_5178_51B7_5374_79D2_6570)
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(attacker, target, _____6C38_6052_8F6E_56DE_6CD5_5178_9644_52A0_4F24_5BB3, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["火焰"])
end
registerAppliedFinalDamageListener(____on_6C38_6052_8F6E_56DE_6CD5_5178_6700_7EC8_4F24_5BB3)
return ____exports
