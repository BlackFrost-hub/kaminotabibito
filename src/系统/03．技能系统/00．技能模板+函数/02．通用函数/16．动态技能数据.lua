local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitState = japi.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local _____6280_80FD_52A8_4F5C = require("平台扩展API动作")
local _____6280_80FD_53D6_503C = require("平台扩展API取值")
local _____52A8_6001_767E_5206_6BD4_84DD_8017_8868 = {}
local _____5355_4F4D_6280_80FD_6570_636E_914D_7F6E_8868 = {}
local _____52A8_6001_6280_80FD_8BF4_660E_8868 = {}
____exports["获取动态技能说明"] = function(_____767B_8BB0_952E, abilityId)
    local ____opt_2 = _____52A8_6001_6280_80FD_8BF4_660E_8868[_____767B_8BB0_952E]
    local _____6307_5B9A_8BF4_660E = ____opt_2 and ____opt_2[abilityId]
    if _____6307_5B9A_8BF4_660E ~= nil then
        return _____6307_5B9A_8BF4_660E
    end
    for key in pairs(_____52A8_6001_6280_80FD_8BF4_660E_8868) do
        local ____opt_4 = _____52A8_6001_6280_80FD_8BF4_660E_8868[__TS__Number(key)]
        local _____8BF4_660E = ____opt_4 and ____opt_4[abilityId]
        if _____8BF4_660E ~= nil then
            return _____8BF4_660E
        end
    end
    return nil
end
____exports["获取动态技能魔耗百分比"] = function(abilityId)
    return _____52A8_6001_767E_5206_6BD4_84DD_8017_8868[abilityId] or -1
end
local function _____5E94_7528_5355_4F4D_6280_80FD_6570_636E(_____5355_4F4D, _____914D_7F6E_5217_8868, _____662F_5426_521D_59CB_5316, _____8DF3_8FC7_5237_65B0_547D_4EE4_5361)
    if _____8DF3_8FC7_5237_65B0_547D_4EE4_5361 == nil then
        _____8DF3_8FC7_5237_65B0_547D_4EE4_5361 = false
    end
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            do
                local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
                local _____6280_80FDID = stringToFourCCSafe(_____914D_7F6E["技能ID"])
                if _____6280_80FDID == 0 then
                    goto __continue10
                end
                if _____914D_7F6E["魔耗百分比"] ~= nil then
                    _____52A8_6001_767E_5206_6BD4_84DD_8017_8868[_____6280_80FDID] = _____914D_7F6E["魔耗百分比"]
                end
                if _____914D_7F6E["名称"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能提示"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["名称"])
                end
                if _____914D_7F6E["图标"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能图标"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["图标"])
                end
                if _____914D_7F6E["说明"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能提示扩展"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["说明"])
                end
                if _____914D_7F6E["冷却"] ~= nil and _____6280_80FD_52A8_4F5C["技能_设置技能冷却时间"] ~= nil then
                    local _____5F53_524D_51B7_5374 = not _____662F_5426_521D_59CB_5316 and _____6280_80FD_53D6_503C["技能_获取技能当前冷却时间"] ~= nil and (_____6280_80FD_53D6_503C["技能_获取技能当前冷却时间"](_____5355_4F4D, _____6280_80FDID) or 0) or 0
                    _____6280_80FD_52A8_4F5C["技能_设置技能冷却时间"](_____5355_4F4D, _____6280_80FDID, _____5F53_524D_51B7_5374, _____914D_7F6E["最大冷却"] or _____914D_7F6E["冷却"])
                end
                if _____6280_80FD_52A8_4F5C["技能_设置技能魔法消耗"] ~= nil then
                    local _____6700_5927_9B54_6CD5_503C = GetUnitState(_____5355_4F4D, jass.UNIT_STATE_MAX_MANA) or 0
                    local _____767E_5206_6BD4_84DD_8017 = _____914D_7F6E["魔耗百分比"] ~= nil and _____6700_5927_9B54_6CD5_503C * _____914D_7F6E["魔耗百分比"] or nil
                    local _____5B9E_9645_9B54_8017 = _____914D_7F6E["魔耗"] ~= nil and _____914D_7F6E["魔耗"] or _____767E_5206_6BD4_84DD_8017
                    if _____5B9E_9645_9B54_8017 ~= nil then
                        _____6280_80FD_52A8_4F5C["技能_设置技能魔法消耗"](_____5355_4F4D, _____6280_80FDID, _____5B9E_9645_9B54_8017)
                    end
                end
                if _____914D_7F6E["施法距离"] ~= nil and _____6280_80FD_52A8_4F5C["技能_设置技能施法距离"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能施法距离"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["施法距离"])
                end
                if _____914D_7F6E["快捷键"] ~= nil and _____6280_80FD_52A8_4F5C["技能_设置技能快捷键"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能快捷键"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["快捷键"])
                end
                if not _____8DF3_8FC7_5237_65B0_547D_4EE4_5361 then
                    _____6280_80FD_52A8_4F5C["技能_设置刷新数据"](_____5355_4F4D, _____6280_80FDID)
                end
            end
            ::__continue10::
            i = i + 1
        end
    end
end
--- 只修改当前单位的技能实例，不创建技能、不替换技能、不承担技能逻辑。
-- 所有修改完成后统一刷新命令卡，适用于 Q/W/E/R/D 阶段显示切换。
____exports["动态修改单位技能数据"] = function(_____5355_4F4D, _____767B_8BB0_952E, _____914D_7F6E_5217_8868, _____8DF3_8FC7_5237_65B0_547D_4EE4_5361)
    if _____8DF3_8FC7_5237_65B0_547D_4EE4_5361 == nil then
        _____8DF3_8FC7_5237_65B0_547D_4EE4_5361 = false
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    if _____767B_8BB0_952E == 0 then
        return
    end
    _____5355_4F4D_6280_80FD_6570_636E_914D_7F6E_8868[_____767B_8BB0_952E] = _____914D_7F6E_5217_8868
    local _____8BF4_660E_8868 = _____52A8_6001_6280_80FD_8BF4_660E_8868[_____767B_8BB0_952E] or ({})
    _____52A8_6001_6280_80FD_8BF4_660E_8868[_____767B_8BB0_952E] = _____8BF4_660E_8868
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____6280_80FDID = stringToFourCCSafe(_____914D_7F6E_5217_8868[i + 1]["技能ID"])
            if _____6280_80FDID ~= 0 and _____914D_7F6E_5217_8868[i + 1]["说明"] ~= nil then
                _____8BF4_660E_8868[_____6280_80FDID] = _____914D_7F6E_5217_8868[i + 1]["说明"]
            end
            i = i + 1
        end
    end
    _____5E94_7528_5355_4F4D_6280_80FD_6570_636E(_____5355_4F4D, _____914D_7F6E_5217_8868, true, _____8DF3_8FC7_5237_65B0_547D_4EE4_5361)
end
--- 新技能通过升级加入后，重新写入显示数据。此函数属于本地动态文本刷新链，固定跳过命令卡刷新。
____exports["刷新单位技能命令卡"] = function(_____5355_4F4D, _____767B_8BB0_952E)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____767B_8BB0_952E == 0 then
        return
    end
    local _____914D_7F6E_5217_8868 = _____5355_4F4D_6280_80FD_6570_636E_914D_7F6E_8868[_____767B_8BB0_952E]
    if _____914D_7F6E_5217_8868 == nil then
        return
    end
    _____5E94_7528_5355_4F4D_6280_80FD_6570_636E(_____5355_4F4D, _____914D_7F6E_5217_8868, false, false)
end
____exports["刷新单位技能数据"] = function(_____5355_4F4D, _____767B_8BB0_952E)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____914D_7F6E_5217_8868 = _____5355_4F4D_6280_80FD_6570_636E_914D_7F6E_8868[_____767B_8BB0_952E]
    if _____914D_7F6E_5217_8868 == nil then
        return
    end
    _____5E94_7528_5355_4F4D_6280_80FD_6570_636E(_____5355_4F4D, _____914D_7F6E_5217_8868, false, true)
end
return ____exports
