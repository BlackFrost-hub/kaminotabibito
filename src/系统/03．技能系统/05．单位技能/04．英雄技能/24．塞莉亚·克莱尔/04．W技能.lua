--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.00．配置")
local _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔技能配置"]
local _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔W配置"]
local _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔表现配置"]
local _____585E_8389_4E9A_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚音效配置"]
local ____24_FF0E_585E_8389_4E9A_B7_514B_83B1_5C14 = require("系统.05．Buff系统.03．Buff表.02．英雄.24．塞莉亚·克莱尔")
local _____585E_8389_4E9ABuffID = ____24_FF0E_585E_8389_4E9A_B7_514B_83B1_5C14["塞莉亚BuffID"]
local ____02_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.02．被动效果")
local _____521B_5EFA_585E_8389_4E9A_8282_70B9 = ____02_FF0E_88AB_52A8_6548_679C["创建塞莉亚节点"]
local _____6388_4E88_585E_8389_4E9A_6F14_7B97_7A97_53E3 = ____02_FF0E_88AB_52A8_6548_679C["授予塞莉亚演算窗口"]
local _____67E5_8BE2_585E_8389_4E9A_6709_6548_8FDE_63A5 = ____02_FF0E_88AB_52A8_6548_679C["查询塞莉亚有效连接"]
local _____767B_8BB0_585E_8389_4E9A_6280_80FD_6E05_7406 = ____02_FF0E_88AB_52A8_6548_679C["登记塞莉亚技能清理"]
local jass = require("jass.common")
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local ____register_62A4_76FE_524D_62E6_622A_4FEE_6539_5668 = ____require_result_3["register护盾前拦截修改器"]
local unregisterDamageModifier = ____require_result_3.unregisterDamageModifier
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统")
local _____5F00_59CB_62A4_76FE = ____require_result_4["开始护盾"]
local _____79FB_9664_62A4_76FE = ____require_result_4["移除护盾"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_5["造成技能伤害"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local ____AOE_65BD_52A0_6269_5C55_63A7_5236 = ____require_result_6["AOE施加扩展控制"]
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_6["施加扩展控制"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local ____require_result_8 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_8.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_8["移除单位指定Buff"]
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_9["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_9["移除单位暂停"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_10["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_10["销毁单位坐标跟随特效"]
local ____require_result_11 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_11.Sound3DII_UnitPlayReuse
local ____require_result_12 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_12["播放英雄技能喊话"]
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_13.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E["单位类型ID"]
local ____W_7ED3_754C_7279_6548_952E = "塞莉亚-W结界"
local ____W_786C_76F4_6765_6E90 = "塞莉亚-W硬直"
--- 结界+锚定连接是否成立（读分支用，不消费）。
local function _____6709_7ED3_754C_951A_5B9A_8FDE_63A5(_____82F1_96C4)
    local _____8FDE_63A5 = _____67E5_8BE2_585E_8389_4E9A_6709_6548_8FDE_63A5(_____82F1_96C4)
    if _____8FDE_63A5 == nil or not _____8FDE_63A5["可读取"] then
        return false
    end
    local _____6709_7ED3_754C = _____8FDE_63A5["A类型"] == "结界" or _____8FDE_63A5["B类型"] == "结界"
    local _____6709_951A_5B9A = _____8FDE_63A5["A类型"] == "锚定" or _____8FDE_63A5["B类型"] == "锚定"
    return _____6709_7ED3_754C and _____6709_951A_5B9A
end
--- 统一收口：成功 / 自然结束 / 打断 / 死亡互斥。
local function _____5173_95EDW_7ED3_754C(_____6570_636E, _____6536_53E3_7C7B_578B)
    debugLogForce("塞莉亚-W", "结束", "原因", _____6536_53E3_7C7B_578B)
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
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____585E_8389_4E9ABuffID["解析结界"])
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____82F1_96C4, ____W_7ED3_754C_7279_6548_952E)
    if _____6536_53E3_7C7B_578B == "自然结束" and not _____6570_636E["主要攻击已解析"] and _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        local X = GetUnitX(_____82F1_96C4)
        local Y = GetUnitY(_____82F1_96C4)
        if _____6709_7ED3_754C_951A_5B9A_8FDE_63A5(_____82F1_96C4) then
            ____AOE_65BD_52A0_6269_5C55_63A7_5236(
                _____82F1_96C4,
                X,
                Y,
                _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["结界锚定束缚半径"],
                "roots",
                _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["结界锚定束缚秒"]
            )
        end
        ____AOE_65BD_52A0_6269_5C55_63A7_5236(
            _____82F1_96C4,
            X,
            Y,
            _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["自然结束脉冲半径"],
            "slow",
            _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["自然结束减速秒"]
        )
    end
end
local function _____91CA_653EW_89E3_6790_7ED3_754C(_context, _____65BD_6CD5_8005, ______6280_80FD_5B9E_4F8BID)
    debugLogForce(
        "塞莉亚-W",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.W["技能ID"],
        "实例",
        ______6280_80FD_5B9E_4F8BID or "-",
        "目标",
        "自身",
        "X",
        math.floor(GetUnitX(_____65BD_6CD5_8005)),
        "Y",
        math.floor(GetUnitY(_____65BD_6CD5_8005))
    )
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "塞莉亚·克莱尔", _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.W["技能ID"])
    _____6DFB_52A0_5355_4F4D_6682_505C(_____65BD_6CD5_8005, ____W_786C_76F4_6765_6E90)
    addDelayedCallback(
        _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["硬直秒"] * 1000,
        function()
            _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, ____W_786C_76F4_6765_6E90)
        end
    )
    local now = getGameTime()
    local _____6570_636E = {
        ["英雄"] = _____65BD_6CD5_8005,
        ["窗口结束时间"] = now + _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["保护窗口秒"] * 1000,
        ["主要攻击已解析"] = false,
        ["已关闭"] = false,
        ["修改器ID"] = 0,
        ["护盾ID"] = 0
    }
    debugLogForce(
        "塞莉亚-W",
        "特效",
        "路径",
        _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["W结界主体"]["模型路径"],
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "X",
        math.floor(GetUnitX(_____65BD_6CD5_8005)),
        "Y",
        math.floor(GetUnitY(_____65BD_6CD5_8005))
    )
    _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        _____65BD_6CD5_8005,
        _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["W结界主体"]["模型路径"],
        ____W_7ED3_754C_7279_6548_952E,
        _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["W结界主体"]["缩放"],
        _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["W结界主体"]["高度"],
        1,
        nil,
        0,
        _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["W结界主体"].RGB
    )
    debugLogForce(
        "塞莉亚-W",
        "Buff",
        "操作",
        "施加",
        "目标",
        _____65BD_6CD5_8005,
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1
    )
    registerManualBuff(_____65BD_6CD5_8005, _____585E_8389_4E9ABuffID["解析结界"], _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["保护窗口秒"], 0)
    _____6388_4E88_585E_8389_4E9A_6F14_7B97_7A97_53E3(_____65BD_6CD5_8005)
    _____521B_5EFA_585E_8389_4E9A_8282_70B9(
        _____65BD_6CD5_8005,
        "结界",
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        ______6280_80FD_5B9E_4F8BID
    )
    _____6570_636E["护盾ID"] = _____5F00_59CB_62A4_76FE(
        _____65BD_6CD5_8005,
        {
            ["类型"] = 0,
            ["数值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["护盾攻击力倍率"],
            ["持续时间"] = _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["保护窗口秒"],
            ["来源单位"] = _____65BD_6CD5_8005,
            ["标签"] = "塞莉亚-解析结界",
            ["显示护盾条"] = true
        }
    )
    Sound3DII_UnitPlayReuse(_____585E_8389_4E9A_97F3_6548_914D_7F6E["W展开"]["路径"], _____65BD_6CD5_8005, _____585E_8389_4E9A_97F3_6548_914D_7F6E["W展开"]["裁断距离"])
    _____6570_636E["修改器ID"] = ____register_62A4_76FE_524D_62E6_622A_4FEE_6539_5668(function(context)
        if _____6570_636E["已关闭"] or _____6570_636E["主要攻击已解析"] then
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
        if not jass.IsUnitEnemy(
            _____653B_51FB_8005,
            jass.GetOwningPlayer(_____65BD_6CD5_8005)
        ) then
            return context.currentDamage
        end
        if getGameTime() >= _____6570_636E["窗口结束时间"] then
            return context.currentDamage
        end
        _____6570_636E["主要攻击已解析"] = true
        Sound3DII_UnitPlayReuse(_____585E_8389_4E9A_97F3_6548_914D_7F6E["W共鸣"]["路径"], _____65BD_6CD5_8005, _____585E_8389_4E9A_97F3_6548_914D_7F6E["W共鸣"]["裁断距离"])
        addDelayedCallback(
            10,
            function()
                if _____6570_636E["已关闭"] then
                    return
                end
                unregisterDamageModifier(_____6570_636E["修改器ID"])
                _____6570_636E["修改器ID"] = 0
                if _____5355_4F4D_5B58_6D3B(_____653B_51FB_8005) then
                    debugLogForce(
                        "塞莉亚-W",
                        "命中",
                        "玩家",
                        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                        "四码",
                        _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.W["技能ID"],
                        "目标",
                        GetUnitName(_____653B_51FB_8005),
                        "handle",
                        _____653B_51FB_8005,
                        "X",
                        math.floor(GetUnitX(_____653B_51FB_8005)),
                        "Y",
                        math.floor(GetUnitY(_____653B_51FB_8005)),
                        "伤害",
                        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["反冲伤害攻击力倍率"]
                    )
                    _____9020_6210_6280_80FD_4F24_5BB3({
                        ["来源"] = _____65BD_6CD5_8005,
                        ["目标"] = _____653B_51FB_8005,
                        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["反冲伤害攻击力倍率"],
                        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                        ["攻击类型"] = ATTACK_TYPE_NORMAL,
                        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "单位技能",
                        ["标签"] = "塞莉亚-解析反冲",
                        ["伤害形态"] = "单体",
                        ["参与技能伤害加成"] = true
                    })
                    _____65BD_52A0_6269_5C55_63A7_5236(_____65BD_6CD5_8005, _____653B_51FB_8005, "slow", _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["反冲减速秒"])
                end
                if _____6709_7ED3_754C_951A_5B9A_8FDE_63A5(_____65BD_6CD5_8005) and _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                    ____AOE_65BD_52A0_6269_5C55_63A7_5236(
                        _____65BD_6CD5_8005,
                        GetUnitX(_____65BD_6CD5_8005),
                        GetUnitY(_____65BD_6CD5_8005),
                        _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["结界锚定束缚半径"],
                        "roots",
                        _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["结界锚定束缚秒"]
                    )
                end
            end
        )
        return context.currentDamage * (1 - _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["解析减免比例"])
    end)
    addDelayedCallback(
        _____585E_8389_4E9A_514B_83B1_5C14W_914D_7F6E["保护窗口秒"] * 1000,
        function()
            _____5173_95EDW_7ED3_754C(_____6570_636E, "自然结束")
        end
    )
    local _____6CE8_9500 = _____767B_8BB0_585E_8389_4E9A_6280_80FD_6E05_7406(
        _____65BD_6CD5_8005,
        "W结界",
        function()
            _____5173_95EDW_7ED3_754C(_____6570_636E, "打断")
        end
    )
    local ____ = _____6CE8_9500
end
local _____5DF2_6CE8_518C = false
____exports["注册塞莉亚W"] = function()
    debugLogForce("塞莉亚-W", "注册", "名称", "注册塞莉亚W")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞莉亚·克莱尔-解析结界（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.W["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EW_89E3_6790_7ED3_754C,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 8
    })
end
return ____exports
