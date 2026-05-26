--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_6838_5FC3_903B_8F91 = require("系统.03．技能系统.07．动态技能文本.03．核心逻辑")
local _____6062_590D_82F1_96C4_6280_80FD_539F_59CB_6587_672C = ____03_FF0E_6838_5FC3_903B_8F91["恢复英雄技能原始文本"]
local _____68C0_67E5_82F1_96C4_6280_80FD = ____03_FF0E_6838_5FC3_903B_8F91["检查英雄技能"]
--- 动态技能文本系统 - 入口与导出
-- 
-- 改为和冷却/蓝耗一致的本地选中驱动：
-- - 只处理本地玩家当前唯一选中的已注册英雄
-- - 不再轮询所有已注册英雄
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照")
local _____529F_80FD_5F00_5173_6A21_5757 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关")
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_1.debugLog
local MODULE_NAME = "动态技能文本"
local REFRESH_MS = 300
local initialized = false
local _____5F53_524D_751F_6548_82F1_96C4 = nil
local _____5F53_524D_5FEB_7167_7B7E_540D = ""
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
            local ____temp_2
            if abilityId ~= 0 then
                ____temp_2 = jass.GetUnitAbilityLevel(hero, abilityId)
            else
                ____temp_2 = 0
            end
            local level = ____temp_2
            _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868 + 1] = (((_____70ED_952E .. "=") .. tostring(abilityId)) .. ":") .. tostring(level)
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
local function onTick()
    local _____5DF2_5F00_542F = _____529F_80FD_5F00_5173_6A21_5757["本地玩家是否开启动态技能文本"]()
    local _____5DF2_5F00_542F_3
    if _____5DF2_5F00_542F then
        _____5DF2_5F00_542F_3 = _____83B7_53D6_672C_5730_5F53_524D_9009_4E2D_82F1_96C4()
    else
        _____5DF2_5F00_542F_3 = nil
    end
    local localHero = _____5DF2_5F00_542F_3
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
    if nextSignature == _____5F53_524D_5FEB_7167_7B7E_540D then
        return
    end
    _____5F53_524D_5FEB_7167_7B7E_540D = nextSignature
    _____68C0_67E5_82F1_96C4_6280_80FD(_____5F53_524D_751F_6548_82F1_96C4)
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
    addPeriodicCallback(REFRESH_MS, onTick)
    debugLog(nil, MODULE_NAME, "初始化动态技能文本系统")
end
function ____exports.restoreDynamicSkillTextCurrentHero()
    _____6062_590D_5F53_524D_751F_6548_82F1_96C4()
end
return ____exports
