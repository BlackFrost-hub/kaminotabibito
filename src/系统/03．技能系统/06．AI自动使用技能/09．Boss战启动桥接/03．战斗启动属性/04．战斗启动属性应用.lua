local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
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
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_1["按名字反查Boss单位ID"]
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表")
local _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID = ____require_result_2["按名字反查异界Boss单位ID"]
local ____require_result_3 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_3["按名字反查玩家英雄单位ID"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local _____6A21_5757_540D = "Boss战启动属性应用"
local _____5DF2_5E94_7528_5C5E_6027_5355_4F4D_8868 = {}
local ____array_6 = __TS__SparseArrayNew(table.unpack(____Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868))
__TS__SparseArrayPush(
    ____array_6,
    table.unpack(_____82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868)
)
__TS__SparseArrayPush(
    ____array_6,
    table.unpack(_____5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868)
)
local _____5168_90E8_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = {__TS__SparseArraySpread(____array_6)}
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
local function _____6309_5355_4F4D_67E5_627E_6218_6597_542F_52A8_5C5E_6027_914D_7F6E(unit)
    local unitTypeId = GetUnitTypeId(unit)
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
local function _____5199_5165_6574_6570_5C5E_6027(unit, _____5C5E_6027_540D, _____503C)
    if _____503C == nil then
        return
    end
    YDUserDataSetSafe(
        "unit",
        unit,
        _____5C5E_6027_540D,
        "integer",
        _____503C
    )
end
local function _____5199_5165_5B9E_6570_5C5E_6027(unit, _____5C5E_6027_540D, _____503C)
    if _____503C == nil then
        return
    end
    YDUserDataSetSafe(
        "unit",
        unit,
        _____5C5E_6027_540D,
        "real",
        _____503C
    )
end
local function _____5199_5165_5E03_5C14_5C5E_6027(unit, _____5C5E_6027_540D, _____503C)
    if _____503C == nil then
        return
    end
    YDUserDataSetSafe(
        "unit",
        unit,
        _____5C5E_6027_540D,
        "boolean",
        _____503C
    )
end
____exports["应用Boss战启动属性配置"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    local handleId = jass.GetHandleId(unit)
    if handleId == 0 or _____5DF2_5E94_7528_5C5E_6027_5355_4F4D_8868[handleId] then
        return
    end
    local _____914D_7F6E = _____6309_5355_4F4D_67E5_627E_6218_6597_542F_52A8_5C5E_6027_914D_7F6E(unit)
    if _____914D_7F6E == nil then
        return
    end
    local n = _____5F53_524DN_503C()
    local _____5F31_70B9_6570_91CF = (_____914D_7F6E["弱点数量基础值"] or 0) + (_____914D_7F6E["弱点数量每层N增量"] or 0) * n
    local _____62A4_76FE_503C = (_____914D_7F6E["护盾基础值"] or 0) + (_____914D_7F6E["护盾每层N增量"] or 0) * n
    local _____6700_5927_751F_547D = GetUnitState(unit, UNIT_STATE_MAX_LIFE)
    local _____5668_5F31_4F24_5BB3_9700_6C42 = (_____914D_7F6E["器弱伤害需求生命百分比"] or 0) * _____6700_5927_751F_547D
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "魔抗", _____914D_7F6E["魔抗"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "暴击率", _____914D_7F6E["暴击率"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "暴击伤害", _____914D_7F6E["暴击伤害"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "减少控制时间", _____914D_7F6E["减少控制时间"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "命中率", _____914D_7F6E["命中率"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "闪避率", _____914D_7F6E["闪避率"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "魔法伤害吸血", _____914D_7F6E["魔法伤害吸血"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "魔法穿透", _____914D_7F6E["魔法穿透"])
    _____5199_5165_6574_6570_5C5E_6027(unit, "弱点数量", _____5F31_70B9_6570_91CF)
    _____5199_5165_6574_6570_5C5E_6027(unit, "天生弱点数", _____914D_7F6E["天生弱点数"])
    _____5199_5165_5E03_5C14_5C5E_6027(unit, "剑弱", _____914D_7F6E["剑弱"])
    _____5199_5165_5E03_5C14_5C5E_6027(unit, "短剑弱", _____914D_7F6E["短剑弱"])
    _____5199_5165_5E03_5C14_5C5E_6027(unit, "杖弱", _____914D_7F6E["杖弱"])
    _____5199_5165_5E03_5C14_5C5E_6027(unit, "火弱", _____914D_7F6E["火弱"])
    _____5199_5165_5E03_5C14_5C5E_6027(unit, "雷弱", _____914D_7F6E["雷弱"])
    _____5199_5165_5E03_5C14_5C5E_6027(unit, "光弱", _____914D_7F6E["光弱"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "器弱伤害需求", _____5668_5F31_4F24_5BB3_9700_6C42)
    _____5199_5165_6574_6570_5C5E_6027(
        unit,
        "护盾值",
        R2I(_____62A4_76FE_503C)
    )
    _____5199_5165_6574_6570_5C5E_6027(
        unit,
        "原始护盾值",
        R2I(_____62A4_76FE_503C)
    )
    _____5DF2_5E94_7528_5C5E_6027_5355_4F4D_8868[handleId] = true
    debugLogForce(
        _____6A21_5757_540D,
        "应用配置",
        "unitTypeId=",
        GetUnitTypeId(unit),
        "分类=",
        _____914D_7F6E["归类"],
        "weakCount=",
        _____5F31_70B9_6570_91CF,
        "shield=",
        _____62A4_76FE_503C,
        "N=",
        n
    )
end
return ____exports
