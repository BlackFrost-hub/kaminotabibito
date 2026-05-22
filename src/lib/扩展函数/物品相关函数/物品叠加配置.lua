--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
--- 这里维护“即使不是 charged / purchasable，也允许进入物品叠加系统”的白名单。
-- 统一写物品名字，不写 4 位 raw id。
____exports["物品叠加白名单名称"] = {"触手残片"}
local function _____8F6C_6362_7269_54C1_540D_5230_7C7B_578BID(_____7269_54C1_540D)
    local _____539F_59CBID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D)
    return stringToFourCCSafe(_____539F_59CBID)
end
local function _____6784_5EFA_7269_54C1_53E0_52A0_767D_540D_5355_7C7B_578BID()
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #____exports["物品叠加白名单名称"] do
            local _____7269_54C1_7C7B_578BID = _____8F6C_6362_7269_54C1_540D_5230_7C7B_578BID(____exports["物品叠加白名单名称"][i + 1])
            if _____7269_54C1_7C7B_578BID > 0 then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____7269_54C1_7C7B_578BID
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["物品叠加白名单类型ID"] = _____6784_5EFA_7269_54C1_53E0_52A0_767D_540D_5355_7C7B_578BID()
____exports["物品在叠加白名单"] = function(_____7269_54C1_7C7B_578BID)
    if _____7269_54C1_7C7B_578BID == 0 then
        return false
    end
    do
        local i = 0
        while i < #____exports["物品叠加白名单类型ID"] do
            if ____exports["物品叠加白名单类型ID"][i + 1] == _____7269_54C1_7C7B_578BID then
                return true
            end
            i = i + 1
        end
    end
    return false
end
return ____exports
