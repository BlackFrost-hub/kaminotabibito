--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00．配置")
local _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["佐佐木单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00A．表现工具")
local _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放佐佐木坐标音效"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00B．分身与状态管理")
local _____662F_4F50_4F50_6728_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是佐佐木本体"]
local _____662F_4F50_4F50_6728_5206_8EAB = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是佐佐木分身"]
local _____77AC_79FB_662F_5426_5C31_7EEA = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["瞬移是否就绪"]
local _____542F_7528_77AC_79FB_51B7_5374 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["启用瞬移冷却"]
local _____8BBE_7F6E_77AC_79FB_540E_6807_8BB0 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["设置瞬移后标记"]
local _____6CE8_518C_4F50_4F50_6728_82F1_96C4 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["注册佐佐木英雄"]
local _____83B7_53D6_73A9_5BB6_4F50_4F50_6728_82F1_96C4 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["获取玩家佐佐木英雄"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local registerTargetOrderListener = ____require_result_1.registerTargetOrderListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_3["造成技能伤害"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local ____SFB__65BD_52A0_901A_7528Buff = ____require_result_4["SFB_施加通用Buff"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_5.getUnitsInRange
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_7.isUnitEnemy
local ____D_6280_80FDID_6570_503C = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["D技能ID"])
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitPosition = jass.SetUnitPosition
local GetOwningPlayer = jass.GetOwningPlayer
local CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
local SetUnitVertexColor = jass.SetUnitVertexColor
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local IssueImmediateOrder = jass.IssueImmediateOrder
local _____6B8B_5F71_9A6C_7532ID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["残影马甲ID"])
local _____5FEB_901F_5200_5149_524DID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["快速刀光前ID"])
local _____5FEB_901F_5200_5149_540EID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["快速刀光后ID"])
local function _____4E24_70B9_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end
local function _____4E24_70B9_89D2_5EA6(x1, y1, x2, y2)
    return math.atan(y2 - y1, x2 - x1) * 180 / math.pi
end
local function _____662F_6709_6548_654C_4EBA(_____65BD_6CD5_8005, target)
    if target == nil or target == 0 or target == _____65BD_6CD5_8005 then
        return false
    end
    if not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    if jass.IsUnitType(target, jass.UNIT_TYPE_ANCIENT) then
        return false
    end
    if jass.IsUnitType(target, jass.UNIT_TYPE_MECHANICAL) then
        return false
    end
    if jass.IsUnitType(target, jass.UNIT_TYPE_STRUCTURE) then
        return false
    end
    if not isUnitEnemy(target, _____65BD_6CD5_8005) then
        return false
    end
    return true
end
--- 执行换位与残影冲刺（源 JASS Trig_1ZZMSYFunc002Func002Func005T）
local function _____6267_884C_4F50_4F50_6728_6362_4F4D(_____82F1_96C4, _____5206_8EAB_5355_4F4D)
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D
    local owner = GetOwningPlayer(_____82F1_96C4)
    local _____672C_4F53X = GetUnitX(_____82F1_96C4)
    local _____672C_4F53Y = GetUnitY(_____82F1_96C4)
    local _____5206_8EABX = GetUnitX(_____5206_8EAB_5355_4F4D)
    local _____5206_8EABY = GetUnitY(_____5206_8EAB_5355_4F4D)
    local _____8DDD_79BB = _____4E24_70B9_8DDD_79BB(_____672C_4F53X, _____672C_4F53Y, _____5206_8EABX, _____5206_8EABY)
    local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(_____672C_4F53X, _____672C_4F53Y, _____5206_8EABX, _____5206_8EABY)
    local _____5F27_5EA6 = _____89D2_5EA6 * math.pi / 180
    local _____5FEB_901F_6A21_5F0F = _____8DDD_79BB >= cfg["快速模式距离"]
    local _____6BCFtick_8DDD_79BB = _____5FEB_901F_6A21_5F0F and cfg["快速每tick距离"] or cfg["冲刺每tick距离"]
    local _____603B_6B65_6570 = math.ceil(_____8DDD_79BB / _____6BCFtick_8DDD_79BB)
    local _____6B8B_5F71 = CreateUnit(
        owner,
        _____6B8B_5F71_9A6C_7532ID,
        _____672C_4F53X,
        _____672C_4F53Y,
        _____89D2_5EA6
    )
    if _____6B8B_5F71 == nil or _____6B8B_5F71 == 0 then
        return
    end
    SetUnitVertexColor(
        _____6B8B_5F71,
        255,
        255,
        255,
        225
    )
    SetUnitAnimationByIndex(_____6B8B_5F71, 9)
    SetUnitTimeScale(_____6B8B_5F71, 2.2)
    local _____5200_5149 = nil
    if _____5FEB_901F_6A21_5F0F then
        _____5200_5149 = CreateUnit(
            owner,
            _____5FEB_901F_5200_5149_524DID,
            _____672C_4F53X + math.cos(_____5F27_5EA6) * 100,
            _____672C_4F53Y + math.sin(_____5F27_5EA6) * 100,
            _____89D2_5EA6
        )
        local _____5200_5149_540E = CreateUnit(
            owner,
            _____5FEB_901F_5200_5149_540EID,
            _____672C_4F53X,
            _____672C_4F53Y,
            _____89D2_5EA6
        )
        SetUnitTimeScale(_____5200_5149_540E, 0.1)
        if _____5200_5149 ~= nil and _____5200_5149 ~= 0 then
            _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548(
                cfg["快速刀光音效路径"],
                GetUnitX(_____5200_5149),
                GetUnitY(_____5200_5149),
                cfg["快速刀光音效裁断"]
            )
        end
    end
    _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548(cfg["突进音效路径"], _____672C_4F53X, _____672C_4F53Y, cfg["突进音效裁断"])
    _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548(cfg["换位音效路径"], _____672C_4F53X, _____672C_4F53Y, cfg["换位音效裁断"])
    _____542F_7528_77AC_79FB_51B7_5374(_____82F1_96C4)
    SetUnitX(_____82F1_96C4, _____5206_8EABX)
    SetUnitY(_____82F1_96C4, _____5206_8EABY)
    SetUnitPosition(_____5206_8EAB_5355_4F4D, _____672C_4F53X, _____672C_4F53Y)
    IssueImmediateOrder(_____82F1_96C4, "holdposition")
    _____8BBE_7F6E_77AC_79FB_540E_6807_8BB0(_____82F1_96C4)
    local _____51B2_523A_547D_4E2D_8868 = {}
    local _____71D5_8FD4_547D_4E2D_8868 = {}
    local _____6B65_957FX = math.cos(_____5F27_5EA6) * _____6BCFtick_8DDD_79BB
    local _____6B65_957FY = math.sin(_____5F27_5EA6) * _____6BCFtick_8DDD_79BB
    local _____5F53_524DX = _____672C_4F53X
    local _____5F53_524DY = _____672C_4F53Y
    local _____5DF2_8D70_6B65_6570 = 0
    local loopId
    loopId = addPeriodicCallback(
        cfg["冲刺tick毫秒"],
        function()
            _____5DF2_8D70_6B65_6570 = _____5DF2_8D70_6B65_6570 + 1
            if _____5DF2_8D70_6B65_6570 > _____603B_6B65_6570 or not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                RemoveUnit(_____6B8B_5F71)
                if _____5200_5149 ~= nil and _____5200_5149 ~= 0 then
                    RemoveUnit(_____5200_5149)
                end
                removePeriodicCallback(loopId)
                return
            end
            _____5F53_524DX = _____5F53_524DX + _____6B65_957FX
            _____5F53_524DY = _____5F53_524DY + _____6B65_957FY
            SetUnitX(_____6B8B_5F71, _____5F53_524DX)
            SetUnitY(_____6B8B_5F71, _____5F53_524DY)
            if _____5200_5149 ~= nil and _____5200_5149 ~= 0 then
                SetUnitX(_____5200_5149, _____5F53_524DX + _____6B65_957FX * (100 / _____6BCFtick_8DDD_79BB))
                SetUnitY(_____5200_5149, _____5F53_524DY + _____6B65_957FY * (100 / _____6BCFtick_8DDD_79BB))
            end
            local units = getUnitsInRange(_____5F53_524DX, _____5F53_524DY, cfg["换位伤害半径"])
            do
                local i = 0
                while i < #units do
                    do
                        local enemy = units[i + 1]
                        if not _____662F_6709_6548_654C_4EBA(_____82F1_96C4, enemy) then
                            goto __continue20
                        end
                        local enemyId = GetHandleId(enemy)
                        if _____51B2_523A_547D_4E2D_8868[enemyId] == true then
                            goto __continue20
                        end
                        _____51B2_523A_547D_4E2D_8868[enemyId] = true
                        _____9020_6210_6280_80FD_4F24_5BB3({
                            ["来源"] = _____82F1_96C4,
                            ["目标"] = enemy,
                            ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____82F1_96C4) * cfg["换位攻击倍率"],
                            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                            ranged = false,
                            attackType = ATTACK_TYPE_NORMAL,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "单位技能",
                            ["技能ID"] = ____D_6280_80FDID_6570_503C,
                            ["标签"] = "佐佐木小次郎-换位冲刺",
                            ["伤害形态"] = "AOE",
                            ["参与技能伤害加成"] = true
                        })
                    end
                    ::__continue20::
                    i = i + 1
                end
            end
            if _____5FEB_901F_6A21_5F0F then
                do
                    local i = 0
                    while i < #units do
                        do
                            local enemy = units[i + 1]
                            if not _____662F_6709_6548_654C_4EBA(_____82F1_96C4, enemy) then
                                goto __continue25
                            end
                            local enemyId = GetHandleId(enemy)
                            if _____71D5_8FD4_547D_4E2D_8868[enemyId] == true then
                                goto __continue25
                            end
                            _____71D5_8FD4_547D_4E2D_8868[enemyId] = true
                            ____SFB__65BD_52A0_901A_7528Buff(_____82F1_96C4, enemy, 21, cfg["燕返硬直秒"])
                            _____9020_6210_6280_80FD_4F24_5BB3({
                                ["来源"] = _____82F1_96C4,
                                ["目标"] = enemy,
                                ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____82F1_96C4) * cfg["燕返攻击倍率"],
                                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                                ranged = false,
                                attackType = ATTACK_TYPE_NORMAL,
                                weaponType = WEAPON_TYPE_WHOKNOWS,
                                ["来源类型"] = "单位技能",
                                ["技能ID"] = ____D_6280_80FDID_6570_503C,
                                ["标签"] = "佐佐木小次郎-燕返被动",
                                ["伤害形态"] = "AOE",
                                ["参与技能伤害加成"] = true
                            })
                        end
                        ::__continue25::
                        i = i + 1
                    end
                end
            end
        end
    )
end
local function ____on_4F50_4F50_6728_53F3_952E_6307_4EE4(_____6307_4EE4_5355_4F4D, orderId, _____76EE_6807_5355_4F4D, _____76EE_6807_7269_54C1, _____76EE_6807_53EF_7834_574F_7269)
    local ____ = orderId
    local ____ = _____76EE_6807_7269_54C1
    local ____ = _____76EE_6807_53EF_7834_574F_7269
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    local _____82F1_96C4 = nil
    if _____662F_4F50_4F50_6728_672C_4F53(_____6307_4EE4_5355_4F4D) then
        _____6CE8_518C_4F50_4F50_6728_82F1_96C4(_____6307_4EE4_5355_4F4D)
        _____82F1_96C4 = _____6307_4EE4_5355_4F4D
    else
        _____82F1_96C4 = _____83B7_53D6_73A9_5BB6_4F50_4F50_6728_82F1_96C4(GetOwningPlayer(_____6307_4EE4_5355_4F4D))
    end
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        return
    end
    if not _____77AC_79FB_662F_5426_5C31_7EEA(_____82F1_96C4) then
        return
    end
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D
    local _____672C_4F53X = GetUnitX(_____82F1_96C4)
    local _____672C_4F53Y = GetUnitY(_____82F1_96C4)
    local candidates = getUnitsInRange(
        GetUnitX(_____76EE_6807_5355_4F4D),
        GetUnitY(_____76EE_6807_5355_4F4D),
        100
    )
    local _____53EF_9009_5206_8EAB = {}
    do
        local i = 0
        while i < #candidates do
            do
                local unit = candidates[i + 1]
                if not _____662F_4F50_4F50_6728_5206_8EAB(_____82F1_96C4, unit) then
                    goto __continue36
                end
                if _____4E24_70B9_8DDD_79BB(
                    _____672C_4F53X,
                    _____672C_4F53Y,
                    GetUnitX(unit),
                    GetUnitY(unit)
                ) > cfg["瞬移最大距离"] then
                    goto __continue36
                end
                _____53EF_9009_5206_8EAB[#_____53EF_9009_5206_8EAB + 1] = unit
            end
            ::__continue36::
            i = i + 1
        end
    end
    if #_____53EF_9009_5206_8EAB == 0 then
        return
    end
    local _____5206_8EAB_5355_4F4D = _____53EF_9009_5206_8EAB[math.floor(math.random() * #_____53EF_9009_5206_8EAB) + 1]
    _____6267_884C_4F50_4F50_6728_6362_4F4D(_____82F1_96C4, _____5206_8EAB_5355_4F4D)
end
registerTargetOrderListener(____on_4F50_4F50_6728_53F3_952E_6307_4EE4)
return ____exports
