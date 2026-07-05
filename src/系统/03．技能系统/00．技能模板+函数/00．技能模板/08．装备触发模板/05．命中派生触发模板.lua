local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local jass = require("jass.common")
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却")
local _____5355_4F4D_6301_6709_88C5_5907 = ____require_result_1["单位持有装备"]
local _____53D6_88C5_5907_51B7_5374_952E = ____require_result_1["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____require_result_1["装备冷却中"]
local _____53D6_88C5_5907_51B7_5374_5269_4F59_6BEB_79D2 = ____require_result_1["取装备冷却剩余毫秒"]
local _____8BBE_7F6E_88C5_5907_51B7_5374 = ____require_result_1["设置装备冷却"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____require_result_1["进入装备冷却并显示"]
local _____663E_793A_5355_4F4D_88C5_5907_51B7_5374 = ____require_result_1["显示单位装备冷却"]
local _____83B7_53D6_5355_4F4D_88C5_5907_7269_54C1 = ____require_result_1["获取单位装备物品"]
local _____53D6_88C5_5907_663E_793A_51B7_5374_5269_4F59 = ____require_result_1["取装备显示冷却剩余"]
local _____88C5_5907_6982_7387_901A_8FC7 = ____require_result_1["装备概率通过"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.09．装备战斗判断")
local _____5355_4F4D_5B58_6D3B = ____require_result_2["单位存活"]
local _____662F_6280_80FD_4F24_5BB3 = ____require_result_2["是技能伤害"]
local _____662F_7EAF_666E_653B = ____require_result_2["是纯普攻"]
local _____662F_654C_5BF9_5355_4F4D = ____require_result_2["是敌对单位"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____require_result_3["造成装备伤害"]
local _____53D6_8303_56F4_654C_4EBA = ____require_result_3["取范围敌人"]
local ____require_result_4 = require("系统.09．表现系统.01．UI工具.07．物品栏冷却显示")
local _____8BBE_7F6E_7269_54C1_680F_7269_54C1_51B7_5374 = ____require_result_4["设置物品栏物品冷却"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.15．单位窗口累计值")
local _____521B_5EFA_7A97_53E3_4E8B_4EF6_8BA1_6570_5668 = ____require_result_5["创建窗口事件计数器"]
local GetHandleId = jass.GetHandleId
local _____547D_4E2D_6D3E_751F_89E6_53D1_8BB0_5F55_8868 = {}
local _____547D_4E2D_6D3E_751F_89E6_53D1_8BA1_6570 = 0
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_6301_6709_8005(target, attacker, config)
    local ____temp_6
    if (config["持有者"] or "攻击者") == "受击者" then
        ____temp_6 = target
    else
        ____temp_6 = attacker
    end
    return ____temp_6
end
local function _____662F_88C5_5907_6280_80FD_547D_4E2D(snapshot)
    return snapshot ~= nil and snapshot.isEquipmentSkillDamage == true
end
local function _____662F_88C5_5907_4E3B_52A8_547D_4E2D(snapshot)
    if not _____662F_88C5_5907_6280_80FD_547D_4E2D(snapshot) then
        return false
    end
    local ____snapshot_equipmentSkillDamageKind_7 = snapshot.equipmentSkillDamageKind
    if ____snapshot_equipmentSkillDamageKind_7 == nil then
        ____snapshot_equipmentSkillDamageKind_7 = snapshot.skillDamageSourceKind
    end
    local kind = ____snapshot_equipmentSkillDamageKind_7
    return kind == "装备主动" or kind == "物品技能"
end
local function _____662F_88C5_5907_6280_80FD_6765_6E90_6807_8BB0(kind)
    return kind == "装备技能" or kind == "装备主动" or kind == "装备被动" or kind == "物品技能" or kind == "装备持续伤害"
end
local function _____662F_4E3B_52A8_6280_80FD_547D_4E2D(snapshot)
    if not _____662F_6280_80FD_4F24_5BB3(snapshot) then
        return false
    end
    if snapshot.isEquipmentSkillDamage == true then
        return false
    end
    if _____662F_88C5_5907_6280_80FD_6765_6E90_6807_8BB0(snapshot.equipmentSkillDamageKind) then
        return false
    end
    if _____662F_88C5_5907_6280_80FD_6765_6E90_6807_8BB0(snapshot.skillDamageSourceKind) then
        return false
    end
    return true
end
local function _____901A_8FC7_547D_4E2D_8FC7_6EE4(snapshot, config)
    local filter = config["命中过滤"] or "任意"
    if filter == "技能" then
        return _____662F_6280_80FD_4F24_5BB3(snapshot)
    end
    if filter == "主动技能" then
        return _____662F_4E3B_52A8_6280_80FD_547D_4E2D(snapshot)
    end
    if filter == "装备技能" then
        return _____662F_88C5_5907_6280_80FD_547D_4E2D(snapshot)
    end
    if filter == "装备主动" then
        return _____662F_88C5_5907_4E3B_52A8_547D_4E2D(snapshot)
    end
    if filter == "纯普攻" then
        return _____662F_7EAF_666E_653B(snapshot)
    end
    if filter == "技能或纯普攻" then
        return _____662F_6280_80FD_4F24_5BB3(snapshot) or _____662F_7EAF_666E_653B(snapshot)
    end
    if filter == "主动技能或纯普攻" then
        return _____662F_4E3B_52A8_6280_80FD_547D_4E2D(snapshot) or _____662F_7EAF_666E_653B(snapshot)
    end
    if filter == "装备主动或纯普攻" then
        return _____662F_88C5_5907_4E3B_52A8_547D_4E2D(snapshot) or _____662F_7EAF_666E_653B(snapshot)
    end
    return true
end
local function _____53D6_51B7_5374_952E(holder, record)
    local tag = record["配置"]["冷却标签"] or record["配置"]["名称"] or record["配置"]["装备名"]
    return _____53D6_88C5_5907_51B7_5374_952E(holder, tag, record["配置"]["冷却前缀"] or "装备命中派生触发")
end
local function _____540C_6B65_51B7_5374_663E_793A(holder, _____88C5_5907_540D, key)
    if key == "" then
        return
    end
    _____663E_793A_5355_4F4D_88C5_5907_51B7_5374(holder, _____88C5_5907_540D, key, "独有")
    local item = _____83B7_53D6_5355_4F4D_88C5_5907_7269_54C1(holder, _____88C5_5907_540D)
    if item == nil or item == 0 then
        return
    end
    _____8BBE_7F6E_7269_54C1_680F_7269_54C1_51B7_5374(
        holder,
        item,
        _____53D6_88C5_5907_663E_793A_51B7_5374_5269_4F59(holder, item, key)
    )
end
local function _____547D_4E2D_51CF_5C11_51B7_5374(holder, record, key)
    local reduceSec = record["配置"]["命中减冷却秒数"] or 0
    if not (reduceSec > 0) or key == "" then
        return
    end
    local remaining = _____53D6_88C5_5907_51B7_5374_5269_4F59_6BEB_79D2(key)
    if not (remaining > 0) then
        return
    end
    local next = remaining - reduceSec * 1000
    _____8BBE_7F6E_88C5_5907_51B7_5374(key, next > 0 and next / 1000 or 0)
    _____540C_6B65_51B7_5374_663E_793A(holder, record["配置"]["装备名"], key)
end
local function _____51B7_5374_5141_8BB8(key, record)
    local cd = record["配置"]["冷却秒数"] or 0
    if not (cd > 0) then
        return true
    end
    return not _____88C5_5907_51B7_5374_4E2D(key)
end
local function _____8BB0_5F55_51B7_5374(holder, record, key)
    local cd = record["配置"]["冷却秒数"] or 0
    if not (cd > 0) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(key, cd, holder, record["配置"]["装备名"])
end
local function _____53D6_8BA1_6570_952E(holder, target, record)
    local holderId = _____53D6_5355_4F4DID(holder)
    if holderId == 0 then
        return ""
    end
    if (record["配置"]["计数作用域"] or "持有者") ~= "持有者目标" then
        return tostring(holderId)
    end
    local targetId = _____53D6_5355_4F4DID(target)
    if targetId == 0 then
        return ""
    end
    return (tostring(holderId) .. ":") .. tostring(targetId)
end
local function _____8BFB_53D6_8BA1_6570_72B6_6001_6B21_6570(record, key)
    if key == "" then
        return 0
    end
    local ____self_8 = record["计数器"]
    return ____self_8["读取"](____self_8, key, record["配置"]["窗口秒数"] or 0)
end
local function _____901A_8FC7_6B21_6570_5E76_8BB0_5F55(holder, target, record)
    local threshold = record["配置"]["次数阈值"] or 1
    if not (threshold > 1) then
        return 1
    end
    local key = _____53D6_8BA1_6570_952E(holder, target, record)
    if key == "" then
        return 0
    end
    local ____self_9 = record["计数器"]
    return ____self_9["增加"](
        ____self_9,
        key,
        record["配置"]["窗口秒数"] or 0,
        record["配置"]["触发后清空次数"] ~= false,
        threshold
    )
end
local function _____5C1D_8BD5_6267_884C_547D_4E2D_6D3E_751F_89E6_53D1(target, attacker, applied, snapshot, record)
    if record["已停止"] or not (applied > 0) then
        return
    end
    local config = record["配置"]
    local holder = _____53D6_6301_6709_8005(target, attacker, config)
    if holder == nil or holder == 0 then
        return
    end
    local ____temp_13 = config["要求双方存活"] ~= false
    if ____temp_13 then
        local ____temp_12 = not _____5355_4F4D_5B58_6D3B(holder)
        if not ____temp_12 then
            local ____5355_4F4D_5B58_6D3B_11 = _____5355_4F4D_5B58_6D3B
            local ____temp_10
            if (config["持有者"] or "攻击者") == "受击者" then
                ____temp_10 = attacker
            else
                ____temp_10 = target
            end
            ____temp_12 = not ____5355_4F4D_5B58_6D3B_11(____temp_10)
        end
        ____temp_13 = ____temp_12
    end
    if ____temp_13 then
        return
    end
    if config["要求敌对"] ~= false and not _____662F_654C_5BF9_5355_4F4D(attacker, target) then
        return
    end
    if not _____5355_4F4D_6301_6709_88C5_5907(holder, config["装备名"]) then
        return
    end
    if not _____901A_8FC7_547D_4E2D_8FC7_6EE4(snapshot, config) then
        return
    end
    local key = _____53D6_51B7_5374_952E(holder, record)
    _____547D_4E2D_51CF_5C11_51B7_5374(holder, record, key)
    local event = {
        ["目标"] = target,
        ["攻击者"] = attacker,
        ["持有者"] = holder,
        ["本次伤害"] = applied,
        ["伤害快照"] = snapshot,
        ["当前次数"] = 0,
        ["冷却键"] = key,
        ["配置"] = config
    }
    if config["自定义过滤"] ~= nil and not config["自定义过滤"](event) then
        return
    end
    if not _____51B7_5374_5141_8BB8(key, record) then
        return
    end
    local current = _____901A_8FC7_6B21_6570_5E76_8BB0_5F55(holder, target, record)
    if current <= 0 then
        return
    end
    event["当前次数"] = current
    if current < (config["次数阈值"] or 1) then
        return
    end
    local chance = config["概率"] or 1
    if not _____88C5_5907_6982_7387_901A_8FC7(holder, chance) then
        return
    end
    _____8BB0_5F55_51B7_5374(holder, record, key)
    config["on触发"](event)
end
local function ____on_547D_4E2D_6D3E_751F_89E6_53D1_6A21_677F(target, attacker, applied, snapshot)
    for key in pairs(_____547D_4E2D_6D3E_751F_89E6_53D1_8BB0_5F55_8868) do
        local record = _____547D_4E2D_6D3E_751F_89E6_53D1_8BB0_5F55_8868[__TS__Number(key) or 0]
        if record ~= nil then
            _____5C1D_8BD5_6267_884C_547D_4E2D_6D3E_751F_89E6_53D1(
                target,
                attacker,
                applied,
                snapshot,
                record
            )
        end
    end
end
registerAppliedFinalDamageListener(____on_547D_4E2D_6D3E_751F_89E6_53D1_6A21_677F)
____exports["注册命中派生触发模板"] = function(_____914D_7F6E)
    _____547D_4E2D_6D3E_751F_89E6_53D1_8BA1_6570 = _____547D_4E2D_6D3E_751F_89E6_53D1_8BA1_6570 + 1
    local id = _____547D_4E2D_6D3E_751F_89E6_53D1_8BA1_6570
    local record
    record = {
        ID = id,
        ["名称"] = _____914D_7F6E["名称"] or "命中派生触发#" .. tostring(id),
        ["配置"] = _____914D_7F6E,
        ["计数器"] = _____521B_5EFA_7A97_53E3_4E8B_4EF6_8BA1_6570_5668(_____914D_7F6E["名称"] or "命中派生触发#" .. tostring(id)),
        ["已停止"] = false,
        ["读取次数"] = function(_____6301_6709_8005, _____76EE_6807)
            return _____8BFB_53D6_8BA1_6570_72B6_6001_6B21_6570(
                record,
                _____53D6_8BA1_6570_952E(_____6301_6709_8005, _____76EE_6807, record)
            )
        end,
        ["清空"] = function(_____6301_6709_8005, _____76EE_6807)
            if _____6301_6709_8005 == nil then
                local ____self_14 = record["计数器"]
                ____self_14["清空"](____self_14)
                return
            end
            local key = _____53D6_8BA1_6570_952E(_____6301_6709_8005, _____76EE_6807, record)
            if key ~= "" then
                local ____self_15 = record["计数器"]
                ____self_15["清空"](____self_15, key)
            end
        end,
        ["停止"] = function()
            record["已停止"] = true
            local ____self_16 = record["计数器"]
            ____self_16["清空"](____self_16)
            __TS__Delete(_____547D_4E2D_6D3E_751F_89E6_53D1_8BB0_5F55_8868, id)
        end
    }
    _____547D_4E2D_6D3E_751F_89E6_53D1_8BB0_5F55_8868[id] = record
    return record
end
local function _____8BA1_7B97_547D_4E2D_4F24_5BB3(value, event)
    if type(value) == "number" then
        return value
    end
    return value(event)
end
____exports["注册主动命中额外伤害"] = function(_____914D_7F6E)
    return ____exports["注册命中派生触发模板"](__TS__ObjectAssign(
        {},
        _____914D_7F6E,
        {
            ["命中过滤"] = _____914D_7F6E["命中过滤"] or "主动技能",
            ["on触发"] = function(event)
                local amount = _____8BA1_7B97_547D_4E2D_4F24_5BB3(_____914D_7F6E["伤害"], event)
                _____9020_6210_88C5_5907_4F24_5BB3(
                    event["持有者"],
                    event["目标"],
                    amount,
                    _____914D_7F6E["伤害类型"],
                    _____914D_7F6E.ranged == true,
                    _____914D_7F6E.weaponType,
                    {["装备技能类型"] = "装备被动", ["标签"] = _____914D_7F6E["伤害标签"] or _____914D_7F6E["名称"] or _____914D_7F6E["装备名"], ["伤害形态"] = "单体"}
                )
            end
        }
    ))
end
____exports["注册主动命中AOE伤害"] = function(_____914D_7F6E)
    return ____exports["注册命中派生触发模板"](__TS__ObjectAssign(
        {},
        _____914D_7F6E,
        {
            ["命中过滤"] = _____914D_7F6E["命中过滤"] or "主动技能",
            ["on触发"] = function(event)
                local amount = _____8BA1_7B97_547D_4E2D_4F24_5BB3(_____914D_7F6E["伤害"], event)
                local enemies = _____53D6_8303_56F4_654C_4EBA(event["持有者"], event["目标"], _____914D_7F6E["范围"])
                do
                    local i = 0
                    while i < #enemies do
                        _____9020_6210_88C5_5907_4F24_5BB3(
                            event["持有者"],
                            enemies[i + 1],
                            amount,
                            _____914D_7F6E["伤害类型"],
                            _____914D_7F6E.ranged == true,
                            _____914D_7F6E.weaponType,
                            {["装备技能类型"] = "装备被动", ["标签"] = _____914D_7F6E["伤害标签"] or _____914D_7F6E["名称"] or _____914D_7F6E["装备名"], ["伤害形态"] = "AOE"}
                        )
                        i = i + 1
                    end
                end
            end
        }
    ))
end
return ____exports
