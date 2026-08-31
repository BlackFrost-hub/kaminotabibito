--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____7ED3_675FW_62DB_67B6, jass, unregisterDamageModifier, _____9020_6210_6280_80FD_4F24_5BB3, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____5355_4F4D_5B58_6D3B, _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D, destroyUnitEffect, Sound3DII_CooPlayReuse, _____6062_590DVF, ____W_6280_80FDID, ____W_914D_7F6E, _____62DB_67B6_7279_6548_952E, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, GetUnitX, GetUnitY
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.00．配置")
local _____6731_96C0_9662_693F_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿技能配置"]
local _____6731_96C0_9662_693F_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿表现配置"]
local _____6731_96C0_9662_693F_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院椿动作槽"]
local _____6731_96C0_9662_693FW_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿W配置"]
local _____6731_96C0_9662_693F_88AB_52A8_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿被动配置"]
local _____6731_96C0_9662_693F_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿音效配置"]
function _____7ED3_675FW_62DB_67B6(_____65BD_6CD5_8005, ______6280_80FD_5B9E_4F8BID, _____6570_636E)
    if _____6570_636E["已结束"] then
        return
    end
    _____6570_636E["已结束"] = true
    if _____6570_636E["修饰ID"] ~= 0 then
        unregisterDamageModifier(_____6570_636E["修饰ID"])
        _____6570_636E["修饰ID"] = 0
    end
    destroyUnitEffect(_____65BD_6CD5_8005, _____62DB_67B6_7279_6548_952E)
    if not _____6570_636E["已招架"] then
        _____6062_590DVF(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_88AB_52A8_914D_7F6E["收刀恢复VF"])
        local _____65B9_5411 = _____6570_636E["方向角"]
        local X = GetUnitX(_____65BD_6CD5_8005)
        local Y = GetUnitY(_____65BD_6CD5_8005)
        Sound3DII_CooPlayReuse(
            _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["W收刀斩"]["路径"],
            X,
            Y,
            _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["W收刀斩"]["高度"],
            _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["W收刀斩"]["裁断距离"]
        )
        local _____654C_4EBA = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
            X = X,
            Y = Y,
            ["半径"] = ____W_914D_7F6E["收刀扇形半径"],
            ["方向角"] = _____65B9_5411,
            ["扇形角度"] = ____W_914D_7F6E["收刀扇形角度"],
            ["单位筛选"] = function(_____5355_4F4D)
                return _____5355_4F4D ~= _____65BD_6CD5_8005 and _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and jass.IsUnitEnemy(
                    _____5355_4F4D,
                    jass.GetOwningPlayer(_____65BD_6CD5_8005)
                )
            end
        })
        do
            local i = 0
            while i < #_____654C_4EBA do
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____65BD_6CD5_8005,
                    ["目标"] = _____654C_4EBA[i + 1],
                    ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____W_914D_7F6E["收刀斩倍率"],
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    ["攻击类型"] = ATTACK_TYPE_NORMAL,
                    ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____W_6280_80FDID,
                    ["技能实例ID"] = nil,
                    ["标签"] = "朱雀院椿-W收刀斩",
                    ["伤害形态"] = "AOE",
                    ["参与技能伤害加成"] = true
                })
                i = i + 1
            end
        end
    end
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["查询战斗技能实例"]
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_4.registerDamageModifier
unregisterDamageModifier = ____require_result_4.unregisterDamageModifier
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_5["造成技能伤害"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
_____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_6["两点角度"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
_____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____require_result_7["获取扇形区域单位"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具")
local _____5355_4F4D_662F_5426_5728_6765_6E90_6B63_9762_6247_533A = ____require_result_8["单位是否在来源正面扇区"]
local _____89D2_5EA6_5DEE_7EDD_5BF9_503C = ____require_result_8["角度差绝对值"]
local ____require_result_9 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_9.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_9["移除单位指定Buff"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_10.createUnitEffect
destroyUnitEffect = ____require_result_10.destroyUnitEffect
local _____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
local _____8BBE_7F6E_7279_6548_7F29_653E = ____require_result_10["设置特效缩放"]
local ____require_result_11 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_11.Sound3DII_UnitPlayReuse
Sound3DII_CooPlayReuse = ____require_result_11.Sound3DII_CooPlayReuse
local ____require_result_12 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_12["播放英雄技能喊话"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.02．被动效果")
local _____662F_6731_96C0_9662_693F = ____require_result_13["是朱雀院椿"]
local _____521B_5EFA_53CD_51FB_51C6_5907 = ____require_result_13["创建反击准备"]
_____6062_590DVF = ____require_result_13["恢复VF"]
local _____83B7_53D6_59FF_6001 = ____require_result_13["获取姿态"]
local _____767B_8BB0_693F_6E05_7406 = ____require_result_13["登记椿清理"]
local _____64AD_653E_693F_52A8_4F5C = ____require_result_13["播放椿动作"]
local _____8054_52A8R = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.06．R技能")
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"])
____W_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E.W["技能ID"])
____W_914D_7F6E = _____6731_96C0_9662_693FW_914D_7F6E
_____62DB_67B6_7279_6548_952E = "朱雀院椿W招架"
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local function _____7ED3_7B97W_53CD_51FB(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, _____5B8C_7F8E)
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["W成功反击"])
    local _____6765_6E90 = _____6570_636E["招架来源"]
    if _____6765_6E90 == nil or _____6765_6E90 == 0 or not _____5355_4F4D_5B58_6D3B(_____6765_6E90) then
        _____7ED3_675FW_62DB_67B6(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
        return
    end
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____6765_6E90,
        ["伤害"] = _____653B_51FB_529B * ____W_914D_7F6E["反击伤害倍率"],
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FDID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = "朱雀院椿-W反击",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true
    })
    if _____5B8C_7F8E and _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005) == "二刀" then
        _____9020_6210_6280_80FD_4F24_5BB3({
            ["来源"] = _____65BD_6CD5_8005,
            ["目标"] = _____6765_6E90,
            ["伤害"] = _____653B_51FB_529B * ____W_914D_7F6E["二刀两侧刀光倍率"],
            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
            ["攻击类型"] = ATTACK_TYPE_NORMAL,
            ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["技能ID"] = ____W_6280_80FDID,
            ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
            ["标签"] = "朱雀院椿-W两侧刀光",
            ["伤害形态"] = "单体",
            ["参与技能伤害加成"] = true
        })
    end
    if _____5B8C_7F8E then
        Sound3DII_UnitPlayReuse(_____6731_96C0_9662_693F_97F3_6548_914D_7F6E["W完美招架"]["路径"], _____65BD_6CD5_8005, _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["W完美招架"]["裁断距离"])
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W完美招架"]["模型路径"],
            RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W完美招架"].RGB,
            X = GetUnitX(_____6765_6E90),
            Y = GetUnitY(_____6765_6E90),
            Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W完美招架"]["高度"],
            ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W完美招架"]["缩放"],
            ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W完美招架"]["持续秒"]
        })
    else
        Sound3DII_UnitPlayReuse(_____6731_96C0_9662_693F_97F3_6548_914D_7F6E["W普通招架"]["路径"], _____65BD_6CD5_8005, _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["W普通招架"]["裁断距离"])
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W普通招架"]["模型路径"],
            RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W普通招架"].RGB,
            X = GetUnitX(_____6765_6E90),
            Y = GetUnitY(_____6765_6E90),
            Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W普通招架"]["高度"],
            ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W普通招架"]["缩放"],
            ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W普通招架"]["持续秒"]
        })
    end
    _____7ED3_675FW_62DB_67B6(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
end
local function _____91CA_653EW_62DB_67B6(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_6731_96C0_9662_693F(_____65BD_6CD5_8005) then
        return
    end
    if _____8054_52A8R["椿R蓄力中"] ~= nil and _____8054_52A8R["椿R蓄力中"](_____65BD_6CD5_8005) then
        return
    end
    if #_____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "椿W") > 0 then
        return
    end
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "朱雀院椿", _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.W["技能ID"])
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["W开窗"])
    local _____6570_636E = {
        ["窗口开始"] = getGameTime(),
        ["方向角"] = GetUnitFacing(_____65BD_6CD5_8005),
        ["修饰ID"] = 0,
        ["已招架"] = false,
        ["已结束"] = false,
        ["招架来源"] = nil
    }
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "椿W",
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
            destroyUnitEffect(_____65BD_6CD5_8005, _____62DB_67B6_7279_6548_952E)
        end
    })
    local _____62DB_67B6_7A97_53E3_7279_6548 = createUnitEffect(
        _____65BD_6CD5_8005,
        "origin",
        _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W招架窗口"]["模型路径"],
        _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W招架窗口"]["持续秒"],
        _____62DB_67B6_7279_6548_952E
    )
    _____8BBE_7F6E_7279_6548_7F29_653E(_____62DB_67B6_7A97_53E3_7279_6548, _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["W招架窗口"]["缩放"])
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
            if not _____5355_4F4D_662F_5426_5728_6765_6E90_6B63_9762_6247_533A(_____65BD_6CD5_8005, context.attacker, ____W_914D_7F6E["正面角度"]) then
                return context.currentDamage
            end
            _____6570_636E["已招架"] = true
            _____6570_636E["招架来源"] = context.attacker
            local _____8FDB_5165_79D2 = getGameTime() - _____6570_636E["窗口开始"]
            local _____6765_6E90_65B9_5411 = _____4E24_70B9_89D2_5EA6(
                GetUnitX(_____65BD_6CD5_8005),
                GetUnitY(_____65BD_6CD5_8005),
                GetUnitX(context.attacker),
                GetUnitY(context.attacker)
            )
            local _____5B8C_7F8E = _____8FDB_5165_79D2 <= ____W_914D_7F6E["完美时点秒"] and _____89D2_5EA6_5DEE_7EDD_5BF9_503C(_____6570_636E["方向角"], _____6765_6E90_65B9_5411) <= ____W_914D_7F6E["完美角度"]
            _____521B_5EFA_53CD_51FB_51C6_5907(_____65BD_6CD5_8005, _____6765_6E90_65B9_5411, context.attacker)
            _____6062_590DVF(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_88AB_52A8_914D_7F6E["招架恢复VF"] + (_____5B8C_7F8E and _____6731_96C0_9662_693F_88AB_52A8_914D_7F6E["完美招架额外VF"] or 0))
            addDelayedCallback(
                0,
                function()
                    _____7ED3_7B97W_53CD_51FB(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, _____5B8C_7F8E)
                end
            )
            return 0
        end,
        60
    )
    local _____5230_671FID = addDelayedCallback(
        ____W_914D_7F6E["招架窗口秒"] * 1000,
        function()
            _____7ED3_675FW_62DB_67B6(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
            if _____63A7_5236_5668 ~= nil then
                _____63A7_5236_5668["完成"](_____63A7_5236_5668)
            end
        end
    )
    _____63A7_5236_5668["登记延迟回调"](_____63A7_5236_5668, _____5230_671FID)
    _____767B_8BB0_693F_6E05_7406(
        _____65BD_6CD5_8005,
        "椿W招架",
        function()
            _____7ED3_675FW_62DB_67B6(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
        end
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院椿W"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院椿-VF场·后之先（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "ATW1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EW_62DB_67B6,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 1.5
    })
end
____exports["朱雀院椿W模块"] = {["技能ID"] = _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.W["技能ID"], ["注册"] = ____exports["注册朱雀院椿W"]}
return ____exports
