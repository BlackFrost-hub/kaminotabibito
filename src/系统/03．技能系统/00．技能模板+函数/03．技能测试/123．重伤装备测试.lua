--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 重伤系统 装备测试
-- 
-- 输入 "1023"：给玩家1英雄设置50%装备重伤，攻击任何敌人即可触发重伤buff
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.04．伤害系统.03．重伤系统.index")
local _____83B7_53D6_5355_4F4D_91CD_4F24 = ____require_result_1["获取单位重伤"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_2.getBuffRuntime
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetHandleId = jass.GetHandleId
local StringHash = jass.StringHash
local SaveReal = jass.SaveReal
local LoadReal = jass.LoadReal
local WOUND_BUFF_ID = "C021"
local _____6A21_5757_540D = "重伤装备测试"
local _____6D4B_8BD5_547D_4EE4 = "1023"
local _____5DF2_6CE8_518C = false
local function _____5199_5165YD_7528_6237_6570_636E(tableType, tableKey, attr, valueType, value)
    debugLogForce(
        _____6A21_5757_540D,
        "测试写入YD用户数据：tableType=",
        tableType,
        "tableKey=",
        tostring(tableKey),
        "attr=",
        attr,
        "valueType=",
        valueType,
        "value=",
        value
    )
    YDUserDataSetSafe(
        tableType,
        tableKey,
        attr,
        valueType,
        value
    )
end
local function _____8BFB_53D6YD_7528_6237_6570_636E(tableType, tableKey, attr, valueType)
    local value = YDUserDataGetSafe(tableType, tableKey, attr, valueType)
    debugLogForce(
        _____6A21_5757_540D,
        "测试读取YD用户数据：tableType=",
        tableType,
        "tableKey=",
        tostring(tableKey),
        "attr=",
        attr,
        "valueType=",
        valueType,
        "value=",
        value
    )
    return value
end
local function _____83B7_53D6YD_54C8_5E0C_8868()
    local _____5019_9009 = {g.YDHASH_HANDLE, g.YDHT, g.udg_YDHASH_HANDLE, g.udg_YDHT}
    for ____, _____54C8_5E0C_8868 in ipairs(_____5019_9009) do
        if _____54C8_5E0C_8868 ~= nil and _____54C8_5E0C_8868 ~= 0 then
            return _____54C8_5E0C_8868
        end
    end
    return nil
end
local function _____8F93_51FA_539F_59CB_54C8_5E0C_8BCA_65AD(owner)
    local _____54C8_5E0C_8868 = _____83B7_53D6YD_54C8_5E0C_8868()
    local _____73A9_5BB6_53E5_67C4ID = GetHandleId(owner)
    local _____73A9_5BB6ID = GetPlayerId(owner)
    local _____5C5E_6027_952E = StringHash("重伤")
    debugLogForce(
        _____6A21_5757_540D,
        "原始哈希诊断：hash=",
        tostring(_____54C8_5E0C_8868),
        "playerHandleId=",
        _____73A9_5BB6_53E5_67C4ID,
        "playerId=",
        _____73A9_5BB6ID,
        "attrHash=",
        _____5C5E_6027_952E
    )
    if _____54C8_5E0C_8868 == nil or _____54C8_5E0C_8868 == 0 then
        debugLogForce(_____6A21_5757_540D, "原始哈希诊断：未找到YDHASH句柄")
        return
    end
    SaveReal(_____54C8_5E0C_8868, _____73A9_5BB6_53E5_67C4ID, _____5C5E_6027_952E, 0.75)
    debugLogForce(
        _____6A21_5757_540D,
        "原始哈希诊断：按handleId写0.75后读取=",
        LoadReal(_____54C8_5E0C_8868, _____73A9_5BB6_53E5_67C4ID, _____5C5E_6027_952E)
    )
    SaveReal(_____54C8_5E0C_8868, _____73A9_5BB6ID, _____5C5E_6027_952E, 0.25)
    debugLogForce(
        _____6A21_5757_540D,
        "原始哈希诊断：按playerId写0.25后读取=",
        LoadReal(_____54C8_5E0C_8868, _____73A9_5BB6ID, _____5C5E_6027_952E)
    )
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
    _____8F93_51FA_539F_59CB_54C8_5E0C_8BCA_65AD(owner)
    debugLogForce(_____6A21_5757_540D, "===== 请攻击任意敌人 =====")
    debugLogForce(_____6A21_5757_540D, "攻击后敌人会获得重伤buff")
    debugLogForce(_____6A21_5757_540D, "tooltip应显示'治疗效果降低50%'")
end
local function _____6CE8_518C_804A_5929_6D4B_8BD5()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    local trig = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        trig,
        Player(0),
        _____6D4B_8BD5_547D_4EE4,
        true
    )
    TriggerAddAction(trig, ____on_804A_5929_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4)
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
