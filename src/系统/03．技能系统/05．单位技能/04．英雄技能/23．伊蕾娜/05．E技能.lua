--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.00．配置")
local _____4F0A_857E_5A1C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜技能配置"]
local _____4F0A_857E_5A1CE_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜E配置"]
local _____4F0A_857E_5A1C_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜表现配置"]
local _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜变式效果配置"]
local _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜模型动作配置"]
local _____4F0A_857E_5A1C_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜音效配置"]
local ____01A_FF0E_52A8_4F5C_8868_73B0 = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.01A．动作表现")
local _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C = ____01A_FF0E_52A8_4F5C_8868_73B0["播放伊蕾娜阶段动作"]
local _____5F00_59CB_4F0A_857E_5A1C_5FAA_73AF_52A8_4F5C = ____01A_FF0E_52A8_4F5C_8868_73B0["开始伊蕾娜循环动作"]
local _____505C_6B62_4F0A_857E_5A1C_5FAA_73AF_52A8_4F5C = ____01A_FF0E_52A8_4F5C_8868_73B0["停止伊蕾娜循环动作"]
local ____02_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.02．被动效果")
local _____8BB0_5F55_4F0A_857E_5A1C_89C1_95FB = ____02_FF0E_88AB_52A8_6548_679C["记录伊蕾娜见闻"]
local _____8BB0_5F55_4F0A_857E_5A1C_626B_5E1A_8DEF_7EBF = ____02_FF0E_88AB_52A8_6548_679C["记录伊蕾娜扫帚路线"]
local _____83B7_53D6_4F0A_857E_5A1C_53D8_5F0F = ____02_FF0E_88AB_52A8_6548_679C["获取伊蕾娜变式"]
local _____6D88_8D39_4F0A_857E_5A1C_53D8_5F0F_7528_4E8E = ____02_FF0E_88AB_52A8_6548_679C["消费伊蕾娜变式用于"]
local _____767B_8BB0_4F0A_857E_5A1C_6280_80FD_6E05_7406 = ____02_FF0E_88AB_52A8_6548_679C["登记伊蕾娜技能清理"]
local ____require_result_0 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_0["播放英雄技能喊话"]
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local SetUnitFacing = jass.SetUnitFacing
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_4["注册单位技能壳监听"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_5["创建战斗技能实例"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_6["开始冲锋"]
local _____505C_6B62_4F4D_79FB = ____require_result_6["停止位移"]
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_7["造成技能伤害"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_8["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_8["两点角度"]
local _____5355_4F4D_5B58_6D3B = ____require_result_8["单位存活"]
local _____8DDD_79BBXY = ____require_result_8["距离XY"]
local _____6781_5750_6807X = ____require_result_8["极坐标X"]
local _____6781_5750_6807Y = ____require_result_8["极坐标Y"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_9["获取坐标范围敌人"]
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_10["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_10["移除单位暂停"]
local ____require_result_11 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setSlow = ____require_result_11.SFB_setSlow
local ____require_result_12 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统")
local _____5F00_59CB_62A4_76FE = ____require_result_12["开始护盾"]
local _____79FB_9664_62A4_76FE = ____require_result_12["移除护盾"]
local ____require_result_13 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_13["创建点特效"]
local ____require_result_14 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_14.Sound3DII_UnitPlayReuse
local ____require_result_15 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_15.Sound3DII_CooPlayReuse
local ____require_result_16 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_16.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____4F0A_857E_5A1C_6280_80FD_914D_7F6E["单位类型ID"]
local ____E_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____4F0A_857E_5A1C_6280_80FD_914D_7F6E.E["技能ID"])
local ____E_786C_76F4_6765_6E90 = "伊蕾娜-E硬直"
--- 终点冲击 + 扫帚路线 + 远行见闻（只在完成原因时调用）。
local function _____7ED3_7B97E_5230_8FBE(_____65BD_6CD5_8005, _____5B9E_4F8BID, _____6570_636E)
    debugLogForce("伊蕾娜-E", "结束", "原因", "完成")
    local X = GetUnitX(_____65BD_6CD5_8005)
    local Y = GetUnitY(_____65BD_6CD5_8005)
    _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C(_____65BD_6CD5_8005, _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["E落地"])
    local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____65BD_6CD5_8005, X, Y, _____4F0A_857E_5A1CE_914D_7F6E["冲击半径"])
    local _____51B2_51FB_4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F0A_857E_5A1CE_914D_7F6E["冲击伤害攻击力倍率"]
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                if not _____5355_4F4D_5B58_6D3B(_____654C_4EBA) then
                    goto __continue4
                end
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____65BD_6CD5_8005,
                    ["目标"] = _____654C_4EBA,
                    ["伤害"] = _____51B2_51FB_4F24_5BB3,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    ["攻击类型"] = ATTACK_TYPE_NORMAL,
                    ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____E_6280_80FD_7C7B_578BID,
                    ["技能实例ID"] = _____5B9E_4F8BID,
                    ["标签"] = "伊蕾娜-扫帚冲击",
                    ["伤害形态"] = "AOE",
                    ["参与技能伤害加成"] = true
                })
                SFB_setSlow(
                    _____65BD_6CD5_8005,
                    _____654C_4EBA,
                    0,
                    _____4F0A_857E_5A1CE_914D_7F6E["冲击减速比例"],
                    _____4F0A_857E_5A1CE_914D_7F6E["冲击减速秒"],
                    "伊蕾娜-落地风压",
                    "技能"
                )
            end
            ::__continue4::
            i = i + 1
        end
    end
    if _____6570_636E["灰烬爆发"] then
        local _____7070_70EC_654C_4EBA = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____65BD_6CD5_8005, X, Y, _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E["灰烬_爆发半径"])
        local _____7070_70EC_4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E["灰烬_爆发伤害攻击力倍率"]
        do
            local i = 0
            while i < #_____7070_70EC_654C_4EBA do
                do
                    local _____654C_4EBA = _____7070_70EC_654C_4EBA[i + 1]
                    if not _____5355_4F4D_5B58_6D3B(_____654C_4EBA) then
                        goto __continue8
                    end
                    _____9020_6210_6280_80FD_4F24_5BB3({
                        ["来源"] = _____65BD_6CD5_8005,
                        ["目标"] = _____654C_4EBA,
                        ["伤害"] = _____7070_70EC_4F24_5BB3,
                        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                        ["攻击类型"] = ATTACK_TYPE_NORMAL,
                        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "单位技能",
                        ["技能ID"] = ____E_6280_80FD_7C7B_578BID,
                        ["技能实例ID"] = _____5B9E_4F8BID,
                        ["标签"] = "伊蕾娜-远行灰烬爆发",
                        ["伤害形态"] = "AOE",
                        ["参与技能伤害加成"] = true
                    })
                end
                ::__continue8::
                i = i + 1
            end
        end
    end
    local _____6CE2_7EB9 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E落地波纹"]["模型路径"],
        RGB = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E落地波纹"].RGB,
        X = X,
        Y = Y,
        Z = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E落地波纹"]["高度"],
        ["缩放"] = _____4F0A_857E_5A1CE_914D_7F6E["冲击半径"] / _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E落地波纹"]["基准半径"] * _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E落地波纹"]["基准缩放"],
        ["持续秒"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E落地波纹"]["持续秒"]
    })
    local ____ = _____6CE2_7EB9
    Sound3DII_CooPlayReuse(
        _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["E落地"]["路径"],
        X,
        Y,
        _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["E落地"]["高度"],
        _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["E落地"]["裁断距离"]
    )
    _____8BB0_5F55_4F0A_857E_5A1C_626B_5E1A_8DEF_7EBF(
        _____65BD_6CD5_8005,
        _____6570_636E["起点X"],
        _____6570_636E["起点Y"],
        _____6570_636E["终点X"],
        _____6570_636E["终点Y"],
        _____6570_636E["方向角"]
    )
    _____8BB0_5F55_4F0A_857E_5A1C_89C1_95FB(_____65BD_6CD5_8005, "远行", _____5B9E_4F8BID)
end
local function _____91CA_653EE_626B_5E1A_8FDC_884C(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    debugLogForce("伊蕾娜-E", "释放", "技能实例ID", _____6280_80FD_5B9E_4F8BID or "-")
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____8D77_70B9X = GetUnitX(_____65BD_6CD5_8005)
    local _____8D77_70B9Y = GetUnitY(_____65BD_6CD5_8005)
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(_____8D77_70B9X, _____8D77_70B9Y, _____76EE_6807X, _____76EE_6807Y)
    local _____6570_636E = {
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["起点X"] = _____8D77_70B9X,
        ["起点Y"] = _____8D77_70B9Y,
        ["方向角"] = _____65B9_5411_89D2,
        ["终点X"] = 0,
        ["终点Y"] = 0,
        ["原飞行高度"] = GetUnitFlyHeight(_____65BD_6CD5_8005),
        ["护盾ID"] = 0,
        ["位移ID"] = 0,
        ["飞行动作守护"] = nil,
        ["灰烬爆发"] = false
    }
    local function _____6CE8_9500_7EDF_4E00_6E05_7406()
    end
    local _____5B9E_4F8B = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "E扫帚远行",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(_____539F_56E0, ______63A7_5236_5668)
            _____6CE8_9500_7EDF_4E00_6E05_7406()
            if _____539F_56E0 ~= "完成" and _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C(_____65BD_6CD5_8005, _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["E中断恢复"])
            end
        end
    })
    _____6CE8_9500_7EDF_4E00_6E05_7406 = _____767B_8BB0_4F0A_857E_5A1C_6280_80FD_6E05_7406(
        _____65BD_6CD5_8005,
        "E远行-" .. tostring(_____5B9E_4F8B["实例ID"]),
        function()
            if not _____5B9E_4F8B["已结束"](_____5B9E_4F8B) then
                _____5B9E_4F8B["结束"](_____5B9E_4F8B, "中断")
            end
        end
    )
    _____5B9E_4F8B["登记自定义清理"](
        _____5B9E_4F8B,
        "E公共收口",
        function()
            if _____6570_636E["位移ID"] > 0 then
                _____505C_6B62_4F4D_79FB(_____6570_636E["位移ID"], "中断")
                _____6570_636E["位移ID"] = 0
            end
            if _____6570_636E["护盾ID"] ~= 0 then
                _____79FB_9664_62A4_76FE(_____6570_636E["护盾ID"])
                _____6570_636E["护盾ID"] = 0
            end
            _____505C_6B62_4F0A_857E_5A1C_5FAA_73AF_52A8_4F5C(_____6570_636E["飞行动作守护"])
            _____6570_636E["飞行动作守护"] = nil
            if _____65BD_6CD5_8005 ~= nil and _____65BD_6CD5_8005 ~= 0 then
                SetUnitFlyHeight(_____65BD_6CD5_8005, _____6570_636E["原飞行高度"], _____4F0A_857E_5A1CE_914D_7F6E["高度恢复率"])
                _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, ____E_786C_76F4_6765_6E90)
            end
        end
    )
    local _____9884_8BFB_53D8_5F0F = _____83B7_53D6_4F0A_857E_5A1C_53D8_5F0F(_____65BD_6CD5_8005)
    local _____7528_8FC5_884C = _____9884_8BFB_53D8_5F0F == "迅行"
    local _____7528_7070_70EC = _____9884_8BFB_53D8_5F0F == "灰烬"
    local _____4F4D_79FB_8DDD_79BB = _____4F0A_857E_5A1CE_914D_7F6E["位移距离"]
    if _____7528_8FC5_884C then
        _____4F4D_79FB_8DDD_79BB = _____4F4D_79FB_8DDD_79BB * _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E["迅行_E位移距离倍率"]
    end
    local _____5230_70B9_8DDD_79BB = _____8DDD_79BBXY(_____8D77_70B9X, _____8D77_70B9Y, _____76EE_6807X, _____76EE_6807Y)
    local _____6700_7EC8_8DDD_79BB = _____5230_70B9_8DDD_79BB < _____4F4D_79FB_8DDD_79BB and _____5230_70B9_8DDD_79BB or _____4F4D_79FB_8DDD_79BB
    _____6570_636E["终点X"] = _____6781_5750_6807X(_____8D77_70B9X, _____65B9_5411_89D2, _____6700_7EC8_8DDD_79BB)
    _____6570_636E["终点Y"] = _____6781_5750_6807Y(_____8D77_70B9Y, _____65B9_5411_89D2, _____6700_7EC8_8DDD_79BB)
    if _____6DFB_52A0_5355_4F4D_6682_505C(_____65BD_6CD5_8005, ____E_786C_76F4_6765_6E90) then
        SetUnitFacing(_____65BD_6CD5_8005, _____65B9_5411_89D2)
        _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C(_____65BD_6CD5_8005, _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["E起飞"])
    end
    _____5B9E_4F8B["登记延迟回调"](
        _____5B9E_4F8B,
        addDelayedCallback(
            _____4F0A_857E_5A1CE_914D_7F6E["硬直秒"] * 1000,
            function()
                if _____5B9E_4F8B["已结束"](_____5B9E_4F8B) then
                    return
                end
                _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, ____E_786C_76F4_6765_6E90)
                if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                    return
                end
                local _____98CE_538B = _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E起飞风压"]["模型路径"],
                    RGB = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E起飞风压"].RGB,
                    X = GetUnitX(_____65BD_6CD5_8005),
                    Y = GetUnitY(_____65BD_6CD5_8005),
                    Z = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E起飞风压"]["高度"],
                    ["缩放"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E起飞风压"]["缩放"],
                    ["持续秒"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E起飞风压"]["持续秒"]
                })
                local ____ = _____98CE_538B
                _____6570_636E["护盾ID"] = _____5F00_59CB_62A4_76FE(
                    _____65BD_6CD5_8005,
                    {
                        ["类型"] = 0,
                        ["数值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F0A_857E_5A1CE_914D_7F6E["位移护盾攻击力倍率"],
                        ["持续时间"] = _____6700_7EC8_8DDD_79BB / _____4F0A_857E_5A1CE_914D_7F6E["每秒速度"] + 0.3,
                        ["来源单位"] = _____65BD_6CD5_8005,
                        ["标签"] = "伊蕾娜-扫帚远行",
                        ["显示护盾条"] = false
                    }
                )
                SetUnitFlyHeight(_____65BD_6CD5_8005, _____4F0A_857E_5A1CE_914D_7F6E["飞行高度"], _____4F0A_857E_5A1CE_914D_7F6E["高度恢复率"])
                debugLogForce(
                    "伊蕾娜-E",
                    "位移",
                    "类型",
                    "冲锋",
                    "距离",
                    _____6700_7EC8_8DDD_79BB
                )
                local _____4F4D_79FBID = _____5F00_59CB_51B2_950B(
                    _____65BD_6CD5_8005,
                    {
                        ["距离"] = _____6700_7EC8_8DDD_79BB,
                        ["角度"] = _____65B9_5411_89D2,
                        ["每秒速度"] = _____4F0A_857E_5A1CE_914D_7F6E["每秒速度"],
                        ["检查地形"] = true,
                        ["暂停单位"] = false,
                        ["位移特效"] = "",
                        ["动画名"] = _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["E飞行"]["名称"],
                        ["开始回调"] = function()
                            _____6570_636E["飞行动作守护"] = _____5F00_59CB_4F0A_857E_5A1C_5FAA_73AF_52A8_4F5C(_____65BD_6CD5_8005, _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["E飞行"])
                        end,
                        ["结束回调"] = function(_____79FB_52A8_5355_4F4D, _____539F_56E0, ______4F4D_79FBID, ______547D_4E2D_76EE_6807)
                            if _____79FB_52A8_5355_4F4D ~= nil and _____79FB_52A8_5355_4F4D ~= 0 and _____5355_4F4D_5B58_6D3B(_____79FB_52A8_5355_4F4D) then
                                SetUnitFlyHeight(_____79FB_52A8_5355_4F4D, _____6570_636E["原飞行高度"], _____4F0A_857E_5A1CE_914D_7F6E["高度恢复率"])
                            end
                            local _____662F_5B8C_6210 = _____539F_56E0 == "完成"
                            local _____5DF2_6536_675F = _____5B9E_4F8B["已结束"](_____5B9E_4F8B)
                            if not _____5DF2_6536_675F and _____662F_5B8C_6210 then
                                _____7ED3_7B97E_5230_8FBE(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
                                _____5B9E_4F8B["完成"](_____5B9E_4F8B)
                            elseif not _____5DF2_6536_675F then
                                _____5B9E_4F8B["结束"](_____5B9E_4F8B, (_____539F_56E0 == "死亡" or _____539F_56E0 == "主单位死亡") and "施法者死亡" or "中断")
                            end
                        end
                    }
                )
                _____6570_636E["位移ID"] = _____4F4D_79FBID
                if _____4F4D_79FBID > 0 then
                    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "伊蕾娜", _____4F0A_857E_5A1C_6280_80FD_914D_7F6E.E["技能ID"])
                    Sound3DII_UnitPlayReuse(_____4F0A_857E_5A1C_97F3_6548_914D_7F6E["E起飞"]["路径"], _____65BD_6CD5_8005, _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["E起飞"]["裁断距离"])
                    if _____7528_8FC5_884C or _____7528_7070_70EC then
                        local _____5DF2_6D88_8D39 = _____6D88_8D39_4F0A_857E_5A1C_53D8_5F0F_7528_4E8E(_____65BD_6CD5_8005, "E")
                        _____6570_636E["灰烬爆发"] = _____5DF2_6D88_8D39 == "灰烬"
                    end
                    local _____5C3E_8FF9_8BA1_6570 = 0
                    _____5B9E_4F8B["登记周期回调"](
                        _____5B9E_4F8B,
                        addPeriodicCallback(
                            _____4F0A_857E_5A1CE_914D_7F6E["尾迹间隔毫秒"],
                            function()
                                if _____5B9E_4F8B["已结束"](_____5B9E_4F8B) or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                                    return
                                end
                                _____5C3E_8FF9_8BA1_6570 = _____5C3E_8FF9_8BA1_6570 + 1
                                local _____8868_73B0 = _____5C3E_8FF9_8BA1_6570 % 2 == 0 and _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E飞行轨迹"] or _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["E星光轨迹"]
                                local _____661F_8FF9 = _____521B_5EFA_70B9_7279_6548({
                                    ["模型路径"] = _____8868_73B0["模型路径"],
                                    RGB = _____8868_73B0.RGB,
                                    X = GetUnitX(_____65BD_6CD5_8005),
                                    Y = GetUnitY(_____65BD_6CD5_8005),
                                    Z = _____8868_73B0["高度"],
                                    ["缩放"] = _____8868_73B0["缩放"],
                                    ["持续秒"] = _____8868_73B0["持续秒"]
                                })
                                local ____ = _____661F_8FF9
                            end
                        )
                    )
                else
                    SetUnitFlyHeight(_____65BD_6CD5_8005, _____6570_636E["原飞行高度"], _____4F0A_857E_5A1CE_914D_7F6E["高度恢复率"])
                    _____5B9E_4F8B["结束"](_____5B9E_4F8B, "中断")
                end
            end
        )
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册伊蕾娜E"] = function()
    debugLogForce("伊蕾娜-E", "注册", "名称", "注册伊蕾娜E")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "伊蕾娜-扫帚·远行（E）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____4F0A_857E_5A1C_6280_80FD_914D_7F6E.E["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EE_626B_5E1A_8FDC_884C,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 6
    })
end
return ____exports
