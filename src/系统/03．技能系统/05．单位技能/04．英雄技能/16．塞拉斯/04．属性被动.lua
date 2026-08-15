local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.00．配置")
local _____585E_62C9_65AF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞拉斯技能配置"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local registerPlayerHeroListener = ____require_result_0.registerPlayerHeroListener
local getRegisteredPlayerHero = ____require_result_0.getRegisteredPlayerHero
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetHeroInt = jass.GetHeroInt
local SetHeroInt = jass.SetHeroInt
local Player = jass.Player
local _____914D_7F6E = _____585E_62C9_65AF_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____R_7C7B_578BID = _____914D_7F6E.R["技能类型ID"]
local _____667A_529B_68C0_67E5_95F4_9694_6BEB_79D2 = 1000
local _____5DF2_65BD_52A0_667A_529B_52A0_6210 = {}
local function _____53D6_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return jass.GetHandleId(unit) or 0
end
local function _____8BA1_7B97R_667A_529B_52A0_6210(_____6280_80FD_7B49_7EA7)
    if _____6280_80FD_7B49_7EA7 <= 0 then
        return 0
    end
    local _____4F4E_6BB5 = _____914D_7F6E.R["智力"]
    local _____4F4E_6BB5_7B49_7EA7 = _____6280_80FD_7B49_7EA7 < _____4F4E_6BB5["低段上限等级"] and _____6280_80FD_7B49_7EA7 or _____4F4E_6BB5["低段上限等级"]
    local _____9AD8_6BB5_7B49_7EA7 = _____6280_80FD_7B49_7EA7 > _____4F4E_6BB5["低段上限等级"] and _____6280_80FD_7B49_7EA7 - _____4F4E_6BB5["低段上限等级"] or 0
    return _____4F4E_6BB5_7B49_7EA7 * _____4F4E_6BB5["低段每级加值"] + _____9AD8_6BB5_7B49_7EA7 * _____4F4E_6BB5["高段每级加值"]
end
local function _____540C_6B65R_667A_529B_52A0_6210(hero)
    if hero == nil or hero == 0 then
        return
    end
    if GetUnitTypeId(hero) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local hid = _____53D6_53E5_67C4ID(hero)
    if hid == 0 then
        return
    end
    local _____6280_80FD_7B49_7EA7 = GetUnitAbilityLevel(hero, ____R_7C7B_578BID)
    local _____76EE_6807_52A0_6210 = _____8BA1_7B97R_667A_529B_52A0_6210(_____6280_80FD_7B49_7EA7)
    local _____5F53_524D_52A0_6210 = _____5DF2_65BD_52A0_667A_529B_52A0_6210[hid] or 0
    if _____76EE_6807_52A0_6210 == _____5F53_524D_52A0_6210 then
        return
    end
    SetHeroInt(
        hero,
        GetHeroInt(hero, true) - _____5F53_524D_52A0_6210 + _____76EE_6807_52A0_6210,
        false
    )
    _____5DF2_65BD_52A0_667A_529B_52A0_6210[hid] = _____76EE_6807_52A0_6210
end
local function ____R_667A_529B_5468_671F_68C0_67E5()
    do
        local i = 0
        while i < 16 do
            do
                local player = Player(i)
                if player == nil or player == 0 then
                    goto __continue13
                end
                local hero = getRegisteredPlayerHero(player)
                if hero == nil or hero == 0 then
                    goto __continue13
                end
                _____540C_6B65R_667A_529B_52A0_6210(hero)
            end
            ::__continue13::
            i = i + 1
        end
    end
end
local function ____R_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local hid = _____53D6_53E5_67C4ID(dyingUnit)
    if hid ~= 0 then
        __TS__Delete(_____5DF2_65BD_52A0_667A_529B_52A0_6210, hid)
    end
end
local function _____82F1_96C4_66FF_6362_65F6_91CD_7B97(_player, hero)
    _____540C_6B65R_667A_529B_52A0_6210(hero)
end
____exports["注册塞拉斯属性被动"] = function()
    registerPlayerHeroListener(_____82F1_96C4_66FF_6362_65F6_91CD_7B97)
    registerDeathListener(____R_5355_4F4D_6B7B_4EA1)
    addPeriodicCallback(_____667A_529B_68C0_67E5_95F4_9694_6BEB_79D2, ____R_667A_529B_5468_671F_68C0_67E5)
end
____exports["注册塞拉斯属性被动"]()
____exports["塞拉斯属性被动状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["E增伤"] = "由 01．状态表 塞拉斯魔法技能增幅倍率 统一入口生效，(10+3×A0JX等级)%",
    ["R智力"] = "等级1-10每级+8，11-15每级+15，周期差量结算",
    ["R魔法穿透"] = "待查：项目暂无魔法穿透接口，不生效",
    ["R旅行经验"] = "待查：项目暂无旅行经验公共系统，按迁移计划暂停该分支"
}
return ____exports
