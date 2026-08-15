--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00．配置")
local _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["铃仙单位技能配置"]
local ____12_FF0E_94C3_4ED9 = require("系统.05．Buff系统.03．Buff表.02．英雄.12．铃仙")
local _____94C3_4ED9BuffID = ____12_FF0E_94C3_4ED9["铃仙BuffID"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00A．表现工具")
local _____64AD_653E_94C3_4ED9_5168_5C40_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放铃仙全局音效"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00B．分身与状态管理")
local _____662F_94C3_4ED9_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是铃仙本体"]
local _____662F_94C3_4ED9_5206_8EAB = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是铃仙分身"]
local _____6CE8_518C_94C3_4ED9_82F1_96C4 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["注册铃仙英雄"]
local _____52A0_5165_94C3_4ED9_5206_8EAB = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["加入铃仙分身"]
local _____79FB_9664_94C3_4ED9_5206_8EAB = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["移除铃仙分身"]
local _____83B7_53D6_94C3_4ED9_5206_8EAB_7EC4 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["获取铃仙分身组"]
local _____94C3_4ED9_5206_8EAB_6570_91CF = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["铃仙分身数量"]
local _____662F_6709_6548_654C_5BF9_76EE_6807 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是有效敌对目标"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.09．单位召唤事件中心")
local _____6CE8_518C_53EC_5524_76D1_542C = ____require_result_2["注册召唤监听"]
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local addSelectionListener = ____require_result_4.addSelectionListener
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setItemIllusion = ____require_result_5.SFB_setItemIllusion
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_6.addDelayedCallback
local removeDelayedCallback = ____require_result_6.removeDelayedCallback
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local createTimedUnitEffect = ____require_result_7.createTimedUnitEffect
local ____require_result_8 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitVertexColorBJ = ____require_result_8.SetUnitVertexColorBJ
local ____require_result_9 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_9.SelectUnitForPlayerSingle
local ____require_result_10 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_10.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_10["移除单位指定Buff"]
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_11.getUnitsInRange
local ____W_6280_80FDID = stringToFourCCSafe(_____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"])
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local ShowUnit = jass.ShowUnit
local KillUnit = jass.KillUnit
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____94C3_4ED9W_4F1A_8BDD_8868 = {}
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD)
end
--- 在分身位置播一次性消失特效（源 JASS：Create+Destroy 特效）
local function _____64AD_653E_5206_8EAB_6D88_5931_7279_6548(_____5206_8EAB)
    if _____5206_8EAB == nil or _____5206_8EAB == 0 then
        return
    end
    local x = GetUnitX(_____5206_8EAB)
    local y = GetUnitY(_____5206_8EAB)
    local cfg = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E.W
    DestroyEffect(AddSpecialEffect(cfg["分身消失特效1"], x, y))
    DestroyEffect(AddSpecialEffect(cfg["分身消失特效2"], x, y))
end
--- 在未结束的 W 会话的分身组里查找单位所属会话（已出现/本体已死的会话跳过）
local function _____67E5_627E_5355_4F4D_6240_5C5E_4F1A_8BDD(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    for key in pairs(_____94C3_4ED9W_4F1A_8BDD_8868) do
        do
            local _____4F1A_8BDD = _____94C3_4ED9W_4F1A_8BDD_8868[key]
            if _____4F1A_8BDD == nil or _____4F1A_8BDD["是否出现"] then
                goto __continue7
            end
            if not _____5355_4F4D_5B58_6D3B(_____4F1A_8BDD["英雄"]) then
                goto __continue7
            end
            local _____5206_8EAB_7EC4 = _____83B7_53D6_94C3_4ED9_5206_8EAB_7EC4(_____4F1A_8BDD["英雄"])
            do
                local i = 0
                while i < #_____5206_8EAB_7EC4 do
                    if _____5206_8EAB_7EC4[i + 1] == _____5355_4F4D then
                        return _____4F1A_8BDD
                    end
                    i = i + 1
                end
            end
        end
        ::__continue7::
    end
    return nil
end
--- 执行“铃仙出现”的表现（ShowUnit + 传送 + 朝向 + 顶点色 + Whine 特效）
local function _____6267_884C_94C3_4ED9_51FA_73B0_8868_73B0(_____82F1_96C4, _____51FA_73B0X, _____51FA_73B0Y, _____671D_5411)
    if not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        return
    end
    local cfg = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E.W
    ShowUnit(_____82F1_96C4, true)
    SetUnitX(_____82F1_96C4, _____51FA_73B0X)
    SetUnitY(_____82F1_96C4, _____51FA_73B0Y)
    if _____671D_5411 ~= nil then
        SetUnitFacing(_____82F1_96C4, _____671D_5411)
    end
    SetUnitVertexColorBJ(
        _____82F1_96C4,
        cfg["出现顶点色红"],
        cfg["出现顶点色绿"],
        cfg["出现顶点色蓝"],
        0
    )
    createTimedUnitEffect(_____82F1_96C4, "origin", cfg["出现特效模型"], 1)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____94C3_4ED9BuffID["W替身"])
end
--- 结束会话：取消超时计时器、重新选中本体、从表中移除
local function _____5B8C_6210_4F1A_8BDD(_____4F1A_8BDD)
    if _____4F1A_8BDD == nil then
        return
    end
    if _____4F1A_8BDD["超时计时器ID"] ~= 0 then
        removeDelayedCallback(_____4F1A_8BDD["超时计时器ID"])
        _____4F1A_8BDD["超时计时器ID"] = 0
    end
    if _____5355_4F4D_5B58_6D3B(_____4F1A_8BDD["英雄"]) then
        SelectUnitForPlayerSingle(
            _____4F1A_8BDD["英雄"],
            GetOwningPlayer(_____4F1A_8BDD["英雄"])
        )
    end
    _____94C3_4ED9W_4F1A_8BDD_8868[GetHandleId(_____4F1A_8BDD["英雄"])] = nil
end
--- 铃仙出现（统一入口，仅未出现时生效）
local function _____94C3_4ED9_51FA_73B0(_____4F1A_8BDD, _____51FA_73B0X, _____51FA_73B0Y, _____671D_5411)
    if _____4F1A_8BDD == nil or _____4F1A_8BDD["是否出现"] then
        return
    end
    _____4F1A_8BDD["是否出现"] = true
    _____6267_884C_94C3_4ED9_51FA_73B0_8868_73B0(_____4F1A_8BDD["英雄"], _____51FA_73B0X, _____51FA_73B0Y, _____671D_5411)
    _____5B8C_6210_4F1A_8BDD(_____4F1A_8BDD)
end
--- 铃仙原地出现（全灭 / 超时路径，本体位置未变无需传送）
local function _____94C3_4ED9_539F_5730_51FA_73B0(_____4F1A_8BDD)
    if _____4F1A_8BDD == nil then
        return
    end
    _____94C3_4ED9_51FA_73B0(_____4F1A_8BDD, _____4F1A_8BDD["原X"], _____4F1A_8BDD["原Y"])
end
--- 选中一个分身：铃仙传送到分身位置出现，分身带消失特效后移除
local function _____94C3_4ED9_5206_8EAB_4F20_9001_51FA_73B0(_____4F1A_8BDD, _____5206_8EAB)
    if _____4F1A_8BDD == nil or _____4F1A_8BDD["是否出现"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(_____4F1A_8BDD["英雄"]) then
        return
    end
    local _____5206_8EABX = GetUnitX(_____5206_8EAB)
    local _____5206_8EABY = GetUnitY(_____5206_8EAB)
    local _____671D_5411 = GetUnitFacing(_____5206_8EAB)
    _____4F1A_8BDD["是否出现"] = true
    local _____5206_8EAB_7EC4 = _____83B7_53D6_94C3_4ED9_5206_8EAB_7EC4(_____4F1A_8BDD["英雄"])
    do
        local i = 0
        while i < #_____5206_8EAB_7EC4 do
            _____64AD_653E_5206_8EAB_6D88_5931_7279_6548(_____5206_8EAB_7EC4[i + 1])
            i = i + 1
        end
    end
    if _____5355_4F4D_5B58_6D3B(_____5206_8EAB) then
        KillUnit(_____5206_8EAB)
    end
    _____6267_884C_94C3_4ED9_51FA_73B0_8868_73B0(_____4F1A_8BDD["英雄"], _____5206_8EABX, _____5206_8EABY, _____671D_5411)
    _____5B8C_6210_4F1A_8BDD(_____4F1A_8BDD)
end
local function ____on_94C3_4ED9_5206_8EAB_53EC_5524(_____88AB_53EC_5524_5355_4F4D, _____53EC_5524_5355_4F4D)
    if _____88AB_53EC_5524_5355_4F4D == nil or _____88AB_53EC_5524_5355_4F4D == 0 then
        return
    end
    if not _____662F_94C3_4ED9_5206_8EAB(_____88AB_53EC_5524_5355_4F4D) then
        return
    end
    if not _____662F_94C3_4ED9_672C_4F53(_____53EC_5524_5355_4F4D) then
        return
    end
    local _____4F1A_8BDD = _____94C3_4ED9W_4F1A_8BDD_8868[GetHandleId(_____53EC_5524_5355_4F4D)]
    if _____4F1A_8BDD == nil or _____4F1A_8BDD["是否出现"] then
        return
    end
    local cfg = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E.W
    _____52A0_5165_94C3_4ED9_5206_8EAB(_____53EC_5524_5355_4F4D, _____88AB_53EC_5524_5355_4F4D)
    _____4F1A_8BDD["角度"] = _____4F1A_8BDD["角度"] + 90
    if _____4F1A_8BDD["角度"] >= 450 then
        ShowUnit(_____53EC_5524_5355_4F4D, false)
        SetUnitX(_____88AB_53EC_5524_5355_4F4D, _____4F1A_8BDD["原X"])
        SetUnitY(_____88AB_53EC_5524_5355_4F4D, _____4F1A_8BDD["原Y"])
        SetUnitFacing(_____88AB_53EC_5524_5355_4F4D, _____4F1A_8BDD["原朝向"])
        addDelayedCallback(
            cfg["中心分身消失秒"] * 1000,
            function()
                if _____5355_4F4D_5B58_6D3B(_____88AB_53EC_5524_5355_4F4D) then
                    KillUnit(_____88AB_53EC_5524_5355_4F4D)
                end
            end
        )
    else
        local _____5206_8EAB_89D2_5EA6 = _____4F1A_8BDD["角度"]
        local _____5206_8EABX = _____4F1A_8BDD["原X"] + cfg["分身半径"] * math.cos(_____5206_8EAB_89D2_5EA6 * math.pi / 180)
        local _____5206_8EABY = _____4F1A_8BDD["原Y"] + cfg["分身半径"] * math.sin(_____5206_8EAB_89D2_5EA6 * math.pi / 180)
        SetUnitX(_____88AB_53EC_5524_5355_4F4D, _____5206_8EABX)
        SetUnitY(_____88AB_53EC_5524_5355_4F4D, _____5206_8EABY)
        SetUnitFacing(_____88AB_53EC_5524_5355_4F4D, _____5206_8EAB_89D2_5EA6)
    end
end
local function ____on_5206_8EAB_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D)
    if _____6B7B_4EA1_5355_4F4D == nil or _____6B7B_4EA1_5355_4F4D == 0 then
        return
    end
    local _____4F1A_8BDD = _____67E5_627E_5355_4F4D_6240_5C5E_4F1A_8BDD(_____6B7B_4EA1_5355_4F4D)
    if _____4F1A_8BDD == nil then
        return
    end
    _____79FB_9664_94C3_4ED9_5206_8EAB(_____4F1A_8BDD["英雄"], _____6B7B_4EA1_5355_4F4D)
    if _____94C3_4ED9_5206_8EAB_6570_91CF(_____4F1A_8BDD["英雄"]) <= 0 then
        _____94C3_4ED9_539F_5730_51FA_73B0(_____4F1A_8BDD)
    end
end
local function ____on_73A9_5BB6_9009_4E2D_5206_8EAB(_____73A9_5BB6, playerId, _____5355_4F4D, _____662F_5426_9009_4E2D)
    if not _____662F_5426_9009_4E2D then
        return
    end
    if not _____662F_94C3_4ED9_5206_8EAB(_____5355_4F4D) then
        return
    end
    local _____4F1A_8BDD = _____67E5_627E_5355_4F4D_6240_5C5E_4F1A_8BDD(_____5355_4F4D)
    if _____4F1A_8BDD == nil or _____4F1A_8BDD["是否出现"] then
        return
    end
    if _____5355_4F4D == _____4F1A_8BDD["英雄"] then
        return
    end
    if GetPlayerId(GetOwningPlayer(_____5355_4F4D)) ~= playerId then
        return
    end
    _____94C3_4ED9_5206_8EAB_4F20_9001_51FA_73B0(_____4F1A_8BDD, _____5355_4F4D)
end
local function ____on_94C3_4ED9W_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if not _____662F_94C3_4ED9_672C_4F53(_____65BD_6CD5_5355_4F4D) then
        return
    end
    if _____6280_80FDID_6570_503C ~= ____W_6280_80FDID then
        return
    end
    local _____82F1_96C4 = _____65BD_6CD5_5355_4F4D
    local cfg = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E.W
    local id = GetHandleId(_____82F1_96C4)
    _____6CE8_518C_94C3_4ED9_82F1_96C4(_____82F1_96C4)
    local _____65E7_4F1A_8BDD = _____94C3_4ED9W_4F1A_8BDD_8868[id]
    if _____65E7_4F1A_8BDD ~= nil then
        _____94C3_4ED9_539F_5730_51FA_73B0(_____65E7_4F1A_8BDD)
    end
    local _____7B49_7EA7 = GetUnitAbilityLevel(_____82F1_96C4, ____W_6280_80FDID)
    local _____6301_7EED_79D2 = cfg["分身持续秒"][_____7B49_7EA7] or cfg["分身持续秒"][1]
    local _____539FX = GetUnitX(_____82F1_96C4)
    local _____539FY = GetUnitY(_____82F1_96C4)
    local _____539F_671D_5411 = GetUnitFacing(_____82F1_96C4)
    _____64AD_653E_94C3_4ED9_5168_5C40_97F3_6548("gg_snd_LX_W2")
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["施法特效模型"],
        X = _____539FX,
        Y = _____539FY,
        Z = cfg["施法特效高度"],
        ["缩放"] = cfg["施法特效缩放"],
        ["持续秒"] = cfg["施法特效持续秒"]
    })
    local _____5468_56F4_5355_4F4D = getUnitsInRange(_____539FX, _____539FY, 350)
    do
        local i = 0
        while i < #_____5468_56F4_5355_4F4D do
            do
                local _____654C_65B9 = _____5468_56F4_5355_4F4D[i + 1]
                if not _____662F_6709_6548_654C_5BF9_76EE_6807(_____82F1_96C4, _____654C_65B9) then
                    goto __continue55
                end
                registerManualBuff(_____654C_65B9, _____94C3_4ED9BuffID["W对视"], 1, 0)
            end
            ::__continue55::
            i = i + 1
        end
    end
    registerManualBuff(_____82F1_96C4, _____94C3_4ED9BuffID["W替身"], _____6301_7EED_79D2, 0)
    local _____4F1A_8BDD = {
        ["英雄"] = _____82F1_96C4,
        ["原X"] = _____539FX,
        ["原Y"] = _____539FY,
        ["原朝向"] = _____539F_671D_5411,
        ["是否出现"] = false,
        ["角度"] = 0,
        ["超时计时器ID"] = 0
    }
    _____94C3_4ED9W_4F1A_8BDD_8868[id] = _____4F1A_8BDD
    do
        local i = 0
        while i < 5 do
            local ok = SFB_setItemIllusion(
                _____82F1_96C4,
                _____82F1_96C4,
                _____6301_7EED_79D2,
                cfg["分身输出倍率"],
                cfg["分身承伤倍率"]
            )
            if not ok then
                break
            end
            i = i + 1
        end
    end
    _____4F1A_8BDD["超时计时器ID"] = addDelayedCallback(
        cfg["超时恢复秒"] * 1000,
        function()
            local current = _____94C3_4ED9W_4F1A_8BDD_8868[id]
            if current == nil or current ~= _____4F1A_8BDD then
                return
            end
            _____94C3_4ED9_539F_5730_51FA_73B0(current)
        end
    )
end
registerSpellEffectListener(____on_94C3_4ED9W_751F_6548)
_____6CE8_518C_53EC_5524_76D1_542C(____on_94C3_4ED9_5206_8EAB_53EC_5524)
registerDeathListener(____on_5206_8EAB_6B7B_4EA1)
addSelectionListener(____on_73A9_5BB6_9009_4E2D_5206_8EAB)
return ____exports
