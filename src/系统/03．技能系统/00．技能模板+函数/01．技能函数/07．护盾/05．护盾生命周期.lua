--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_62A4_76FE_5B9E_4F8B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.02．护盾实例")
local _____5220_9664_62A4_76FE_5B9E_4F8B = ____02_FF0E_62A4_76FE_5B9E_4F8B["删除护盾实例"]
local _____53D6_53E5_67C4ID = ____02_FF0E_62A4_76FE_5B9E_4F8B["取句柄ID"]
local _____5220_9664_5355_4F4D_6240_6709_62A4_76FE = ____02_FF0E_62A4_76FE_5B9E_4F8B["删除单位所有护盾"]
local _____83B7_53D6_6240_6709_6D3B_52A8_62A4_76FE_5B9E_4F8B = ____02_FF0E_62A4_76FE_5B9E_4F8B["获取所有活动护盾实例"]
local ____06_FF0E_62A4_76FE_6761_8868_73B0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.06．护盾条表现")
local _____5220_9664_62A4_76FE_6761 = ____06_FF0E_62A4_76FE_6761_8868_73B0["删除护盾条"]
local ____08_FF0E_62A4_76FE_56DE_8C03_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.08．护盾回调模板")
local _____663E_793A_62A4_76FE_5230_671F_6F02_6D6E_6587_5B57 = ____08_FF0E_62A4_76FE_56DE_8C03_6A21_677F["显示护盾到期漂浮文字"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
local offTick10ms = ____require_result_0.offTick10ms
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local TICK_INTERVAL = 0.02
local CENTER_TIMER_TICKS = 2
local UNIT_ALIVE_LIFE = 0.405
local _____5DF2_6CE8_518C_8BA1_65F6_5668 = false
local ____tick_8BA1_6570 = 0
local function _____5355_4F4D_5B58_6D3B(u)
    if u == nil or u == 0 then
        return false
    end
    if GetUnitTypeId(u) == 0 then
        return false
    end
    if IsUnitType(u, jass.UNIT_TYPE_DEAD) then
        return false
    end
    return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
local function _____5904_7406_62A4_76FE_5230_671F(_____5B9E_4F8B, _____539F_56E0)
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    _____5220_9664_62A4_76FE_5B9E_4F8B(_____5B9E_4F8B.id)
    if _____539F_56E0 == "到期" then
        _____663E_793A_62A4_76FE_5230_671F_6F02_6D6E_6587_5B57(_____5355_4F4D, _____5B9E_4F8B["类型"])
    end
    if _____539F_56E0 == "到期" and type(_____5B9E_4F8B["到期回调"]) == "function" then
        _____5B9E_4F8B["到期回调"](_____5355_4F4D, _____5B9E_4F8B.id)
    end
    if type(_____5B9E_4F8B["结束回调"]) == "function" then
        _____5B9E_4F8B["结束回调"](_____5355_4F4D, _____5B9E_4F8B.id, _____539F_56E0)
    end
end
local function ____on_62A4_76FE_7CFB_7EDFTick()
    ____tick_8BA1_6570 = ____tick_8BA1_6570 + 1
    if ____tick_8BA1_6570 < CENTER_TIMER_TICKS then
        return
    end
    ____tick_8BA1_6570 = 0
    local _____5230_671F_5217_8868 = {}
    local _____6D3B_52A8_62A4_76FE = _____83B7_53D6_6240_6709_6D3B_52A8_62A4_76FE_5B9E_4F8B()
    for ____, _____5B9E_4F8B in ipairs(_____6D3B_52A8_62A4_76FE) do
        do
            if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
                _____5230_671F_5217_8868[#_____5230_671F_5217_8868 + 1] = {["实例"] = _____5B9E_4F8B, ["原因"] = "单位死亡"}
                goto __continue12
            end
            if _____5B9E_4F8B["总持续时间"] > 0 then
                _____5B9E_4F8B["剩余时间"] = _____5B9E_4F8B["剩余时间"] - TICK_INTERVAL
                if _____5B9E_4F8B["剩余时间"] <= 0 then
                    _____5230_671F_5217_8868[#_____5230_671F_5217_8868 + 1] = {["实例"] = _____5B9E_4F8B, ["原因"] = "到期"}
                end
            end
        end
        ::__continue12::
    end
    for ____, ____value in ipairs(_____5230_671F_5217_8868) do
        local _____5B9E_4F8B = ____value["实例"]
        local _____539F_56E0 = ____value["原因"]
        _____5904_7406_62A4_76FE_5230_671F(_____5B9E_4F8B, _____539F_56E0)
    end
end
local function ____on_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(dyingUnit)
    if _____5355_4F4DID == 0 then
        return
    end
    local _____5220_9664_5217_8868 = _____5220_9664_5355_4F4D_6240_6709_62A4_76FE(_____5355_4F4DID)
    for ____, _____5B9E_4F8B in ipairs(_____5220_9664_5217_8868) do
        if type(_____5B9E_4F8B["结束回调"]) == "function" then
            _____5B9E_4F8B["结束回调"](dyingUnit, _____5B9E_4F8B.id, "单位死亡")
        end
    end
    _____5220_9664_62A4_76FE_6761(dyingUnit)
end
local _____5DF2_521D_59CB_5316 = false
____exports["初始化护盾生命周期"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    if not _____5DF2_6CE8_518C_8BA1_65F6_5668 then
        _____5DF2_6CE8_518C_8BA1_65F6_5668 = true
        onTick10ms(____on_62A4_76FE_7CFB_7EDFTick)
    end
    registerDeathListener(nil, ____on_5355_4F4D_6B7B_4EA1)
end
return ____exports
