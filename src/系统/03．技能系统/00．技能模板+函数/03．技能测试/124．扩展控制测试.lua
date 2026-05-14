--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 扩展控制测试
-- 
-- 输入 "1024"：
-- - 让大法师周围1000码内的第一个敌人，对大法师施加5秒魅惑
-- - 验证大法师会失去控制并贴身跟随敌人
-- 
-- 输入 "1025"：
-- - 让大法师周围1000码内的第一个敌人，对大法师施加5秒恐惧（逃离施法者）
-- - 验证大法师会持续逃离敌人
-- 
-- 输入 "1026"：
-- - 让大法师周围1000码内的第一个敌人，对大法师施加5秒恐惧（随机乱跑）
-- - 验证大法师会持续随机移动
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____6269_5C55_63A7_5236_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.index")
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_1.getEnemyUnitsInRange
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____6A21_5757_540D = "扩展控制测试"
local _____9B45_60D1_547D_4EE4 = "1024"
local _____6050_60E7_9003_79BB_547D_4EE4 = "1025"
local _____6050_60E7_968F_673A_547D_4EE4 = "1026"
local _____5DF2_6CE8_518C = false
local function _____65BD_52A0_5355_4F53_9B45_60D1(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
    return _____6269_5C55_63A7_5236_7CFB_7EDF["施加魅惑"](_____6269_5C55_63A7_5236_7CFB_7EDF, _____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
end
local function _____65BD_52A0_5355_4F53_6050_60E7(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
    return _____6269_5C55_63A7_5236_7CFB_7EDF["施加恐惧"](_____6269_5C55_63A7_5236_7CFB_7EDF, _____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
end
local function _____83B7_53D6_6D4B_8BD5_76EE_6807()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return nil
    end
    local x = GetUnitX(_____5927_6CD5_5E08)
    local y = GetUnitY(_____5927_6CD5_5E08)
    local _____654C_4EBA_5217_8868 = getEnemyUnitsInRange(_____5927_6CD5_5E08, x, y, 1000)
    local _____7B2C_4E00_4E2A_654C_4EBA = _____654C_4EBA_5217_8868[1]
    if _____7B2C_4E00_4E2A_654C_4EBA == nil or _____7B2C_4E00_4E2A_654C_4EBA == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：大法师周围1000码内没有敌人")
        return nil
    end
    return {["大法师"] = _____5927_6CD5_5E08, ["敌人"] = _____7B2C_4E00_4E2A_654C_4EBA}
end
local function ____on_9B45_60D1_6D4B_8BD5()
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6D4B_8BD5_76EE_6807()
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    local _____7ED3_679C = _____65BD_52A0_5355_4F53_9B45_60D1(_____4E0A_4E0B_6587["敌人"], _____4E0A_4E0B_6587["大法师"], {["持续时间"] = 5, ["跟随半径"] = 140})
    debugLogForce(
        _____6A21_5757_540D,
        "魅惑结果=",
        _____7ED3_679C,
        "来源=",
        _____4E0A_4E0B_6587["敌人"],
        "目标=gg_unit_Hamg_0002"
    )
end
local function ____on_6050_60E7_9003_79BB_6D4B_8BD5()
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6D4B_8BD5_76EE_6807()
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    local _____7ED3_679C = _____65BD_52A0_5355_4F53_6050_60E7(_____4E0A_4E0B_6587["敌人"], _____4E0A_4E0B_6587["大法师"], {["持续时间"] = 5, ["模式"] = "逃离施法者", ["逃离距离"] = 550})
    debugLogForce(
        _____6A21_5757_540D,
        "恐惧逃离结果=",
        _____7ED3_679C,
        "来源=",
        _____4E0A_4E0B_6587["敌人"],
        "目标=gg_unit_Hamg_0002"
    )
end
local function ____on_6050_60E7_968F_673A_6D4B_8BD5()
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6D4B_8BD5_76EE_6807()
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    local _____7ED3_679C = _____65BD_52A0_5355_4F53_6050_60E7(_____4E0A_4E0B_6587["敌人"], _____4E0A_4E0B_6587["大法师"], {["持续时间"] = 5, ["模式"] = "随机乱跑", ["随机半径"] = 450})
    debugLogForce(
        _____6A21_5757_540D,
        "恐惧随机结果=",
        _____7ED3_679C,
        "来源=",
        _____4E0A_4E0B_6587["敌人"],
        "目标=gg_unit_Hamg_0002"
    )
end
local function _____6CE8_518C_804A_5929_6D4B_8BD5()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    local _____9B45_60D1_89E6_53D1_5668 = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        _____9B45_60D1_89E6_53D1_5668,
        Player(0),
        _____9B45_60D1_547D_4EE4,
        true
    )
    TriggerAddAction(_____9B45_60D1_89E6_53D1_5668, ____on_9B45_60D1_6D4B_8BD5)
    local _____6050_60E7_9003_79BB_89E6_53D1_5668 = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        _____6050_60E7_9003_79BB_89E6_53D1_5668,
        Player(0),
        _____6050_60E7_9003_79BB_547D_4EE4,
        true
    )
    TriggerAddAction(_____6050_60E7_9003_79BB_89E6_53D1_5668, ____on_6050_60E7_9003_79BB_6D4B_8BD5)
    local _____6050_60E7_968F_673A_89E6_53D1_5668 = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        _____6050_60E7_968F_673A_89E6_53D1_5668,
        Player(0),
        _____6050_60E7_968F_673A_547D_4EE4,
        true
    )
    TriggerAddAction(_____6050_60E7_968F_673A_89E6_53D1_5668, ____on_6050_60E7_968F_673A_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____9B45_60D1_547D_4EE4, "让周围第一个敌人魅惑大法师")
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6050_60E7_9003_79BB_547D_4EE4, "让周围第一个敌人恐惧大法师-逃离施法者")
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6050_60E7_968F_673A_547D_4EE4, "让周围第一个敌人恐惧大法师-随机乱跑")
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
