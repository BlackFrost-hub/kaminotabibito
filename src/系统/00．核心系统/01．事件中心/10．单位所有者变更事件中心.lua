local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____6D3E_53D1_6240_6709_8005_53D8_66F4_4E8B_4EF6, ____on_6240_6709_8005_53D8_66F4, jass, playerUnitEvent, _____6240_6709_8005_53D8_66F4_76D1_542C_5217_8868, _____5DF2_521D_59CB_5316
function _____6D3E_53D1_6240_6709_8005_53D8_66F4_4E8B_4EF6(_____5217_8868, _____53D8_66F4_5355_4F4D)
    do
        local i = 0
        while i < #_____5217_8868 do
            local _____56DE_8C03 = _____5217_8868[i + 1]
            if _____56DE_8C03 ~= nil then
                _____56DE_8C03(_____53D8_66F4_5355_4F4D)
            end
            i = i + 1
        end
    end
end
function ____on_6240_6709_8005_53D8_66F4()
    local _____53D8_66F4_5355_4F4D = jass:GetTriggerUnit()
    if _____53D8_66F4_5355_4F4D == nil then
        return
    end
    _____6D3E_53D1_6240_6709_8005_53D8_66F4_4E8B_4EF6(_____6240_6709_8005_53D8_66F4_76D1_542C_5217_8868, _____53D8_66F4_5355_4F4D)
end
____exports["初始化所有者变更事件"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    local _____89E6_53D1_5668 = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(_____89E6_53D1_5668, ____exports["所有者变更玩家ID列表"], jass.EVENT_PLAYER_UNIT_CHANGE_OWNER)
    jass:TriggerAddAction(_____89E6_53D1_5668, ____on_6240_6709_8005_53D8_66F4)
end
jass = require("jass.common")
playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
____exports["所有者变更玩家ID列表"] = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
}
_____6240_6709_8005_53D8_66F4_76D1_542C_5217_8868 = {}
_____5DF2_521D_59CB_5316 = false
local function _____662F_5426_5DF2_6CE8_518C_76D1_542C(_____5217_8868, _____56DE_8C03)
    do
        local i = 0
        while i < #_____5217_8868 do
            if _____5217_8868[i + 1] == _____56DE_8C03 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["注册所有者变更监听"] = function(_____56DE_8C03)
    if type(_____56DE_8C03) ~= "function" then
        return
    end
    ____exports["初始化所有者变更事件"]()
    if not _____662F_5426_5DF2_6CE8_518C_76D1_542C(_____6240_6709_8005_53D8_66F4_76D1_542C_5217_8868, _____56DE_8C03) then
        _____6240_6709_8005_53D8_66F4_76D1_542C_5217_8868[#_____6240_6709_8005_53D8_66F4_76D1_542C_5217_8868 + 1] = _____56DE_8C03
    end
end
____exports["取消所有者变更监听"] = function(_____56DE_8C03)
    local index = __TS__ArrayIndexOf(_____6240_6709_8005_53D8_66F4_76D1_542C_5217_8868, _____56DE_8C03)
    if index >= 0 then
        __TS__ArraySplice(_____6240_6709_8005_53D8_66F4_76D1_542C_5217_8868, index, 1)
    end
end
return ____exports
