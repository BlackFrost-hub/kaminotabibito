--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C = ____require_result_0["延后一帧执行伤害派生效果"]
____exports["创建伤害派生批处理队列"] = function(_____540D_79F0, _____9009_9879)
    local _____961F_5217 = {}
    local _____5DF2_5B89_6392_5904_7406 = false
    local function _____6267_884C_6279_5904_7406()
        _____5DF2_5B89_6392_5904_7406 = false
        while #_____961F_5217 > 0 do
            do
                local _____4E0A_4E0B_6587 = table.remove(_____961F_5217, 1)
                if _____4E0A_4E0B_6587 == nil then
                    goto __continue4
                end
                _____9009_9879["处理"](_____4E0A_4E0B_6587)
            end
            ::__continue4::
        end
    end
    return {
        ["名称"] = _____540D_79F0,
        ["加入"] = function(_____4E0A_4E0B_6587)
            _____961F_5217[#_____961F_5217 + 1] = _____4E0A_4E0B_6587
            if _____5DF2_5B89_6392_5904_7406 then
                return
            end
            _____5DF2_5B89_6392_5904_7406 = true
            _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C(_____6267_884C_6279_5904_7406)
        end,
        ["清空"] = function()
            while #_____961F_5217 > 0 do
                table.remove(_____961F_5217)
            end
            _____5DF2_5B89_6392_5904_7406 = false
        end
    }
end
return ____exports
