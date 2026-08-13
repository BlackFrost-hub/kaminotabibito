local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8DDD_79BB_5E73_65B9XY = ____require_result_3["距离平方XY"]
local ____require_result_4 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置")
local _____73AF_5883_4E92_52A8_6280_80FDID = ____require_result_4["环境互动技能ID"]
local _____73AF_5883_4E92_52A8_9ED8_8BA4_89E6_53D1_8303_56F4 = ____require_result_4["环境互动默认触发范围"]
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 = {}
local _____5DF2_521D_59CB_5316_73AF_5883_4E92_52A8 = false
local function _____79FB_9664_8C03_67E5_70B9(_____8C03_67E5_70B9ID)
    do
        local i = 0
        while i < #_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 do
            do
                if _____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868[i + 1].ID ~= _____8C03_67E5_70B9ID then
                    goto __continue4
                end
                __TS__ArraySplice(_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868, i, 1)
                return true
            end
            ::__continue4::
            i = i + 1
        end
    end
    return false
end
local function _____5904_7406_73AF_5883_4E92_52A8_6280_80FD(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____65BD_6CD5_5355_4F4D) then
        return
    end
    if _____6280_80FDID ~= stringToFourCCSafe(_____73AF_5883_4E92_52A8_6280_80FDID) then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____73A9_5BB6ID = GetPlayerId(_____73A9_5BB6)
    local _____65BD_6CD5X = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____65BD_6CD5Y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    do
        local i = 0
        while i < #_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 do
            do
                local _____8C03_67E5_70B9 = _____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868[i + 1]
                local _____89E6_53D1_8303_56F4 = _____8C03_67E5_70B9["触发范围"] ~= nil and _____8C03_67E5_70B9["触发范围"] > 0 and _____8C03_67E5_70B9["触发范围"] or _____73AF_5883_4E92_52A8_9ED8_8BA4_89E6_53D1_8303_56F4
                if _____8DDD_79BB_5E73_65B9XY(_____65BD_6CD5X, _____65BD_6CD5Y, _____8C03_67E5_70B9.X, _____8C03_67E5_70B9.Y) > _____89E6_53D1_8303_56F4 * _____89E6_53D1_8303_56F4 then
                    goto __continue11
                end
                if _____8C03_67E5_70B9["触发回调"](_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9) then
                    _____79FB_9664_8C03_67E5_70B9(_____8C03_67E5_70B9.ID)
                end
                return
            end
            ::__continue11::
            i = i + 1
        end
    end
end
--- 注册一个可被环境互动技能触发的调查点；同 ID 会先替换旧配置。
____exports["注册环境互动调查点"] = function(_____8C03_67E5_70B9)
    if _____8C03_67E5_70B9 == nil or _____8C03_67E5_70B9.ID == "" or _____8C03_67E5_70B9["触发回调"] == nil then
        return false
    end
    _____79FB_9664_8C03_67E5_70B9(_____8C03_67E5_70B9.ID)
    _____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868[#_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 + 1] = _____8C03_67E5_70B9
    return true
end
--- 注销指定调查点，返回是否找到并移除。
____exports["注销环境互动调查点"] = function(_____8C03_67E5_70B9ID)
    if _____8C03_67E5_70B9ID == "" then
        return false
    end
    return _____79FB_9664_8C03_67E5_70B9(_____8C03_67E5_70B9ID)
end
--- 注销全部调查点；任务结束、场景切换或失败清理时使用。
____exports["清理全部环境互动调查点"] = function()
    do
        local i = #_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 - 1
        while i >= 0 do
            table.remove(_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868)
            i = i - 1
        end
    end
end
____exports["init环境互动"] = function()
    if _____5DF2_521D_59CB_5316_73AF_5883_4E92_52A8 then
        return
    end
    _____5DF2_521D_59CB_5316_73AF_5883_4E92_52A8 = true
    registerSpellEffectListener(_____5904_7406_73AF_5883_4E92_52A8_6280_80FD)
end
return ____exports
