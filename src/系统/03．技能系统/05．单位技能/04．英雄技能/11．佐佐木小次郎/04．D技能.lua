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
local _____8DDD_79BBXY = ____require_result_6["距离XY"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_6["两点角度"]
local _____6781_5750_6807X = ____require_result_6["极坐标X"]
local _____6781_5750_6807Y = ____require_result_6["极坐标Y"]
local _____53D6_5355_4F4DID = ____require_result_6["取单位ID"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_7.isUnitEnemy
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_SetUnitMovableSafe = ____require_result_8.X_SetUnitMovableSafe
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_9["创建单位并登记排泄安全"]
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_10["立即移除单位并取消排泄登记"]
local ____D_6280_80FDID_6570_503C = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["D被动技能ID"])
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
local SetUnitVertexColor = jass.SetUnitVertexColor
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local IssueImmediateOrder = jass.IssueImmediateOrder
local _____6B8B_5F71_9A6C_7532ID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["残影马甲ID"])
local _____5FEB_901F_5200_5149_524DID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["快速刀光前ID"])
local _____5FEB_901F_5200_5149_540EID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["快速刀光后ID"])
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
--- 佐佐木 D 残影冲刺周期推进。实例参数对象快照本技能创建的单位与句柄ID，
-- 英雄死亡或重复释放时旧回调不得移除句柄已被复用的新实例单位。
local function _____63A8_8FDBD_51B2_523A(variable)
    local _____5B9E_4F8B = variable
    if _____5B9E_4F8B == nil then
        return
    end
    _____5B9E_4F8B["已走步数"] = _____5B9E_4F8B["已走步数"] + 1
    if _____5B9E_4F8B["已走步数"] > _____5B9E_4F8B["总步数"] or not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["英雄"]) then
        if _____53D6_5355_4F4DID(_____5B9E_4F8B["残影"]) == _____5B9E_4F8B["残影ID"] then
            _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____5B9E_4F8B["残影"])
        end
        if _____5B9E_4F8B["刀光"] ~= nil and _____5B9E_4F8B["刀光"] ~= 0 and _____53D6_5355_4F4DID(_____5B9E_4F8B["刀光"]) == _____5B9E_4F8B["刀光ID"] then
            _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____5B9E_4F8B["刀光"])
        end
        if _____5B9E_4F8B["慢刀光"] ~= nil and _____5B9E_4F8B["慢刀光"] ~= 0 and _____53D6_5355_4F4DID(_____5B9E_4F8B["慢刀光"]) == _____5B9E_4F8B["慢刀光ID"] then
            _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____5B9E_4F8B["慢刀光"])
        end
        removePeriodicCallback(_____5B9E_4F8B["回调ID"])
        return
    end
    _____5B9E_4F8B["当前X"] = _____5B9E_4F8B["当前X"] + _____5B9E_4F8B["步长X"]
    _____5B9E_4F8B["当前Y"] = _____5B9E_4F8B["当前Y"] + _____5B9E_4F8B["步长Y"]
    SetUnitX(_____5B9E_4F8B["残影"], _____5B9E_4F8B["当前X"])
    SetUnitY(_____5B9E_4F8B["残影"], _____5B9E_4F8B["当前Y"])
    if _____5B9E_4F8B["刀光"] ~= nil and _____5B9E_4F8B["刀光"] ~= 0 then
        SetUnitX(_____5B9E_4F8B["刀光"], _____5B9E_4F8B["当前X"] + _____5B9E_4F8B["步长X"] * (100 / _____5B9E_4F8B["每tick距离"]))
        SetUnitY(_____5B9E_4F8B["刀光"], _____5B9E_4F8B["当前Y"] + _____5B9E_4F8B["步长Y"] * (100 / _____5B9E_4F8B["每tick距离"]))
    end
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D
    local units = getUnitsInRange(_____5B9E_4F8B["当前X"], _____5B9E_4F8B["当前Y"], cfg["换位伤害半径"])
    do
        local i = 0
        while i < #units do
            do
                local enemy = units[i + 1]
                if not _____662F_6709_6548_654C_4EBA(_____5B9E_4F8B["英雄"], enemy) then
                    goto __continue17
                end
                local enemyId = GetHandleId(enemy)
                if _____5B9E_4F8B["命中表"][enemyId] == true then
                    goto __continue17
                end
                _____5B9E_4F8B["命中表"][enemyId] = true
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____5B9E_4F8B["英雄"],
                    ["目标"] = enemy,
                    ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____5B9E_4F8B["英雄"]) * cfg["换位攻击倍率"],
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
            ::__continue17::
            i = i + 1
        end
    end
    if _____5B9E_4F8B["快速模式"] then
        do
            local i = 0
            while i < #units do
                do
                    local enemy = units[i + 1]
                    if not _____662F_6709_6548_654C_4EBA(_____5B9E_4F8B["英雄"], enemy) then
                        goto __continue22
                    end
                    local enemyId = GetHandleId(enemy)
                    if _____5B9E_4F8B["燕返表"][enemyId] == true then
                        goto __continue22
                    end
                    _____5B9E_4F8B["燕返表"][enemyId] = true
                    ____SFB__65BD_52A0_901A_7528Buff(_____5B9E_4F8B["英雄"], enemy, 21, cfg["燕返硬直秒"])
                    _____9020_6210_6280_80FD_4F24_5BB3({
                        ["来源"] = _____5B9E_4F8B["英雄"],
                        ["目标"] = enemy,
                        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____5B9E_4F8B["英雄"]) * cfg["燕返攻击倍率"],
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
                ::__continue22::
                i = i + 1
            end
        end
    end
end
local function _____6267_884C_4F50_4F50_6728_6362_4F4D(_____82F1_96C4, _____5206_8EAB_5355_4F4D)
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D
    local owner = GetOwningPlayer(_____82F1_96C4)
    local _____672C_4F53X = GetUnitX(_____82F1_96C4)
    local _____672C_4F53Y = GetUnitY(_____82F1_96C4)
    local _____5206_8EABX = GetUnitX(_____5206_8EAB_5355_4F4D)
    local _____5206_8EABY = GetUnitY(_____5206_8EAB_5355_4F4D)
    local _____8DDD_79BB = _____8DDD_79BBXY(_____672C_4F53X, _____672C_4F53Y, _____5206_8EABX, _____5206_8EABY)
    local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(_____672C_4F53X, _____672C_4F53Y, _____5206_8EABX, _____5206_8EABY)
    local _____5FEB_901F_6A21_5F0F = _____8DDD_79BB >= cfg["快速模式距离"]
    local _____6BCFtick_8DDD_79BB = _____5FEB_901F_6A21_5F0F and cfg["快速每tick距离"] or cfg["冲刺每tick距离"]
    local _____603B_6B65_6570 = jass.R2I((_____8DDD_79BB + _____6BCFtick_8DDD_79BB - 1) / _____6BCFtick_8DDD_79BB)
    local _____6B8B_5F71 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        _____6B8B_5F71_9A6C_7532ID,
        _____672C_4F53X,
        _____672C_4F53Y,
        _____89D2_5EA6
    )
    if _____6B8B_5F71 == nil or _____6B8B_5F71 == 0 then
        return
    end
    X_SetUnitMovableSafe(_____6B8B_5F71, false)
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
    local _____6162_5200_5149 = nil
    if _____5FEB_901F_6A21_5F0F then
        _____5200_5149 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            owner,
            _____5FEB_901F_5200_5149_524DID,
            _____6781_5750_6807X(_____672C_4F53X, _____89D2_5EA6, 100),
            _____6781_5750_6807Y(_____672C_4F53Y, _____89D2_5EA6, 100),
            _____89D2_5EA6
        )
        _____6162_5200_5149 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            owner,
            _____5FEB_901F_5200_5149_540EID,
            _____672C_4F53X,
            _____672C_4F53Y,
            _____89D2_5EA6
        )
        if _____6162_5200_5149 ~= nil and _____6162_5200_5149 ~= 0 then
            SetUnitTimeScale(_____6162_5200_5149, 0.1)
        end
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
    local _____51B2_523A_5B9E_4F8B = {
        ["英雄"] = _____82F1_96C4,
        ["残影"] = _____6B8B_5F71,
        ["残影ID"] = _____53D6_5355_4F4DID(_____6B8B_5F71),
        ["刀光"] = _____5200_5149,
        ["刀光ID"] = _____5200_5149 ~= nil and _____5200_5149 ~= 0 and _____53D6_5355_4F4DID(_____5200_5149) or 0,
        ["慢刀光"] = _____6162_5200_5149,
        ["慢刀光ID"] = _____6162_5200_5149 ~= nil and _____6162_5200_5149 ~= 0 and _____53D6_5355_4F4DID(_____6162_5200_5149) or 0,
        ["步长X"] = _____6781_5750_6807X(0, _____89D2_5EA6, _____6BCFtick_8DDD_79BB),
        ["步长Y"] = _____6781_5750_6807Y(0, _____89D2_5EA6, _____6BCFtick_8DDD_79BB),
        ["每tick距离"] = _____6BCFtick_8DDD_79BB,
        ["快速模式"] = _____5FEB_901F_6A21_5F0F,
        ["总步数"] = _____603B_6B65_6570,
        ["命中表"] = {},
        ["燕返表"] = {},
        ["当前X"] = _____672C_4F53X,
        ["当前Y"] = _____672C_4F53Y,
        ["已走步数"] = 0,
        ["回调ID"] = 0
    }
    _____51B2_523A_5B9E_4F8B["回调ID"] = addPeriodicCallback(cfg["冲刺tick毫秒"], _____63A8_8FDBD_51B2_523A, _____51B2_523A_5B9E_4F8B)
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
    if _____662F_4F50_4F50_6728_5206_8EAB(_____82F1_96C4, _____76EE_6807_5355_4F4D) and _____8DDD_79BBXY(
        _____672C_4F53X,
        _____672C_4F53Y,
        GetUnitX(_____76EE_6807_5355_4F4D),
        GetUnitY(_____76EE_6807_5355_4F4D)
    ) <= cfg["瞬移最大距离"] then
        _____6267_884C_4F50_4F50_6728_6362_4F4D(_____82F1_96C4, _____76EE_6807_5355_4F4D)
    end
end
registerTargetOrderListener(____on_4F50_4F50_6728_53F3_952E_6307_4EE4)
return ____exports
