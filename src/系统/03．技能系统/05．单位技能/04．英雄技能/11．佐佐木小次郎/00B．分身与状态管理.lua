--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00．配置")
local _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["佐佐木单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00A．表现工具")
local _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放佐佐木坐标音效"]
local _____64AD_653E_4F50_4F50_6728_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放佐佐木配置动作"]
local ____11_FF0E_4F50_4F50_6728_5C0F_6B21_90CE = require("系统.05．Buff系统.03．Buff表.02．英雄.11．佐佐木小次郎")
local _____4F50_4F50_6728_5C0F_6B21_90CEBuffID = ____11_FF0E_4F50_4F50_6728_5C0F_6B21_90CE["佐佐木小次郎BuffID"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setItemIllusion = ____require_result_1.SFB_setItemIllusion
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.09．单位召唤事件中心")
local _____6CE8_518C_53EC_5524_76D1_542C = ____require_result_2["注册召唤监听"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local removeDelayedCallback = ____require_result_3.removeDelayedCallback
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_SetUnitMovableSafe = ____require_result_5.X_SetUnitMovableSafe
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_6["造成技能伤害"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_7.getUnitsInRange
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_8["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_8["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_8["两点角度"]
local _____89D2_5EA6_5DEE_7EDD_5BF9_503C = ____require_result_8["角度差绝对值"]
local _____6781_5750_6807X = ____require_result_8["极坐标X"]
local _____6781_5750_6807Y = ____require_result_8["极坐标Y"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
local ____require_result_10 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_10.isUnitEnemy
local ____require_result_11 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.02．攻击效果监听")
local _____6CE8_518C_666E_653B_653B_51FB_6548_679C_76D1_542C = ____require_result_11["注册普攻攻击效果监听"]
local ____require_result_12 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_12.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_12["移除单位指定Buff"]
local ____require_result_13 = require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示")
local _____767B_8BB0_88AB_52A8_6280_80FD_51B7_5374 = ____require_result_13["登记被动技能冷却"]
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____4F50_4F50_6728_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local ____Q_4E8C_6BB5_6280_80FDID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["Q二段技能ID"])
local ____W_4E8C_6BB5_6280_80FDID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["W二段技能ID"])
local ____D_88AB_52A8_6280_80FDID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["D被动技能ID"])
--- 幻象原生 Buff（分身判定标志）
local _____5E7B_8C61BuffID = stringToFourCCSafe("BIil")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local IsUnitIllusion = jass.IsUnitIllusion
do
    local playerId = 0
    while playerId <= 15 do
        SetPlayerAbilityAvailable(
            jass.Player(playerId),
            ____Q_4E8C_6BB5_6280_80FDID,
            false
        )
        SetPlayerAbilityAvailable(
            jass.Player(playerId),
            ____W_4E8C_6BB5_6280_80FDID,
            false
        )
        playerId = playerId + 1
    end
end
local function _____662F_6709_6548_4F24_5BB3_76EE_6807(_____65BD_6CD5_8005, target)
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
--- 扇形技能伤害结算（Q / W 共用）
-- 以（中心X, 中心Y）为圆心、半径 radius、面向 faceAngle ± 半角 的扇形内敌人结算一次技能伤害。
____exports["佐佐木扇形伤害"] = function(_____65BD_6CD5_8005, _____4E2D_5FC3X, _____4E2D_5FC3Y, _____9762_5411_89D2_5EA6, _____534A_5F84, _____534A_89D2, _____653B_51FB_500D_7387, _____6280_80FDID, _____6807_7B7E, _____547D_4E2D_7279_6548_6A21_578B, _____547D_4E2D_7279_6548_7F29_653E, _____786C_76F4_79D2)
    local _____4F24_5BB3_503C = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____653B_51FB_500D_7387
    local targets = getUnitsInRange(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____534A_5F84)
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____662F_6709_6548_4F24_5BB3_76EE_6807(_____65BD_6CD5_8005, target) then
                    goto __continue13
                end
                local _____6307_5411_76EE_6807_89D2_5EA6 = _____4E24_70B9_89D2_5EA6(
                    _____4E2D_5FC3X,
                    _____4E2D_5FC3Y,
                    GetUnitX(target),
                    GetUnitY(target)
                )
                if _____89D2_5EA6_5DEE_7EDD_5BF9_503C(_____6307_5411_76EE_6807_89D2_5EA6, _____9762_5411_89D2_5EA6) > _____534A_89D2 then
                    goto __continue13
                end
                if _____786C_76F4_79D2 > 0 then
                    local ____require_result_14 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
                    local ____SFB__65BD_52A0_901A_7528Buff = ____require_result_14["SFB_施加通用Buff"]
                    ____SFB__65BD_52A0_901A_7528Buff(_____65BD_6CD5_8005, target, 21, _____786C_76F4_79D2)
                end
                if _____547D_4E2D_7279_6548_6A21_578B ~= "" then
                    _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = _____547D_4E2D_7279_6548_6A21_578B,
                        X = GetUnitX(target),
                        Y = GetUnitY(target),
                        ["面向角度"] = _____9762_5411_89D2_5EA6,
                        ["缩放"] = _____547D_4E2D_7279_6548_7F29_653E,
                        ["持续秒"] = 1
                    })
                end
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____65BD_6CD5_8005,
                    ["目标"] = target,
                    ["伤害"] = _____4F24_5BB3_503C,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = _____6280_80FDID,
                    ["标签"] = _____6807_7B7E,
                    ["伤害形态"] = "AOE",
                    ["参与技能伤害加成"] = true
                })
            end
            ::__continue13::
            i = i + 1
        end
    end
end
local _____77AC_79FB_51B7_5374_8868 = {}
local _____5206_8EAB_5165_573A_6682_505C_6765_6E90 = "佐佐木分身入场"
--- 是否是佐佐木小次郎本体
____exports["是佐佐木本体"] = function(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == _____4F50_4F50_6728_5355_4F4D_7C7B_578BID
end
local _____4F50_4F50_6728_82F1_96C4_8868 = {}
local GetPlayerId = jass.GetPlayerId
____exports["注册佐佐木英雄"] = function(_____82F1_96C4)
    if not ____exports["是佐佐木本体"](_____82F1_96C4) then
        return
    end
    _____4F50_4F50_6728_82F1_96C4_8868[GetPlayerId(GetOwningPlayer(_____82F1_96C4))] = _____82F1_96C4
end
____exports["获取玩家佐佐木英雄"] = function(player)
    if player == nil or player == 0 then
        return nil
    end
    local hero = _____4F50_4F50_6728_82F1_96C4_8868[GetPlayerId(player)]
    if hero == nil or hero == 0 or not _____5355_4F4D_5B58_6D3B(hero) then
        return nil
    end
    return hero
end
--- 右键换位后 1 秒内为 true（Q 附加剑气窗口）
local _____77AC_79FB_540E_8868 = {}
____exports["获取瞬移后标记"] = function(_____82F1_96C4)
    return _____77AC_79FB_540E_8868[GetHandleId(_____82F1_96C4)] == true
end
____exports["消耗瞬移后标记"] = function(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    if _____77AC_79FB_540E_8868[id] ~= true then
        return false
    end
    _____77AC_79FB_540E_8868[id] = false
    return true
end
____exports["设置瞬移后标记"] = function(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    _____77AC_79FB_540E_8868[id] = true
    registerManualBuff(_____82F1_96C4, _____4F50_4F50_6728_5C0F_6B21_90CEBuffID["无心视野"], _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["瞬移后窗口秒"], 0)
    addDelayedCallback(
        _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["瞬移后窗口秒"] * 1000,
        function()
            _____77AC_79FB_540E_8868[id] = false
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4F50_4F50_6728_5C0F_6B21_90CEBuffID["无心视野"])
        end
    )
end
--- 瞬移是否就绪（冷却结束或被分身创建刷新）
____exports["瞬移是否就绪"] = function(_____82F1_96C4)
    local record = _____77AC_79FB_51B7_5374_8868[GetHandleId(_____82F1_96C4)]
    return record == nil or record["冷却中"] ~= true
end
--- 结束内部瞬移冷却，并清除 D 被动图标上的模拟冷却显示。
local function _____7ED3_675F_77AC_79FB_51B7_5374(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local id = GetHandleId(_____82F1_96C4)
    local record = _____77AC_79FB_51B7_5374_8868[id]
    if record ~= nil then
        record["冷却中"] = false
        record["计时器ID"] = 0
    end
    _____767B_8BB0_88AB_52A8_6280_80FD_51B7_5374(_____82F1_96C4, ____D_88AB_52A8_6280_80FDID, 0)
end
--- 启用 3 秒内部瞬移冷却，并在常驻 A0GW 被动图标上显示倒计时。
____exports["启用瞬移冷却"] = function(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    local record = _____77AC_79FB_51B7_5374_8868[id]
    if record == nil or record["英雄"] ~= _____82F1_96C4 then
        record = {["英雄"] = _____82F1_96C4, ["冷却中"] = false, ["计时器ID"] = 0}
        _____77AC_79FB_51B7_5374_8868[id] = record
    end
    if record["计时器ID"] ~= 0 then
        removeDelayedCallback(record["计时器ID"])
    end
    record["冷却中"] = true
    _____767B_8BB0_88AB_52A8_6280_80FD_51B7_5374(_____82F1_96C4, ____D_88AB_52A8_6280_80FDID, _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["瞬移冷却秒"])
    record["计时器ID"] = addDelayedCallback(
        _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["瞬移冷却秒"] * 1000,
        function()
            local current = _____77AC_79FB_51B7_5374_8868[id]
            if current == nil then
                return
            end
            current["计时器ID"] = 0
            _____7ED3_675F_77AC_79FB_51B7_5374(current["英雄"])
            _____77AC_79FB_51B7_5374_8868[id] = nil
        end
    )
end
--- 刷新瞬移就绪（Q/W 施法与创建分身时调用）：
-- 保留源 JASS 的立即刷新语义，但只清内部状态和 QWERD 模拟冷却。
____exports["刷新瞬移就绪"] = function(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    local record = _____77AC_79FB_51B7_5374_8868[id]
    if record ~= nil and record["计时器ID"] ~= 0 then
        removeDelayedCallback(record["计时器ID"])
        record["计时器ID"] = 0
    end
    if record ~= nil then
        record["冷却中"] = false
    end
    _____767B_8BB0_88AB_52A8_6280_80FD_51B7_5374(_____82F1_96C4, ____D_88AB_52A8_6280_80FDID, 0)
end
local _____5206_8EAB_5F85_843D_5730_8868 = {}
--- 当前正在创建分身的佐佐木本体（SFB 幻象召唤事件的召唤单位是全局马甲，无法从召唤单位反推本体）
local _____5F53_524D_521B_5EFA_5206_8EAB_7684_82F1_96C4 = nil
local function _____5206_8EAB_5165_573A_5904_7406(_____5206_8EAB, _____8BB0_5F55)
    X_SetUnitMovableSafe(_____5206_8EAB, false)
    if type(japi.EXSetUnitCollisionType) == "function" then
        japi.EXSetUnitCollisionType(false, _____5206_8EAB, 1)
    end
    _____6DFB_52A0_5355_4F4D_6682_505C(_____5206_8EAB, _____5206_8EAB_5165_573A_6682_505C_6765_6E90)
    SetUnitX(_____5206_8EAB, _____8BB0_5F55["落点X"])
    SetUnitY(_____5206_8EAB, _____8BB0_5F55["落点Y"])
    _____64AD_653E_4F50_4F50_6728_914D_7F6E_52A8_4F5C(_____5206_8EAB, 9, 1.2)
    if _____8BB0_5F55["行为"] == "W落地" then
        local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.W
        ____exports["佐佐木扇形伤害"](
            _____8BB0_5F55["英雄"],
            GetUnitX(_____5206_8EAB),
            GetUnitY(_____5206_8EAB),
            _____8BB0_5F55["朝向"],
            cfg["命中范围"],
            cfg["扇形半角"],
            cfg["攻击力倍率"],
            _____8BB0_5F55["技能ID"],
            "佐佐木小次郎-后撤斩",
            cfg["命中特效模型"],
            cfg["命中特效缩放"],
            0
        )
        local ____require_result_15 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00A．表现工具")
        local _____64AD_653E_4F50_4F50_6728_5355_4F4D_97F3_6548 = ____require_result_15["播放佐佐木单位音效"]
        _____64AD_653E_4F50_4F50_6728_5355_4F4D_97F3_6548(_____5206_8EAB, cfg["分身命中音效路径"], cfg["分身命中音效裁断"])
    end
    addDelayedCallback(
        1000,
        function()
            if _____5206_8EAB == nil or _____5206_8EAB == 0 then
                return
            end
            jass.SetUnitTimeScale(_____5206_8EAB, 1)
            _____79FB_9664_5355_4F4D_6682_505C(_____5206_8EAB, _____5206_8EAB_5165_573A_6682_505C_6765_6E90)
        end
    )
end
local function ____on_4F50_4F50_6728_5206_8EAB_53EC_5524(_____88AB_53EC_5524_5355_4F4D, _____53EC_5524_5355_4F4D)
    if _____88AB_53EC_5524_5355_4F4D == nil or _____88AB_53EC_5524_5355_4F4D == 0 then
        return
    end
    local _____662F_5E7B_8C61 = IsUnitIllusion(_____88AB_53EC_5524_5355_4F4D)
    local _____7C7B_578B_5339_914D = GetUnitTypeId(_____88AB_53EC_5524_5355_4F4D) == _____4F50_4F50_6728_5355_4F4D_7C7B_578BID
    if not _____662F_5E7B_8C61 then
        return
    end
    if not _____7C7B_578B_5339_914D then
        return
    end
    local _____82F1_96C4 = _____5F53_524D_521B_5EFA_5206_8EAB_7684_82F1_96C4
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    if not ____exports["是佐佐木本体"](_____82F1_96C4) then
        return
    end
    local id = GetHandleId(_____82F1_96C4)
    local _____8BB0_5F55 = _____5206_8EAB_5F85_843D_5730_8868[id]
    if _____8BB0_5F55 == nil then
        return
    end
    _____5206_8EAB_5F85_843D_5730_8868[id] = nil
    _____5206_8EAB_5165_573A_5904_7406(_____88AB_53EC_5524_5355_4F4D, _____8BB0_5F55)
end
_____6CE8_518C_53EC_5524_76D1_542C(____on_4F50_4F50_6728_5206_8EAB_53EC_5524)
--- 创建佐佐木分身（输出 10% 攻击 / 承伤 400%，持续 3 秒）
-- 行为决定分身落点与是否结算落地伤害。
____exports["创建佐佐木分身"] = function(_____82F1_96C4, _____843D_70B9X, _____843D_70B9Y, _____671D_5411, _____884C_4E3A, _____6280_80FDID)
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D
    ____exports["注册佐佐木英雄"](_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    _____5206_8EAB_5F85_843D_5730_8868[id] = {
        ["英雄"] = _____82F1_96C4,
        ["落点X"] = _____843D_70B9X,
        ["落点Y"] = _____843D_70B9Y,
        ["朝向"] = _____671D_5411,
        ["行为"] = _____884C_4E3A,
        ["技能ID"] = _____6280_80FDID
    }
    _____5F53_524D_521B_5EFA_5206_8EAB_7684_82F1_96C4 = _____82F1_96C4
    local ok = SFB_setItemIllusion(
        _____82F1_96C4,
        _____82F1_96C4,
        cfg["分身持续秒"],
        cfg["分身输出倍率"],
        cfg["分身承伤倍率"]
    )
    _____5F53_524D_521B_5EFA_5206_8EAB_7684_82F1_96C4 = nil
    if not ok then
        _____5206_8EAB_5F85_843D_5730_8868[id] = nil
        return false
    end
    addDelayedCallback(
        1500,
        function()
            if _____5206_8EAB_5F85_843D_5730_8868[id] ~= nil then
                _____5206_8EAB_5F85_843D_5730_8868[id] = nil
            end
        end
    )
    ____exports["刷新瞬移就绪"](_____82F1_96C4)
    _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548(
        _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.Q["创建分身音效路径"],
        GetUnitX(_____82F1_96C4),
        GetUnitY(_____82F1_96C4),
        _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.Q["创建分身音效裁断"]
    )
    return true
end
--- 分身判定：目标是否为佐佐木的可换位分身（幻象 Buff + 同类型 + 存活）
____exports["是佐佐木分身"] = function(_____82F1_96C4, _____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 or _____76EE_6807 == _____82F1_96C4 then
        return false
    end
    if not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return false
    end
    if not IsUnitIllusion(_____76EE_6807) then
        return false
    end
    if GetUnitTypeId(_____76EE_6807) ~= _____4F50_4F50_6728_5355_4F4D_7C7B_578BID then
        return false
    end
    local ____require_result_16 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
    local _____5355_4F4D_62E5_6709_539F_751FBuff = ____require_result_16["单位拥有原生Buff"]
    return _____5355_4F4D_62E5_6709_539F_751FBuff(_____76EE_6807, _____5E7B_8C61BuffID)
end
local _____666E_653B_8BA1_6570_8868 = {}
local function ____on_4F50_4F50_6728_666E_653B_547D_4E2D(ctx)
    local ____opt_result_19
    if ctx ~= nil then
        ____opt_result_19 = ctx.source
    end
    local source = ____opt_result_19
    if not ____exports["是佐佐木本体"](source) then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(source) then
        return
    end
    local ____opt_result_22
    if ctx ~= nil then
        ____opt_result_22 = ctx.target
    end
    local target = ____opt_result_22
    if target == nil or target == 0 then
        return
    end
    local id = GetHandleId(source)
    ____exports["注册佐佐木英雄"](source)
    local count = (_____666E_653B_8BA1_6570_8868[id] or 0) + 1
    if count < _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["普攻创建分身次数"] then
        _____666E_653B_8BA1_6570_8868[id] = count
        return
    end
    _____666E_653B_8BA1_6570_8868[id] = 0
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D
    local _____6307_5411_89D2_5EA6 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(source),
        GetUnitY(source),
        GetUnitX(target),
        GetUnitY(target)
    )
    local _____8EAB_540EX = _____6781_5750_6807X(
        GetUnitX(target),
        _____6307_5411_89D2_5EA6,
        cfg["普攻分身后方距离"]
    )
    local _____8EAB_540EY = _____6781_5750_6807Y(
        GetUnitY(target),
        _____6307_5411_89D2_5EA6,
        cfg["普攻分身后方距离"]
    )
    ____exports["创建佐佐木分身"](
        source,
        _____8EAB_540EX,
        _____8EAB_540EY,
        _____6307_5411_89D2_5EA6,
        "身后",
        ____D_88AB_52A8_6280_80FDID
    )
end
_____6CE8_518C_666E_653B_653B_51FB_6548_679C_76D1_542C({
    ["名称"] = "佐佐木小次郎-普攻计数",
    ["条件"] = function(ctx)
        local ____exports__662F_4F50_4F50_6728_672C_4F53_26 = ____exports["是佐佐木本体"]
        local ____opt_result_25
        if ctx ~= nil then
            ____opt_result_25 = ctx.source
        end
        return ____exports__662F_4F50_4F50_6728_672C_4F53_26(____opt_result_25)
    end,
    ["命中后"] = ____on_4F50_4F50_6728_666E_653B_547D_4E2D
})
return ____exports
