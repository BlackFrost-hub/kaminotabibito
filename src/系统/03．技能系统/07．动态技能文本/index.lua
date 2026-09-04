--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_516C_5F0F_914D_7F6E = require("系统.03．技能系统.07．动态技能文本.01．公式配置")
local _____52A8_6001_6587_672C_767D_540D_5355 = ____01_FF0E_516C_5F0F_914D_7F6E["动态文本白名单"]
local ____02_FF0E_5C5E_6027_8BA1_7B97 = require("系统.03．技能系统.07．动态技能文本.02．属性计算")
local _____83B7_53D6_5C5E_6027_503C = ____02_FF0E_5C5E_6027_8BA1_7B97["获取属性值"]
local ____03_FF0E_6838_5FC3_903B_8F91 = require("系统.03．技能系统.07．动态技能文本.03．核心逻辑")
local _____6062_590D_82F1_96C4_6280_80FD_539F_59CB_6587_672C = ____03_FF0E_6838_5FC3_903B_8F91["恢复英雄技能原始文本"]
local _____68C0_67E5_82F1_96C4_6280_80FD = ____03_FF0E_6838_5FC3_903B_8F91["检查英雄技能"]
local _____540C_6B65_5237_65B0_82F1_96C4_6280_80FD_754C_9762 = ____03_FF0E_6838_5FC3_903B_8F91["同步刷新英雄技能界面"]
local _____540C_6B65_5237_65B0_82F1_96C4_6280_80FD_539F_59CB_754C_9762 = ____03_FF0E_6838_5FC3_903B_8F91["同步刷新英雄技能原始界面"]
local ____05_FF0E_6280_80FD_63D0_793AUI = require("系统.03．技能系统.07．动态技能文本.05．技能提示UI")
local _____521D_59CB_5316_6280_80FD_63D0_793AUI = ____05_FF0E_6280_80FD_63D0_793AUI["初始化技能提示UI"]
--- 动态技能文本系统 - 入口与导出
-- 
-- 改为和冷却/蓝耗一致的本地选中驱动：
-- - 只处理本地玩家当前唯一选中的已注册英雄
-- - 不再轮询所有已注册英雄
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local syncHardwareInput = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local ____require_result_1 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____require_result_1.KEY_STATE
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照")
local _____529F_80FD_5F00_5173_6A21_5757 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关")
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_3.debugLog
local MODULE_NAME = "动态技能文本"
local REFRESH_MS = 300
local ALT_KEY_CODE = 18
local initialized = false
local _____5F53_524D_751F_6548_82F1_96C4 = nil
local _____5F53_524D_5FEB_7167_7B7E_540D = ""
local ____Alt_540C_6B65_6309_4E0B = false
local function isValidHandle(handle)
    return handle ~= nil and handle ~= 0
end
local function _____83B7_53D6_672C_5730_5F53_524D_9009_4E2D_82F1_96C4()
    return selectionSnapshotSystem["获取本地选中技能快照"]().hero
end
local function _____6784_5EFA_52A8_6001_6587_672C_5FEB_7167_7B7E_540D(hero)
    if not isValidHandle(hero) then
        return ""
    end
    local _____547D_4EE4_5361_5FEB_7167 = selectionSnapshotSystem["获取本地选中技能快照"]()
    local _____7247_6BB5_5217_8868 = {}
    _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868 + 1] = "hero=" .. tostring(hero)
    local _____6280_80FD_70ED_952E_5217_8868 = {
        "Q",
        "W",
        "E",
        "R",
        "D"
    }
    do
        local i = 0
        while i < #_____6280_80FD_70ED_952E_5217_8868 do
            local _____70ED_952E = _____6280_80FD_70ED_952E_5217_8868[i + 1]
            local abilityId = _____547D_4EE4_5361_5FEB_7167.skills[_____70ED_952E] or 0
            local ____temp_4
            if abilityId ~= 0 then
                ____temp_4 = jass.GetUnitAbilityLevel(hero, abilityId)
            else
                ____temp_4 = 0
            end
            local level = ____temp_4
            _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868 + 1] = (((_____70ED_952E .. "=") .. tostring(abilityId)) .. ":") .. tostring(level)
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #_____52A8_6001_6587_672C_767D_540D_5355 do
            local _____5C5E_6027_540D = _____52A8_6001_6587_672C_767D_540D_5355[i + 1]
            local _____5C5E_6027_503C = _____83B7_53D6_5C5E_6027_503C(hero, _____5C5E_6027_540D)
            _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868 + 1] = (("attr:" .. _____5C5E_6027_540D) .. "=") .. tostring(_____5C5E_6027_503C)
            i = i + 1
        end
    end
    return table.concat(_____7247_6BB5_5217_8868, "|")
end
local function _____6062_590D_5F53_524D_751F_6548_82F1_96C4()
    if not isValidHandle(_____5F53_524D_751F_6548_82F1_96C4) then
        _____5F53_524D_751F_6548_82F1_96C4 = nil
        _____5F53_524D_5FEB_7167_7B7E_540D = ""
        return
    end
    _____6062_590D_82F1_96C4_6280_80FD_539F_59CB_6587_672C(_____5F53_524D_751F_6548_82F1_96C4)
    _____5F53_524D_751F_6548_82F1_96C4 = nil
    _____5F53_524D_5FEB_7167_7B7E_540D = ""
end
local function _____5904_7406_540C_6B65Alt_6309_4E0B(event)
    if ____Alt_540C_6B65_6309_4E0B then
        return
    end
    local ____temp_5
    if event ~= nil then
        ____temp_5 = event.player
    else
        ____temp_5 = nil
    end
    local player = ____temp_5
    local hero = getRegisteredPlayerHero(player)
    if not isValidHandle(hero) then
        return
    end
    ____Alt_540C_6B65_6309_4E0B = true
    _____540C_6B65_5237_65B0_82F1_96C4_6280_80FD_539F_59CB_754C_9762(hero)
end
local function _____5904_7406_540C_6B65Alt_677E_5F00(event)
    if not ____Alt_540C_6B65_6309_4E0B then
        return
    end
    local ____temp_6
    if event ~= nil then
        ____temp_6 = event.player
    else
        ____temp_6 = nil
    end
    local player = ____temp_6
    local hero = getRegisteredPlayerHero(player)
    if not isValidHandle(hero) then
        return
    end
    ____Alt_540C_6B65_6309_4E0B = false
    _____540C_6B65_5237_65B0_82F1_96C4_6280_80FD_754C_9762(hero)
end
local function onTick()
    local _____5DF2_5F00_542F = _____529F_80FD_5F00_5173_6A21_5757["本地玩家是否开启动态技能文本"]()
    local _____5DF2_5F00_542F_7
    if _____5DF2_5F00_542F then
        _____5DF2_5F00_542F_7 = _____83B7_53D6_672C_5730_5F53_524D_9009_4E2D_82F1_96C4()
    else
        _____5DF2_5F00_542F_7 = nil
    end
    local localHero = _____5DF2_5F00_542F_7
    if _____5F53_524D_751F_6548_82F1_96C4 ~= localHero then
        if isValidHandle(_____5F53_524D_751F_6548_82F1_96C4) then
            _____6062_590D_82F1_96C4_6280_80FD_539F_59CB_6587_672C(_____5F53_524D_751F_6548_82F1_96C4)
        end
        _____5F53_524D_751F_6548_82F1_96C4 = localHero
        _____5F53_524D_5FEB_7167_7B7E_540D = ""
    end
    if not isValidHandle(_____5F53_524D_751F_6548_82F1_96C4) then
        return
    end
    if not _____5DF2_5F00_542F then
        return
    end
    local nextSignature = _____6784_5EFA_52A8_6001_6587_672C_5FEB_7167_7B7E_540D(_____5F53_524D_751F_6548_82F1_96C4)
    if nextSignature ~= _____5F53_524D_5FEB_7167_7B7E_540D then
        _____5F53_524D_5FEB_7167_7B7E_540D = nextSignature
        _____68C0_67E5_82F1_96C4_6280_80FD(_____5F53_524D_751F_6548_82F1_96C4)
    end
end
function ____exports.registerDynamicSkillTextHero(whichHero)
    if not isValidHandle(whichHero) then
        return
    end
    debugLog(nil, MODULE_NAME, "注册英雄用于动态文本")
end
function ____exports.initDynamicSkillTextSystem()
    if initialized then
        return
    end
    initialized = true
    selectionSnapshotSystem["初始化本地选中技能快照"]()
    _____521D_59CB_5316_6280_80FD_63D0_793AUI()
    addPeriodicCallback(REFRESH_MS, onTick)
    syncHardwareInput.registerSyncHardwareKey(ALT_KEY_CODE, KEY_STATE.DOWN, _____5904_7406_540C_6B65Alt_6309_4E0B)
    syncHardwareInput.registerSyncHardwareKey(ALT_KEY_CODE, KEY_STATE.UP, _____5904_7406_540C_6B65Alt_677E_5F00)
    debugLog(nil, MODULE_NAME, "初始化动态技能文本系统")
end
function ____exports.restoreDynamicSkillTextCurrentHero()
    _____6062_590D_5F53_524D_751F_6548_82F1_96C4()
end
return ____exports
