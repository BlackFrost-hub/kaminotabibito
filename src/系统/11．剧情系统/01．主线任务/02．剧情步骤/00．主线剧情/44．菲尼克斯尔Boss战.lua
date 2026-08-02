--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____8FDB_5165_4E3B_7EBF_8282_70B9 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["进入主线节点"]
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
local ____43_FF0E_83F2_5C3C_514B_65AF_5C14_73B0_8EAB = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.43．菲尼克斯尔现身")
local _____83B7_53D6_83F2_5C3C_514B_65AF_5C14Boss = ____43_FF0E_83F2_5C3C_514B_65AF_5C14_73B0_8EAB["获取菲尼克斯尔Boss"]
local _____83F2_5C3C_514B_65AF_5C14_5F85_6218_6682_505C_6765_6E90 = ____43_FF0E_83F2_5C3C_514B_65AF_5C14_73B0_8EAB["菲尼克斯尔待战暂停来源"]
local ____require_result_0 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_0.IsUnitAliveBJ
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit)
end
____exports["执行启动菲尼克斯尔Boss战"] = function(______53C2_6570)
    local _____5F53_524D_8FDB_5EA6 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    if _____5F53_524D_8FDB_5EA6 ~= 43 and _____5F53_524D_8FDB_5EA6 ~= 44 then
        return
    end
    local bossUnit = _____83B7_53D6_83F2_5C3C_514B_65AF_5C14Boss()
    local ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_1 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.菲尼克斯尔玩家")
    if ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_1 == nil then
        ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_1 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    end
    local _____73A9_5BB6_5355_4F4D = ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_1
    if not _____5355_4F4D_5B58_6D3B(bossUnit) or not _____5355_4F4D_5B58_6D3B(_____73A9_5BB6_5355_4F4D) then
        return
    end
    local _____5DF2_542F_52A8 = _____542F_52A8_5267_60C5Boss_6218(bossUnit, {["触发单位"] = _____73A9_5BB6_5355_4F4D, ["暂停来源"] = _____83F2_5C3C_514B_65AF_5C14_5F85_6218_6682_505C_6765_6E90})
    if _____5DF2_542F_52A8 and _____5F53_524D_8FDB_5EA6 == 43 then
        _____8FDB_5165_4E3B_7EBF_8282_70B9(44)
    end
end
____exports["菲尼克斯尔Boss战剧情动作注册表"] = {["第三章_启动菲尼克斯尔Boss战"] = ____exports["执行启动菲尼克斯尔Boss战"]}
return ____exports
