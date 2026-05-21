local ____lualib = require("lualib_bundle")
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
local ____01_FF0E_88C5_5907_6570_636E = require("系统.02．物品系统.01．装备数据")
local items = ____01_FF0E_88C5_5907_6570_636E.items
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local function _____53D6_7269_54C1_7C7B_578BID(_____7269_54C1_540D)
    return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D))
end
local function _____53D6_540C_540D_7269_54C1_7C7B_578BID_5217_8868(_____7269_54C1_540D)
    local _____7ED3_679C = {}
    for ____, ____value in ipairs(__TS__ObjectEntries(items)) do
        local rawId = ____value[1]
        local data = ____value[2]
        do
            if data.name ~= _____7269_54C1_540D then
                goto __continue4
            end
            local _____7269_54C1_7C7B_578BID = stringToFourCCSafe(rawId)
            if _____7269_54C1_7C7B_578BID > 0 then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____7269_54C1_7C7B_578BID
            end
        end
        ::__continue4::
    end
    return _____7ED3_679C
end
____exports["通用物品名称"] = {["获取特效"] = "领悟暗之力", ["合成打造"] = "合成|打造", ["传送门_万浴熔灵"] = "|CffD8D800传送门：|r|Cffff0000万浴熔灵|r", ["领取技能"] = "领取技能"}
____exports["通用物品ID"] = {
    ["获取特效"] = _____53D6_7269_54C1_7C7B_578BID(____exports["通用物品名称"]["获取特效"]),
    ["合成打造列表"] = _____53D6_540C_540D_7269_54C1_7C7B_578BID_5217_8868(____exports["通用物品名称"]["合成打造"]),
    ["传送门_万浴熔灵"] = _____53D6_7269_54C1_7C7B_578BID(____exports["通用物品名称"]["传送门_万浴熔灵"]),
    ["领取技能"] = _____53D6_7269_54C1_7C7B_578BID(____exports["通用物品名称"]["领取技能"])
}
____exports["通用物品配置"] = {
    ["获取特效路径"] = "Abilities\\Spells\\Items\\AIsm\\AIsmTarget.mdl",
    ["获取特效持续时间"] = 1.5,
    ["获取特效角度"] = 270,
    ["获取特效尺寸"] = 1.5,
    ["合成打造延迟毫秒"] = 500,
    ["万浴熔灵镜头矩形"] = "gg_rct______________091",
    ["万浴熔灵传送X"] = 14853.4,
    ["万浴熔灵传送Y"] = -14964.3
}
return ____exports
