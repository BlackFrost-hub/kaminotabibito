--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_2.UnitHasItemOfTypeBJ
____exports["影骨战利品装备名"] = {["影骨披风"] = "影骨披风", ["幽影匕首"] = "幽影匕首", ["盗贼首领徽记"] = "盗贼首领徽记", ["阴影陷阱装置"] = "阴影陷阱装置"}
local _____5F71_9AA8_6218_5229_54C1_7269_54C1ID_7F13_5B58 = {}
____exports["取影骨战利品物品ID"] = function(_____88C5_5907_540D)
    local cached = _____5F71_9AA8_6218_5229_54C1_7269_54C1ID_7F13_5B58[_____88C5_5907_540D]
    if cached ~= nil then
        return cached
    end
    local id = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D))
    _____5F71_9AA8_6218_5229_54C1_7269_54C1ID_7F13_5B58[_____88C5_5907_540D] = id
    return id
end
____exports["单位持有影骨战利品"] = function(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 then
        return false
    end
    local itemId = ____exports["取影骨战利品物品ID"](_____88C5_5907_540D)
    if itemId == 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(unit, itemId) == true
end
return ____exports
