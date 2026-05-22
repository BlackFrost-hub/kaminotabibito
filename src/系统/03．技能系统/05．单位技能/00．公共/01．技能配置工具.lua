--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["创建单位技能配置"] = function(_____914D_7F6E)
    return _____914D_7F6E
end
____exports["按归类筛选单位技能配置"] = function(_____914D_7F6E_5217_8868, _____5F52_7C7B)
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
____exports["按触发方式筛选单位技能配置"] = function(_____914D_7F6E_5217_8868, _____89E6_53D1_65B9_5F0F)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["触发方式"] == _____89E6_53D1_65B9_5F0F then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____914D_7F6E
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["按单位类型筛选单位技能配置"] = function(_____914D_7F6E_5217_8868, _____5355_4F4D_7C7B_578B)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            do
                local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
                local _____5355_4F4D_7C7B_578B_5217_8868 = _____914D_7F6E["单位类型列表"]
                if not _____5355_4F4D_7C7B_578B_5217_8868 or #_____5355_4F4D_7C7B_578B_5217_8868 == 0 then
                    _____7ED3_679C[#_____7ED3_679C + 1] = _____914D_7F6E
                    goto __continue13
                end
                do
                    local j = 0
                    while j < #_____5355_4F4D_7C7B_578B_5217_8868 do
                        if _____5355_4F4D_7C7B_578B_5217_8868[j + 1] == _____5355_4F4D_7C7B_578B then
                            _____7ED3_679C[#_____7ED3_679C + 1] = _____914D_7F6E
                            break
                        end
                        j = j + 1
                    end
                end
            end
            ::__continue13::
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["按技能ID获取单位技能配置"] = function(_____914D_7F6E_5217_8868, _____6280_80FDID)
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["技能ID"] == _____6280_80FDID then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
____exports["按技能名称获取单位技能配置"] = function(_____914D_7F6E_5217_8868, _____6280_80FD_540D_79F0)
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            if _____914D_7F6E["技能名"] == _____6280_80FD_540D_79F0 then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
____exports["构建单位技能配置索引"] = function(_____914D_7F6E_5217_8868)
    local _____7D22_5F15 = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            _____7D22_5F15[_____914D_7F6E["技能ID"]] = _____914D_7F6E
            i = i + 1
        end
    end
    return _____7D22_5F15
end
____exports["构建按单位类型索引"] = function(_____914D_7F6E_5217_8868)
    local _____7D22_5F15 = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            do
                local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
                local _____5355_4F4D_7C7B_578B_5217_8868 = _____914D_7F6E["单位类型列表"]
                if not _____5355_4F4D_7C7B_578B_5217_8868 or #_____5355_4F4D_7C7B_578B_5217_8868 == 0 then
                    goto __continue31
                end
                do
                    local j = 0
                    while j < #_____5355_4F4D_7C7B_578B_5217_8868 do
                        local _____5355_4F4D_7C7B_578B = tostring(_____5355_4F4D_7C7B_578B_5217_8868[j + 1])
                        if not _____7D22_5F15[_____5355_4F4D_7C7B_578B] then
                            _____7D22_5F15[_____5355_4F4D_7C7B_578B] = {}
                        end
                        local ____7D22_5F15______5355_4F4D_7C7B_578B_0 = _____7D22_5F15[_____5355_4F4D_7C7B_578B]
                        ____7D22_5F15______5355_4F4D_7C7B_578B_0[#____7D22_5F15______5355_4F4D_7C7B_578B_0 + 1] = _____914D_7F6E
                        j = j + 1
                    end
                end
            end
            ::__continue31::
            i = i + 1
        end
    end
    return _____7D22_5F15
end
____exports["构建按触发方式索引"] = function(_____914D_7F6E_5217_8868)
    local _____7D22_5F15 = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            local _____89E6_53D1_65B9_5F0F = _____914D_7F6E["触发方式"]
            if not _____7D22_5F15[_____89E6_53D1_65B9_5F0F] then
                _____7D22_5F15[_____89E6_53D1_65B9_5F0F] = {}
            end
            local ____7D22_5F15______89E6_53D1_65B9_5F0F_1 = _____7D22_5F15[_____89E6_53D1_65B9_5F0F]
            ____7D22_5F15______89E6_53D1_65B9_5F0F_1[#____7D22_5F15______89E6_53D1_65B9_5F0F_1 + 1] = _____914D_7F6E
            i = i + 1
        end
    end
    return _____7D22_5F15
end
return ____exports
