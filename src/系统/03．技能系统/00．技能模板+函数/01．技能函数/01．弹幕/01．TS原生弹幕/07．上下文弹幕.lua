local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____03_FF0E_5BF9_5916_63A5_53E3["创建原生弹幕"]
local _____4E0A_4E0B_6587_5F39_5E55_8868 = {}
local function _____6E05_7406_4E0A_4E0B_6587_5F39_5E55(_____5F39_5E55ID)
    __TS__Delete(_____4E0A_4E0B_6587_5F39_5E55_8868, _____5F39_5E55ID)
end
____exports["创建带上下文原生弹幕"] = function(_____53C2_6570)
    local base = _____53C2_6570["弹幕参数"]
    local _____539Fon_547D_4E2D = base["on命中"]
    local _____539Fon_547D_4E2D_5355_4F4D = base["on命中单位"]
    local _____539Fon_7ED3_675F = base["on结束"]
    base["on命中"] = function(target, projectileId)
        local ctx = _____4E0A_4E0B_6587_5F39_5E55_8868[projectileId]
        if ctx ~= nil and _____53C2_6570["on命中"] ~= nil then
            _____53C2_6570["on命中"]({["上下文"] = ctx, ["命中单位"] = target, ["弹幕ID"] = projectileId})
        end
        if _____539Fon_547D_4E2D ~= nil then
            _____539Fon_547D_4E2D(target, projectileId)
        end
        if _____53C2_6570["命中后清理"] == true then
            _____6E05_7406_4E0A_4E0B_6587_5F39_5E55(projectileId)
        end
    end
    base["on命中单位"] = function(target, projectileId)
        if _____539Fon_547D_4E2D_5355_4F4D ~= nil then
            _____539Fon_547D_4E2D_5355_4F4D(target, projectileId)
        end
    end
    base["on结束"] = function(reason, projectileId)
        local ctx = _____4E0A_4E0B_6587_5F39_5E55_8868[projectileId]
        if ctx ~= nil and _____53C2_6570["on结束"] ~= nil then
            _____53C2_6570["on结束"]({["上下文"] = ctx, ["原因"] = reason, ["弹幕ID"] = projectileId})
        end
        if _____539Fon_7ED3_675F ~= nil then
            _____539Fon_7ED3_675F(reason, projectileId)
        end
        _____6E05_7406_4E0A_4E0B_6587_5F39_5E55(projectileId)
    end
    local instance = _____521B_5EFA_539F_751F_5F39_5E55(base)
    if instance == nil or instance["弹幕ID"] == nil then
        return nil
    end
    _____4E0A_4E0B_6587_5F39_5E55_8868[instance["弹幕ID"]] = _____53C2_6570["上下文"]
    return instance
end
return ____exports
