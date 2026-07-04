local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local jass = require("jass.common")
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却")
local _____5355_4F4D_6301_6709_88C5_5907 = ____require_result_1["单位持有装备"]
local _____53D6_88C5_5907_51B7_5374_952E = ____require_result_1["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____require_result_1["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374 = ____require_result_1["进入装备冷却"]
local _____88C5_5907_6982_7387_901A_8FC7 = ____require_result_1["装备概率通过"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.09．装备战斗判断")
local _____5355_4F4D_5B58_6D3B = ____require_result_2["单位存活"]
local _____662F_6280_80FD_4F24_5BB3 = ____require_result_2["是技能伤害"]
local _____662F_7EAF_666E_653B = ____require_result_2["是纯普攻"]
local _____6700_7EC8_4F24_5BB3_89E6_53D1_8BB0_5F55_8868 = {}
local _____6700_7EC8_4F24_5BB3_89E6_53D1_8BA1_6570 = 0
local GetHandleId = jass.GetHandleId
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_6301_6709_8005(target, attacker, config)
    local ____temp_3
    if (config["持有者"] or "攻击者") == "受击者" then
        ____temp_3 = target
    else
        ____temp_3 = attacker
    end
    return ____temp_3
end
local function _____901A_8FC7_4F24_5BB3_7C7B_578B_8FC7_6EE4(snapshot, config)
    local filter = config["伤害过滤"] or "任意"
    if filter == "技能" then
        return _____662F_6280_80FD_4F24_5BB3(snapshot)
    end
    if filter == "纯普攻" then
        return _____662F_7EAF_666E_653B(snapshot)
    end
    return true
end
local function _____53D6_51B7_5374_952E(holder, record)
    local tag = record["配置"]["冷却标签"] or record["配置"]["名称"] or record["配置"]["装备名"]
    return _____53D6_88C5_5907_51B7_5374_952E(holder, tag, record["配置"]["冷却前缀"] or "装备最终伤害触发")
end
local function _____51B7_5374_5141_8BB8(holder, record)
    local cd = record["配置"]["冷却秒数"] or 0
    if not (cd > 0) then
        return true
    end
    local key = _____53D6_51B7_5374_952E(holder, record)
    if _____88C5_5907_51B7_5374_4E2D(key) then
        return false
    end
    return true
end
local function _____8BB0_5F55_51B7_5374(holder, record)
    local cd = record["配置"]["冷却秒数"] or 0
    if not (cd > 0) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374(
        _____53D6_51B7_5374_952E(holder, record),
        cd
    )
end
local function _____901A_8FC7_6B21_6570_5E76_8BB0_5F55(holder, record)
    local threshold = record["配置"]["次数阈值"] or 1
    if not (threshold > 1) then
        return true
    end
    local id = _____53D6_5355_4F4DID(holder)
    if id == 0 then
        return false
    end
    local next = (record["次数表"][id] or 0) + 1
    if next < threshold then
        record["次数表"][id] = next
        return false
    end
    if record["配置"]["触发后清空次数"] ~= false then
        __TS__Delete(record["次数表"], id)
    else
        record["次数表"][id] = next
    end
    return true
end
local function _____5C1D_8BD5_6267_884C_6700_7EC8_4F24_5BB3_89E6_53D1(target, attacker, applied, snapshot, record)
    if record["已停止"] or not (applied > 0) then
        return
    end
    local config = record["配置"]
    local holder = _____53D6_6301_6709_8005(target, attacker, config)
    if holder == nil or holder == 0 then
        return
    end
    local ____temp_7 = config["要求双方存活"] ~= false
    if ____temp_7 then
        local ____temp_6 = not _____5355_4F4D_5B58_6D3B(holder)
        if not ____temp_6 then
            local ____5355_4F4D_5B58_6D3B_5 = _____5355_4F4D_5B58_6D3B
            local ____temp_4
            if (config["持有者"] or "攻击者") == "受击者" then
                ____temp_4 = attacker
            else
                ____temp_4 = target
            end
            ____temp_6 = not ____5355_4F4D_5B58_6D3B_5(____temp_4)
        end
        ____temp_7 = ____temp_6
    end
    if ____temp_7 then
        return
    end
    if not _____5355_4F4D_6301_6709_88C5_5907(holder, config["装备名"]) then
        return
    end
    if not _____901A_8FC7_4F24_5BB3_7C7B_578B_8FC7_6EE4(snapshot, config) then
        return
    end
    local event = {
        ["目标"] = target,
        ["攻击者"] = attacker,
        ["持有者"] = holder,
        ["本次伤害"] = applied,
        ["伤害快照"] = snapshot,
        ["配置"] = config
    }
    if config["自定义过滤"] ~= nil and not config["自定义过滤"](event) then
        return
    end
    local chance = config["概率"] or 1
    if not _____88C5_5907_6982_7387_901A_8FC7(holder, chance) then
        return
    end
    if not _____51B7_5374_5141_8BB8(holder, record) then
        return
    end
    if not _____901A_8FC7_6B21_6570_5E76_8BB0_5F55(holder, record) then
        return
    end
    _____8BB0_5F55_51B7_5374(holder, record)
    config["on触发"](event)
end
local function ____on_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F(target, attacker, applied, snapshot)
    for key in pairs(_____6700_7EC8_4F24_5BB3_89E6_53D1_8BB0_5F55_8868) do
        local record = _____6700_7EC8_4F24_5BB3_89E6_53D1_8BB0_5F55_8868[__TS__Number(key) or 0]
        if record ~= nil then
            _____5C1D_8BD5_6267_884C_6700_7EC8_4F24_5BB3_89E6_53D1(
                target,
                attacker,
                applied,
                snapshot,
                record
            )
        end
    end
end
registerAppliedFinalDamageListener(____on_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F)
____exports["注册最终伤害触发模板"] = function(_____914D_7F6E)
    _____6700_7EC8_4F24_5BB3_89E6_53D1_8BA1_6570 = _____6700_7EC8_4F24_5BB3_89E6_53D1_8BA1_6570 + 1
    local id = _____6700_7EC8_4F24_5BB3_89E6_53D1_8BA1_6570
    local record
    record = {
        ID = id,
        ["名称"] = _____914D_7F6E["名称"] or "最终伤害触发#" .. tostring(id),
        ["配置"] = _____914D_7F6E,
        ["次数表"] = {},
        ["已停止"] = false,
        ["读取次数"] = function(_____5355_4F4D)
            return record["次数表"][_____53D6_5355_4F4DID(_____5355_4F4D)] or 0
        end,
        ["清空"] = function(_____5355_4F4D)
            if _____5355_4F4D == nil then
                record["次数表"] = {}
                return
            end
            __TS__Delete(
                record["次数表"],
                _____53D6_5355_4F4DID(_____5355_4F4D)
            )
        end,
        ["停止"] = function()
            record["已停止"] = true
            record["次数表"] = {}
            __TS__Delete(_____6700_7EC8_4F24_5BB3_89E6_53D1_8BB0_5F55_8868, id)
        end
    }
    _____6700_7EC8_4F24_5BB3_89E6_53D1_8BB0_5F55_8868[id] = record
    return record
end
return ____exports
