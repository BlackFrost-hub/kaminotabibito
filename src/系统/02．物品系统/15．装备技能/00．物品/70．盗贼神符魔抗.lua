--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____8C03_8BD5_6A21_5757_540D = "盗贼神符魔抗"
local function _____8BB0_5F55_76D7_8D3C_795E_7B26_9B54_6297_56DE_9000(unit)
    debugLogForce(
        _____8C03_8BD5_6A21_5757_540D,
        "回退魔抗",
        "unitId=" .. tostring(GetHandleId(unit)),
        "delta=" .. tostring(-_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["盗贼神符魔抗"]["魔抗提升"])
    )
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
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["盗贼神符魔抗"]
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, cfg["持续毫秒"], {{["类型"] = "玩家属性", ["属性名"] = "魔抗", ["数值"] = cfg["魔抗提升"]}}, {["on清除"] = _____8BB0_5F55_76D7_8D3C_795E_7B26_9B54_6297_56DE_9000})
end
return ____exports
