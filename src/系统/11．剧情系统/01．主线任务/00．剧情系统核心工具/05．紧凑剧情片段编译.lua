local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
____exports["编译紧凑动作"] = function(_____52A8_4F5C)
    return {
        type = "runAction",
        id = _____52A8_4F5C["动作ID"],
        ["名称"] = _____52A8_4F5C["名称"],
        ["动作ID"] = _____52A8_4F5C["动作ID"],
        ["参数"] = __TS__ObjectAssign({["挂点"] = _____52A8_4F5C["挂点"], ["对白序号"] = _____52A8_4F5C["对白序号"] or 0, ["时间秒"] = _____52A8_4F5C["时间秒"] or 0}, _____52A8_4F5C["参数"] or ({}))
    }
end
____exports["编译紧凑剧情片段"] = function(_____914D_7F6E)
    local _____6B65_9AA4_5217_8868 = {}
    local _____52A8_4F5C_65F6_95F4_7EBF = _____914D_7F6E["动作时间线"] or ({})
    do
        local i = 0
        while i < #_____914D_7F6E["对白列表"] do
            local _____5BF9_767D = _____914D_7F6E["对白列表"][i + 1]
            do
                local j = 0
                while j < #_____52A8_4F5C_65F6_95F4_7EBF do
                    local _____52A8_4F5C = _____52A8_4F5C_65F6_95F4_7EBF[j + 1]
                    if _____52A8_4F5C["挂点"] == "beforeDialog" and _____52A8_4F5C["对白序号"] == _____5BF9_767D["序号"] then
                        _____6B65_9AA4_5217_8868[#_____6B65_9AA4_5217_8868 + 1] = ____exports["编译紧凑动作"](_____52A8_4F5C)
                    end
                    j = j + 1
                end
            end
            _____6B65_9AA4_5217_8868[#_____6B65_9AA4_5217_8868 + 1] = {
                type = "dialog",
                id = (_____914D_7F6E["片段ID"] .. "_dialog_") .. tostring(_____5BF9_767D["序号"]),
                ["名称"] = (tostring(_____5BF9_767D["序号"]) .. ". ") .. _____5BF9_767D["说话者"],
                ["说话者"] = _____5BF9_767D["说话者"],
                ["文本"] = _____5BF9_767D["文本"],
                ["持续时间"] = _____5BF9_767D["持续时间"],
                ["使用原生电影系统"] = _____5BF9_767D["使用原生电影系统"],
                ["原生电影阻塞"] = _____5BF9_767D["原生电影阻塞"]
            }
            do
                local j = 0
                while j < #_____52A8_4F5C_65F6_95F4_7EBF do
                    local _____52A8_4F5C = _____52A8_4F5C_65F6_95F4_7EBF[j + 1]
                    if _____52A8_4F5C["挂点"] == "afterDialog" and _____52A8_4F5C["对白序号"] == _____5BF9_767D["序号"] then
                        _____6B65_9AA4_5217_8868[#_____6B65_9AA4_5217_8868 + 1] = ____exports["编译紧凑动作"](_____52A8_4F5C)
                    end
                    j = j + 1
                end
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #_____52A8_4F5C_65F6_95F4_7EBF do
            local _____52A8_4F5C = _____52A8_4F5C_65F6_95F4_7EBF[i + 1]
            if _____52A8_4F5C["挂点"] == "absoluteTime" then
                _____6B65_9AA4_5217_8868[#_____6B65_9AA4_5217_8868 + 1] = ____exports["编译紧凑动作"](_____52A8_4F5C)
            end
            i = i + 1
        end
    end
    return {
        ["片段ID"] = _____914D_7F6E["片段ID"],
        ["名称"] = _____914D_7F6E["名称"],
        ["可Esc整段跳过"] = _____914D_7F6E["可Esc整段跳过"],
        ["默认倍速"] = _____914D_7F6E["默认倍速"],
        ["步骤列表"] = _____6B65_9AA4_5217_8868
    }
end
____exports["合并剧情步骤列表"] = function(_____7247_6BB5ID, _____540D_79F0, _____7247_6BB5_5217_8868)
    local _____6B65_9AA4_5217_8868 = {}
    do
        local i = 0
        while i < #_____7247_6BB5_5217_8868 do
            local _____7247_6BB5 = _____7247_6BB5_5217_8868[i + 1]
            do
                local j = 0
                while j < #_____7247_6BB5["步骤列表"] do
                    _____6B65_9AA4_5217_8868[#_____6B65_9AA4_5217_8868 + 1] = _____7247_6BB5["步骤列表"][j + 1]
                    j = j + 1
                end
            end
            i = i + 1
        end
    end
    return {
        ["片段ID"] = _____7247_6BB5ID,
        ["名称"] = _____540D_79F0,
        ["可Esc整段跳过"] = true,
        ["默认倍速"] = 1,
        ["步骤列表"] = _____6B65_9AA4_5217_8868
    }
end
return ____exports
