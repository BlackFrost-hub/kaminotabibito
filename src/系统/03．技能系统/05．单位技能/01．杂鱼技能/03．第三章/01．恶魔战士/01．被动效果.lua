--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8F6C_56DB_4F4DID = ____require_result_1["转四位ID"]
local _____5355_4F4D_62E5_6709_539F_751FBuff = ____require_result_1["单位拥有原生Buff"]
local _____8BFB_53D6_5355_4F4D_62A4_7532 = ____require_result_1["读取单位护甲"]
local _____8BA1_7B97_65E0_89C6_62A4_7532_8865_6B63_4F24_5BB3 = ____require_result_1["计算无视护甲补正伤害"]
local _____5BF9_5355_4F4D_9020_6210_5F3A_5316_4F24_5BB3 = ____require_result_1["对单位造成强化伤害"]
local _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_540E_76D1_542C = ____require_result_1["注册指定单位暴击后监听"]
local _____64AD_653E_52A8_4F5C = ____require_result_1["播放动作"]
local _____6062_590D_65F6_95F4_6D41_901F = ____require_result_1["恢复时间流速"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.01．恶魔战士.00．配置")
local _____6076_9B54_6218_58EB_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_2["恶魔战士单位技能配置"]
local _____6076_9B54_6218_58EB_5355_4F4D_7C7B_578BID = _____8F6C_56DB_4F4DID(_____6076_9B54_6218_58EB_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6076_9B54_6218_58EB_89E6_53D1BuffID = _____8F6C_56DB_4F4DID(_____6076_9B54_6218_58EB_5355_4F4D_6280_80FD_914D_7F6E["触发BuffID"])
local _____52A8_4F5C_6062_590D_961F_5217 = {}
local function _____5904_7406_6076_9B54_6218_58EB_52A8_4F5C_6062_590D()
    local record = table.remove(_____52A8_4F5C_6062_590D_961F_5217, 1)
    if record == nil then
        return
    end
    _____6062_590D_65F6_95F4_6D41_901F(record["单位"])
end
local function _____6076_9B54_6218_58EB_66B4_51FB_540E_5904_7406(record, applied, _snapshot)
    if not _____5355_4F4D_62E5_6709_539F_751FBuff(record.attacker, _____6076_9B54_6218_58EB_89E6_53D1BuffID) then
        return
    end
    local armor = _____8BFB_53D6_5355_4F4D_62A4_7532(record.target)
    local bonusDamage = _____8BA1_7B97_65E0_89C6_62A4_7532_8865_6B63_4F24_5BB3(applied, armor)
    if bonusDamage > 0 then
        _____5BF9_5355_4F4D_9020_6210_5F3A_5316_4F24_5BB3(record.attacker, record.target, bonusDamage)
    end
    _____64AD_653E_52A8_4F5C(record.attacker, _____6076_9B54_6218_58EB_5355_4F4D_6280_80FD_914D_7F6E["动作序号"], _____6076_9B54_6218_58EB_5355_4F4D_6280_80FD_914D_7F6E["动作时间流速"])
    _____52A8_4F5C_6062_590D_961F_5217[#_____52A8_4F5C_6062_590D_961F_5217 + 1] = {["单位"] = record.attacker}
    addDelayedCallback(_____6076_9B54_6218_58EB_5355_4F4D_6280_80FD_914D_7F6E["动作恢复毫秒"], _____5904_7406_6076_9B54_6218_58EB_52A8_4F5C_6062_590D)
end
____exports["注册恶魔战士被动效果"] = function()
    _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_540E_76D1_542C(_____6076_9B54_6218_58EB_5355_4F4D_7C7B_578BID, _____6076_9B54_6218_58EB_66B4_51FB_540E_5904_7406)
end
____exports["注册恶魔战士被动效果"]()
return ____exports
