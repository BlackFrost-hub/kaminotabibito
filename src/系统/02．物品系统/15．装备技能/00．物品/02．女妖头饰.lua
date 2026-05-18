--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local ____require_result_1 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_1.resolveItemIdByName
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.01．暗影突袭")
local _____65BD_52A0_6697_5F71_7A81_88AD_51CF_76CA = ____require_result_2["施加暗影突袭减益"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.治疗波跳链")
local _____53D1_8D77_6CBB_7597_6CE2_8DF3_94FE = ____require_result_3["发起治疗波跳链"]
local ____require_result_4 = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表")
local _____5973_5996_5934_9970_7D2F_8BA1_914D_7F6E = ____require_result_4["女妖头饰累计配置"]
local ____require_result_5 = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表")
local _____5973_5996_5934_9970_5F3A_5316_7D2F_8BA1_914D_7F6E = ____require_result_5["女妖头饰强化累计配置"]
local GetHandleId = jass.GetHandleId
local GetItemTypeId = jass.GetItemTypeId
local UnitItemInSlot = jass.UnitItemInSlot
local stringToFourCC = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换").stringToFourCC
local _____5973_5996_5934_9970ID = stringToFourCC(resolveItemIdByName(_____5973_5996_5934_9970_7D2F_8BA1_914D_7F6E["物品名"]) or "")
local _____5973_5996_5934_9970_7D2F_8BA1_8868 = {}
local _____5973_5996_5934_9970_5F3A_5316ID = stringToFourCC(resolveItemIdByName(_____5973_5996_5934_9970_5F3A_5316_7D2F_8BA1_914D_7F6E["物品名"]) or "")
local _____5973_5996_5934_9970_5F3A_5316_547D_4E2D_8868 = {}
local function _____5355_4F4D_62E5_6709_88C5_5907(unit, itemTypeId)
    if unit == nil or unit == 0 or itemTypeId <= 0 then
        return false
    end
    do
        local slot = 0
        while slot < 6 do
            local item = UnitItemInSlot(unit, slot)
            if item ~= nil and item ~= 0 and GetItemTypeId(item) == itemTypeId then
                return true
            end
            slot = slot + 1
        end
    end
    return false
end
____exports["处理女妖头饰累计"] = function(target, attacker, applied)
    debugLogForce(
        "女妖头饰",
        "进入处理",
        "target:",
        target,
        "attacker:",
        attacker,
        "applied:",
        applied
    )
    if target == nil or target == 0 or attacker == nil or attacker == 0 or not (applied > 0) then
        debugLogForce("女妖头饰", "提前返回: 参数无效")
        return
    end
    local _____6709_5973_5996_5934_9970 = _____5355_4F4D_62E5_6709_88C5_5907(target, _____5973_5996_5934_9970ID)
    local ____temp_6
    if resolveItemIdByName(_____5973_5996_5934_9970_5F3A_5316_7D2F_8BA1_914D_7F6E["物品名"]) ~= nil then
        ____temp_6 = _____5355_4F4D_62E5_6709_88C5_5907(
            target,
            stringToFourCC(resolveItemIdByName(_____5973_5996_5934_9970_5F3A_5316_7D2F_8BA1_914D_7F6E["物品名"]) or "")
        )
    else
        ____temp_6 = false
    end
    local _____6709_5973_5996_5934_9970_5F3A_5316 = ____temp_6
    debugLogForce(
        "女妖头饰",
        "有女妖头饰:",
        _____6709_5973_5996_5934_9970,
        "有强化:",
        _____6709_5973_5996_5934_9970_5F3A_5316,
        "女妖头饰ID:",
        _____5973_5996_5934_9970ID
    )
    if not _____6709_5973_5996_5934_9970 and not _____6709_5973_5996_5934_9970_5F3A_5316 then
        return
    end
    local hid = GetHandleId(target)
    if _____6709_5973_5996_5934_9970 then
        _____5973_5996_5934_9970_7D2F_8BA1_8868[hid] = (_____5973_5996_5934_9970_7D2F_8BA1_8868[hid] or 0) + applied
        if (_____5973_5996_5934_9970_7D2F_8BA1_8868[hid] or 0) >= _____5973_5996_5934_9970_7D2F_8BA1_914D_7F6E["累计阈值"] then
            _____5973_5996_5934_9970_7D2F_8BA1_8868[hid] = 0
            _____53D1_8D77_6CBB_7597_6CE2_8DF3_94FE({
                ["起始目标"] = target,
                ["来源单位"] = attacker,
                ["影响目标"] = "敌方",
                ["最大跳数"] = 7,
                ["初始治疗量"] = 1,
                ["每跳最大距离"] = 600,
                ["每跳衰减系数"] = 0,
                ["允许重复治疗"] = false,
                ["跳跃间隔"] = 0.05,
                ["每跳回调"] = function(_____5355_4F4D)
                    _____65BD_52A0_6697_5F71_7A81_88AD_51CF_76CA(attacker, _____5355_4F4D, {duration = 2, damagePerSecond = 500})
                end
            })
        end
    end
    if _____6709_5973_5996_5934_9970_5F3A_5316 then
        _____5973_5996_5934_9970_5F3A_5316_547D_4E2D_8868[hid] = (_____5973_5996_5934_9970_5F3A_5316_547D_4E2D_8868[hid] or 0) + 1
        if (_____5973_5996_5934_9970_5F3A_5316_547D_4E2D_8868[hid] or 0) >= _____5973_5996_5934_9970_5F3A_5316_7D2F_8BA1_914D_7F6E["命中次数阈值"] then
            _____5973_5996_5934_9970_5F3A_5316_547D_4E2D_8868[hid] = 0
            _____53D1_8D77_6CBB_7597_6CE2_8DF3_94FE({
                ["起始目标"] = target,
                ["来源单位"] = target,
                ["影响目标"] = "敌方",
                ["最大跳数"] = 7,
                ["初始治疗量"] = 1,
                ["每跳最大距离"] = 600,
                ["每跳衰减系数"] = 0,
                ["允许重复治疗"] = false,
                ["跳跃间隔"] = 0.05,
                ["每跳回调"] = function(_____5355_4F4D)
                    _____65BD_52A0_6697_5F71_7A81_88AD_51CF_76CA(target, _____5355_4F4D, {duration = 2, damagePerSecond = 500})
                end
            })
        end
    end
end
return ____exports
