--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["创建单位AI配置"] = function(_____914D_7F6E)
    return _____914D_7F6E
end
____exports["按归类筛选单位AI配置"] = function(_____914D_7F6E_5217_8868, _____5F52_7C7B)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["归类"] == _____5F52_7C7B then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____914D_7F6E
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["按单位名筛选单位AI配置"] = function(_____914D_7F6E_5217_8868, _____5355_4F4D_540D)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["单位名"] == _____5355_4F4D_540D then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____914D_7F6E
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["按AI配置ID获取单位AI配置"] = function(_____914D_7F6E_5217_8868, ____AI_914D_7F6EID)
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["AI配置ID"] == ____AI_914D_7F6EID then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
____exports["按单位名获取单位AI配置"] = function(_____914D_7F6E_5217_8868, _____5355_4F4D_540D)
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["单位名"] == _____5355_4F4D_540D then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
____exports["构建单位AI配置ID索引"] = function(_____914D_7F6E_5217_8868)
    local _____7D22_5F15 = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            _____7D22_5F15[_____914D_7F6E["AI配置ID"]] = _____914D_7F6E
            i = i + 1
        end
    end
    return _____7D22_5F15
end
____exports["构建单位名AI配置索引"] = function(_____914D_7F6E_5217_8868)
    local _____7D22_5F15 = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if not _____7D22_5F15[_____914D_7F6E["单位名"]] then
                _____7D22_5F15[_____914D_7F6E["单位名"]] = {}
            end
            local ____7D22_5F15______914D_7F6E__5355_4F4D_540D_0 = _____7D22_5F15[_____914D_7F6E["单位名"]]
            ____7D22_5F15______914D_7F6E__5355_4F4D_540D_0[#____7D22_5F15______914D_7F6E__5355_4F4D_540D_0 + 1] = _____914D_7F6E
            i = i + 1
        end
    end
    return _____7D22_5F15
end
return ____exports
