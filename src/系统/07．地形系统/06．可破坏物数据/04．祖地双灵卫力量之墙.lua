--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E = require("系统.07．地形系统.06．可破坏物数据.03．祖地双灵卫力量之墙配置")
local _____7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E = ____03_FF0E_7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E["祖地双灵卫力量之墙配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local CreateDestructableLoc = ____require_result_0.CreateDestructableLoc
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local Location = jass.Location
local RemoveLocation = jass.RemoveLocation
local RemoveDestructable = jass.RemoveDestructable
local SetDestructableInvulnerable = jass.SetDestructableInvulnerable
local _____529B_91CF_4E4B_5899_53EF_7834_574F_7269ID = stringToFourCCSafe(_____7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E["可破坏物ID"])
local _____7956_5730_53CC_7075_536BBoss_5355_4F4D_7C7B_578BID_5217_8868 = {}
local _____5DF2_767B_8BB0Boss_53E5_67C4_8868 = {}
local _____5DF2_767B_8BB0Boss_6570_91CF = 0
local _____5F53_524D_529B_91CF_4E4B_5899 = nil
do
    local i = 0
    while i < #_____7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E["Boss单位ID列表"] do
        _____7956_5730_53CC_7075_536BBoss_5355_4F4D_7C7B_578BID_5217_8868[#_____7956_5730_53CC_7075_536BBoss_5355_4F4D_7C7B_578BID_5217_8868 + 1] = stringToFourCCSafe(_____7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E["Boss单位ID列表"][i + 1])
        i = i + 1
    end
end
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____662F_7956_5730_53CC_7075_536BBoss(bossUnit)
    if not _____53E5_67C4_6709_6548(bossUnit) then
        return false
    end
    local unitTypeId = GetUnitTypeId(bossUnit)
    do
        local i = 0
        while i < #_____7956_5730_53CC_7075_536BBoss_5355_4F4D_7C7B_578BID_5217_8868 do
            if _____7956_5730_53CC_7075_536BBoss_5355_4F4D_7C7B_578BID_5217_8868[i + 1] == unitTypeId then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____767B_8BB0_7956_5730_53CC_7075_536BBoss(bossUnit)
    local handleId = GetHandleId(bossUnit) or 0
    if handleId == 0 or _____5DF2_767B_8BB0Boss_53E5_67C4_8868[handleId] then
        return
    end
    _____5DF2_767B_8BB0Boss_53E5_67C4_8868[handleId] = true
    _____5DF2_767B_8BB0Boss_6570_91CF = _____5DF2_767B_8BB0Boss_6570_91CF + 1
end
local function _____6CE8_9500_7956_5730_53CC_7075_536BBoss(bossUnit)
    local handleId = GetHandleId(bossUnit) or 0
    if handleId == 0 or not _____5DF2_767B_8BB0Boss_53E5_67C4_8868[handleId] then
        return
    end
    _____5DF2_767B_8BB0Boss_53E5_67C4_8868[handleId] = nil
    if _____5DF2_767B_8BB0Boss_6570_91CF > 0 then
        _____5DF2_767B_8BB0Boss_6570_91CF = _____5DF2_767B_8BB0Boss_6570_91CF - 1
    end
end
local function _____521B_5EFA_529B_91CF_4E4B_5899()
    local location = Location(_____7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E.X, _____7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E.Y)
    if not _____53E5_67C4_6709_6548(location) then
        return nil
    end
    local destructable = CreateDestructableLoc(
        _____529B_91CF_4E4B_5899_53EF_7834_574F_7269ID,
        location,
        _____7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E["朝向"],
        _____7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E["缩放"],
        _____7956_5730_53CC_7075_536B_529B_91CF_4E4B_5899_914D_7F6E["变体"]
    )
    RemoveLocation(location)
    if _____53E5_67C4_6709_6548(destructable) then
        SetDestructableInvulnerable(destructable, true)
    end
    return destructable
end
--- Boss 战启动时登记当前形态，并保证同一场战斗只存在一面力量之墙。
____exports["重建祖地双灵卫力量之墙"] = function(bossUnit)
    if not _____662F_7956_5730_53CC_7075_536BBoss(bossUnit) then
        return
    end
    _____767B_8BB0_7956_5730_53CC_7075_536BBoss(bossUnit)
    if _____53E5_67C4_6709_6548(_____5F53_524D_529B_91CF_4E4B_5899) then
        return
    end
    _____5F53_524D_529B_91CF_4E4B_5899 = _____521B_5EFA_529B_91CF_4E4B_5899()
end
--- 每个双灵卫运行上下文结束时注销；最后一个上下文结束后再移除墙体。
____exports["清理祖地双灵卫力量之墙"] = function(bossUnit)
    if not _____662F_7956_5730_53CC_7075_536BBoss(bossUnit) then
        return
    end
    _____6CE8_9500_7956_5730_53CC_7075_536BBoss(bossUnit)
    if _____5DF2_767B_8BB0Boss_6570_91CF > 0 or not _____53E5_67C4_6709_6548(_____5F53_524D_529B_91CF_4E4B_5899) then
        return
    end
    RemoveDestructable(_____5F53_524D_529B_91CF_4E4B_5899)
    _____5F53_524D_529B_91CF_4E4B_5899 = nil
end
return ____exports
