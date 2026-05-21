--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 累计伤害装备测试
-- 
-- 输入 "1040" 后，给大法师发放：
-- - 回沙之书
-- - 女妖头饰
-- 用来测试累计伤害相关的装备触发链。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_2["按名字反查物品ID"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_3.stringToFourCC
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local CreateItem = jass.CreateItem
local UnitAddItem = jass.UnitAddItem
local _____6A21_5757_540D = "累计伤害装备测试"
local _____6D4B_8BD5_547D_4EE4 = "1040"
local _____6D4B_8BD5_88C5_5907_5217_8868 = {"回沙之书", "女妖头饰"}
local function _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    local ____g_gg_unit_Hamg_0002_4 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_4 == nil then
        ____g_gg_unit_Hamg_0002_4 = _G.bj_lastCreatedUnit
    end
    return ____g_gg_unit_Hamg_0002_4
end
local function _____7ED9_5355_4F4D_53D1_88C5_5907(unit, _____88C5_5907_540D)
    local _____7269_54C1ID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
    if _____7269_54C1ID == nil or _____7269_54C1ID == "" then
        debugLogForce(_____6A21_5757_540D, "未找到装备ID", _____88C5_5907_540D)
        return
    end
    local item = CreateItem(
        stringToFourCC(_____7269_54C1ID),
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if item == nil or item == 0 then
        debugLogForce(_____6A21_5757_540D, "创建装备失败", _____88C5_5907_540D, _____7269_54C1ID)
        return
    end
    UnitAddItem(unit, item)
    debugLogForce(_____6A21_5757_540D, "已发放装备", _____88C5_5907_540D, _____7269_54C1ID)
end
local function ____on_804A_59291040_6D4B_8BD5()
    local _____5927_6CD5_5E08 = _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_Hamg_0002，无法发放累计伤害装备")
        return
    end
    for ____, _____88C5_5907_540D in ipairs(_____6D4B_8BD5_88C5_5907_5217_8868) do
        _____7ED9_5355_4F4D_53D1_88C5_5907(_____5927_6CD5_5E08, _____88C5_5907_540D)
    end
    debugLogForce(_____6A21_5757_540D, "已给大法师发放累计伤害装备测试包")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291040_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "给大法师发放累计伤害装备")
return ____exports
