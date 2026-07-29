local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_1["按名字反查物品ID"]
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_2["按结算键执行Boss死亡结算"]
do
    local ____17_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_6B7B_4EA1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.17．第一章最终Boss教派死亡")
    ____exports["教派最终Boss死亡剧情片段"] = ____17_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_6B7B_4EA1["教派最终Boss死亡剧情片段"]
end
local GetDyingUnit = jass.GetDyingUnit
local GetUnitTypeId = jass.GetUnitTypeId
local CreateItem = jass.CreateItem
local SetUnitPosition = jass.SetUnitPosition
local UnitSuspendDecay = jass.UnitSuspendDecay
____exports["执行蒙面人死亡"] = function(_____53C2_6570)
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local dyingTypeId = GetUnitTypeId(dyingUnit)
    if dyingTypeId ~= stringToFourCCSafe("N05N") and dyingTypeId ~= stringToFourCCSafe("N05M") then
        return
    end
    UnitSuspendDecay(dyingUnit, true)
    _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97("蒙面人", dyingUnit)
    local ____53C2_6570__56FA_5B9A_6389_843D_7269_54C1_540D_3 = _____53C2_6570["固定掉落物品名"]
    if ____53C2_6570__56FA_5B9A_6389_843D_7269_54C1_540D_3 == nil then
        ____53C2_6570__56FA_5B9A_6389_843D_7269_54C1_540D_3 = ""
    end
    local _____56FA_5B9A_6389_843D_7269_54C1_540D = tostring(____53C2_6570__56FA_5B9A_6389_843D_7269_54C1_540D_3)
    local _____56FA_5B9A_6389_843D_7269_54C1ID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____56FA_5B9A_6389_843D_7269_54C1_540D))
    if _____56FA_5B9A_6389_843D_7269_54C1ID > 0 then
        CreateItem(
            _____56FA_5B9A_6389_843D_7269_54C1ID,
            __TS__Number(_____53C2_6570["固定掉落X"]) or 15678.8,
            __TS__Number(_____53C2_6570["固定掉落Y"]) or -29965.6
        )
    end
    local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
    local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
    local _____957F_8001 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
    if _____957F_8001 ~= nil and _____957F_8001 ~= 0 then
        SetUnitPosition(
            _____957F_8001,
            __TS__Number(_____53C2_6570["族长新位置X"]) or 28775.2,
            __TS__Number(_____53C2_6570["族长新位置Y"]) or -28660.2
        )
    end
end
____exports["第一章最终Boss教派死亡剧情动作注册表"] = {["SW01死亡事件_蒙面人死亡"] = ____exports["执行蒙面人死亡"]}
return ____exports
