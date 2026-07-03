local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____02_FF0EBoss_5C42_6570_72B6_6001_96C6 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.02．Boss层数状态集")
local _____521B_5EFABoss_5C42_6570_72B6_6001_96C6 = ____02_FF0EBoss_5C42_6570_72B6_6001_96C6["创建Boss层数状态集"]
local _____5355_4F4D_72B6_6001_8868_5B9E_73B0 = __TS__Class()
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.name = "单位状态表实现"
function _____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype.____constructor(self, _____53C2_6570)
    self["单位列表"] = {}
    self["层数状态"] = _____521B_5EFABoss_5C42_6570_72B6_6001_96C6(_____53C2_6570["层数状态列表"])
    self["设置单位列表"](self, _____53C2_6570["单位列表"] or ({}))
end
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype["设置单位列表"] = function(self, _____5355_4F4D_5217_8868)
    self["单位列表"] = {}
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            local ____self__5355_4F4D_5217_8868_0 = self["单位列表"]
            ____self__5355_4F4D_5217_8868_0[#____self__5355_4F4D_5217_8868_0 + 1] = _____5355_4F4D_5217_8868[i + 1]
            i = i + 1
        end
    end
end
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype["取单位列表"] = function(self)
    local result = {}
    do
        local i = 0
        while i < #self["单位列表"] do
            result[#result + 1] = self["单位列表"][i + 1]
            i = i + 1
        end
    end
    return result
end
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype["增加"] = function(self, _____72B6_6001ID, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____5C42_6570 == nil then
        _____5C42_6570 = 1
    end
    if _____539F_56E0 == nil then
        _____539F_56E0 = "单位状态增加"
    end
    local ____self_1 = self["层数状态"]
    return ____self_1["增加"](
        ____self_1,
        _____72B6_6001ID,
        _____5355_4F4D,
        _____5C42_6570,
        _____539F_56E0
    )
end
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype["设置"] = function(self, _____72B6_6001ID, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "单位状态设置"
    end
    local ____self_2 = self["层数状态"]
    return ____self_2["设置"](
        ____self_2,
        _____72B6_6001ID,
        _____5355_4F4D,
        _____5C42_6570,
        _____539F_56E0
    )
end
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype["减少"] = function(self, _____72B6_6001ID, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____5C42_6570 == nil then
        _____5C42_6570 = 1
    end
    if _____539F_56E0 == nil then
        _____539F_56E0 = "单位状态减少"
    end
    local ____self_3 = self["层数状态"]
    return ____self_3["减少"](
        ____self_3,
        _____72B6_6001ID,
        _____5355_4F4D,
        _____5C42_6570,
        _____539F_56E0
    )
end
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype["取层数"] = function(self, _____72B6_6001ID, _____5355_4F4D)
    local ____self_4 = self["层数状态"]
    return ____self_4["取层数"](____self_4, _____72B6_6001ID, _____5355_4F4D)
end
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype["清空单位"] = function(self, _____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "单位状态清空"
    end
    local ____self_5 = self["层数状态"]
    ____self_5["清空单位全部"](____self_5, _____5355_4F4D, _____539F_56E0)
end
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype["清空全部单位"] = function(self, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "单位状态清空全部"
    end
    do
        local i = 0
        while i < #self["单位列表"] do
            self["清空单位"](self, self["单位列表"][i + 1], _____539F_56E0)
            i = i + 1
        end
    end
end
_____5355_4F4D_72B6_6001_8868_5B9E_73B0.prototype["销毁"] = function(self)
    self["清空全部单位"](self, "单位状态销毁")
    local ____self_6 = self["层数状态"]
    ____self_6["销毁"](____self_6)
end
____exports["创建单位状态表"] = function(_____53C2_6570)
    local _____8868 = __TS__New(_____5355_4F4D_72B6_6001_8868_5B9E_73B0, _____53C2_6570)
    if _____53C2_6570["清理"] ~= nil then
        local ____self_7 = _____53C2_6570["清理"]
        ____self_7["登记清理"](
            ____self_7,
            _____53C2_6570["名称"],
            function()
                _____8868["销毁"](_____8868)
            end
        )
    end
    return _____8868
end
return ____exports
