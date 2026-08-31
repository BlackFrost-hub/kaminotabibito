--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____7ED3_7B97W_5355_4F53_4F24_5BB3, _____91CA_653E_5931_8D25_524D_65A9, jass, _____9020_6210_6280_80FD_4F24_5BB3, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____5355_4F4D_5B58_6D3B, _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D, _____65BD_52A0_6731_96C0_9662_7834_7EFD, _____64AD_653E_7EA2_53F6_52A8_4F5C, ____W_6280_80FDID, ____W_914D_7F6E, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, GetUnitX, GetUnitY, GetUnitFacing
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.00．配置")
local _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶技能配置"]
local _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶表现配置"]
local _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶音效配置"]
local _____6731_96C0_9662_7EA2_53F6Buff_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶Buff配置"]
local _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院红叶动作槽"]
local _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C = ____00_FF0E_914D_7F6E["朱雀院红叶待平衡数值"]
function _____7ED3_7B97W_5355_4F53_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____6280_80FD_5B9E_4F8BID, _____4F24_5BB3_503C, _____6807_7B7E)
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3_503C,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FDID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = _____6807_7B7E,
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true
    })
end
function _____91CA_653E_5931_8D25_524D_65A9(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["W失败前斩"])
    local _____65B9_5411 = GetUnitFacing(_____65BD_6CD5_8005)
    local X = GetUnitX(_____65BD_6CD5_8005)
    local Y = GetUnitY(_____65BD_6CD5_8005)
    local _____6247_5F62_654C_4EBA = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = X,
        Y = Y,
        ["半径"] = ____W_914D_7F6E["前斩半径"],
        ["方向角"] = _____65B9_5411,
        ["扇形角度"] = ____W_914D_7F6E["前斩扇形角度"],
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
            _____7ED3_7B97W_5355_4F53_4F24_5BB3(
                _____65BD_6CD5_8005,
                _____6247_5F62_654C_4EBA[i + 1],
                _____6280_80FD_5B9E_4F8BID,
                _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____W_914D_7F6E["前斩攻击力倍率"],
                "朱雀院红叶-W失败前斩"
            )
            _____65BD_52A0_6731_96C0_9662_7834_7EFD(_____65BD_6CD5_8005, _____6247_5F62_654C_4EBA[i + 1])
            i = i + 1
        end
    end
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["查询战斗技能实例"]
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_4.registerDamageModifier
local unregisterDamageModifier = ____require_result_4.unregisterDamageModifier
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_5["开始击退"]
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_6["造成技能伤害"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
_____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_7["两点角度"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
_____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____require_result_8["获取扇形区域单位"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具")
local _____4E24_70B9_65B9_5411_89D2 = ____require_result_9["两点方向角"]
local _____89D2_5EA6_5DEE_7EDD_5BF9_503C = ____require_result_9["角度差绝对值"]
local ____require_result_10 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_10.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_10["移除单位指定Buff"]
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_11.createUnitEffect
local destroyUnitEffect = ____require_result_11.destroyUnitEffect
local _____8BBE_7F6E_7279_6548_7F29_653E = ____require_result_11["设置特效缩放"]
local ____require_result_12 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_12.Sound3DII_UnitPlayReuse
local Sound3DII_CooPlayReuse = ____require_result_12.Sound3DII_CooPlayReuse
local ____require_result_13 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_13["播放英雄技能喊话"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.02．被动效果")
_____65BD_52A0_6731_96C0_9662_7834_7EFD = ____require_result_14["施加朱雀院破绽"]
local _____5C1D_8BD5_6D88_8D39_4E00_5C42_5200_52BF = ____require_result_14["尝试消费一层刀势"]
local _____589E_52A0_5200_52BF = ____require_result_14["增加刀势"]
local _____662F_6731_96C0_9662_7EA2_53F6 = ____require_result_14["是朱雀院红叶"]
local _____767B_8BB0_6731_96C0_9662_6E05_7406 = ____require_result_14["登记朱雀院清理"]
_____64AD_653E_7EA2_53F6_52A8_4F5C = ____require_result_14["播放红叶动作"]
local _____8054_52A8D = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.07．D技能")
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.03．Q技能")
local _____5EF6_957FQ2_7A97_53E3 = ____require_result_15["延长Q2窗口"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E["单位类型ID"])
____W_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.W["技能ID"])
local _____6C34_955CBuffID = _____6731_96C0_9662_7EA2_53F6Buff_914D_7F6E["水镜招架"]
____W_914D_7F6E = _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C.W
local ____W_6C34_955C_5C55_5F00_97F3_6548 = _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E["W水镜展开"]
local ____W_62DB_67B6_6210_529F_97F3_6548 = _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E["W招架成功"]
local ____W_8FD4_5203_53CD_51FB_97F3_6548 = _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E["W返刃反击"]
local _____6C34_955C_7279_6548_952E = "朱雀院红叶W水镜"
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
local function _____7ED3_675FW_62DB_67B6(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    if _____6570_636E["已结束"] then
        return
    end
    _____6570_636E["已结束"] = true
    if _____6570_636E["修饰ID"] ~= 0 then
        unregisterDamageModifier(_____6570_636E["修饰ID"])
        _____6570_636E["修饰ID"] = 0
    end
    destroyUnitEffect(_____65BD_6CD5_8005, _____6C34_955C_7279_6548_952E)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_8005, _____6C34_955CBuffID)
    if not _____6570_636E["已招架"] then
        _____91CA_653E_5931_8D25_524D_65A9(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    end
    _____63A7_5236_5668["完成"](_____63A7_5236_5668)
end
local function _____7ED3_7B97W_53CD_51FB(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    local _____6765_6E90 = _____6570_636E["招架来源"]
    if _____6765_6E90 == nil or _____6765_6E90 == 0 or not _____5355_4F4D_5B58_6D3B(_____6765_6E90) then
        _____7ED3_675FW_62DB_67B6(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
        return
    end
    _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["W成功反击"])
    Sound3DII_CooPlayReuse(
        ____W_8FD4_5203_53CD_51FB_97F3_6548["路径"],
        GetUnitX(_____6765_6E90),
        GetUnitY(_____6765_6E90),
        ____W_8FD4_5203_53CD_51FB_97F3_6548["高度"],
        ____W_8FD4_5203_53CD_51FB_97F3_6548["裁断距离"]
    )
    _____7ED3_7B97W_5355_4F53_4F24_5BB3(
        _____65BD_6CD5_8005,
        _____6765_6E90,
        _____6280_80FD_5B9E_4F8BID,
        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____W_914D_7F6E["反击攻击力倍率"],
        "朱雀院红叶-W反击"
    )
    _____65BD_52A0_6731_96C0_9662_7834_7EFD(_____65BD_6CD5_8005, _____6765_6E90)
    _____589E_52A0_5200_52BF(_____65BD_6CD5_8005, 1)
    _____5EF6_957FQ2_7A97_53E3(_____65BD_6CD5_8005, ____W_914D_7F6E["Q2延长秒"])
    if not _____6570_636E["刀势已消费"] then
        _____6570_636E["刀势已消费"] = true
        if _____5C1D_8BD5_6D88_8D39_4E00_5C42_5200_52BF(_____65BD_6CD5_8005) then
            _____7ED3_7B97W_5355_4F53_4F24_5BB3(
                _____65BD_6CD5_8005,
                _____6765_6E90,
                _____6280_80FD_5B9E_4F8BID,
                _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____W_914D_7F6E["回刃剑气攻击力倍率"],
                "朱雀院红叶-W回刃剑气"
            )
        end
    end
    if _____8054_52A8D["尝试消费D强化"] ~= nil and _____8054_52A8D["尝试消费D强化"](_____65BD_6CD5_8005) then
        local _____6765_6E90X = GetUnitX(_____6765_6E90)
        local _____6765_6E90Y = GetUnitY(_____6765_6E90)
        local _____62C9_56DE_89D2_5EA6 = _____4E24_70B9_89D2_5EA6(
            _____6765_6E90X,
            _____6765_6E90Y,
            GetUnitX(_____65BD_6CD5_8005),
            GetUnitY(_____65BD_6CD5_8005)
        )
        _____5F00_59CB_51FB_9000(_____6765_6E90, {["距离"] = ____W_914D_7F6E["D强化拉回距离"], ["角度"] = _____62C9_56DE_89D2_5EA6, ["来源单位"] = _____65BD_6CD5_8005, ["主单位死亡时中断"] = true})
    end
    _____7ED3_675FW_62DB_67B6(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
end
local function _____91CA_653EW_6C34_955C_8FD4_5203(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_6731_96C0_9662_7EA2_53F6(_____65BD_6CD5_8005) then
        return
    end
    _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["W开窗"])
    if #_____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "红叶W") > 0 then
        return
    end
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "朱雀院红叶", _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.W["技能ID"])
    local _____6570_636E = {
        ["方向角"] = GetUnitFacing(_____65BD_6CD5_8005),
        ["修饰ID"] = 0,
        ["已招架"] = false,
        ["已结束"] = false,
        ["招架来源"] = nil,
        ["刀势已消费"] = false
    }
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "红叶W",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(______539F_56E0, _c)
            if _____6570_636E["已结束"] then
                return
            end
            _____6570_636E["已结束"] = true
            if _____6570_636E["修饰ID"] ~= 0 then
                unregisterDamageModifier(_____6570_636E["修饰ID"])
            end
            destroyUnitEffect(_____65BD_6CD5_8005, _____6C34_955C_7279_6548_952E)
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_8005, _____6C34_955CBuffID)
        end
    })
    local _____6C34_955C_7279_6548 = createUnitEffect(
        _____65BD_6CD5_8005,
        "origin",
        _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["水镜主体"]["模型路径"],
        _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["水镜主体"]["持续秒"],
        _____6C34_955C_7279_6548_952E
    )
    _____8BBE_7F6E_7279_6548_7F29_653E(_____6C34_955C_7279_6548, _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["水镜主体"]["缩放"])
    registerManualBuff(
        _____65BD_6CD5_8005,
        _____6C34_955CBuffID,
        ____W_914D_7F6E["招架窗口秒"],
        1,
        {stack = 1}
    )
    Sound3DII_UnitPlayReuse(____W_6C34_955C_5C55_5F00_97F3_6548["路径"], _____65BD_6CD5_8005, ____W_6C34_955C_5C55_5F00_97F3_6548["裁断距离"])
    _____6570_636E["修饰ID"] = registerDamageModifier(
        function(context)
            if _____6570_636E["已招架"] or _____6570_636E["已结束"] then
                return context.currentDamage
            end
            if context.target ~= _____65BD_6CD5_8005 then
                return context.currentDamage
            end
            if context.attacker == nil or context.attacker == 0 then
                return context.currentDamage
            end
            local _____6765_6E90_65B9_5411 = _____4E24_70B9_65B9_5411_89D2(
                GetUnitX(_____65BD_6CD5_8005),
                GetUnitY(_____65BD_6CD5_8005),
                GetUnitX(context.attacker),
                GetUnitY(context.attacker)
            )
            if _____89D2_5EA6_5DEE_7EDD_5BF9_503C(_____6570_636E["方向角"], _____6765_6E90_65B9_5411) > ____W_914D_7F6E["正面角度"] / 2 then
                return context.currentDamage
            end
            _____6570_636E["已招架"] = true
            _____6570_636E["招架来源"] = context.attacker
            addDelayedCallback(
                0,
                function()
                    Sound3DII_UnitPlayReuse(____W_62DB_67B6_6210_529F_97F3_6548["路径"], _____65BD_6CD5_8005, ____W_62DB_67B6_6210_529F_97F3_6548["裁断距离"])
                    _____7ED3_7B97W_53CD_51FB(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
                end
            )
            return 0
        end,
        60
    )
    local _____5230_671FID = addDelayedCallback(
        ____W_914D_7F6E["招架窗口秒"] * 1000,
        function()
            _____7ED3_675FW_62DB_67B6(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
        end
    )
    _____63A7_5236_5668["登记延迟回调"](_____63A7_5236_5668, _____5230_671FID)
    _____767B_8BB0_6731_96C0_9662_6E05_7406(
        _____65BD_6CD5_8005,
        "红叶W招架",
        function()
            _____63A7_5236_5668["中断"](_____63A7_5236_5668)
        end
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院红叶W"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院红叶-水镜·返刃（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "AMW1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EW_6C34_955C_8FD4_5203,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 1.5
    })
end
____exports["朱雀院红叶W模块"] = {["技能ID"] = _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.W["技能ID"], ["招架窗口秒"] = ____W_914D_7F6E["招架窗口秒"], ["注册"] = ____exports["注册朱雀院红叶W"]}
return ____exports
