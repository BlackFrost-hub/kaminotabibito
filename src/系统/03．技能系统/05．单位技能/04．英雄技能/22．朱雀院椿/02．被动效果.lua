local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local _____5237_65B0VF_8868_73B0, _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548, _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548, _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI, _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, Sound3DII_UnitPlayReuse, debugLogForce, ____VF_573ABuffID, ____VF_6B8B_7F3ABuffID, _____88AB_52A8_914D_7F6E, GetOwningPlayer, GetPlayerId, GetUnitX, GetUnitY, ____VF_7279_6548_952E
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.00．配置")
local _____6731_96C0_9662_693F_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿技能配置"]
local _____6731_96C0_9662_693F_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿表现配置"]
local _____6731_96C0_9662_693FBuff_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿Buff配置"]
local _____6731_96C0_9662_693F_88AB_52A8_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿被动配置"]
local _____6731_96C0_9662_693F_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿音效配置"]
local _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿读条配置"]
function _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
    local _____6B8B_7F3A = _____72B6_6001["VF当前"] <= 0 or _____72B6_6001["VF当前"] < _____88AB_52A8_914D_7F6E["VF上限"] * _____88AB_52A8_914D_7F6E["VF残缺阈值"]
    local _____4E4B_524D_6B8B_7F3A = _____72B6_6001["VF残缺"]
    _____72B6_6001["VF残缺"] = _____6B8B_7F3A
    if _____6B8B_7F3A ~= _____4E4B_524D_6B8B_7F3A then
        debugLogForce(
            "椿-被动",
            "VF",
            "状态",
            _____6B8B_7F3A and "残缺进入" or "残缺恢复",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____82F1_96C4)) + 1,
            "当前VF",
            _____72B6_6001["VF当前"]
        )
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, ____VF_573ABuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, ____VF_6B8B_7F3ABuffID)
    if _____72B6_6001["VF读条UI"] == nil then
        _____72B6_6001["VF读条UI"] = _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI({
            X = GetUnitX(_____82F1_96C4),
            Y = GetUnitY(_____82F1_96C4),
            Z = 0,
            ["跟随单位"] = _____82F1_96C4,
            ["跟随Z偏移"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["跟随Z偏移"],
            ["屏幕Y偏移"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["VF读条"]["屏幕Y偏移"],
            ["最大值"] = _____88AB_52A8_914D_7F6E["VF上限"],
            ["当前值"] = _____72B6_6001["VF当前"],
            ["标题"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["VF读条"]["标题"],
            ["数值后缀"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["VF读条"]["数值后缀"],
            ["类型"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["VF读条"]["UI类型"],
            ["平滑过渡秒"] = 0.05,
            ["初始显示"] = true
        })
    else
        _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(_____72B6_6001["VF读条UI"], _____72B6_6001["VF当前"])
    end
    if _____72B6_6001["VF当前"] <= 0 then
        if _____72B6_6001["护盾已展开"] then
            _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____82F1_96C4, ____VF_7279_6548_952E)
            _____72B6_6001["护盾已展开"] = false
        end
    elseif _____72B6_6001["护盾已展开"] then
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____82F1_96C4, ____VF_7279_6548_952E)
        _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
            _____82F1_96C4,
            _____6B8B_7F3A and _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF残缺"]["模型路径"] or _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF完整"]["模型路径"],
            ____VF_7279_6548_952E,
            _____6B8B_7F3A and _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF残缺"]["缩放"] or _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF完整"]["缩放"],
            _____6B8B_7F3A and _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF残缺"]["高度"] or _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF完整"]["高度"],
            1,
            nil,
            0,
            _____6B8B_7F3A and _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF残缺"].RGB or _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["VF完整"].RGB
        )
    end
    if _____72B6_6001["VF当前"] > 0 then
        if _____6B8B_7F3A then
            registerManualBuff(
                _____82F1_96C4,
                ____VF_6B8B_7F3ABuffID,
                9999,
                1,
                {stack = 1}
            )
        else
            registerManualBuff(
                _____82F1_96C4,
                ____VF_573ABuffID,
                9999,
                _____72B6_6001["VF当前"],
                {stack = 1}
            )
            if _____4E4B_524D_6B8B_7F3A and _____72B6_6001["护盾已展开"] then
                Sound3DII_UnitPlayReuse(_____6731_96C0_9662_693F_97F3_6548_914D_7F6E["VF展开"]["路径"], _____82F1_96C4, _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["VF展开"]["裁断距离"])
            end
        end
    end
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local registerPlayerHeroListener = ____require_result_3.registerPlayerHeroListener
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_4.registerAppliedFinalDamageListener
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_6.registerDamageModifier
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_7["造成技能伤害"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____require_result_9["两点角度"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_10["创建单位坐标跟随特效"]
_____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_10["销毁单位坐标跟随特效"]
local ____require_result_11 = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI")
_____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_11["创建世界坐标进度UI"]
_____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_11["更新世界坐标进度UI"]
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_11["销毁世界坐标进度UI"]
local ____require_result_12 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_12.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_12["移除单位指定Buff"]
local ____require_result_13 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
Sound3DII_UnitPlayReuse = ____require_result_13.Sound3DII_UnitPlayReuse
local ____require_result_14 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_14.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"])
____VF_573ABuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["VF场"]
____VF_6B8B_7F3ABuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["VF残缺"]
local _____53CD_51FB_51C6_5907BuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["反击准备"]
local _____4E00_5200BuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["一刀守势"]
local _____4E8C_5200BuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["二刀攻势"]
_____88AB_52A8_914D_7F6E = _____6731_96C0_9662_693F_88AB_52A8_914D_7F6E
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
GetOwningPlayer = jass.GetOwningPlayer
GetPlayerId = jass.GetPlayerId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local _____82F1_96C4_72B6_6001_8868 = {}
____VF_7279_6548_952E = "朱雀院椿VF场"
local _____59FF_6001_7279_6548_952E = "朱雀院椿姿态"
local function _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {
            ["VF当前"] = _____88AB_52A8_914D_7F6E["VF上限"],
            ["VF残缺"] = false,
            ["VF归零透传已告警"] = false,
            ["护盾已展开"] = false,
            ["VF读条UI"] = nil,
            ["反击准备到期"] = 0,
            ["反击准备方向"] = 0,
            ["反击准备来源"] = nil,
            ["姿态"] = "一刀",
            ["决斗距离到期"] = 0,
            ["决斗距离方向"] = 0,
            ["决斗距离目标单位"] = nil,
            ["决斗距离目标X"] = 0,
            ["决斗距离目标Y"] = 0,
            ["VF恢复冷却到期"] = 0,
            ["姿态锁"] = false,
            ["技能清理表"] = {}
        }
        _____82F1_96C4_72B6_6001_8868[id] = _____72B6_6001
        _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
        debugLogForce(
            "椿-被动",
            "Buff",
            "操作",
            "施加",
            "目标",
            GetHandleId(_____82F1_96C4),
            "Buff",
            _____4E00_5200BuffID
        )
        registerManualBuff(
            _____82F1_96C4,
            _____4E00_5200BuffID,
            9999,
            1,
            {stack = 1}
        )
    end
    return _____72B6_6001
end
--- 是否是朱雀院椿
____exports["是朱雀院椿"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return jass.GetUnitTypeId(unit) == _____82F1_96C4_5355_4F4D_7C7B_578BID
end
--- 登记技能清理函数（Q/W/E/R/D 模块调用；死亡/场景清理统一执行，幂等）
____exports["登记椿清理"] = function(_____82F1_96C4, _____540D_79F0, _____6E05_7406)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)["技能清理表"][_____540D_79F0] = _____6E05_7406
end
--- 幂等统一清理：死亡/复活重置/重复初始化/场景清理
____exports["清理朱雀院椿状态"] = function(_____82F1_96C4, ______539F_56E0)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local id = GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return
    end
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetHandleId(_____82F1_96C4),
        "Buff",
        ____VF_573ABuffID
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, ____VF_573ABuffID)
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetHandleId(_____82F1_96C4),
        "Buff",
        ____VF_6B8B_7F3ABuffID
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, ____VF_6B8B_7F3ABuffID)
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetHandleId(_____82F1_96C4),
        "Buff",
        _____53CD_51FB_51C6_5907BuffID
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____53CD_51FB_51C6_5907BuffID)
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetHandleId(_____82F1_96C4),
        "Buff",
        _____4E00_5200BuffID
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4E00_5200BuffID)
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetHandleId(_____82F1_96C4),
        "Buff",
        _____4E8C_5200BuffID
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4E8C_5200BuffID)
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____82F1_96C4, ____VF_7279_6548_952E)
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____82F1_96C4, _____59FF_6001_7279_6548_952E)
    if _____72B6_6001["VF读条UI"] ~= nil then
        _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(_____72B6_6001["VF读条UI"])
        _____72B6_6001["VF读条UI"] = nil
    end
    for key in pairs(_____72B6_6001["技能清理表"]) do
        local _____6E05_7406 = _____72B6_6001["技能清理表"][key]
        if _____6E05_7406 ~= nil then
            _____6E05_7406()
        end
    end
    __TS__Delete(_____82F1_96C4_72B6_6001_8868, id)
end
____exports["获取VF"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return 0
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and _____72B6_6001["VF当前"] or 0
end
--- 初始化/重置 VF 到上限（死亡重置/复活/场景清理后重建状态时调用）
____exports["初始化VF"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    _____72B6_6001["VF当前"] = _____88AB_52A8_914D_7F6E["VF上限"]
    _____72B6_6001["VF残缺"] = false
    _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
end
--- 恢复 VF（内部冷却：任何入口都不能靠攻速无限回满）；成功返回 true
____exports["恢复VF"] = function(_____82F1_96C4, _____91CF)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____91CF <= 0 then
        return false
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    local _____73B0_5728 = getGameTime()
    if _____73B0_5728 < _____72B6_6001["VF恢复冷却到期"] then
        debugLogForce(
            "椿-被动",
            "VF",
            "操作",
            "恢复失败",
            "原因",
            "内部冷却",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____82F1_96C4)) + 1,
            "量",
            _____91CF
        )
        return false
    end
    _____72B6_6001["VF恢复冷却到期"] = _____73B0_5728 + _____88AB_52A8_914D_7F6E["VF恢复冷却秒"]
    _____72B6_6001["VF当前"] = _____72B6_6001["VF当前"] + _____91CF > _____88AB_52A8_914D_7F6E["VF上限"] and _____88AB_52A8_914D_7F6E["VF上限"] or _____72B6_6001["VF当前"] + _____91CF
    _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
    debugLogForce(
        "椿-被动",
        "VF",
        "操作",
        "恢复",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____82F1_96C4)) + 1,
        "量",
        _____91CF,
        "当前VF",
        _____72B6_6001["VF当前"]
    )
    return true
end
--- 扣除 VF（二刀持续消耗等）；返回扣除后的剩余
____exports["扣除VF"] = function(_____82F1_96C4, _____91CF)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____91CF <= 0 then
        return 0
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    _____72B6_6001["VF当前"] = _____72B6_6001["VF当前"] - _____91CF < 0 and 0 or _____72B6_6001["VF当前"] - _____91CF
    _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
    return _____72B6_6001["VF当前"]
end
local ____VF_4FEE_6539_5668ID = 0
local function _____6CE8_518CVF_5438_6536()
    if ____VF_4FEE_6539_5668ID ~= 0 then
        return
    end
    ____VF_4FEE_6539_5668ID = registerDamageModifier(
        function(context)
            local ____temp_15
            if context ~= nil then
                ____temp_15 = context.target
            else
                ____temp_15 = nil
            end
            local _____5355_4F4D = ____temp_15
            if not ____exports["是朱雀院椿"](_____5355_4F4D) then
                return context.currentDamage
            end
            local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____5355_4F4D)
            if _____72B6_6001["VF当前"] <= 0 then
                if not _____72B6_6001["VF归零透传已告警"] then
                    _____72B6_6001["VF归零透传已告警"] = true
                    debugLogForce(
                        "椿-被动",
                        "VF",
                        "状态",
                        "归零透传",
                        "玩家",
                        GetPlayerId(GetOwningPlayer(_____5355_4F4D)) + 1,
                        "第一次余伤",
                        context.currentDamage,
                        "剩余VF",
                        _____72B6_6001["VF当前"]
                    )
                end
                return context.currentDamage
            end
            if context.currentDamage <= 0 then
                return context.currentDamage
            end
            local _____5438_6536 = context.currentDamage > _____72B6_6001["VF当前"] and _____72B6_6001["VF当前"] or context.currentDamage
            _____72B6_6001["VF当前"] = _____72B6_6001["VF当前"] - _____5438_6536
            if not _____72B6_6001["护盾已展开"] then
                _____72B6_6001["护盾已展开"] = true
            end
            _____5237_65B0VF_8868_73B0(_____5355_4F4D, _____72B6_6001)
            debugLogForce(
                "椿-被动",
                "VF",
                "操作",
                "吸收",
                "玩家",
                GetPlayerId(GetOwningPlayer(_____5355_4F4D)) + 1,
                "吸收",
                _____5438_6536,
                "剩余VF",
                _____72B6_6001["VF当前"],
                "余伤",
                context.currentDamage - _____5438_6536
            )
            return context.currentDamage - _____5438_6536
        end,
        40
    )
end
____exports["有反击准备"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and getGameTime() <= _____72B6_6001["反击准备到期"]
end
--- 创建反击准备（1.2s 窗口；刷新时重置到期；Buff 同步）
____exports["创建反击准备"] = function(_____82F1_96C4, _____65B9_5411, _____6765_6E90)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    _____72B6_6001["反击准备到期"] = getGameTime() + _____88AB_52A8_914D_7F6E["反击准备持续秒"] * 1000
    _____72B6_6001["反击准备方向"] = _____65B9_5411
    local ____temp_16
    if _____6765_6E90 ~= nil and _____6765_6E90 ~= 0 then
        ____temp_16 = _____6765_6E90
    else
        ____temp_16 = nil
    end
    _____72B6_6001["反击准备来源"] = ____temp_16
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "施加",
        "目标",
        GetHandleId(_____82F1_96C4),
        "Buff",
        _____53CD_51FB_51C6_5907BuffID
    )
    registerManualBuff(
        _____82F1_96C4,
        _____53CD_51FB_51C6_5907BuffID,
        _____88AB_52A8_914D_7F6E["反击准备持续秒"],
        1,
        {stack = 1}
    )
end
--- 消费反击准备（普攻/Q/E 各最多一次；无或过期返回 null）
____exports["消费反击准备"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return nil
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    if _____72B6_6001 == nil then
        return nil
    end
    if getGameTime() > _____72B6_6001["反击准备到期"] then
        return nil
    end
    _____72B6_6001["反击准备到期"] = 0
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetHandleId(_____82F1_96C4),
        "Buff",
        _____53CD_51FB_51C6_5907BuffID
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____53CD_51FB_51C6_5907BuffID)
    return {["方向"] = _____72B6_6001["反击准备方向"], ["来源"] = _____72B6_6001["反击准备来源"]}
end
____exports["获取姿态"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return "一刀"
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and _____72B6_6001["姿态"] or "一刀"
end
--- 设置姿态（互斥 Buff/特效；切换前由 D 模块校验可切换性）
____exports["设置姿态"] = function(_____82F1_96C4, _____59FF_6001)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["姿态"] == _____59FF_6001 then
        return
    end
    _____72B6_6001["姿态"] = _____59FF_6001
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetHandleId(_____82F1_96C4),
        "Buff",
        _____4E00_5200BuffID
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4E00_5200BuffID)
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetHandleId(_____82F1_96C4),
        "Buff",
        _____4E8C_5200BuffID
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4E8C_5200BuffID)
    if _____59FF_6001 == "一刀" then
        debugLogForce(
            "椿-被动",
            "Buff",
            "操作",
            "施加",
            "目标",
            GetHandleId(_____82F1_96C4),
            "Buff",
            _____4E00_5200BuffID
        )
        registerManualBuff(
            _____82F1_96C4,
            _____4E00_5200BuffID,
            9999,
            1,
            {stack = 1}
        )
    else
        debugLogForce(
            "椿-被动",
            "Buff",
            "操作",
            "施加",
            "目标",
            GetHandleId(_____82F1_96C4),
            "Buff",
            _____4E8C_5200BuffID
        )
        registerManualBuff(
            _____82F1_96C4,
            _____4E8C_5200BuffID,
            9999,
            1,
            {stack = 1}
        )
    end
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____82F1_96C4, _____59FF_6001_7279_6548_952E)
    _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        _____82F1_96C4,
        _____59FF_6001 == "一刀" and _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D一刀守势"]["模型路径"] or _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D二刀攻势"]["模型路径"],
        _____59FF_6001_7279_6548_952E,
        _____59FF_6001 == "一刀" and _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D一刀守势"]["缩放"] or _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D二刀攻势"]["缩放"],
        _____59FF_6001 == "一刀" and _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D一刀守势"]["高度"] or _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D二刀攻势"]["高度"],
        1,
        nil,
        0,
        _____59FF_6001 == "一刀" and _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D一刀守势"].RGB or _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["D二刀攻势"].RGB
    )
end
--- R 蓄力期间锁定姿态（D 不得中途改写本次 R 分支）
____exports["锁定姿态"] = function(_____82F1_96C4, _____9501_5B9A)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)["姿态锁"] = _____9501_5B9A
    debugLogForce(
        "椿-被动",
        "状态",
        "姿态锁",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____82F1_96C4)) + 1,
        "锁定",
        _____9501_5B9A
    )
end
____exports["姿态是否锁定"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and _____72B6_6001["姿态锁"]
end
--- 设置决斗距离（默认 2.5s，供 R 读取方向/锚点）；规划明确该状态不进玩家 Buff 栏，仅维护内部数据
____exports["设置决斗距离"] = function(_____82F1_96C4, _____65B9_5411, _____6301_7EED_79D2, _____76EE_6807_5355_4F4D, _____515C_5E95X, _____515C_5E95Y)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    _____72B6_6001["决斗距离到期"] = getGameTime() + _____6301_7EED_79D2 * 1000
    _____72B6_6001["决斗距离方向"] = _____65B9_5411
    local ____76EE_6807_5355_4F4D_17 = _____76EE_6807_5355_4F4D
    if ____76EE_6807_5355_4F4D_17 == nil then
        ____76EE_6807_5355_4F4D_17 = nil
    end
    _____72B6_6001["决斗距离目标单位"] = ____76EE_6807_5355_4F4D_17
    _____72B6_6001["决斗距离目标X"] = _____515C_5E95X or 0
    _____72B6_6001["决斗距离目标Y"] = _____515C_5E95Y or 0
    local ____debugLogForce_20 = debugLogForce
    local ____array_19 = __TS__SparseArrayNew(
        "椿-被动",
        "状态",
        "决斗距离建立",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____82F1_96C4)) + 1,
        "方向",
        _____65B9_5411,
        "持续秒",
        _____6301_7EED_79D2,
        "目标单位"
    )
    local ____76EE_6807_5355_4F4D_18 = _____76EE_6807_5355_4F4D
    if ____76EE_6807_5355_4F4D_18 == nil then
        ____76EE_6807_5355_4F4D_18 = "-"
    end
    __TS__SparseArrayPush(____array_19, ____76EE_6807_5355_4F4D_18)
    ____debugLogForce_20(__TS__SparseArraySpread(____array_19))
end
____exports["有决斗距离"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and getGameTime() <= _____72B6_6001["决斗距离到期"]
end
____exports["获取决斗距离方向"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return 0
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and getGameTime() <= _____72B6_6001["决斗距离到期"] and _____72B6_6001["决斗距离方向"] or 0
end
--- 获取决斗距离的特效锚点：目标单位存活 → 该单位脚下；死亡 → E 目标点快照兜底；均无 → null
____exports["获取决斗距离锚点"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return nil
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    if _____72B6_6001 == nil or getGameTime() > _____72B6_6001["决斗距离到期"] then
        return nil
    end
    local _____5355_4F4D = _____72B6_6001["决斗距离目标单位"]
    if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and _____5355_4F4D_5B58_6D3B(_____5355_4F4D) then
        return {
            X = GetUnitX(_____5355_4F4D),
            Y = GetUnitY(_____5355_4F4D)
        }
    end
    if _____72B6_6001["决斗距离目标X"] ~= 0 or _____72B6_6001["决斗距离目标Y"] ~= 0 then
        return {X = _____72B6_6001["决斗距离目标X"], Y = _____72B6_6001["决斗距离目标Y"]}
    end
    return nil
end
--- 清除决斗距离（R 终式读取方向后消费）
____exports["清除决斗距离"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["决斗距离到期"] = 0
    debugLogForce(
        "椿-被动",
        "状态",
        "决斗距离消费",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____82F1_96C4)) + 1
    )
end
local function _____5904_7406_693F_666E_653B_53CD_51FB_65A9(target, attacker, applied, snapshot)
    if not ____exports["是朱雀院椿"](attacker) then
        return
    end
    if snapshot == nil then
        return
    end
    if snapshot.isNormalAttack ~= true then
        return
    end
    if snapshot.isWrappedSkillDamage == true then
        return
    end
    if target == nil or target == 0 then
        return
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(attacker)]
    if _____72B6_6001 == nil then
        return
    end
    if getGameTime() > _____72B6_6001["反击准备到期"] then
        if _____72B6_6001["反击准备到期"] > 0 then
            _____72B6_6001["反击准备到期"] = 0
            debugLogForce(
                "椿-被动",
                "状态",
                "反击准备过期",
                "玩家",
                GetPlayerId(GetOwningPlayer(attacker)) + 1,
                "目标",
                GetUnitName(target),
                "handle",
                target
            )
        end
        return
    end
    _____72B6_6001["反击准备到期"] = 0
    debugLogForce(
        "椿-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetHandleId(attacker),
        "Buff",
        _____53CD_51FB_51C6_5907BuffID
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(attacker, _____53CD_51FB_51C6_5907BuffID)
    local _____53CD_51FB_65B9_5411 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(attacker),
        GetUnitY(attacker),
        GetUnitX(target),
        GetUnitY(target)
    )
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["普攻反击斩"]["模型路径"],
        RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["普攻反击斩"].RGB,
        X = GetUnitX(target),
        Y = GetUnitY(target),
        Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["普攻反击斩"]["高度"],
        ["面向角度"] = _____53CD_51FB_65B9_5411,
        ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["普攻反击斩"]["缩放"],
        ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["普攻反击斩"]["持续秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"]["模型路径"],
        RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"].RGB,
        X = GetUnitX(target),
        Y = GetUnitY(target),
        Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"]["高度"],
        ["面向角度"] = _____53CD_51FB_65B9_5411,
        ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"]["缩放"],
        ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"]["持续秒"]
    })
    local _____8FFD_52A0_4F24_5BB3 = applied * _____88AB_52A8_914D_7F6E["反击斩伤害倍率"]
    debugLogForce(
        "椿-被动",
        "命中",
        "标签",
        "朱雀院椿-反击斩",
        "玩家",
        GetPlayerId(GetOwningPlayer(attacker)) + 1,
        "目标",
        GetUnitName(target),
        "handle",
        target,
        "X",
        math.floor(GetUnitX(target)),
        "Y",
        math.floor(GetUnitY(target)),
        "伤害",
        _____8FFD_52A0_4F24_5BB3
    )
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = attacker,
        ["目标"] = target,
        ["伤害"] = _____8FFD_52A0_4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = 0,
        ["标签"] = "朱雀院椿-反击斩",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false
    })
    if _____72B6_6001["姿态"] == "一刀" then
        ____exports["恢复VF"](attacker, _____88AB_52A8_914D_7F6E["反击斩恢复VF"])
    else
        debugLogForce(
            "椿-被动",
            "命中",
            "标签",
            "朱雀院椿-反击斩二刀",
            "玩家",
            GetPlayerId(GetOwningPlayer(attacker)) + 1,
            "目标",
            GetUnitName(target),
            "handle",
            target,
            "X",
            math.floor(GetUnitX(target)),
            "Y",
            math.floor(GetUnitY(target)),
            "伤害",
            applied * _____88AB_52A8_914D_7F6E["二刀反击斩额外倍率"]
        )
        _____9020_6210_6280_80FD_4F24_5BB3({
            ["来源"] = attacker,
            ["目标"] = target,
            ["伤害"] = applied * _____88AB_52A8_914D_7F6E["二刀反击斩额外倍率"],
            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
            ["攻击类型"] = ATTACK_TYPE_NORMAL,
            ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["技能ID"] = 0,
            ["标签"] = "朱雀院椿-反击斩二刀",
            ["伤害形态"] = "单体",
            ["参与技能伤害加成"] = false
        })
    end
end
local _____5DF2_6CE8_518C = false
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____786E_4FDD_6B7B_4EA1_6E05_7406()
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(function(dyingUnit, _killingUnit)
        if dyingUnit == nil or dyingUnit == 0 then
            return
        end
        if ____exports["是朱雀院椿"](dyingUnit) then
            debugLogForce(
                "椿-被动",
                "回调",
                "类型",
                "死亡",
                "单位",
                GetHandleId(dyingUnit),
                "玩家",
                GetPlayerId(GetOwningPlayer(dyingUnit)) + 1
            )
            ____exports["清理朱雀院椿状态"](dyingUnit, "英雄死亡")
        end
    end)
end
--- 注册朱雀院椿被动（VF 吸收 + 普攻反击斩 + 死亡清理；幂等）
____exports["注册朱雀院椿被动"] = function()
    debugLogForce("椿-被动", "注册", "名称", "注册朱雀院椿被动")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____786E_4FDD_6B7B_4EA1_6E05_7406()
    registerPlayerHeroListener(function(_player, hero)
        if hero == nil or hero == 0 then
            return
        end
        if ____exports["是朱雀院椿"](hero) then
            debugLogForce(
                "椿-被动",
                "回调",
                "类型",
                "英雄注册",
                "单位",
                GetHandleId(hero),
                "玩家",
                GetPlayerId(GetOwningPlayer(hero)) + 1
            )
            ____exports["初始化VF"](hero)
        end
    end)
    _____6CE8_518CVF_5438_6536()
    registerAppliedFinalDamageListener(_____5904_7406_693F_666E_653B_53CD_51FB_65A9)
end
--- 播放椿施法动作（接收动作槽，索引/持续秒/播放速度全部配置驱动；0 跳过），持续后恢复 stand；随英雄清理移除恢复回调
____exports["播放椿动作"] = function(_____82F1_96C4, _____69FD)
    local _____52A8_4F5C_7D22_5F15 = _____69FD["索引"]
    local _____6301_7EED_79D2 = _____69FD["持续秒"]
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____52A8_4F5C_7D22_5F15 <= 0 then
        return
    end
    jass.SetUnitAnimationByIndex(_____82F1_96C4, _____52A8_4F5C_7D22_5F15)
    local _____64AD_653E_901F_5EA6 = _____69FD["播放速度"] ~= nil and _____69FD["播放速度"] > 0 and _____69FD["播放速度"] or 1
    if _____64AD_653E_901F_5EA6 ~= 1 then
        jass.SetUnitTimeScale(_____82F1_96C4, _____64AD_653E_901F_5EA6)
    end
    if _____6301_7EED_79D2 > 0 then
        local _____6062_590DID = addDelayedCallback(
            _____6301_7EED_79D2 * 1000,
            function()
                if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    if _____64AD_653E_901F_5EA6 ~= 1 then
                        jass.SetUnitTimeScale(_____82F1_96C4, 1)
                    end
                    jass.SetUnitAnimation(_____82F1_96C4, "stand")
                end
            end
        )
        ____exports["登记椿清理"](
            _____82F1_96C4,
            "椿动作-" .. tostring(_____52A8_4F5C_7D22_5F15),
            function()
                removeDelayedCallback(_____6062_590DID)
                if _____64AD_653E_901F_5EA6 ~= 1 and _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    jass.SetUnitTimeScale(_____82F1_96C4, 1)
                end
            end
        )
    end
end
____exports["朱雀院椿被动模块"] = {["英雄ID"] = _____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"], ["注册"] = ____exports["注册朱雀院椿被动"]}
return ____exports
