--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_1["按名字反查物品ID"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_2.stringToFourCC
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local _____6A21_5757_540D = "装备死亡事件测试"
local _____6D4B_8BD5_547D_4EE4 = "1039"
local _____6D4B_8BD5_88C5_5907_540D_5217_8868 = {"小颅盾（唯一）", "斯尔能量之心", "德鲁伊指引灯笼（魔猎）", "德鲁伊指引灯笼（智识）"}
local function _____521B_5EFA_5E76_7ED9_4E88_88C5_5907(_____5355_4F4D, _____88C5_5907_540D)
    local _____7269_54C1ID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
    if _____7269_54C1ID == nil or _____7269_54C1ID == "" then
        debugLogForce(_____6A21_5757_540D, "未找到装备", _____88C5_5907_540D)
        return
    end
    local x = jass:GetUnitX(_____5355_4F4D)
    local y = jass:GetUnitY(_____5355_4F4D)
    local item = jass:CreateItem(
        stringToFourCC(_____7269_54C1ID),
        x,
        y
    )
    if item == nil or item == 0 then
        debugLogForce(_____6A21_5757_540D, "创建物品失败", _____88C5_5907_540D, _____7269_54C1ID)
        return
    end
    jass:UnitAddItem(_____5355_4F4D, item)
end
local function ____on_804A_59291039_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_Hamg_0002")
        return
    end
    for ____, _____88C5_5907_540D in ipairs(_____6D4B_8BD5_88C5_5907_540D_5217_8868) do
        _____521B_5EFA_5E76_7ED9_4E88_88C5_5907(_____5927_6CD5_5E08, _____88C5_5907_540D)
    end
    debugLogForce(_____6A21_5757_540D, "已给予大法师死亡事件测试装备")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291039_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "给予大法师死亡事件装备")
return ____exports
