local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
--- 本地存档核心
-- 
-- 这里只管理“玩家本机配置”的读写，不直接接入具体业务系统。
-- 业务层后续只需要读写字段枚举，例如动态技能文本、仇恨文字、热键 VK 码。
local jass = require("jass.common")
local PreloadSL = require("系统.10．存档系统.01．本地存档.00．PreloadSL本地存档")
local _____5E38_91CF = require("系统.10．存档系统.01．本地存档.01．常量定义")
local GetPlayerId = jass.GetPlayerId
local _____73A9_5BB6_6570_91CF_4E0A_9650 = 12
local _____672C_5730_5B58_6863_5DF2_52A0_8F7D_8868 = {}
local _____672C_5730_5B58_6863_503C_8868 = {}
local _____6309_952E_540D_5230_7801_8868 = {
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90
}
local _____6309_952E_7801_5230_540D_8868 = {
    [65] = "A",
    [66] = "B",
    [67] = "C",
    [68] = "D",
    [69] = "E",
    [70] = "F",
    [71] = "G",
    [72] = "H",
    [73] = "I",
    [74] = "J",
    [75] = "K",
    [76] = "L",
    [77] = "M",
    [78] = "N",
    [79] = "O",
    [80] = "P",
    [81] = "Q",
    [82] = "R",
    [83] = "S",
    [84] = "T",
    [85] = "U",
    [86] = "V",
    [87] = "W",
    [88] = "X",
    [89] = "Y",
    [90] = "Z"
}
local function _____6784_5EFA_72B6_6001_952E(playerId, field)
    return playerId * 1000 + field
end
local function _____83B7_53D6_73A9_5BB6_7F16_53F7(player)
    return GetPlayerId(player)
end
local function _____83B7_53D6_9ED8_8BA4_503C(field, fallback)
    local value = _____5E38_91CF["本地存档默认值"][field]
    return value == nil and fallback or value
end
local function _____5199_5165_5185_5B58_503C(playerId, field, value)
    _____672C_5730_5B58_6863_503C_8868[_____6784_5EFA_72B6_6001_952E(playerId, field)] = value
end
local function _____8BFB_53D6_5185_5B58_503C(playerId, field, fallback)
    local value = _____672C_5730_5B58_6863_503C_8868[_____6784_5EFA_72B6_6001_952E(playerId, field)]
    return value == nil and fallback or value
end
local function _____5199_5165_9ED8_8BA4_503C_5230_5185_5B58(playerId)
    do
        local field = 1
        while field <= _____5E38_91CF["本地存档字段数量"] do
            _____5199_5165_5185_5B58_503C(
                playerId,
                field,
                _____83B7_53D6_9ED8_8BA4_503C(field, 0)
            )
            field = field + 1
        end
    end
end
local function _____5199_5165Preload_5B57_6BB5(player, playerId)
    do
        local field = 1
        while field <= _____5E38_91CF["本地存档字段数量"] do
            local value = _____8BFB_53D6_5185_5B58_503C(
                playerId,
                field,
                _____83B7_53D6_9ED8_8BA4_503C(field, 0)
            )
            PreloadSL["PreloadSL设置整数"](player, field, value)
            field = field + 1
        end
    end
end
local function _____8BFB_53D6Preload_5B57_6BB5_5230_5185_5B58(player, playerId)
    do
        local field = 1
        while field <= _____5E38_91CF["本地存档字段数量"] do
            local fallback = _____83B7_53D6_9ED8_8BA4_503C(field, 0)
            local value = PreloadSL["PreloadSL读取整数"](player, field)
            _____5199_5165_5185_5B58_503C(playerId, field, value == nil and fallback or value)
            field = field + 1
        end
    end
end
local function _____5E03_5C14_8F6C_6587_672C(value)
    return value ~= 0 and "true" or "false"
end
local function _____6587_672C_8F6C_5E03_5C14_6574_6570(text, fallback)
    local normalized = string.lower(__TS__StringTrim(text))
    if normalized == "true" or normalized == "1" or normalized == "on" or normalized == "yes" or normalized == "开" then
        return 1
    end
    if normalized == "false" or normalized == "flase" or normalized == "0" or normalized == "off" or normalized == "no" or normalized == "关" then
        return 0
    end
    return fallback
end
local function _____6309_952E_7801_8F6C_6587_672C(keyCode)
    local keyName = _____6309_952E_7801_5230_540D_8868[keyCode]
    return keyName == nil and tostring(keyCode) or keyName
end
local function _____6587_672C_8F6C_6309_952E_7801(text, fallback)
    local normalized = string.upper(__TS__StringTrim(text))
    local mapped = _____6309_952E_540D_5230_7801_8868[normalized]
    if mapped ~= nil then
        return mapped
    end
    local value = __TS__ParseInt(normalized, 10)
    if __TS__NumberIsNaN(__TS__Number(value)) then
        return fallback
    end
    return value
end
local function _____6784_5EFA_53EF_8BFB_914D_7F6E_8F7D_8377(playerId)
    local _____5B57_6BB5 = _____5E38_91CF["本地存档字段"]
    local _____52A8_6001_6280_80FD = _____8BFB_53D6_5185_5B58_503C(
        playerId,
        _____5B57_6BB5["动态技能文本开关"],
        _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["动态技能文本开关"], 1)
    )
    local _____4EC7_6068_5F00_5173 = _____8BFB_53D6_5185_5B58_503C(
        playerId,
        _____5B57_6BB5["仇恨漂浮文字开关"],
        _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["仇恨漂浮文字开关"], 1)
    )
    local _____51B7_5374_663E_793A = _____8BFB_53D6_5185_5B58_503C(
        playerId,
        _____5B57_6BB5["QWERD冷却显示开关"],
        _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["QWERD冷却显示开关"], 1)
    )
    local _____84DD_8017_663E_793A = _____8BFB_53D6_5185_5B58_503C(
        playerId,
        _____5B57_6BB5["QWERD蓝耗显示开关"],
        _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["QWERD蓝耗显示开关"], 1)
    )
    local _____4EC7_6068_952E = _____8BFB_53D6_5185_5B58_503C(
        playerId,
        _____5B57_6BB5["仇恨面板热键"],
        _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["仇恨面板热键"], 86)
    )
    local _____624B_518C_952E = _____8BFB_53D6_5185_5B58_503C(
        playerId,
        _____5B57_6BB5["游戏说明手册热键"],
        _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["游戏说明手册热键"], 75)
    )
    local _____663E_793A_952E = _____8BFB_53D6_5185_5B58_503C(
        playerId,
        _____5B57_6BB5["QWERD显示面板热键"],
        _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["QWERD显示面板热键"], 74)
    )
    return (((((((((((("chouhen=" .. _____5E03_5C14_8F6C_6587_672C(_____4EC7_6068_5F00_5173)) .. ";dongtai=") .. _____5E03_5C14_8F6C_6587_672C(_____52A8_6001_6280_80FD)) .. ";lengque=") .. _____5E03_5C14_8F6C_6587_672C(_____51B7_5374_663E_793A)) .. ";lanhao=") .. _____5E03_5C14_8F6C_6587_672C(_____84DD_8017_663E_793A)) .. ";chouhenjian=") .. _____6309_952E_7801_8F6C_6587_672C(_____4EC7_6068_952E)) .. ";shoucejian=") .. _____6309_952E_7801_8F6C_6587_672C(_____624B_518C_952E)) .. ";xianshijian=") .. _____6309_952E_7801_8F6C_6587_672C(_____663E_793A_952E)
end
local function _____6587_672C_5305_542B(text, pattern)
    return (string.find(text, pattern, nil, true) or 0) - 1 >= 0
end
local function _____5E94_7528_53EF_8BFB_914D_7F6E_9879(playerId, key, value)
    local _____5B57_6BB5 = _____5E38_91CF["本地存档字段"]
    if key == "chouhen" or key == "hateText" or key == "仇恨开关" or key == "仇恨文字" then
        local fallback = _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["仇恨漂浮文字开关"], 1)
        _____5199_5165_5185_5B58_503C(
            playerId,
            _____5B57_6BB5["仇恨漂浮文字开关"],
            _____6587_672C_8F6C_5E03_5C14_6574_6570(value, fallback)
        )
        return
    end
    if key == "dongtai" or key == "dynamicSkill" or key == "动态技能" then
        local fallback = _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["动态技能文本开关"], 1)
        _____5199_5165_5185_5B58_503C(
            playerId,
            _____5B57_6BB5["动态技能文本开关"],
            _____6587_672C_8F6C_5E03_5C14_6574_6570(value, fallback)
        )
        return
    end
    if key == "lengque" or key == "cooldown" or key == "冷却显示" then
        local fallback = _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["QWERD冷却显示开关"], 1)
        _____5199_5165_5185_5B58_503C(
            playerId,
            _____5B57_6BB5["QWERD冷却显示开关"],
            _____6587_672C_8F6C_5E03_5C14_6574_6570(value, fallback)
        )
        return
    end
    if key == "lanhao" or key == "manaCost" or key == "蓝耗显示" then
        local fallback = _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["QWERD蓝耗显示开关"], 1)
        _____5199_5165_5185_5B58_503C(
            playerId,
            _____5B57_6BB5["QWERD蓝耗显示开关"],
            _____6587_672C_8F6C_5E03_5C14_6574_6570(value, fallback)
        )
        return
    end
    if key == "chouhenjian" or key == "hateKey" or key == "仇恨键" then
        local fallback = _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["仇恨面板热键"], 86)
        _____5199_5165_5185_5B58_503C(
            playerId,
            _____5B57_6BB5["仇恨面板热键"],
            _____6587_672C_8F6C_6309_952E_7801(value, fallback)
        )
        return
    end
    if key == "shoucejian" or key == "manualKey" or key == "手册键" then
        local fallback = _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["游戏说明手册热键"], 75)
        _____5199_5165_5185_5B58_503C(
            playerId,
            _____5B57_6BB5["游戏说明手册热键"],
            _____6587_672C_8F6C_6309_952E_7801(value, fallback)
        )
        return
    end
    if key == "xianshijian" or key == "displayKey" or key == "显示键" then
        local fallback = _____83B7_53D6_9ED8_8BA4_503C(_____5B57_6BB5["QWERD显示面板热键"], 74)
        _____5199_5165_5185_5B58_503C(
            playerId,
            _____5B57_6BB5["QWERD显示面板热键"],
            _____6587_672C_8F6C_6309_952E_7801(value, fallback)
        )
    end
end
local function _____89E3_6790_53EF_8BFB_914D_7F6E_8F7D_8377(playerId, payload)
    if not _____6587_672C_5305_542B(payload, "=") then
        return false
    end
    local entries = __TS__StringSplit(payload, ";")
    do
        local i = 0
        while i < #entries do
            do
                local entry = entries[i + 1]
                local eqIndex = (string.find(entry, "=", nil, true) or 0) - 1
                if eqIndex <= 0 then
                    goto __continue37
                end
                local key = __TS__StringTrim(__TS__StringSubstring(entry, 0, eqIndex))
                local value = __TS__StringTrim(__TS__StringSubstring(entry, eqIndex + 1))
                _____5E94_7528_53EF_8BFB_914D_7F6E_9879(playerId, key, value)
            end
            ::__continue37::
            i = i + 1
        end
    end
    return true
end
local function _____89E3_6790_65E7_6574_6570_8F7D_8377(player, playerId)
    _____8BFB_53D6Preload_5B57_6BB5_5230_5185_5B58(player, playerId)
end
____exports["本地存档接口可用"] = function()
    return PreloadSL["PreloadSL接口是否存在"]()
end
____exports["获取本地存档接口来源"] = function()
    return PreloadSL["PreloadSL接口来源描述"]()
end
____exports["获取本地存档路径"] = function()
    return PreloadSL["PreloadSL获取存档路径"](_____5E38_91CF["本地存档目录"], _____5E38_91CF["本地存档文件"])
end
____exports["加载玩家本地存档"] = function(player)
    if not ____exports["本地存档接口可用"]() then
        return false
    end
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(player)
    _____5199_5165_9ED8_8BA4_503C_5230_5185_5B58(playerId)
    local payload = PreloadSL["PreloadSL加载文本"](player, _____5E38_91CF["本地存档目录"], _____5E38_91CF["本地存档文件"])
    local ok = payload ~= nil and payload ~= ""
    if ok then
        if not _____89E3_6790_53EF_8BFB_914D_7F6E_8F7D_8377(playerId, payload) then
            _____89E3_6790_65E7_6574_6570_8F7D_8377(player, playerId)
        end
    end
    _____672C_5730_5B58_6863_5DF2_52A0_8F7D_8868[playerId] = true
    return ok
end
____exports["保存玩家本地存档"] = function(player)
    if not ____exports["本地存档接口可用"]() then
        return false
    end
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(player)
    if _____672C_5730_5B58_6863_5DF2_52A0_8F7D_8868[playerId] ~= true then
        _____5199_5165_9ED8_8BA4_503C_5230_5185_5B58(playerId)
        _____672C_5730_5B58_6863_5DF2_52A0_8F7D_8868[playerId] = true
    end
    _____5199_5165_5185_5B58_503C(
        playerId,
        _____5E38_91CF["本地存档字段"]["版本号"],
        _____83B7_53D6_9ED8_8BA4_503C(_____5E38_91CF["本地存档字段"]["版本号"], 1)
    )
    local payload = _____6784_5EFA_53EF_8BFB_914D_7F6E_8F7D_8377(playerId)
    local saveOk = PreloadSL["PreloadSL保存文本"](player, _____5E38_91CF["本地存档目录"], _____5E38_91CF["本地存档文件"], payload)
    return saveOk
end
____exports["读取本地存档整数"] = function(player, field, fallback)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(player)
    local defaultValue = fallback == nil and _____83B7_53D6_9ED8_8BA4_503C(field, 0) or fallback
    return _____8BFB_53D6_5185_5B58_503C(playerId, field, defaultValue)
end
____exports["设置本地存档整数"] = function(player, field, value, autoSave)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(player)
    _____5199_5165_5185_5B58_503C(playerId, field, value)
    if autoSave == true then
        return ____exports["保存玩家本地存档"](player)
    end
    return true
end
____exports["读取本地存档布尔"] = function(player, field, fallback)
    local fallbackValue = fallback == true and 1 or 0
    return ____exports["读取本地存档整数"](player, field, fallbackValue) ~= 0
end
____exports["设置本地存档布尔"] = function(player, field, enabled, autoSave)
    return ____exports["设置本地存档整数"](player, field, enabled and 1 or 0, autoSave)
end
____exports["重置玩家本地存档"] = function(player, autoSave)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(player)
    _____5199_5165_9ED8_8BA4_503C_5230_5185_5B58(playerId)
    _____672C_5730_5B58_6863_5DF2_52A0_8F7D_8868[playerId] = true
    if autoSave == true then
        return ____exports["保存玩家本地存档"](player)
    end
    return true
end
____exports["初始化本地存档内存默认值"] = function()
    do
        local playerId = 0
        while playerId < _____73A9_5BB6_6570_91CF_4E0A_9650 do
            _____5199_5165_9ED8_8BA4_503C_5230_5185_5B58(playerId)
            playerId = playerId + 1
        end
    end
end
return ____exports
