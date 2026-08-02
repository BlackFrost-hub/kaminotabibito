--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.KK扩展API.00．装饰物函数")
local DzDoodadCreate = ____require_result_1.DzDoodadCreate
local DzDoodadRemove = ____require_result_1.DzDoodadRemove
local _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970 = {
    ["类型ID"] = "D08V",
    X = 8384.9,
    Y = -13714.5,
    Z = 0,
    ["朝向"] = 180,
    ["缩放"] = 2,
    ["变体"] = 1
}
local _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970_53E5_67C4 = 0
____exports["创建菲尼克斯尔战后地形装饰"] = function()
    if _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970_53E5_67C4 ~= 0 then
        return
    end
    _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970_53E5_67C4 = DzDoodadCreate(
        stringToFourCCSafe(_____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970["类型ID"]),
        _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970["变体"],
        _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970.X,
        _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970.Y,
        _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970.Z,
        _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970["朝向"],
        _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970["缩放"]
    )
end
____exports["清理菲尼克斯尔战后地形装饰"] = function()
    if _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970_53E5_67C4 == 0 then
        return
    end
    DzDoodadRemove(_____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970_53E5_67C4)
    _____83F2_5C3C_514B_65AF_5C14_6218_540E_5730_5F62_88C5_9970_53E5_67C4 = 0
end
return ____exports
