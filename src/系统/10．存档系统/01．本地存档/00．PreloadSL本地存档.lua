local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharCodeAt = ____lualib.__TS__StringCharCodeAt
local ____exports = {}
--- Preload 本地存档封装
-- 
-- `JASS/世界地图/存档.j` 里的 `YDWE_PreloadSL_*` 是编辑器生成的 JASS 函数，
-- Lua 侧不会自动拥有同名 API。这里直接用原生 Preload 文件生成能力写入本机文件，
-- 再用 `SetPlayerTechMaxAllowed(Player(14/15), key, value)` 在 `Preloader` 执行时回填槽位。
-- 
-- 当前封装支持两层能力：
-- - 文本载荷：给正式配置文件使用，例如 `chouhen=true;shoucejian=K`
-- - 整数槽位：保留给测试和低层兼容使用
local jass = require("jass.common")
local GetLocalPlayer = jass.GetLocalPlayer
local PreloadGenClear = jass.PreloadGenClear
local PreloadGenStart = jass.PreloadGenStart
local Preload = jass.Preload
local PreloadGenEnd = jass.PreloadGenEnd
local Preloader = jass.Preloader
local Player = jass.Player
local SetPlayerTechMaxAllowed = jass.SetPlayerTechMaxAllowed
local GetPlayerTechMaxAllowed = jass.GetPlayerTechMaxAllowed
local _____5B58_6863_6269_5C55_540D = ".sav"
local _____7A7A_8F7D_8377 = ""
local _____5B57_6BB5_5206_9694_7B26 = "|"
local _____6587_672C_5B57_6BB5_540D = "config"
local _____6587_672C_957F_5EA6_69FD = 1
local _____6587_672C_5185_5BB9_8D77_59CB_69FD = 2
local _____6587_672C_69FD_4F4D_6570_91CF = 192
local _____8D1F_6570_6807_8BB0_504F_79FB = 512
local _____5B57_6BB5_503C_8868 = {}
local _____6587_672C_8F7D_8377 = _____7A7A_8F7D_8377
local _____6700_8FD1_8BFB_53D6_8DEF_5F84 = _____7A7A_8F7D_8377
local _____6700_8FD1_63A5_53E3_6765_6E90 = _____7A7A_8F7D_8377
local _____6700_8FD1_52A0_8F7D_6210_529F = false
local _____6700_8FD1_6587_672C_957F_5EA6 = 0
local _____5B57_7B26_5DE5_5177 = string
local _____5B57_7B26_7F16_7801_8F6C_6587_672C = _____5B57_7B26_5DE5_5177.char
local function _____51FD_6570_5B58_5728(fn)
    return type(fn) == "function"
end
local function ____YDWE_5B58_6863_63A5_53E3_662F_5426_5B58_5728()
    return _____51FD_6570_5B58_5728(YDWE_PreloadSL_Set) and _____51FD_6570_5B58_5728(YDWE_PreloadSL_Get) and _____51FD_6570_5B58_5728(YDWE_PreloadSL_Save) and _____51FD_6570_5B58_5728(YDWE_PreloadSL_Load)
end
local function _____662F_5426_672C_5730_73A9_5BB6(player)
    return _____51FD_6570_5B58_5728(GetLocalPlayer) and GetLocalPlayer() == player
end
local function _____6784_5EFA_5B58_6863_8DEF_5F84(dir, file)
    local dirPart = (dir == nil or dir == "") and "default" or dir
    return ((dirPart .. "\\pre") .. file) .. _____5B58_6863_6269_5C55_540D
end
local function _____6784_5EFA_76EE_5F55_5217_8868_8DEF_5F84(dir)
    local dirPart = (dir == nil or dir == "") and "default" or dir
    return dirPart .. "\\list.sav"
end
____exports["PreloadSL获取存档路径"] = function(dir, file)
    return _____6784_5EFA_5B58_6863_8DEF_5F84(dir, file)
end
____exports["PreloadSL获取最近读取路径"] = function()
    return _____6700_8FD1_8BFB_53D6_8DEF_5F84
end
____exports["PreloadSL获取最近接口来源"] = function()
    return _____6700_8FD1_63A5_53E3_6765_6E90
end
____exports["PreloadSL最近加载是否成功"] = function()
    return _____6700_8FD1_52A0_8F7D_6210_529F
end
____exports["PreloadSL获取最近文本长度"] = function()
    return _____6700_8FD1_6587_672C_957F_5EA6
end
local function _____6784_5EFA_6574_6570_8F7D_8377(fieldCount)
    local payload = ""
    do
        local index = 1
        while index <= fieldCount do
            if index > 1 then
                payload = payload .. _____5B57_6BB5_5206_9694_7B26
            end
            local value = _____5B57_6BB5_503C_8868[index]
            payload = payload .. tostring(value == nil and 0 or value)
            index = index + 1
        end
    end
    return payload
end
local function _____6E05_7406_8F7D_8377_6587_672C(payload)
    return table.concat(
        __TS__StringSplit(
            table.concat(
                __TS__StringSplit(
                    table.concat(
                        __TS__StringSplit(payload, "\""),
                        ""
                    ),
                    "\n"
                ),
                ""
            ),
            "\r"
        ),
        ""
    )
end
local function _____89E3_6790_6574_6570_8F7D_8377(payload, fieldCount)
    local parts = __TS__StringSplit(payload, _____5B57_6BB5_5206_9694_7B26)
    do
        local index = 1
        while index <= fieldCount do
            local raw = parts[index]
            local value = (raw == nil or raw == "") and 0 or __TS__ParseInt(raw, 10)
            _____5B57_6BB5_503C_8868[index] = __TS__NumberIsNaN(__TS__Number(value)) and 0 or value
            index = index + 1
        end
    end
end
local function _____9650_5236_6587_672C_957F_5EA6(payload)
    local safePayload = _____6E05_7406_8F7D_8377_6587_672C(payload)
    local maxLength = _____6587_672C_69FD_4F4D_6570_91CF - _____6587_672C_5185_5BB9_8D77_59CB_69FD + 1
    if #safePayload <= maxLength then
        return safePayload
    end
    return __TS__StringSubstring(safePayload, 0, maxLength)
end
local function _____5199_5165YDWE_6587_672C_69FD_4F4D(player, payload)
    local safePayload = _____9650_5236_6587_672C_957F_5EA6(payload)
    YDWE_PreloadSL_Set(player, _____6587_672C_5B57_6BB5_540D, _____6587_672C_957F_5EA6_69FD, #safePayload)
    do
        local i = 0
        while i < #safePayload do
            YDWE_PreloadSL_Set(
                player,
                _____6587_672C_5B57_6BB5_540D,
                _____6587_672C_5185_5BB9_8D77_59CB_69FD + i,
                __TS__StringCharCodeAt(safePayload, i)
            )
            i = i + 1
        end
    end
    _____6700_8FD1_6587_672C_957F_5EA6 = YDWE_PreloadSL_Get(player, _____6587_672C_5B57_6BB5_540D, _____6587_672C_957F_5EA6_69FD)
    return safePayload
end
local function _____8BFB_53D6YDWE_6587_672C_69FD_4F4D(player)
    local length = YDWE_PreloadSL_Get(player, _____6587_672C_5B57_6BB5_540D, _____6587_672C_957F_5EA6_69FD)
    _____6700_8FD1_6587_672C_957F_5EA6 = length == nil and 0 or length
    if length == nil or length <= 0 then
        return _____7A7A_8F7D_8377
    end
    local maxLength = _____6587_672C_69FD_4F4D_6570_91CF - _____6587_672C_5185_5BB9_8D77_59CB_69FD + 1
    local safeLength = length > maxLength and maxLength or length
    local payload = ""
    do
        local i = 0
        while i < safeLength do
            local code = YDWE_PreloadSL_Get(player, _____6587_672C_5B57_6BB5_540D, _____6587_672C_5185_5BB9_8D77_59CB_69FD + i)
            if code == nil or code <= 0 then
                break
            end
            payload = payload .. _____5B57_7B26_7F16_7801_8F6C_6587_672C(code)
            i = i + 1
        end
    end
    return payload
end
local function _____6784_5EFA_4FDD_5B58_6574_6570_6587_672C(key, value)
    local absValue = value < 0 and -value or value
    local typeValue = value < 0 and 2 or 1
    return ((((((("\")\ncall SetPlayerTechMaxAllowed(Player(14)," .. tostring(key)) .. ",") .. tostring(typeValue)) .. ")\ncall SetPlayerTechMaxAllowed(Player(15),") .. tostring(key)) .. ",") .. tostring(absValue)) .. ")\n//"
end
local function _____5199_5165_539F_751FPreload_6574_6570(key, value)
    Preload(_____6784_5EFA_4FDD_5B58_6574_6570_6587_672C(key, value))
end
local function _____8BFB_53D6_539F_751FPreload_6574_6570(key)
    local typeValue = GetPlayerTechMaxAllowed(
        Player(14),
        key
    )
    local absValue = GetPlayerTechMaxAllowed(
        Player(15),
        key
    )
    if typeValue == 1 then
        return absValue
    end
    if typeValue == 2 then
        return -absValue
    end
    return 0
end
local function _____4FDD_5B58_539F_751FPreload_6587_672C(path, payload)
    local safePayload = _____9650_5236_6587_672C_957F_5EA6(payload)
    PreloadGenClear()
    PreloadGenStart()
    _____5199_5165_539F_751FPreload_6574_6570(_____6587_672C_957F_5EA6_69FD, #safePayload)
    do
        local i = 0
        while i < #safePayload do
            _____5199_5165_539F_751FPreload_6574_6570(
                _____6587_672C_5185_5BB9_8D77_59CB_69FD + i,
                __TS__StringCharCodeAt(safePayload, i)
            )
            i = i + 1
        end
    end
    PreloadGenEnd(path)
    _____6700_8FD1_6587_672C_957F_5EA6 = #safePayload
    return safePayload
end
local function _____521D_59CB_5316_539F_751FPreload_76EE_5F55(dir)
    PreloadGenClear()
    PreloadGenStart()
    Preload("")
    PreloadGenEnd(_____6784_5EFA_76EE_5F55_5217_8868_8DEF_5F84(dir))
end
local function _____52A0_8F7D_539F_751FPreload_6587_672C(path)
    Preloader(path)
    local length = _____8BFB_53D6_539F_751FPreload_6574_6570(_____6587_672C_957F_5EA6_69FD)
    _____6700_8FD1_6587_672C_957F_5EA6 = length == nil and 0 or length
    if length == nil or length <= 0 then
        return _____7A7A_8F7D_8377
    end
    local maxLength = _____6587_672C_69FD_4F4D_6570_91CF - _____6587_672C_5185_5BB9_8D77_59CB_69FD + 1
    local safeLength = length > maxLength and maxLength or length
    local payload = ""
    do
        local i = 0
        while i < safeLength do
            local code = _____8BFB_53D6_539F_751FPreload_6574_6570(_____6587_672C_5185_5BB9_8D77_59CB_69FD + i)
            if code == nil or code <= 0 then
                break
            end
            payload = payload .. _____5B57_7B26_7F16_7801_8F6C_6587_672C(code)
            i = i + 1
        end
    end
    _____6700_8FD1_8BFB_53D6_8DEF_5F84 = path
    return payload
end
____exports["PreloadSL接口是否存在"] = function()
    if ____YDWE_5B58_6863_63A5_53E3_662F_5426_5B58_5728() then
        return true
    end
    return _____51FD_6570_5B58_5728(GetLocalPlayer) and _____51FD_6570_5B58_5728(PreloadGenClear) and _____51FD_6570_5B58_5728(PreloadGenStart) and _____51FD_6570_5B58_5728(Preload) and _____51FD_6570_5B58_5728(PreloadGenEnd) and _____51FD_6570_5B58_5728(Preloader) and _____51FD_6570_5B58_5728(Player) and _____51FD_6570_5B58_5728(SetPlayerTechMaxAllowed) and _____51FD_6570_5B58_5728(GetPlayerTechMaxAllowed)
end
____exports["PreloadSL接口来源描述"] = function()
    if ____YDWE_5B58_6863_63A5_53E3_662F_5426_5B58_5728() then
        return "YDWE_PreloadSL"
    end
    if ____exports["PreloadSL接口是否存在"]() then
        return "native-preload-tech"
    end
    return "missing-native-preload-tech"
end
____exports["PreloadSL设置整数"] = function(player, index, value)
    if ____YDWE_5B58_6863_63A5_53E3_662F_5426_5B58_5728() then
        YDWE_PreloadSL_Set(
            player,
            tostring(index),
            index,
            value
        )
    end
    _____5B57_6BB5_503C_8868[index] = value
    return true
end
____exports["PreloadSL读取整数"] = function(player, index)
    if ____YDWE_5B58_6863_63A5_53E3_662F_5426_5B58_5728() then
        return YDWE_PreloadSL_Get(
            player,
            tostring(index),
            index
        )
    end
    local value = _____5B57_6BB5_503C_8868[index]
    return value == nil and 0 or value
end
____exports["PreloadSL设置文本载荷"] = function(payload)
    _____6587_672C_8F7D_8377 = _____6E05_7406_8F7D_8377_6587_672C(payload)
    return true
end
____exports["PreloadSL读取文本载荷"] = function()
    return _____6587_672C_8F7D_8377
end
____exports["PreloadSL保存文本"] = function(player, dir, file, payload)
    if not ____exports["PreloadSL接口是否存在"]() then
        return false
    end
    if ____YDWE_5B58_6863_63A5_53E3_662F_5426_5B58_5728() then
        _____6700_8FD1_63A5_53E3_6765_6E90 = "YDWE_PreloadSL"
        _____6700_8FD1_52A0_8F7D_6210_529F = false
        _____6700_8FD1_8BFB_53D6_8DEF_5F84 = (dir == nil or dir == "") and file or (dir .. "\\") .. file
        _____6587_672C_8F7D_8377 = _____5199_5165YDWE_6587_672C_69FD_4F4D(player, payload)
        YDWE_PreloadSL_Save(player, dir, file, _____6587_672C_69FD_4F4D_6570_91CF)
        return true
    end
    _____6700_8FD1_63A5_53E3_6765_6E90 = "native-preload-tech"
    if not _____662F_5426_672C_5730_73A9_5BB6(player) then
        return true
    end
    local path = _____6784_5EFA_5B58_6863_8DEF_5F84(dir, file)
    _____6700_8FD1_8BFB_53D6_8DEF_5F84 = path
    _____521D_59CB_5316_539F_751FPreload_76EE_5F55(dir)
    _____6587_672C_8F7D_8377 = _____4FDD_5B58_539F_751FPreload_6587_672C(path, payload)
    return true
end
____exports["PreloadSL加载文本"] = function(player, dir, file)
    if not ____exports["PreloadSL接口是否存在"]() then
        return _____7A7A_8F7D_8377
    end
    if ____YDWE_5B58_6863_63A5_53E3_662F_5426_5B58_5728() then
        _____6700_8FD1_63A5_53E3_6765_6E90 = "YDWE_PreloadSL"
        local ok = YDWE_PreloadSL_Load(player, dir, file, _____6587_672C_69FD_4F4D_6570_91CF)
        _____6700_8FD1_52A0_8F7D_6210_529F = ok == true
        _____6700_8FD1_8BFB_53D6_8DEF_5F84 = (dir == nil or dir == "") and file or (dir .. "\\") .. file
        if not ok then
            return _____7A7A_8F7D_8377
        end
        _____6587_672C_8F7D_8377 = _____8BFB_53D6YDWE_6587_672C_69FD_4F4D(player)
        return _____6587_672C_8F7D_8377 == nil and _____7A7A_8F7D_8377 or _____6587_672C_8F7D_8377
    end
    _____6700_8FD1_63A5_53E3_6765_6E90 = "native-preload-tech"
    _____6700_8FD1_52A0_8F7D_6210_529F = false
    if not _____662F_5426_672C_5730_73A9_5BB6(player) then
        return _____6587_672C_8F7D_8377
    end
    local path = _____6784_5EFA_5B58_6863_8DEF_5F84(dir, file)
    _____6700_8FD1_8BFB_53D6_8DEF_5F84 = path
    _____6587_672C_8F7D_8377 = _____52A0_8F7D_539F_751FPreload_6587_672C(path)
    _____6700_8FD1_52A0_8F7D_6210_529F = _____6587_672C_8F7D_8377 ~= _____7A7A_8F7D_8377
    return _____6587_672C_8F7D_8377 == nil and _____7A7A_8F7D_8377 or _____6587_672C_8F7D_8377
end
____exports["PreloadSL保存"] = function(player, dir, file, fieldCount)
    if not ____exports["PreloadSL接口是否存在"]() then
        return false
    end
    if ____YDWE_5B58_6863_63A5_53E3_662F_5426_5B58_5728() then
        YDWE_PreloadSL_Save(player, dir, file, fieldCount)
        return true
    end
    if not _____662F_5426_672C_5730_73A9_5BB6(player) then
        return true
    end
    local path = _____6784_5EFA_5B58_6863_8DEF_5F84(dir, file)
    local payload = _____6784_5EFA_6574_6570_8F7D_8377(fieldCount)
    return ____exports["PreloadSL保存文本"](player, dir, file, payload)
end
____exports["PreloadSL加载"] = function(player, dir, file, fieldCount)
    if not ____exports["PreloadSL接口是否存在"]() then
        return false
    end
    if ____YDWE_5B58_6863_63A5_53E3_662F_5426_5B58_5728() then
        return YDWE_PreloadSL_Load(player, dir, file, fieldCount)
    end
    if not _____662F_5426_672C_5730_73A9_5BB6(player) then
        return true
    end
    local payload = ____exports["PreloadSL加载文本"](player, dir, file)
    if payload == nil or payload == _____7A7A_8F7D_8377 then
        return false
    end
    _____89E3_6790_6574_6570_8F7D_8377(payload, fieldCount)
    return true
end
return ____exports
