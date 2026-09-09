--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["计算Boss脱战目标生命比例"] = function(_____5F53_524D_6BD4_4F8B, _____9636_6BB5_9608_503C)
    if _____5F53_524D_6BD4_4F8B >= 1 then
        return _____5F53_524D_6BD4_4F8B
    end
    local _____76EE_6807_6BD4_4F8B
    if _____9636_6BB5_9608_503C ~= nil and _____9636_6BB5_9608_503C > 0 and _____9636_6BB5_9608_503C <= 1 then
        _____76EE_6807_6BD4_4F8B = _____9636_6BB5_9608_503C * 1.35
    else
        local _____56DE_590D_6BD4_4F8B = (1 - _____5F53_524D_6BD4_4F8B) * 0.5
        _____76EE_6807_6BD4_4F8B = _____5F53_524D_6BD4_4F8B + (_____56DE_590D_6BD4_4F8B > 0.3 and 0.3 or _____56DE_590D_6BD4_4F8B)
    end
    if _____76EE_6807_6BD4_4F8B > 1 then
        _____76EE_6807_6BD4_4F8B = 1
    end
    return _____76EE_6807_6BD4_4F8B > _____5F53_524D_6BD4_4F8B and _____76EE_6807_6BD4_4F8B or _____5F53_524D_6BD4_4F8B
end
return ____exports
