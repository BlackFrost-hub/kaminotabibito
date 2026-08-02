--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local CreateDestructableLoc = ____require_result_0.CreateDestructableLoc
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local GetDestructableX = jass.GetDestructableX
local GetDestructableY = jass.GetDestructableY
local RemoveDestructable = jass.RemoveDestructable
local SetDestructableInvulnerable = jass.SetDestructableInvulnerable
local Location = jass.Location
local RemoveLocation = jass.RemoveLocation
local GetUnitTypeId = jass.GetUnitTypeId
local _____5C01_9501_5899_7269_7F16ID = stringToFourCCSafe("Dofw")
local _____5C01_9501_5899_521B_5EFA_671D_5411 = 90
local _____5C01_9501_5899_7F29_653E = 1
local _____5C01_9501_5899_53D8_4F53 = 0
local _____4E9A_4F26_67EF_65AF_5355_4F4DID = stringToFourCCSafe("U006")
local _____5B89_5179_4E4C_5C14_606D_5355_4F4DID = stringToFourCCSafe("U007")
local _____5C01_9501_5899_5168_5C40_540D_8868 = {"gg_dest_Dofw_4579", "gg_dest_Dofw_4580", "gg_dest_Dofw_5037", "gg_dest_Dofw_5038"}
local _____5C01_9501_5899_5750_6807_7F13_5B58
local _____5DF2_521B_5EFA_5C01_9501_5899 = {}
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____662F_5C01_9501_5899Boss(bossUnit)
    if not _____53E5_67C4_6709_6548(bossUnit) then
        return false
    end
    local unitTypeId = GetUnitTypeId(bossUnit)
    return unitTypeId == _____4E9A_4F26_67EF_65AF_5355_4F4DID or unitTypeId == _____5B89_5179_4E4C_5C14_606D_5355_4F4DID
end
--- 在封锁墙仍存在时读取坐标并移除原始地图对象。
-- 坐标只缓存一次，后续 Boss 战重建不再依赖地图全局句柄。
____exports["缓存并移除亚伦柯斯安兹封锁墙"] = function()
    if _____5C01_9501_5899_5750_6807_7F13_5B58 ~= nil then
        return #_____5C01_9501_5899_5750_6807_7F13_5B58 == #_____5C01_9501_5899_5168_5C40_540D_8868
    end
    local _____5750_6807_5217_8868 = {}
    do
        local i = 0
        while i < #_____5C01_9501_5899_5168_5C40_540D_8868 do
            do
                local _____5168_5C40_540D = _____5C01_9501_5899_5168_5C40_540D_8868[i + 1]
                local destructable = jglobals[_____5168_5C40_540D]
                if not _____53E5_67C4_6709_6548(destructable) then
                    goto __continue8
                end
                _____5750_6807_5217_8868[#_____5750_6807_5217_8868 + 1] = {
                    X = GetDestructableX(destructable),
                    Y = GetDestructableY(destructable)
                }
                RemoveDestructable(destructable)
                jglobals[_____5168_5C40_540D] = nil
            end
            ::__continue8::
            i = i + 1
        end
    end
    _____5C01_9501_5899_5750_6807_7F13_5B58 = _____5750_6807_5217_8868
    return #_____5750_6807_5217_8868 == #_____5C01_9501_5899_5168_5C40_540D_8868
end
local function _____521B_5EFA_5C01_9501_5899(_____5750_6807)
    local loc = Location(_____5750_6807.X, _____5750_6807.Y)
    if not _____53E5_67C4_6709_6548(loc) then
        return nil
    end
    local destructable = CreateDestructableLoc(
        _____5C01_9501_5899_7269_7F16ID,
        loc,
        _____5C01_9501_5899_521B_5EFA_671D_5411,
        _____5C01_9501_5899_7F29_653E,
        _____5C01_9501_5899_53D8_4F53
    )
    RemoveLocation(loc)
    if _____53E5_67C4_6709_6548(destructable) then
        SetDestructableInvulnerable(destructable, true)
    end
    return destructable
end
--- Boss 战开始时重新建立四道不可破坏封锁墙。
____exports["重建亚伦柯斯安兹封锁墙"] = function(bossUnit)
    if not _____662F_5C01_9501_5899Boss(bossUnit) or #_____5DF2_521B_5EFA_5C01_9501_5899 > 0 then
        return
    end
    if not ____exports["缓存并移除亚伦柯斯安兹封锁墙"]() or _____5C01_9501_5899_5750_6807_7F13_5B58 == nil then
        return
    end
    do
        local i = 0
        while i < #_____5C01_9501_5899_5750_6807_7F13_5B58 do
            local destructable = _____521B_5EFA_5C01_9501_5899(_____5C01_9501_5899_5750_6807_7F13_5B58[i + 1])
            if _____53E5_67C4_6709_6548(destructable) then
                _____5DF2_521B_5EFA_5C01_9501_5899[#_____5DF2_521B_5EFA_5C01_9501_5899 + 1] = destructable
            end
            i = i + 1
        end
    end
end
--- Boss 战结束或提前中止时移除战斗期间重建的封锁墙。
____exports["清理亚伦柯斯安兹封锁墙"] = function(bossUnit)
    if not _____662F_5C01_9501_5899Boss(bossUnit) then
        return
    end
    do
        local i = 0
        while i < #_____5DF2_521B_5EFA_5C01_9501_5899 do
            local destructable = _____5DF2_521B_5EFA_5C01_9501_5899[i + 1]
            if _____53E5_67C4_6709_6548(destructable) then
                RemoveDestructable(destructable)
            end
            i = i + 1
        end
    end
    _____5DF2_521B_5EFA_5C01_9501_5899 = {}
end
return ____exports
