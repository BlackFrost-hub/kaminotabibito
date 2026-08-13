local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
local _____5F52_7C7B_53CD_67E5_5355_4F4DID, _____89E3_6790_4E16_754C_5730_56FE_5355_4F4DID, _____89E3_6790_4E16_754C_5730_56FE_5355_4F4D_671D_5411, _____89E3_6790_4E16_754C_5730_56FE_5355_4F4D_73A9_5BB6, _____767B_8BB0_4E16_754C_5730_56FE_5916_90E8_4EFB_52A1NPC_5355_4F4D, _____521B_5EFA_4E16_754C_5730_56FE_5355_4F4D_5B9E_4F8B, _____6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4, _____6807_8BB0_521D_59CB_6CE8_518CBoss_4E34_65F6_8DF3_8FC7_6B7B_4EA1_7ED3_7B97, _____6267_884C_5355_6761_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C, _____6267_884C_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_914D_7F6E_8868, stringToFourCC, _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168, GetRandomDirectionDeg, addDelayedCallback, _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID, _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID, _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID, YDUserDataSetSafe, YDUserDataClearSafe, Player, ShowUnit, S2R, _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID, _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID, _____521D_59CB_6CE8_518CBoss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97_5B57_6BB5, _____521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_6BEB_79D2, _____521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_6E05_7406_5DF2_5B89_6392, _____5F85_6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_5355_4F4D
local ____00_FF0E_5F00_5173_4E0E_7C7B_578B = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.00．开关与类型")
local _____4E16_754C_5730_56FE_5355_4F4D_9ED8_8BA4_6279_6B21_95F4_9694_79D2 = ____00_FF0E_5F00_5173_4E0E_7C7B_578B["世界地图单位默认批次间隔秒"]
local _____4E16_754C_5730_56FE_5355_4F4D_9ED8_8BA4_6BCF_6279_521B_5EFA_6570_91CF = ____00_FF0E_5F00_5173_4E0E_7C7B_578B["世界地图单位默认每批创建数量"]
local ____05_FF0E_4E2D_7ACB_751F_7269_914D_7F6E_8868 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.05．中立生物配置表")
local _____4E16_754C_5730_56FE_4E2D_7ACB_751F_7269_914D_7F6E_8868 = ____05_FF0E_4E2D_7ACB_751F_7269_914D_7F6E_8868["世界地图中立生物配置表"]
local ____06_FF0E_690D_7269_914D_7F6E_8868 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.06．植物配置表")
local _____4E16_754C_5730_56FE_690D_7269_5355_4F4D_914D_7F6E_8868 = ____06_FF0E_690D_7269_914D_7F6E_8868["世界地图植物单位配置表"]
local _____4E16_754C_5730_56FE_690D_7269_968F_673A_7269_54C1_914D_7F6E_8868 = ____06_FF0E_690D_7269_914D_7F6E_8868["世界地图植物随机物品配置表"]
local ____07_FF0E_5F02_754C_63CF_8FF0_77F3_914D_7F6E_8868 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.07．异界描述石配置表")
local _____4E16_754C_5730_56FE_5F02_754C_63CF_8FF0_77F3_914D_7F6E_8868 = ____07_FF0E_5F02_754C_63CF_8FF0_77F3_914D_7F6E_8868["世界地图异界描述石配置表"]
local ____08_FF0EBoss_521D_59CB_6CE8_518C_914D_7F6E_8868 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.08．Boss初始注册配置表")
local _____4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_5EF6_8FDF_79D2 = ____08_FF0EBoss_521D_59CB_6CE8_518C_914D_7F6E_8868["世界地图Boss初始注册延迟秒"]
local _____4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_914D_7F6E_8868 = ____08_FF0EBoss_521D_59CB_6CE8_518C_914D_7F6E_8868["世界地图Boss初始注册配置表"]
local _____4E16_754C_5730_56FEBoss_521D_59CB_989D_5916_5355_4F4D_914D_7F6E_8868 = ____08_FF0EBoss_521D_59CB_6CE8_518C_914D_7F6E_8868["世界地图Boss初始额外单位配置表"]
local ____09_FF0E_4E16_754C_5730_56FE_5355_4F4D_7F13_5B58 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.09．世界地图单位缓存")
local _____5C1D_8BD5_7F13_5B58_4E16_754C_5730_56FE_5355_4F4D = ____09_FF0E_4E16_754C_5730_56FE_5355_4F4D_7F13_5B58["尝试缓存世界地图单位"]
function _____5F52_7C7B_53CD_67E5_5355_4F4DID(_____654C_4EBA_5F52_7C7B, _____5355_4F4D_540D)
    if _____654C_4EBA_5F52_7C7B == "Boss" then
        return _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____5355_4F4D_540D)
    end
    if _____654C_4EBA_5F52_7C7B == "异界Boss" then
        return _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID(_____5355_4F4D_540D)
    end
    if _____654C_4EBA_5F52_7C7B == "NPC" then
        return _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D)
    end
    return nil
end
function _____89E3_6790_4E16_754C_5730_56FE_5355_4F4DID(_____914D_7F6E)
    if _____914D_7F6E["敌人归类"] == "杂鱼" or _____914D_7F6E["敌人归类"] == "精英" then
        local ____opt_14 = _____914D_7F6E["兼容单位ID"]
        local _____517C_5BB9_5355_4F4DID = ____opt_14 and __TS__StringTrim(_____914D_7F6E["兼容单位ID"])
        if _____517C_5BB9_5355_4F4DID ~= nil and #_____517C_5BB9_5355_4F4DID >= 4 then
            return __TS__StringSubstring(_____517C_5BB9_5355_4F4DID, 0, 4)
        end
        return nil
    end
    local _____53CD_67E5_7ED3_679C = _____5F52_7C7B_53CD_67E5_5355_4F4DID(_____914D_7F6E["敌人归类"], _____914D_7F6E["单位名"])
    if _____53CD_67E5_7ED3_679C ~= nil and _____53CD_67E5_7ED3_679C ~= "" then
        return _____53CD_67E5_7ED3_679C
    end
    local _____603B_8868_53CD_67E5_7ED3_679C = _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____914D_7F6E["单位名"])
    if _____603B_8868_53CD_67E5_7ED3_679C ~= nil and _____603B_8868_53CD_67E5_7ED3_679C ~= "" then
        return _____603B_8868_53CD_67E5_7ED3_679C
    end
    local ____opt_16 = _____914D_7F6E["兼容单位ID"]
    local _____517C_5BB9_5355_4F4DID = ____opt_16 and __TS__StringTrim(_____914D_7F6E["兼容单位ID"])
    if _____517C_5BB9_5355_4F4DID ~= nil and #_____517C_5BB9_5355_4F4DID >= 4 then
        return __TS__StringSubstring(_____517C_5BB9_5355_4F4DID, 0, 4)
    end
    return nil
end
function _____89E3_6790_4E16_754C_5730_56FE_5355_4F4D_671D_5411(_____914D_7F6E)
    if _____914D_7F6E["朝向"] == "随机" then
        return GetRandomDirectionDeg()
    end
    if type(_____914D_7F6E["朝向"]) == "number" then
        return _____914D_7F6E["朝向"]
    end
    return S2R(_____914D_7F6E["朝向"])
end
function _____89E3_6790_4E16_754C_5730_56FE_5355_4F4D_73A9_5BB6(_____914D_7F6E)
    local _____73A9_5BB6ID = _____914D_7F6E["玩家ID"] or (_____914D_7F6E["敌人归类"] == "NPC" and _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID or _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID)
    return Player(_____73A9_5BB6ID)
end
function _____767B_8BB0_4E16_754C_5730_56FE_5916_90E8_4EFB_52A1NPC_5355_4F4D(_____4EFB_52A1ID, _____5355_4F4D)
    local ____NPC_751F_6210_5668 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
    ____NPC_751F_6210_5668["登记外部任务NPC单位"](_____4EFB_52A1ID, _____5355_4F4D)
end
function _____521B_5EFA_4E16_754C_5730_56FE_5355_4F4D_5B9E_4F8B(_____914D_7F6E)
    local _____5355_4F4DID = _____89E3_6790_4E16_754C_5730_56FE_5355_4F4DID(_____914D_7F6E)
    if _____5355_4F4DID == nil then
        return nil
    end
    local _____5355_4F4D_7C7B_578BID = stringToFourCC(_____5355_4F4DID)
    local _____9762_5411_89D2_5EA6 = _____89E3_6790_4E16_754C_5730_56FE_5355_4F4D_671D_5411(_____914D_7F6E)
    local _____73A9_5BB6 = _____89E3_6790_4E16_754C_5730_56FE_5355_4F4D_73A9_5BB6(_____914D_7F6E)
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____73A9_5BB6,
        _____5355_4F4D_7C7B_578BID,
        _____914D_7F6E.X,
        _____914D_7F6E.Y,
        _____9762_5411_89D2_5EA6
    )
    _____5C1D_8BD5_7F13_5B58_4E16_754C_5730_56FE_5355_4F4D(_____914D_7F6E, unit)
    if _____914D_7F6E["任务NPC任务ID"] ~= nil then
        _____767B_8BB0_4E16_754C_5730_56FE_5916_90E8_4EFB_52A1NPC_5355_4F4D(_____914D_7F6E["任务NPC任务ID"], unit)
    end
    return unit
end
function _____6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4()
    do
        local i = 0
        while i < #_____5F85_6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_5355_4F4D do
            local _____5355_4F4D = _____5F85_6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_5355_4F4D[i + 1]
            if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 then
                YDUserDataClearSafe("unit", _____5355_4F4D, _____521D_59CB_6CE8_518CBoss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97_5B57_6BB5, "boolean")
            end
            i = i + 1
        end
    end
    __TS__ArraySetLength(_____5F85_6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_5355_4F4D, 0)
    _____521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_6E05_7406_5DF2_5B89_6392 = false
end
function _____6807_8BB0_521D_59CB_6CE8_518CBoss_4E34_65F6_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    YDUserDataSetSafe(
        "unit",
        _____5355_4F4D,
        _____521D_59CB_6CE8_518CBoss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97_5B57_6BB5,
        "boolean",
        true
    )
    _____5F85_6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_5355_4F4D[#_____5F85_6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_5355_4F4D + 1] = _____5355_4F4D
    if _____521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_6E05_7406_5DF2_5B89_6392 then
        return
    end
    _____521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_6E05_7406_5DF2_5B89_6392 = true
    addDelayedCallback(_____521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_6BEB_79D2, _____6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4)
end
function _____6267_884C_5355_6761_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C(_____914D_7F6E)
    local _____5355_4F4D = _____521B_5EFA_4E16_754C_5730_56FE_5355_4F4D_5B9E_4F8B(_____914D_7F6E)
    if _____5355_4F4D == nil then
        return nil
    end
    _____6807_8BB0_521D_59CB_6CE8_518CBoss_4E34_65F6_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(_____5355_4F4D)
    if _____914D_7F6E["记录到Boss表键名"] ~= nil and _____914D_7F6E["记录到Boss表键名"] ~= "" then
        YDUserDataSetSafe(
            "string",
            "Boss",
            _____914D_7F6E["记录到Boss表键名"],
            "unit",
            _____5355_4F4D
        )
    end
    if _____914D_7F6E["初始隐藏"] == true then
        ShowUnit(_____5355_4F4D, false)
    end
    return _____5355_4F4D
end
function _____6267_884C_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_914D_7F6E_8868(_____914D_7F6E_8868)
    local _____5DF2_521B_5EFA_6570_91CF = 0
    for ____, _____914D_7F6E in ipairs(_____914D_7F6E_8868) do
        if _____6267_884C_5355_6761_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C(_____914D_7F6E) ~= nil then
            _____5DF2_521B_5EFA_6570_91CF = _____5DF2_521B_5EFA_6570_91CF + 1
        end
    end
    return _____5DF2_521B_5EFA_6570_91CF
end
____exports["初始化世界地图Boss初始注册"] = function()
    return _____6267_884C_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_914D_7F6E_8868(_____4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_914D_7F6E_8868) + _____6267_884C_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_914D_7F6E_8868(_____4E16_754C_5730_56FEBoss_521D_59CB_989D_5916_5355_4F4D_914D_7F6E_8868)
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
stringToFourCC = ____require_result_1.stringToFourCC
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
_____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_3["创建单位并登记排泄安全"]
local ____require_result_4 = require("lib.扩展函数.BJ函数.07．杂项")
GetRandomDirectionDeg = ____require_result_4.GetRandomDirectionDeg
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_5.addDelayedCallback
local addPeriodicCallback = ____require_result_5.addPeriodicCallback
local removePeriodicCallback = ____require_result_5.removePeriodicCallback
local ____require_result_6 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
_____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_6["按名字反查Boss单位ID"]
local ____require_result_7 = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表")
_____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID = ____require_result_7["按名字反查异界Boss单位ID"]
local ____require_result_8 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
_____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_8["按名字反查总单位ID"]
local ____require_result_9 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_9["按名字反查物品ID"]
local ____require_result_10 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_10["创建物品并注册排泄监听"]
local ____require_result_11 = require("系统.02．物品系统.17．装备采集.02．核心")
local _____767B_8BB0_91C7_96C6_7269_54C1_5B9E_4F8B = ____require_result_11["登记采集物品实例"]
local ____require_result_12 = require("lib.扩展函数.BJ函数.03．物品与库存")
local AddItemToStockBJ = ____require_result_12.AddItemToStockBJ
local ____require_result_13 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataSetSafe = ____require_result_13.YDUserDataSetSafe
YDUserDataClearSafe = ____require_result_13.YDUserDataClearSafe
Player = jass.Player
local GetRandomReal = jass.GetRandomReal
local GetRectMinX = jass.GetRectMinX
local GetRectMaxX = jass.GetRectMaxX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxY = jass.GetRectMaxY
ShowUnit = jass.ShowUnit
local R2I = jass.R2I
S2R = jass.S2R
_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
_____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = jass.PLAYER_NEUTRAL_PASSIVE
local _____4E16_754C_5730_56FE_968F_673A_5355_4F4D_9ED8_8BA4_73A9_5BB6ID = _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID
local _____4E16_754C_5730_56FE_968F_673A_5355_4F4D_9ED8_8BA4_671D_5411 = 0
_____521D_59CB_6CE8_518CBoss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97_5B57_6BB5 = "初始注册Boss跳过死亡结算"
_____521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_6BEB_79D2 = 3000
_____521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_6E05_7406_5DF2_5B89_6392 = false
_____5F85_6E05_7406_521D_59CB_6CE8_518CBoss_6B7B_4EA1_7ED3_7B97_4FDD_62A4_5355_4F4D = {}
local _____7F13_6B65_521B_5EFA_8C03_5EA6_5668_95F4_9694_6BEB_79D2 = 10
local _____5F53_524D_9ED8_8BA4_4EFB_52A1ID
local _____4E0B_4E00_4E2A_7F13_6B65_521B_5EFA_4EFB_52A1ID = 1
local _____7F13_6B65_521B_5EFA_8C03_5EA6_5668_56DE_8C03ID
local _____7F13_6B65_521B_5EFA_4EFB_52A1_8868 = {}
local _____4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_5B8C_6210_56DE_8C03
local function _____83B7_53D6_968F_673A_77E9_5F62X(rect)
    return GetRandomReal(
        GetRectMinX(rect),
        GetRectMaxX(rect)
    )
end
local function _____83B7_53D6_968F_673A_77E9_5F62Y(rect)
    return GetRandomReal(
        GetRectMinY(rect),
        GetRectMaxY(rect)
    )
end
local function _____89E3_6790_4E16_754C_5730_56FE_7269_54C1ID(_____7269_54C1_540D)
    local _____540E_7F00_5206_9694_4F4D_7F6E = (string.find(_____7269_54C1_540D, "#", nil, true) or 0) - 1
    if _____540E_7F00_5206_9694_4F4D_7F6E > 0 then
        local _____6307_5B9A_7269_54C1ID = __TS__StringSubstring(_____7269_54C1_540D, _____540E_7F00_5206_9694_4F4D_7F6E + 1)
        if #_____6307_5B9A_7269_54C1ID == 4 and stringToFourCCSafe(_____6307_5B9A_7269_54C1ID) > 0 then
            return _____6307_5B9A_7269_54C1ID
        end
        _____7269_54C1_540D = __TS__StringSubstring(_____7269_54C1_540D, 0, _____540E_7F00_5206_9694_4F4D_7F6E)
    end
    local _____53CD_67E5_7ED3_679C = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D)
    if _____53CD_67E5_7ED3_679C ~= nil and _____53CD_67E5_7ED3_679C ~= "" then
        return _____53CD_67E5_7ED3_679C
    end
    return nil
end
local function _____6267_884C_5355_6761_4E16_754C_5730_56FE_5355_4F4D_521B_5EFA(_____914D_7F6E)
    local _____5355_4F4D = _____521B_5EFA_4E16_754C_5730_56FE_5355_4F4D_5B9E_4F8B(_____914D_7F6E)
    return _____5355_4F4D ~= nil
end
local function _____83B7_53D6_7F13_6B65_521B_5EFA_4EFB_52A1(_____4EFB_52A1ID)
    if _____4EFB_52A1ID == nil then
        return nil
    end
    return _____7F13_6B65_521B_5EFA_4EFB_52A1_8868[_____4EFB_52A1ID]
end
local function _____6784_9020_7A7A_7F13_6B65_521B_5EFA_72B6_6001()
    return {["总数"] = 0, ["当前索引"] = 0, ["已创建数量"] = 0, ["运行中"] = false}
end
local function _____6784_9020_7F13_6B65_521B_5EFA_72B6_6001(_____4EFB_52A1)
    if _____4EFB_52A1 == nil then
        return _____6784_9020_7A7A_7F13_6B65_521B_5EFA_72B6_6001()
    end
    return {["总数"] = #_____4EFB_52A1["配置表"], ["当前索引"] = _____4EFB_52A1["当前索引"], ["已创建数量"] = _____4EFB_52A1["已创建数量"], ["运行中"] = true}
end
local function _____662F_5426_4ECD_6709_7F13_6B65_521B_5EFA_4EFB_52A1()
    for ____, _____4EFB_52A1 in ipairs(__TS__ObjectValues(_____7F13_6B65_521B_5EFA_4EFB_52A1_8868)) do
        if _____4EFB_52A1 ~= nil then
            return true
        end
    end
    return false
end
local function _____5982_65E0_4EFB_52A1_5219_505C_6B62_7F13_6B65_521B_5EFA_8C03_5EA6_5668()
    if _____662F_5426_4ECD_6709_7F13_6B65_521B_5EFA_4EFB_52A1() then
        return
    end
    if _____7F13_6B65_521B_5EFA_8C03_5EA6_5668_56DE_8C03ID == nil then
        return
    end
    removePeriodicCallback(_____7F13_6B65_521B_5EFA_8C03_5EA6_5668_56DE_8C03ID)
    _____7F13_6B65_521B_5EFA_8C03_5EA6_5668_56DE_8C03ID = nil
end
local function _____5220_9664_7F13_6B65_521B_5EFA_4EFB_52A1(_____4EFB_52A1ID)
    __TS__Delete(_____7F13_6B65_521B_5EFA_4EFB_52A1_8868, _____4EFB_52A1ID)
    if _____5F53_524D_9ED8_8BA4_4EFB_52A1ID == _____4EFB_52A1ID then
        _____5F53_524D_9ED8_8BA4_4EFB_52A1ID = nil
    end
    _____5982_65E0_4EFB_52A1_5219_505C_6B62_7F13_6B65_521B_5EFA_8C03_5EA6_5668()
end
local function _____505C_6B62_6307_5B9A_7F13_6B65_521B_5EFA_4EFB_52A1(_____4EFB_52A1ID)
    if _____4EFB_52A1ID == nil then
        return
    end
    _____5220_9664_7F13_6B65_521B_5EFA_4EFB_52A1(_____4EFB_52A1ID)
end
local function _____6267_884C_5355_4E2A_7F13_6B65_521B_5EFA_4EFB_52A1_4E00_6279(_____4EFB_52A1)
    local _____672C_6279_521B_5EFA_6570 = 0
    while _____4EFB_52A1["当前索引"] < #_____4EFB_52A1["配置表"] and _____672C_6279_521B_5EFA_6570 < _____4EFB_52A1["每批创建数量"] do
        local _____914D_7F6E = _____4EFB_52A1["配置表"][_____4EFB_52A1["当前索引"] + 1]
        _____4EFB_52A1["当前索引"] = _____4EFB_52A1["当前索引"] + 1
        _____672C_6279_521B_5EFA_6570 = _____672C_6279_521B_5EFA_6570 + 1
        if _____6267_884C_5355_6761_4E16_754C_5730_56FE_5355_4F4D_521B_5EFA(_____914D_7F6E) then
            _____4EFB_52A1["已创建数量"] = _____4EFB_52A1["已创建数量"] + 1
        end
    end
    if _____4EFB_52A1["当前索引"] < #_____4EFB_52A1["配置表"] then
        return
    end
    local _____5B8C_6210_56DE_8C03 = _____4EFB_52A1["完成回调"]
    local _____5DF2_521B_5EFA_6570_91CF = _____4EFB_52A1["已创建数量"]
    _____5220_9664_7F13_6B65_521B_5EFA_4EFB_52A1(_____4EFB_52A1["任务ID"])
    if type(_____5B8C_6210_56DE_8C03) == "function" then
        _____5B8C_6210_56DE_8C03(_____5DF2_521B_5EFA_6570_91CF)
    end
end
local function _____5904_7406_5168_90E8_7F13_6B65_521B_5EFA_4EFB_52A1()
    for ____, _____4EFB_52A1 in ipairs(__TS__ObjectValues(_____7F13_6B65_521B_5EFA_4EFB_52A1_8868)) do
        do
            if _____4EFB_52A1 == nil then
                goto __continue49
            end
            _____4EFB_52A1["已累计毫秒"] = _____4EFB_52A1["已累计毫秒"] + _____7F13_6B65_521B_5EFA_8C03_5EA6_5668_95F4_9694_6BEB_79D2
            if _____4EFB_52A1["已累计毫秒"] < _____4EFB_52A1["批次间隔毫秒"] then
                goto __continue49
            end
            _____4EFB_52A1["已累计毫秒"] = 0
            _____6267_884C_5355_4E2A_7F13_6B65_521B_5EFA_4EFB_52A1_4E00_6279(_____4EFB_52A1)
        end
        ::__continue49::
    end
    _____5982_65E0_4EFB_52A1_5219_505C_6B62_7F13_6B65_521B_5EFA_8C03_5EA6_5668()
end
local function _____786E_4FDD_7F13_6B65_521B_5EFA_8C03_5EA6_5668_5DF2_542F_52A8()
    if _____7F13_6B65_521B_5EFA_8C03_5EA6_5668_56DE_8C03ID ~= nil then
        return
    end
    _____7F13_6B65_521B_5EFA_8C03_5EA6_5668_56DE_8C03ID = addPeriodicCallback(_____7F13_6B65_521B_5EFA_8C03_5EA6_5668_95F4_9694_6BEB_79D2, _____5904_7406_5168_90E8_7F13_6B65_521B_5EFA_4EFB_52A1)
end
____exports["预解析世界地图单位ID"] = function(_____914D_7F6E)
    return _____89E3_6790_4E16_754C_5730_56FE_5355_4F4DID(_____914D_7F6E)
end
____exports["获取世界地图单位缓步创建任务状态"] = function(_____4EFB_52A1ID)
    return _____6784_9020_7F13_6B65_521B_5EFA_72B6_6001(_____83B7_53D6_7F13_6B65_521B_5EFA_4EFB_52A1(_____4EFB_52A1ID))
end
____exports["获取世界地图单位缓步创建状态"] = function()
    return _____6784_9020_7F13_6B65_521B_5EFA_72B6_6001(_____83B7_53D6_7F13_6B65_521B_5EFA_4EFB_52A1(_____5F53_524D_9ED8_8BA4_4EFB_52A1ID))
end
____exports["启动世界地图单位缓步创建任务"] = function(_____914D_7F6E_8868, _____9009_9879)
    local _____6BCF_6279_521B_5EFA_6570_91CF_539F_503C = _____9009_9879 and _____9009_9879["每批创建数量"] or _____4E16_754C_5730_56FE_5355_4F4D_9ED8_8BA4_6BCF_6279_521B_5EFA_6570_91CF
    local _____6BCF_6279_521B_5EFA_6570_91CF = _____6BCF_6279_521B_5EFA_6570_91CF_539F_503C > 0 and _____6BCF_6279_521B_5EFA_6570_91CF_539F_503C or _____4E16_754C_5730_56FE_5355_4F4D_9ED8_8BA4_6BCF_6279_521B_5EFA_6570_91CF
    local _____6279_6B21_95F4_9694_79D2_539F_503C = _____9009_9879 and _____9009_9879["批次间隔秒"] or _____4E16_754C_5730_56FE_5355_4F4D_9ED8_8BA4_6279_6B21_95F4_9694_79D2
    local _____6279_6B21_95F4_9694_79D2 = _____6279_6B21_95F4_9694_79D2_539F_503C >= 0 and _____6279_6B21_95F4_9694_79D2_539F_503C or _____4E16_754C_5730_56FE_5355_4F4D_9ED8_8BA4_6279_6B21_95F4_9694_79D2
    local _____6279_6B21_95F4_9694_6BEB_79D2 = _____6279_6B21_95F4_9694_79D2 <= 0 and 1 or R2I(_____6279_6B21_95F4_9694_79D2 * 1000)
    local _____4EFB_52A1ID = _____4E0B_4E00_4E2A_7F13_6B65_521B_5EFA_4EFB_52A1ID
    _____4E0B_4E00_4E2A_7F13_6B65_521B_5EFA_4EFB_52A1ID = _____4E0B_4E00_4E2A_7F13_6B65_521B_5EFA_4EFB_52A1ID + 1
    _____7F13_6B65_521B_5EFA_4EFB_52A1_8868[_____4EFB_52A1ID] = {
        ["任务ID"] = _____4EFB_52A1ID,
        ["配置表"] = _____914D_7F6E_8868,
        ["当前索引"] = 0,
        ["已创建数量"] = 0,
        ["每批创建数量"] = _____6BCF_6279_521B_5EFA_6570_91CF,
        ["批次间隔毫秒"] = _____6279_6B21_95F4_9694_6BEB_79D2 < _____7F13_6B65_521B_5EFA_8C03_5EA6_5668_95F4_9694_6BEB_79D2 and _____7F13_6B65_521B_5EFA_8C03_5EA6_5668_95F4_9694_6BEB_79D2 or _____6279_6B21_95F4_9694_6BEB_79D2,
        ["已累计毫秒"] = 0,
        ["完成回调"] = _____9009_9879 and _____9009_9879["完成回调"]
    }
    _____786E_4FDD_7F13_6B65_521B_5EFA_8C03_5EA6_5668_5DF2_542F_52A8()
    return _____4EFB_52A1ID
end
____exports["启动世界地图单位缓步创建"] = function(_____914D_7F6E_8868, _____9009_9879)
    _____505C_6B62_6307_5B9A_7F13_6B65_521B_5EFA_4EFB_52A1(_____5F53_524D_9ED8_8BA4_4EFB_52A1ID)
    _____5F53_524D_9ED8_8BA4_4EFB_52A1ID = ____exports["启动世界地图单位缓步创建任务"](_____914D_7F6E_8868, _____9009_9879)
    return ____exports["获取世界地图单位缓步创建状态"]()
end
____exports["停止世界地图单位缓步创建任务"] = function(_____4EFB_52A1ID)
    _____505C_6B62_6307_5B9A_7F13_6B65_521B_5EFA_4EFB_52A1(_____4EFB_52A1ID)
end
____exports["停止世界地图单位缓步创建"] = function()
    _____505C_6B62_6307_5B9A_7F13_6B65_521B_5EFA_4EFB_52A1(_____5F53_524D_9ED8_8BA4_4EFB_52A1ID)
    _____5F53_524D_9ED8_8BA4_4EFB_52A1ID = nil
end
____exports["立即创建世界地图单位"] = function(_____914D_7F6E)
    return _____6267_884C_5355_6761_4E16_754C_5730_56FE_5355_4F4D_521B_5EFA(_____914D_7F6E)
end
local function ____on_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_5EF6_8FDF_56DE_8C03()
    ____exports["初始化世界地图Boss初始注册"]()
    local _____5B8C_6210_56DE_8C03 = _____4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_5B8C_6210_56DE_8C03
    _____4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_5B8C_6210_56DE_8C03 = nil
    if type(_____5B8C_6210_56DE_8C03) == "function" then
        _____5B8C_6210_56DE_8C03()
    end
end
____exports["延迟初始化世界地图Boss初始注册"] = function(_____5B8C_6210_56DE_8C03)
    _____4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_5B8C_6210_56DE_8C03 = _____5B8C_6210_56DE_8C03
    addDelayedCallback(_____4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_5EF6_8FDF_79D2 * 1000, ____on_4E16_754C_5730_56FEBoss_521D_59CB_6CE8_518C_5EF6_8FDF_56DE_8C03)
end
local function _____89E3_6790_533A_57DF_968F_673A_521B_5EFA_5355_4F4DID(_____5355_4F4D_540D)
    local _____603B_8868_53CD_67E5_7ED3_679C = _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D)
    if _____603B_8868_53CD_67E5_7ED3_679C ~= nil and _____603B_8868_53CD_67E5_7ED3_679C ~= "" then
        return _____603B_8868_53CD_67E5_7ED3_679C
    end
    if #_____5355_4F4D_540D >= 4 then
        return __TS__StringSubstring(_____5355_4F4D_540D, 0, 4)
    end
    return nil
end
local function _____6267_884C_5355_6761_4E2D_7ACB_751F_7269_521B_5EFA(_____914D_7F6E)
    local rect = _____83B7_53D6_77E9_5F62_533A_57DF(_____914D_7F6E["矩形区域名称"])
    if rect == nil then
        return 0
    end
    local _____5355_4F4DID = _____89E3_6790_533A_57DF_968F_673A_521B_5EFA_5355_4F4DID(_____914D_7F6E["单位名"])
    if _____5355_4F4DID == nil then
        return 0
    end
    local _____5355_4F4D_7C7B_578BID = stringToFourCC(_____5355_4F4DID)
    local _____73A9_5BB6 = Player(_____914D_7F6E["玩家ID"] or _____4E16_754C_5730_56FE_968F_673A_5355_4F4D_9ED8_8BA4_73A9_5BB6ID)
    local _____671D_5411 = _____914D_7F6E["朝向"] or _____4E16_754C_5730_56FE_968F_673A_5355_4F4D_9ED8_8BA4_671D_5411
    local _____5DF2_521B_5EFA_6570_91CF = 0
    do
        local i = 0
        while i < _____914D_7F6E["创建数量"] do
            local x = _____83B7_53D6_968F_673A_77E9_5F62X(rect)
            local y = _____83B7_53D6_968F_673A_77E9_5F62Y(rect)
            local _____5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                _____73A9_5BB6,
                _____5355_4F4D_7C7B_578BID,
                x,
                y,
                _____671D_5411
            )
            if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 then
                _____5DF2_521B_5EFA_6570_91CF = _____5DF2_521B_5EFA_6570_91CF + 1
            end
            i = i + 1
        end
    end
    return _____5DF2_521B_5EFA_6570_91CF
end
____exports["执行世界地图中立生物创建"] = function(_____914D_7F6E_8868)
    local _____5B9E_9645_914D_7F6E_8868 = _____914D_7F6E_8868 or _____4E16_754C_5730_56FE_4E2D_7ACB_751F_7269_914D_7F6E_8868
    local _____603B_521B_5EFA_6570_91CF = 0
    for ____, _____914D_7F6E in ipairs(_____5B9E_9645_914D_7F6E_8868) do
        _____603B_521B_5EFA_6570_91CF = _____603B_521B_5EFA_6570_91CF + _____6267_884C_5355_6761_4E2D_7ACB_751F_7269_521B_5EFA(_____914D_7F6E)
    end
    return _____603B_521B_5EFA_6570_91CF
end
____exports["初始化世界地图中立生物"] = function()
    return ____exports["执行世界地图中立生物创建"](_____4E16_754C_5730_56FE_4E2D_7ACB_751F_7269_914D_7F6E_8868)
end
local function _____6267_884C_5355_6761_4E16_754C_5730_56FE_690D_7269_5355_4F4D_521B_5EFA(_____914D_7F6E)
    local _____5355_4F4DID = _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____914D_7F6E["单位名"])
    if _____5355_4F4DID == nil or _____5355_4F4DID == "" then
        return nil
    end
    local _____5355_4F4D_7C7B_578BID = stringToFourCC(_____5355_4F4DID)
    local _____671D_5411 = _____914D_7F6E["朝向"] == "随机" and GetRandomDirectionDeg() or (_____914D_7F6E["朝向"] or 0)
    local _____73A9_5BB6 = Player(_____914D_7F6E["玩家ID"] or _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID)
    local _____5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____73A9_5BB6,
        _____5355_4F4D_7C7B_578BID,
        _____914D_7F6E.X,
        _____914D_7F6E.Y,
        _____671D_5411
    )
    if _____5355_4F4D ~= nil and _____914D_7F6E["YD表名"] ~= nil and _____914D_7F6E["YD键名"] ~= nil then
        YDUserDataSetSafe(
            "string",
            _____914D_7F6E["YD表名"],
            _____914D_7F6E["YD键名"],
            "unit",
            _____5355_4F4D
        )
    end
    return _____5355_4F4D
end
local function _____6267_884C_5355_6761_4E16_754C_5730_56FE_690D_7269_968F_673A_7269_54C1_521B_5EFA(_____914D_7F6E)
    local rect = _____83B7_53D6_77E9_5F62_533A_57DF(_____914D_7F6E["矩形区域名称"])
    if rect == nil then
        return 0
    end
    local _____7269_54C1ID = _____89E3_6790_4E16_754C_5730_56FE_7269_54C1ID(_____914D_7F6E["物品名"])
    if _____7269_54C1ID == nil then
        return 0
    end
    local _____7269_54C1_7C7B_578BID = stringToFourCC(_____7269_54C1ID)
    local _____5DF2_521B_5EFA_6570_91CF = 0
    do
        local i = 0
        while i < _____914D_7F6E["创建数量"] do
            local x = _____83B7_53D6_968F_673A_77E9_5F62X(rect)
            local y = _____83B7_53D6_968F_673A_77E9_5F62Y(rect)
            local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(_____7269_54C1_7C7B_578BID, x, y)
            if _____7269_54C1 ~= nil and _____7269_54C1 ~= 0 then
                _____767B_8BB0_91C7_96C6_7269_54C1_5B9E_4F8B(_____7269_54C1, _____7269_54C1_7C7B_578BID, _____914D_7F6E["矩形区域名称"])
                _____5DF2_521B_5EFA_6570_91CF = _____5DF2_521B_5EFA_6570_91CF + 1
            end
            i = i + 1
        end
    end
    return _____5DF2_521B_5EFA_6570_91CF
end
____exports["初始化世界地图植物"] = function()
    local _____603B_521B_5EFA_6570_91CF = 0
    for ____, _____914D_7F6E in ipairs(_____4E16_754C_5730_56FE_690D_7269_5355_4F4D_914D_7F6E_8868) do
        if _____6267_884C_5355_6761_4E16_754C_5730_56FE_690D_7269_5355_4F4D_521B_5EFA(_____914D_7F6E) ~= nil then
            _____603B_521B_5EFA_6570_91CF = _____603B_521B_5EFA_6570_91CF + 1
        end
    end
    for ____, _____914D_7F6E in ipairs(_____4E16_754C_5730_56FE_690D_7269_968F_673A_7269_54C1_914D_7F6E_8868) do
        _____603B_521B_5EFA_6570_91CF = _____603B_521B_5EFA_6570_91CF + _____6267_884C_5355_6761_4E16_754C_5730_56FE_690D_7269_968F_673A_7269_54C1_521B_5EFA(_____914D_7F6E)
    end
    return _____603B_521B_5EFA_6570_91CF
end
local function _____6267_884C_5355_6761_5F02_754C_63CF_8FF0_77F3_521B_5EFA(_____914D_7F6E)
    local _____5355_4F4DID = _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____914D_7F6E["单位名"])
    local _____7269_54C1ID = _____89E3_6790_4E16_754C_5730_56FE_7269_54C1ID(_____914D_7F6E["上架物品名"])
    if _____5355_4F4DID == nil or _____5355_4F4DID == "" or _____7269_54C1ID == nil then
        return nil
    end
    local _____5355_4F4D_7C7B_578BID = stringToFourCC(_____5355_4F4DID)
    local _____7269_54C1_7C7B_578BID = stringToFourCC(_____7269_54C1ID)
    local _____671D_5411 = _____914D_7F6E["朝向"] == "随机" and GetRandomDirectionDeg() or (_____914D_7F6E["朝向"] or 0)
    local _____73A9_5BB6 = Player(_____914D_7F6E["玩家ID"] or _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID)
    local _____5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____73A9_5BB6,
        _____5355_4F4D_7C7B_578BID,
        _____914D_7F6E.X,
        _____914D_7F6E.Y,
        _____671D_5411
    )
    if _____5355_4F4D ~= nil then
        AddItemToStockBJ(_____7269_54C1_7C7B_578BID, _____5355_4F4D, _____914D_7F6E["当前库存"] or 1, _____914D_7F6E["最大库存"] or 1)
    end
    return _____5355_4F4D
end
____exports["初始化世界地图异界描述石"] = function()
    local _____603B_521B_5EFA_6570_91CF = 0
    for ____, _____914D_7F6E in ipairs(_____4E16_754C_5730_56FE_5F02_754C_63CF_8FF0_77F3_914D_7F6E_8868) do
        if _____6267_884C_5355_6761_5F02_754C_63CF_8FF0_77F3_521B_5EFA(_____914D_7F6E) ~= nil then
            _____603B_521B_5EFA_6570_91CF = _____603B_521B_5EFA_6570_91CF + 1
        end
    end
    return _____603B_521B_5EFA_6570_91CF
end
return ____exports
