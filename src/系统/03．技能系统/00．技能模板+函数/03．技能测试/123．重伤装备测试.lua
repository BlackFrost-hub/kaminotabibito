--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 重伤系统 装备测试
-- 
-- 输入 "1023"：给玩家1英雄设置50%装备重伤，攻击任何敌人即可触发重伤buff
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.04．伤害系统.03．重伤系统.index")
local _____83B7_53D6_5355_4F4D_91CD_4F24 = ____require_result_2["获取单位重伤"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_3.getBuffRuntime
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_4.YDUserDataSetSafe
local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
local GetOwningPlayer = jass.GetOwningPlayer
local WOUND_BUFF_ID = "C021"
local _____6A21_5757_540D = "重伤装备测试"
local _____6D4B_8BD5_547D_4EE4 = "1023"
local function _____5199_5165YD_7528_6237_6570_636E(tableType, tableKey, attr, valueType, value)
    YDUserDataSetSafe(
        tableType,
        tableKey,
        attr,
        valueType,
        value
    )
end
local function _____8BFB_53D6YD_7528_6237_6570_636E(tableType, tableKey, attr, valueType)
    return YDUserDataGetSafe(tableType, tableKey, attr, valueType)
end
local function ____on_804A_5929_6D4B_8BD5()
    debugLogForce(_____6A21_5757_540D, "===== 重伤装备测试 =====")
    local _____82F1_96C4 = g.gg_unit_Hamg_0002
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    debugLogForce(_____6A21_5757_540D, "英雄handle：", _____82F1_96C4)
    local owner = GetOwningPlayer(_____82F1_96C4)
    debugLogForce(_____6A21_5757_540D, "英雄owner：", owner)
    _____5199_5165YD_7528_6237_6570_636E(
        "player",
        owner,
        "重伤",
        "real",
        0.5
    )
    debugLogForce(
        _____6A21_5757_540D,
        "已设置英雄装备重伤：",
        _____8BFB_53D6YD_7528_6237_6570_636E("player", owner, "重伤", "real")
    )
    debugLogForce(_____6A21_5757_540D, "===== 请攻击任意敌人 =====")
    debugLogForce(_____6A21_5757_540D, "攻击后敌人会获得重伤buff")
    debugLogForce(_____6A21_5757_540D, "tooltip应显示'治疗效果降低50%'")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4)
return ____exports
