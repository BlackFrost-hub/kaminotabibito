local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.01．装备属性应用")
local applyEquipStatsTS = ____require_result_1.applyEquipStatsTS
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.09．物品升级.02．物品升级配置表")
local _____5355_4F4D_5347_7EA7_5C5E_6027_52A0_6210_914D_7F6E_8868 = ____require_result_2["单位升级属性加成配置表"]
local function _____8BFB_53D6_5347_7EA7_52A0_6210_6570_503C(_____5355_4F4D, _____914D_7F6E)
    local _____503C = __TS__Number(YDUserDataGetSafe("unit", _____5355_4F4D, _____914D_7F6E["属性名"], _____914D_7F6E["数值类型"])) or 0
    return _____503C
end
____exports["处理单位升级属性加成"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____5F85_5E94_7528_5C5E_6027 = {}
    do
        local i = 0
        while i < #_____5355_4F4D_5347_7EA7_5C5E_6027_52A0_6210_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____5355_4F4D_5347_7EA7_5C5E_6027_52A0_6210_914D_7F6E_8868[i + 1]
                local _____6570_503C = _____8BFB_53D6_5347_7EA7_52A0_6210_6570_503C(_____5355_4F4D, _____914D_7F6E)
                if _____6570_503C == 0 then
                    goto __continue6
                end
                _____5F85_5E94_7528_5C5E_6027[#_____5F85_5E94_7528_5C5E_6027 + 1] = {name = _____914D_7F6E["应用属性名"], value = _____6570_503C}
            end
            ::__continue6::
            i = i + 1
        end
    end
    if #_____5F85_5E94_7528_5C5E_6027 == 0 then
        return
    end
    applyEquipStatsTS(_____5355_4F4D, _____5F85_5E94_7528_5C5E_6027)
end
return ____exports
