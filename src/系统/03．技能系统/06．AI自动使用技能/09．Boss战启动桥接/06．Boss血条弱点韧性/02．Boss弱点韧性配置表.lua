local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.01．常量定义")
local ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点反馈默认配置"]
local ____Boss_5F31_70B9_5019_9009_5217_8868 = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点候选列表"]
local ____Boss_5F31_70B9YD_5B57_6BB5 = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点YD字段"]
local ____01_FF0EBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.03．战斗启动属性.01．Boss战斗启动属性配置表")
local ____Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = ____01_FF0EBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868["Boss战斗启动属性配置表"]
local ____02_FF0E_82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.03．战斗启动属性.02．英雄Boss战斗启动属性配置表")
local _____82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = ____02_FF0E_82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868["英雄Boss战斗启动属性配置表"]
local ____03_FF0E_5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.03．战斗启动属性.03．异界Boss战斗启动属性配置表")
local _____5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = ____03_FF0E_5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868["异界Boss战斗启动属性配置表"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitState = jass.GetUnitState
local R2I = jass.R2I
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_2["按名字反查Boss单位ID"]
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表")
local _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID = ____require_result_3["按名字反查异界Boss单位ID"]
local ____require_result_4 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_4["按名字反查玩家英雄单位ID"]
local ____array_5 = __TS__SparseArrayNew(table.unpack(____Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868))
__TS__SparseArrayPush(
    ____array_5,
    table.unpack(_____82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868)
)
__TS__SparseArrayPush(
    ____array_5,
    table.unpack(_____5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868)
)
local _____5168_90E8_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = {__TS__SparseArraySpread(____array_5)}
____exports["Boss弱点韧性配置表"] = {}
local function _____8BFB_53D6Boss_5F31_70B9_6807_8BB0(bossUnit, weakKey)
    return YDUserDataGetSafe("unit", bossUnit, weakKey, "boolean") == true
end
local function _____8BFB_53D6Boss_62A4_76FE_503C(bossUnit, attr)
    local value = __TS__Number(YDUserDataGetSafe("unit", bossUnit, attr, "integer")) or 0
    return value > 0 and value or nil
end
local function _____8BFB_53D6Boss_5B9E_6570_5B57_6BB5(bossUnit, attr)
    local value = __TS__Number(YDUserDataGetSafe("unit", bossUnit, attr, "real")) or 0
    return value > 0 and value or nil
end
local function _____8BFB_53D6Boss_79D2_6570_5B57_6BB5_6BEB_79D2(bossUnit, attr)
    local value = __TS__Number(YDUserDataGetSafe("unit", bossUnit, attr, "real")) or 0
    return value > 0 and value * 1000 or nil
end
local function _____5F53_524DN_503C()
    return __TS__Number(jglobals.udg_N) or 0
end
local function _____89E3_6790_914D_7F6E_5355_4F4D_7C7B_578BID(_____914D_7F6E)
    if _____914D_7F6E["单位ID"] ~= nil and _____914D_7F6E["单位ID"] ~= "" then
        return stringToFourCCSafe(_____914D_7F6E["单位ID"])
    end
    if _____914D_7F6E["归类"] == "Boss" then
        return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____914D_7F6E["单位名"]))
    end
    if _____914D_7F6E["归类"] == "英雄Boss" then
        return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____914D_7F6E["单位名"]) or _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(_____914D_7F6E["单位名"]))
    end
    if _____914D_7F6E["归类"] == "异界Boss" then
        return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID(_____914D_7F6E["单位名"]))
    end
    return 0
end
local function _____6309_5355_4F4D_67E5_627E_6218_6597_542F_52A8_5C5E_6027_914D_7F6E(bossUnit)
    local unitTypeId = GetUnitTypeId(bossUnit)
    if unitTypeId == 0 then
        return nil
    end
    do
        local i = 0
        while i < #_____5168_90E8_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 do
            local _____914D_7F6E = _____5168_90E8_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868[i + 1]
            if _____89E3_6790_914D_7F6E_5355_4F4D_7C7B_578BID(_____914D_7F6E) == unitTypeId then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
local function _____8BFB_53D6_542F_52A8_5C5E_6027_5F31_70B9_6807_8BB0(_____914D_7F6E, weakKey)
    return _____914D_7F6E[weakKey] == true
end
local function _____4ECE_542F_52A8_5C5E_6027_521B_5EFA_5F31_70B9_5217_8868(_____914D_7F6E)
    local weakList = {}
    do
        local i = 0
        while i < #____Boss_5F31_70B9_5019_9009_5217_8868 do
            local candidate = ____Boss_5F31_70B9_5019_9009_5217_8868[i + 1]
            if _____8BFB_53D6_542F_52A8_5C5E_6027_5F31_70B9_6807_8BB0(_____914D_7F6E, candidate["弱点键"]) then
                weakList[#weakList + 1] = candidate
            end
            i = i + 1
        end
    end
    return weakList
end
local function _____4ECEYD_521B_5EFA_5F31_70B9_5217_8868(bossUnit)
    local weakList = {}
    do
        local i = 0
        while i < #____Boss_5F31_70B9_5019_9009_5217_8868 do
            local candidate = ____Boss_5F31_70B9_5019_9009_5217_8868[i + 1]
            if _____8BFB_53D6Boss_5F31_70B9_6807_8BB0(bossUnit, candidate["弱点键"]) then
                weakList[#weakList + 1] = candidate
            end
            i = i + 1
        end
    end
    return weakList
end
local function _____586B_5145_9ED8_8BA4_53CD_9988_914D_7F6E(config)
    config["弱点发现音效路径"] = config["弱点发现音效路径"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点发现音效路径"]
    config["弱点击中音效路径"] = config["弱点击中音效路径"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点击中音效路径"]
    config["护盾破碎音效路径"] = config["护盾破碎音效路径"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾破碎音效路径"]
    local ____config_7 = config
    local ____config__5F31_70B9_53D1_73B0_63D0_793A_542F_7528_6 = config["弱点发现提示启用"]
    if ____config__5F31_70B9_53D1_73B0_63D0_793A_542F_7528_6 == nil then
        ____config__5F31_70B9_53D1_73B0_63D0_793A_542F_7528_6 = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点发现提示启用"]
    end
    ____config_7["弱点发现提示启用"] = ____config__5F31_70B9_53D1_73B0_63D0_793A_542F_7528_6
    config["护盾命中削减值"] = config["护盾命中削减值"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾命中削减值"]
    config["弱点命中表现毫秒"] = config["弱点命中表现毫秒"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点命中表现毫秒"]
    config["弱点命中伤害加成"] = config["弱点命中伤害加成"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点命中伤害加成"]
    config["破盾控制Buff类型"] = config["破盾控制Buff类型"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破盾控制Buff类型"]
    config["破盾控制持续秒"] = config["破盾控制持续秒"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破盾控制持续秒"]
    config["破盾伤害倍率"] = config["破盾伤害倍率"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破盾伤害倍率"]
    config["破碎护盾显示毫秒"] = config["破碎护盾显示毫秒"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破碎护盾显示毫秒"]
    return config
end
local function _____521B_5EFATS_542F_52A8_5C5E_6027_5F31_70B9_914D_7F6E(bossUnit, _____914D_7F6E)
    local weakList = _____4ECE_542F_52A8_5C5E_6027_521B_5EFA_5F31_70B9_5217_8868(_____914D_7F6E)
    if #weakList <= 0 then
        return nil
    end
    local n = _____5F53_524DN_503C()
    local shieldValue = (_____914D_7F6E["护盾基础值"] or 0) + (_____914D_7F6E["护盾每层N增量"] or 0) * n
    local maxLife = GetUnitState(bossUnit, UNIT_STATE_MAX_LIFE) or 0
    local demand = (_____914D_7F6E["器弱伤害需求生命百分比"] or 0) * maxLife
    return _____586B_5145_9ED8_8BA4_53CD_9988_914D_7F6E({
        ["配置键"] = "TS战斗启动属性",
        ["Boss单位名"] = _____914D_7F6E["单位名"],
        ["Boss引用键"] = _____914D_7F6E["单位ID"],
        ["弱点列表"] = weakList,
        ["天生弱点数"] = _____914D_7F6E["天生弱点数"] or #weakList,
        ["初始护盾值"] = shieldValue > 0 and R2I(shieldValue) or nil,
        ["弱点伤害需求"] = demand > 0 and demand or nil,
        ["护盾冷却毫秒"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾恢复延迟毫秒"]
    })
end
local function _____521B_5EFAYD_5F31_70B9_914D_7F6E(bossUnit)
    local weakList = _____4ECEYD_521B_5EFA_5F31_70B9_5217_8868(bossUnit)
    if #weakList <= 0 then
        return nil
    end
    return _____586B_5145_9ED8_8BA4_53CD_9988_914D_7F6E({
        ["配置键"] = "YD弱点标记",
        ["弱点列表"] = weakList,
        ["天生弱点数"] = #weakList,
        ["初始护盾值"] = _____8BFB_53D6Boss_62A4_76FE_503C(bossUnit, ____Boss_5F31_70B9YD_5B57_6BB5["原始护盾值"]),
        ["弱点伤害需求"] = _____8BFB_53D6Boss_5B9E_6570_5B57_6BB5(bossUnit, ____Boss_5F31_70B9YD_5B57_6BB5["器弱伤害需求"]) or _____8BFB_53D6Boss_62A4_76FE_503C(bossUnit, ____Boss_5F31_70B9YD_5B57_6BB5["器弱伤害需求"]),
        ["护盾冷却毫秒"] = _____8BFB_53D6Boss_79D2_6570_5B57_6BB5_6BEB_79D2(bossUnit, ____Boss_5F31_70B9YD_5B57_6BB5["护盾冷却"]) or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾恢复延迟毫秒"]
    })
end
____exports["查找Boss弱点韧性配置"] = function(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return nil
    end
    local tsConfig = _____6309_5355_4F4D_67E5_627E_6218_6597_542F_52A8_5C5E_6027_914D_7F6E(bossUnit)
    if tsConfig ~= nil then
        local weakConfig = _____521B_5EFATS_542F_52A8_5C5E_6027_5F31_70B9_914D_7F6E(bossUnit, tsConfig)
        if weakConfig ~= nil then
            return weakConfig
        end
    end
    local ydConfig = _____521B_5EFAYD_5F31_70B9_914D_7F6E(bossUnit)
    if ydConfig ~= nil then
        return ydConfig
    end
    return nil
end
return ____exports
