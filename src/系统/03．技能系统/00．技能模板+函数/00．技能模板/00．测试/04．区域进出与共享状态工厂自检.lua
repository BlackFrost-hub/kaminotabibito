--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____05_FF0E_533A_57DF_8FDB_51FA_4E0E_5171_4EAB_72B6_6001_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.05．区域进出与共享状态工厂")
local _____521B_5EFA_533A_57DF_8FDB_51FA = ____05_FF0E_533A_57DF_8FDB_51FA_4E0E_5171_4EAB_72B6_6001_5DE5_5382["创建区域进出"]
local jass = require("jass.common")
local Player = jass.Player
local CreateUnit = jass.CreateUnit
local SetUnitPosition = jass.SetUnitPosition
local KillUnit = jass.KillUnit
local function _____7A7A_8F93_51FA(______6D88_606F)
end
local ____print = jass.print or _____7A7A_8F93_51FA
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local _____519C_6C11_5355_4F4D_7C7B_578B = stringToFourCCSafe("hpea")
local _____4E8B_4EF6_65E5_5FD7 = {}
local function _____8BB0_5F55(_____4E8B_4EF6)
    _____4E8B_4EF6_65E5_5FD7[#_____4E8B_4EF6_65E5_5FD7 + 1] = _____4E8B_4EF6
    ____print("[H-02自检] " .. _____4E8B_4EF6)
end
local function _____65AD_8A00(_____6761_4EF6, _____6D88_606F)
    ____print(("[H-02自检] " .. (_____6761_4EF6 and "通过: " or "失败: ")) .. _____6D88_606F)
end
____exports["运行H02自检"] = function()
    local _____76EE_6807A = CreateUnit(
        Player(1),
        _____519C_6C11_5355_4F4D_7C7B_578B,
        100,
        0,
        0
    )
    local _____533A_57DF1 = _____521B_5EFA_533A_57DF_8FDB_51FA({
        ["名称"] = "H02-区域1",
        ["中心"] = {["类型"] = "固定", X = 0, Y = 0},
        ["半径"] = 300,
        ["Tick间隔毫秒"] = 100,
        ["目标源"] = function()
            return {_____76EE_6807A}
        end,
        ["on进入"] = function(______76EE_6807)
            _____8BB0_5F55("区域1-进入")
        end,
        ["on停留"] = function(______76EE_6807)
            _____8BB0_5F55("区域1-停留")
        end,
        ["on离开"] = function(______76EE_6807)
            _____8BB0_5F55("区域1-离开")
        end
    })
    local _____533A_57DF2 = _____521B_5EFA_533A_57DF_8FDB_51FA({
        ["名称"] = "H02-区域2",
        ["中心"] = {["类型"] = "固定", X = 100, Y = 0},
        ["半径"] = 300,
        ["Tick间隔毫秒"] = 100,
        ["目标源"] = function()
            return {_____76EE_6807A}
        end,
        ["共享键"] = "H02共享",
        ["on进入"] = function(______76EE_6807)
            _____8BB0_5F55("区域2-进入")
        end,
        ["on离开"] = function(______76EE_6807)
            _____8BB0_5F55("区域2-离开")
        end,
        ["on共享离开"] = function(______76EE_6807, _____952E)
            _____8BB0_5F55("共享归零-" .. _____952E)
        end
    })
    local _____533A_57DF3 = _____521B_5EFA_533A_57DF_8FDB_51FA({
        ["名称"] = "H02-区域3",
        ["中心"] = {["类型"] = "固定", X = -100, Y = 0},
        ["半径"] = 300,
        ["Tick间隔毫秒"] = 100,
        ["目标源"] = function()
            return {_____76EE_6807A}
        end,
        ["共享键"] = "H02共享",
        ["on进入"] = function(______76EE_6807)
            _____8BB0_5F55("区域3-进入")
        end,
        ["on离开"] = function(______76EE_6807)
            _____8BB0_5F55("区域3-离开")
        end,
        ["on共享离开"] = function(______76EE_6807, ______952E)
            _____8BB0_5F55("共享归零-再次")
        end
    })
    if _____533A_57DF1 == nil or _____533A_57DF2 == nil or _____533A_57DF3 == nil then
        ____print("[H-02自检] 区域参数非法，无法启动自检")
        return
    end
    addDelayedCallback(
        250,
        function()
            _____65AD_8A00(
                #_____533A_57DF1["取当前成员"]() == 1,
                "区域1进入1目标"
            )
            _____65AD_8A00(
                _____533A_57DF3["取共享计数"](_____76EE_6807A) == 2,
                "两共享区域覆盖同一目标计数=2"
            )
            _____533A_57DF2["销毁"]()
            addDelayedCallback(
                250,
                function()
                    _____65AD_8A00(
                        _____533A_57DF3["取共享计数"](_____76EE_6807A) == 1,
                        "区域2销毁后计数=1"
                    )
                    SetUnitPosition(_____76EE_6807A, 5000, 5000)
                    addDelayedCallback(
                        250,
                        function()
                            _____65AD_8A00(
                                #_____533A_57DF1["取当前成员"]() == 0,
                                "走出后区域1离开"
                            )
                            _____65AD_8A00(
                                _____533A_57DF3["取共享计数"](_____76EE_6807A) == 0,
                                "区域3离开后共享计数归零"
                            )
                            SetUnitPosition(_____76EE_6807A, 0, 0)
                            addDelayedCallback(
                                250,
                                function()
                                    KillUnit(_____76EE_6807A)
                                    addDelayedCallback(
                                        250,
                                        function()
                                            _____65AD_8A00(
                                                #_____533A_57DF1["取当前成员"]() == 0,
                                                "死亡强制离开"
                                            )
                                            local _____9500_6BC1_987A_5E8F = {}
                                            local _____9500_6BC1_76EE_68071 = CreateUnit(
                                                Player(1),
                                                _____519C_6C11_5355_4F4D_7C7B_578B,
                                                10,
                                                0,
                                                0
                                            )
                                            local _____9500_6BC1_76EE_68072 = CreateUnit(
                                                Player(1),
                                                _____519C_6C11_5355_4F4D_7C7B_578B,
                                                20,
                                                0,
                                                0
                                            )
                                            local _____533A_57DF4 = _____521B_5EFA_533A_57DF_8FDB_51FA({
                                                ["名称"] = "H02-区域4",
                                                ["中心"] = {["类型"] = "固定", X = 0, Y = 0},
                                                ["半径"] = 500,
                                                ["Tick间隔毫秒"] = 100,
                                                ["目标源"] = function()
                                                    return {_____9500_6BC1_76EE_68071, _____9500_6BC1_76EE_68072}
                                                end,
                                                ["on进入"] = function(_____76EE_6807)
                                                    _____9500_6BC1_987A_5E8F[#_____9500_6BC1_987A_5E8F + 1] = "进入"
                                                end,
                                                ["on离开"] = function(______76EE_6807)
                                                    _____9500_6BC1_987A_5E8F[#_____9500_6BC1_987A_5E8F + 1] = "离开"
                                                end
                                            })
                                            if _____533A_57DF4 == nil then
                                                ____print("[H-02自检] 区域4参数非法，无法完成销毁顺序自检")
                                                return
                                            end
                                            addDelayedCallback(
                                                250,
                                                function()
                                                    _____533A_57DF4["销毁"]()
                                                    addDelayedCallback(
                                                        100,
                                                        function()
                                                            _____65AD_8A00(#_____9500_6BC1_987A_5E8F == 4, "销毁时2目标全部离开（进入2+离开2）")
                                                            ____print("[H-02自检] 全部自检项执行完毕")
                                                        end
                                                    )
                                                end
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    )
end
return ____exports
