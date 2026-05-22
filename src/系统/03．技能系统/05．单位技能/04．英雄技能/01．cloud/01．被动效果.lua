--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8F6C_56DB_4F4DID = ____require_result_0["转四位ID"]
local _____5355_4F4D_62E5_6709_539F_751FBuff = ____require_result_0["单位拥有原生Buff"]
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_0["获取范围敌军"]
local _____5BF9_5355_4F4D_9020_6210_5F3A_5316_4F24_5BB3 = ____require_result_0["对单位造成强化伤害"]
local _____5728_5750_6807_64AD_653E_7279_6548 = ____require_result_0["在坐标播放特效"]
local _____53D6_5355_4F4DX = ____require_result_0["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_0["取单位Y"]
local _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_540E_76D1_542C = ____require_result_0["注册指定单位暴击后监听"]
local _____64AD_653E_52A8_4F5C = ____require_result_0["播放动作"]
local _____6062_590D_65F6_95F4_6D41_901F = ____require_result_0["恢复时间流速"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．cloud.00．配置")
local ____cloud_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_3["cloud单位技能配置"]
local ____cloud_5355_4F4D_7C7B_578BID = _____8F6C_56DB_4F4DID(____cloud_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local ____cloud_89E6_53D1BuffID = _____8F6C_56DB_4F4DID(____cloud_5355_4F4D_6280_80FD_914D_7F6E["触发BuffID"])
local ____cloud_5F85_6062_590D_6D41_901F_961F_5217 = {}
local function _____5904_7406cloud_786C_76F4_6062_590D()
    local unit = table.remove(____cloud_5F85_6062_590D_6D41_901F_961F_5217, 1)
    if unit == nil then
        return
    end
    _____6062_590D_65F6_95F4_6D41_901F(unit)
end
local function ____cloud_66B4_51FB_540E_5904_7406(record, applied, _snapshot)
    if not _____5355_4F4D_62E5_6709_539F_751FBuff(record.attacker, ____cloud_89E6_53D1BuffID) then
        return
    end
    _____5F00_59CB_786C_76F4(record.attacker, ____cloud_5355_4F4D_6280_80FD_914D_7F6E["硬直毫秒"] * 0.001)
    _____64AD_653E_52A8_4F5C(record.attacker, ____cloud_5355_4F4D_6280_80FD_914D_7F6E["动作序号"], ____cloud_5355_4F4D_6280_80FD_914D_7F6E["动作时间流速"])
    ____cloud_5F85_6062_590D_6D41_901F_961F_5217[#____cloud_5F85_6062_590D_6D41_901F_961F_5217 + 1] = record.attacker
    addDelayedCallback(____cloud_5355_4F4D_6280_80FD_914D_7F6E["硬直毫秒"], _____5904_7406cloud_786C_76F4_6062_590D)
    local x = _____53D6_5355_4F4DX(record.target)
    local y = _____53D6_5355_4F4DY(record.target)
    _____5728_5750_6807_64AD_653E_7279_6548(
        ____cloud_5355_4F4D_6280_80FD_914D_7F6E["特效路径"],
        x,
        y,
        0,
        1,
        1
    )
    local targets = _____83B7_53D6_8303_56F4_654C_519B(record.attacker, x, y, ____cloud_5355_4F4D_6280_80FD_914D_7F6E["溅射半径"])
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if target == record.target then
                    goto __continue7
                end
                _____5BF9_5355_4F4D_9020_6210_5F3A_5316_4F24_5BB3(record.attacker, target, applied)
            end
            ::__continue7::
            i = i + 1
        end
    end
end
____exports["注册cloud被动效果"] = function()
    _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_540E_76D1_542C(____cloud_5355_4F4D_7C7B_578BID, ____cloud_66B4_51FB_540E_5904_7406)
end
____exports["注册cloud被动效果"]()
return ____exports
