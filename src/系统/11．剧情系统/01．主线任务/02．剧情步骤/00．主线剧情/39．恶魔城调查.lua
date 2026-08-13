local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____64AD_653E_8C03_67E5_5267_60C5, _____5355_4F4D_6709_6548, _____5355_4F4D_5B58_6D3B, _____6E05_7406_4E0B_5C42_4ED3_5E93_5165_53E3_76D1_542C, _____89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB, _____6E05_7406_4E0B_5C42_4ED3_5E93_6218_6597_8FD0_884C_65F6_5F15_7528, _____5B89_6392_4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97, _____7ED3_7B97_4E0B_5C42_4ED3_5E93_6218_6597, ____on_4E0B_5C42_4ED3_5E93_5355_4F4D_6B7B_4EA1, unregisterDeathListener, safeDestroyTrigger, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D, _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF, addDelayedCallback, YDUserDataClearSafe, _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0, RemoveDestructable, GetUnitState, GetUnitTypeId, UNIT_STATE_LIFE, _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62_952E, _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1, _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_5230_8FBE_5BF9_767D_4F4D_7F6E, _____4E0B_5C42_4ED3_5E93_5F85_89E6_53D1_73A9_5BB6_5355_4F4D, _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62, _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668, _____5DF2_89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB, _____4E0B_5C42_4ED3_5E93_89E6_53D1_73A9_5BB6_5355_4F4D, _____4E0B_5C42_4ED3_5E93_8D64_5C3E, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, _____4E0B_5C42_4ED3_5E93_52A8_6001Boss, _____4E0B_5C42_4ED3_5E93Dofw_56FE4, _____4E0B_5C42_4ED3_5E93Dofw_56FE5, _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1, _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D, _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA, _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3, _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392, _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____7ED9_73A9_5BB6_7EC4_6DFB_52A0_591A_4E2A_533A_57DF_89C6_91CE = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["给玩家组添加多个区域视野"]
local _____8BFB_53D6_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取触发单位"]
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
function _____64AD_653E_8C03_67E5_5267_60C5(_____7247_6BB5ID, _____89E6_53D1_5355_4F4D, _____89E6_53D1_914D_7F6E_540D)
    local ____require_result_18 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_18["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = _____89E6_53D1_914D_7F6E_540D, ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0
end
function _____5355_4F4D_5B58_6D3B(unit)
    return _____5355_4F4D_6709_6548(unit) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
function _____6E05_7406_4E0B_5C42_4ED3_5E93_5165_53E3_76D1_542C()
    if _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 ~= nil and _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 ~= 0 then
        safeDestroyTrigger(_____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668)
    end
    _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62_952E)
    _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 = nil
    _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = nil
end
function _____89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB(_____89E6_53D1_5355_4F4D)
    if _____5DF2_89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 39 then
        return
    end
    if not _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 or not _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_5230_8FBE_5BF9_767D_4F4D_7F6E then
        return
    end
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    _____5DF2_89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB = true
    _____4E0B_5C42_4ED3_5E93_89E6_53D1_73A9_5BB6_5355_4F4D = _____89E6_53D1_5355_4F4D
    _____4E0B_5C42_4ED3_5E93_5F85_89E6_53D1_73A9_5BB6_5355_4F4D = nil
    _____6E05_7406_4E0B_5C42_4ED3_5E93_5165_53E3_76D1_542C()
    _____64AD_653E_8C03_67E5_5267_60C5("molten_realm_warehouse_ambush", _____89E6_53D1_5355_4F4D, "恶魔城下层仓库入口")
end
function _____6E05_7406_4E0B_5C42_4ED3_5E93_6218_6597_8FD0_884C_65F6_5F15_7528()
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情单位.教派清理者（学者）")
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情单位.教派清理者（战士）")
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情单位.教派恶魔军官")
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss) then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss)
    end
    YDUserDataClearSafe("string", "Boss", "教派恶魔军官", "unit")
    _____4E0B_5C42_4ED3_5E93_52A8_6001Boss = nil
    if _____4E0B_5C42_4ED3_5E93Dofw_56FE4 ~= nil and _____4E0B_5C42_4ED3_5E93Dofw_56FE4 ~= 0 then
        RemoveDestructable(_____4E0B_5C42_4ED3_5E93Dofw_56FE4)
    end
    if _____4E0B_5C42_4ED3_5E93Dofw_56FE5 ~= nil and _____4E0B_5C42_4ED3_5E93Dofw_56FE5 ~= 0 then
        RemoveDestructable(_____4E0B_5C42_4ED3_5E93Dofw_56FE5)
    end
    _____4E0B_5C42_4ED3_5E93Dofw_56FE4 = nil
    _____4E0B_5C42_4ED3_5E93Dofw_56FE5 = nil
end
function _____5B89_6392_4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97()
    if _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 then
        return
    end
    _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 = true
    addDelayedCallback(1, _____7ED3_7B97_4E0B_5C42_4ED3_5E93_6218_6597, {["世代"] = _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3})
end
function _____7ED3_7B97_4E0B_5C42_4ED3_5E93_6218_6597(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or _____53C2_6570["世代"] ~= _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3 then
        return
    end
    if not _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D then
        return
    end
    _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D = false
    _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 = false
    if _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C then
        unregisterDeathListener(____on_4E0B_5C42_4ED3_5E93_5355_4F4D_6B7B_4EA1)
        _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C = false
    end
    local _____8D64_5C3E_5B58_6D3B = _____5355_4F4D_5B58_6D3B(_____4E0B_5C42_4ED3_5E93_8D64_5C3E) and not _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1
    local _____89E6_53D1_5355_4F4D = _____4E0B_5C42_4ED3_5E93_89E6_53D1_73A9_5BB6_5355_4F4D
    _____6E05_7406_4E0B_5C42_4ED3_5E93_6218_6597_8FD0_884C_65F6_5F15_7528()
    _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 = nil
    _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB = nil
    _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA = 0
    _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_5230_8FBE_5BF9_767D_4F4D_7F6E = false
    _____4E0B_5C42_4ED3_5E93_5F85_89E6_53D1_73A9_5BB6_5355_4F4D = nil
    if _____8D64_5C3E_5B58_6D3B then
        _____64AD_653E_8C03_67E5_5267_60C5("molten_realm_warehouse_survivor_aftermath", _____89E6_53D1_5355_4F4D, "恶魔城下层仓库战后")
    else
        _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("主线NPC.赤尾")
        _____4E0B_5C42_4ED3_5E93_8D64_5C3E = nil
        _____64AD_653E_8C03_67E5_5267_60C5("molten_realm_warehouse_redtail_death_aftermath", _____89E6_53D1_5355_4F4D, "恶魔城下层仓库战后")
    end
end
function ____on_4E0B_5C42_4ED3_5E93_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    if not _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D then
        return
    end
    if dyingUnit == _____4E0B_5C42_4ED3_5E93_8D64_5C3E then
        _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1 = true
        return
    end
    local _____662F_4F0F_51FB_654C_4EBA = false
    if dyingUnit == _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 or dyingUnit == _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB then
        _____662F_4F0F_51FB_654C_4EBA = true
    end
    if dyingUnit == _____4E0B_5C42_4ED3_5E93_52A8_6001Boss then
        _____662F_4F0F_51FB_654C_4EBA = true
    end
    if not _____662F_4F0F_51FB_654C_4EBA then
        return
    end
    if _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA > 0 then
        _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA = _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA - 1
    end
    if _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA <= 0 then
        _____5B89_6392_4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97()
    end
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_0["创建单位并登记排泄安全"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_1["暂停并设置无敌安全"]
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_1["解除暂停并取消无敌安全"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_3["按名字反查总单位ID"]
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerOneShotUnitRangeListener = ____require_result_4.registerOneShotUnitRangeListener
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
unregisterDeathListener = ____require_result_5.unregisterDeathListener
local ____require_result_6 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_6.safeTriggerAddAction
safeDestroyTrigger = ____require_result_6.safeDestroyTrigger
local ____require_result_7 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
_____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_7["是玩家英雄组单位"]
local ____require_result_8 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____52A8_6001_77E9_5F62_533A_57DF_914D_7F6E_8868 = ____require_result_8["动态矩形区域配置表"]
local _____6CE8_518C_52A8_6001_77E9_5F62_533A_57DF = ____require_result_8["注册动态矩形区域"]
_____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF = ____require_result_8["注销动态矩形区域"]
local ____require_result_9 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_9.addDelayedCallback
local addPeriodicCallback = ____require_result_9.addPeriodicCallback
local removePeriodicCallback = ____require_result_9.removePeriodicCallback
local ____require_result_10 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____require_result_10.YDWEAngleBetweenUnitsSafe
local ____require_result_11 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_11.YDUserDataSetSafe
YDUserDataClearSafe = ____require_result_11.YDUserDataClearSafe
local ____require_result_12 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
_____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_12["立即移除单位并取消排泄登记"]
local ____require_result_13 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterEnterRectSimple = ____require_result_13.TriggerRegisterEnterRectSimple
local ____require_result_14 = require("lib.扩展函数.封装函数.01．通用工具.index")
local AdjustPlayerStateBJ = ____require_result_14.AdjustPlayerStateBJ
local ____require_result_15 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_15.QuestMessageBJ
local ____require_result_16 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_16.GetPlayersAll
local ____require_result_17 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local RectContainsUnit = ____require_result_17.RectContainsUnit
local CreateTrigger = jass.CreateTrigger
local CreateDestructable = jass.CreateDestructable
RemoveDestructable = jass.RemoveDestructable
local GetTriggerUnit = jass.GetTriggerUnit
GetUnitState = jass.GetUnitState
GetUnitTypeId = jass.GetUnitTypeId
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssuePointOrder = jass.IssuePointOrder
local IssueTargetOrder = jass.IssueTargetOrder
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerState = jass.GetPlayerState
local PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
local bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED
local bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local _____8C03_67E5_8303_56F4 = 450
____exports["执行开启恶魔城领主区域视野"] = function()
    _____7ED9_73A9_5BB6_7EC4_6DFB_52A0_591A_4E2A_533A_57DF_89C6_91CE("熔岩恶魔城")
end
_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62_952E = "剧情.恶魔城下层仓库入口"
local _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5F85_6218_6682_505C_6765_6E90 = "剧情系统:恶魔城下层仓库清理者待战"
local _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5F85_6218_6682_505C_6765_6E90 = "剧情系统:恶魔城下层仓库赤尾待战"
local _____4E0B_5C42_4ED3_5E93_52A8_6001Boss_5F85_6218_6682_505C_6765_6E90 = "剧情系统:恶魔城教派恶魔军官待战"
local _____8D64_5C3E_524D_5F80_4E0B_5C42_4ED3_5E93_4FDD_5E95_95F4_9694_6BEB_79D2 = 400
local _____8D64_5C3E_5230_8FBE_4E0B_5C42_4ED3_5E93_8DDD_79BB_5E73_65B9 = 96 * 96
local _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5BF9_767DX = 20171.3
local _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5BF9_767DY = -18292.4
local _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5BF9_767D_671D_5411 = 45
____exports["恶魔城调查场景站位表"] = {
    ["锻造区证人"] = {X = 13628.8, Y = -19973.6, ["朝向"] = 90},
    ["锻造区双持居民"] = {X = 13719.9, Y = -14276.8, ["朝向"] = 315},
    ["赤尾"] = {X = 16465.9, Y = -20027.5, ["朝向"] = 270},
    ["下层仓库入口"] = {X = 19611, Y = -18842.2, ["朝向"] = 0},
    ["下层仓库内部"] = {X = 20334, Y = -18094.7, ["朝向"] = 0}
}
local _____5DF2_5E03_7F6E_6076_9B54_57CE_8C03_67E5 = false
local _____5DF2_89E6_53D1_953B_9020_533A_8BC1_4EBA = false
local _____5DF2_89E6_53D1_8D64_5C3E_4EA4_6613 = false
_____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 = false
local _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C
local _____8D64_5C3E_79FB_52A8_4FDD_5E95_56DE_8C03ID = 0
local _____8D64_5C3E_79FB_52A8_4E16_4EE3 = 0
local _____8D64_5C3E_79FB_52A8_72B6_6001
_____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_5230_8FBE_5BF9_767D_4F4D_7F6E = false
_____4E0B_5C42_4ED3_5E93_5F85_89E6_53D1_73A9_5BB6_5355_4F4D = nil
_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = nil
_____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 = nil
_____5DF2_89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB = false
_____4E0B_5C42_4ED3_5E93_89E6_53D1_73A9_5BB6_5355_4F4D = nil
_____4E0B_5C42_4ED3_5E93_8D64_5C3E = nil
_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 = nil
_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB = nil
_____4E0B_5C42_4ED3_5E93_52A8_6001Boss = nil
_____4E0B_5C42_4ED3_5E93Dofw_56FE4 = nil
_____4E0B_5C42_4ED3_5E93Dofw_56FE5 = nil
_____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1 = false
_____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D = false
_____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA = 0
_____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3 = 0
_____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 = false
_____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C = false
local _____5DF2_8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E = false
local function _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, key, _____9ED8_8BA4_503C)
    local value = _____53C2_6570[key]
    if type(value) == "number" then
        return value
    end
    if type(value) == "string" then
        return __TS__Number(value) or _____9ED8_8BA4_503C
    end
    return _____9ED8_8BA4_503C
end
local function _____7A7A_53D6_6D88_8303_56F4_76D1_542C()
end
local function _____8F6C_5411_76EE_6807(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____6765_6E90_5355_4F4D) or not _____5355_4F4D_6709_6548(_____76EE_6807_5355_4F4D) then
        return
    end
    local _____671D_5411 = YDWEAngleBetweenUnitsSafe(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D)
    SetUnitFacing(_____6765_6E90_5355_4F4D, _____671D_5411)
end
local function _____6E05_7406_8D64_5C3E_79FB_52A8_4FDD_5E95()
    if _____8D64_5C3E_79FB_52A8_4FDD_5E95_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____8D64_5C3E_79FB_52A8_4FDD_5E95_56DE_8C03ID)
        _____8D64_5C3E_79FB_52A8_4FDD_5E95_56DE_8C03ID = 0
    end
    if _____8D64_5C3E_79FB_52A8_72B6_6001 ~= nil then
        _____8D64_5C3E_79FB_52A8_72B6_6001["运行中"] = false
    end
    _____8D64_5C3E_79FB_52A8_72B6_6001 = nil
end
local function ____on_8D64_5C3E_79FB_52A8_4FDD_5E95Tick(variable)
    local _____53C2_6570 = variable
    local _____72B6_6001 = _____8D64_5C3E_79FB_52A8_72B6_6001
    local ____temp_19
    if _____53C2_6570 ~= nil then
        ____temp_19 = _____53C2_6570["世代"]
    else
        ____temp_19 = nil
    end
    local _____4E16_4EE3 = ____temp_19
    if _____72B6_6001 == nil or not _____72B6_6001["运行中"] or _____4E16_4EE3 ~= _____72B6_6001["世代"] or _____4E16_4EE3 ~= _____8D64_5C3E_79FB_52A8_4E16_4EE3 then
        if _____8D64_5C3E_79FB_52A8_4FDD_5E95_56DE_8C03ID ~= 0 and (_____72B6_6001 == nil or not _____72B6_6001["运行中"]) then
            removePeriodicCallback(_____8D64_5C3E_79FB_52A8_4FDD_5E95_56DE_8C03ID)
            _____8D64_5C3E_79FB_52A8_4FDD_5E95_56DE_8C03ID = 0
        end
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 39 or not _____5355_4F4D_5B58_6D3B(_____72B6_6001["单位"]) then
        _____6E05_7406_8D64_5C3E_79FB_52A8_4FDD_5E95()
        return
    end
    local dx = GetUnitX(_____72B6_6001["单位"]) - _____72B6_6001["目标X"]
    local dy = GetUnitY(_____72B6_6001["单位"]) - _____72B6_6001["目标Y"]
    if dx * dx + dy * dy <= _____8D64_5C3E_5230_8FBE_4E0B_5C42_4ED3_5E93_8DDD_79BB_5E73_65B9 then
        IssueImmediateOrder(_____72B6_6001["单位"], "holdposition")
        SetUnitFacing(_____72B6_6001["单位"], _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5BF9_767D_671D_5411)
        _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_5230_8FBE_5BF9_767D_4F4D_7F6E = true
        _____6E05_7406_8D64_5C3E_79FB_52A8_4FDD_5E95()
        local _____5F85_89E6_53D1_73A9_5BB6 = _____4E0B_5C42_4ED3_5E93_5F85_89E6_53D1_73A9_5BB6_5355_4F4D
        if _____5355_4F4D_6709_6548(_____5F85_89E6_53D1_73A9_5BB6) and _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____5F85_89E6_53D1_73A9_5BB6) and _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 ~= nil and RectContainsUnit(_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62, _____5F85_89E6_53D1_73A9_5BB6) then
            _____4E0B_5C42_4ED3_5E93_5F85_89E6_53D1_73A9_5BB6_5355_4F4D = nil
            _____89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB(_____5F85_89E6_53D1_73A9_5BB6)
        end
        return
    end
    IssuePointOrder(_____72B6_6001["单位"], "move", _____72B6_6001["目标X"], _____72B6_6001["目标Y"])
end
local function _____8D64_5C3E_8F6C_5411_89E6_53D1_73A9_5BB6(______53C2_6570)
    local _____8D64_5C3E = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.赤尾")
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if _____5355_4F4D_6709_6548(_____8D64_5C3E) and _____5355_4F4D_6709_6548(_____89E6_53D1_5355_4F4D) then
        _____8F6C_5411_76EE_6807(_____8D64_5C3E, _____89E6_53D1_5355_4F4D)
    end
end
local function _____8D64_5C3E_524D_5F80_4E0B_5C42_4ED3_5E93(_____53C2_6570)
    if not _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 then
        return
    end
    local _____8D64_5C3E = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.赤尾")
    if not _____5355_4F4D_5B58_6D3B(_____8D64_5C3E) then
        return
    end
    _____6E05_7406_8D64_5C3E_79FB_52A8_4FDD_5E95()
    _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_5230_8FBE_5BF9_767D_4F4D_7F6E = false
    _____4E0B_5C42_4ED3_5E93_5F85_89E6_53D1_73A9_5BB6_5355_4F4D = nil
    _____8D64_5C3E_79FB_52A8_4E16_4EE3 = _____8D64_5C3E_79FB_52A8_4E16_4EE3 + 1
    local _____4E16_4EE3 = _____8D64_5C3E_79FB_52A8_4E16_4EE3
    local _____76EE_6807X = _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570 or ({}), "赤尾X", _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5BF9_767DX)
    local _____76EE_6807Y = _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570 or ({}), "赤尾Y", _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5BF9_767DY)
    _____8D64_5C3E_79FB_52A8_72B6_6001 = {
        ["世代"] = _____4E16_4EE3,
        ["单位"] = _____8D64_5C3E,
        ["目标X"] = _____76EE_6807X,
        ["目标Y"] = _____76EE_6807Y,
        ["运行中"] = true
    }
    IssuePointOrder(_____8D64_5C3E, "move", _____76EE_6807X, _____76EE_6807Y)
    _____8D64_5C3E_79FB_52A8_4FDD_5E95_56DE_8C03ID = addPeriodicCallback(_____8D64_5C3E_524D_5F80_4E0B_5C42_4ED3_5E93_4FDD_5E95_95F4_9694_6BEB_79D2, ____on_8D64_5C3E_79FB_52A8_4FDD_5E95Tick, {["世代"] = _____4E16_4EE3})
end
local function ____on_953B_9020_533A_8BC1_4EBA_8303_56F4_89E6_53D1(_____89E6_53D1_5355_4F4D)
    if _____5DF2_89E6_53D1_953B_9020_533A_8BC1_4EBA or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 39 then
        return false
    end
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return false
    end
    _____5DF2_89E6_53D1_953B_9020_533A_8BC1_4EBA = true
    _____64AD_653E_8C03_67E5_5267_60C5("molten_realm_forge_witness", _____89E6_53D1_5355_4F4D, "恶魔城锻造区证人入口")
    return true
end
local function ____on_8D64_5C3E_8303_56F4_89E6_53D1(_____89E6_53D1_5355_4F4D)
    if _____5DF2_89E6_53D1_8D64_5C3E_4EA4_6613 or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 39 then
        return false
    end
    if _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 then
        return false
    end
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return false
    end
    _____5DF2_89E6_53D1_8D64_5C3E_4EA4_6613 = true
    _____64AD_653E_8C03_67E5_5267_60C5("molten_realm_redtail_meet", _____89E6_53D1_5355_4F4D, "恶魔城赤尾交易入口")
    return true
end
local function _____6CE8_518C_5355_4F4D_8303_56F4_5165_53E3(unit, range, action)
    if unit == nil or unit == 0 then
        return _____7A7A_53D6_6D88_8303_56F4_76D1_542C
    end
    return registerOneShotUnitRangeListener(unit, range, action, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D)
end
local function ____on_8FDB_5165_4E0B_5C42_4ED3_5E93_5165_53E3()
    if _____5DF2_89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 39 then
        return
    end
    if not _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    if not _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_5230_8FBE_5BF9_767D_4F4D_7F6E then
        _____4E0B_5C42_4ED3_5E93_5F85_89E6_53D1_73A9_5BB6_5355_4F4D = _____89E6_53D1_5355_4F4D
        return
    end
    _____89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB(_____89E6_53D1_5355_4F4D)
end
local function _____6CE8_518C_4E0B_5C42_4ED3_5E93_5165_53E3_76D1_542C()
    if _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 ~= nil and _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 ~= 0 then
        return
    end
    _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = _____6CE8_518C_52A8_6001_77E9_5F62_533A_57DF(_____52A8_6001_77E9_5F62_533A_57DF_914D_7F6E_8868[_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62_952E])
    if _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 == nil or _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 == 0 then
        return
    end
    _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 = CreateTrigger()
    if _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 == nil or _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 == 0 then
        _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62_952E)
        _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = nil
        return
    end
    if safeTriggerAddAction(_____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668, ____on_8FDB_5165_4E0B_5C42_4ED3_5E93_5165_53E3) == nil then
        safeDestroyTrigger(_____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668)
        _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62_952E)
        _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 = nil
        _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = nil
        return
    end
    TriggerRegisterEnterRectSimple(_____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668, _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62)
end
local function _____652F_4ED8_8D64_5C3E_5B9A_91D1(______53C2_6570)
    if _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 then
        return
    end
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____89E6_53D1_5355_4F4D)
    local _____5B9A_91D1 = 300
    if GetPlayerState(_____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD) < _____5B9A_91D1 then
        QuestMessageBJ(
            GetPlayersAll(),
            bj_QUESTMESSAGE_WARNING,
            "|cffffff00『系统提示』：|r金币不足，无法支付赤尾的|cffffcc00300金币定金|r。离开后再次靠近赤尾可以重新交涉。"
        )
        return
    end
    _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 = true
    if _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C ~= nil then
        _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C()
        _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C = nil
    end
    AdjustPlayerStateBJ(-_____5B9A_91D1, _____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD)
    QuestMessageBJ(
        GetPlayersAll(),
        bj_QUESTMESSAGE_UPDATED,
        "|cffffff00『系统提示』：|r已支付赤尾|cffffcc00300金币定金|r。"
    )
end
local function _____7ED3_675F_8D64_5C3E_4EA4_6613_5C1D_8BD5(______53C2_6570)
    if not _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 then
        _____5DF2_89E6_53D1_8D64_5C3E_4EA4_6613 = false
    end
end
local function _____521B_5EFA_5E76_767B_8BB0_8C03_67E5_5355_4F4D(_____5355_4F4DID, _____7AD9_4F4D, _____8BED_4E49_5F15_7528)
    local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5355_4F4DID)
    if not (_____5355_4F4D_7C7B_578BID > 0) then
        return nil
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
        _____5355_4F4D_7C7B_578BID,
        _____7AD9_4F4D.X,
        _____7AD9_4F4D.Y,
        _____7AD9_4F4D["朝向"]
    )
    if unit == nil or unit == 0 then
        return nil
    end
    SetUnitPosition(unit, _____7AD9_4F4D.X, _____7AD9_4F4D.Y)
    SetUnitFacing(unit, _____7AD9_4F4D["朝向"])
    IssueImmediateOrder(unit, "stop")
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8BED_4E49_5F15_7528, unit)
    return unit
end
local function _____521B_5EFA_5E76_51BB_7ED3_4E0B_5C42_4ED3_5E93_6E05_7406_8005(_____5355_4F4D_540D, x, y, _____671D_5411, _____8BED_4E49_5F15_7528)
    local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D))
    if not (_____5355_4F4D_7C7B_578BID > 0) then
        return nil
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        _____5355_4F4D_7C7B_578BID,
        x,
        y,
        _____671D_5411
    )
    if not _____5355_4F4D_6709_6548(unit) then
        return nil
    end
    SetUnitPosition(unit, x, y)
    SetUnitFacing(unit, _____671D_5411)
    IssueImmediateOrder(unit, "stop")
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(unit, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5F85_6218_6682_505C_6765_6E90)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8BED_4E49_5F15_7528, unit)
    return unit
end
local function _____5E03_7F6E_4E0B_5C42_4ED3_5E93_4F0F_51FB(_____53C2_6570)
    if _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D or _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 ~= nil or _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB ~= nil or _____4E0B_5C42_4ED3_5E93_52A8_6001Boss ~= nil then
        return
    end
    local _____8D64_5C3E = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.赤尾")
    if not _____5355_4F4D_6709_6548(_____8D64_5C3E) then
        return
    end
    if not _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_5230_8FBE_5BF9_767D_4F4D_7F6E then
        return
    end
    _____6E05_7406_8D64_5C3E_79FB_52A8_4FDD_5E95()
    _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3 = _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3 + 1
    _____4E0B_5C42_4ED3_5E93_8D64_5C3E = _____8D64_5C3E
    _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1 = not _____5355_4F4D_5B58_6D3B(_____8D64_5C3E)
    _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 = false
    _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA = 0
    local _____8D64_5C3E_671D_5411 = _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "赤尾朝向", _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5BF9_767D_671D_5411)
    SetUnitFacing(_____8D64_5C3E, _____8D64_5C3E_671D_5411)
    IssueImmediateOrder(_____8D64_5C3E, "stop")
    if not _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1 then
        _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(_____8D64_5C3E, _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5F85_6218_6682_505C_6765_6E90)
    end
    _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 = _____521B_5EFA_5E76_51BB_7ED3_4E0B_5C42_4ED3_5E93_6E05_7406_8005(
        "教派清理者（学者）",
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "学者X", 20214.6),
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "学者Y", -18088.2),
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "学者朝向", 135),
        "剧情单位.教派清理者（学者）"
    )
    _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB = _____521B_5EFA_5E76_51BB_7ED3_4E0B_5C42_4ED3_5E93_6E05_7406_8005(
        "教派清理者（战士）",
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "战士X", 20409.9),
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "战士Y", -18284.9),
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "战士朝向", 315),
        "剧情单位.教派清理者（战士）"
    )
    local _____6559_6D3E_6076_9B54_519B_5B98_7C7B_578BID = stringToFourCCSafe("O002")
    if _____6559_6D3E_6076_9B54_519B_5B98_7C7B_578BID > 0 then
        _____4E0B_5C42_4ED3_5E93_52A8_6001Boss = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
            _____6559_6D3E_6076_9B54_519B_5B98_7C7B_578BID,
            20581.7,
            -17857.8,
            225
        )
        if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss) then
            SetUnitPosition(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss, 20581.7, -17857.8)
            SetUnitFacing(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss, 225)
            IssueImmediateOrder(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss, "stop")
            _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss, _____4E0B_5C42_4ED3_5E93_52A8_6001Boss_5F85_6218_6682_505C_6765_6E90)
            _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情单位.教派恶魔军官", _____4E0B_5C42_4ED3_5E93_52A8_6001Boss)
            YDUserDataSetSafe(
                "string",
                "Boss",
                "教派恶魔军官",
                "unit",
                _____4E0B_5C42_4ED3_5E93_52A8_6001Boss
            )
        else
            _____4E0B_5C42_4ED3_5E93_52A8_6001Boss = nil
        end
    end
    local ____Dofw_7C7B_578BID = stringToFourCCSafe("Dofw")
    if ____Dofw_7C7B_578BID > 0 then
        _____4E0B_5C42_4ED3_5E93Dofw_56FE4 = CreateDestructable(
            ____Dofw_7C7B_578BID,
            19455.5,
            -19092.3,
            180,
            1,
            0
        )
        _____4E0B_5C42_4ED3_5E93Dofw_56FE5 = CreateDestructable(
            ____Dofw_7C7B_578BID,
            20854.4,
            -17065.4,
            270,
            1,
            0
        )
    end
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005) then
        _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA = _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA + 1
    end
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB) then
        _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA = _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA + 1
    end
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss) then
        _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA = _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA + 1
    end
    if not _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C then
        registerDeathListener(____on_4E0B_5C42_4ED3_5E93_5355_4F4D_6B7B_4EA1)
        _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C = true
    end
end
local function _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_8F6C_5411_8D64_5C3E(______53C2_6570)
    local ____4E0B_5C42_4ED3_5E93_8D64_5C3E_20 = _____4E0B_5C42_4ED3_5E93_8D64_5C3E
    if ____4E0B_5C42_4ED3_5E93_8D64_5C3E_20 == nil then
        ____4E0B_5C42_4ED3_5E93_8D64_5C3E_20 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.赤尾")
    end
    local _____8D64_5C3E = ____4E0B_5C42_4ED3_5E93_8D64_5C3E_20
    if not _____5355_4F4D_6709_6548(_____8D64_5C3E) then
        return
    end
    _____8F6C_5411_76EE_6807(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, _____8D64_5C3E)
    _____8F6C_5411_76EE_6807(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, _____8D64_5C3E)
end
local function _____5F00_542F_4E0B_5C42_4ED3_5E93_6218_6597(______53C2_6570)
    if _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D then
        return
    end
    local ____4E0B_5C42_4ED3_5E93_8D64_5C3E_21 = _____4E0B_5C42_4ED3_5E93_8D64_5C3E
    if ____4E0B_5C42_4ED3_5E93_8D64_5C3E_21 == nil then
        ____4E0B_5C42_4ED3_5E93_8D64_5C3E_21 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.赤尾")
    end
    local _____8D64_5C3E = ____4E0B_5C42_4ED3_5E93_8D64_5C3E_21
    if not _____5355_4F4D_6709_6548(_____8D64_5C3E) then
        return
    end
    _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D = true
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005) then
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5F85_6218_6682_505C_6765_6E90)
        _____8F6C_5411_76EE_6807(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, _____8D64_5C3E)
        IssueTargetOrder(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, "attack", _____8D64_5C3E)
    end
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB) then
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5F85_6218_6682_505C_6765_6E90)
        _____8F6C_5411_76EE_6807(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, _____8D64_5C3E)
        IssueTargetOrder(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, "attack", _____8D64_5C3E)
    end
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss) then
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss, _____4E0B_5C42_4ED3_5E93_52A8_6001Boss_5F85_6218_6682_505C_6765_6E90)
        _____8F6C_5411_76EE_6807(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss, _____8D64_5C3E)
        IssueTargetOrder(_____4E0B_5C42_4ED3_5E93_52A8_6001Boss, "attack", _____8D64_5C3E)
    end
    if _____5355_4F4D_5B58_6D3B(_____8D64_5C3E) then
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____8D64_5C3E, _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5F85_6218_6682_505C_6765_6E90)
    end
    if _____4E0B_5C42_4ED3_5E93_5269_4F59_654C_4EBA <= 0 then
        _____5B89_6392_4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97()
    end
end
local function _____8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E(______53C2_6570)
    if _____5DF2_8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E then
        return
    end
    _____5DF2_8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E = true
    QuestMessageBJ(
        GetPlayersAll(),
        bj_QUESTMESSAGE_UPDATED,
        "|cffffff00『系统消息』：|r已收集下层仓库的契约、路线图与教派内应证据。返回阿瓦尔处汇报。"
    )
end
____exports["执行布置恶魔城调查"] = function(______53C2_6570)
    if _____5DF2_5E03_7F6E_6076_9B54_57CE_8C03_67E5 then
        return
    end
    _____5DF2_5E03_7F6E_6076_9B54_57CE_8C03_67E5 = true
    local _____953B_9020_533A_8BC1_4EBA = _____521B_5EFA_5E76_767B_8BB0_8C03_67E5_5355_4F4D("n03W", ____exports["恶魔城调查场景站位表"]["锻造区证人"], "主线NPC.锻造区证人")
    _____521B_5EFA_5E76_767B_8BB0_8C03_67E5_5355_4F4D("n03Y", ____exports["恶魔城调查场景站位表"]["锻造区双持居民"], "主线NPC.锻造区双持居民")
    local _____8D64_5C3E = _____521B_5EFA_5E76_767B_8BB0_8C03_67E5_5355_4F4D("n03Z", ____exports["恶魔城调查场景站位表"]["赤尾"], "主线NPC.赤尾")
    _____6CE8_518C_5355_4F4D_8303_56F4_5165_53E3(_____953B_9020_533A_8BC1_4EBA, _____8C03_67E5_8303_56F4, ____on_953B_9020_533A_8BC1_4EBA_8303_56F4_89E6_53D1)
    _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C = _____6CE8_518C_5355_4F4D_8303_56F4_5165_53E3(_____8D64_5C3E, _____8C03_67E5_8303_56F4, ____on_8D64_5C3E_8303_56F4_89E6_53D1)
    _____6CE8_518C_4E0B_5C42_4ED3_5E93_5165_53E3_76D1_542C()
end
____exports["恶魔城调查剧情动作注册表"] = {
    ["第三章_开启恶魔城领主区域视野"] = ____exports["执行开启恶魔城领主区域视野"],
    ["第三章_布置恶魔城调查"] = ____exports["执行布置恶魔城调查"],
    ["第三章_支付赤尾定金"] = _____652F_4ED8_8D64_5C3E_5B9A_91D1,
    ["第三章_结束赤尾交易尝试"] = _____7ED3_675F_8D64_5C3E_4EA4_6613_5C1D_8BD5,
    ["第三章_赤尾转向触发玩家"] = _____8D64_5C3E_8F6C_5411_89E6_53D1_73A9_5BB6,
    ["第三章_赤尾前往下层仓库"] = _____8D64_5C3E_524D_5F80_4E0B_5C42_4ED3_5E93,
    ["第三章_布置下层仓库伏击"] = _____5E03_7F6E_4E0B_5C42_4ED3_5E93_4F0F_51FB,
    ["第三章_下层仓库清理者转向赤尾"] = _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_8F6C_5411_8D64_5C3E,
    ["第三章_开启下层仓库战斗"] = _____5F00_542F_4E0B_5C42_4ED3_5E93_6218_6597,
    ["第三章_记录下层仓库证据"] = _____8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E
}
return ____exports
