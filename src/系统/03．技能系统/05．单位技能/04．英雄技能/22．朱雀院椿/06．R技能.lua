--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.00．配置")
local _____6731_96C0_9662_693F_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿技能配置"]
local _____6731_96C0_9662_693F_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿表现配置"]
local _____6731_96C0_9662_693F_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院椿动作槽"]
local _____6731_96C0_9662_693FR_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿R配置"]
local _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿读条配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_1["注册单位技能壳监听"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_2["开始充能"]
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_3.registerDamageModifier
local unregisterDamageModifier = ____require_result_3.unregisterDamageModifier
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
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.02．被动效果")
local _____662F_6731_96C0_9662_693F = ____require_result_8["是朱雀院椿"]
local _____83B7_53D6_59FF_6001 = ____require_result_8["获取姿态"]
local _____9501_5B9A_59FF_6001 = ____require_result_8["锁定姿态"]
local _____6062_590DVF = ____require_result_8["恢复VF"]
local _____6263_9664VF = ____require_result_8["扣除VF"]
local _____64AD_653E_693F_52A8_4F5C = ____require_result_8["播放椿动作"]
local _____6709_51B3_6597_8DDD_79BB = ____require_result_8["有决斗距离"]
local _____83B7_53D6_51B3_6597_8DDD_79BB_65B9_5411 = ____require_result_8["获取决斗距离方向"]
local _____6E05_9664_51B3_6597_8DDD_79BB = ____require_result_8["清除决斗距离"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"])
local ____R_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E.R["技能ID"])
local ____R_914D_7F6E = _____6731_96C0_9662_693FR_914D_7F6E
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local _____84C4_529B_4E2D_8868 = {}
--- W 检查：R 蓄力期间禁止开启 W
____exports["椿R蓄力中"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    return _____84C4_529B_4E2D_8868[jass.GetHandleId(_____82F1_96C4)] == true
end
local function _____7ED3_7B97R_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____6280_80FD_5B9E_4F8BID, _____4F24_5BB3_503C, _____6807_7B7E)
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3_503C,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____R_6280_80FDID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = _____6807_7B7E,
        ["伤害形态"] = "AOE",
        ["参与技能伤害加成"] = true
    })
end
local function ____R_521B_5EFA_7EC8_5F0F(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____65B9_5411_89D2, _____53D7_51FB_8BB0_5F55)
    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    local _____59FF_6001 = _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005)
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____59FF_6001 == "二刀" and _____6731_96C0_9662_693F_52A8_4F5C_69FD["R二刀释放"] or _____6731_96C0_9662_693F_52A8_4F5C_69FD["R一刀释放"])
    local _____654C_4EBA = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = GetUnitX(_____65BD_6CD5_8005),
        Y = GetUnitY(_____65BD_6CD5_8005),
        ["半径"] = ____R_914D_7F6E["距离"],
        ["方向角"] = _____65B9_5411_89D2,
        ["扇形角度"] = _____59FF_6001 == "二刀" and ____R_914D_7F6E["二刀扇形角度"] or ____R_914D_7F6E["一刀窄线角度"],
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
            _____7ED3_7B97R_4F24_5BB3(
                _____65BD_6CD5_8005,
                _____654C_4EBA[i + 1],
                _____6280_80FD_5B9E_4F8BID,
                _____653B_51FB_529B * ____R_914D_7F6E["主斩倍率"],
                "朱雀院椿-R主斩"
            )
            i = i + 1
        end
    end
    if ____R_914D_7F6E["主斩特效"] ~= "" then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = ____R_914D_7F6E["主斩特效"],
            X = GetUnitX(_____65BD_6CD5_8005),
            Y = GetUnitY(_____65BD_6CD5_8005),
            Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["参数"]["R主斩"]["高度"],
            ["面向角度"] = _____65B9_5411_89D2,
            ["动画索引"] = 0,
            ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["参数"]["R主斩"]["缩放"],
            ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["参数"]["R主斩"]["持续秒"]
        })
    end
    if _____59FF_6001 == "一刀" and _____53D7_51FB_8BB0_5F55 then
        do
            local i = 0
            while i < #_____654C_4EBA do
                _____7ED3_7B97R_4F24_5BB3(
                    _____65BD_6CD5_8005,
                    _____654C_4EBA[i + 1],
                    _____6280_80FD_5B9E_4F8BID,
                    _____653B_51FB_529B * ____R_914D_7F6E["反击斩倍率"],
                    "朱雀院椿-R后之先反击"
                )
                i = i + 1
            end
        end
        _____6062_590DVF(_____65BD_6CD5_8005, ____R_914D_7F6E["一刀受击恢复VF"])
    end
    if _____59FF_6001 == "二刀" then
        _____6263_9664VF(_____65BD_6CD5_8005, ____R_914D_7F6E["二刀VF代价"])
        do
            local i = 0
            while i < #_____654C_4EBA do
                _____7ED3_7B97R_4F24_5BB3(
                    _____65BD_6CD5_8005,
                    _____654C_4EBA[i + 1],
                    _____6280_80FD_5B9E_4F8BID,
                    _____653B_51FB_529B * ____R_914D_7F6E["二刀交错倍率"],
                    "朱雀院椿-R交错斩"
                )
                i = i + 1
            end
        end
        if ____R_914D_7F6E["交错斩特效"] ~= "" then
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = ____R_914D_7F6E["交错斩特效"],
                X = GetUnitX(_____65BD_6CD5_8005),
                Y = GetUnitY(_____65BD_6CD5_8005),
                Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["参数"]["R交错斩"]["高度"],
                ["面向角度"] = _____65B9_5411_89D2,
                ["动画索引"] = 0,
                ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["参数"]["R交错斩"]["缩放"],
                ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["参数"]["R交错斩"]["持续秒"]
            })
        end
    end
end
local function _____91CA_653ER_708E_59EC(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_6731_96C0_9662_693F(_____65BD_6CD5_8005) then
        return
    end
    if _____84C4_529B_4E2D_8868[jass.GetHandleId(_____65BD_6CD5_8005)] == true then
        return
    end
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["R蓄力"])
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        _____76EE_6807X,
        _____76EE_6807Y
    )
    _____9501_5B9A_59FF_6001(_____65BD_6CD5_8005, true)
    _____84C4_529B_4E2D_8868[jass.GetHandleId(_____65BD_6CD5_8005)] = true
    local _____51B3_6597_8DDD_79BB_5FEB_7167 = {
        ["有效"] = _____6709_51B3_6597_8DDD_79BB(_____65BD_6CD5_8005),
        ["方向"] = _____83B7_53D6_51B3_6597_8DDD_79BB_65B9_5411(_____65BD_6CD5_8005)
    }
    local _____53D7_51FB_8BB0_5F55 = false
    local _____53D7_51FB_4FEE_6539_5668ID = 0
    if _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005) == "一刀" then
        _____53D7_51FB_4FEE_6539_5668ID = registerDamageModifier(
            function(context)
                if context.target ~= _____65BD_6CD5_8005 then
                    return context.currentDamage
                end
                if context.currentDamage <= 0 then
                    return context.currentDamage
                end
                if context.attacker == nil or context.attacker == 0 or context.attacker == _____65BD_6CD5_8005 then
                    return context.currentDamage
                end
                if not jass.IsUnitEnemy(
                    context.attacker,
                    jass.GetOwningPlayer(_____65BD_6CD5_8005)
                ) then
                    return context.currentDamage
                end
                if _____53D7_51FB_8BB0_5F55 then
                    return context.currentDamage
                end
                _____53D7_51FB_8BB0_5F55 = true
                return context.currentDamage
            end,
            50
        )
    end
    local _____9884_8B66_7279_6548 = nil
    _____5F00_59CB_5145_80FD(
        _____65BD_6CD5_8005,
        {
            ["持续时间"] = ____R_914D_7F6E["蓄力秒"],
            ["指令中断"] = true,
            ["世界坐标进度UI"] = true,
            ["世界坐标进度UI类型"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["UI类型"],
            ["世界坐标进度UI标题"] = "炎姬·黄泉凤凰",
            ["世界坐标进度UI数值后缀"] = "",
            ["世界坐标进度UI高度偏移"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["跟随Z偏移"],
            ["显示进度条特效"] = false,
            ["开始回调"] = function(______5355_4F4D, ______5145_80FDID)
                if ____R_914D_7F6E["蓄力提示特效"] ~= nil and ____R_914D_7F6E["蓄力提示特效"] ~= "" then
                    _____9884_8B66_7279_6548 = _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = ____R_914D_7F6E["蓄力提示特效"],
                        X = _____76EE_6807X,
                        Y = _____76EE_6807Y,
                        Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["参数"]["R蓄力提示"]["高度"],
                        ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["参数"]["R蓄力提示"]["缩放"],
                        ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["参数"]["R蓄力提示"]["持续秒"]
                    })
                end
            end,
            ["充能完成回调"] = function(______5355_4F4D, ______5145_80FDID)
                local _____7EC8_5F0F_65B9_5411 = _____51B3_6597_8DDD_79BB_5FEB_7167["有效"] and _____51B3_6597_8DDD_79BB_5FEB_7167["方向"] or _____65B9_5411_89D2
                if _____51B3_6597_8DDD_79BB_5FEB_7167["有效"] then
                    _____6E05_9664_51B3_6597_8DDD_79BB(_____65BD_6CD5_8005)
                end
                ____R_521B_5EFA_7EC8_5F0F(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____7EC8_5F0F_65B9_5411, _____53D7_51FB_8BB0_5F55)
            end,
            ["结束回调"] = function(______5355_4F4D, ______539F_56E0, ______5145_80FDID)
                if _____9884_8B66_7279_6548 ~= nil and _____9884_8B66_7279_6548 ~= 0 then
                    jass.DestroyEffect(_____9884_8B66_7279_6548)
                    _____9884_8B66_7279_6548 = nil
                end
                if _____53D7_51FB_4FEE_6539_5668ID ~= 0 then
                    unregisterDamageModifier(_____53D7_51FB_4FEE_6539_5668ID)
                    _____53D7_51FB_4FEE_6539_5668ID = 0
                end
                _____84C4_529B_4E2D_8868[jass.GetHandleId(_____65BD_6CD5_8005)] = false
                _____9501_5B9A_59FF_6001(_____65BD_6CD5_8005, false)
            end
        }
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院椿R"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院椿-炎姬·黄泉凤凰（R）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "ATR1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653ER_708E_59EC,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = ____R_914D_7F6E["蓄力秒"] + 1
    })
end
____exports["朱雀院椿R模块"] = {["技能ID"] = _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.R["技能ID"], ["蓄力秒"] = ____R_914D_7F6E["蓄力秒"], ["世界坐标读条"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E, ["注册"] = ____exports["注册朱雀院椿R"]}
return ____exports
