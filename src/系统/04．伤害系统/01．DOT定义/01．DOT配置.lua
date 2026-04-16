--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local debuffMod = require("系统.05．Buff系统.01．Buff表")
local debuffBuffs = debuffMod.buffs
local DOT_BUFF_ROWS = {antiHeal = "D001", burn = "D002", poison = "D003", trollCurse = "D004"}
--- DOT 每跳 `AddSpecialEffectTarget` 的模型路径，与同 ID 行的 `effect` 一致
function ____exports.dotEffectModelFromBuffRow(self, rowId)
    local row = debuffBuffs[rowId]
    return row ~= nil and type(row.effect) == "string" and row.effect ~= "" and row.effect or ""
end
local ____opt_0 = debuffBuffs[DOT_BUFF_ROWS.antiHeal]
local ____temp_8 = ____opt_0 and ____opt_0.buffID or DOT_BUFF_ROWS.antiHeal
local ____opt_2 = debuffBuffs[DOT_BUFF_ROWS.burn]
local ____temp_9 = ____opt_2 and ____opt_2.buffID or DOT_BUFF_ROWS.burn
local ____opt_4 = debuffBuffs[DOT_BUFF_ROWS.poison]
local ____temp_10 = ____opt_4 and ____opt_4.buffID or DOT_BUFF_ROWS.poison
local ____opt_6 = debuffBuffs[DOT_BUFF_ROWS.trollCurse]
--- 与 Buff表 buffID 对齐，供 UI/其它系统引用
____exports.DOT_DEBUFF_IDS = {antiHeal = ____temp_8, burn = ____temp_9, poison = ____temp_10, trollCurse = ____opt_6 and ____opt_6.buffID or DOT_BUFF_ROWS.trollCurse}
function ____exports.getDotBuffRow(self, typeId)
    return DOT_BUFF_ROWS[typeId]
end
return ____exports
