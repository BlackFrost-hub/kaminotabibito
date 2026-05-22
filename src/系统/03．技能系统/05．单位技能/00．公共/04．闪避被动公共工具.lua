--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.05．闪避系统.01．闪避核心")
local registerDodgeAppliedFinalDamageListener = ____require_result_0.registerDodgeAppliedFinalDamageListener
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____5355_4F4D_662F_6307_5B9A_7C7B_578B = ____require_result_1["单位是指定类型"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local _____5BF9_5355_4F4D_9020_6210_6697_5F71_4F24_5BB3 = ____require_result_1["对单位造成暗影伤害"]
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_1["获取范围敌军"]
local _____5728_5750_6807_64AD_653E_7279_6548 = ____require_result_1["在坐标播放特效"]
____exports["注册指定单位闪避后监听"] = function(unitTypeId, handler)
    local function _____95EA_907F_540E_76D1_542C_5305_88C5(record, applied, snapshot)
        local ____5355_4F4D_662F_6307_5B9A_7C7B_578B_5 = _____5355_4F4D_662F_6307_5B9A_7C7B_578B
        local ____opt_result_4
        if record ~= nil then
            ____opt_result_4 = record.target
        end
        if not ____5355_4F4D_662F_6307_5B9A_7C7B_578B_5(____opt_result_4, unitTypeId) then
            return
        end
        handler(record, applied, snapshot)
    end
    registerDodgeAppliedFinalDamageListener(_____95EA_907F_540E_76D1_542C_5305_88C5)
end
____exports["以攻击力倍率造成范围暗影伤害"] = function(source, x, y, radius, damageRate)
    if source == nil or source == 0 or not (radius > 0) or not (damageRate > 0) then
        return
    end
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(source) * damageRate
    if not (damage > 0) then
        return
    end
    local targets = _____83B7_53D6_8303_56F4_654C_519B(source, x, y, radius)
    do
        local i = 0
        while i < #targets do
            _____5BF9_5355_4F4D_9020_6210_6697_5F71_4F24_5BB3(source, targets[i + 1], damage)
            i = i + 1
        end
    end
end
____exports["播放灵力意识体爆点特效"] = function(x, y)
    _____5728_5750_6807_64AD_653E_7279_6548(
        "war3mapImported\\superdarkflash.mdl",
        x,
        y,
        35,
        1.1,
        1.1
    )
    _____5728_5750_6807_64AD_653E_7279_6548(
        "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",
        x,
        y,
        35,
        1.1,
        0.1
    )
end
____exports["init闪避被动公共工具"] = function()
end
return ____exports
