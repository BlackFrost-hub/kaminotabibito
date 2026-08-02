local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 跳链 - 单位绑定闪电
-- 
-- 说明：
-- 1. 用于让闪电效果在持续时间内跟随两个单位，而不是只取创建瞬间坐标。
-- 2. 适合跳链、治疗波、生命汲取等“短时单位到单位连线”表现。
-- 3. 这是跳链内部辅助层，不负责查找目标或伤害/治疗结算。
local jass = require("jass.common")
local AddLightningEx = jass.AddLightningEx
local MoveLightningEx = jass.MoveLightningEx
local DestroyLightning = jass.DestroyLightning
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local SetLightningColor = jass.SetLightningColor
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isValidUnit = ____require_result_1.isValidUnit
local _____6D3B_8DC3_5355_4F4D_7ED1_5B9A_95EA_7535 = {}
local _____4E0B_4E00_4E2A_5355_4F4D_7ED1_5B9A_95EA_7535ID = 0
local _____5355_4F4D_7ED1_5B9A_95EA_7535_56DE_8C03ID = 0
local _____5F85_9500_6BC1_7279_6548_5217_8868 = {}
local _____7279_6548_9500_6BC1_56DE_8C03ID = 0
local _____95EA_7535_6700_77ED_6301_7EED_65F6_95F4_79D2 = 0.8
local _____9ED8_8BA4_547D_4E2D_7279_6548_6301_7EED_65F6_95F4_79D2 = 1
local function _____83B7_53D6_95EA_7535_547D_4E2D_7279_6548_6A21_578B(_____6548_679C_4EE3_7801)
    if _____6548_679C_4EE3_7801 == "HWPB" or _____6548_679C_4EE3_7801 == "HWSB" then
        return "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl"
    end
    if _____6548_679C_4EE3_7801 == "DRAB" or _____6548_679C_4EE3_7801 == "DRAL" or _____6548_679C_4EE3_7801 == "DRAM" then
        return "Abilities\\Spells\\Other\\Drain\\DrainTarget.mdl"
    end
    if _____6548_679C_4EE3_7801 == "LEAS" or _____6548_679C_4EE3_7801 == "ROP" then
        return "Abilities\\Spells\\Human\\AerialShackles\\AerialShacklesTarget.mdl"
    end
    if _____6548_679C_4EE3_7801 == "AFOD" then
        return "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl"
    end
    if _____6548_679C_4EE3_7801 == "SPLK" then
        return "Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl"
    end
    if _____6548_679C_4EE3_7801 == "CLPB" or _____6548_679C_4EE3_7801 == "CLSB" or _____6548_679C_4EE3_7801 == "FORK" or _____6548_679C_4EE3_7801 == "CHIM" or _____6548_679C_4EE3_7801 == "MFPB" then
        return "Abilities\\Weapons\\Bolt\\BoltImpact.mdl"
    end
    return "Abilities\\Weapons\\Bolt\\BoltImpact.mdl"
end
local function _____89C4_8303_95EA_7535_6301_7EED_65F6_95F4(_____6301_7EED_65F6_95F4)
    return _____6301_7EED_65F6_95F4 >= _____95EA_7535_6700_77ED_6301_7EED_65F6_95F4_79D2 and _____6301_7EED_65F6_95F4 or _____95EA_7535_6700_77ED_6301_7EED_65F6_95F4_79D2
end
local function ____on_547D_4E2D_7279_6548_9500_6BC1Tick()
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    do
        local i = #_____5F85_9500_6BC1_7279_6548_5217_8868 - 1
        while i >= 0 do
            do
                local _____8BB0_5F55 = _____5F85_9500_6BC1_7279_6548_5217_8868[i + 1]
                if _____5F53_524D_65F6_95F4_6BEB_79D2 < _____8BB0_5F55["到期时间毫秒"] then
                    goto __continue12
                end
                DestroyEffect(_____8BB0_5F55["句柄"])
                __TS__ArraySplice(_____5F85_9500_6BC1_7279_6548_5217_8868, i, 1)
            end
            ::__continue12::
            i = i - 1
        end
    end
    if #_____5F85_9500_6BC1_7279_6548_5217_8868 == 0 and _____7279_6548_9500_6BC1_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____7279_6548_9500_6BC1_56DE_8C03ID)
        _____7279_6548_9500_6BC1_56DE_8C03ID = 0
    end
end
local function _____5B89_6392_547D_4E2D_7279_6548_9500_6BC1(effect, _____6301_7EED_65F6_95F4_79D2)
    if effect == nil or effect == 0 then
        return
    end
    if _____7279_6548_9500_6BC1_56DE_8C03ID == 0 then
        _____7279_6548_9500_6BC1_56DE_8C03ID = addPeriodicCallback(100, ____on_547D_4E2D_7279_6548_9500_6BC1Tick)
    end
    _____5F85_9500_6BC1_7279_6548_5217_8868[#_____5F85_9500_6BC1_7279_6548_5217_8868 + 1] = {
        ["句柄"] = effect,
        ["到期时间毫秒"] = getServerTime() + _____6301_7EED_65F6_95F4_79D2 * 1000
    }
end
local function _____64AD_653E_95EA_7535_547D_4E2D_7279_6548(_____6548_679C_4EE3_7801, _____7EC8_70B9_5355_4F4D)
    if not isValidUnit(_____7EC8_70B9_5355_4F4D) then
        return
    end
    local _____6A21_578B = _____83B7_53D6_95EA_7535_547D_4E2D_7279_6548_6A21_578B(_____6548_679C_4EE3_7801)
    if _____6A21_578B == "" then
        return
    end
    local effect = AddSpecialEffectTarget(_____6A21_578B, _____7EC8_70B9_5355_4F4D, "origin")
    _____5B89_6392_547D_4E2D_7279_6548_9500_6BC1(effect, _____9ED8_8BA4_547D_4E2D_7279_6548_6301_7EED_65F6_95F4_79D2)
end
local function _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535_5B9E_4F8B(_____5B9E_4F8B)
    __TS__Delete(_____6D3B_8DC3_5355_4F4D_7ED1_5B9A_95EA_7535, _____5B9E_4F8B.id)
    if _____5B9E_4F8B["闪电句柄"] ~= nil and _____5B9E_4F8B["闪电句柄"] ~= 0 then
        DestroyLightning(_____5B9E_4F8B["闪电句柄"])
    end
end
local function _____8BA1_7B97_5355_4F4D_7ED1_5B9A_95EA_7535Z(_____5355_4F4D, _____9AD8_5EA6_504F_79FB)
    return GetUnitFlyHeight(_____5355_4F4D) + _____9AD8_5EA6_504F_79FB
end
local function _____66F4_65B0_5355_4F4D_7ED1_5B9A_95EA_7535(_____5B9E_4F8B)
    local _____8D77_70B9_5355_4F4D = _____5B9E_4F8B["起点单位"]
    local _____7EC8_70B9_5355_4F4D = _____5B9E_4F8B["终点单位"]
    if _____5B9E_4F8B["任一死亡时销毁"] then
        if not isValidUnit(_____8D77_70B9_5355_4F4D) or not isValidUnit(_____7EC8_70B9_5355_4F4D) then
            _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535_5B9E_4F8B(_____5B9E_4F8B)
            return false
        end
    else
        if _____8D77_70B9_5355_4F4D == nil or _____8D77_70B9_5355_4F4D == 0 or _____7EC8_70B9_5355_4F4D == nil or _____7EC8_70B9_5355_4F4D == 0 then
            _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535_5B9E_4F8B(_____5B9E_4F8B)
            return false
        end
    end
    MoveLightningEx(
        _____5B9E_4F8B["闪电句柄"],
        false,
        GetUnitX(_____8D77_70B9_5355_4F4D),
        GetUnitY(_____8D77_70B9_5355_4F4D),
        _____8BA1_7B97_5355_4F4D_7ED1_5B9A_95EA_7535Z(_____8D77_70B9_5355_4F4D, _____5B9E_4F8B["起点高度偏移"]),
        GetUnitX(_____7EC8_70B9_5355_4F4D),
        GetUnitY(_____7EC8_70B9_5355_4F4D),
        _____8BA1_7B97_5355_4F4D_7ED1_5B9A_95EA_7535Z(_____7EC8_70B9_5355_4F4D, _____5B9E_4F8B["终点高度偏移"])
    )
    return true
end
local function ____on_5355_4F4D_7ED1_5B9A_95EA_7535Tick()
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____4ECD_6709_6D3B_8DC3_5B9E_4F8B = false
    for _____5B9E_4F8BID_6587_672C in pairs(_____6D3B_8DC3_5355_4F4D_7ED1_5B9A_95EA_7535) do
        do
            local _____5B9E_4F8B = _____6D3B_8DC3_5355_4F4D_7ED1_5B9A_95EA_7535[_____5B9E_4F8BID_6587_672C]
            if _____5B9E_4F8B == nil then
                goto __continue30
            end
            if _____5F53_524D_65F6_95F4_6BEB_79D2 >= _____5B9E_4F8B["到期时间毫秒"] then
                _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535_5B9E_4F8B(_____5B9E_4F8B)
                goto __continue30
            end
            if _____66F4_65B0_5355_4F4D_7ED1_5B9A_95EA_7535(_____5B9E_4F8B) then
                _____4ECD_6709_6D3B_8DC3_5B9E_4F8B = true
            end
        end
        ::__continue30::
    end
    if not _____4ECD_6709_6D3B_8DC3_5B9E_4F8B and _____5355_4F4D_7ED1_5B9A_95EA_7535_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____5355_4F4D_7ED1_5B9A_95EA_7535_56DE_8C03ID)
        _____5355_4F4D_7ED1_5B9A_95EA_7535_56DE_8C03ID = 0
    end
end
local function _____786E_4FDD_5355_4F4D_7ED1_5B9A_95EA_7535Tick_5DF2_542F_52A8()
    if _____5355_4F4D_7ED1_5B9A_95EA_7535_56DE_8C03ID ~= 0 then
        return
    end
    _____5355_4F4D_7ED1_5B9A_95EA_7535_56DE_8C03ID = addPeriodicCallback(20, ____on_5355_4F4D_7ED1_5B9A_95EA_7535Tick)
end
____exports["创建单位绑定闪电"] = function(_____53C2_6570)
    if _____53C2_6570["效果代码"] == nil or _____53C2_6570["效果代码"] == "" then
        return nil
    end
    if _____53C2_6570["起点单位"] == nil or _____53C2_6570["起点单位"] == 0 then
        return nil
    end
    if _____53C2_6570["终点单位"] == nil or _____53C2_6570["终点单位"] == 0 then
        return nil
    end
    if _____53C2_6570["持续时间"] <= 0 then
        return nil
    end
    if not isValidUnit(_____53C2_6570["起点单位"]) or not isValidUnit(_____53C2_6570["终点单位"]) then
        return nil
    end
    local _____6301_7EED_65F6_95F4_79D2 = _____89C4_8303_95EA_7535_6301_7EED_65F6_95F4(_____53C2_6570["持续时间"])
    local _____8D77_70B9_9AD8_5EA6_504F_79FB = _____53C2_6570["起点高度偏移"] or 60
    local _____7EC8_70B9_9AD8_5EA6_504F_79FB = _____53C2_6570["终点高度偏移"] or 60
    local _____95EA_7535_53E5_67C4 = AddLightningEx(
        _____53C2_6570["效果代码"],
        false,
        GetUnitX(_____53C2_6570["起点单位"]),
        GetUnitY(_____53C2_6570["起点单位"]),
        _____8BA1_7B97_5355_4F4D_7ED1_5B9A_95EA_7535Z(_____53C2_6570["起点单位"], _____8D77_70B9_9AD8_5EA6_504F_79FB),
        GetUnitX(_____53C2_6570["终点单位"]),
        GetUnitY(_____53C2_6570["终点单位"]),
        _____8BA1_7B97_5355_4F4D_7ED1_5B9A_95EA_7535Z(_____53C2_6570["终点单位"], _____7EC8_70B9_9AD8_5EA6_504F_79FB)
    )
    if _____95EA_7535_53E5_67C4 == nil or _____95EA_7535_53E5_67C4 == 0 then
        return nil
    end
    local _____989C_8272 = _____53C2_6570["颜色"]
    if _____989C_8272 ~= nil then
        SetLightningColor(
            _____95EA_7535_53E5_67C4,
            _____989C_8272.r,
            _____989C_8272.g,
            _____989C_8272.b,
            _____989C_8272.a
        )
    end
    _____64AD_653E_95EA_7535_547D_4E2D_7279_6548(_____53C2_6570["效果代码"], _____53C2_6570["终点单位"])
    _____4E0B_4E00_4E2A_5355_4F4D_7ED1_5B9A_95EA_7535ID = _____4E0B_4E00_4E2A_5355_4F4D_7ED1_5B9A_95EA_7535ID + 1
    local _____5B9E_4F8B = {
        id = _____4E0B_4E00_4E2A_5355_4F4D_7ED1_5B9A_95EA_7535ID,
        ["闪电句柄"] = _____95EA_7535_53E5_67C4,
        ["起点单位"] = _____53C2_6570["起点单位"],
        ["终点单位"] = _____53C2_6570["终点单位"],
        ["起点高度偏移"] = _____8D77_70B9_9AD8_5EA6_504F_79FB,
        ["终点高度偏移"] = _____7EC8_70B9_9AD8_5EA6_504F_79FB,
        ["到期时间毫秒"] = getServerTime() + _____6301_7EED_65F6_95F4_79D2 * 1000,
        ["任一死亡时销毁"] = _____53C2_6570["任一死亡时销毁"] ~= false
    }
    _____6D3B_8DC3_5355_4F4D_7ED1_5B9A_95EA_7535[_____5B9E_4F8B.id] = _____5B9E_4F8B
    _____786E_4FDD_5355_4F4D_7ED1_5B9A_95EA_7535Tick_5DF2_542F_52A8()
    return _____95EA_7535_53E5_67C4
end
____exports["销毁单位绑定闪电"] = function(_____95EA_7535_53E5_67C4)
    if _____95EA_7535_53E5_67C4 == nil or _____95EA_7535_53E5_67C4 == 0 then
        return
    end
    for _____5B9E_4F8BID_6587_672C in pairs(_____6D3B_8DC3_5355_4F4D_7ED1_5B9A_95EA_7535) do
        do
            local _____5B9E_4F8B = _____6D3B_8DC3_5355_4F4D_7ED1_5B9A_95EA_7535[_____5B9E_4F8BID_6587_672C]
            if _____5B9E_4F8B == nil or _____5B9E_4F8B["闪电句柄"] ~= _____95EA_7535_53E5_67C4 then
                goto __continue48
            end
            _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535_5B9E_4F8B(_____5B9E_4F8B)
            return
        end
        ::__continue48::
    end
end
return ____exports
