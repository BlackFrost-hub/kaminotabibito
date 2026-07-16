local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____21_FF0E_4E0D_540C_6280_80FD_5E8F_5217_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.21．不同技能序列状态")
local _____521B_5EFA_4E0D_540C_6280_80FD_5E8F_5217_72B6_6001 = ____21_FF0E_4E0D_540C_6280_80FD_5E8F_5217_72B6_6001["创建不同技能序列状态"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____require_result_1["单位持有装备"]
local _____662F_6280_80FD_4F24_5BB3 = ____require_result_1["是技能伤害"]
local _____8BB0_5F55_8868 = {}
local _____4E0B_4E00_4E2AID = 0
local function _____9ED8_8BA4_53D6_6280_80FD_952E(event)
    local snapshot = event["伤害快照"]
    local ____opt_result_4
    if snapshot ~= nil then
        ____opt_result_4 = snapshot.abilityId
    end
    local ____opt_result_4_8 = ____opt_result_4
    if ____opt_result_4_8 == nil then
        local ____opt_result_7
        if snapshot ~= nil then
            ____opt_result_7 = snapshot.skillInstanceId
        end
        ____opt_result_4_8 = ____opt_result_7
    end
    local ____opt_result_4_8_12 = ____opt_result_4_8
    if ____opt_result_4_8_12 == nil then
        local ____opt_result_11
        if snapshot ~= nil then
            ____opt_result_11 = snapshot.tag
        end
        ____opt_result_4_8_12 = ____opt_result_11
    end
    local ____opt_result_4_8_12_13 = ____opt_result_4_8_12
    if ____opt_result_4_8_12_13 == nil then
        ____opt_result_4_8_12_13 = ""
    end
    return tostring(____opt_result_4_8_12_13)
end
local function _____5C1D_8BD5_89E6_53D1_8BB0_5F55(record, target, attacker, applied, snapshot)
    if record["已停止"] or not (applied > 0) or not _____5355_4F4D_6301_6709_88C5_5907(attacker, record["参数"]["装备名"]) or not _____662F_6280_80FD_4F24_5BB3(snapshot) then
        return
    end
    local event = {
        ["攻击者"] = attacker,
        ["目标"] = target,
        ["本次伤害"] = applied,
        ["伤害快照"] = snapshot,
        ["技能键"] = ""
    }
    event["技能键"] = record["参数"]["取技能键"] == nil and _____9ED8_8BA4_53D6_6280_80FD_952E(event) or record["参数"]["取技能键"](event)
    if event["技能键"] == "" or record["参数"]["过滤事件"] ~= nil and not record["参数"]["过滤事件"](event) then
        return
    end
    local ____temp_14
    if (record["参数"]["作用域"] or "主体") == "主体与目标" then
        ____temp_14 = target
    else
        ____temp_14 = nil
    end
    local scopeTarget = ____temp_14
    if (record["参数"]["触发时机"] or "达成时") == "下一次技能伤害" then
        local ____self_15 = record["状态"]
        local ready = ____self_15["读取"](____self_15, attacker, scopeTarget)
        if (ready and ready["已就绪"]) == true then
            local ____self_18 = record["状态"]
            ____self_18["消耗"](____self_18, attacker, scopeTarget)
            record["参数"]["on触发"](event)
            return
        end
    end
    local ____self_19 = record["状态"]
    local result = ____self_19["记录"](____self_19, attacker, event["技能键"], scopeTarget)
    if (record["参数"]["触发时机"] or "达成时") == "达成时" and (result and result["刚刚就绪"]) == true then
        local ____self_22 = record["状态"]
        ____self_22["消耗"](____self_22, attacker, scopeTarget)
        record["参数"]["on触发"](event)
    end
end
local function ____on_4E0D_540C_6280_80FD_4F24_5BB3_5E8F_5217(target, attacker, applied, snapshot)
    for key in pairs(_____8BB0_5F55_8868) do
        local record = _____8BB0_5F55_8868[__TS__Number(key) or 0]
        if record ~= nil then
            _____5C1D_8BD5_89E6_53D1_8BB0_5F55(
                record,
                target,
                attacker,
                applied,
                snapshot
            )
        end
    end
end
registerAppliedFinalDamageListener(____on_4E0D_540C_6280_80FD_4F24_5BB3_5E8F_5217)
____exports["注册不同技能伤害序列触发模板"] = function(_____53C2_6570)
    _____4E0B_4E00_4E2AID = _____4E0B_4E00_4E2AID + 1
    local id = _____4E0B_4E00_4E2AID
    local record = {
        ID = id,
        ["参数"] = _____53C2_6570,
        ["状态"] = _____521B_5EFA_4E0D_540C_6280_80FD_5E8F_5217_72B6_6001({
            ["名称"] = _____53C2_6570["名称"],
            ["需要不同技能数"] = _____53C2_6570["需要不同技能数"],
            ["时间窗毫秒"] = _____53C2_6570["时间窗毫秒"],
            ["作用域"] = _____53C2_6570["作用域"],
            ["重复策略"] = _____53C2_6570["重复策略"]
        }),
        ["已停止"] = false
    }
    _____8BB0_5F55_8868[id] = record
    return {
        ["名称"] = _____53C2_6570["名称"],
        ["清空"] = function()
            local ____self_23 = record["状态"]
            ____self_23["清空全部"](____self_23)
        end,
        ["停止"] = function()
            if not record["已停止"] then
                record["已停止"] = true
                local ____self_24 = record["状态"]
                ____self_24["销毁"](____self_24)
                __TS__Delete(_____8BB0_5F55_8868, id)
            end
        end
    }
end
return ____exports
