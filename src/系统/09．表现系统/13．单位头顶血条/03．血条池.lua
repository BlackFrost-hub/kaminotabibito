--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF = require("系统.09．表现系统.13．单位头顶血条.00．常量")
local _____8840_6761_5C3A_5BF8 = ____00_FF0E_5E38_91CF["血条尺寸"]
local ____02_FF0E_5E27_521B_5EFA = require("系统.09．表现系统.13．单位头顶血条.02．帧创建")
local _____521B_5EFA_5355_4F4D_8840_6761_5E27_7EC4 = ____02_FF0E_5E27_521B_5EFA["创建单位血条帧组"]
local japi = require("jass.japi")
local DzFrameShow = japi.DzFrameShow
local DzFrameUnBind = japi.DzFrameUnBind
local _____7A7A_95F2_5E27_7EC4 = {}
local _____5DF2_521B_5EFA_6570_91CF = 0
local _____5F53_524D_5BB9_91CF = _____8840_6761_5C3A_5BF8["初始血条容量"]
local function _____9690_85CF_5E27_7EC4(_____5E27)
    DzFrameShow(_____5E27.root, false)
end
____exports["取单位血条帧组"] = function()
    local reused = table.remove(_____7A7A_95F2_5E27_7EC4)
    if reused ~= nil then
        return reused
    end
    if _____5DF2_521B_5EFA_6570_91CF >= _____5F53_524D_5BB9_91CF then
        _____5F53_524D_5BB9_91CF = _____5F53_524D_5BB9_91CF + _____8840_6761_5C3A_5BF8["血条容量扩展步长"]
    end
    _____5DF2_521B_5EFA_6570_91CF = _____5DF2_521B_5EFA_6570_91CF + 1
    return _____521B_5EFA_5355_4F4D_8840_6761_5E27_7EC4(_____5DF2_521B_5EFA_6570_91CF)
end
____exports["回收单位血条帧组"] = function(_____5E27)
    if _____5E27 == nil or _____5E27.root == 0 then
        return
    end
    DzFrameUnBind(_____5E27.root)
    _____9690_85CF_5E27_7EC4(_____5E27)
    _____7A7A_95F2_5E27_7EC4[#_____7A7A_95F2_5E27_7EC4 + 1] = _____5E27
end
return ____exports
