local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
local ____09_FF0E_4E3B_7EBF_8282_70B9_914D_7F6E = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.09．主线节点配置")
local _____6E05_9664_4E3B_7EBF_8282_70B9_8FD0_884C_65F6_8986_76D6 = ____09_FF0E_4E3B_7EBF_8282_70B9_914D_7F6E["清除主线节点运行时覆盖"]
local _____8BBE_7F6E_4E3B_7EBF_8282_70B9_8FD0_884C_65F6_8986_76D6 = ____09_FF0E_4E3B_7EBF_8282_70B9_914D_7F6E["设置主线节点运行时覆盖"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["发布主线节点目标"]
local _____8FDB_5165_4E3B_7EBF_8282_70B9 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["进入主线节点"]
local ____31B_FF0E_8036_63D0_5C14_534F_6218_63A7_5236_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.31B．耶提尔协战控制器")
local _____5E03_7F6E_8036_63D0_5C14_6218_540E_5956_52B1NPC = ____31B_FF0E_8036_63D0_5C14_534F_6218_63A7_5236_5668["布置耶提尔战后奖励NPC"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_2.X_FixUnitStandingSafe
local ____require_result_3 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_3.IsUnitAliveBJ
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerUnitInRangeTrigger = ____require_result_4.registerUnitInRangeTrigger
local ____require_result_5 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_5.safeTriggerAddAction
local safeDestroyTrigger = ____require_result_5.safeDestroyTrigger
local ____require_result_6 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_6["是玩家英雄组单位"]
local ____require_result_7 = require("系统.11．剧情系统.01．主线任务.03．主线引导UI.01．主线引导配置表")
local _____5237_65B0_4E3B_7EBF_8282_70B9_5F15_5BFC_914D_7F6E = ____require_result_7["刷新主线节点引导配置"]
do
    local ____35_FF0E_738B_57CE_6218_540E_4E0E_7B2C_4E09_7AE0_542F_7A0B = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.03．第三章.35．王城战后与第三章启程")
    ____exports["王城战后与第三章启程剧情片段"] = ____35_FF0E_738B_57CE_6218_540E_4E0E_7B2C_4E09_7AE0_542F_7A0B["王城战后与第三章启程剧情片段"]
end
local CreateTrigger = jass.CreateTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local Player = jass.Player
local _____7B2C_4E09_7AE0_542F_7A0B_8FDB_5EA6 = 36
local _____738B_5BAB_542F_7A0B_4F20_9001_95E8_952E = "剧情运行时.王宫启程传送门"
local _____738B_5BAB_542F_7A0B_4F20_9001_95E8_7C7B_578BID = "n025"
local _____738B_5BAB_542F_7A0B_4F20_9001_95E8_4F4D_7F6E = {X = 6451.3, Y = -28690.6, ["朝向"] = 270}
local _____738B_5BAB_542F_7A0B_4F20_9001_95E8_8FDB_5165_8303_56F4 = 500
local _____7194_5CA9_5C0F_9547_4F4D_7F6E = {X = 8668.3, Y = -20334}
local _____5F53_524D_738B_5BAB_542F_7A0B_4F20_9001_95E8_72B6_6001
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit)
end
local function _____6E05_7406_738B_5BAB_542F_7A0B_4F20_9001_95E8_76D1_542C(_____72B6_6001)
    if _____72B6_6001["取消范围监听"] ~= nil then
        _____72B6_6001["取消范围监听"]()
    end
    if _____72B6_6001["范围触发器"] ~= nil and _____72B6_6001["范围触发器"] ~= 0 then
        safeDestroyTrigger(_____72B6_6001["范围触发器"])
    end
    _____72B6_6001["取消范围监听"] = nil
    _____72B6_6001["范围触发器"] = nil
end
local function _____5207_6362_5230_7194_5CA9_5C0F_9547_5F15_5BFC()
    _____8BBE_7F6E_4E3B_7EBF_8282_70B9_8FD0_884C_65F6_8986_76D6({
        ["进度"] = _____7B2C_4E09_7AE0_542F_7A0B_8FDB_5EA6,
        ["任务描述"] = "穿过第一章沙漠，前往熔岩小镇。",
        ["提示文本"] = "|cffffff00『第三章主线』：|r穿过第一章沙漠，前往|cffff6800『熔岩小镇』|r。",
        ["任务更新提示"] = "|cffffff00『系统消息』：|r已经抵达启程传送门。穿过第一章沙漠，前往|cffff6800『熔岩小镇』|r。",
        ["小地图"] = {X = _____7194_5CA9_5C0F_9547_4F4D_7F6E.X, Y = _____7194_5CA9_5C0F_9547_4F4D_7F6E.Y, ["持续时间"] = 20},
        ["引导"] = {["镜头X"] = _____7194_5CA9_5C0F_9547_4F4D_7F6E.X, ["镜头Y"] = _____7194_5CA9_5C0F_9547_4F4D_7F6E.Y}
    })
    _____5237_65B0_4E3B_7EBF_8282_70B9_5F15_5BFC_914D_7F6E(_____7B2C_4E09_7AE0_542F_7A0B_8FDB_5EA6)
    _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807(_____7B2C_4E09_7AE0_542F_7A0B_8FDB_5EA6)
end
local function ____on_73A9_5BB6_62B5_8FBE_738B_5BAB_542F_7A0B_4F20_9001_95E8()
    local _____72B6_6001 = _____5F53_524D_738B_5BAB_542F_7A0B_4F20_9001_95E8_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已切换熔岩小镇引导"] or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= _____7B2C_4E09_7AE0_542F_7A0B_8FDB_5EA6 then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if not _____5355_4F4D_5B58_6D3B(_____89E6_53D1_5355_4F4D) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    _____72B6_6001["已切换熔岩小镇引导"] = true
    _____6E05_7406_738B_5BAB_542F_7A0B_4F20_9001_95E8_76D1_542C(_____72B6_6001)
    _____5207_6362_5230_7194_5CA9_5C0F_9547_5F15_5BFC()
end
local function _____6CE8_518C_738B_5BAB_542F_7A0B_4F20_9001_95E8_8303_56F4_76D1_542C(_____72B6_6001)
    local trigger = CreateTrigger()
    if trigger == nil or trigger == 0 then
        return
    end
    if safeTriggerAddAction(trigger, ____on_73A9_5BB6_62B5_8FBE_738B_5BAB_542F_7A0B_4F20_9001_95E8) == nil then
        safeDestroyTrigger(trigger)
        return
    end
    _____72B6_6001["范围触发器"] = trigger
    _____72B6_6001["取消范围监听"] = registerUnitInRangeTrigger(
        trigger,
        _____72B6_6001["传送门"],
        _____738B_5BAB_542F_7A0B_4F20_9001_95E8_8FDB_5165_8303_56F4,
        nil,
        false
    )
end
local function _____521B_5EFA_738B_5BAB_542F_7A0B_4F20_9001_95E8()
    local _____4F20_9001_95E8 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____738B_5BAB_542F_7A0B_4F20_9001_95E8_952E)
    if not _____5355_4F4D_5B58_6D3B(_____4F20_9001_95E8) then
        _____4F20_9001_95E8 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            Player(6),
            stringToFourCCSafe(_____738B_5BAB_542F_7A0B_4F20_9001_95E8_7C7B_578BID),
            _____738B_5BAB_542F_7A0B_4F20_9001_95E8_4F4D_7F6E.X,
            _____738B_5BAB_542F_7A0B_4F20_9001_95E8_4F4D_7F6E.Y,
            _____738B_5BAB_542F_7A0B_4F20_9001_95E8_4F4D_7F6E["朝向"]
        )
        if not _____5355_4F4D_5B58_6D3B(_____4F20_9001_95E8) then
            return nil
        end
        X_FixUnitStandingSafe(_____4F20_9001_95E8)
        _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____738B_5BAB_542F_7A0B_4F20_9001_95E8_952E, _____4F20_9001_95E8)
    end
    return _____4F20_9001_95E8
end
____exports["执行第三章启程布置"] = function(_____53C2_6570)
    _____5E03_7F6E_8036_63D0_5C14_6218_540E_5956_52B1NPC()
    if _____5F53_524D_738B_5BAB_542F_7A0B_4F20_9001_95E8_72B6_6001 ~= nil then
        _____6E05_7406_738B_5BAB_542F_7A0B_4F20_9001_95E8_76D1_542C(_____5F53_524D_738B_5BAB_542F_7A0B_4F20_9001_95E8_72B6_6001)
    end
    _____6E05_9664_4E3B_7EBF_8282_70B9_8FD0_884C_65F6_8986_76D6(_____7B2C_4E09_7AE0_542F_7A0B_8FDB_5EA6)
    _____5237_65B0_4E3B_7EBF_8282_70B9_5F15_5BFC_914D_7F6E(_____7B2C_4E09_7AE0_542F_7A0B_8FDB_5EA6)
    local _____4F20_9001_95E8 = _____521B_5EFA_738B_5BAB_542F_7A0B_4F20_9001_95E8()
    if _____5355_4F4D_5B58_6D3B(_____4F20_9001_95E8) then
        _____5F53_524D_738B_5BAB_542F_7A0B_4F20_9001_95E8_72B6_6001 = {["传送门"] = _____4F20_9001_95E8, ["已切换熔岩小镇引导"] = false}
        _____6CE8_518C_738B_5BAB_542F_7A0B_4F20_9001_95E8_8303_56F4_76D1_542C(_____5F53_524D_738B_5BAB_542F_7A0B_4F20_9001_95E8_72B6_6001)
    end
    _____8FDB_5165_4E3B_7EBF_8282_70B9(__TS__Number(_____53C2_6570["节点进度"]) or _____7B2C_4E09_7AE0_542F_7A0B_8FDB_5EA6)
end
____exports["第三章启程剧情动作注册表"] = {["第三章_启程前往熔岩小镇"] = ____exports["执行第三章启程布置"]}
return ____exports
