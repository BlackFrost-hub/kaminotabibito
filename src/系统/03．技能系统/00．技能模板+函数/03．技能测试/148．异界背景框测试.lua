--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Fire = ____require_result_2.STES_Fire
local _____80CC_666F_6846 = require("系统.09．表现系统.11．背景框.01．背景框创建")
local _____6A21_5757_540D = "异界背景框测试"
local ____STES_547D_4EE4 = "1048"
local _____76F4_63A5_547D_4EE4 = "1049"
local _____81EA_5B9A_4E49_547D_4EE4 = "1050"
local _____9500_6BC1_547D_4EE4 = "1051"
local _____6D4B_8BD5_5E27_7EC4 = nil
local function _____786E_4FDD_9500_6BC1()
    if _____6D4B_8BD5_5E27_7EC4 ~= nil then
        _____80CC_666F_6846["销毁背景框"](_____6D4B_8BD5_5E27_7EC4)
        _____6D4B_8BD5_5E27_7EC4 = nil
    end
end
local function ____onSTES_89E6_53D1_6D4B_8BD5()
    _____786E_4FDD_9500_6BC1()
    STES_Fire("异界Boss背景框")
    debugLogForce(_____6A21_5757_540D, "已触发 STES_Fire('异界Boss背景框')")
end
local function ____on_76F4_63A5_663E_793A_6D4B_8BD5()
    _____786E_4FDD_9500_6BC1()
    _____6D4B_8BD5_5E27_7EC4 = _____80CC_666F_6846["创建背景框"]({["段落数量"] = 4, ["段落文字"] = {"第一段：动态创建测试", "第二段：调用通用 API", "第三段：支持自定义文字", "第四段：一切正常！"}})
    if _____6D4B_8BD5_5E27_7EC4 == nil then
        debugLogForce(_____6A21_5757_540D, "错误：创建背景框失败")
        return
    end
    _____80CC_666F_6846["设置背景框透明度"](_____6D4B_8BD5_5E27_7EC4, 255)
    _____80CC_666F_6846["显示背景框"](_____6D4B_8BD5_5E27_7EC4)
    debugLogForce(_____6A21_5757_540D, "已动态创建背景框（4段落，含初始文字）")
end
local function ____on_81EA_5B9A_4E49_6BB5_843D_6D4B_8BD5()
    _____786E_4FDD_9500_6BC1()
    _____6D4B_8BD5_5E27_7EC4 = _____80CC_666F_6846["创建背景框"]({["段落数量"] = 6})
    if _____6D4B_8BD5_5E27_7EC4 == nil then
        debugLogForce(_____6A21_5757_540D, "错误：创建背景框失败")
        return
    end
    do
        local i = 0
        while i < 6 do
            _____80CC_666F_6846["设置段落文字"](
                _____6D4B_8BD5_5E27_7EC4,
                i,
                "自定义段落 #" .. tostring(i + 1)
            )
            i = i + 1
        end
    end
    _____80CC_666F_6846["设置背景框透明度"](_____6D4B_8BD5_5E27_7EC4, 255)
    _____80CC_666F_6846["显示背景框"](_____6D4B_8BD5_5E27_7EC4)
    debugLogForce(_____6A21_5757_540D, "已动态创建 6 段落背景框")
end
local function ____on_9500_6BC1_6D4B_8BD5()
    if _____6D4B_8BD5_5E27_7EC4 == nil then
        debugLogForce(_____6A21_5757_540D, "没有可销毁的测试背景框")
        return
    end
    _____786E_4FDD_9500_6BC1()
    debugLogForce(_____6A21_5757_540D, "已销毁测试背景框")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(____STES_547D_4EE4, ____onSTES_89E6_53D1_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____76F4_63A5_547D_4EE4, ____on_76F4_63A5_663E_793A_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____81EA_5B9A_4E49_547D_4EE4, ____on_81EA_5B9A_4E49_6BB5_843D_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____9500_6BC1_547D_4EE4, ____on_9500_6BC1_6D4B_8BD5)
debugLogForce(
    _____6A21_5757_540D,
    "已注册测试：输入",
    ____STES_547D_4EE4,
    "STES；",
    _____76F4_63A5_547D_4EE4,
    "直接创建；",
    _____81EA_5B9A_4E49_547D_4EE4,
    "6段落；",
    _____9500_6BC1_547D_4EE4,
    "销毁"
)
return ____exports
