--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.00．配置")
local _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶技能配置"]
local _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院红叶动作槽"]
local _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C = ____00_FF0E_914D_7F6E["朱雀院红叶待平衡数值"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["查询战斗技能实例"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.25．限时二段技能壳")
local _____521B_5EFA_9650_65F6_4E8C_6BB5_6280_80FD_58F3 = ____require_result_4["创建限时二段技能壳"]
local _____786E_8BA4_9650_65F6_4E8C_6BB5_6280_80FD_58F3 = ____require_result_4["确认限时二段技能壳"]
local _____6E05_7406_9650_65F6_4E8C_6BB5_6280_80FD_58F3 = ____require_result_4["清理限时二段技能壳"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_5["开始冲锋"]
local _____505C_6B62_4F4D_79FB = ____require_result_5["停止位移"]
local platformAbilityApi = require("平台扩展API取值")
local platformAbilityAction = require("平台扩展API动作")
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_6["造成技能伤害"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_7["两点角度"]
local _____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____require_result_8["获取扇形区域单位"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.02．被动效果")
local _____65BD_52A0_6731_96C0_9662_7834_7EFD = ____require_result_9["施加朱雀院破绽"]
local _____5C1D_8BD5_6D88_8D39_4E00_5C42_5200_52BF = ____require_result_9["尝试消费一层刀势"]
local _____662F_6731_96C0_9662_7EA2_53F6 = ____require_result_9["是朱雀院红叶"]
local _____767B_8BB0_6731_96C0_9662_6E05_7406 = ____require_result_9["登记朱雀院清理"]
local _____64AD_653E_7EA2_53F6_52A8_4F5C = ____require_result_9["播放红叶动作"]
local _____8054_52A8E = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.05．E技能")
local _____8054_52A8D = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.07．D技能")
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E["单位类型ID"])
local ____Q_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.Q["技能ID"])
local ____Q2_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E["Q2技能ID"])
local ____Q_914D_7F6E = _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C.Q
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitFacing = jass.GetUnitFacing
local function _____7ED3_7B97Q_5355_4F53_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____6280_80FD_5B9E_4F8BID, _____4F24_5BB3_503C, _____6807_7B7E)
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3_503C,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FDID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = _____6807_7B7E,
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true
    })
end
local function _____5F00_542FQ2_7A97_53E3(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6570_636E, _____6301_7EED_79D2)
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = ____Q_914D_7F6E["Q2窗口秒"]
    end
    if _____6570_636E["Q2壳"] ~= nil then
        return
    end
    local _____58F3 = _____521B_5EFA_9650_65F6_4E8C_6BB5_6280_80FD_58F3({
        ["名称"] = "朱雀院红叶-Q2",
        ["单位"] = _____65BD_6CD5_8005,
        ["一段技能ID"] = ____Q_6280_80FDID,
        ["二段技能ID"] = ____Q2_6280_80FDID,
        ["持续秒"] = _____6301_7EED_79D2,
        ["超时回调"] = function(_____8D85_65F6_58F3)
            if _____6570_636E["Q2壳"] ~= _____8D85_65F6_58F3 then
                return
            end
            _____6570_636E["Q2壳"] = nil
            _____6570_636E["Q2到期时间"] = 0
            _____63A7_5236_5668["完成"](_____63A7_5236_5668)
        end
    })
    if _____58F3 ~= nil then
        _____6570_636E["Q2壳"] = _____58F3
        _____6570_636E["Q2到期时间"] = getGameTime() + _____6301_7EED_79D2
        _____767B_8BB0_6731_96C0_9662_6E05_7406(
            _____65BD_6CD5_8005,
            "红叶Q2窗口",
            function()
                if _____6570_636E["Q2壳"] ~= nil then
                    _____6E05_7406_9650_65F6_4E8C_6BB5_6280_80FD_58F3(_____6570_636E["Q2壳"])
                    _____6570_636E["Q2壳"] = nil
                    _____6570_636E["Q2到期时间"] = 0
                end
            end
        )
    else
        _____6570_636E["Q2到期时间"] = 0
        _____63A7_5236_5668["完成"](_____63A7_5236_5668)
    end
end
local function _____91CA_653EQ_98DE_71D5_7A7F(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_6731_96C0_9662_7EA2_53F6(_____65BD_6CD5_8005) then
        return
    end
    _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["Q冲刺"])
    if #_____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "红叶Q") > 0 then
        return
    end
    local _____8D77_70B9X = GetUnitX(_____65BD_6CD5_8005)
    local _____8D77_70B9Y = GetUnitY(_____65BD_6CD5_8005)
    local _____65B9_5411 = _____4E24_70B9_89D2_5EA6(
        _____8D77_70B9X,
        _____8D77_70B9Y,
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    local _____6570_636E = {
        ["位移ID"] = 0,
        ["已命中"] = false,
        ["已Q2"] = false,
        ["强化已消费"] = false,
        ["剑痕已读取"] = false,
        ["已延长窗口"] = false,
        ["Q2壳"] = nil,
        ["Q2到期时间"] = 0
    }
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "红叶Q",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(______539F_56E0, _c)
            if _____6570_636E["位移ID"] ~= 0 then
                _____505C_6B62_4F4D_79FB(_____6570_636E["位移ID"], "中断")
                _____6570_636E["位移ID"] = 0
            end
            if _____6570_636E["Q2壳"] ~= nil then
                _____6E05_7406_9650_65F6_4E8C_6BB5_6280_80FD_58F3(_____6570_636E["Q2壳"])
                _____6570_636E["Q2壳"] = nil
            end
            _____6570_636E["Q2到期时间"] = 0
        end
    })
    local _____4F4D_79FBID = _____5F00_59CB_51B2_950B(
        _____65BD_6CD5_8005,
        {
            ["角度"] = _____65B9_5411,
            ["距离"] = ____Q_914D_7F6E["突进距离"],
            ["每秒速度"] = ____Q_914D_7F6E["突进速度"],
            ["检查地形"] = true,
            ["朝向跟随位移"] = true,
            ["暂停单位"] = true,
            ["命中半径"] = ____Q_914D_7F6E["命中半径"],
            ["只命中敌人"] = true,
            ["命中后结束"] = true,
            ["允许重复命中"] = false,
            ["命中回调"] = function(______79FB_52A8_5355_4F4D, _____76EE_6807, ______4F4D_79FBID)
                if _____6570_636E["已命中"] then
                    return
                end
                _____6570_636E["已命中"] = true
                _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["Q命中斩"])
                _____7ED3_7B97Q_5355_4F53_4F24_5BB3(
                    _____65BD_6CD5_8005,
                    _____76EE_6807,
                    _____6280_80FD_5B9E_4F8BID,
                    _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____Q_914D_7F6E["伤害攻击力倍率"],
                    "朱雀院红叶-Q1"
                )
                _____65BD_52A0_6731_96C0_9662_7834_7EFD(_____65BD_6CD5_8005, _____76EE_6807)
                if _____8054_52A8D["尝试消费D强化"] ~= nil and _____8054_52A8D["尝试消费D强化"](_____65BD_6CD5_8005) then
                    _____7ED3_7B97Q_5355_4F53_4F24_5BB3(
                        _____65BD_6CD5_8005,
                        _____76EE_6807,
                        _____6280_80FD_5B9E_4F8BID,
                        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____Q_914D_7F6E["D刀光攻击力倍率"],
                        "朱雀院红叶-Q1D刀光"
                    )
                end
                _____5F00_542FQ2_7A97_53E3(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6570_636E)
            end,
            ["撞墙回调"] = function(_____79FB_52A8_5355_4F4D, ______4F4D_79FBID)
                local _____6700_5927 = platformAbilityApi["技能_获取技能最大冷却时间"](_____79FB_52A8_5355_4F4D, ____Q_6280_80FDID)
                platformAbilityAction["技能_设置技能冷却时间"](_____79FB_52A8_5355_4F4D, ____Q_6280_80FDID, ____Q_914D_7F6E["短惩罚冷却秒"], _____6700_5927)
            end,
            ["结束回调"] = function(______79FB_52A8_5355_4F4D, ______539F_56E0, ______4F4D_79FBID)
                _____6570_636E["位移ID"] = 0
                if not _____6570_636E["已命中"] then
                    _____63A7_5236_5668["完成"](_____63A7_5236_5668)
                end
            end
        }
    )
    _____6570_636E["位移ID"] = _____4F4D_79FBID
    if _____4F4D_79FBID == 0 then
        _____63A7_5236_5668["中断"](_____63A7_5236_5668)
    end
end
local function _____6267_884CQ2_56DE_8EAB_65A9(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["Q2回身斩"])
    local _____65B9_5411 = GetUnitFacing(_____65BD_6CD5_8005)
    local X = GetUnitX(_____65BD_6CD5_8005)
    local Y = GetUnitY(_____65BD_6CD5_8005)
    local _____6247_5F62_654C_4EBA = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = X,
        Y = Y,
        ["半径"] = ____Q_914D_7F6E["Q2扇形半径"],
        ["方向角"] = _____65B9_5411,
        ["扇形角度"] = ____Q_914D_7F6E["Q2扇形角度"],
        ["单位筛选"] = function(_____5355_4F4D)
            return _____5355_4F4D ~= _____65BD_6CD5_8005 and _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and jass.IsUnitEnemy(
                _____5355_4F4D,
                jass.GetOwningPlayer(_____65BD_6CD5_8005)
            )
        end
    })
    do
        local i = 0
        while i < #_____6247_5F62_654C_4EBA do
            _____7ED3_7B97Q_5355_4F53_4F24_5BB3(
                _____65BD_6CD5_8005,
                _____6247_5F62_654C_4EBA[i + 1],
                _____6280_80FD_5B9E_4F8BID,
                _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____Q_914D_7F6E["Q2伤害攻击力倍率"],
                "朱雀院红叶-Q2"
            )
            _____65BD_52A0_6731_96C0_9662_7834_7EFD(_____65BD_6CD5_8005, _____6247_5F62_654C_4EBA[i + 1])
            i = i + 1
        end
    end
    if not _____6570_636E["强化已消费"] then
        _____6570_636E["强化已消费"] = true
        if _____5C1D_8BD5_6D88_8D39_4E00_5C42_5200_52BF(_____65BD_6CD5_8005) then
            do
                local i = 0
                while i < #_____6247_5F62_654C_4EBA do
                    _____7ED3_7B97Q_5355_4F53_4F24_5BB3(
                        _____65BD_6CD5_8005,
                        _____6247_5F62_654C_4EBA[i + 1],
                        _____6280_80FD_5B9E_4F8BID,
                        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____Q_914D_7F6E["刀势剑气攻击力倍率"],
                        "朱雀院红叶-Q2刀势剑气"
                    )
                    i = i + 1
                end
            end
        end
    end
    if not _____6570_636E["剑痕已读取"] then
        _____6570_636E["剑痕已读取"] = true
        local ____temp_10
        if _____8054_52A8E["读取最近剑痕并锁定"] ~= nil then
            ____temp_10 = _____8054_52A8E["读取最近剑痕并锁定"](_____65BD_6CD5_8005)
        else
            ____temp_10 = nil
        end
        local _____5251_75D5 = ____temp_10
        if _____5251_75D5 ~= nil then
            do
                local i = 0
                while i < #_____6247_5F62_654C_4EBA do
                    _____7ED3_7B97Q_5355_4F53_4F24_5BB3(
                        _____65BD_6CD5_8005,
                        _____6247_5F62_654C_4EBA[i + 1],
                        _____6280_80FD_5B9E_4F8BID,
                        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____Q_914D_7F6E["剑痕回响攻击力倍率"],
                        "朱雀院红叶-Q2剑痕回响"
                    )
                    i = i + 1
                end
            end
        end
    end
    if _____6570_636E["Q2壳"] ~= nil then
        _____786E_8BA4_9650_65F6_4E8C_6BB5_6280_80FD_58F3(_____6570_636E["Q2壳"])
        _____6570_636E["Q2壳"] = nil
        _____6570_636E["Q2到期时间"] = 0
    end
    _____63A7_5236_5668["完成"](_____63A7_5236_5668)
end
local function _____91CA_653EQ2_56DE_8EAB_65A9(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_6731_96C0_9662_7EA2_53F6(_____65BD_6CD5_8005) then
        return
    end
    local _____6D3B_8DC3_5217_8868 = _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "红叶Q")
    do
        local i = 0
        while i < #_____6D3B_8DC3_5217_8868 do
            do
                local _____63A7_5236_5668 = _____6D3B_8DC3_5217_8868[i + 1]
                local _____6570_636E = _____63A7_5236_5668["数据"]
                if _____6570_636E == nil or _____6570_636E["已Q2"] then
                    goto __continue40
                end
                _____6570_636E["已Q2"] = true
                _____6267_884CQ2_56DE_8EAB_65A9(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
                return
            end
            ::__continue40::
            i = i + 1
        end
    end
end
local _____5DF2_6CE8_518C = false
--- W 成功招架后延长 Q2 窗口（最多延长一次，不无限刷新）
____exports["延长Q2窗口"] = function(_____65BD_6CD5_8005, _____5EF6_957F_79D2)
    if not _____662F_6731_96C0_9662_7EA2_53F6(_____65BD_6CD5_8005) then
        return
    end
    local _____6D3B_8DC3_5217_8868 = _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "红叶Q")
    do
        local i = 0
        while i < #_____6D3B_8DC3_5217_8868 do
            do
                local _____63A7_5236_5668 = _____6D3B_8DC3_5217_8868[i + 1]
                local _____6570_636E = _____63A7_5236_5668["数据"]
                if _____6570_636E == nil or _____6570_636E["Q2壳"] == nil or _____6570_636E["已Q2"] then
                    goto __continue45
                end
                if _____6570_636E["已延长窗口"] then
                    return
                end
                _____6570_636E["已延长窗口"] = true
                local _____5269_4F59_79D2 = _____6570_636E["Q2到期时间"] - getGameTime()
                local _____65B0_7A97_53E3_79D2 = (_____5269_4F59_79D2 > 0 and _____5269_4F59_79D2 or 0) + _____5EF6_957F_79D2
                _____6E05_7406_9650_65F6_4E8C_6BB5_6280_80FD_58F3(_____6570_636E["Q2壳"])
                _____6570_636E["Q2壳"] = nil
                _____6570_636E["Q2到期时间"] = 0
                _____5F00_542FQ2_7A97_53E3(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6570_636E, _____65B0_7A97_53E3_79D2)
                return
            end
            ::__continue45::
            i = i + 1
        end
    end
end
____exports["注册朱雀院红叶Q"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院红叶-飞燕·穿（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "AMQ1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EQ_98DE_71D5_7A7F,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 2.5
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院红叶-Q2回身斩（ASQ2）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "ASQ2",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EQ2_56DE_8EAB_65A9,
        ["创建独立技能实例"] = false
    })
end
____exports["朱雀院红叶Q模块"] = {["技能ID"] = _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.Q["技能ID"], ["二段技能ID"] = _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E["Q2技能ID"], ["二段窗口秒"] = ____Q_914D_7F6E["Q2窗口秒"], ["注册"] = ____exports["注册朱雀院红叶Q"]}
return ____exports
