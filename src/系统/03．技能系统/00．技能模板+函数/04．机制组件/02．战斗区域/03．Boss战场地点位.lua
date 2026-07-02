local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_52A8_6001_77E9_5F62_533A_57DF_7EC4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.01．动态矩形区域组")
local _____53D6_52A8_6001_77E9_5F62_533A_57DF_4E2D_5FC3 = ____01_FF0E_52A8_6001_77E9_5F62_533A_57DF_7EC4["取动态矩形区域中心"]
local function _____8F6C_4E3A_70B9_4F4D(_____533A_57DF)
    local _____4E2D_5FC3 = _____53D6_52A8_6001_77E9_5F62_533A_57DF_4E2D_5FC3(_____533A_57DF)
    return {ID = _____533A_57DF["配置"].ID or _____533A_57DF["配置"]["名称"] or "", ["名称"] = _____533A_57DF["配置"]["名称"], X = _____4E2D_5FC3.x, Y = _____4E2D_5FC3.y}
end
local ____Boss_6218_573A_5730_70B9_4F4D_96C6_5B9E_73B0 = __TS__Class()
____Boss_6218_573A_5730_70B9_4F4D_96C6_5B9E_73B0.name = "Boss战场地点位集实现"
function ____Boss_6218_573A_5730_70B9_4F4D_96C6_5B9E_73B0.prototype.____constructor(self, _____533A_57DF_7EC4, _____56DE_9000X, _____56DE_9000Y)
    self["点位列表"] = {}
    if _____533A_57DF_7EC4 ~= nil then
        local _____533A_57DF_5217_8868 = _____533A_57DF_7EC4["区域列表"]
        do
            local i = 0
            while i < #_____533A_57DF_5217_8868 do
                local ____self__70B9_4F4D_5217_8868_0 = self["点位列表"]
                ____self__70B9_4F4D_5217_8868_0[#____self__70B9_4F4D_5217_8868_0 + 1] = _____8F6C_4E3A_70B9_4F4D(_____533A_57DF_5217_8868[i + 1])
                i = i + 1
            end
        end
    end
    self["中心点位"] = #self["点位列表"] > 0 and self["点位列表"][1] or ({ID = "fallback", ["名称"] = "回退点", X = _____56DE_9000X, Y = _____56DE_9000Y})
end
____Boss_6218_573A_5730_70B9_4F4D_96C6_5B9E_73B0.prototype["取中心"] = function(self)
    return self["中心点位"]
end
____Boss_6218_573A_5730_70B9_4F4D_96C6_5B9E_73B0.prototype["按ID取"] = function(self, ID)
    do
        local i = 0
        while i < #self["点位列表"] do
            if self["点位列表"][i + 1].ID == ID then
                return self["点位列表"][i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
____Boss_6218_573A_5730_70B9_4F4D_96C6_5B9E_73B0.prototype["按名称取"] = function(self, _____540D_79F0)
    do
        local i = 0
        while i < #self["点位列表"] do
            if self["点位列表"][i + 1]["名称"] == _____540D_79F0 then
                return self["点位列表"][i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
____Boss_6218_573A_5730_70B9_4F4D_96C6_5B9E_73B0.prototype["取全部"] = function(self)
    return self["点位列表"]
end
____exports["创建Boss战场地点位集"] = function(_____533A_57DF_7EC4, _____56DE_9000X, _____56DE_9000Y)
    return __TS__New(____Boss_6218_573A_5730_70B9_4F4D_96C6_5B9E_73B0, _____533A_57DF_7EC4, _____56DE_9000X, _____56DE_9000Y)
end
return ____exports
