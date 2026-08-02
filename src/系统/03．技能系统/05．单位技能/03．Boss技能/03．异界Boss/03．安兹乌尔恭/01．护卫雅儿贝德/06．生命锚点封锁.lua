--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____03_FF0E_7279_6548 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____03_FF0E_7279_6548["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____03_FF0E_7279_6548["销毁单位坐标跟随特效"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____10_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.10．台词播放")
local _____64AD_653E_96C5_513F_8D1D_5FB7_53F0_8BCD = ____10_FF0E_53F0_8BCD_64AD_653E["播放雅儿贝德台词"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统")
local _____5F00_59CB_62A4_76FE = ____require_result_0["开始护盾"]
local _____79FB_9664_62A4_76FE = ____require_result_0["移除护盾"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_2.YDWETimerDestroyEffectSafe
local ____require_result_3 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_3["广播单位提示"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____751F_547D_951A_70B9_5C01_9501_9501_94FE_8DDF_968F_952E = "雅儿贝德-生命锚点封锁锁链"
local function _____9009_62E9_672A_6FC0_6D3B_951A_70B9(targets)
    do
        local i = 0
        while i < #targets do
            if _____5355_4F4D_6709_6548(targets[i + 1]["单位"]) and not targets[i + 1]["是否已激活"]() then
                return targets[i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
____exports["启动雅儿贝德生命锚点封锁"] = function(context, targets, durationSeconds)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or state["阶段状态"] == "失衡" or context["挑战已结束"] then
        return nil
    end
    local target = _____9009_62E9_672A_6FC0_6D3B_951A_70B9(targets)
    if target == nil or not (durationSeconds > 0) then
        return nil
    end
    _____64AD_653E_96C5_513F_8D1D_5FB7_53F0_8BCD(albedo, "生命锚点封锁")
    local guardState = state
    local blockTarget = target
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local byAlbedo = GetUnitState(albedo, UNIT_STATE_LIFE) * cfg["守护者模式"]["生命锚点封锁当前生命比例"]
    local byBoss = GetUnitStateJapi(context["安兹单位"], UNIT_STATE_MAX_LIFE) * cfg["守护者模式"]["生命锚点封锁安兹最大生命上限比例"]
    local shieldValue = byAlbedo < byBoss and byAlbedo or byBoss
    if not (shieldValue > 0) then
        return nil
    end
    local unit = blockTarget["单位"]
    local shieldId = 0
    local periodicId = 0
    local cleaned = false
    local function _____7ED3_675F_5C01_9501(_____539F_56E0)
        if _____539F_56E0 == nil then
            _____539F_56E0 = "阶段结束"
        end
        if cleaned then
            return
        end
        cleaned = true
        blockTarget["设置封锁"](false)
        SetUnitInvulnerable(unit, true)
        if periodicId ~= 0 then
            removePeriodicCallback(periodicId)
            periodicId = 0
        end
        local currentShieldId = shieldId
        shieldId = 0
        if currentShieldId ~= 0 and _____539F_56E0 ~= "护盾结束" then
            _____79FB_9664_62A4_76FE(currentShieldId)
        end
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(unit, _____751F_547D_951A_70B9_5C01_9501_9501_94FE_8DDF_968F_952E)
        if _____539F_56E0 == "破碎" then
            local breakEffect = AddSpecialEffect(
                cfg["表现资源"]["雅儿贝德共同护盾破碎特效路径"],
                GetUnitX(unit),
                GetUnitY(unit)
            )
            if breakEffect ~= nil and breakEffect ~= 0 then
                YDWETimerDestroyEffectSafe(1.2, breakEffect)
            end
        end
    end
    local controller = {
        ["是否生效"] = function()
            return not cleaned
        end,
        ["结束"] = _____7ED3_675F_5C01_9501
    }
    local function onShieldBreak()
        shieldId = 0
        _____7ED3_675F_5C01_9501("破碎")
    end
    local function onShieldEnd(_unit, _shieldId, reason)
        shieldId = 0
        if reason ~= "破碎" then
            _____7ED3_675F_5C01_9501("护盾结束")
        end
    end
    local function ____on_5C01_9501_72B6_6001_68C0_67E5()
        if context["挑战已结束"] or not _____5355_4F4D_6709_6548(unit) or not _____5355_4F4D_6709_6548(albedo) or guardState["阶段状态"] == "失衡" or blockTarget["是否已激活"]() then
            _____7ED3_675F_5C01_9501(guardState["阶段状态"] == "失衡" and "雅儿贝德失衡" or "状态失效")
        end
    end
    blockTarget["设置封锁"](true)
    shieldId = _____5F00_59CB_62A4_76FE(unit, {
        ["数值"] = shieldValue,
        ["持续时间"] = durationSeconds,
        ["来源单位"] = albedo,
        ["显示护盾条"] = true,
        ["可驱散"] = false,
        ["标签"] = "雅儿贝德-生命锚点封锁",
        ["溢出处理策略"] = "阻止传递",
        ["破碎回调"] = onShieldBreak,
        ["结束回调"] = onShieldEnd
    })
    if shieldId == 0 then
        _____7ED3_675F_5C01_9501("护盾创建失败")
        return nil
    end
    SetUnitInvulnerable(unit, false)
    _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        unit,
        cfg["表现资源"]["雅儿贝德黑翼拘束锁链特效路径"],
        _____751F_547D_951A_70B9_5C01_9501_9501_94FE_8DDF_968F_952E,
        cfg["守护者模式"]["生命锚点封锁锁链缩放"],
        cfg["守护者模式"]["生命锚点封锁锁链高度"]
    )
    periodicId = addPeriodicCallback(cfg["守护者模式"]["生命锚点封锁状态检查间隔毫秒"], ____on_5C01_9501_72B6_6001_68C0_67E5)
    local ____self_6 = context["清理"]
    ____self_6["登记清理"](
        ____self_6,
        "雅儿贝德-生命锚点封锁",
        function()
            _____7ED3_675F_5C01_9501("挑战清理")
        end
    )
    _____5E7F_64AD_5355_4F4D_63D0_793A(
        context["安兹单位"],
        ("|cffffcc66雅儿贝德封锁了1座未激活生命锚点，并生成持续" .. tostring(durationSeconds)) .. "秒的暗金屏障：击破屏障后才能激活。（多人模式集火破盾，单人模式持续攻击屏障。）|r",
        3600
    )
    return controller
end
____exports["生命锚点封锁技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "阶段机制干扰",
    ["语义"] = "雅儿贝德封锁一个生命锚点，玩家需要使其失衡或绕过防线，但不得永久锁死大招解法。"
}
return ____exports
