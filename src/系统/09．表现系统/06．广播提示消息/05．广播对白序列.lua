--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示淡出毫秒"]
local _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示滑入毫秒"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local function _____64AD_653E_4E0B_4E00_53E5_5E7F_64AD_5BF9_767D(_____53C2_6570)
    local _____72B6_6001 = _____53C2_6570
    if _____72B6_6001 == nil then
        return
    end
    local _____914D_7F6E = _____72B6_6001["配置"]
    if _____914D_7F6E["播放前校验"] ~= nil and not _____914D_7F6E["播放前校验"]() then
        if _____914D_7F6E["播放中止"] ~= nil then
            _____914D_7F6E["播放中止"]()
        end
        return
    end
    if _____72B6_6001["当前索引"] >= #_____914D_7F6E["对白列表"] then
        if _____914D_7F6E["播放完成"] ~= nil then
            _____914D_7F6E["播放完成"]()
        end
        return
    end
    local _____5E8F_53F7 = _____72B6_6001["当前索引"] + 1
    local _____5BF9_767D = _____914D_7F6E["对白列表"][_____72B6_6001["当前索引"] + 1]
    if _____914D_7F6E["单句播放前校验"] ~= nil and not _____914D_7F6E["单句播放前校验"](_____5E8F_53F7, _____5BF9_767D["说话者键"]) then
        if _____914D_7F6E["播放中止"] ~= nil then
            _____914D_7F6E["播放中止"]()
        end
        return
    end
    if _____914D_7F6E["单句播放前"] ~= nil then
        _____914D_7F6E["单句播放前"](_____5E8F_53F7)
    end
    local _____6765_6E90_5355_4F4D = _____914D_7F6E["读取说话单位"](_____5BF9_767D["说话者键"])
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        if _____914D_7F6E["播放中止"] ~= nil then
            _____914D_7F6E["播放中止"]()
        end
        return
    end
    _____914D_7F6E["播放单句"](_____6765_6E90_5355_4F4D, _____5BF9_767D["文本"], _____5BF9_767D["停留毫秒"])
    _____72B6_6001["当前索引"] = _____72B6_6001["当前索引"] + 1
    addDelayedCallback(_____5BF9_767D["下一句延迟毫秒"] or _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 + _____5BF9_767D["停留毫秒"] + _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2, _____64AD_653E_4E0B_4E00_53E5_5E7F_64AD_5BF9_767D, _____72B6_6001)
end
--- 按广播 UI 的滑入、停留、淡出总时长依次播放，不改变剧情或电影模式状态。
____exports["播放广播对白序列"] = function(_____914D_7F6E)
    if _____914D_7F6E == nil or #_____914D_7F6E["对白列表"] <= 0 then
        if (_____914D_7F6E and _____914D_7F6E["播放完成"]) ~= nil then
            _____914D_7F6E["播放完成"]()
        end
        return
    end
    _____64AD_653E_4E0B_4E00_53E5_5E7F_64AD_5BF9_767D({["配置"] = _____914D_7F6E, ["当前索引"] = 0})
end
return ____exports
