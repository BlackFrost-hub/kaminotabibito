local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.01．可配置层数状态")
local _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001 = ____01_FF0E_53EF_914D_7F6E_5C42_6570_72B6_6001["创建可配置层数状态"]
local ____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0 = __TS__Class()
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.name = "Boss层数状态集实现"
function ____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype.____constructor(self, _____5B9A_4E49_5217_8868)
    self["控制器表"] = {}
    self["ID列表"] = {}
    do
        local i = 0
        while i < #_____5B9A_4E49_5217_8868 do
            local _____5B9A_4E49 = _____5B9A_4E49_5217_8868[i + 1]
            local ____self_ID_5217_8868_0 = self["ID列表"]
            ____self_ID_5217_8868_0[#____self_ID_5217_8868_0 + 1] = _____5B9A_4E49.ID
            self["控制器表"][_____5B9A_4E49.ID] = _____521B_5EFA_53EF_914D_7F6E_5C42_6570_72B6_6001(_____5B9A_4E49)
            i = i + 1
        end
    end
end
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype["取控制器"] = function(self, ID)
    return self["控制器表"][ID]
end
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype["增加"] = function(self, ID, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____5C42_6570 == nil then
        _____5C42_6570 = 1
    end
    if _____539F_56E0 == nil then
        _____539F_56E0 = "增加"
    end
    local _____63A7_5236_5668 = self["控制器表"][ID]
    return _____63A7_5236_5668 == nil and 0 or _____63A7_5236_5668["增加"](_____63A7_5236_5668, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
end
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype["设置"] = function(self, ID, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "设置"
    end
    local _____63A7_5236_5668 = self["控制器表"][ID]
    return _____63A7_5236_5668 == nil and 0 or _____63A7_5236_5668["设置"](_____63A7_5236_5668, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
end
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype["减少"] = function(self, ID, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
    if _____5C42_6570 == nil then
        _____5C42_6570 = 1
    end
    if _____539F_56E0 == nil then
        _____539F_56E0 = "减少"
    end
    local _____63A7_5236_5668 = self["控制器表"][ID]
    return _____63A7_5236_5668 == nil and 0 or _____63A7_5236_5668["减少"](_____63A7_5236_5668, _____5355_4F4D, _____5C42_6570, _____539F_56E0)
end
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype["清空"] = function(self, ID, _____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "清空"
    end
    local _____63A7_5236_5668 = self["控制器表"][ID]
    if _____63A7_5236_5668 ~= nil then
        _____63A7_5236_5668["清空"](_____63A7_5236_5668, _____5355_4F4D, _____539F_56E0)
    end
end
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype["清空单位全部"] = function(self, _____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "清空全部"
    end
    do
        local i = 0
        while i < #self["ID列表"] do
            self["清空"](self, self["ID列表"][i + 1], _____5355_4F4D, _____539F_56E0)
            i = i + 1
        end
    end
end
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype["取层数"] = function(self, ID, _____5355_4F4D)
    local _____63A7_5236_5668 = self["控制器表"][ID]
    return _____63A7_5236_5668 == nil and 0 or _____63A7_5236_5668["取层数"](_____63A7_5236_5668, _____5355_4F4D)
end
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype["取最高层数"] = function(self, _____5355_4F4D)
    local _____6700_9AD8ID = ""
    local _____6700_9AD8_5C42_6570 = 0
    do
        local i = 0
        while i < #self["ID列表"] do
            local ID = self["ID列表"][i + 1]
            local _____5C42_6570 = self["取层数"](self, ID, _____5355_4F4D)
            if _____5C42_6570 > _____6700_9AD8_5C42_6570 then
                _____6700_9AD8ID = ID
                _____6700_9AD8_5C42_6570 = _____5C42_6570
            end
            i = i + 1
        end
    end
    return {ID = _____6700_9AD8ID, ["层数"] = _____6700_9AD8_5C42_6570}
end
____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0.prototype["销毁"] = function(self)
    do
        local i = 0
        while i < #self["ID列表"] do
            local ID = self["ID列表"][i + 1]
            local _____63A7_5236_5668 = self["控制器表"][ID]
            if _____63A7_5236_5668 ~= nil then
                _____63A7_5236_5668["销毁"](_____63A7_5236_5668)
            end
            self["控制器表"][ID] = nil
            i = i + 1
        end
    end
    self["ID列表"] = {}
end
____exports["创建Boss层数状态集"] = function(_____5B9A_4E49_5217_8868)
    return __TS__New(____Boss_5C42_6570_72B6_6001_96C6_5B9E_73B0, _____5B9A_4E49_5217_8868)
end
return ____exports
