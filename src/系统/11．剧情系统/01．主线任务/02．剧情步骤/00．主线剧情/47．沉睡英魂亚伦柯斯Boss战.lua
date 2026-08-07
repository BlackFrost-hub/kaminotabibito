--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____8FDB_5165_4E3B_7EBF_8282_70B9 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["进入主线节点"]
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["剧情Boss预置暂停来源"]
local ____46_FF0E_6C89_7761_82F1_9B42_4E9A_4F26_67EF_65AF_524D_5BFC = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.46．沉睡英魂亚伦柯斯前导")
local _____4E9A_4F26_67EF_65AFBoss_952E = ____46_FF0E_6C89_7761_82F1_9B42_4E9A_4F26_67EF_65AF_524D_5BFC["亚伦柯斯Boss键"]
local _____4E9A_4F26_67EF_65AF_5F85_6218_6682_505C_6765_6E90 = ____46_FF0E_6C89_7761_82F1_9B42_4E9A_4F26_67EF_65AF_524D_5BFC["亚伦柯斯待战暂停来源"]
local ____require_result_0 = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐")
local _____6E05_7406_7B2C_4E09_7AE0_4E9A_4F26_67EF_65AF_6218_524D_533A_57DF_80CC_666F_97F3_4E50 = ____require_result_0["清理第三章亚伦柯斯战前区域背景音乐"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_1["解除暂停并取消无敌安全"]
local ____require_result_2 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_2.IsUnitAliveBJ
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit)
end
____exports["执行启动亚伦柯斯Boss战"] = function(______53C2_6570)
    local _____5F53_524D_8FDB_5EA6 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    if _____5F53_524D_8FDB_5EA6 ~= 46 and _____5F53_524D_8FDB_5EA6 ~= 47 then
        return
    end
    local ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.亚伦柯斯")
    if ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3 == nil then
        ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____4E9A_4F26_67EF_65AFBoss_952E)
    end
    local bossUnit = ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3
    local ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_4 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.亚伦柯斯玩家")
    if ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_4 == nil then
        ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_4 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    end
    local _____73A9_5BB6_5355_4F4D = ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_4
    if not _____5355_4F4D_5B58_6D3B(bossUnit) or not _____5355_4F4D_5B58_6D3B(_____73A9_5BB6_5355_4F4D) then
        return
    end
    _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(bossUnit, _____4E9A_4F26_67EF_65AF_5F85_6218_6682_505C_6765_6E90)
    local _____5DF2_542F_52A8 = _____542F_52A8_5267_60C5Boss_6218(bossUnit, {["触发单位"] = _____73A9_5BB6_5355_4F4D, ["暂停来源"] = _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90})
    if _____5DF2_542F_52A8 then
        _____6E05_7406_7B2C_4E09_7AE0_4E9A_4F26_67EF_65AF_6218_524D_533A_57DF_80CC_666F_97F3_4E50()
        if _____5F53_524D_8FDB_5EA6 == 46 then
            _____8FDB_5165_4E3B_7EBF_8282_70B9(47)
        end
    end
end
____exports["沉睡英魂亚伦柯斯Boss战剧情动作注册表"] = {["第三章_启动亚伦柯斯Boss战"] = ____exports["执行启动亚伦柯斯Boss战"]}
return ____exports
