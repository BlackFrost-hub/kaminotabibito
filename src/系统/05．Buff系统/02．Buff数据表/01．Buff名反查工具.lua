local ____lualib = require("lualib_bundle")
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
local ____00_FF0EBuff_6570_636E_8868 = require("系统.05．Buff系统.02．Buff数据表.00．Buff数据表")
local ____Buff_6570_636E_8868 = ____00_FF0EBuff_6570_636E_8868["Buff数据表"]
local function normalizeBuffName(name)
    local result = ""
    do
        local i = 0
        while i < #name do
            do
                local ch = __TS__StringCharAt(name, i)
                if ch == "\r" or ch == "\n" then
                    goto __continue4
                end
                if ch == "\\" then
                    local next = __TS__StringCharAt(name, i + 1)
                    if next == "n" or next == "r" then
                        i = i + 1
                        goto __continue4
                    end
                end
                if ch == "|" then
                    local next = __TS__StringCharAt(name, i + 1)
                    if next == "r" or next == "R" then
                        i = i + 1
                        goto __continue4
                    end
                    if next == "c" or next == "C" then
                        i = i + 9
                        goto __continue4
                    end
                end
                result = result .. ch
            end
            ::__continue4::
            i = i + 1
        end
    end
    return __TS__StringTrim(result)
end
____exports["创建Buff名反查器"] = function(_____914D_7F6E_8868, _____540D_79F0_5B57_6BB5_5217_8868)
    if _____540D_79F0_5B57_6BB5_5217_8868 == nil then
        _____540D_79F0_5B57_6BB5_5217_8868 = {"Bufftip", "EditorName"}
    end
    return function(name)
        local normalized = normalizeBuffName(name)
        for ____, ____value in ipairs(__TS__ObjectEntries(_____914D_7F6E_8868)) do
            local buffId = ____value[1]
            local data = ____value[2]
            do
                local i = 0
                while i < #_____540D_79F0_5B57_6BB5_5217_8868 do
                    local fieldName = _____540D_79F0_5B57_6BB5_5217_8868[i + 1]
                    local fieldValue = data[fieldName]
                    if type(fieldValue) == "string" and normalizeBuffName(fieldValue) == normalized then
                        return buffId
                    end
                    i = i + 1
                end
            end
            if type(data.key) == "string" and normalizeBuffName(data.key) == normalized then
                return buffId
            end
            if normalizeBuffName(buffId) == normalized then
                return buffId
            end
        end
        return nil
    end
end
____exports["Buff名反查器"] = ____exports["创建Buff名反查器"](____Buff_6570_636E_8868)
____exports["按名字反查BuffID"] = function(name)
    return ____exports["Buff名反查器"](name)
end
return ____exports
