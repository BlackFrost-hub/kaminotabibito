local ____lualib = require("lualib_bundle")
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__Delete = ____lualib.__TS__Delete
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local _____6D4B_8BD5_5355_4F4D_5B58_6D3B, ____on_5C01_5370_6280_80FD_5EF6_8FDF_64CD_4F5C, IsUnitAliveBJ, _____65BD_52A0_5FEB_901F_63A7_5236Buff, _____8BFB_53D6_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_8FD0_884C_8BB0_5F55, debugLogForce, GetHandleId, SetUnitPosition, KillUnit, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757, _____6D4B_8BD5_73A9_5BB6_82F1_96C4, _____6D4B_8BD5_76EE_6807_5217_8868, _____6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868
function _____6D4B_8BD5_5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit) == true
end
function ____on_5C01_5370_6280_80FD_5EF6_8FDF_64CD_4F5C(variable)
    local data = variable
    if data == nil then
        return
    end
    local unit = data["单位"]
    if data["操作"] == "硬控" and _____6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) then
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(
            _____6D4B_8BD5_73A9_5BB6_82F1_96C4,
            unit,
            0,
            1,
            "封印守卫战技能测试打断",
            "测试"
        )
    elseif data["操作"] == "移出锚点" and _____6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) then
        SetUnitPosition(unit, _____6D4B_8BD5_4E2D_5FC3X + 900, _____6D4B_8BD5_4E2D_5FC3Y + 900)
    elseif data["操作"] == "击杀" and _____6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) then
        KillUnit(unit)
    elseif data["操作"] == "隐藏英雄目标" then
        _____6D4B_8BD5_76EE_6807_5217_8868 = {}
        _____6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868 = {}
    end
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_8FD0_884C_8BB0_5F55(unit)
    local ____debugLogForce_22 = debugLogForce
    local ____array_21 = __TS__SparseArrayNew(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "延迟分支执行",
        "label=",
        data["标签"],
        "action=",
        data["操作"],
        "unitHid=",
        unit ~= nil and unit ~= 0 and GetHandleId(unit) or 0,
        "recordExists=",
        record ~= nil,
        "chargeId="
    )
    local ____opt_result_15
    if record ~= nil then
        ____opt_result_15 = record["充能ID"]
    end
    local ____opt_result_15_16 = ____opt_result_15
    if ____opt_result_15_16 == nil then
        ____opt_result_15_16 = 0
    end
    __TS__SparseArrayPush(____array_21, ____opt_result_15_16, "anchorSuppressed=")
    local ____opt_result_19
    if record ~= nil then
        ____opt_result_19 = record["正在压制锚点"]
    end
    local ____opt_result_19_20 = ____opt_result_19
    if ____opt_result_19_20 == nil then
        ____opt_result_19_20 = false
    end
    __TS__SparseArrayPush(____array_21, ____opt_result_19_20)
    ____debugLogForce_22(__TS__SparseArraySpread(____array_21))
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_1["是允许测试玩家"]
local ____require_result_2 = require("系统.12．测试系统.00．Boss测试系统.index")
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_2["获取Boss测试玩家基准英雄"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_2["设置Boss测试单位满血"]
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local directRegisterPlayerHero = ____require_result_3.directRegisterPlayerHero
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_4["创建单位并登记排泄安全"]
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_5["立即移除单位并取消排泄登记"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local ____require_result_7 = require("lib.扩展函数.BJ函数.02．单位与英雄")
IsUnitAliveBJ = ____require_result_7.IsUnitAliveBJ
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_8.addDelayedCallback
local removeDelayedCallback = ____require_result_8.removeDelayedCallback
local getServerTime = ____require_result_8.getServerTime
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_9["施加快速控制Buff"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战技能运行时")
local _____542F_52A8_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_6280_80FD = ____require_result_10["启动封印守卫战第三章敌人技能"]
local _____505C_6B62_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_6280_80FD = ____require_result_10["停止封印守卫战第三章敌人技能"]
local _____767B_8BB0_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA = ____require_result_10["登记封印守卫战第三章敌人"]
local _____4EE4_5C01_5370_5B88_536B_6218_654C_4EBA_6280_80FD_7ACB_5373_5C31_7EEA = ____require_result_10["令封印守卫战敌人技能立即就绪"]
_____8BFB_53D6_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_8FD0_884C_8BB0_5F55 = ____require_result_10["读取封印守卫战第三章敌人运行记录"]
local ____require_result_11 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.49．封印守卫战")
local _____5C01_5370_5B88_536B_6218_5355_4EBA_6CE2_6B21_914D_7F6E_8868 = ____require_result_11["封印守卫战单人波次配置表"]
local _____5C01_5370_5B88_536B_6218_6CE2_6B21_914D_7F6E_8868 = ____require_result_11["封印守卫战波次配置表"]
local ____require_result_12 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_12.debugLogForce
local Player = jass.Player
GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
SetUnitPosition = jass.SetUnitPosition
local SetUnitFacing = jass.SetUnitFacing
local ShowUnit = jass.ShowUnit
local PauseUnit = jass.PauseUnit
KillUnit = jass.KillUnit
local UnitDamageTarget = jass.UnitDamageTarget
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
_____6D4B_8BD5_4E2D_5FC3X = -540.6
_____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
_____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757 = "封印守卫战敌人技能测试"
local _____6D4B_8BD5_5355_4F4D_7C7B_578BID = {
    ["失控英灵"] = stringToFourCCSafe("n06B"),
    ["夺灵祭司"] = stringToFourCCSafe("n06A"),
    ["锚蚀兽"] = stringToFourCCSafe("n06C"),
    ["断誓猎手"] = stringToFourCCSafe("n06D"),
    ["黑暗残响"] = stringToFourCCSafe("n069"),
    ["裂誓重卫"] = stringToFourCCSafe("n06E"),
    ["失律号令者"] = stringToFourCCSafe("n06F"),
    ["潮蚀巡鳞者"] = stringToFourCCSafe("n056"),
    ["碎礁投石手"] = stringToFourCCSafe("h00Y"),
    ["灵潮祭司"] = stringToFourCCSafe("n054"),
    ["金鳞执刑官"] = stringToFourCCSafe("n052"),
    ["深渊鳞将"] = stringToFourCCSafe("n055"),
    ["能量核心"] = stringToFourCCSafe("n06G"),
    ["场外白板"] = stringToFourCCSafe("hfoo")
}
local _____6D4B_8BD5_951A_70B9_5217_8868 = {{
    ["编号"] = 1,
    X = _____6D4B_8BD5_4E2D_5FC3X + 420,
    Y = _____6D4B_8BD5_4E2D_5FC3Y,
    ["已完成"] = false,
    ["已压制"] = false
}, {
    ["编号"] = 2,
    X = _____6D4B_8BD5_4E2D_5FC3X - 420,
    Y = _____6D4B_8BD5_4E2D_5FC3Y,
    ["已完成"] = false,
    ["已压制"] = false
}, {
    ["编号"] = 3,
    X = _____6D4B_8BD5_4E2D_5FC3X,
    Y = _____6D4B_8BD5_4E2D_5FC3Y + 420,
    ["已完成"] = false,
    ["已压制"] = false
}}
local _____6D4B_8BD5_5355_4F4D_7F13_5B58 = {}
local _____672C_8F6E_6FC0_6D3B_5355_4F4D_952E_5217_8868 = {}
local _____5F85_53D6_6D88_5EF6_8FDF_56DE_8C03ID_5217_8868 = {}
local _____6D4B_8BD5_6838_5FC3 = nil
_____6D4B_8BD5_73A9_5BB6_82F1_96C4 = nil
_____6D4B_8BD5_76EE_6807_5217_8868 = {}
_____6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868 = {}
local function _____8BFB_53D6_6D4B_8BD5_6838_5FC3()
    return _____6D4B_8BD5_6838_5FC3
end
local function _____8BFB_53D6_6D4B_8BD5_951A_70B9(_____951A_70B9_7F16_53F7)
    return _____6D4B_8BD5_951A_70B9_5217_8868[_____951A_70B9_7F16_53F7]
end
local function _____8BBE_7F6E_6D4B_8BD5_951A_70B9_538B_5236(_____951A_70B9_7F16_53F7, enabled)
    local anchor = _____6D4B_8BD5_951A_70B9_5217_8868[_____951A_70B9_7F16_53F7]
    if anchor == nil then
        return
    end
    anchor["已压制"] = enabled
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "测试锚点压制状态变化",
        "anchorId=",
        _____951A_70B9_7F16_53F7,
        "suppressed=",
        enabled
    )
end
local function _____8BFB_53D6_6D4B_8BD5_76EE_6807_5217_8868()
    return _____6D4B_8BD5_76EE_6807_5217_8868
end
local function _____8BFB_53D6_6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868()
    return _____6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868
end
local _____6D4B_8BD5_6280_80FD_73AF_5883 = {
    ["读取能量核心"] = _____8BFB_53D6_6D4B_8BD5_6838_5FC3,
    ["读取锚点状态"] = _____8BFB_53D6_6D4B_8BD5_951A_70B9,
    ["设置锚点压制"] = _____8BBE_7F6E_6D4B_8BD5_951A_70B9_538B_5236,
    ["读取玩家英雄列表"] = _____8BFB_53D6_6D4B_8BD5_76EE_6807_5217_8868,
    ["读取正在修复锚点的英雄列表"] = _____8BFB_53D6_6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868
}
local function _____53D6_6D88_5168_90E8_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03()
    do
        local i = 0
        while i < #_____5F85_53D6_6D88_5EF6_8FDF_56DE_8C03ID_5217_8868 do
            removeDelayedCallback(_____5F85_53D6_6D88_5EF6_8FDF_56DE_8C03ID_5217_8868[i + 1])
            i = i + 1
        end
    end
    __TS__ArraySetLength(_____5F85_53D6_6D88_5EF6_8FDF_56DE_8C03ID_5217_8868, 0)
end
local function _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(delayMs, data)
    local id = addDelayedCallback(delayMs, ____on_5C01_5370_6280_80FD_5EF6_8FDF_64CD_4F5C, data)
    if id > 0 then
        _____5F85_53D6_6D88_5EF6_8FDF_56DE_8C03ID_5217_8868[#_____5F85_53D6_6D88_5EF6_8FDF_56DE_8C03ID_5217_8868 + 1] = id
    end
    return id
end
local function _____505C_7528_5168_90E8_7F13_5B58_6D4B_8BD5_5355_4F4D()
    __TS__ArraySetLength(_____672C_8F6E_6FC0_6D3B_5355_4F4D_952E_5217_8868, 0)
    for key in pairs(_____6D4B_8BD5_5355_4F4D_7F13_5B58) do
        do
            local unit = _____6D4B_8BD5_5355_4F4D_7F13_5B58[key]
            if not _____6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) then
                goto __continue15
            end
            PauseUnit(unit, true)
            ShowUnit(unit, false)
        end
        ::__continue15::
    end
end
local function _____91CD_7F6E_6D4B_8BD5_951A_70B9()
    do
        local i = 0
        while i < #_____6D4B_8BD5_951A_70B9_5217_8868 do
            _____6D4B_8BD5_951A_70B9_5217_8868[i + 1]["已完成"] = false
            _____6D4B_8BD5_951A_70B9_5217_8868[i + 1]["已压制"] = false
            i = i + 1
        end
    end
end
local function _____83B7_53D6_6216_521B_5EFA_7F13_5B58_6D4B_8BD5_5355_4F4D(_____7C7B_578B, slot)
    if slot == nil then
        slot = 1
    end
    local key = (_____7C7B_578B .. "#") .. tostring(slot)
    local unit = _____6D4B_8BD5_5355_4F4D_7F13_5B58[key]
    if not _____6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) then
        unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
            _____6D4B_8BD5_5355_4F4D_7C7B_578BID[_____7C7B_578B],
            _____6D4B_8BD5_4E2D_5FC3X,
            _____6D4B_8BD5_4E2D_5FC3Y,
            0
        )
        _____6D4B_8BD5_5355_4F4D_7F13_5B58[key] = unit
    end
    return unit
end
local function _____6FC0_6D3B_6D4B_8BD5_5355_4F4D(_____7C7B_578B, x, y, facing, slot, _____662F_5426_767B_8BB0)
    if facing == nil then
        facing = 0
    end
    if slot == nil then
        slot = 1
    end
    if _____662F_5426_767B_8BB0 == nil then
        _____662F_5426_767B_8BB0 = true
    end
    local unit = _____83B7_53D6_6216_521B_5EFA_7F13_5B58_6D4B_8BD5_5355_4F4D(_____7C7B_578B, slot)
    if not _____6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) then
        return nil
    end
    local key = (_____7C7B_578B .. "#") .. tostring(slot)
    _____672C_8F6E_6FC0_6D3B_5355_4F4D_952E_5217_8868[#_____672C_8F6E_6FC0_6D3B_5355_4F4D_952E_5217_8868 + 1] = key
    ShowUnit(unit, true)
    PauseUnit(unit, false)
    SetUnitPosition(unit, x, y)
    SetUnitFacing(unit, facing)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(unit, 100000)
    if _____662F_5426_767B_8BB0 then
        _____767B_8BB0_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA(unit)
        _____4EE4_5C01_5370_5B88_536B_6218_654C_4EBA_6280_80FD_7ACB_5373_5C31_7EEA(unit)
    end
    return unit
end
local function _____786E_4FDD_6D4B_8BD5_6838_5FC3()
    if not _____6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6D4B_8BD5_6838_5FC3) then
        _____6D4B_8BD5_6838_5FC3 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            Player(_____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
            _____6D4B_8BD5_5355_4F4D_7C7B_578BID["能量核心"],
            _____6D4B_8BD5_4E2D_5FC3X,
            _____6D4B_8BD5_4E2D_5FC3Y,
            0
        )
    end
    if _____6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6D4B_8BD5_6838_5FC3) then
        ShowUnit(_____6D4B_8BD5_6838_5FC3, true)
        PauseUnit(_____6D4B_8BD5_6838_5FC3, false)
        SetUnitPosition(_____6D4B_8BD5_6838_5FC3, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(_____6D4B_8BD5_6838_5FC3, 180000)
    end
    return _____6D4B_8BD5_6838_5FC3
end
local function _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player)
    _____53D6_6D88_5168_90E8_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03()
    _____505C_6B62_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_6280_80FD()
    _____505C_7528_5168_90E8_7F13_5B58_6D4B_8BD5_5355_4F4D()
    _____91CD_7F6E_6D4B_8BD5_951A_70B9()
    _____6D4B_8BD5_73A9_5BB6_82F1_96C4 = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not _____6D4B_8BD5_5355_4F4D_5B58_6D3B(_____6D4B_8BD5_73A9_5BB6_82F1_96C4) or not _____6D4B_8BD5_5355_4F4D_5B58_6D3B(_____786E_4FDD_6D4B_8BD5_6838_5FC3()) then
        return false
    end
    directRegisterPlayerHero(player, _____6D4B_8BD5_73A9_5BB6_82F1_96C4)
    SetUnitPosition(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, _____6D4B_8BD5_4E2D_5FC3X - 500, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, 0)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, 100000)
    _____6D4B_8BD5_76EE_6807_5217_8868 = {_____6D4B_8BD5_73A9_5BB6_82F1_96C4}
    _____6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868 = {}
    local started = _____542F_52A8_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_6280_80FD(_____6D4B_8BD5_6280_80FD_73AF_5883)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "测试场准备完成",
        "started=",
        started,
        "heroHid=",
        GetHandleId(_____6D4B_8BD5_73A9_5BB6_82F1_96C4),
        "coreHid=",
        GetHandleId(_____6D4B_8BD5_6838_5FC3),
        "expected=",
        "缓存单位复用，职业运行时和延迟操作可统一清理"
    )
    return started
end
local function _____6E05_7406_5C01_5370_6280_80FD_6D4B_8BD5_573A()
    _____53D6_6D88_5168_90E8_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03()
    _____505C_6B62_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_6280_80FD()
    for key in pairs(_____6D4B_8BD5_5355_4F4D_7F13_5B58) do
        local unit = _____6D4B_8BD5_5355_4F4D_7F13_5B58[key]
        if unit ~= nil and unit ~= 0 then
            _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(unit)
        end
        __TS__Delete(_____6D4B_8BD5_5355_4F4D_7F13_5B58, key)
    end
    if _____6D4B_8BD5_6838_5FC3 ~= nil and _____6D4B_8BD5_6838_5FC3 ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____6D4B_8BD5_6838_5FC3)
    end
    _____6D4B_8BD5_6838_5FC3 = nil
    _____6D4B_8BD5_76EE_6807_5217_8868 = {}
    _____6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868 = {}
    debugLogForce(_____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757, "测试场已清理", "expected=", "敌人、充能、弹幕、锚点压制和号令属性全部清理")
end
local function _____63D0_4EA4_771F_5B9E_666E_653B(source, target, amount)
    if amount == nil then
        amount = 200
    end
    return UnitDamageTarget(
        source,
        target,
        amount,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____6D4B_8BD5_5931_63A7_82F1_7075_6B63_5E38(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local revenant = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失控英灵", _____6D4B_8BD5_4E2D_5FC3X - 180, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    SetUnitPosition(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, _____6D4B_8BD5_4E2D_5FC3X + 80, _____6D4B_8BD5_4E2D_5FC3Y)
    local submitted = _____63D0_4EA4_771F_5B9E_666E_653B(revenant, _____6D4B_8BD5_73A9_5BB6_82F1_96C4)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "失控英灵正常测试",
        "submitted=",
        submitted,
        "expected=",
        "优先追击玩家英雄，真实普攻命中后施加20%移速降低2秒"
    )
end
local function _____6D4B_8BD5_5931_63A7_82F1_7075_56DE_9000_6838_5FC3(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    _____6D4B_8BD5_76EE_6807_5217_8868 = {}
    local revenant = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失控英灵", _____6D4B_8BD5_4E2D_5FC3X - 600, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "失控英灵回退核心",
        "revenantHid=",
        GetHandleId(revenant),
        "expected=",
        "无玩家目标时攻击能量核心"
    )
end
local function _____6D4B_8BD5_5931_63A7_82F1_7075_51CF_901F_51B7_5374(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local revenant = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失控英灵", _____6D4B_8BD5_4E2D_5FC3X - 180, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    local first = _____63D0_4EA4_771F_5B9E_666E_653B(revenant, _____6D4B_8BD5_73A9_5BB6_82F1_96C4)
    local second = _____63D0_4EA4_771F_5B9E_666E_653B(revenant, _____6D4B_8BD5_73A9_5BB6_82F1_96C4)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "失控英灵减速冷却",
        "first=",
        first,
        "second=",
        second,
        "expected=",
        "5秒内第二次命中不重复触发缚魂斩"
    )
end
local function _____6D4B_8BD5_593A_7075_796D_53F8_6B63_5E38(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local anchor = _____6D4B_8BD5_951A_70B9_5217_8868[1]
    local priest = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("夺灵祭司", anchor.X + 40, anchor.Y, 180)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "夺灵祭司正常测试",
        "priestHid=",
        GetHandleId(priest),
        "expected=",
        "头顶2秒充能完成后锚点压制=true并关闭正式光束"
    )
end
local function _____6D4B_8BD5_593A_7075_796D_53F8_786C_63A7_6253_65AD(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local anchor = _____6D4B_8BD5_951A_70B9_5217_8868[1]
    local priest = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("夺灵祭司", anchor.X + 40, anchor.Y, 180)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(500, {["操作"] = "硬控", ["单位"] = priest, ["标签"] = "祭司引导硬控打断"})
    debugLogForce(_____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757, "夺灵祭司硬控打断已提交", "expected=", "进度条清理、锚点不压制、3秒后才可重试")
end
local function _____6D4B_8BD5_593A_7075_796D_53F8_8D8A_754C_6253_65AD(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local anchor = _____6D4B_8BD5_951A_70B9_5217_8868[1]
    local priest = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("夺灵祭司", anchor.X + 40, anchor.Y, 180)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(500, {["操作"] = "移出锚点", ["单位"] = priest, ["标签"] = "祭司引导越界打断"})
    debugLogForce(_____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757, "夺灵祭司越界打断已提交", "expected=", "离开220码后引导中断且锚点不压制")
end
local function _____6D4B_8BD5_593A_7075_796D_53F8_6B7B_4EA1_89E3_538B_5236(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local anchor = _____6D4B_8BD5_951A_70B9_5217_8868[1]
    local priest = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("夺灵祭司", anchor.X + 40, anchor.Y, 180)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(2400, {["操作"] = "击杀", ["单位"] = priest, ["标签"] = "祭司完成压制后死亡"})
    debugLogForce(_____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757, "夺灵祭司死亡解压制已提交", "expected=", "先压制锚点，死亡后压制和法阵立即清除")
end
local function _____6D4B_8BD5_951A_8680_517D_6B63_5E38(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local beast = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("锚蚀兽", _____6D4B_8BD5_4E2D_5FC3X - 120, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "锚蚀兽正常测试",
        "beastHid=",
        GetHandleId(beast),
        "coreLifeBefore=",
        GetUnitState(_____6D4B_8BD5_6838_5FC3, UNIT_STATE_LIFE),
        "expected=",
        "1.4秒充能后自爆，对核心造成2%最大生命+50%攻击力并死亡"
    )
end
local function _____6D4B_8BD5_951A_8680_517D_786C_63A7_6253_65AD(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local beast = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("锚蚀兽", _____6D4B_8BD5_4E2D_5FC3X - 120, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(500, {["操作"] = "硬控", ["单位"] = beast, ["标签"] = "锚蚀兽自爆硬控打断"})
    debugLogForce(_____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757, "锚蚀兽硬控打断已提交", "expected=", "本次不爆炸，1秒后重新进入范围可重试")
end
local function _____6D4B_8BD5_951A_8680_517D_84C4_529B_6B7B_4EA1(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local beast = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("锚蚀兽", _____6D4B_8BD5_4E2D_5FC3X - 120, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(500, {["操作"] = "击杀", ["单位"] = beast, ["标签"] = "锚蚀兽蓄力中死亡"})
    debugLogForce(_____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757, "锚蚀兽蓄力死亡已提交", "expected=", "死亡清理充能且核心不受自爆伤害")
end
local function _____6D4B_8BD5_951A_8680_517D_65E0_89C6_73A9_5BB6(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    SetUnitPosition(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, _____6D4B_8BD5_4E2D_5FC3X - 250, _____6D4B_8BD5_4E2D_5FC3Y)
    local beast = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("锚蚀兽", _____6D4B_8BD5_4E2D_5FC3X - 700, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "锚蚀兽无视玩家",
        "beastHid=",
        GetHandleId(beast),
        "expected=",
        "即使玩家挡路也持续以核心为目标"
    )
end
local function _____8FDE_7EED_63D0_4EA4_730E_624B_666E_653B(hunter, count)
    local submitted = 0
    do
        local i = 0
        while i < count do
            if _____63D0_4EA4_771F_5B9E_666E_653B(hunter, _____6D4B_8BD5_6838_5FC3, 100) then
                submitted = submitted + 1
            end
            i = i + 1
        end
    end
    return submitted
end
local function _____6D4B_8BD5_65AD_8A93_730E_624B_7B2C_56DB_51FB(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local hunter = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("断誓猎手", _____6D4B_8BD5_4E2D_5FC3X + 760, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local before = GetUnitState(_____6D4B_8BD5_6838_5FC3, UNIT_STATE_LIFE)
    local submitted = _____8FDE_7EED_63D0_4EA4_730E_624B_666E_653B(hunter, 4)
    local after = GetUnitState(_____6D4B_8BD5_6838_5FC3, UNIT_STATE_LIFE)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "断誓猎手第四击",
        "submitted=",
        submitted,
        "lifeBefore=",
        before,
        "lifeAfter=",
        after,
        "expected=",
        "第四次伤害为130%，核心生命恢复降低50%持续3秒"
    )
end
local function _____6D4B_8BD5_65AD_8A93_730E_624B_8FD1_8EAB_8F6C_706B(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local hunter = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("断誓猎手", _____6D4B_8BD5_4E2D_5FC3X + 760, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    SetUnitPosition(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, _____6D4B_8BD5_4E2D_5FC3X + 700, _____6D4B_8BD5_4E2D_5FC3Y)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "断誓猎手近身转火",
        "hunterHid=",
        GetHandleId(hunter),
        "expected=",
        "240码内转火玩家，玩家离开后恢复核心射击站位"
    )
end
local function _____6D4B_8BD5_65AD_8A93_730E_624B_5237_65B0_538B_5236(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local hunter = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("断誓猎手", _____6D4B_8BD5_4E2D_5FC3X + 760, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local submitted = _____8FDE_7EED_63D0_4EA4_730E_624B_666E_653B(hunter, 8)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "断誓猎手压制刷新",
        "submitted=",
        submitted,
        "expected=",
        "两次第四击只刷新3秒持续时间，不叠加降低比例"
    )
end
local function _____6D4B_8BD5_9ED1_6697_6B8B_54CD_6B63_5E38(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local echo = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("黑暗残响", _____6D4B_8BD5_4E2D_5FC3X - 260, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    _____6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868 = {_____6D4B_8BD5_73A9_5BB6_82F1_96C4}
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "黑暗残响正常测试",
        "echoHid=",
        GetHandleId(echo),
        "expected=",
        "优先修复英雄，0.6秒充能后发射追踪暗影弹并结算伤害与减速"
    )
end
local function _____6D4B_8BD5_9ED1_6697_6B8B_54CD_786C_63A7_6253_65AD(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local echo = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("黑暗残响", _____6D4B_8BD5_4E2D_5FC3X - 260, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(250, {["操作"] = "硬控", ["单位"] = echo, ["标签"] = "黑暗残响充能硬控打断"})
    debugLogForce(_____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757, "黑暗残响硬控打断已提交", "expected=", "不生成弹幕并进入完整8秒冷却")
end
local function _____6D4B_8BD5_9ED1_6697_6B8B_54CD_76EE_6807_5931_6548(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local dummy = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D(
        "场外白板",
        _____6D4B_8BD5_4E2D_5FC3X + 260,
        _____6D4B_8BD5_4E2D_5FC3Y,
        180,
        1,
        false
    )
    _____6D4B_8BD5_76EE_6807_5217_8868 = {dummy}
    local echo = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("黑暗残响", _____6D4B_8BD5_4E2D_5FC3X - 260, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(250, {["操作"] = "击杀", ["单位"] = dummy, ["标签"] = "黑暗残响目标充能中失效"})
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "黑暗残响目标失效已提交",
        "echoHid=",
        GetHandleId(echo),
        "expected=",
        "目标死亡后中断充能、清理目标引用且不生成弹幕"
    )
end
local function _____6D4B_8BD5_9ED1_6697_6B8B_54CD_56DE_9000_6838_5FC3(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    _____6D4B_8BD5_76EE_6807_5217_8868 = {}
    _____6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868 = {}
    local echo = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("黑暗残响", _____6D4B_8BD5_4E2D_5FC3X - 600, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "黑暗残响回退核心",
        "echoHid=",
        GetHandleId(echo),
        "expected=",
        "无有效玩家英雄时不施放暗影索敌并攻击核心"
    )
end
local function _____6D4B_8BD5_88C2_8A93_91CD_536B_6B63_80CC_9762(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local bulwark = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("裂誓重卫", _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    SetUnitPosition(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, _____6D4B_8BD5_4E2D_5FC3X + 220, _____6D4B_8BD5_4E2D_5FC3Y)
    local front = _____63D0_4EA4_771F_5B9E_666E_653B(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, bulwark, 1000)
    SetUnitPosition(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, _____6D4B_8BD5_4E2D_5FC3X - 220, _____6D4B_8BD5_4E2D_5FC3Y)
    local back = _____63D0_4EA4_771F_5B9E_666E_653B(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, bulwark, 1000)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "裂誓重卫正背面减伤",
        "frontSubmitted=",
        front,
        "backSubmitted=",
        back,
        "expected=",
        "正面120度减伤30%，背面不减伤"
    )
end
local function _____6D4B_8BD5_88C2_8A93_91CD_536B_4FDD_62A4_4E0D_53E0_52A0(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local ally = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失控英灵", _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    local first = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D(
        "裂誓重卫",
        _____6D4B_8BD5_4E2D_5FC3X + 120,
        _____6D4B_8BD5_4E2D_5FC3Y,
        180,
        1
    )
    local second = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D(
        "裂誓重卫",
        _____6D4B_8BD5_4E2D_5FC3X - 120,
        _____6D4B_8BD5_4E2D_5FC3Y,
        0,
        2
    )
    local submitted = _____63D0_4EA4_771F_5B9E_666E_653B(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, ally, 1000)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "裂誓重卫保护不叠加",
        "submitted=",
        submitted,
        "firstHid=",
        GetHandleId(first),
        "secondHid=",
        GetHandleId(second),
        "expected=",
        "友军只获得一次12%减伤，重卫彼此不受保护"
    )
end
local function _____6D4B_8BD5_88C2_8A93_91CD_536B_76FE_51FB(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    SetUnitPosition(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, _____6D4B_8BD5_4E2D_5FC3X + 120, _____6D4B_8BD5_4E2D_5FC3Y)
    local bulwark = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("裂誓重卫", _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "裂誓重卫盾击",
        "bulwarkHid=",
        GetHandleId(bulwark),
        "expected=",
        "220码内触发80%攻击力AOE并击退180，不附加眩晕"
    )
end
local function _____6D4B_8BD5_5931_5F8B_53F7_4EE4_6B63_5E38(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local ally = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失控英灵", _____6D4B_8BD5_4E2D_5FC3X + 180, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local herald = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失律号令者", _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "失律号令正常测试",
        "heraldHid=",
        GetHandleId(herald),
        "allyHid=",
        GetHandleId(ally),
        "expected=",
        "0.8秒充能后550码登记敌人获得移速12%、攻速15%、减伤12%持续6秒"
    )
end
local function _____6D4B_8BD5_5931_5F8B_53F7_4EE4_786C_63A7_6253_65AD(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失控英灵", _____6D4B_8BD5_4E2D_5FC3X + 180, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local herald = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失律号令者", _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(300, {["操作"] = "硬控", ["单位"] = herald, ["标签"] = "失律号令充能硬控打断"})
    debugLogForce(_____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757, "失律号令硬控打断已提交", "expected=", "不施加强化并进入完整10秒冷却")
end
local function _____6D4B_8BD5_5931_5F8B_53F7_4EE4_5237_65B0_4E0D_53E0_52A0(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local ally = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失控英灵", _____6D4B_8BD5_4E2D_5FC3X + 180, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local first = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D(
        "失律号令者",
        _____6D4B_8BD5_4E2D_5FC3X - 100,
        _____6D4B_8BD5_4E2D_5FC3Y,
        0,
        1
    )
    local second = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D(
        "失律号令者",
        _____6D4B_8BD5_4E2D_5FC3X + 100,
        _____6D4B_8BD5_4E2D_5FC3Y,
        180,
        2
    )
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "失律号令刷新不叠加",
        "allyHid=",
        GetHandleId(ally),
        "firstHid=",
        GetHandleId(first),
        "secondHid=",
        GetHandleId(second),
        "expected=",
        "两次号令只刷新持续时间，不重复增加属性和减伤"
    )
end
local function _____6D4B_8BD5_5931_5F8B_53F7_4EE4_4EC5_767B_8BB0_654C_4EBA(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local ally = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失控英灵", _____6D4B_8BD5_4E2D_5FC3X + 180, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local outsider = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D(
        "场外白板",
        _____6D4B_8BD5_4E2D_5FC3X + 220,
        _____6D4B_8BD5_4E2D_5FC3Y,
        180,
        1,
        false
    )
    local herald = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失律号令者", _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "失律号令登记范围",
        "heraldHid=",
        GetHandleId(herald),
        "allyHid=",
        GetHandleId(ally),
        "outsiderHid=",
        GetHandleId(outsider),
        "expected=",
        "只强化守卫战登记敌人，场外白板不受影响"
    )
end
local function _____6D4B_8BD5_4E03_7C7B_654C_4EBA_7EFC_5408AI(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失控英灵", _____6D4B_8BD5_4E2D_5FC3X - 700, _____6D4B_8BD5_4E2D_5FC3Y - 200, 0)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("夺灵祭司", _____6D4B_8BD5_951A_70B9_5217_8868[1].X + 60, _____6D4B_8BD5_951A_70B9_5217_8868[1].Y, 180)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("锚蚀兽", _____6D4B_8BD5_4E2D_5FC3X - 140, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("断誓猎手", _____6D4B_8BD5_4E2D_5FC3X + 760, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("黑暗残响", _____6D4B_8BD5_4E2D_5FC3X - 500, _____6D4B_8BD5_4E2D_5FC3Y + 200, 0)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("裂誓重卫", _____6D4B_8BD5_4E2D_5FC3X + 300, _____6D4B_8BD5_4E2D_5FC3Y - 220, 180)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("失律号令者", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y - 220, 180)
    _____6D4B_8BD5_4FEE_590D_82F1_96C4_5217_8868 = {_____6D4B_8BD5_73A9_5BB6_82F1_96C4}
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "七类敌人综合AI",
        "activeCount=",
        #_____672C_8F6E_6FC0_6D3B_5355_4F4D_952E_5217_8868,
        "expected=",
        "各职业独立执行目标与技能，不再被旧1.8秒核心攻击命令覆盖"
    )
end
local function _____6D4B_8BD5_6F6E_8680_5DE1_9CDE_8005_6B63_5E38(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("潮蚀巡鳞者", _____6D4B_8BD5_4E2D_5FC3X - 900, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "潮蚀巡鳞者潮刃突袭",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "250至650码内出现160x480矩形预警，充能完成后突进并造成120%攻击力伤害和25%减速"
    )
end
local function _____6D4B_8BD5_6F6E_8680_5DE1_9CDE_8005_6253_65AD(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("潮蚀巡鳞者", _____6D4B_8BD5_4E2D_5FC3X - 900, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(250, {["操作"] = "硬控", ["单位"] = unit, ["标签"] = "潮刃突袭充能硬控打断"})
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "潮蚀巡鳞者打断已提交",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "打断后不突进、不结算命中伤害，进度条清理并进入冷却"
    )
end
local function _____6D4B_8BD5_788E_7901_6295_77F3_624B_6B63_5E38(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("碎礁投石手", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "碎礁投石手碎礁投掷",
        "unitHid=",
        GetHandleId(unit),
        "targetX=",
        _____6D4B_8BD5_4E2D_5FC3X - 500,
        "targetY=",
        _____6D4B_8BD5_4E2D_5FC3Y,
        "expected=",
        "最远玩家位置出现220码圆形预警，抛物线投射物抵达锁定目标点后造成145%攻击力伤害和0.5秒硬直"
    )
end
local function _____6D4B_8BD5_788E_7901_6295_77F3_624B_8FD1_8EAB_7981_6B62(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    SetUnitPosition(_____6D4B_8BD5_73A9_5BB6_82F1_96C4, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("碎礁投石手", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "碎礁投石手近身禁止",
        "unitHid=",
        GetHandleId(unit),
        "distance=",
        100,
        "expected=",
        "玩家进入250码内不释放碎礁投掷，继续处理近身目标"
    )
end
local function _____6D4B_8BD5_788E_7901_6295_77F3_624B_5CA9_77F3_5220_9664(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("碎礁投石手", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "碎礁投石手岩石删除检查已提交",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "投射物抵达目标点创建LTcr地形装饰物，1.5秒后自动删除，装饰物不阻挡寻路"
    )
end
local function _____6D4B_8BD5_7075_6F6E_796D_53F8_7977_5370(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("灵潮祭司", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "灵潮祭司灵潮祷印",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "玩家最密集位置出现260码圆形预警和吟唱条，完成后造成130%攻击力伤害并降低30%移速2.5秒"
    )
end
local function _____6D4B_8BD5_7075_6F6E_796D_53F8_7977_5370_6253_65AD(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("灵潮祭司", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(300, {["操作"] = "硬控", ["单位"] = unit, ["标签"] = "灵潮祷印充能硬控打断"})
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "灵潮祭司祷印打断已提交",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "打断后不爆发、不造成伤害，进度条和预警清理并进入冷却"
    )
end
local function _____6D4B_8BD5_7075_6F6E_796D_53F8_62A4_6301(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local ally = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("潮蚀巡鳞者", _____6D4B_8BD5_4E2D_5FC3X - 650, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("灵潮祭司", _____6D4B_8BD5_4E2D_5FC3X - 500, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_8FD0_884C_8BB0_5F55(unit)
    if record ~= nil then
        if record["附加状态"] == nil then
            record["附加状态"] = {}
        end
        record["附加状态"]["灵潮祷印冷却毫秒"] = getServerTime() + 60000
    end
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "灵潮祭司潮蚀护持",
        "unitHid=",
        GetHandleId(unit),
        "allyHid=",
        GetHandleId(ally),
        "expected=",
        "优先连接生命比例最低的精英或普通小怪，创建蓝色细束连线，目标获得25%减伤并每秒恢复0.8%最大生命"
    )
end
local function _____6D4B_8BD5_7075_6F6E_796D_53F8_62A4_6301_65AD_7EBF(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local ally = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("潮蚀巡鳞者", _____6D4B_8BD5_4E2D_5FC3X - 650, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("灵潮祭司", _____6D4B_8BD5_4E2D_5FC3X - 500, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_8FD0_884C_8BB0_5F55(unit)
    if record ~= nil then
        if record["附加状态"] == nil then
            record["附加状态"] = {}
        end
        record["附加状态"]["灵潮祷印冷却毫秒"] = getServerTime() + 60000
    end
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(800, {["操作"] = "移出锚点", ["单位"] = unit, ["标签"] = "潮蚀护持超过700码断线"})
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "灵潮祭司护持断线已提交",
        "unitHid=",
        GetHandleId(unit),
        "allyHid=",
        GetHandleId(ally),
        "expected=",
        "祭司离开目标700码后蓝色连线、减伤Buff和周期治疗清理"
    )
end
local function _____6D4B_8BD5_91D1_9CDE_6267_5211_5B98_51B2_9635(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("金鳞执刑官", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "金鳞执刑官金鳞冲阵",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "出现220x600矩形预警和进度条，冲锋命中造成160%攻击力伤害并击退180码"
    )
end
local function _____6D4B_8BD5_91D1_9CDE_6267_5211_5B98_51B2_9635_6253_65AD(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("金鳞执刑官", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(250, {["操作"] = "硬控", ["单位"] = unit, ["标签"] = "金鳞冲阵充能硬控打断"})
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "金鳞执刑官冲阵打断已提交",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "打断后不冲锋、不造成命中伤害，进度条清理并进入冷却"
    )
end
local function _____6D4B_8BD5_91D1_9CDE_6267_5211_5B98_91CD_9CDE_62A4_4F53(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("金鳞执刑官", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    SetUnitState(
        unit,
        UNIT_STATE_LIFE,
        GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE) * 0.4
    )
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "金鳞执刑官重鳞护体",
        "unitHid=",
        GetHandleId(unit),
        "life=",
        GetUnitState(unit, UNIT_STATE_LIFE),
        "expected=",
        "首次低于50%生命触发一次，获得30%减伤和25%移速降低6秒，结束播放护盾破裂特效"
    )
end
local function _____6D4B_8BD5_6DF1_6E0A_9CDE_5C06_56DE_6F6E(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("深渊鳞将", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "深渊鳞将深渊回潮",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "正面100度、半径500码预警1秒，完成后左中右三道死亡波造成175%攻击力伤害并降低攻速移速30%3秒"
    )
end
local function _____6D4B_8BD5_6DF1_6E0A_9CDE_5C06_6F6E_6C50_7275_5F15(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("深渊鳞将", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_8FD0_884C_8BB0_5F55(unit)
    if record ~= nil then
        if record["附加状态"] == nil then
            record["附加状态"] = {}
        end
        record["附加状态"]["深渊回潮冷却毫秒"] = getServerTime() + 60000
    end
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "深渊鳞将潮汐牵引",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "先出现550码圆形预警和0.8秒进度条，完成后造成70%攻击力伤害并将范围内玩家拉近最多240码"
    )
end
local function _____6D4B_8BD5_6DF1_6E0A_9CDE_5C06_56DE_6F6E_5C01_9501(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    local unit = _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("深渊鳞将", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_7B2C_4E09_7AE0_654C_4EBA_8FD0_884C_8BB0_5F55(unit)
    if record ~= nil then
        if record["附加状态"] == nil then
            record["附加状态"] = {}
        end
        record["附加状态"]["深渊回潮冷却毫秒"] = getServerTime() + 60000
    end
    _____767B_8BB0_5C01_5370_6280_80FD_6D4B_8BD5_5EF6_8FDF_56DE_8C03(1800, {["操作"] = "记录检查", ["单位"] = unit, ["标签"] = "潮汐牵引后检查回潮封锁"})
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "深渊鳞将回潮封锁检查已提交",
        "unitHid=",
        GetHandleId(unit),
        "expected=",
        "潮汐牵引结束后设置回潮封锁毫秒，封锁期间不会立即接深渊回潮"
    )
end
local function _____6D4B_8BD5_4E94_7C7B_654C_4EBA_7EFC_5408AI(player)
    if not _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A(player) then
        return
    end
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("潮蚀巡鳞者", _____6D4B_8BD5_4E2D_5FC3X - 900, _____6D4B_8BD5_4E2D_5FC3Y, 0)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("碎礁投石手", _____6D4B_8BD5_4E2D_5FC3X + 100, _____6D4B_8BD5_4E2D_5FC3Y, 180)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("灵潮祭司", _____6D4B_8BD5_4E2D_5FC3X - 300, _____6D4B_8BD5_4E2D_5FC3Y + 260, 180)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("金鳞执刑官", _____6D4B_8BD5_4E2D_5FC3X + 320, _____6D4B_8BD5_4E2D_5FC3Y - 220, 180)
    _____6FC0_6D3B_6D4B_8BD5_5355_4F4D("深渊鳞将", _____6D4B_8BD5_4E2D_5FC3X + 420, _____6D4B_8BD5_4E2D_5FC3Y + 220, 180)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "五类敌人综合AI",
        "activeCount=",
        #_____672C_8F6E_6FC0_6D3B_5355_4F4D_952E_5217_8868,
        "expected=",
        "五类新单位同时登记后各自执行预警、充能、技能结算和状态清理"
    )
end
local function _____7EDF_8BA1_6CE2_6B21_5355_4F4D_6570_91CF(waves)
    local total = 0
    do
        local i = 0
        while i < #waves do
            local ____opt_23 = waves[i + 1]
            if ____opt_23 ~= nil then
                ____opt_23 = ____opt_23["单位列表"]
            end
            local ____opt_23_25 = ____opt_23
            if ____opt_23_25 == nil then
                ____opt_23_25 = {}
            end
            local units = ____opt_23_25
            do
                local j = 0
                while j < units.length do
                    local ____opt_26 = units[j]
                    if ____opt_26 ~= nil then
                        ____opt_26 = ____opt_26["数量"]
                    end
                    local ____opt_26_28 = ____opt_26
                    if ____opt_26_28 == nil then
                        ____opt_26_28 = 0
                    end
                    total = total + ____opt_26_28
                    j = j + 1
                end
            end
            i = i + 1
        end
    end
    return total
end
local function _____6D4B_8BD5_5355_4EBA_6CE2_6B21_914D_7F6E(_player)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "单人波次配置",
        "waveCount=",
        #_____5C01_5370_5B88_536B_6218_5355_4EBA_6CE2_6B21_914D_7F6E_8868,
        "totalUnits=",
        _____7EDF_8BA1_6CE2_6B21_5355_4F4D_6570_91CF(_____5C01_5370_5B88_536B_6218_5355_4EBA_6CE2_6B21_914D_7F6E_8868),
        "expected=",
        "九波、每批最多一种精英，明显少于多人且避免祭司与锚蚀兽集中叠压"
    )
end
local function _____6D4B_8BD5_591A_4EBA_6CE2_6B21_914D_7F6E(_player)
    debugLogForce(
        _____5C01_5370_6280_80FD_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "多人波次配置",
        "waveCount=",
        #_____5C01_5370_5B88_536B_6218_6CE2_6B21_914D_7F6E_8868,
        "totalUnits=",
        _____7EDF_8BA1_6CE2_6B21_5355_4F4D_6570_91CF(_____5C01_5370_5B88_536B_6218_6CE2_6B21_914D_7F6E_8868),
        "expected=",
        "2人及以上统一使用多人九波配置"
    )
end
local _____5C01_5370_6D4B_8BD5_547D_4EE4_8868 = {
    ["封印测试"] = _____51C6_5907_5C01_5370_6280_80FD_6D4B_8BD5_573A,
    ["封印清理"] = _____6E05_7406_5C01_5370_6280_80FD_6D4B_8BD5_573A,
    ["封印1"] = _____6D4B_8BD5_5931_63A7_82F1_7075_6B63_5E38,
    ["封印1-1"] = _____6D4B_8BD5_5931_63A7_82F1_7075_56DE_9000_6838_5FC3,
    ["封印1-2"] = _____6D4B_8BD5_5931_63A7_82F1_7075_51CF_901F_51B7_5374,
    ["封印2"] = _____6D4B_8BD5_593A_7075_796D_53F8_6B63_5E38,
    ["封印2-1"] = _____6D4B_8BD5_593A_7075_796D_53F8_786C_63A7_6253_65AD,
    ["封印2-2"] = _____6D4B_8BD5_593A_7075_796D_53F8_8D8A_754C_6253_65AD,
    ["封印2-3"] = _____6D4B_8BD5_593A_7075_796D_53F8_6B7B_4EA1_89E3_538B_5236,
    ["封印3"] = _____6D4B_8BD5_951A_8680_517D_6B63_5E38,
    ["封印3-1"] = _____6D4B_8BD5_951A_8680_517D_786C_63A7_6253_65AD,
    ["封印3-2"] = _____6D4B_8BD5_951A_8680_517D_84C4_529B_6B7B_4EA1,
    ["封印3-3"] = _____6D4B_8BD5_951A_8680_517D_65E0_89C6_73A9_5BB6,
    ["封印4"] = _____6D4B_8BD5_65AD_8A93_730E_624B_7B2C_56DB_51FB,
    ["封印4-1"] = _____6D4B_8BD5_65AD_8A93_730E_624B_8FD1_8EAB_8F6C_706B,
    ["封印4-2"] = _____6D4B_8BD5_65AD_8A93_730E_624B_5237_65B0_538B_5236,
    ["封印5"] = _____6D4B_8BD5_9ED1_6697_6B8B_54CD_6B63_5E38,
    ["封印5-1"] = _____6D4B_8BD5_9ED1_6697_6B8B_54CD_786C_63A7_6253_65AD,
    ["封印5-2"] = _____6D4B_8BD5_9ED1_6697_6B8B_54CD_76EE_6807_5931_6548,
    ["封印5-3"] = _____6D4B_8BD5_9ED1_6697_6B8B_54CD_56DE_9000_6838_5FC3,
    ["封印6"] = _____6D4B_8BD5_88C2_8A93_91CD_536B_6B63_80CC_9762,
    ["封印6-1"] = _____6D4B_8BD5_88C2_8A93_91CD_536B_4FDD_62A4_4E0D_53E0_52A0,
    ["封印6-2"] = _____6D4B_8BD5_88C2_8A93_91CD_536B_76FE_51FB,
    ["封印7"] = _____6D4B_8BD5_5931_5F8B_53F7_4EE4_6B63_5E38,
    ["封印7-1"] = _____6D4B_8BD5_5931_5F8B_53F7_4EE4_786C_63A7_6253_65AD,
    ["封印7-2"] = _____6D4B_8BD5_5931_5F8B_53F7_4EE4_5237_65B0_4E0D_53E0_52A0,
    ["封印7-3"] = _____6D4B_8BD5_5931_5F8B_53F7_4EE4_4EC5_767B_8BB0_654C_4EBA,
    ["封印8"] = _____6D4B_8BD5_4E03_7C7B_654C_4EBA_7EFC_5408AI,
    ["封印8-1"] = _____6D4B_8BD5_5355_4EBA_6CE2_6B21_914D_7F6E,
    ["封印8-2"] = _____6D4B_8BD5_591A_4EBA_6CE2_6B21_914D_7F6E,
    ["封印8-3"] = _____6E05_7406_5C01_5370_6280_80FD_6D4B_8BD5_573A,
    ["双灵卫1"] = _____6D4B_8BD5_6F6E_8680_5DE1_9CDE_8005_6B63_5E38,
    ["双灵卫1-1"] = _____6D4B_8BD5_6F6E_8680_5DE1_9CDE_8005_6253_65AD,
    ["双灵卫2"] = _____6D4B_8BD5_788E_7901_6295_77F3_624B_6B63_5E38,
    ["双灵卫2-1"] = _____6D4B_8BD5_788E_7901_6295_77F3_624B_8FD1_8EAB_7981_6B62,
    ["双灵卫2-2"] = _____6D4B_8BD5_788E_7901_6295_77F3_624B_5CA9_77F3_5220_9664,
    ["双灵卫3"] = _____6D4B_8BD5_7075_6F6E_796D_53F8_7977_5370,
    ["双灵卫3-1"] = _____6D4B_8BD5_7075_6F6E_796D_53F8_7977_5370_6253_65AD,
    ["双灵卫3-2"] = _____6D4B_8BD5_7075_6F6E_796D_53F8_62A4_6301,
    ["双灵卫3-3"] = _____6D4B_8BD5_7075_6F6E_796D_53F8_62A4_6301_65AD_7EBF,
    ["双灵卫4"] = _____6D4B_8BD5_91D1_9CDE_6267_5211_5B98_51B2_9635,
    ["双灵卫4-1"] = _____6D4B_8BD5_91D1_9CDE_6267_5211_5B98_51B2_9635_6253_65AD,
    ["双灵卫4-2"] = _____6D4B_8BD5_91D1_9CDE_6267_5211_5B98_91CD_9CDE_62A4_4F53,
    ["双灵卫5"] = _____6D4B_8BD5_6DF1_6E0A_9CDE_5C06_56DE_6F6E,
    ["双灵卫5-1"] = _____6D4B_8BD5_6DF1_6E0A_9CDE_5C06_6F6E_6C50_7275_5F15,
    ["双灵卫5-2"] = _____6D4B_8BD5_6DF1_6E0A_9CDE_5C06_56DE_6F6E_5C01_9501,
    ["双灵卫6"] = _____6D4B_8BD5_4E94_7C7B_654C_4EBA_7EFC_5408AI
}
local _____5C01_5370_6D4B_8BD5_547D_4EE4_5217_8868 = {
    "封印测试",
    "封印清理",
    "封印1",
    "封印1-1",
    "封印1-2",
    "封印2",
    "封印2-1",
    "封印2-2",
    "封印2-3",
    "封印3",
    "封印3-1",
    "封印3-2",
    "封印3-3",
    "封印4",
    "封印4-1",
    "封印4-2",
    "封印5",
    "封印5-1",
    "封印5-2",
    "封印5-3",
    "封印6",
    "封印6-1",
    "封印6-2",
    "封印7",
    "封印7-1",
    "封印7-2",
    "封印7-3",
    "封印8",
    "封印8-1",
    "封印8-2",
    "封印8-3",
    "双灵卫1",
    "双灵卫1-1",
    "双灵卫2",
    "双灵卫2-1",
    "双灵卫2-2",
    "双灵卫3",
    "双灵卫3-1",
    "双灵卫3-2",
    "双灵卫3-3",
    "双灵卫4",
    "双灵卫4-1",
    "双灵卫4-2",
    "双灵卫5",
    "双灵卫5-1",
    "双灵卫5-2",
    "双灵卫6"
}
local function ____on_5C01_5370_5B88_536B_6218_654C_4EBA_6280_80FD_6D4B_8BD5_547D_4EE4(player, command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local execute = _____5C01_5370_6D4B_8BD5_547D_4EE4_8868[command]
    if execute ~= nil then
        execute(player)
    end
end
local function _____6CE8_518C_5C01_5370_5B88_536B_6218_654C_4EBA_6280_80FD_6D4B_8BD5_547D_4EE4()
    do
        local i = 0
        while i < #_____5C01_5370_6D4B_8BD5_547D_4EE4_5217_8868 do
            _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____5C01_5370_6D4B_8BD5_547D_4EE4_5217_8868[i + 1], ____on_5C01_5370_5B88_536B_6218_654C_4EBA_6280_80FD_6D4B_8BD5_547D_4EE4)
            i = i + 1
        end
    end
end
_____6CE8_518C_5C01_5370_5B88_536B_6218_654C_4EBA_6280_80FD_6D4B_8BD5_547D_4EE4()
return ____exports
