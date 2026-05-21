--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["调整玩家属性"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____56DE_9000_961F_5217 = {}
local _____8C03_8BD5_6A21_5757_540D = "盗贼神符魔抗"
local function _____56DE_9000_76D7_8D3C_795E_7B26_9B54_6297()
    local unit = table.remove(_____56DE_9000_961F_5217, 1)
    if unit == nil or unit == 0 then
        return
    end
    debugLogForce(
        _____8C03_8BD5_6A21_5757_540D,
        "回退魔抗",
        "unitId=" .. tostring(GetHandleId(unit)),
        "delta=" .. tostring(-_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["盗贼神符魔抗"]["魔抗提升"])
    )
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, "魔抗", -_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["盗贼神符魔抗"]["魔抗提升"])
end
____exports["处理盗贼神符魔抗使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["盗贼神符魔抗"]) then
        return
    end
    local unit = ctx["施法单位"]
    debugLogForce(
        _____8C03_8BD5_6A21_5757_540D,
        "使用命中",
        "unitId=" .. tostring(GetHandleId(unit)),
        "delta=" .. tostring(_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["盗贼神符魔抗"]["魔抗提升"]),
        "durationMs=" .. tostring(_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["盗贼神符魔抗"]["持续毫秒"])
    )
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, "魔抗", _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["盗贼神符魔抗"]["魔抗提升"])
    _____56DE_9000_961F_5217[#_____56DE_9000_961F_5217 + 1] = unit
    addDelayedCallback(_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["盗贼神符魔抗"]["持续毫秒"], _____56DE_9000_76D7_8D3C_795E_7B26_9B54_6297)
end
return ____exports
