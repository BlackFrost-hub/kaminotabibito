local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local jass = require("jass.common")
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_0.EC_CreateEffect
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字")
local _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57 = ____require_result_2["显示单位数值漂浮文字"]
local _____8150_8D25_7279_6548_6A21_578B = "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl"
local _____8150_8D25_503C_4E0A_9650 = 100
local function _____8F6C_6570_5B57(value)
    if value == nil or value == false or value == "" then
        return 0
    end
    local n = type(value) == "number" and value or __TS__Number(value)
    return n ~= n and 0 or n
end
local function _____9650_5236_8150_8D25_503C_4E0A_9650(value)
    if value <= 0 then
        return value
    end
    if value >= _____8150_8D25_503C_4E0A_9650 then
        return _____8150_8D25_503C_4E0A_9650
    end
    return value
end
____exports["应用腐败层数"] = function(_____53C2_6570)
    local ____53C2_6570__76EE_6807_5355_4F4D_3 = _____53C2_6570["目标单位"]
    if ____53C2_6570__76EE_6807_5355_4F4D_3 == nil then
        ____53C2_6570__76EE_6807_5355_4F4D_3 = _____53C2_6570.TargetUnit
    end
    local _____76EE_6807_5355_4F4D = ____53C2_6570__76EE_6807_5355_4F4D_3
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    local _____5C42_6570 = _____8F6C_6570_5B57(_____53C2_6570["层数"] or _____53C2_6570.Stacks)
    if _____5C42_6570 == 0 then
        return
    end
    local _____62E5_6709_8005 = GetOwningPlayer(_____76EE_6807_5355_4F4D)
    if _____53C2_6570["腐败值"] ~= false and _____62E5_6709_8005 ~= nil and _____62E5_6709_8005 ~= 0 then
        local _____5F53_524D_8150_8D25_503C = _____8F6C_6570_5B57(YDUserDataGetSafe("player", _____62E5_6709_8005, "腐败值", "real"))
        YDUserDataSetSafe(
            "player",
            _____62E5_6709_8005,
            "腐败值",
            "real",
            _____9650_5236_8150_8D25_503C_4E0A_9650(_____5F53_524D_8150_8D25_503C + _____5C42_6570)
        )
    end
    EC_CreateEffect(
        _____8150_8D25_7279_6548_6A21_578B,
        GetUnitX(_____76EE_6807_5355_4F4D),
        GetUnitY(_____76EE_6807_5355_4F4D),
        0,
        270,
        1.5,
        1,
        1
    )
    _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(_____76EE_6807_5355_4F4D, _____5C42_6570, {
        ["后缀"] = "腐败",
        ["红"] = 100,
        ["绿"] = 20,
        ["蓝"] = 20,
        ["持续时间"] = 1
    })
end
return ____exports
