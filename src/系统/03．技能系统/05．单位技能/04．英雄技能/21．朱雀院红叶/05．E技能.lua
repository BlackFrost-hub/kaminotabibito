local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.00．配置")
local _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶技能配置"]
local _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶表现配置"]
local _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶音效配置"]
local _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院红叶动作槽"]
local _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C = ____00_FF0E_914D_7F6E["朱雀院红叶待平衡数值"]
local _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶读条配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local fourCCToStringSafe = ____require_result_0.fourCCToStringSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_3["开始硬直"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_4["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_4["查询战斗技能实例"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_5["造成技能伤害"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_6["两点角度"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____require_result_7["获取扇形区域单位"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI")
local _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_9["创建世界坐标进度UI"]
local _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_9["更新世界坐标进度UI"]
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_9["销毁世界坐标进度UI"]
local ____require_result_10 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_10.Sound3DII_CooPlayReuse
local ____require_result_11 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_11["播放英雄技能喊话"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.02．被动效果")
local _____65BD_52A0_6731_96C0_9662_7834_7EFD = ____require_result_12["施加朱雀院破绽"]
local _____5C1D_8BD5_6D88_8D39_4E00_5C42_5200_52BF = ____require_result_12["尝试消费一层刀势"]
local _____662F_6731_96C0_9662_7EA2_53F6 = ____require_result_12["是朱雀院红叶"]
local _____767B_8BB0_6731_96C0_9662_6E05_7406 = ____require_result_12["登记朱雀院清理"]
local _____64AD_653E_7EA2_53F6_52A8_4F5C = ____require_result_12["播放红叶动作"]
local _____8054_52A8D = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.07．D技能")
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_13.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E["单位类型ID"])
local ____E_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.E["技能ID"])
local ____E_914D_7F6E = _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C.E
local ____E_8F7B_65A9_97F3_6548 = _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E["E轻斩"]
local ____E_7EC8_7ED3_97F3_6548 = _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E["E终结"]
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetRandomInt = jass.GetRandomInt
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local _____5251_75D5_5E8F_53F7 = 0
local _____5251_75D5_8868 = {}
local _____82F1_96C4_5251_75D5_5217_8868 = {}
local function _____79FB_9664_5251_75D5(_____5251_75D5)
    if _____5251_75D5["到期回调ID"] ~= 0 then
        removeDelayedCallback(_____5251_75D5["到期回调ID"])
        _____5251_75D5["到期回调ID"] = 0
    end
    if _____5251_75D5["特效句柄"] ~= nil and _____5251_75D5["特效句柄"] ~= 0 then
        jass.DestroyEffect(_____5251_75D5["特效句柄"])
        _____5251_75D5["特效句柄"] = nil
    end
    __TS__Delete(_____5251_75D5_8868, _____5251_75D5["序号"])
    local _____82F1_96C4ID = jass.GetHandleId(_____5251_75D5["来源英雄"])
    local _____5217_8868 = _____82F1_96C4_5251_75D5_5217_8868[_____82F1_96C4ID]
    if _____5217_8868 ~= nil then
        local idx = __TS__ArrayIndexOf(_____5217_8868, _____5251_75D5["序号"])
        if idx >= 0 then
            __TS__ArraySplice(_____5217_8868, idx, 1)
        end
        if #_____5217_8868 <= 0 then
            __TS__Delete(_____82F1_96C4_5251_75D5_5217_8868, _____82F1_96C4ID)
        end
    end
end
local function _____521B_5EFA_5251_75D5(_____6765_6E90_82F1_96C4, X, Y, _____65B9_5411_89D2)
    debugLogForce(
        "红叶-E",
        "状态",
        "创建剑痕",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____6765_6E90_82F1_96C4)) + 1,
        "X",
        math.floor(X),
        "Y",
        math.floor(Y),
        "方向角",
        _____65B9_5411_89D2
    )
    _____5251_75D5_5E8F_53F7 = _____5251_75D5_5E8F_53F7 + 1
    local _____5E8F_53F7 = _____5251_75D5_5E8F_53F7
    local _____5251_75D5 = {
        ["序号"] = _____5E8F_53F7,
        ["来源英雄"] = _____6765_6E90_82F1_96C4,
        X = X,
        Y = Y,
        ["方向角"] = _____65B9_5411_89D2,
        ["已读取"] = false,
        ["到期回调ID"] = 0,
        ["特效句柄"] = nil
    }
    _____5251_75D5["到期回调ID"] = addDelayedCallback(
        ____E_914D_7F6E["剑痕持续秒"] * 1000,
        function()
            _____79FB_9664_5251_75D5(_____5251_75D5)
        end
    )
    _____5251_75D5_8868[_____5E8F_53F7] = _____5251_75D5
    local _____82F1_96C4ID = jass.GetHandleId(_____6765_6E90_82F1_96C4)
    local _____5217_8868 = _____82F1_96C4_5251_75D5_5217_8868[_____82F1_96C4ID]
    if _____5217_8868 == nil then
        _____5217_8868 = {}
        _____82F1_96C4_5251_75D5_5217_8868[_____82F1_96C4ID] = _____5217_8868
    end
    _____5217_8868[#_____5217_8868 + 1] = _____5E8F_53F7
    local ____E_5251_75D5_6A21_578B_8DEF_5F84 = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["E剑痕"]["模型路径"]
    if ____E_5251_75D5_6A21_578B_8DEF_5F84 ~= "" then
        _____5251_75D5["特效句柄"] = _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = ____E_5251_75D5_6A21_578B_8DEF_5F84,
            RGB = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["E剑痕"].RGB,
            X = X,
            Y = Y,
            Z = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["E剑痕"]["高度"],
            ["缩放"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["E剑痕"]["缩放"],
            ["持续秒"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["E剑痕"]["持续秒"]
        })
    end
    return _____5251_75D5
end
--- 读取最近一条有效 E 剑痕并锁定（Q/W/R 调用；同帧重复读取返回 null）
____exports["读取最近剑痕并锁定"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return nil
    end
    local _____5217_8868 = _____82F1_96C4_5251_75D5_5217_8868[jass.GetHandleId(_____82F1_96C4)]
    if _____5217_8868 == nil or #_____5217_8868 <= 0 then
        return nil
    end
    do
        local i = #_____5217_8868 - 1
        while i >= 0 do
            do
                local _____5251_75D5 = _____5251_75D5_8868[_____5217_8868[i + 1]]
                if _____5251_75D5 == nil then
                    __TS__ArraySplice(_____5217_8868, i, 1)
                    goto __continue16
                end
                if _____5251_75D5["已读取"] then
                    goto __continue16
                end
                _____5251_75D5["已读取"] = true
                return _____5251_75D5
            end
            ::__continue16::
            i = i - 1
        end
    end
    return nil
end
--- 清理指定英雄的全部剑痕（死亡/场景清理）
____exports["清理英雄剑痕"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____5217_8868 = _____82F1_96C4_5251_75D5_5217_8868[jass.GetHandleId(_____82F1_96C4)]
    if _____5217_8868 == nil then
        return
    end
    local _____526F_672C = __TS__ArraySlice(_____5217_8868, 0)
    do
        local i = 0
        while i < #_____526F_672C do
            local _____5251_75D5 = _____5251_75D5_8868[_____526F_672C[i + 1]]
            if _____5251_75D5 ~= nil then
                _____79FB_9664_5251_75D5(_____5251_75D5)
            end
            i = i + 1
        end
    end
end
local function _____7ED3_7B97E_6BB5_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____6280_80FD_5B9E_4F8BID, _____4F24_5BB3_503C, _____6807_7B7E)
    debugLogForce(
        "红叶-E",
        "伤害",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "X",
        math.floor(GetUnitX(_____76EE_6807)),
        "Y",
        math.floor(GetUnitY(_____76EE_6807)),
        "伤害",
        math.floor(_____4F24_5BB3_503C),
        "标签",
        _____6807_7B7E,
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-"
    )
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3_503C,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____E_6280_80FDID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = _____6807_7B7E,
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true
    })
    _____65BD_52A0_6731_96C0_9662_7834_7EFD(_____65BD_6CD5_8005, _____76EE_6807)
end
local function _____53D6_6BB5_6247_5F62_654C_4EBA(_____65BD_6CD5_8005, _____6570_636E, _____534A_5F84, _____89D2_5EA6)
    return _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = _____6570_636E["目标X"],
        Y = _____6570_636E["目标Y"],
        ["半径"] = _____534A_5F84,
        ["方向角"] = _____6570_636E["方向角"],
        ["扇形角度"] = _____89D2_5EA6,
        ["单位筛选"] = function(_____5355_4F4D)
            return _____5355_4F4D ~= _____65BD_6CD5_8005 and _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and jass.IsUnitEnemy(
                _____5355_4F4D,
                jass.GetOwningPlayer(_____65BD_6CD5_8005)
            )
        end
    })
end
local function _____521B_5EFAE_53E0_52A0_65A9_5149(_____914D_7F6E, X, Y, _____65B9_5411_89D2)
    local ____521B_5EFA_70B9_7279_6548_21 = _____521B_5EFA_70B9_7279_6548
    local ____914D_7F6E__6A21_578B_8DEF_5F84_15 = _____914D_7F6E["模型路径"]
    local ____914D_7F6E_RGB_16 = _____914D_7F6E.RGB
    local ____X_17 = X
    local ____Y_18 = Y
    local ____914D_7F6E__9AD8_5EA6_19 = _____914D_7F6E["高度"]
    local ____GetRandomInt_result_20 = GetRandomInt(0, 359)
    local ____914D_7F6E__53E0_52A0_7F29_653E_14 = _____914D_7F6E["叠加缩放"]
    if ____914D_7F6E__53E0_52A0_7F29_653E_14 == nil then
        ____914D_7F6E__53E0_52A0_7F29_653E_14 = _____914D_7F6E["缩放"]
    end
    ____521B_5EFA_70B9_7279_6548_21({
        ["模型路径"] = ____914D_7F6E__6A21_578B_8DEF_5F84_15,
        RGB = ____914D_7F6E_RGB_16,
        X = ____X_17,
        Y = ____Y_18,
        Z = ____914D_7F6E__9AD8_5EA6_19,
        ["面向角度"] = ____GetRandomInt_result_20,
        ["动画索引"] = 0,
        ["缩放"] = ____914D_7F6E__53E0_52A0_7F29_653E_14,
        ["持续秒"] = _____914D_7F6E["持续秒"]
    })
    if _____914D_7F6E["叠加模型路径"] ~= nil and _____914D_7F6E["叠加模型路径"] ~= "" then
        local ____521B_5EFA_70B9_7279_6548_29 = _____521B_5EFA_70B9_7279_6548
        local ____914D_7F6E__53E0_52A0_6A21_578B_8DEF_5F84_23 = _____914D_7F6E["叠加模型路径"]
        local ____914D_7F6E_RGB_24 = _____914D_7F6E.RGB
        local ____X_25 = X
        local ____Y_26 = Y
        local ____914D_7F6E__9AD8_5EA6_27 = _____914D_7F6E["高度"]
        local ____GetRandomInt_result_28 = GetRandomInt(0, 359)
        local ____914D_7F6E__53E0_52A0_7F29_653E_22 = _____914D_7F6E["叠加缩放"]
        if ____914D_7F6E__53E0_52A0_7F29_653E_22 == nil then
            ____914D_7F6E__53E0_52A0_7F29_653E_22 = _____914D_7F6E["缩放"]
        end
        ____521B_5EFA_70B9_7279_6548_29({
            ["模型路径"] = ____914D_7F6E__53E0_52A0_6A21_578B_8DEF_5F84_23,
            RGB = ____914D_7F6E_RGB_24,
            X = ____X_25,
            Y = ____Y_26,
            Z = ____914D_7F6E__9AD8_5EA6_27,
            ["面向角度"] = ____GetRandomInt_result_28,
            ["动画索引"] = 0,
            ["缩放"] = ____914D_7F6E__53E0_52A0_7F29_653E_22,
            ["持续秒"] = _____914D_7F6E["持续秒"]
        })
    end
end
local function _____6267_884CE_4E00_6BB5(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    _____6570_636E["已斩段数"] = 1
    _____521B_5EFAE_53E0_52A0_65A9_5149(_____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["E第一斩"], _____6570_636E["目标X"], _____6570_636E["目标Y"], _____6570_636E["方向角"])
    Sound3DII_CooPlayReuse(
        ____E_8F7B_65A9_97F3_6548["路径"],
        _____6570_636E["目标X"],
        _____6570_636E["目标Y"],
        ____E_8F7B_65A9_97F3_6548["高度"],
        ____E_8F7B_65A9_97F3_6548["裁断距离"]
    )
    local _____654C_4EBA = _____53D6_6BB5_6247_5F62_654C_4EBA(_____65BD_6CD5_8005, _____6570_636E, ____E_914D_7F6E["第一斩半径"], ____E_914D_7F6E["第一斩扇形角度"])
    do
        local i = 0
        while i < #_____654C_4EBA do
            do
                local id = jass.GetHandleId(_____654C_4EBA[i + 1])
                local _____6B21_6570 = _____6570_636E["同目标次数"][id] or 0
                if _____6B21_6570 >= ____E_914D_7F6E["同目标最大次数"] then
                    goto __continue32
                end
                _____6570_636E["同目标次数"][id] = _____6B21_6570 + 1
                _____7ED3_7B97E_6BB5_4F24_5BB3(
                    _____65BD_6CD5_8005,
                    _____654C_4EBA[i + 1],
                    _____6280_80FD_5B9E_4F8BID,
                    _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____E_914D_7F6E["第一斩攻击力倍率"],
                    "朱雀院红叶-E第一斩"
                )
            end
            ::__continue32::
            i = i + 1
        end
    end
end
local function _____6267_884CE_4E8C_6BB5(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    _____6570_636E["已斩段数"] = 2
    _____521B_5EFAE_53E0_52A0_65A9_5149(_____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["E第二斩"], _____6570_636E["目标X"], _____6570_636E["目标Y"], _____6570_636E["方向角"])
    Sound3DII_CooPlayReuse(
        ____E_8F7B_65A9_97F3_6548["路径"],
        _____6570_636E["目标X"],
        _____6570_636E["目标Y"],
        ____E_8F7B_65A9_97F3_6548["高度"],
        ____E_8F7B_65A9_97F3_6548["裁断距离"]
    )
    local _____654C_4EBA = _____53D6_6BB5_6247_5F62_654C_4EBA(_____65BD_6CD5_8005, _____6570_636E, ____E_914D_7F6E["第二斩半径"], ____E_914D_7F6E["第二斩扇形角度"])
    do
        local i = 0
        while i < #_____654C_4EBA do
            do
                local id = jass.GetHandleId(_____654C_4EBA[i + 1])
                local _____6B21_6570 = _____6570_636E["同目标次数"][id] or 0
                if _____6B21_6570 >= ____E_914D_7F6E["同目标最大次数"] then
                    goto __continue36
                end
                _____6570_636E["同目标次数"][id] = _____6B21_6570 + 1
                _____7ED3_7B97E_6BB5_4F24_5BB3(
                    _____65BD_6CD5_8005,
                    _____654C_4EBA[i + 1],
                    _____6280_80FD_5B9E_4F8BID,
                    _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____E_914D_7F6E["第二斩攻击力倍率"],
                    "朱雀院红叶-E第二斩"
                )
            end
            ::__continue36::
            i = i + 1
        end
    end
end
local function _____6267_884CE_4E09_6BB5(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    _____6570_636E["已斩段数"] = 3
    _____521B_5EFAE_53E0_52A0_65A9_5149(_____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["E第三斩"], _____6570_636E["目标X"], _____6570_636E["目标Y"], _____6570_636E["方向角"])
    local _____5019_9009 = ____E_7EC8_7ED3_97F3_6548["候选路径"]
    local _____7EC8_7ED3_8DEF_5F84 = _____5019_9009 ~= nil and #_____5019_9009 > 0 and _____5019_9009[GetRandomInt(1, #_____5019_9009)] or ____E_7EC8_7ED3_97F3_6548["路径"]
    Sound3DII_CooPlayReuse(
        _____7EC8_7ED3_8DEF_5F84,
        _____6570_636E["目标X"],
        _____6570_636E["目标Y"],
        ____E_7EC8_7ED3_97F3_6548["高度"],
        ____E_7EC8_7ED3_97F3_6548["裁断距离"]
    )
    local _____654C_4EBA = _____53D6_6BB5_6247_5F62_654C_4EBA(_____65BD_6CD5_8005, _____6570_636E, ____E_914D_7F6E["第三斩半径"], ____E_914D_7F6E["第三斩扇形角度"])
    do
        local i = 0
        while i < #_____654C_4EBA do
            do
                local id = jass.GetHandleId(_____654C_4EBA[i + 1])
                local _____6B21_6570 = _____6570_636E["同目标次数"][id] or 0
                if _____6B21_6570 >= ____E_914D_7F6E["同目标最大次数"] then
                    goto __continue40
                end
                _____6570_636E["同目标次数"][id] = _____6B21_6570 + 1
                _____7ED3_7B97E_6BB5_4F24_5BB3(
                    _____65BD_6CD5_8005,
                    _____654C_4EBA[i + 1],
                    _____6280_80FD_5B9E_4F8BID,
                    _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____E_914D_7F6E["第三斩攻击力倍率"],
                    "朱雀院红叶-E第三斩"
                )
            end
            ::__continue40::
            i = i + 1
        end
    end
    local _____4E3B_5251_75D5 = _____521B_5EFA_5251_75D5(_____65BD_6CD5_8005, _____6570_636E["目标X"], _____6570_636E["目标Y"], _____6570_636E["方向角"])
    local ____6570_636E__672CE_5251_75D5_30 = _____6570_636E["本E剑痕"]
    ____6570_636E__672CE_5251_75D5_30[#____6570_636E__672CE_5251_75D5_30 + 1] = _____4E3B_5251_75D5
    if ____E_914D_7F6E["刀势强化第二剑痕"] and _____5C1D_8BD5_6D88_8D39_4E00_5C42_5200_52BF(_____65BD_6CD5_8005) then
        local ____6570_636E__672CE_5251_75D5_31 = _____6570_636E["本E剑痕"]
        ____6570_636E__672CE_5251_75D5_31[#____6570_636E__672CE_5251_75D5_31 + 1] = _____521B_5EFA_5251_75D5(_____65BD_6CD5_8005, _____6570_636E["目标X"], _____6570_636E["目标Y"], _____6570_636E["方向角"] + 90)
    elseif ____E_914D_7F6E["D强化第二剑痕"] and _____8054_52A8D["尝试消费D强化"] ~= nil and _____8054_52A8D["尝试消费D强化"](_____65BD_6CD5_8005) then
        local ____6570_636E__672CE_5251_75D5_32 = _____6570_636E["本E剑痕"]
        ____6570_636E__672CE_5251_75D5_32[#____6570_636E__672CE_5251_75D5_32 + 1] = _____521B_5EFA_5251_75D5(_____65BD_6CD5_8005, _____6570_636E["目标X"], _____6570_636E["目标Y"], _____6570_636E["方向角"] + 90)
    end
    _____63A7_5236_5668["完成"]()
end
local function _____91CA_653EE_4E09_53F6_6563_534E(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    debugLogForce(
        "红叶-E",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____E_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "目标",
        "点施放",
        "施法者X",
        math.floor(GetUnitX(_____65BD_6CD5_8005)),
        "施法者Y",
        math.floor(GetUnitY(_____65BD_6CD5_8005)),
        "目标X",
        math.floor(_____76EE_6807X),
        "目标Y",
        math.floor(_____76EE_6807Y)
    )
    if not _____662F_6731_96C0_9662_7EA2_53F6(_____65BD_6CD5_8005) then
        debugLogForce(
            "红叶-E",
            "释放被拒",
            "原因",
            "非红叶单位",
            "施法者",
            _____65BD_6CD5_8005
        )
        return
    end
    if #_____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "红叶E") > 0 then
        debugLogForce(
            "红叶-E",
            "释放被拒",
            "原因",
            "重复E活跃实例",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1
        )
        return
    end
    _____5F00_59CB_786C_76F4(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["E连续三斩"]["持续秒"])
    _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["E连续三斩"])
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "朱雀院红叶", _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.E["技能ID"])
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        _____76EE_6807X,
        _____76EE_6807Y
    )
    local _____6570_636E = {
        ["方向角"] = _____65B9_5411_89D2,
        ["目标X"] = _____76EE_6807X,
        ["目标Y"] = _____76EE_6807Y,
        ["已斩段数"] = 0,
        ["段回调ID"] = {},
        ["同目标次数"] = {},
        ["本E剑痕"] = {}
    }
    local ____E_8FDB_5EA6_6700_5927_503C = _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["E连续三斩"]["持续秒"]
    _____6570_636E["进度UI"] = _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI({
        X = GetUnitX(_____65BD_6CD5_8005),
        Y = GetUnitY(_____65BD_6CD5_8005),
        Z = 0,
        ["跟随单位"] = _____65BD_6CD5_8005,
        ["跟随Z偏移"] = _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E["跟随Z偏移"],
        ["最大值"] = ____E_8FDB_5EA6_6700_5927_503C,
        ["当前值"] = 0,
        ["标题"] = _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E["标题"] or "三叶·散华",
        ["数值后缀"] = _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E["数值后缀"],
        ["类型"] = _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E["UI类型"]
    })
    local ____E_5DF2_6D41_901D_79D2 = 0
    local ____E_8FDB_5EA6_5468_671FID
    ____E_8FDB_5EA6_5468_671FID = addPeriodicCallback(
        50,
        function()
            if _____6570_636E["进度UI"] == nil then
                removePeriodicCallback(____E_8FDB_5EA6_5468_671FID)
                return
            end
            ____E_5DF2_6D41_901D_79D2 = ____E_5DF2_6D41_901D_79D2 + 0.05
            _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(_____6570_636E["进度UI"], ____E_5DF2_6D41_901D_79D2)
            if ____E_5DF2_6D41_901D_79D2 >= ____E_8FDB_5EA6_6700_5927_503C then
                removePeriodicCallback(____E_8FDB_5EA6_5468_671FID)
            end
        end
    )
    addDelayedCallback(
        ____E_8FDB_5EA6_6700_5927_503C * 1000,
        function()
            if _____6570_636E["进度UI"] == nil then
                return
            end
            _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(_____6570_636E["进度UI"])
            _____6570_636E["进度UI"] = nil
        end
    )
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "红叶E",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(_____539F_56E0, _c)
            debugLogForce(
                "红叶-E",
                "结束",
                "原因",
                _____539F_56E0 or "-",
                "玩家",
                GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1
            )
            if _____539F_56E0 ~= "完成" then
                _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(_____6570_636E["进度UI"])
                _____6570_636E["进度UI"] = nil
            end
            do
                local i = 0
                while i < #_____6570_636E["段回调ID"] do
                    removeDelayedCallback(_____6570_636E["段回调ID"][i + 1])
                    i = i + 1
                end
            end
            _____6570_636E["段回调ID"] = {}
            if _____539F_56E0 ~= "完成" then
                do
                    local i = 0
                    while i < #_____6570_636E["本E剑痕"] do
                        _____79FB_9664_5251_75D5(_____6570_636E["本E剑痕"][i + 1])
                        i = i + 1
                    end
                end
                _____6570_636E["本E剑痕"] = {}
            end
        end
    })
    local _____6BB5_56DE_8C03 = {
        function()
            _____6267_884CE_4E00_6BB5(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
        end,
        function()
            _____6267_884CE_4E8C_6BB5(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
        end,
        function()
            _____6267_884CE_4E09_6BB5(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
        end
    }
    do
        local i = 0
        while i < #_____6BB5_56DE_8C03 do
            local _____5EF6_8FDF = ____E_914D_7F6E["每段延迟毫秒"][i + 1] or 0
            local _____56DE_8C03ID = addDelayedCallback(_____5EF6_8FDF, _____6BB5_56DE_8C03[i + 1])
            local ____6570_636E__6BB5_56DE_8C03ID_33 = _____6570_636E["段回调ID"]
            ____6570_636E__6BB5_56DE_8C03ID_33[#____6570_636E__6BB5_56DE_8C03ID_33 + 1] = _____56DE_8C03ID
            _____63A7_5236_5668["登记延迟回调"](_____56DE_8C03ID)
            i = i + 1
        end
    end
    _____767B_8BB0_6731_96C0_9662_6E05_7406(
        _____65BD_6CD5_8005,
        "红叶E剑痕",
        function()
            do
                local i = 0
                while i < #_____6570_636E["本E剑痕"] do
                    _____79FB_9664_5251_75D5(_____6570_636E["本E剑痕"][i + 1])
                    i = i + 1
                end
            end
            _____6570_636E["本E剑痕"] = {}
        end
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院红叶E"] = function()
    debugLogForce(
        "红叶-E",
        "注册",
        "名称",
        "E",
        "函数",
        "注册朱雀院红叶E"
    )
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院红叶-三叶·散华（E）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "AME1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EE_4E09_53F6_6563_534E,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 2.5
    })
end
____exports["朱雀院红叶E模块"] = {["技能ID"] = _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.E["技能ID"], ["剑痕持续秒"] = ____E_914D_7F6E["剑痕持续秒"], ["注册"] = ____exports["注册朱雀院红叶E"]}
return ____exports
