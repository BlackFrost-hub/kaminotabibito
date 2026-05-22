--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local japi = require("jass.japi")
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8F6C_56DB_4F4DID = ____require_result_1["转四位ID"]
local _____53D6_5355_4F4DX = ____require_result_1["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_1["取单位Y"]
local _____5728_5750_6807_64AD_653E_7279_6548 = ____require_result_1["在坐标播放特效"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_2.EC_CreateEffect
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.04．闪避被动公共工具")
local _____6CE8_518C_6307_5B9A_5355_4F4D_95EA_907F_540E_76D1_542C = ____require_result_3["注册指定单位闪避后监听"]
local _____4EE5_653B_51FB_529B_500D_7387_9020_6210_8303_56F4_6697_5F71_4F24_5BB3 = ____require_result_3["以攻击力倍率造成范围暗影伤害"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．灵力意识体.00．配置")
local _____7075_529B_610F_8BC6_4F53_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_4["灵力意识体单位技能配置"]
local _____7075_529B_610F_8BC6_4F53_5355_4F4D_7C7B_578BID = _____8F6C_56DB_4F4DID(_____7075_529B_610F_8BC6_4F53_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____7075_529B_610F_8BC6_4F53_7206_70B9_961F_5217 = {}
local EXSetEffectSize = japi.EXSetEffectSize
local function _____64AD_653E_7075_529B_610F_8BC6_4F53_7206_70B9_7279_6548(x, y)
    _____5728_5750_6807_64AD_653E_7279_6548(
        _____7075_529B_610F_8BC6_4F53_5355_4F4D_6280_80FD_914D_7F6E["爆点特效1"],
        x,
        y,
        35,
        1.1,
        1.1
    )
    _____5728_5750_6807_64AD_653E_7279_6548(
        _____7075_529B_610F_8BC6_4F53_5355_4F4D_6280_80FD_914D_7F6E["爆点特效2"],
        x,
        y,
        35,
        1.1,
        0.1
    )
end
local function _____5904_7406_7075_529B_610F_8BC6_4F53_5EF6_8FDF_7206_70B9()
    local record = table.remove(_____7075_529B_610F_8BC6_4F53_7206_70B9_961F_5217, 1)
    if record == nil then
        return
    end
    if record["预警特效"] ~= nil and record["预警特效"] ~= 0 then
        EXSetEffectSize(record["预警特效"], 0)
    end
    _____64AD_653E_7075_529B_610F_8BC6_4F53_7206_70B9_7279_6548(record.X, record.Y)
    _____4EE5_653B_51FB_529B_500D_7387_9020_6210_8303_56F4_6697_5F71_4F24_5BB3(
        record["来源单位"],
        record.X,
        record.Y,
        _____7075_529B_610F_8BC6_4F53_5355_4F4D_6280_80FD_914D_7F6E["伤害半径"],
        _____7075_529B_610F_8BC6_4F53_5355_4F4D_6280_80FD_914D_7F6E["伤害倍率"]
    )
end
local function _____7075_529B_610F_8BC6_4F53_95EA_907F_540E_5904_7406(record, _applied, _snapshot)
    local x = _____53D6_5355_4F4DX(record.attacker)
    local y = _____53D6_5355_4F4DY(record.attacker)
    local _____9884_8B66_7279_6548 = EC_CreateEffect(
        _____7075_529B_610F_8BC6_4F53_5355_4F4D_6280_80FD_914D_7F6E["预警特效"],
        x,
        y,
        50,
        270,
        0.8,
        1,
        0.7
    )
    _____7075_529B_610F_8BC6_4F53_7206_70B9_961F_5217[#_____7075_529B_610F_8BC6_4F53_7206_70B9_961F_5217 + 1] = {["来源单位"] = record.target, X = x, Y = y, ["预警特效"] = _____9884_8B66_7279_6548}
    addDelayedCallback(_____7075_529B_610F_8BC6_4F53_5355_4F4D_6280_80FD_914D_7F6E["延迟毫秒"], _____5904_7406_7075_529B_610F_8BC6_4F53_5EF6_8FDF_7206_70B9)
end
____exports["注册灵力意识体被动效果"] = function()
    _____6CE8_518C_6307_5B9A_5355_4F4D_95EA_907F_540E_76D1_542C(_____7075_529B_610F_8BC6_4F53_5355_4F4D_7C7B_578BID, _____7075_529B_610F_8BC6_4F53_95EA_907F_540E_5904_7406)
end
____exports["注册灵力意识体被动效果"]()
return ____exports
