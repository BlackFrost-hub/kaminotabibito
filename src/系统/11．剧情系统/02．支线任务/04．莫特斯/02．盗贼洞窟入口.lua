--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF = require("系统.11．剧情系统.02．支线任务.04．莫特斯.00．常量")
local _____83AB_7279_65AF_5165_53E3_77E9_5F62_914D_7F6E_952E = ____00_FF0E_5E38_91CF["莫特斯入口矩形配置键"]
local _____83AB_7279_65AF_5165_53E3_843D_70B9X = ____00_FF0E_5E38_91CF["莫特斯入口落点X"]
local _____83AB_7279_65AF_5165_53E3_843D_70B9Y = ____00_FF0E_5E38_91CF["莫特斯入口落点Y"]
local _____83AB_7279_65AF_5165_53E3_843D_70B9_9762_5411 = ____00_FF0E_5E38_91CF["莫特斯入口落点面向"]
local _____83AB_7279_65AF_6D1E_7A9F_5B88_536B_6682_505C_8303_56F4 = ____00_FF0E_5E38_91CF["莫特斯洞窟守卫暂停范围"]
local _____83AB_7279_65AF_6D1E_7A9F_5B88_536B_6F14_51FA_6682_505C_6765_6E90 = ____00_FF0E_5E38_91CF["莫特斯洞窟守卫演出暂停来源"]
local _____83AB_7279_65AF_6A21_5757_540D = ____00_FF0E_5E38_91CF["莫特斯模块名"]
local ____01_FF0E_8FD0_884C_72B6_6001 = require("系统.11．剧情系统.02．支线任务.04．莫特斯.01．运行状态")
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_72B6_6001["单位存活"]
local _____53E5_67C4_6709_6548 = ____01_FF0E_8FD0_884C_72B6_6001["句柄有效"]
local _____6253_5F00_83AB_7279_65AF_6D1E_7A9F_95E8 = ____01_FF0E_8FD0_884C_72B6_6001["打开莫特斯洞窟门"]
local _____662F_83AB_7279_65AF_526F_672C_73A9_5BB6_82F1_96C4 = ____01_FF0E_8FD0_884C_72B6_6001["是莫特斯副本玩家英雄"]
local _____83AB_7279_65AF_8FD0_884C_72B6_6001 = ____01_FF0E_8FD0_884C_72B6_6001["莫特斯运行状态"]
local ____03_FF0E_83AB_7279_65AFBoss_8FD0_884C = require("系统.11．剧情系统.02．支线任务.04．莫特斯.03．莫特斯Boss运行")
local _____786E_4FDD_521B_5EFA_83AB_7279_65AF = ____03_FF0E_83AB_7279_65AFBoss_8FD0_884C["确保创建莫特斯"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local _____521B_5EFA_77E9_5F62_8FDB_5165_76D1_542C = ____require_result_0["创建矩形进入监听"]
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_1["广播单位提示"]
local _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217 = ____require_result_1["播放广播对白序列"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_2["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_2["移除单位暂停"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____require_result_3.YDWEAngleBetweenUnitsSafe
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("系统.07．地形系统.09．动态矩形区域注册表.02．动态矩形区域动作")
local _____6309_914D_7F6E_952E_6CE8_518C_52A8_6001_77E9_5F62_533A_57DF = ____require_result_5["按配置键注册动态矩形区域"]
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local FirstOfGroup = jass.FirstOfGroup
local GetOwningPlayer = jass.GetOwningPlayer
local GetTriggerUnit = jass.GetTriggerUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local GroupRemoveUnit = jass.GroupRemoveUnit
local IsUnitType = jass.IsUnitType
local IssueImmediateOrder = jass.IssueImmediateOrder
local IsQuestItemCompleted = jass.IsQuestItemCompleted
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local function _____91CA_653E_9996_6B21_5165_53E3_6682_505C()
    if _____53E5_67C4_6709_6548(_____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"]) then
        _____79FB_9664_5355_4F4D_6682_505C(_____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"], _____83AB_7279_65AF_6D1E_7A9F_5B88_536B_6F14_51FA_6682_505C_6765_6E90)
    end
    do
        local i = 0
        while i < #_____83AB_7279_65AF_8FD0_884C_72B6_6001["当前暂停小怪"] do
            local _____5C0F_602A = _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前暂停小怪"][i + 1]
            if _____53E5_67C4_6709_6548(_____5C0F_602A) then
                _____79FB_9664_5355_4F4D_6682_505C(_____5C0F_602A, _____83AB_7279_65AF_6D1E_7A9F_5B88_536B_6F14_51FA_6682_505C_6765_6E90)
            end
            i = i + 1
        end
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前暂停小怪"] = {}
end
local function ____on_9996_6B21_5165_53E3_5BF9_767D_7ED3_675F()
    if _____83AB_7279_65AF_8FD0_884C_72B6_6001["首次入口演出已完成"] then
        return
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["首次入口演出已完成"] = true
    _____91CA_653E_9996_6B21_5165_53E3_6682_505C()
    _____6253_5F00_83AB_7279_65AF_6D1E_7A9F_95E8()
    _____786E_4FDD_521B_5EFA_83AB_7279_65AF()
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前洞窟守卫"] = nil
end
local function _____8BFB_53D6_5B88_536B_5BF9_767D_5355_4F4D(_____8BF4_8BDD_8005_952E)
    local ____temp_6
    if _____8BF4_8BDD_8005_952E == "守卫" then
        ____temp_6 = _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前洞窟守卫"]
    else
        ____temp_6 = _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"]
    end
    return ____temp_6
end
local function _____6821_9A8C_5B88_536B_5355_53E5(______5E8F_53F7, _____8BF4_8BDD_8005_952E)
    return _____5355_4F4D_5B58_6D3B(_____8BFB_53D6_5B88_536B_5BF9_767D_5355_4F4D(_____8BF4_8BDD_8005_952E))
end
local function _____64AD_653E_5B88_536B_5BF9_767D()
    _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217({
        ["对白列表"] = {
            {["说话者键"] = "守卫", ["文本"] = "站住！谁准你们闯进来的？这地方不欢迎活人。", ["停留毫秒"] = 3400},
            {["说话者键"] = "玩家", ["文本"] = "就是你们袭击了沙漠里的佣兵团？", ["停留毫秒"] = 2800},
            {["说话者键"] = "守卫", ["文本"] = "那两个领头的命倒是够硬，居然还能爬回去。怎么，你们也来替他们送死？", ["停留毫秒"] = 4800},
            {["说话者键"] = "玩家", ["文本"] = "我们来查盗贼团和分离教派的关系。让开。", ["停留毫秒"] = 3200},
            {["说话者键"] = "守卫", ["文本"] = "首领就在深处。真有胆子，就自己走到他面前。不过进了这座洞的人，从没活着出去过。", ["停留毫秒"] = 5200}
        },
        ["读取说话单位"] = _____8BFB_53D6_5B88_536B_5BF9_767D_5355_4F4D,
        ["播放单句"] = _____5E7F_64AD_5355_4F4D_63D0_793A,
        ["单句播放前校验"] = _____6821_9A8C_5B88_536B_5355_53E5,
        ["播放中止"] = ____on_9996_6B21_5165_53E3_5BF9_767D_7ED3_675F,
        ["播放完成"] = ____on_9996_6B21_5165_53E3_5BF9_767D_7ED3_675F
    })
end
local function _____6682_505C_9644_8FD1_5C0F_602A_5E76_627E_5B88_536B(_____82F1_96C4)
    local _____5355_4F4D_7EC4 = CreateGroup()
    if not _____53E5_67C4_6709_6548(_____5355_4F4D_7EC4) then
        return nil
    end
    local _____82F1_96C4X = GetUnitX(_____82F1_96C4)
    local _____82F1_96C4Y = GetUnitY(_____82F1_96C4)
    local _____4E2D_7ACB_654C_5BF9 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
    local _____6700_8FD1_5C0F_602A = nil
    local _____6700_8FD1_8DDD_79BB_5E73_65B9 = 0
    GroupEnumUnitsInRange(
        _____5355_4F4D_7EC4,
        _____82F1_96C4X,
        _____82F1_96C4Y,
        _____83AB_7279_65AF_6D1E_7A9F_5B88_536B_6682_505C_8303_56F4,
        nil
    )
    while true do
        do
            local _____5355_4F4D = FirstOfGroup(_____5355_4F4D_7EC4)
            if not _____53E5_67C4_6709_6548(_____5355_4F4D) then
                break
            end
            GroupRemoveUnit(_____5355_4F4D_7EC4, _____5355_4F4D)
            if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) or GetOwningPlayer(_____5355_4F4D) ~= _____4E2D_7ACB_654C_5BF9 or IsUnitType(_____5355_4F4D, jass.UNIT_TYPE_HERO) == true then
                goto __continue14
            end
            local ____83AB_7279_65AF_8FD0_884C_72B6_6001__5F53_524D_6682_505C_5C0F_602A_7 = _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前暂停小怪"]
            ____83AB_7279_65AF_8FD0_884C_72B6_6001__5F53_524D_6682_505C_5C0F_602A_7[#____83AB_7279_65AF_8FD0_884C_72B6_6001__5F53_524D_6682_505C_5C0F_602A_7 + 1] = _____5355_4F4D
            IssueImmediateOrder(_____5355_4F4D, "stop")
            _____6DFB_52A0_5355_4F4D_6682_505C(_____5355_4F4D, _____83AB_7279_65AF_6D1E_7A9F_5B88_536B_6F14_51FA_6682_505C_6765_6E90)
            local ____X_5DEE = GetUnitX(_____5355_4F4D) - _____82F1_96C4X
            local ____Y_5DEE = GetUnitY(_____5355_4F4D) - _____82F1_96C4Y
            local _____8DDD_79BB_5E73_65B9 = ____X_5DEE * ____X_5DEE + ____Y_5DEE * ____Y_5DEE
            if not _____53E5_67C4_6709_6548(_____6700_8FD1_5C0F_602A) or _____8DDD_79BB_5E73_65B9 < _____6700_8FD1_8DDD_79BB_5E73_65B9 then
                _____6700_8FD1_5C0F_602A = _____5355_4F4D
                _____6700_8FD1_8DDD_79BB_5E73_65B9 = _____8DDD_79BB_5E73_65B9
            end
        end
        ::__continue14::
    end
    DestroyGroup(_____5355_4F4D_7EC4)
    return _____6700_8FD1_5C0F_602A
end
local function _____5F00_59CB_9996_6B21_5165_53E3_6F14_51FA(_____82F1_96C4)
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["首次入口演出已开始"] = true
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"] = _____82F1_96C4
    IssueImmediateOrder(_____82F1_96C4, "stop")
    _____6DFB_52A0_5355_4F4D_6682_505C(_____82F1_96C4, _____83AB_7279_65AF_6D1E_7A9F_5B88_536B_6F14_51FA_6682_505C_6765_6E90)
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前洞窟守卫"] = _____6682_505C_9644_8FD1_5C0F_602A_5E76_627E_5B88_536B(_____82F1_96C4)
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["当前洞窟守卫"]) then
        debugLogForce(_____83AB_7279_65AF_6A21_5757_540D, "入口落点附近未找到中立敌对小怪", "radius=", _____83AB_7279_65AF_6D1E_7A9F_5B88_536B_6682_505C_8303_56F4)
        ____on_9996_6B21_5165_53E3_5BF9_767D_7ED3_675F()
        return
    end
    SetUnitFacing(
        _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前洞窟守卫"],
        YDWEAngleBetweenUnitsSafe(_____83AB_7279_65AF_8FD0_884C_72B6_6001["当前洞窟守卫"], _____82F1_96C4)
    )
    SetUnitFacing(
        _____82F1_96C4,
        YDWEAngleBetweenUnitsSafe(_____82F1_96C4, _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前洞窟守卫"])
    )
    _____64AD_653E_5B88_536B_5BF9_767D()
end
local function ____on_6C38_4E45_5165_53E3_8FDB_5165()
    local _____89E6_53D1_82F1_96C4 = GetTriggerUnit()
    if not _____662F_83AB_7279_65AF_526F_672C_73A9_5BB6_82F1_96C4(_____89E6_53D1_82F1_96C4) then
        return
    end
    if IsQuestItemCompleted(jglobals.udg_RWXM[18]) ~= true then
        return
    end
    SetUnitPosition(_____89E6_53D1_82F1_96C4, _____83AB_7279_65AF_5165_53E3_843D_70B9X, _____83AB_7279_65AF_5165_53E3_843D_70B9Y)
    SetUnitFacing(_____89E6_53D1_82F1_96C4, _____83AB_7279_65AF_5165_53E3_843D_70B9_9762_5411)
    IssueImmediateOrder(_____89E6_53D1_82F1_96C4, "stop")
    if not _____83AB_7279_65AF_8FD0_884C_72B6_6001["首次入口演出已开始"] then
        _____5F00_59CB_9996_6B21_5165_53E3_6F14_51FA(_____89E6_53D1_82F1_96C4)
    elseif _____83AB_7279_65AF_8FD0_884C_72B6_6001["首次入口演出已完成"] then
        _____786E_4FDD_521B_5EFA_83AB_7279_65AF()
    end
end
--- 永久保留传送入口；首次对白、Boss 创建和靠近监听各自只执行一次。
____exports["初始化莫特斯隐藏副本"] = function()
    if _____83AB_7279_65AF_8FD0_884C_72B6_6001["永久入口已初始化"] then
        return
    end
    local _____5165_53E3_77E9_5F62 = _____6309_914D_7F6E_952E_6CE8_518C_52A8_6001_77E9_5F62_533A_57DF(_____83AB_7279_65AF_5165_53E3_77E9_5F62_914D_7F6E_952E)
    if not _____53E5_67C4_6709_6548(_____5165_53E3_77E9_5F62) then
        debugLogForce(_____83AB_7279_65AF_6A21_5757_540D, "永久入口初始化失败", "rect=", _____5165_53E3_77E9_5F62)
        return
    end
    local _____76D1_542C = _____521B_5EFA_77E9_5F62_8FDB_5165_76D1_542C(_____5165_53E3_77E9_5F62, ____on_6C38_4E45_5165_53E3_8FDB_5165, nil)
    if _____76D1_542C == nil then
        debugLogForce(_____83AB_7279_65AF_6A21_5757_540D, "永久入口动作注册失败")
        return
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["永久入口区域"] = _____76D1_542C["区域"]
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["永久入口触发器"] = _____76D1_542C["触发器"]
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["永久入口已初始化"] = true
end
return ____exports
