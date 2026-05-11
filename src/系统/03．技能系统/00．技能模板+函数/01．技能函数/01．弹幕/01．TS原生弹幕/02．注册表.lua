local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
____exports["原生弹幕实例表"] = {}
____exports["单位到原生弹幕ID"] = {}
____exports["原生弹幕ID列表"] = {}
local _____4E0B_4E00_4E2A_539F_751F_5F39_5E55ID = 0
____exports["分配原生弹幕ID"] = function()
    _____4E0B_4E00_4E2A_539F_751F_5F39_5E55ID = _____4E0B_4E00_4E2A_539F_751F_5F39_5E55ID + 1
    return _____4E0B_4E00_4E2A_539F_751F_5F39_5E55ID
end
____exports["获取原生弹幕实例"] = function(_____5F39_5E55ID)
    return ____exports["原生弹幕实例表"][_____5F39_5E55ID]
end
____exports["注册原生弹幕实例"] = function(_____5B9E_4F8B, _____5F39_5E55_5355_4F4D_53E5_67C4ID)
    ____exports["原生弹幕实例表"][_____5B9E_4F8B.id] = _____5B9E_4F8B
    ____exports["单位到原生弹幕ID"][_____5F39_5E55_5355_4F4D_53E5_67C4ID] = _____5B9E_4F8B.id
    local ____exports__539F_751F_5F39_5E55ID_5217_8868_0 = ____exports["原生弹幕ID列表"]
    ____exports__539F_751F_5F39_5E55ID_5217_8868_0[#____exports__539F_751F_5F39_5E55ID_5217_8868_0 + 1] = _____5B9E_4F8B.id
end
____exports["移除原生弹幕实例"] = function(_____5F39_5E55ID, _____5F39_5E55_5355_4F4D_53E5_67C4ID)
    __TS__Delete(____exports["原生弹幕实例表"], _____5F39_5E55ID)
    if _____5F39_5E55_5355_4F4D_53E5_67C4ID > 0 then
        __TS__Delete(____exports["单位到原生弹幕ID"], _____5F39_5E55_5355_4F4D_53E5_67C4ID)
    end
    do
        local i = #____exports["原生弹幕ID列表"] - 1
        while i >= 0 do
            if ____exports["原生弹幕ID列表"][i + 1] == _____5F39_5E55ID then
                __TS__ArraySplice(____exports["原生弹幕ID列表"], i, 1)
                break
            end
            i = i - 1
        end
    end
end
return ____exports
