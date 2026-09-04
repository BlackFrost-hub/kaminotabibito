--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5173_95EDW_955C_754C, _____5B9E_4F8B_5316W_6536_5C3E_5B88_62A4, GetUnitX, GetUnitY, GetUnitName, unregisterDamageModifier, _____79FB_9664_62A4_76FE, _____5355_4F4D_5B58_6D3B, _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA, SFB_setSlow, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548, debugLogForce, ____W_955C_754C_7279_6548_952E
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.00．配置")
local _____4F0A_857E_5A1C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜技能配置"]
local _____4F0A_857E_5A1CW_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜W配置"]
local _____4F0A_857E_5A1C_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜表现配置"]
local _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜模型动作配置"]
local _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜变式效果配置"]
local _____4F0A_857E_5A1C_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜音效配置"]
local ____01A_FF0E_52A8_4F5C_8868_73B0 = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.01A．动作表现")
local _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C = ____01A_FF0E_52A8_4F5C_8868_73B0["播放伊蕾娜阶段动作"]
local _____5F00_59CB_4F0A_857E_5A1C_5FAA_73AF_52A8_4F5C = ____01A_FF0E_52A8_4F5C_8868_73B0["开始伊蕾娜循环动作"]
local _____505C_6B62_4F0A_857E_5A1C_5FAA_73AF_52A8_4F5C = ____01A_FF0E_52A8_4F5C_8868_73B0["停止伊蕾娜循环动作"]
local ____23_FF0E_4F0A_857E_5A1C = require("系统.05．Buff系统.03．Buff表.02．英雄.23．伊蕾娜")
local _____4F0A_857E_5A1CBuffID = ____23_FF0E_4F0A_857E_5A1C["伊蕾娜BuffID"]
local ____02_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.02．被动效果")
local _____8BB0_5F55_4F0A_857E_5A1C_89C1_95FB = ____02_FF0E_88AB_52A8_6548_679C["记录伊蕾娜见闻"]
local _____83B7_53D6_4F0A_857E_5A1C_53D8_5F0F = ____02_FF0E_88AB_52A8_6548_679C["获取伊蕾娜变式"]
local _____6D88_8D39_4F0A_857E_5A1C_53D8_5F0F_7528_4E8E = ____02_FF0E_88AB_52A8_6548_679C["消费伊蕾娜变式用于"]
local _____5B58_4F0A_857E_5A1CW_7ED3_754C = ____02_FF0E_88AB_52A8_6548_679C["存伊蕾娜W结界"]
local _____53D6_4F0A_857E_5A1CW_7ED3_754C = ____02_FF0E_88AB_52A8_6548_679C["取伊蕾娜W结界"]
local _____767B_8BB0_4F0A_857E_5A1C_6280_80FD_6E05_7406 = ____02_FF0E_88AB_52A8_6548_679C["登记伊蕾娜技能清理"]
function _____5173_95EDW_955C_754C(_____6570_636E, _____5141_8BB8_8109_51B2)
    debugLogForce(
        "伊蕾娜-W",
        "结束",
        "原因",
        _____5141_8BB8_8109_51B2 and "自然结束" or "提前收口",
        "单位",
        GetUnitName(_____6570_636E["英雄"]),
        "handle",
        _____6570_636E["英雄"]
    )
    if _____6570_636E["已关闭"] then
        return
    end
    _____6570_636E["已关闭"] = true
    if _____6570_636E["修改器ID"] ~= 0 then
        unregisterDamageModifier(_____6570_636E["修改器ID"])
        _____6570_636E["修改器ID"] = 0
    end
    local _____82F1_96C4 = _____6570_636E["英雄"]
    _____79FB_9664_62A4_76FE(_____6570_636E["护盾ID"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4F0A_857E_5A1CBuffID["镜界结界"])
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____82F1_96C4, ____W_955C_754C_7279_6548_952E)
    _____505C_6B62_4F0A_857E_5A1C_5FAA_73AF_52A8_4F5C(_____6570_636E["保持动作守护"])
    _____6570_636E["保持动作守护"] = nil
    if _____6570_636E["注销清理"] ~= nil then
        _____6570_636E["注销清理"]()
        _____6570_636E["注销清理"] = nil
    end
    if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C(_____82F1_96C4, _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["W收势"])
    end
    if _____5141_8BB8_8109_51B2 and not _____6570_636E["主要攻击已处理"] and _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        local X = GetUnitX(_____82F1_96C4)
        local Y = GetUnitY(_____82F1_96C4)
        local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____82F1_96C4, X, Y, _____4F0A_857E_5A1CW_914D_7F6E["自然结束脉冲半径"])
        do
            local i = 0
            while i < #_____654C_4EBA_5217_8868 do
                do
                    local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                    if not _____5355_4F4D_5B58_6D3B(_____654C_4EBA) then
                        goto __continue9
                    end
                    SFB_setSlow(
                        _____82F1_96C4,
                        _____654C_4EBA,
                        0,
                        _____4F0A_857E_5A1CW_914D_7F6E["自然结束减速比例"],
                        _____4F0A_857E_5A1CW_914D_7F6E["自然结束减速秒"],
                        "伊蕾娜-镜界碎裂",
                        "技能"
                    )
                end
                ::__continue9::
                i = i + 1
            end
        end
    end
    if _____53D6_4F0A_857E_5A1CW_7ED3_754C(_____82F1_96C4) == _____6570_636E then
        _____5B58_4F0A_857E_5A1CW_7ED3_754C(_____82F1_96C4, nil)
    end
end
function _____5B9E_4F8B_5316W_6536_5C3E_5B88_62A4(_____65BD_6CD5_8005, _____6570_636E)
    _____6570_636E["注销清理"] = _____767B_8BB0_4F0A_857E_5A1C_6280_80FD_6E05_7406(
        _____65BD_6CD5_8005,
        "W镜界",
        function()
            _____5173_95EDW_955C_754C(_____6570_636E, false)
        end
    )
end
local ____require_result_0 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_0["播放英雄技能喊话"]
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local fourCCToStringSafe = ____require_result_1.fourCCToStringSafe
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local IsUnitEnemy = jass.IsUnitEnemy
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_3.getGameTime
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_4["注册单位技能壳监听"]
local ____require_result_5 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_5.registerDamageModifier
unregisterDamageModifier = ____require_result_5.unregisterDamageModifier
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统")
local _____5F00_59CB_62A4_76FE = ____require_result_6["开始护盾"]
_____79FB_9664_62A4_76FE = ____require_result_6["移除护盾"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
_____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_7["两点角度"]
local _____6781_5750_6807X = ____require_result_7["极坐标X"]
local _____6781_5750_6807Y = ____require_result_7["极坐标Y"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
_____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_8["获取坐标范围敌人"]
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_9["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_9["移除单位暂停"]
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
SFB_setSlow = ____require_result_10.SFB_setSlow
local ____require_result_11 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_11.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_11["移除单位指定Buff"]
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_12["创建单位坐标跟随特效"]
_____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_12["销毁单位坐标跟随特效"]
local _____521B_5EFA_70B9_7279_6548 = ____require_result_12["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_12["销毁点特效"]
local ____require_result_13 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_13.Sound3DII_UnitPlayReuse
local ____require_result_14 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_14.Sound3DII_CooPlayReuse
local ____require_result_15 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_15.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____4F0A_857E_5A1C_6280_80FD_914D_7F6E["单位类型ID"]
____W_955C_754C_7279_6548_952E = "伊蕾娜-W镜界"
local ____W_786C_76F4_6765_6E90 = "伊蕾娜-W硬直"
--- 折射可用查询（Q 联动读取）。
____exports["查询伊蕾娜W折射可用"] = function(_____82F1_96C4)
    local _____6570_636E = _____53D6_4F0A_857E_5A1CW_7ED3_754C(_____82F1_96C4)
    if _____6570_636E == nil or _____6570_636E["已关闭"] then
        return false
    end
    if getGameTime() >= _____6570_636E["窗口结束时间"] then
        return false
    end
    return not _____6570_636E["折射已用"]
end
--- 折射消费（Q 联动调用；每个结界实例只允许一次；不影响主要攻击偏折机会）。
____exports["消费伊蕾娜W折射"] = function(_____82F1_96C4)
    local _____6570_636E = _____53D6_4F0A_857E_5A1CW_7ED3_754C(_____82F1_96C4)
    if _____6570_636E == nil or _____6570_636E["已关闭"] then
        return false
    end
    if _____6570_636E["折射已用"] then
        return false
    end
    if getGameTime() >= _____6570_636E["窗口结束时间"] then
        return false
    end
    _____6570_636E["折射已用"] = true
    return true
end
local function _____91CA_653EW_955C_754C_62A4_7B26(_context, _____65BD_6CD5_8005, ______6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        debugLogForce(
            "伊蕾娜-W",
            "释放被拒",
            "原因",
            "施法者无效",
            "handle",
            _____65BD_6CD5_8005
        )
        return
    end
    debugLogForce(
        "伊蕾娜-W",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(stringToFourCCSafe(_____4F0A_857E_5A1C_6280_80FD_914D_7F6E.W["技能ID"])),
        "实例",
        ______6280_80FD_5B9E_4F8BID or "-",
        "目标",
        "自身",
        "X",
        math.floor(GetUnitX(_____65BD_6CD5_8005)),
        "Y",
        math.floor(GetUnitY(_____65BD_6CD5_8005))
    )
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "伊蕾娜", _____4F0A_857E_5A1C_6280_80FD_914D_7F6E.W["技能ID"])
    local _____65E7_6570_636E = _____53D6_4F0A_857E_5A1CW_7ED3_754C(_____65BD_6CD5_8005)
    if _____65E7_6570_636E ~= nil and not _____65E7_6570_636E["已关闭"] then
        _____5173_95EDW_955C_754C(_____65E7_6570_636E, false)
    end
    if _____6DFB_52A0_5355_4F4D_6682_505C(_____65BD_6CD5_8005, ____W_786C_76F4_6765_6E90) then
        _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C(_____65BD_6CD5_8005, _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["W展开"])
    end
    addDelayedCallback(
        _____4F0A_857E_5A1CW_914D_7F6E["硬直秒"] * 1000,
        function()
            _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, ____W_786C_76F4_6765_6E90)
        end
    )
    local now = getGameTime()
    local _____6570_636E = {
        ["英雄"] = _____65BD_6CD5_8005,
        ["窗口结束时间"] = now + _____4F0A_857E_5A1CW_914D_7F6E["保护窗口秒"] * 1000,
        ["主要攻击已处理"] = false,
        ["已关闭"] = false,
        ["修改器ID"] = 0,
        ["护盾ID"] = 0,
        ["镜界变式待消费"] = _____83B7_53D6_4F0A_857E_5A1C_53D8_5F0F(_____65BD_6CD5_8005) == "镜界",
        ["注销清理"] = nil,
        ["保持动作守护"] = nil,
        ["折射已用"] = false
    }
    _____5B58_4F0A_857E_5A1CW_7ED3_754C(_____65BD_6CD5_8005, _____6570_636E)
    addDelayedCallback(
        _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["W展开"]["持续秒"] * 1000,
        function()
            if not _____6570_636E["已关闭"] and _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                _____6570_636E["保持动作守护"] = _____5F00_59CB_4F0A_857E_5A1C_5FAA_73AF_52A8_4F5C(_____65BD_6CD5_8005, _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["W保持"])
            end
        end
    )
    registerManualBuff(_____65BD_6CD5_8005, _____4F0A_857E_5A1CBuffID["镜界结界"], _____4F0A_857E_5A1CW_914D_7F6E["保护窗口秒"], 0)
    local _____955C_754C_8868_73B0 = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["W镜界主体"]
    local _____955C_754C_7F29_653E = _____4F0A_857E_5A1CW_914D_7F6E["结界接触半径"] / _____955C_754C_8868_73B0["基准半径"] * _____955C_754C_8868_73B0["基准缩放"]
    debugLogForce(
        "伊蕾娜-W",
        "特效",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "路径",
        _____955C_754C_8868_73B0["模型路径"]
    )
    _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        _____65BD_6CD5_8005,
        _____955C_754C_8868_73B0["模型路径"],
        ____W_955C_754C_7279_6548_952E,
        _____955C_754C_7F29_653E,
        _____955C_754C_8868_73B0["高度"],
        1,
        nil,
        0,
        _____955C_754C_8868_73B0.RGB
    )
    Sound3DII_UnitPlayReuse(_____4F0A_857E_5A1C_97F3_6548_914D_7F6E["W展开"]["路径"], _____65BD_6CD5_8005, _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["W展开"]["裁断距离"])
    _____6570_636E["护盾ID"] = _____5F00_59CB_62A4_76FE(
        _____65BD_6CD5_8005,
        {
            ["类型"] = 0,
            ["数值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F0A_857E_5A1CW_914D_7F6E["护盾攻击力倍率"],
            ["持续时间"] = _____4F0A_857E_5A1CW_914D_7F6E["保护窗口秒"],
            ["来源单位"] = _____65BD_6CD5_8005,
            ["标签"] = "伊蕾娜-镜界护盾",
            ["显示护盾条"] = true
        }
    )
    _____6570_636E["修改器ID"] = registerDamageModifier(
        function(context)
            if _____6570_636E["已关闭"] or _____6570_636E["主要攻击已处理"] then
                return context.currentDamage
            end
            if context.target ~= _____65BD_6CD5_8005 then
                return context.currentDamage
            end
            if not (context.currentDamage > 0) then
                return context.currentDamage
            end
            local _____653B_51FB_8005 = context.attacker
            if _____653B_51FB_8005 == nil or _____653B_51FB_8005 == 0 or _____653B_51FB_8005 == _____65BD_6CD5_8005 then
                return context.currentDamage
            end
            if not IsUnitEnemy(
                _____653B_51FB_8005,
                GetOwningPlayer(_____65BD_6CD5_8005)
            ) then
                return context.currentDamage
            end
            if getGameTime() >= _____6570_636E["窗口结束时间"] then
                return context.currentDamage
            end
            _____6570_636E["主要攻击已处理"] = true
            debugLogForce(
                "伊蕾娜-W",
                "命中",
                "玩家",
                GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                "四码",
                fourCCToStringSafe(stringToFourCCSafe(_____4F0A_857E_5A1C_6280_80FD_914D_7F6E.W["技能ID"])),
                "目标",
                GetUnitName(_____653B_51FB_8005),
                "handle",
                _____653B_51FB_8005,
                "X",
                math.floor(GetUnitX(_____653B_51FB_8005)),
                "Y",
                math.floor(GetUnitY(_____653B_51FB_8005)),
                "伤害",
                math.floor(context.currentDamage),
                "类型",
                "主要攻击偏折"
            )
            local _____63A5_89E6_89D2 = _____4E24_70B9_89D2_5EA6(
                GetUnitX(_____65BD_6CD5_8005),
                GetUnitY(_____65BD_6CD5_8005),
                GetUnitX(_____653B_51FB_8005),
                GetUnitY(_____653B_51FB_8005)
            )
            local _____63A5_89E6X = _____6781_5750_6807X(
                GetUnitX(_____65BD_6CD5_8005),
                _____63A5_89E6_89D2,
                _____4F0A_857E_5A1CW_914D_7F6E["结界接触半径"]
            )
            local _____63A5_89E6Y = _____6781_5750_6807Y(
                GetUnitY(_____65BD_6CD5_8005),
                _____63A5_89E6_89D2,
                _____4F0A_857E_5A1CW_914D_7F6E["结界接触半径"]
            )
            local _____53CD_9988_7279_6548 = _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["W偏折反馈"]["模型路径"],
                RGB = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["W偏折反馈"].RGB,
                X = _____63A5_89E6X,
                Y = _____63A5_89E6Y,
                Z = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["W偏折反馈"]["高度"],
                ["面向角度"] = _____63A5_89E6_89D2,
                ["缩放"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["W偏折反馈"]["缩放"],
                ["持续秒"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["W偏折反馈"]["持续秒"]
            })
            local ____ = _____53CD_9988_7279_6548
            Sound3DII_CooPlayReuse(
                _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["W偏折"]["路径"],
                _____63A5_89E6X,
                _____63A5_89E6Y,
                _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["W偏折"]["高度"],
                _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["W偏折"]["裁断距离"]
            )
            addDelayedCallback(
                10,
                function()
                    if _____6570_636E["已关闭"] then
                        return
                    end
                    _____8BB0_5F55_4F0A_857E_5A1C_89C1_95FB(_____65BD_6CD5_8005, "镜界", nil)
                    _____5173_95EDW_955C_754C(_____6570_636E, false)
                    if _____6570_636E["镜界变式待消费"] and _____6D88_8D39_4F0A_857E_5A1C_53D8_5F0F_7528_4E8E(_____65BD_6CD5_8005, "W") == "镜界" then
                        _____5F00_59CB_62A4_76FE(
                            _____65BD_6CD5_8005,
                            {
                                ["类型"] = 0,
                                ["数值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E["镜界_W回响护盾攻击力倍率"],
                                ["持续时间"] = _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E["镜界_W回响护盾秒"],
                                ["来源单位"] = _____65BD_6CD5_8005,
                                ["标签"] = "伊蕾娜-镜界变式回响",
                                ["显示护盾条"] = false
                            }
                        )
                    end
                end
            )
            return context.currentDamage * (1 - _____4F0A_857E_5A1CW_914D_7F6E["偏折减免比例"])
        end,
        50
    )
    addDelayedCallback(
        _____4F0A_857E_5A1CW_914D_7F6E["保护窗口秒"] * 1000,
        function()
            _____5173_95EDW_955C_754C(_____6570_636E, true)
        end
    )
    _____5B9E_4F8B_5316W_6536_5C3E_5B88_62A4(_____65BD_6CD5_8005, _____6570_636E)
end
local _____5DF2_6CE8_518C = false
____exports["注册伊蕾娜W"] = function()
    debugLogForce("伊蕾娜-W", "注册", "名称", "注册伊蕾娜W")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "伊蕾娜-镜界护符（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____4F0A_857E_5A1C_6280_80FD_914D_7F6E.W["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EW_955C_754C_62A4_7B26,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 8
    })
end
return ____exports
