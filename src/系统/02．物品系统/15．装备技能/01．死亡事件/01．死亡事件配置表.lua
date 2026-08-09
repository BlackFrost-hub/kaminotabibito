local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_1["按名字反查物品ID"]
local _____539F_59CB_6B7B_4EA1_4E8B_4EF6_914D_7F6E = {["尸体召唤"] = {
    ["装备名"] = "小颅盾（唯一）",
    ["搜索半径"] = 500,
    ["召唤单位类型"] = "u000",
    ["限时生命Buff"] = "BHwe",
    ["持续时间"] = 5,
    ["特效路径"] = "Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl",
    ["特效持续时间"] = 1,
    ["额外生命值"] = 300,
    ["生命值系数"] = 0.25,
    ["额外攻击力"] = 25,
    ["攻击力状态"] = 21,
    ["攻击力系数"] = 0.4
}, ["击杀叠层列表"] = {{["装备名"] = "斯尔能量之心", ["每次增加层数"] = 2, ["最大层数"] = 100}}}
local _____7F13_5B58_914D_7F6E
local function _____89E3_6790_88C5_5907_540D_5230ID(_____88C5_5907_540D)
    if _____88C5_5907_540D == nil or _____88C5_5907_540D == "" then
        return nil
    end
    return _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
end
local function _____89E3_6790_51FB_6740_53E0_5C42_914D_7F6E()
    local _____7ED3_679C = {}
    for ____, _____914D_7F6E in ipairs(_____539F_59CB_6B7B_4EA1_4E8B_4EF6_914D_7F6E["击杀叠层列表"]) do
        _____7ED3_679C[#_____7ED3_679C + 1] = __TS__ObjectAssign(
            {},
            _____914D_7F6E,
            {
                ["装备ID"] = _____89E3_6790_88C5_5907_540D_5230ID(_____914D_7F6E["装备名"]),
                ["满层升级到装备ID"] = _____89E3_6790_88C5_5907_540D_5230ID(_____914D_7F6E["满层升级到装备名"])
            }
        )
    end
    return _____7ED3_679C
end
____exports["获取死亡事件配置"] = function()
    if _____7F13_5B58_914D_7F6E ~= nil then
        return _____7F13_5B58_914D_7F6E
    end
    _____7F13_5B58_914D_7F6E = {
        ["尸体召唤"] = __TS__ObjectAssign(
            {},
            _____539F_59CB_6B7B_4EA1_4E8B_4EF6_914D_7F6E["尸体召唤"],
            {["装备ID"] = _____89E3_6790_88C5_5907_540D_5230ID(_____539F_59CB_6B7B_4EA1_4E8B_4EF6_914D_7F6E["尸体召唤"]["装备名"])}
        ),
        ["击杀叠层列表"] = _____89E3_6790_51FB_6740_53E0_5C42_914D_7F6E()
    }
    return _____7F13_5B58_914D_7F6E
end
____exports["取物品四字码"] = function(_____7269_54C1ID)
    return stringToFourCC(_____7269_54C1ID)
end
return ____exports
