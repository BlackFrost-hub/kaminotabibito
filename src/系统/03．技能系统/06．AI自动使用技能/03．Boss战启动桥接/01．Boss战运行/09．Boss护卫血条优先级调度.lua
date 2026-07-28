--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____05_FF0EBoss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.05．Boss战斗启动护卫配置表")
local ____Boss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 = ____05_FF0EBoss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868["Boss战斗启动护卫配置表"]
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.01．常量定义")
local ____Boss_62A4_536B_8840_6761UI_5E38_91CF = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss护卫血条UI常量"]
local ____07_FF0EBoss_5F31_70B9_4E8B_4EF6_6865_63A5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.07．Boss弱点事件桥接")
local _____542F_52A8Boss_62A4_536B_8840_6761_5F31_70B9_97E7_6027 = ____07_FF0EBoss_5F31_70B9_4E8B_4EF6_6865_63A5["启动Boss护卫血条弱点韧性"]
local _____7ED3_675FBoss_62A4_536B_8840_6761_5F31_70B9_97E7_6027 = ____07_FF0EBoss_5F31_70B9_4E8B_4EF6_6865_63A5["结束Boss护卫血条弱点韧性"]
local ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["获取全部Boss血条弱点韧性运行状态"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.01．单位系统.10．护卫系统.index")
local _____83B7_53D6Boss_62A4_536B_5217_8868 = ____require_result_1["获取Boss护卫列表"]
local _____83B7_53D6_62A4_536B_8BB0_5F55 = ____require_result_1["获取护卫记录"]
local function _____83B7_53D6_62A4_536B_8840_6761_5F52_5C5E_7C7B_578B(context)
    local bossTypeId = GetUnitTypeId(context["Boss单位"]) or 0
    do
        local i = 0
        while i < #____Boss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 do
            local config = ____Boss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868[i + 1]
            if stringToFourCCSafe(config["Boss单位ID"]) == bossTypeId then
                return config["护卫血条归属类型"]
            end
            i = i + 1
        end
    end
    return "独立"
end
local function _____5019_9009_5E94_6392_5728_524D_9762(left, right)
    if left["优先级"] ~= right["优先级"] then
        return left["优先级"] > right["优先级"]
    end
    if left["登记顺序"] ~= right["登记顺序"] then
        return left["登记顺序"] < right["登记顺序"]
    end
    return left.handleId < right.handleId
end
local function _____6392_5E8F_62A4_536B_8840_6761_5019_9009(list)
    do
        local i = 1
        while i < #list do
            local current = list[i + 1]
            local insertIndex = i - 1
            while insertIndex >= 0 and _____5019_9009_5E94_6392_5728_524D_9762(current, list[insertIndex + 1]) do
                list[insertIndex + 1 + 1] = list[insertIndex + 1]
                insertIndex = insertIndex - 1
            end
            list[insertIndex + 1 + 1] = current
            i = i + 1
        end
    end
end
local function _____6536_96C6Boss_62A4_536B_8840_6761_5019_9009(context, _____5F52_5C5E_7C7B_578B)
    local result = {}
    local guards = _____83B7_53D6Boss_62A4_536B_5217_8868(context["Boss单位"], true)
    do
        local i = 0
        while i < #guards do
            do
                local unit = guards[i + 1]
                local record = _____83B7_53D6_62A4_536B_8BB0_5F55(unit)
                local handleId = GetHandleId(unit) or 0
                if record == nil or record["主Boss单位"] ~= context["Boss单位"] or handleId == 0 then
                    goto __continue15
                end
                if not (record["护卫血条优先级"] > 0) then
                    goto __continue15
                end
                result[#result + 1] = {
                    unit = unit,
                    handleId = handleId,
                    ["优先级"] = record["护卫血条优先级"],
                    ["登记顺序"] = record["登记顺序"],
                    ["Boss战上下文"] = context,
                    ["归属类型"] = _____5F52_5C5E_7C7B_578B
                }
            end
            ::__continue15::
            i = i + 1
        end
    end
    _____6392_5E8F_62A4_536B_8840_6761_5019_9009(result)
    return result
end
local function _____622A_53D6_53EF_663E_793A_5019_9009(list)
    local result = {}
    local count = #list < ____Boss_62A4_536B_8840_6761UI_5E38_91CF["最大显示数量"] and #list or ____Boss_62A4_536B_8840_6761UI_5E38_91CF["最大显示数量"]
    do
        local i = 0
        while i < count do
            result[#result + 1] = list[i + 1]
            i = i + 1
        end
    end
    return result
end
local function _____6392_5E8F_5F53_524D_62A4_536B_8840_6761_72B6_6001(list)
    do
        local i = 1
        while i < #list do
            local current = list[i + 1]
            local insertIndex = i - 1
            while insertIndex >= 0 and list[insertIndex + 1]["护卫槽位索引"] > current["护卫槽位索引"] do
                list[insertIndex + 1 + 1] = list[insertIndex + 1]
                insertIndex = insertIndex - 1
            end
            list[insertIndex + 1 + 1] = current
            i = i + 1
        end
    end
end
local function _____83B7_53D6_5F53_524D_62A4_536B_8840_6761_72B6_6001(_____5F52_5C5E_7C7B_578B, _____4E3BBoss_53E5_67C4ID)
    local result = {}
    local states = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    do
        local i = 0
        while i < #states do
            do
                local state = states[i + 1]
                if state["显示类型"] ~= "护卫" or state["是否已结束"] or not state["是否血条已注册"] then
                    goto __continue27
                end
                if state["护卫血条归属类型"] ~= _____5F52_5C5E_7C7B_578B then
                    goto __continue27
                end
                if _____5F52_5C5E_7C7B_578B == "独立" and state["所属主Boss句柄ID"] ~= _____4E3BBoss_53E5_67C4ID then
                    goto __continue27
                end
                result[#result + 1] = state
            end
            ::__continue27::
            i = i + 1
        end
    end
    _____6392_5E8F_5F53_524D_62A4_536B_8840_6761_72B6_6001(result)
    return result
end
local function _____5F53_524D_663E_793A_987A_5E8F_76F8_540C(current, selected)
    if #current ~= #selected then
        return false
    end
    do
        local i = 0
        while i < #selected do
            if current[i + 1]["Boss句柄ID"] ~= selected[i + 1].handleId then
                return false
            end
            i = i + 1
        end
    end
    return true
end
local function _____91CD_5EFA_62A4_536B_8840_6761_7EC4(current, selected)
    if _____5F53_524D_663E_793A_987A_5E8F_76F8_540C(current, selected) then
        return
    end
    do
        local i = 0
        while i < #current do
            _____7ED3_675FBoss_62A4_536B_8840_6761_5F31_70B9_97E7_6027(current[i + 1]["Boss单位"])
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #selected do
            local candidate = selected[i + 1]
            _____542F_52A8Boss_62A4_536B_8840_6761_5F31_70B9_97E7_6027(candidate["Boss战上下文"], candidate.unit, candidate["归属类型"])
            i = i + 1
        end
    end
end
local function _____540C_6B65_72EC_7ACBBoss_62A4_536B_8840_6761(context)
    local selected = _____622A_53D6_53EF_663E_793A_5019_9009(_____6536_96C6Boss_62A4_536B_8840_6761_5019_9009(context, "独立"))
    local current = _____83B7_53D6_5F53_524D_62A4_536B_8840_6761_72B6_6001("独立", context["Boss句柄ID"])
    _____91CD_5EFA_62A4_536B_8840_6761_7EC4(current, selected)
end
____exports["同步全部Boss护卫血条优先级"] = function(contexts)
    local activeIndependentBossIds = {}
    local sharedCandidates = {}
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if context == nil or context["是否已结束"] or not context["是否已激活"] then
                    goto __continue45
                end
                local ownership = _____83B7_53D6_62A4_536B_8840_6761_5F52_5C5E_7C7B_578B(context)
                if ownership == "共享" then
                    local candidates = _____6536_96C6Boss_62A4_536B_8840_6761_5019_9009(context, "共享")
                    do
                        local j = 0
                        while j < #candidates do
                            sharedCandidates[#sharedCandidates + 1] = candidates[j + 1]
                            j = j + 1
                        end
                    end
                else
                    activeIndependentBossIds[context["Boss句柄ID"]] = true
                    _____540C_6B65_72EC_7ACBBoss_62A4_536B_8840_6761(context)
                end
            end
            ::__continue45::
            i = i + 1
        end
    end
    local allStates = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    do
        local i = 0
        while i < #allStates do
            do
                local state = allStates[i + 1]
                if state["显示类型"] ~= "护卫" or state["是否已结束"] then
                    goto __continue52
                end
                if state["护卫血条归属类型"] == "独立" and activeIndependentBossIds[state["所属主Boss句柄ID"]] ~= true then
                    _____7ED3_675FBoss_62A4_536B_8840_6761_5F31_70B9_97E7_6027(state["Boss单位"])
                end
            end
            ::__continue52::
            i = i + 1
        end
    end
    _____6392_5E8F_62A4_536B_8840_6761_5019_9009(sharedCandidates)
    local selectedShared = _____622A_53D6_53EF_663E_793A_5019_9009(sharedCandidates)
    local currentShared = _____83B7_53D6_5F53_524D_62A4_536B_8840_6761_72B6_6001("共享", 0)
    _____91CD_5EFA_62A4_536B_8840_6761_7EC4(currentShared, selectedShared)
end
return ____exports
