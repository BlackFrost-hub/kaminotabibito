--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5C38_4F53_53EC_5524 = require("系统.02．物品系统.15．装备技能.01．死亡事件.02．尸体召唤")
local _____5904_7406_5C38_4F53_53EC_5524 = ____02_FF0E_5C38_4F53_53EC_5524["处理尸体召唤"]
local ____03_FF0E_51FB_6740_53E0_5C42 = require("系统.02．物品系统.15．装备技能.01．死亡事件.03．击杀叠层")
local _____5904_7406_51FB_6740_53E0_5C42 = ____03_FF0E_51FB_6740_53E0_5C42["处理击杀叠层"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____7279_5B9A_654C_65B9_73A9_5BB6ID = 7
local _____8FDC_53E4_5355_4F4D_7C7B_578B = jass.UNIT_TYPE_ANCIENT
local _____673A_68B0_5355_4F4D_7C7B_578B = jass.UNIT_TYPE_MECHANICAL
local _____53EC_5524_5355_4F4D_7C7B_578B = jass.UNIT_TYPE_SUMMONED
local function _____662F_5426_5C5E_4E8E_76D1_542C_6B7B_4EA1_5355_4F4D(_____5355_4F4D)
    local _____6240_6709_8005 = jass.GetOwningPlayer(_____5355_4F4D)
    local _____73A9_5BB6ID = jass.GetPlayerId(_____6240_6709_8005)
    return _____73A9_5BB6ID == _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID or _____73A9_5BB6ID == _____7279_5B9A_654C_65B9_73A9_5BB6ID
end
local function _____662F_5426_901A_8FC7_6B7B_4EA1_8FC7_6EE4(_____5355_4F4D)
    if not _____662F_5426_5C5E_4E8E_76D1_542C_6B7B_4EA1_5355_4F4D(_____5355_4F4D) then
        return false
    end
    if jass.IsUnitType(_____5355_4F4D, _____8FDC_53E4_5355_4F4D_7C7B_578B) then
        return false
    end
    if jass.IsUnitType(_____5355_4F4D, _____673A_68B0_5355_4F4D_7C7B_578B) then
        return false
    end
    if jass.IsUnitType(_____5355_4F4D, _____53EC_5524_5355_4F4D_7C7B_578B) then
        return false
    end
    return true
end
local function _____6784_5EFA_6B7B_4EA1_4E8B_4EF6_4E0A_4E0B_6587(_____6B7B_4EA1_5355_4F4D, _____51FB_6740_5355_4F4D)
    return {
        ["死亡单位"] = _____6B7B_4EA1_5355_4F4D,
        ["击杀单位"] = _____51FB_6740_5355_4F4D,
        ["死亡单位所有者"] = jass.GetOwningPlayer(_____6B7B_4EA1_5355_4F4D),
        ["死亡坐标X"] = jass.GetUnitX(_____6B7B_4EA1_5355_4F4D),
        ["死亡坐标Y"] = jass.GetUnitY(_____6B7B_4EA1_5355_4F4D)
    }
end
local function ____on_88C5_5907_6B7B_4EA1_4E8B_4EF6(_____6B7B_4EA1_5355_4F4D, _____51FB_6740_5355_4F4D)
    if _____6B7B_4EA1_5355_4F4D == nil or _____6B7B_4EA1_5355_4F4D == 0 then
        return
    end
    if not _____662F_5426_901A_8FC7_6B7B_4EA1_8FC7_6EE4(_____6B7B_4EA1_5355_4F4D) then
        return
    end
    local _____4E0A_4E0B_6587 = _____6784_5EFA_6B7B_4EA1_4E8B_4EF6_4E0A_4E0B_6587(_____6B7B_4EA1_5355_4F4D, _____51FB_6740_5355_4F4D)
    _____5904_7406_5C38_4F53_53EC_5524(_____4E0A_4E0B_6587)
    _____5904_7406_51FB_6740_53E0_5C42(_____4E0A_4E0B_6587)
end
registerDeathListener(____on_88C5_5907_6B7B_4EA1_4E8B_4EF6)
return ____exports
