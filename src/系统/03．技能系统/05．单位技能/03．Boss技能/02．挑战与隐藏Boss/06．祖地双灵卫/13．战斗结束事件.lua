--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____6218_6597_7ED3_675F_76D1_542C_5668_5217_8868 = {}
____exports["register祖地双灵卫战斗结束Listener"] = function(listener)
    if type(listener) ~= "function" then
        return
    end
    do
        local i = 0
        while i < #_____6218_6597_7ED3_675F_76D1_542C_5668_5217_8868 do
            if _____6218_6597_7ED3_675F_76D1_542C_5668_5217_8868[i + 1] == listener then
                return
            end
            i = i + 1
        end
    end
    _____6218_6597_7ED3_675F_76D1_542C_5668_5217_8868[#_____6218_6597_7ED3_675F_76D1_542C_5668_5217_8868 + 1] = listener
end
____exports["派发祖地双灵卫战斗结束"] = function(_____8D64_8A93_7075_536B, _____82CD_5F71_7075_536B)
    do
        local i = 0
        while i < #_____6218_6597_7ED3_675F_76D1_542C_5668_5217_8868 do
            _____6218_6597_7ED3_675F_76D1_542C_5668_5217_8868[i + 1](_____8D64_8A93_7075_536B, _____82CD_5F71_7075_536B)
            i = i + 1
        end
    end
end
return ____exports
