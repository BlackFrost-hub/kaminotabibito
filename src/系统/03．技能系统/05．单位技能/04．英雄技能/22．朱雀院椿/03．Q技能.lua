--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.00．配置")
local _____6731_96C0_9662_693F_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿技能配置"]
local _____6731_96C0_9662_693F_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿表现配置"]
local _____6731_96C0_9662_693F_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院椿动作槽"]
local _____6731_96C0_9662_693FQ_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿Q配置"]
local _____6731_96C0_9662_693F_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿音效配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local fourCCToStringSafe = ____require_result_0.fourCCToStringSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["查询战斗技能实例"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_4["造成技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_5["两点角度"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____require_result_6["获取扇形区域单位"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local ____require_result_8 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_8.Sound3DII_CooPlayReuse
local ____require_result_9 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_9["播放英雄技能喊话"]
local ____E_8054_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.05．E技能")
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.02．被动效果")
local _____662F_6731_96C0_9662_693F = ____require_result_10["是朱雀院椿"]
local _____6D88_8D39_53CD_51FB_51C6_5907 = ____require_result_10["消费反击准备"]
local _____6062_590DVF = ____require_result_10["恢复VF"]
local _____83B7_53D6_59FF_6001 = ____require_result_10["获取姿态"]
local _____767B_8BB0_693F_6E05_7406 = ____require_result_10["登记椿清理"]
local _____64AD_653E_693F_52A8_4F5C = ____require_result_10["播放椿动作"]
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_11.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"])
local ____Q_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E.Q["技能ID"])
local ____Q_914D_7F6E = _____6731_96C0_9662_693FQ_914D_7F6E
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local function _____7ED3_7B97Q_65A9(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____65B9_5411_89D2, _____4F24_5BB3_500D_7387, _____6807_7B7E)
    local _____73A9_5BB6ID = GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1
    debugLogForce(
        "椿-Q",
        "结算",
        "玩家",
        _____73A9_5BB6ID,
        "四码",
        fourCCToStringSafe(____Q_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "标签",
        _____6807_7B7E,
        "伤害",
        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F24_5BB3_500D_7387
    )
    local X = GetUnitX(_____65BD_6CD5_8005)
    local Y = GetUnitY(_____65BD_6CD5_8005)
    debugLogForce("椿-Q", "特效", "路径", _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["Q主斩"]["模型路径"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["Q主斩"]["模型路径"],
        RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["Q主斩"].RGB,
        X = X,
        Y = Y,
        Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["Q主斩"]["高度"],
        ["面向角度"] = _____65B9_5411_89D2,
        ["动画索引"] = 0,
        ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["Q主斩"]["缩放"],
        ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["Q主斩"]["持续秒"]
    })
    local _____654C_4EBA = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = X,
        Y = Y,
        ["半径"] = ____Q_914D_7F6E["扇形半径"],
        ["方向角"] = _____65B9_5411_89D2,
        ["扇形角度"] = ____Q_914D_7F6E["扇形角度"],
        ["单位筛选"] = function(_____5355_4F4D)
            return _____5355_4F4D ~= _____65BD_6CD5_8005 and _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and jass.IsUnitEnemy(
                _____5355_4F4D,
                jass.GetOwningPlayer(_____65BD_6CD5_8005)
            )
        end
    })
    if #_____654C_4EBA == 0 then
        debugLogForce(
            "椿-Q",
            "命中失败",
            "原因",
            "无目标",
            "玩家",
            _____73A9_5BB6ID,
            "四码",
            fourCCToStringSafe(____Q_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-",
            "标签",
            _____6807_7B7E,
            "方向",
            _____65B9_5411_89D2
        )
    end
    do
        local i = 0
        while i < #_____654C_4EBA do
            debugLogForce(
                "椿-Q",
                "命中",
                "玩家",
                _____73A9_5BB6ID,
                "四码",
                fourCCToStringSafe(____Q_6280_80FDID),
                "实例",
                _____6280_80FD_5B9E_4F8BID or "-",
                "标签",
                _____6807_7B7E,
                "目标",
                GetUnitName(_____654C_4EBA[i + 1]),
                "handle",
                _____654C_4EBA[i + 1],
                "X",
                math.floor(GetUnitX(_____654C_4EBA[i + 1])),
                "Y",
                math.floor(GetUnitY(_____654C_4EBA[i + 1])),
                "伤害",
                _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F24_5BB3_500D_7387
            )
            _____9020_6210_6280_80FD_4F24_5BB3({
                ["来源"] = _____65BD_6CD5_8005,
                ["目标"] = _____654C_4EBA[i + 1],
                ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F24_5BB3_500D_7387,
                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                ["攻击类型"] = ATTACK_TYPE_NORMAL,
                ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "单位技能",
                ["技能ID"] = ____Q_6280_80FDID,
                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                ["标签"] = _____6807_7B7E,
                ["伤害形态"] = "AOE",
                ["参与技能伤害加成"] = true
            })
            i = i + 1
        end
    end
end
local function _____6267_884C_57FA_7840_5C45_5408(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    _____7ED3_7B97Q_65A9(
        _____65BD_6CD5_8005,
        _____6280_80FD_5B9E_4F8BID,
        _____6570_636E["输入方向"],
        ____Q_914D_7F6E["基础伤害倍率"],
        "朱雀院椿-Q居合"
    )
    Sound3DII_CooPlayReuse(
        _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["Q居合"]["路径"],
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["Q居合"]["高度"],
        _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["Q居合"]["裁断距离"]
    )
    _____63A7_5236_5668["完成"]()
end
local function _____6267_884C_8FD4_5203_7B2C_4E00_6BB5(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    _____7ED3_7B97Q_65A9(
        _____65BD_6CD5_8005,
        _____6280_80FD_5B9E_4F8BID,
        _____6570_636E["输入方向"],
        ____Q_914D_7F6E["返刃一段倍率"],
        "朱雀院椿-Q返刃一段"
    )
    local _____7B2C_4E8C_6BB5ID = addDelayedCallback(
        ____Q_914D_7F6E["二段延迟毫秒"],
        function()
            _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["Q返刃二段"])
            Sound3DII_CooPlayReuse(
                _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["Q返刃"]["路径"],
                GetUnitX(_____65BD_6CD5_8005),
                GetUnitY(_____65BD_6CD5_8005),
                _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["Q返刃"]["高度"],
                _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["Q返刃"]["裁断距离"]
            )
            local _____59FF_6001 = _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005)
            if _____59FF_6001 == "一刀" then
                _____7ED3_7B97Q_65A9(
                    _____65BD_6CD5_8005,
                    _____6280_80FD_5B9E_4F8BID,
                    _____6570_636E["反击方向"],
                    ____Q_914D_7F6E["返刃二段倍率"],
                    "朱雀院椿-Q返刃二段"
                )
                _____6062_590DVF(_____65BD_6CD5_8005, 25)
            else
                _____7ED3_7B97Q_65A9(
                    _____65BD_6CD5_8005,
                    _____6280_80FD_5B9E_4F8BID,
                    _____6570_636E["反击方向"],
                    ____Q_914D_7F6E["返刃二段倍率"],
                    "朱雀院椿-Q返刃二段"
                )
                _____7ED3_7B97Q_65A9(
                    _____65BD_6CD5_8005,
                    _____6280_80FD_5B9E_4F8BID,
                    _____6570_636E["反击方向"] + 90,
                    ____Q_914D_7F6E["二刀交叉倍率"],
                    "朱雀院椿-Q交叉斩"
                )
                Sound3DII_CooPlayReuse(
                    _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["二刀交错"]["路径"],
                    GetUnitX(_____65BD_6CD5_8005),
                    GetUnitY(_____65BD_6CD5_8005),
                    _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["二刀交错"]["高度"],
                    _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["二刀交错"]["裁断距离"]
                )
            end
            _____63A7_5236_5668["完成"]()
        end
    )
    local ____6570_636E__6BB5_56DE_8C03ID_12 = _____6570_636E["段回调ID"]
    ____6570_636E__6BB5_56DE_8C03ID_12[#____6570_636E__6BB5_56DE_8C03ID_12 + 1] = _____7B2C_4E8C_6BB5ID
    _____63A7_5236_5668["登记延迟回调"](_____7B2C_4E8C_6BB5ID)
end
local function _____91CA_653EQ_5C45_5408(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_6731_96C0_9662_693F(_____65BD_6CD5_8005) then
        debugLogForce(
            "椿-Q",
            "释放被拒",
            "原因",
            "非朱雀院椿",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "四码",
            fourCCToStringSafe(____Q_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-"
        )
        return
    end
    debugLogForce(
        "椿-Q",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____Q_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "目标",
        "点施放",
        "X",
        math.floor(GetSpellTargetX()),
        "Y",
        math.floor(GetSpellTargetY())
    )
    if #_____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "椿Q") > 0 then
        debugLogForce(
            "椿-Q",
            "释放被拒",
            "原因",
            "已有活跃Q实例",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "四码",
            fourCCToStringSafe(____Q_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-"
        )
        return
    end
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "朱雀院椿", _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.Q["技能ID"])
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["Q居合"])
    local _____8F93_5165_65B9_5411 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    local _____53CD_51FB = _____6D88_8D39_53CD_51FB_51C6_5907(_____65BD_6CD5_8005)
    local ____temp_13
    if ____E_8054_52A8["获取椿回锋方向"] ~= nil then
        ____temp_13 = ____E_8054_52A8["获取椿回锋方向"](_____65BD_6CD5_8005)
    else
        ____temp_13 = nil
    end
    local _____56DE_950B_65B9_5411 = ____temp_13
    local _____6570_636E = {["输入方向"] = _____8F93_5165_65B9_5411, ["反击方向"] = _____56DE_950B_65B9_5411 ~= nil and _____56DE_950B_65B9_5411 or (_____53CD_51FB ~= nil and _____53CD_51FB["方向"] or _____8F93_5165_65B9_5411), ["已消费反击"] = _____53CD_51FB ~= nil or _____56DE_950B_65B9_5411 ~= nil, ["段回调ID"] = {}}
    debugLogForce(
        "椿-Q",
        "状态",
        "创建战斗技能实例",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____Q_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-"
    )
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "椿Q",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(______539F_56E0, _c)
            debugLogForce(
                "椿-Q",
                "结束",
                "玩家",
                GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                "四码",
                fourCCToStringSafe(____Q_6280_80FDID),
                "实例",
                _____6280_80FD_5B9E_4F8BID or "-",
                "原因",
                ______539F_56E0 or "-"
            )
            do
                local i = 0
                while i < #_____6570_636E["段回调ID"] do
                    i = i + 1
                end
            end
            _____6570_636E["段回调ID"] = {}
        end
    })
    local _____7B2C_4E00_6BB5ID = addDelayedCallback(
        ____Q_914D_7F6E["前摇毫秒"],
        function()
            if _____6570_636E["已消费反击"] then
                _____6267_884C_8FD4_5203_7B2C_4E00_6BB5(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
            else
                _____6267_884C_57FA_7840_5C45_5408(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
            end
        end
    )
    local ____6570_636E__6BB5_56DE_8C03ID_14 = _____6570_636E["段回调ID"]
    ____6570_636E__6BB5_56DE_8C03ID_14[#____6570_636E__6BB5_56DE_8C03ID_14 + 1] = _____7B2C_4E00_6BB5ID
    _____63A7_5236_5668["登记延迟回调"](_____7B2C_4E00_6BB5ID)
    _____767B_8BB0_693F_6E05_7406(
        _____65BD_6CD5_8005,
        "椿Q",
        function()
            if _____63A7_5236_5668 ~= nil then
                _____63A7_5236_5668["中断"]()
            end
        end
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院椿Q"] = function()
    debugLogForce("椿-Q", "注册", "名称", "注册朱雀院椿Q")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院椿-居合·返（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "ATQ1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EQ_5C45_5408,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 1.2
    })
end
____exports["朱雀院椿Q模块"] = {["技能ID"] = _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.Q["技能ID"], ["注册"] = ____exports["注册朱雀院椿Q"]}
return ____exports
