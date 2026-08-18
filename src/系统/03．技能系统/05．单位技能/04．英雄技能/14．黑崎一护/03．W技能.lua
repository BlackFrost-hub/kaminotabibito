--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.00．配置")
local _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["黑崎一护技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.01．状态表")
local _____662F_5426_77AC_6B65_8FDE_643A_4E2D = ____01_FF0E_72B6_6001_8868["是否瞬步连携中"]
local ____09_FF0E_9ED1_5D0E_4E00_62A4 = require("系统.05．Buff系统.03．Buff表.02．英雄.09．黑崎一护")
local _____9ED1_5D0E_4E00_62A4BuffID = ____09_FF0E_9ED1_5D0E_4E00_62A4["黑崎一护BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_1["获取范围敌军"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_2["开始击退"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_3["施加眩晕"]
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local ____require_result_5 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundAtPointBJ = ____require_result_5.PlaySoundAtPointBJ
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local ____require_result_7 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_7.YDUserDataGetSafe
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local _____914D_7F6E = _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____W_7C7B_578BID = stringToFourCC(_____914D_7F6E.W["技能ID"])
local ____W_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587(unit)
    local id = GetHandleId(unit)
    local ctx = ____W_4E0A_4E0B_6587_8868[id]
    if ctx == nil then
        ctx = {}
        ____W_4E0A_4E0B_6587_8868[id] = ctx
    end
    return ctx
end
local function _____91CA_653E_7075_538B_7206_53D1(_context, caster, _____6280_80FD_5B9E_4F8BID)
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local _____8FDE_643A = _____662F_5426_77AC_6B65_8FDE_643A_4E2D(caster)
    local _____5206_652F = _____8FDE_643A and _____914D_7F6E.W["连携"] or _____914D_7F6E.W["普通"]
    local _____5019_9009 = _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____914D_7F6E.W["半径码"])
    local _____654C_519B = {}
    if _____5019_9009 ~= nil then
        do
            local i = 0
            while i < #_____5019_9009 do
                do
                    local u = _____5019_9009[i + 1]
                    if u == nil or u == 0 then
                        goto __continue7
                    end
                    if YDUserDataGetSafe("unit", u, "免控", "boolean") == true then
                        goto __continue7
                    end
                    _____654C_519B[#_____654C_519B + 1] = u
                end
                ::__continue7::
                i = i + 1
            end
        end
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.W["主特效"]["模型"],
        X = x,
        Y = y,
        Z = 0,
        ["缩放"] = _____914D_7F6E.W["主特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.W["主特效"]["持续秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.W["爆发特效"]["模型"],
        X = x,
        Y = y,
        Z = 0,
        ["缩放"] = _____914D_7F6E.W["爆发特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.W["爆发特效"]["持续秒"]
    })
    if _____8FDE_643A then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E.W["连携"]["附加特效"]["模型"],
            X = x,
            Y = y,
            Z = 0,
            ["缩放"] = _____914D_7F6E.W["连携"]["附加特效"]["缩放"],
            ["持续秒"] = _____914D_7F6E.W["连携"]["附加特效"]["持续秒"]
        })
    end
    PlaySoundAtPointBJ(
        jglobals.gg_snd_ThunderClapCaster,
        100,
        x,
        y,
        0
    )
    local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E.W["伤害攻击力倍率"]
    do
        local i = 0
        while i < #_____654C_519B do
            local target = _____654C_519B[i + 1]
            _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                ["来源"] = caster,
                ["目标"] = target,
                ["伤害"] = _____4F24_5BB3,
                ["伤害类型"] = DAMAGE_TYPE_LIGHTNING,
                attack = false,
                attackType = ATTACK_TYPE_NORMAL,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "单位技能",
                ["标签"] = "黑崎一护-W灵压爆发",
                ["技能ID"] = ____W_7C7B_578BID,
                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
            })
            _____65BD_52A0_7729_6655(
                caster,
                target,
                _____5206_652F["眩晕秒"],
                "黑崎一护-灵压爆发",
                "技能"
            )
            registerManualBuff(target, _____9ED1_5D0E_4E00_62A4BuffID["灵压爆发眩晕"], _____5206_652F["眩晕秒"], 0)
            _____5F00_59CB_51FB_9000(target, {["来源单位"] = caster, ["距离"] = _____5206_652F["击退总距离"], ["持续时间"] = _____8FDE_643A and _____914D_7F6E.W["连携"]["击退持续时间秒"] or 0.4, ["检查地形"] = true})
            i = i + 1
        end
    end
end
____exports["注册黑崎一护W"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "黑崎一护-灵压爆发（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.W["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_7075_538B_7206_53D1,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 2
    })
end
____exports["注册黑崎一护W"]()
return ____exports
