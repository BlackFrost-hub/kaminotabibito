local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local _____53D6_5355_4F4D_53E5_67C4ID, _____8BFB_53D6_6280_80FD_80FD_529BID, _____83B7_53D6Boss_4E3B_52A8_8FD0_884C_72B6_6001, jass, stringToFourCCSafe, ____Boss_4E3B_52A8_8FD0_884C_72B6_6001_8868, _____6280_80FD_80FD_529BID_7F13_5B58
local ____02_FF0EAI_914D_7F6E_5DE5_5177 = require("系统.03．技能系统.06．AI自动使用技能.00．AI配置.02．AI配置工具")
local _____89E3_6790_5355_4F4DAI_914D_7F6E_5355_4F4D_7C7B_578BID = ____02_FF0EAI_914D_7F6E_5DE5_5177["解析单位AI配置单位类型ID"]
local ____01_FF0EBossAI_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.00．AI配置.01．BossAI配置表.index")
local ____BossAI_914D_7F6E_8868 = ____01_FF0EBossAI_914D_7F6E_8868["BossAI配置表"]
local ____04_FF0E_82F1_96C4BossAI_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.00．AI配置.04．英雄BossAI配置表.index")
local _____82F1_96C4BossAI_914D_7F6E_8868 = ____04_FF0E_82F1_96C4BossAI_914D_7F6E_8868["英雄BossAI配置表"]
local ____05_FF0E_5F02_754CBossAI_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.00．AI配置.05．异界BossAI配置表.index")
local _____5F02_754CBossAI_914D_7F6E_8868 = ____05_FF0E_5F02_754CBossAI_914D_7F6E_8868["异界BossAI配置表"]
local ____01_FF0EBoss_81EA_52A8_6280_80FD_6CE8_518C_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____83B7_53D6_6240_6709Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587 = ____01_FF0EBoss_81EA_52A8_6280_80FD_6CE8_518C_8868["获取所有Boss自动技能启动上下文"]
local _____6E05_7406Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587 = ____01_FF0EBoss_81EA_52A8_6280_80FD_6CE8_518C_8868["清理Boss自动技能启动上下文"]
local ____04_FF0EBoss_81EA_52A8_65BD_6CD5_5F00_5173 = require("系统.03．技能系统.06．AI自动使用技能.04．Boss自动施法开关")
local ____Boss_81EA_52A8_65BD_6CD5_662F_5426_5F00_542F = ____04_FF0EBoss_81EA_52A8_65BD_6CD5_5F00_5173["Boss自动施法是否开启"]
local ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.15．单位技能壳提示")
local _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A = ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A["设置单位技能壳普通提示"]
function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local handleId = jass:GetHandleId(unit)
    return handleId or 0
end
function _____8BFB_53D6_6280_80FD_80FD_529BID(skillId)
    local cached = _____6280_80FD_80FD_529BID_7F13_5B58[skillId]
    if cached ~= nil then
        return cached
    end
    local value = stringToFourCCSafe(skillId)
    _____6280_80FD_80FD_529BID_7F13_5B58[skillId] = value
    return value
end
function _____83B7_53D6Boss_4E3B_52A8_8FD0_884C_72B6_6001(unit)
    local handleId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    local state = ____Boss_4E3B_52A8_8FD0_884C_72B6_6001_8868[handleId]
    if state == nil then
        state = {
            ["下次检查时间"] = 0,
            ["下次可施法时间"] = 0,
            ["树魔下次技能索引"] = 0,
            ["技能提示已初始化"] = false,
            ["技能下次可用时间表"] = {}
        }
        ____Boss_4E3B_52A8_8FD0_884C_72B6_6001_8868[handleId] = state
    end
    return state
end
jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitName = jass.GetUnitName
local GetUnitState = jass.GetUnitState
local IssueImmediateOrderById = jass.IssueImmediateOrderById
local IssuePointOrderById = jass.IssuePointOrderById
local IssueTargetOrderById = jass.IssueTargetOrderById
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态")
local _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5 = ____require_result_2["单位是否正在原生施法"]
local _____5355_4F4D_662F_5426_6B63_5728_65BD_6CD5 = ____require_result_2["单位是否正在施法"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRangeOfUnit = ____require_result_4.getEnemyUnitsInRangeOfUnit
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local SUC_IsUnitAlive = ____require_result_5.SUC_IsUnitAlive
local SUC_MatchBasicTarget = ____require_result_5.SUC_MatchBasicTarget
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEDistanceBetweenUnitsSafe = ____require_result_6.YDWEDistanceBetweenUnitsSafe
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local ____require_result_8 = require("系统.01．单位系统.06．仇恨系统.02．目标选择")
local _____83B7_53D6_5E94_653B_51FB_76EE_6807 = ____require_result_8["获取应攻击目标"]
local ____require_result_9 = require("系统.03．技能系统.08．技能数据表.00．技能数据表")
local _____6280_80FD_6570_636E_8868 = ____require_result_9["技能数据表"]
local platformAbilityApi = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4 = platformAbilityApi["技能_获取技能当前冷却时间"]
local _____6280_80FD__83B7_53D6_6280_80FD_65BD_6CD5_8DDD_79BB = platformAbilityApi["技能_获取技能施法距离"]
local _____6280_80FD__83B7_53D6_6280_80FD_65BD_6CD5_8303_56F4 = platformAbilityApi["技能_获取技能施法范围"]
local _____6280_80FD__83B7_53D6_6280_80FD_547D_4EE4_7F16_53F7 = platformAbilityApi["技能_获取技能命令编号"]
local ____require_result_10 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_10["技能_设置技能冷却时间"]
local _____6A21_5757_540D = "Boss主动扫描施法"
local _____9ED8_8BA4_626B_63CF_95F4_9694_6BEB_79D2 = 250
local _____9ED8_8BA4_516C_5171_65BD_6CD5_95F4_9694_6BEB_79D2 = 1000
____Boss_4E3B_52A8_8FD0_884C_72B6_6001_8868 = {}
_____6280_80FD_80FD_529BID_7F13_5B58 = {}
local _____6280_80FD_65BD_6CD5_8DDD_79BB_7F13_5B58 = {}
local _____6280_80FD_65BD_6CD5_8303_56F4_7F13_5B58 = {}
local ____Boss_4E3B_52A8_626B_63CF_56DE_8C03ID = 0
local ____array_11 = __TS__SparseArrayNew(table.unpack(____BossAI_914D_7F6E_8868))
__TS__SparseArrayPush(
    ____array_11,
    table.unpack(_____82F1_96C4BossAI_914D_7F6E_8868)
)
__TS__SparseArrayPush(
    ____array_11,
    table.unpack(_____5F02_754CBossAI_914D_7F6E_8868)
)
local ____Boss_4E3B_52A8_626B_63CF_914D_7F6E_8868 = {__TS__SparseArraySpread(____array_11)}
local function _____8BFB_53D6_6570_503C_5B57_6BB5(raw)
    if raw == nil then
        return 0
    end
    if type(raw) == "number" then
        return raw
    end
    if type(raw) == "string" then
        local value = __TS__ParseFloat(raw)
        return __TS__NumberIsNaN(__TS__Number(value)) and 0 or value
    end
    if type(raw) == "table" then
        local directKeys = {"1", 1, "0", 0}
        do
            local i = 0
            while i < #directKeys do
                local value = raw[directKeys[i + 1]]
                if value ~= nil and value ~= "" then
                    return _____8BFB_53D6_6570_503C_5B57_6BB5(value)
                end
                i = i + 1
            end
        end
        local keys = __TS__ArraySort(
            __TS__ObjectKeys(raw),
            function(____, a, b)
                local na = __TS__ParseInt(a, 10)
                local nb = __TS__ParseInt(b, 10)
                if __TS__NumberIsNaN(__TS__Number(na)) and __TS__NumberIsNaN(__TS__Number(nb)) then
                    return a < b and -1 or 1
                end
                if __TS__NumberIsNaN(__TS__Number(na)) then
                    return 1
                end
                if __TS__NumberIsNaN(__TS__Number(nb)) then
                    return -1
                end
                return na - nb
            end
        )
        do
            local i = 0
            while i < #keys do
                local value = raw[keys[i + 1]]
                if value ~= nil and value ~= "" then
                    return _____8BFB_53D6_6570_503C_5B57_6BB5(value)
                end
                i = i + 1
            end
        end
    end
    return 0
end
local function _____8BFB_53D6_6280_80FD_8868_6570_503C(skillId, field)
    local _____7F13_5B58_952E = (skillId .. ":") .. field
    local ____temp_12
    if field == "Rng" then
        ____temp_12 = _____6280_80FD_65BD_6CD5_8DDD_79BB_7F13_5B58[_____7F13_5B58_952E]
    else
        ____temp_12 = _____6280_80FD_65BD_6CD5_8303_56F4_7F13_5B58[_____7F13_5B58_952E]
    end
    local cached = ____temp_12
    if cached ~= nil then
        return cached
    end
    local entry = _____6280_80FD_6570_636E_8868[skillId]
    if entry == nil then
        return 0
    end
    local value = _____8BFB_53D6_6570_503C_5B57_6BB5(entry[field])
    if field == "Rng" then
        _____6280_80FD_65BD_6CD5_8DDD_79BB_7F13_5B58[_____7F13_5B58_952E] = value
    else
        _____6280_80FD_65BD_6CD5_8303_56F4_7F13_5B58[_____7F13_5B58_952E] = value
    end
    return value
end
local function _____8BFB_53D6_6280_80FD_547D_4EE4_7F16_53F7(unit, skill)
    local skillId = skill["技能ID"] or ""
    if skillId == "" then
        return 0
    end
    local abilityId = _____8BFB_53D6_6280_80FD_80FD_529BID(skillId)
    if abilityId == 0 then
        return 0
    end
    return _____6280_80FD__83B7_53D6_6280_80FD_547D_4EE4_7F16_53F7(unit, abilityId) or 0
end
local function _____8BFB_53D6_6280_80FD_5F53_524D_51B7_5374_6BEB_79D2(unit, skillId)
    local abilityId = _____8BFB_53D6_6280_80FD_80FD_529BID(skillId)
    if abilityId == 0 then
        return 0
    end
    local currentCooldown = _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4(unit, abilityId) or 0
    local _____5E73_53F0_51B7_5374_6BEB_79D2 = currentCooldown > 0 and currentCooldown * 1000 or 0
    local state = _____83B7_53D6Boss_4E3B_52A8_8FD0_884C_72B6_6001(unit)
    local _____4E0B_6B21_53EF_7528_65F6_95F4 = state["技能下次可用时间表"][abilityId] or 0
    local now = getServerTime()
    local _____8FD0_884C_65F6_51B7_5374_6BEB_79D2 = _____4E0B_6B21_53EF_7528_65F6_95F4 - now
    if _____8FD0_884C_65F6_51B7_5374_6BEB_79D2 <= 0 then
        state["技能下次可用时间表"][abilityId] = nil
        _____8FD0_884C_65F6_51B7_5374_6BEB_79D2 = 0
    end
    return _____5E73_53F0_51B7_5374_6BEB_79D2 > _____8FD0_884C_65F6_51B7_5374_6BEB_79D2 and _____5E73_53F0_51B7_5374_6BEB_79D2 or _____8FD0_884C_65F6_51B7_5374_6BEB_79D2
end
local function _____8BFB_53D6_6280_80FD_5B9E_65F6_65BD_6CD5_8DDD_79BB(unit, skillId)
    local abilityId = _____8BFB_53D6_6280_80FD_80FD_529BID(skillId)
    if abilityId ~= 0 then
        local currentRange = _____6280_80FD__83B7_53D6_6280_80FD_65BD_6CD5_8DDD_79BB(unit, abilityId) or 0
        if currentRange > 0 then
            return currentRange
        end
    end
    return _____8BFB_53D6_6280_80FD_8868_6570_503C(skillId, "Rng")
end
local function _____8BFB_53D6_6280_80FD_5B9E_65F6_65BD_6CD5_8303_56F4(unit, skillId)
    local abilityId = _____8BFB_53D6_6280_80FD_80FD_529BID(skillId)
    if abilityId ~= 0 then
        local currentArea = _____6280_80FD__83B7_53D6_6280_80FD_65BD_6CD5_8303_56F4(unit, abilityId) or 0
        if currentArea > 0 then
            return currentArea
        end
    end
    return _____8BFB_53D6_6280_80FD_8868_6570_503C(skillId, "Area")
end
local function _____6E05_7406Boss_4E3B_52A8_8FD0_884C_72B6_6001(unit)
    local handleId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if handleId == 0 then
        return
    end
    ____Boss_4E3B_52A8_8FD0_884C_72B6_6001_8868[handleId] = nil
end
local function _____662F_5426_6709_6548Boss_4E3B_52A8_76EE_6807(candidate, source)
    if candidate == nil or candidate == 0 then
        return false
    end
    if not SUC_MatchBasicTarget(candidate, source, true) then
        return false
    end
    if jass:IsUnitType(candidate, jass.UNIT_TYPE_ANCIENT) then
        return false
    end
    if jass:IsUnitType(candidate, jass.UNIT_TYPE_SUMMONED) then
        return false
    end
    return true
end
local function _____9009_62E9_6700_8FD1_654C_4EBA(unit, candidates)
    if #candidates == 0 then
        return nil
    end
    local best = candidates[1]
    local bestDistance = YDWEDistanceBetweenUnitsSafe(unit, best)
    do
        local i = 1
        while i < #candidates do
            local candidate = candidates[i + 1]
            local distance = YDWEDistanceBetweenUnitsSafe(unit, candidate)
            if distance < bestDistance then
                best = candidate
                bestDistance = distance
            end
            i = i + 1
        end
    end
    return best
end
local function _____8BFB_53D6_5355_4F4D_72B6_6001_767E_5206_6BD4(unit, currentState, maxState)
    local max = GetUnitState(unit, maxState)
    if max <= 0 then
        return 100
    end
    local current = GetUnitState(unit, currentState)
    return current / max * 100
end
local function _____662F_5426_6EE1_8DB3_767E_5206_6BD4_533A_95F4(value, min, max)
    if min ~= nil and value < min then
        return false
    end
    if max ~= nil and value > max then
        return false
    end
    return true
end
local function _____662F_5426_6EE1_8DB3_6280_80FD_91CA_653E_6761_4EF6(unit, _____6280_80FD, target)
    local lifePercent = _____8BFB_53D6_5355_4F4D_72B6_6001_767E_5206_6BD4(unit, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE)
    if not _____662F_5426_6EE1_8DB3_767E_5206_6BD4_533A_95F4(lifePercent, _____6280_80FD["最低生命百分比"], _____6280_80FD["最高生命百分比"]) then
        return false
    end
    local manaPercent = _____8BFB_53D6_5355_4F4D_72B6_6001_767E_5206_6BD4(unit, UNIT_STATE_MANA, UNIT_STATE_MAX_MANA)
    if not _____662F_5426_6EE1_8DB3_767E_5206_6BD4_533A_95F4(manaPercent, _____6280_80FD["最低魔法百分比"], _____6280_80FD["最高魔法百分比"]) then
        return false
    end
    if target ~= nil and target ~= 0 and target ~= unit then
        local distance = YDWEDistanceBetweenUnitsSafe(unit, target)
        if _____6280_80FD["最小施法距离"] ~= nil and distance < _____6280_80FD["最小施法距离"] then
            return false
        end
        if _____6280_80FD["最大施法距离"] ~= nil and distance > _____6280_80FD["最大施法距离"] then
            return false
        end
    end
    return true
end
local function _____662F_6811_9B54_9996_9886AI(_____914D_7F6E)
    return _____914D_7F6E["AI配置ID"] == "树魔首领AI"
end
local function _____662F_5426_6EE1_8DB3_6280_80FD_8FD0_884C_65F6_53EF_7528_6761_4EF6(unit, _____6280_80FD)
    local _____6761_4EF6 = _____6280_80FD["运行时可用条件"]
    return _____6761_4EF6 == nil or _____6761_4EF6(unit)
end
local function _____6309_5355_4F4D_83B7_53D6Boss_4E3B_52A8AI_914D_7F6E(unit)
    local unitTypeId = GetUnitTypeId(unit)
    if unitTypeId ~= 0 then
        do
            local i = 0
            while i < #____Boss_4E3B_52A8_626B_63CF_914D_7F6E_8868 do
                local _____914D_7F6E = ____Boss_4E3B_52A8_626B_63CF_914D_7F6E_8868[i + 1]
                if _____89E3_6790_5355_4F4DAI_914D_7F6E_5355_4F4D_7C7B_578BID(_____914D_7F6E) == unitTypeId then
                    return _____914D_7F6E
                end
                i = i + 1
            end
        end
    end
    local unitName = GetUnitName(unit)
    do
        local i = 0
        while i < #____Boss_4E3B_52A8_626B_63CF_914D_7F6E_8868 do
            local _____914D_7F6E = ____Boss_4E3B_52A8_626B_63CF_914D_7F6E_8868[i + 1]
            if _____914D_7F6E["单位名"] == unitName then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
local function _____521D_59CB_5316Boss_6280_80FD_63D0_793A(unit)
    local _____914D_7F6E = _____6309_5355_4F4D_83B7_53D6Boss_4E3B_52A8AI_914D_7F6E(unit)
    if _____914D_7F6E == nil then
        return
    end
    local state = _____83B7_53D6Boss_4E3B_52A8_8FD0_884C_72B6_6001(unit)
    if state["技能提示已初始化"] then
        return
    end
    local _____6280_80FD_5217_8868 = _____914D_7F6E["技能覆盖"] or ({})
    local _____63D0_793A_5217_8868 = {}
    do
        local i = 0
        while i < #_____6280_80FD_5217_8868 do
            do
                local _____6280_80FD = _____6280_80FD_5217_8868[i + 1]
                local _____6280_80FDID = _____6280_80FD["技能ID"]
                if _____6280_80FDID == nil or #_____6280_80FDID < 4 or _____6280_80FD["技能名"] == "" then
                    goto __continue77
                end
                _____63D0_793A_5217_8868[#_____63D0_793A_5217_8868 + 1] = {["技能ID"] = _____6280_80FDID, ["提示"] = _____6280_80FD["技能名"]}
            end
            ::__continue77::
            i = i + 1
        end
    end
    _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A(unit, _____63D0_793A_5217_8868)
    state["技能提示已初始化"] = true
end
local function _____8BFB_53D6Boss_6280_80FD_914D_7F6E_51B7_5374_79D2(unit, _____6280_80FD)
    local _____52A8_6001_8BFB_53D6_5668 = _____6280_80FD["冷却秒读取器"]
    local ____temp_13
    if _____52A8_6001_8BFB_53D6_5668 ~= nil then
        ____temp_13 = _____52A8_6001_8BFB_53D6_5668(unit)
    else
        ____temp_13 = _____6280_80FD["冷却秒"]
    end
    local _____51B7_5374_79D2 = ____temp_13
    return _____51B7_5374_79D2 ~= nil and _____51B7_5374_79D2 > 0 and _____51B7_5374_79D2 or 0
end
local function ____onBoss_901A_9B54_6280_80FD_751F_6548(castingUnit, spellAbilityId)
    local _____914D_7F6E = _____6309_5355_4F4D_83B7_53D6Boss_4E3B_52A8AI_914D_7F6E(castingUnit)
    if _____914D_7F6E == nil or spellAbilityId == 0 then
        return
    end
    local _____6280_80FD_5217_8868 = _____914D_7F6E["技能覆盖"] or ({})
    local _____5339_914D_6280_80FD
    do
        local i = 0
        while i < #_____6280_80FD_5217_8868 do
            local ____opt_14 = _____6280_80FD_5217_8868[i + 1]
            local _____6280_80FDID = ____opt_14 and ____opt_14["技能ID"]
            if _____6280_80FDID ~= nil and _____6280_80FDID ~= "" and _____8BFB_53D6_6280_80FD_80FD_529BID(_____6280_80FDID) == spellAbilityId then
                _____5339_914D_6280_80FD = _____6280_80FD_5217_8868[i + 1]
                break
            end
            i = i + 1
        end
    end
    if _____5339_914D_6280_80FD == nil then
        return
    end
    local _____914D_7F6E_51B7_5374 = _____8BFB_53D6Boss_6280_80FD_914D_7F6E_51B7_5374_79D2(castingUnit, _____5339_914D_6280_80FD)
    if _____914D_7F6E_51B7_5374 <= 0 then
        return
    end
    local state = _____83B7_53D6Boss_4E3B_52A8_8FD0_884C_72B6_6001(castingUnit)
    state["技能下次可用时间表"][spellAbilityId] = getServerTime() + _____914D_7F6E_51B7_5374 * 1000
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(castingUnit, spellAbilityId, _____914D_7F6E_51B7_5374, _____914D_7F6E_51B7_5374)
end
local function _____9009_62E9_4E3B_52A8_65BD_6CD5_76EE_6807(unit, _____914D_7F6E, _____6280_80FD, _____8303_56F4)
    local _____65BD_6CD5_76EE_6807_7C7B_578B = _____6280_80FD["施法目标类型"] or "自动"
    if _____65BD_6CD5_76EE_6807_7C7B_578B == "无目标" then
        return nil
    end
    if _____65BD_6CD5_76EE_6807_7C7B_578B == "自己" then
        return unit
    end
    local candidates = __TS__ArrayFilter(
        getEnemyUnitsInRangeOfUnit(unit, _____8303_56F4),
        function(____, candidate) return _____662F_5426_6709_6548Boss_4E3B_52A8_76EE_6807(candidate, unit) end
    )
    if #candidates == 0 then
        return nil
    end
    local _____76EE_6807_9009_62E9_65B9_5F0F = _____6280_80FD["目标选择方式"] or _____914D_7F6E["默认目标选择方式"] or "最高仇恨"
    if _____76EE_6807_9009_62E9_65B9_5F0F == "最近敌人" then
        return _____9009_62E9_6700_8FD1_654C_4EBA(unit, candidates)
    end
    local threat = _____83B7_53D6_5E94_653B_51FB_76EE_6807(
        unit,
        function(entry)
            local target = entry.targetRef
            if not _____662F_5426_6709_6548Boss_4E3B_52A8_76EE_6807(target, unit) then
                return false
            end
            return YDWEDistanceBetweenUnitsSafe(unit, target) <= _____8303_56F4
        end
    )
    if threat ~= nil and threat.targetRef ~= nil and threat.targetRef ~= 0 then
        return threat.targetRef
    end
    return _____9009_62E9_6700_8FD1_654C_4EBA(unit, candidates)
end
local function _____6267_884C_6280_80FD_4E0B_5355(unit, _____6280_80FD, _____547D_4EE4ID, target)
    local _____65BD_6CD5_76EE_6807_7C7B_578B = _____6280_80FD["施法目标类型"] or "自动"
    if _____65BD_6CD5_76EE_6807_7C7B_578B == "无目标" then
        return IssueImmediateOrderById(unit, _____547D_4EE4ID) == true
    end
    if _____65BD_6CD5_76EE_6807_7C7B_578B == "自己" then
        return IssueTargetOrderById(unit, _____547D_4EE4ID, unit) == true
    end
    if _____65BD_6CD5_76EE_6807_7C7B_578B == "单位" then
        if target == nil or target == 0 then
            return false
        end
        return IssueTargetOrderById(unit, _____547D_4EE4ID, target) == true
    end
    if _____65BD_6CD5_76EE_6807_7C7B_578B == "点" then
        local ____temp_16
        if target ~= nil and target ~= 0 then
            ____temp_16 = target
        else
            ____temp_16 = unit
        end
        local pointTarget = ____temp_16
        local x = jass:GetUnitX(pointTarget)
        local y = jass:GetUnitY(pointTarget)
        return IssuePointOrderById(unit, _____547D_4EE4ID, x, y) == true
    end
    if _____65BD_6CD5_76EE_6807_7C7B_578B == "单位或点" then
        if target ~= nil and target ~= 0 then
            return IssueTargetOrderById(unit, _____547D_4EE4ID, target) == true
        end
        local x = jass:GetUnitX(unit)
        local y = jass:GetUnitY(unit)
        return IssuePointOrderById(unit, _____547D_4EE4ID, x, y) == true
    end
    if target ~= nil and target ~= 0 then
        return IssueTargetOrderById(unit, _____547D_4EE4ID, target) == true
    end
    return IssueImmediateOrderById(unit, _____547D_4EE4ID) == true
end
local function _____9009_62E9_53EF_65BD_6CD5_6280_80FD(unit, _____914D_7F6E, _____8D77_59CB_6280_80FD_7D22_5F15)
    local _____6309_914D_7F6E_987A_5E8F_8F6E_6362 = _____8D77_59CB_6280_80FD_7D22_5F15 ~= nil
    local _____6280_80FD_5217_8868 = __TS__ArraySlice(__TS__ArrayFilter(
        _____914D_7F6E["技能覆盖"] or ({}),
        function(____, skill) return skill ~= nil and not skill["禁用"] and skill["技能ID"] ~= nil and skill["技能ID"] ~= "" end
    ))
    if not _____6309_914D_7F6E_987A_5E8F_8F6E_6362 then
        __TS__ArraySort(
            _____6280_80FD_5217_8868,
            function(____, a, b)
                local _____6743_91CDA = a["权重"] or 0
                local _____6743_91CDB = b["权重"] or 0
                if _____6743_91CDA ~= _____6743_91CDB then
                    return _____6743_91CDB - _____6743_91CDA
                end
                local idA = a["技能ID"] or ""
                local idB = b["技能ID"] or ""
                return idA < idB and -1 or 1
            end
        )
    end
    local _____5B9E_9645_8D77_59CB_7D22_5F15 = _____8D77_59CB_6280_80FD_7D22_5F15 or 0
    if _____5B9E_9645_8D77_59CB_7D22_5F15 < 0 or _____5B9E_9645_8D77_59CB_7D22_5F15 >= #_____6280_80FD_5217_8868 then
        _____5B9E_9645_8D77_59CB_7D22_5F15 = 0
    end
    do
        local i = 0
        while i < #_____6280_80FD_5217_8868 do
            do
                local _____6280_80FD_7D22_5F15 = (_____5B9E_9645_8D77_59CB_7D22_5F15 + i) % #_____6280_80FD_5217_8868
                local skill = _____6280_80FD_5217_8868[_____6280_80FD_7D22_5F15 + 1]
                local skillId = skill["技能ID"]
                if skillId == nil or skillId == "" then
                    goto __continue112
                end
                local abilityId = _____8BFB_53D6_6280_80FD_80FD_529BID(skillId)
                local _____6280_80FD_7B49_7EA7 = abilityId == 0 and 0 or jass:GetUnitAbilityLevel(unit, abilityId)
                local coolMs = _____8BFB_53D6_6280_80FD_5F53_524D_51B7_5374_6BEB_79D2(unit, skillId)
                local orderId = _____8BFB_53D6_6280_80FD_547D_4EE4_7F16_53F7(unit, skill)
                if not _____662F_5426_6EE1_8DB3_6280_80FD_8FD0_884C_65F6_53EF_7528_6761_4EF6(unit, skill) then
                    goto __continue112
                end
                if abilityId == 0 or _____6280_80FD_7B49_7EA7 <= 0 then
                    goto __continue112
                end
                if coolMs > 0 then
                    goto __continue112
                end
                local range = skill["最大施法距离"] or _____8BFB_53D6_6280_80FD_5B9E_65F6_65BD_6CD5_8DDD_79BB(unit, skillId) or _____914D_7F6E["默认施法距离"] or 1200
                local area = _____8BFB_53D6_6280_80FD_5B9E_65F6_65BD_6CD5_8303_56F4(unit, skillId)
                local target = _____9009_62E9_4E3B_52A8_65BD_6CD5_76EE_6807(unit, _____914D_7F6E, skill, range)
                if not _____662F_5426_6EE1_8DB3_6280_80FD_91CA_653E_6761_4EF6(unit, skill, target) then
                    goto __continue112
                end
                if (skill["施法目标类型"] or "自动") ~= "无目标" and (skill["施法目标类型"] or "自动") ~= "自己" then
                    if target == nil or target == 0 then
                        goto __continue112
                    end
                end
                if orderId == 0 then
                    goto __continue112
                end
                return {
                    skill = skill,
                    target = target,
                    coolMs = coolMs,
                    range = range,
                    area = area,
                    ["下次技能索引"] = (_____6280_80FD_7D22_5F15 + 1) % #_____6280_80FD_5217_8868
                }
            end
            ::__continue112::
            i = i + 1
        end
    end
    return nil
end
local function _____5C1D_8BD5_9A71_52A8_5355_4E2ABoss(context)
    local unit = context["Boss单位"]
    if unit == nil or unit == 0 then
        return
    end
    if not SUC_IsUnitAlive(unit) then
        _____6E05_7406Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587(unit)
        _____6E05_7406Boss_4E3B_52A8_8FD0_884C_72B6_6001(unit)
        return
    end
    local _____5355_4F4D_540D = GetUnitName(unit)
    local _____914D_7F6E = _____6309_5355_4F4D_83B7_53D6Boss_4E3B_52A8AI_914D_7F6E(unit)
    if _____914D_7F6E == nil then
        return
    end
    if _____914D_7F6E["AI模式"] ~= "固定技能表" then
        return
    end
    if _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5(unit) or _____5355_4F4D_662F_5426_6B63_5728_65BD_6CD5(unit) then
        return
    end
    local now = getServerTime()
    local state = _____83B7_53D6Boss_4E3B_52A8_8FD0_884C_72B6_6001(unit)
    local _____662F_6811_9B54_9996_9886 = _____662F_6811_9B54_9996_9886AI(_____914D_7F6E)
    local _____68C0_67E5_95F4_9694 = _____914D_7F6E["检查间隔Ms"] or _____9ED8_8BA4_626B_63CF_95F4_9694_6BEB_79D2
    if state["下次检查时间"] > now then
        return
    end
    state["下次检查时间"] = now + _____68C0_67E5_95F4_9694
    if state["下次可施法时间"] > now then
        return
    end
    local _____9009_62E9_7ED3_679C = _____9009_62E9_53EF_65BD_6CD5_6280_80FD(unit, _____914D_7F6E, _____662F_6811_9B54_9996_9886 and state["树魔下次技能索引"] or nil)
    if _____9009_62E9_7ED3_679C == nil then
        return
    end
    local skill = _____9009_62E9_7ED3_679C.skill
    local target = _____9009_62E9_7ED3_679C.target
    local coolMs = _____9009_62E9_7ED3_679C.coolMs
    local range = _____9009_62E9_7ED3_679C.range
    local area = _____9009_62E9_7ED3_679C.area
    local _____4E0B_6B21_6280_80FD_7D22_5F15 = _____9009_62E9_7ED3_679C["下次技能索引"]
    local orderId = _____8BFB_53D6_6280_80FD_547D_4EE4_7F16_53F7(unit, skill)
    local _____6210_529F = _____6267_884C_6280_80FD_4E0B_5355(unit, skill, orderId, target)
    if not _____6210_529F then
        if _____662F_6811_9B54_9996_9886 then
            state["树魔下次技能索引"] = _____4E0B_6B21_6280_80FD_7D22_5F15
        end
        return
    end
    local skillId = skill["技能ID"] or ""
    local abilityId = _____8BFB_53D6_6280_80FD_80FD_529BID(skillId)
    local _____914D_7F6E_51B7_5374 = _____8BFB_53D6Boss_6280_80FD_914D_7F6E_51B7_5374_79D2(unit, skill)
    if abilityId ~= 0 and _____914D_7F6E_51B7_5374 > 0 then
        state["技能下次可用时间表"][abilityId] = now + _____914D_7F6E_51B7_5374 * 1000
    end
    if _____662F_6811_9B54_9996_9886 then
        state["树魔下次技能索引"] = _____4E0B_6B21_6280_80FD_7D22_5F15
    end
    state["下次可施法时间"] = now + (_____914D_7F6E["公共施法间隔Ms"] or _____9ED8_8BA4_516C_5171_65BD_6CD5_95F4_9694_6BEB_79D2)
    local ____debugLogForce_20 = debugLogForce
    local ____skill__6280_80FD_540D_18 = skill["技能名"]
    local ____skill__6280_80FDID_19 = skill["技能ID"]
    local ____temp_17
    if target ~= nil and target ~= 0 then
        ____temp_17 = jass:GetUnitName(target)
    else
        ____temp_17 = "无目标"
    end
    ____debugLogForce_20(
        _____6A21_5757_540D,
        "Boss主动施法",
        "boss=",
        _____5355_4F4D_540D,
        "skill=",
        ____skill__6280_80FD_540D_18,
        "id=",
        ____skill__6280_80FDID_19,
        "target=",
        ____temp_17,
        "cdMs=",
        coolMs,
        "range=",
        range,
        "area=",
        area,
        "公共间隔Ms=",
        _____914D_7F6E["公共施法间隔Ms"] or _____9ED8_8BA4_516C_5171_65BD_6CD5_95F4_9694_6BEB_79D2
    )
end
local function ____onBoss_4E3B_52A8_626B_63CFTick()
    local contexts = _____83B7_53D6_6240_6709Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            _____521D_59CB_5316Boss_6280_80FD_63D0_793A(contexts[i + 1]["Boss单位"])
            i = i + 1
        end
    end
    if not ____Boss_81EA_52A8_65BD_6CD5_662F_5426_5F00_542F() then
        return
    end
    do
        local i = 0
        while i < #contexts do
            _____5C1D_8BD5_9A71_52A8_5355_4E2ABoss(contexts[i + 1])
            i = i + 1
        end
    end
end
____exports["initBoss主动扫描施法"] = function()
    if ____Boss_4E3B_52A8_626B_63CF_56DE_8C03ID ~= 0 then
        return
    end
    registerSpellEffectListener(____onBoss_901A_9B54_6280_80FD_751F_6548)
    ____Boss_4E3B_52A8_626B_63CF_56DE_8C03ID = addPeriodicCallback(250, ____onBoss_4E3B_52A8_626B_63CFTick)
end
____exports["重新扫描Boss主动施法"] = function()
    ____onBoss_4E3B_52A8_626B_63CFTick()
end
return ____exports
