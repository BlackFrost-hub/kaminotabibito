local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____03_FF0E_6838_5FC3_903B_8F91 = require("系统.03．技能系统.07．动态技能文本.03．核心逻辑")
local _____68C0_67E5_82F1_96C4_6280_80FD = ____03_FF0E_6838_5FC3_903B_8F91["检查英雄技能"]
--- 动态技能文本系统 - 入口与导出
-- 
-- 功能：动态修改技能提示扩展文本
-- - 将描述中的公式替换为实际伤害数值
-- - 例如"智力×3"替换为实际智力×3的数值
-- - 支持：攻击力、最大生命值、当前生命值、智力、敏捷、力量的倍率公式
local _____5E73_53F0_6269_5C55_53D6_503C = require("平台扩展API.取值")
local _____5F53_524D_9009_62E9_7684_5355_4F4D_5F02_6B65 = _____5E73_53F0_6269_5C55_53D6_503C["当前选择的单位异步"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_1.debugLog
local MODULE_NAME = "动态技能文本"
local REFRESH_MS = 500
local registeredHeroes = __TS__New(Set)
local initialized = false
local function isValidHandle(handle)
    return handle ~= nil and handle ~= 0
end
local function onTick()
    local unit = _____5F53_524D_9009_62E9_7684_5355_4F4D_5F02_6B65()
    if not isValidHandle(unit) then
        return
    end
    if not registeredHeroes:has(unit) then
        return
    end
    _____68C0_67E5_82F1_96C4_6280_80FD(unit)
end
function ____exports.registerDynamicSkillTextHero(whichHero)
    if not isValidHandle(whichHero) then
        return
    end
    if registeredHeroes:has(whichHero) then
        return
    end
    registeredHeroes:add(whichHero)
    debugLog(nil, MODULE_NAME, "注册英雄用于动态文本")
    _____68C0_67E5_82F1_96C4_6280_80FD(whichHero)
end
function ____exports.initDynamicSkillTextSystem()
    if initialized then
        return
    end
    initialized = true
    addPeriodicCallback(REFRESH_MS, onTick)
    debugLog(nil, MODULE_NAME, "初始化动态技能文本系统")
end
return ____exports
