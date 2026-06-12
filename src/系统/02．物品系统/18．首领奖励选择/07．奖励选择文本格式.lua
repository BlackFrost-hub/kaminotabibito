local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
---
-- @noSelfInFile
local luaString = string
local stringByte = luaString.byte
local stringSub = luaString.sub
local function _____83B7_53D6Utf8_5B57_7B26_5B57_8282_6570(_____9996_5B57_8282)
    if _____9996_5B57_8282 < 128 then
        return 1
    end
    if _____9996_5B57_8282 < 224 then
        return 2
    end
    if _____9996_5B57_8282 < 240 then
        return 3
    end
    return 4
end
local function _____4F30_7B97_7279_6548_5B57_7B26_5BBD_5EA6(_____5B57_7B26, _____9996_5B57_8282, _____5B57_8282_6570)
    if _____5B57_8282_6570 == 1 then
        if _____9996_5B57_8282 == 32 then
            return 0.55
        end
        if _____9996_5B57_8282 >= 48 and _____9996_5B57_8282 <= 57 then
            return 0.9
        end
        if _____9996_5B57_8282 >= 65 and _____9996_5B57_8282 <= 90 or _____9996_5B57_8282 >= 97 and _____9996_5B57_8282 <= 122 then
            return 0.95
        end
        return 0.75
    end
    if _____5B57_7B26 == "，" or _____5B57_7B26 == "。" or _____5B57_7B26 == "；" or _____5B57_7B26 == "：" or _____5B57_7B26 == "、" then
        return 1.25
    end
    return 2
end
____exports["格式化奖励属性列"] = function(_____6587_672C, _____5217_53F7, _____6BCF_5217_6700_5927_884C_6570)
    local _____884C_5217_8868 = __TS__StringSplit(_____6587_672C, "\n")
    local _____8D77_59CB = _____5217_53F7 * _____6BCF_5217_6700_5927_884C_6570
    local _____7ED3_675F = _____8D77_59CB + _____6BCF_5217_6700_5927_884C_6570
    local _____5F53_524D_6709_6548_5E8F_53F7 = 0
    local _____7ED3_679C = ""
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < #_____884C_5217_8868 do
            do
                local _____884C = _____884C_5217_8868[_____5E8F_53F7 + 1]
                if _____884C == "" then
                    goto __continue14
                end
                if _____5F53_524D_6709_6548_5E8F_53F7 >= _____8D77_59CB and _____5F53_524D_6709_6548_5E8F_53F7 < _____7ED3_675F then
                    if _____7ED3_679C ~= "" then
                        _____7ED3_679C = _____7ED3_679C .. "\n"
                    end
                    _____7ED3_679C = (_____7ED3_679C .. "· ") .. _____884C
                end
                _____5F53_524D_6709_6548_5E8F_53F7 = _____5F53_524D_6709_6548_5E8F_53F7 + 1
            end
            ::__continue14::
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    return _____7ED3_679C
end
____exports["按显示宽度换行"] = function(_____6587_672C, _____6BCF_884C_6700_5927_5BBD_5EA6)
    local _____7ED3_679C = ""
    local _____5F53_524D_884C = ""
    local _____5F53_524D_5BBD_5EA6 = 0
    local _____5B57_8282_4F4D_7F6E = 1
    while _____5B57_8282_4F4D_7F6E <= #_____6587_672C do
        local _____9996_5B57_8282 = stringByte(_____6587_672C, _____5B57_8282_4F4D_7F6E) or 0
        local _____5B57_8282_6570 = _____83B7_53D6Utf8_5B57_7B26_5B57_8282_6570(_____9996_5B57_8282)
        local _____5B57_7B26 = stringSub(_____6587_672C, _____5B57_8282_4F4D_7F6E, _____5B57_8282_4F4D_7F6E + _____5B57_8282_6570 - 1)
        local _____5B57_7B26_5BBD_5EA6 = _____4F30_7B97_7279_6548_5B57_7B26_5BBD_5EA6(_____5B57_7B26, _____9996_5B57_8282, _____5B57_8282_6570)
        if _____5F53_524D_884C ~= "" and _____5F53_524D_5BBD_5EA6 + _____5B57_7B26_5BBD_5EA6 > _____6BCF_884C_6700_5927_5BBD_5EA6 then
            if _____7ED3_679C ~= "" then
                _____7ED3_679C = _____7ED3_679C .. "\n"
            end
            _____7ED3_679C = _____7ED3_679C .. _____5F53_524D_884C
            _____5F53_524D_884C = ""
            _____5F53_524D_5BBD_5EA6 = 0
        end
        _____5F53_524D_884C = _____5F53_524D_884C .. tostring(_____5B57_7B26)
        _____5F53_524D_5BBD_5EA6 = _____5F53_524D_5BBD_5EA6 + _____5B57_7B26_5BBD_5EA6
        _____5B57_8282_4F4D_7F6E = _____5B57_8282_4F4D_7F6E + _____5B57_8282_6570
    end
    if _____5F53_524D_884C ~= "" then
        if _____7ED3_679C ~= "" then
            _____7ED3_679C = _____7ED3_679C .. "\n"
        end
        _____7ED3_679C = _____7ED3_679C .. _____5F53_524D_884C
    end
    return _____7ED3_679C
end
____exports["格式化奖励特效列表"] = function(_____6587_672C)
    local _____884C_5217_8868 = __TS__StringSplit(_____6587_672C, "\n")
    local _____7ED3_679C = ""
    local _____5DF2_5199_6570_91CF = 0
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < #_____884C_5217_8868 do
            do
                local _____884C = _____884C_5217_8868[_____5E8F_53F7 + 1]
                if _____884C == "" then
                    goto __continue26
                end
                if _____7ED3_679C ~= "" then
                    _____7ED3_679C = _____7ED3_679C .. "\n"
                end
                _____7ED3_679C = _____7ED3_679C .. ____exports["按显示宽度换行"](_____884C, 61)
                _____5DF2_5199_6570_91CF = _____5DF2_5199_6570_91CF + 1
                if _____5DF2_5199_6570_91CF >= 2 then
                    break
                end
            end
            ::__continue26::
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    return _____7ED3_679C
end
return ____exports
