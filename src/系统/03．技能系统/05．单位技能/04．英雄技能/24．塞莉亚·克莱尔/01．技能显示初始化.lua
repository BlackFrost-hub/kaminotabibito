--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.00．配置")
local _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔技能配置"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local registerPlayerHeroListener = ____require_result_0.registerPlayerHeroListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．动态技能数据")
local _____52A8_6001_4FEE_6539_5355_4F4D_6280_80FD_6570_636E = ____require_result_1["动态修改单位技能数据"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = jass.FourCC(_____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E["单位类型ID"])
local _____5360_4F4D_56FE_6807 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
local _____6280_80FD_663E_793A = {
    {
        ["技能ID"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.Q["技能ID"],
        ["名称"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.Q["名称"],
        ["图标"] = _____5360_4F4D_56FE_6807,
        ["说明"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.Q["说明"],
        ["快捷键"] = "Q"
    },
    {
        ["技能ID"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.W["技能ID"],
        ["名称"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.W["名称"],
        ["图标"] = _____5360_4F4D_56FE_6807,
        ["说明"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.W["说明"],
        ["快捷键"] = "W"
    },
    {
        ["技能ID"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.E["技能ID"],
        ["名称"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.E["名称"],
        ["图标"] = _____5360_4F4D_56FE_6807,
        ["说明"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.E["说明"],
        ["快捷键"] = "E"
    },
    {
        ["技能ID"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.R["技能ID"],
        ["名称"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.R["名称"],
        ["图标"] = _____5360_4F4D_56FE_6807,
        ["说明"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.R["说明"],
        ["快捷键"] = "R"
    },
    {
        ["技能ID"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.D["技能ID"],
        ["名称"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.D["名称"],
        ["图标"] = _____5360_4F4D_56FE_6807,
        ["说明"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.D["说明"],
        ["快捷键"] = "D"
    }
}
local function _____521D_59CB_5316_585E_8389_4E9A_514B_83B1_5C14_6280_80FD_663E_793A(_player, hero)
    if hero == nil or hero == 0 or jass.GetUnitTypeId(hero) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    _____52A8_6001_4FEE_6539_5355_4F4D_6280_80FD_6570_636E(hero, _____6280_80FD_663E_793A)
end
registerPlayerHeroListener(_____521D_59CB_5316_585E_8389_4E9A_514B_83B1_5C14_6280_80FD_663E_793A)
return ____exports
