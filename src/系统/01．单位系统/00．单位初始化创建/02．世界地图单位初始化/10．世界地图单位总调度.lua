local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_6742_9C7C_51FA_751F_914D_7F6E = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.01．杂鱼出生配置")
local _____4E16_754C_5730_56FE_6742_9C7C_51FA_751F_914D_7F6E_8868 = ____01_FF0E_6742_9C7C_51FA_751F_914D_7F6E["世界地图杂鱼出生配置表"]
local _____4E16_754C_5730_56FE_6742_9C7C_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879 = ____01_FF0E_6742_9C7C_51FA_751F_914D_7F6E["世界地图杂鱼默认缓步创建选项"]
local ____02_FF0E_7CBE_82F1_51FA_751F_914D_7F6E = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.02．精英出生配置")
local _____4E16_754C_5730_56FE_7CBE_82F1_51FA_751F_914D_7F6E_8868 = ____02_FF0E_7CBE_82F1_51FA_751F_914D_7F6E["世界地图精英出生配置表"]
local _____4E16_754C_5730_56FE_7CBE_82F1_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879 = ____02_FF0E_7CBE_82F1_51FA_751F_914D_7F6E["世界地图精英默认缓步创建选项"]
local ____03_FF0E_8DEF_4EBANPC_51FA_751F_914D_7F6E = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.03．路人NPC出生配置")
local _____8DEF_4EBANPC_51FA_751F_914D_7F6E_8868 = ____03_FF0E_8DEF_4EBANPC_51FA_751F_914D_7F6E["路人NPC出生配置表"]
local _____8DEF_4EBANPC_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879 = ____03_FF0E_8DEF_4EBANPC_51FA_751F_914D_7F6E["路人NPC默认缓步创建选项"]
local ____04_FF0E_5546_4EBA_51FA_751F_914D_7F6E = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.04．商人出生配置")
local _____4E16_754C_5730_56FE_5546_4EBA_51FA_751F_914D_7F6E_8868 = ____04_FF0E_5546_4EBA_51FA_751F_914D_7F6E["世界地图商人出生配置表"]
local _____4E16_754C_5730_56FE_5546_4EBA_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879 = ____04_FF0E_5546_4EBA_51FA_751F_914D_7F6E["世界地图商人默认缓步创建选项"]
local ____20_FF0E_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.20．世界地图单位缓步创建")
local _____83B7_53D6_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA_4EFB_52A1_72B6_6001 = ____20_FF0E_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA["获取世界地图单位缓步创建任务状态"]
local _____542F_52A8_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA_4EFB_52A1 = ____20_FF0E_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA["启动世界地图单位缓步创建任务"]
local _____505C_6B62_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA_4EFB_52A1 = ____20_FF0E_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA["停止世界地图单位缓步创建任务"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local R2I = jass.R2I
local _____7A7A_72B6_6001 = {
    ["当前阶段"] = "未启动",
    ["是否运行中"] = false,
    ["杂鱼总数"] = #_____4E16_754C_5730_56FE_6742_9C7C_51FA_751F_914D_7F6E_8868,
    ["杂鱼已创建数"] = 0,
    ["精英总数"] = #_____4E16_754C_5730_56FE_7CBE_82F1_51FA_751F_914D_7F6E_8868,
    ["精英已创建数"] = 0,
    ["NPC总数"] = #_____8DEF_4EBANPC_51FA_751F_914D_7F6E_8868,
    ["NPC已创建数"] = 0,
    ["商人总数"] = #_____4E16_754C_5730_56FE_5546_4EBA_51FA_751F_914D_7F6E_8868,
    ["商人已创建数"] = 0
}
____exports["世界地图单位总调度默认选项"] = {["杂鱼选项"] = _____4E16_754C_5730_56FE_6742_9C7C_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879, ["精英选项"] = _____4E16_754C_5730_56FE_7CBE_82F1_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879, ["路人NPC选项"] = _____8DEF_4EBANPC_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879, ["监视间隔秒"] = 0.1}
local _____5F53_524D_72B6_6001 = __TS__ObjectAssign({}, _____7A7A_72B6_6001)
local _____5F53_524D_6742_9C7C_4EFB_52A1ID
local _____5F53_524D_7CBE_82F1_4EFB_52A1ID
local _____5F53_524D_8DEF_4EBANPC_4EFB_52A1ID
local _____5F53_524D_5546_4EBA_4EFB_52A1ID
local _____76D1_89C6_56DE_8C03ID
local _____7CBE_82F1_5DF2_542F_52A8 = false
local _____8DEF_4EBANPC_5DF2_542F_52A8 = false
local _____5546_4EBA_5DF2_542F_52A8 = false
local _____6742_9C7C_5DF2_5B8C_6210 = false
local _____7CBE_82F1_5DF2_5B8C_6210 = false
local _____8DEF_4EBANPC_5DF2_5B8C_6210 = false
local _____5546_4EBA_5DF2_5B8C_6210 = false
local _____5168_90E8_521B_5EFA_5B8C_6210_56DE_8C03
local _____5168_90E8_521B_5EFA_5B8C_6210_56DE_8C03_5DF2_89E6_53D1 = false
local _____5F53_524D_7CBE_82F1_9009_9879
local _____5F53_524D_8DEF_4EBANPC_9009_9879
local _____5F53_524D_5546_4EBA_9009_9879
local function _____521B_5EFA_72B6_6001_526F_672C()
    return __TS__ObjectAssign({}, _____5F53_524D_72B6_6001)
end
local function _____91CD_7F6E_603B_8C03_5EA6()
    _____5F53_524D_72B6_6001 = __TS__ObjectAssign({}, _____7A7A_72B6_6001)
    _____5F53_524D_6742_9C7C_4EFB_52A1ID = nil
    _____5F53_524D_7CBE_82F1_4EFB_52A1ID = nil
    _____5F53_524D_8DEF_4EBANPC_4EFB_52A1ID = nil
    _____5F53_524D_5546_4EBA_4EFB_52A1ID = nil
    _____7CBE_82F1_5DF2_542F_52A8 = false
    _____8DEF_4EBANPC_5DF2_542F_52A8 = false
    _____5546_4EBA_5DF2_542F_52A8 = false
    _____6742_9C7C_5DF2_5B8C_6210 = false
    _____7CBE_82F1_5DF2_5B8C_6210 = false
    _____8DEF_4EBANPC_5DF2_5B8C_6210 = false
    _____5546_4EBA_5DF2_5B8C_6210 = false
    _____5168_90E8_521B_5EFA_5B8C_6210_56DE_8C03 = nil
    _____5168_90E8_521B_5EFA_5B8C_6210_56DE_8C03_5DF2_89E6_53D1 = false
    _____5F53_524D_7CBE_82F1_9009_9879 = nil
    _____5F53_524D_8DEF_4EBANPC_9009_9879 = nil
    _____5F53_524D_5546_4EBA_9009_9879 = nil
end
local function _____505C_6B62_603B_8C03_5EA6_76D1_89C6()
    if _____76D1_89C6_56DE_8C03ID == nil then
        return
    end
    removePeriodicCallback(_____76D1_89C6_56DE_8C03ID)
    _____76D1_89C6_56DE_8C03ID = nil
end
local function _____505C_6B62_4EFB_52A1(_____4EFB_52A1ID)
    if _____4EFB_52A1ID == nil then
        return
    end
    _____505C_6B62_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA_4EFB_52A1(_____4EFB_52A1ID)
end
local function _____8BFB_53D6_4EFB_52A1_72B6_6001(_____4EFB_52A1ID)
    if _____4EFB_52A1ID == nil then
        return nil
    end
    return _____83B7_53D6_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA_4EFB_52A1_72B6_6001(_____4EFB_52A1ID)
end
local function _____5237_65B0_5355_4E2A_4EFB_52A1_8FDB_5EA6(_____4EFB_52A1ID, _____603B_6570, _____5199_5165_51FD_6570)
    local _____72B6_6001 = _____8BFB_53D6_4EFB_52A1_72B6_6001(_____4EFB_52A1ID)
    if _____72B6_6001 == nil then
        return
    end
    if _____72B6_6001["总数"] <= 0 and _____72B6_6001["运行中"] ~= true then
        return
    end
    _____5199_5165_51FD_6570(_____72B6_6001["已创建数量"] > _____603B_6570 and _____603B_6570 or _____72B6_6001["已创建数量"])
end
local function _____5199_5165_6742_9C7C_5DF2_521B_5EFA_6570(value)
    _____5F53_524D_72B6_6001["杂鱼已创建数"] = value
end
local function _____5199_5165_7CBE_82F1_5DF2_521B_5EFA_6570(value)
    _____5F53_524D_72B6_6001["精英已创建数"] = value
end
local function _____5199_5165_8DEF_4EBANPC_5DF2_521B_5EFA_6570(value)
    _____5F53_524D_72B6_6001["NPC已创建数"] = value
end
local function _____5199_5165_5546_4EBA_5DF2_521B_5EFA_6570(value)
    _____5F53_524D_72B6_6001["商人已创建数"] = value
end
local function _____6742_9C7C_5B8C_6210_56DE_8C03(_____5DF2_521B_5EFA_6570_91CF)
    _____6742_9C7C_5DF2_5B8C_6210 = true
    _____5F53_524D_6742_9C7C_4EFB_52A1ID = nil
    _____5F53_524D_72B6_6001["杂鱼已创建数"] = _____5DF2_521B_5EFA_6570_91CF
end
local function _____7CBE_82F1_5B8C_6210_56DE_8C03(_____5DF2_521B_5EFA_6570_91CF)
    _____7CBE_82F1_5DF2_5B8C_6210 = true
    _____5F53_524D_7CBE_82F1_4EFB_52A1ID = nil
    _____5F53_524D_72B6_6001["精英已创建数"] = _____5DF2_521B_5EFA_6570_91CF
end
local function _____8DEF_4EBANPC_5B8C_6210_56DE_8C03(_____5DF2_521B_5EFA_6570_91CF)
    _____8DEF_4EBANPC_5DF2_5B8C_6210 = true
    _____5F53_524D_8DEF_4EBANPC_4EFB_52A1ID = nil
    _____5F53_524D_72B6_6001["NPC已创建数"] = _____5DF2_521B_5EFA_6570_91CF
end
local function _____5546_4EBA_5B8C_6210_56DE_8C03(_____5DF2_521B_5EFA_6570_91CF)
    _____5546_4EBA_5DF2_5B8C_6210 = true
    _____5F53_524D_5546_4EBA_4EFB_52A1ID = nil
    _____5F53_524D_72B6_6001["商人已创建数"] = _____5DF2_521B_5EFA_6570_91CF
end
local function _____542F_52A8_7CBE_82F1_9636_6BB5()
    if _____7CBE_82F1_5DF2_542F_52A8 then
        return
    end
    _____7CBE_82F1_5DF2_542F_52A8 = true
    _____5F53_524D_72B6_6001["当前阶段"] = "杂鱼+精英"
    _____5F53_524D_7CBE_82F1_4EFB_52A1ID = _____542F_52A8_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA_4EFB_52A1(
        _____4E16_754C_5730_56FE_7CBE_82F1_51FA_751F_914D_7F6E_8868,
        __TS__ObjectAssign({}, _____4E16_754C_5730_56FE_7CBE_82F1_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879, _____5F53_524D_7CBE_82F1_9009_9879, {["完成回调"] = _____7CBE_82F1_5B8C_6210_56DE_8C03})
    )
end
local function _____542F_52A8_8DEF_4EBANPC_9636_6BB5()
    if _____8DEF_4EBANPC_5DF2_542F_52A8 then
        return
    end
    _____8DEF_4EBANPC_5DF2_542F_52A8 = true
    _____5F53_524D_72B6_6001["当前阶段"] = "NPC"
    _____5F53_524D_8DEF_4EBANPC_4EFB_52A1ID = _____542F_52A8_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA_4EFB_52A1(
        _____8DEF_4EBANPC_51FA_751F_914D_7F6E_8868,
        __TS__ObjectAssign({}, _____8DEF_4EBANPC_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879, _____5F53_524D_8DEF_4EBANPC_9009_9879, {["完成回调"] = _____8DEF_4EBANPC_5B8C_6210_56DE_8C03})
    )
end
local function _____542F_52A8_5546_4EBA_9636_6BB5()
    if _____5546_4EBA_5DF2_542F_52A8 then
        return
    end
    _____5546_4EBA_5DF2_542F_52A8 = true
    _____5F53_524D_72B6_6001["当前阶段"] = "商人"
    _____5F53_524D_5546_4EBA_4EFB_52A1ID = _____542F_52A8_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA_4EFB_52A1(
        _____4E16_754C_5730_56FE_5546_4EBA_51FA_751F_914D_7F6E_8868,
        __TS__ObjectAssign({}, _____4E16_754C_5730_56FE_5546_4EBA_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879, _____5F53_524D_5546_4EBA_9009_9879, {["完成回调"] = _____5546_4EBA_5B8C_6210_56DE_8C03})
    )
end
local function _____5237_65B0_5168_90E8_8FDB_5EA6()
    _____5237_65B0_5355_4E2A_4EFB_52A1_8FDB_5EA6(_____5F53_524D_6742_9C7C_4EFB_52A1ID, _____5F53_524D_72B6_6001["杂鱼总数"], _____5199_5165_6742_9C7C_5DF2_521B_5EFA_6570)
    _____5237_65B0_5355_4E2A_4EFB_52A1_8FDB_5EA6(_____5F53_524D_7CBE_82F1_4EFB_52A1ID, _____5F53_524D_72B6_6001["精英总数"], _____5199_5165_7CBE_82F1_5DF2_521B_5EFA_6570)
    _____5237_65B0_5355_4E2A_4EFB_52A1_8FDB_5EA6(_____5F53_524D_8DEF_4EBANPC_4EFB_52A1ID, _____5F53_524D_72B6_6001["NPC总数"], _____5199_5165_8DEF_4EBANPC_5DF2_521B_5EFA_6570)
    _____5237_65B0_5355_4E2A_4EFB_52A1_8FDB_5EA6(_____5F53_524D_5546_4EBA_4EFB_52A1ID, _____5F53_524D_72B6_6001["商人总数"], _____5199_5165_5546_4EBA_5DF2_521B_5EFA_6570)
end
local function _____6742_9C7C_5DF2_8FDB_5165_6700_540E_4E8C_6210()
    if _____5F53_524D_72B6_6001["杂鱼总数"] <= 0 then
        return true
    end
    if _____6742_9C7C_5DF2_5B8C_6210 then
        return true
    end
    local _____72B6_6001 = _____8BFB_53D6_4EFB_52A1_72B6_6001(_____5F53_524D_6742_9C7C_4EFB_52A1ID)
    if _____72B6_6001 == nil or _____72B6_6001["总数"] <= 0 then
        return false
    end
    return _____72B6_6001["当前索引"] * 5 >= _____72B6_6001["总数"] * 4
end
local function _____5168_90E8_5B8C_6210()
    return _____6742_9C7C_5DF2_5B8C_6210 and _____7CBE_82F1_5DF2_5B8C_6210 and _____8DEF_4EBANPC_5DF2_5B8C_6210 and _____5546_4EBA_5DF2_5B8C_6210
end
local function _____603B_8C03_5EA6_76D1_89C6_56DE_8C03()
    if _____5F53_524D_72B6_6001["是否运行中"] ~= true then
        _____505C_6B62_603B_8C03_5EA6_76D1_89C6()
        return
    end
    _____5237_65B0_5168_90E8_8FDB_5EA6()
    if not _____7CBE_82F1_5DF2_542F_52A8 and _____6742_9C7C_5DF2_8FDB_5165_6700_540E_4E8C_6210() then
        _____542F_52A8_7CBE_82F1_9636_6BB5()
    end
    if not _____8DEF_4EBANPC_5DF2_542F_52A8 and _____7CBE_82F1_5DF2_5B8C_6210 then
        _____542F_52A8_8DEF_4EBANPC_9636_6BB5()
    end
    if not _____5546_4EBA_5DF2_542F_52A8 and _____8DEF_4EBANPC_5DF2_5B8C_6210 then
        _____542F_52A8_5546_4EBA_9636_6BB5()
    end
    if _____5168_90E8_5B8C_6210() then
        _____5F53_524D_72B6_6001["当前阶段"] = "完成"
        _____5F53_524D_72B6_6001["是否运行中"] = false
        _____505C_6B62_603B_8C03_5EA6_76D1_89C6()
        if not _____5168_90E8_521B_5EFA_5B8C_6210_56DE_8C03_5DF2_89E6_53D1 then
            _____5168_90E8_521B_5EFA_5B8C_6210_56DE_8C03_5DF2_89E6_53D1 = true
            local _____5B8C_6210_56DE_8C03 = _____5168_90E8_521B_5EFA_5B8C_6210_56DE_8C03
            _____5168_90E8_521B_5EFA_5B8C_6210_56DE_8C03 = nil
            if type(_____5B8C_6210_56DE_8C03) == "function" then
                _____5B8C_6210_56DE_8C03()
            end
        end
    end
end
local function _____542F_52A8_603B_8C03_5EA6_76D1_89C6(_____95F4_9694_79D2)
    _____505C_6B62_603B_8C03_5EA6_76D1_89C6()
    local _____95F4_9694_6BEB_79D2 = _____95F4_9694_79D2 <= 0 and 100 or R2I(_____95F4_9694_79D2 * 1000)
    _____76D1_89C6_56DE_8C03ID = addPeriodicCallback(_____95F4_9694_6BEB_79D2, _____603B_8C03_5EA6_76D1_89C6_56DE_8C03)
end
____exports["获取世界地图全部单位创建状态"] = function()
    return _____521B_5EFA_72B6_6001_526F_672C()
end
____exports["停止世界地图全部单位缓步创建"] = function()
    _____505C_6B62_603B_8C03_5EA6_76D1_89C6()
    _____505C_6B62_4EFB_52A1(_____5F53_524D_6742_9C7C_4EFB_52A1ID)
    _____505C_6B62_4EFB_52A1(_____5F53_524D_7CBE_82F1_4EFB_52A1ID)
    _____505C_6B62_4EFB_52A1(_____5F53_524D_8DEF_4EBANPC_4EFB_52A1ID)
    _____505C_6B62_4EFB_52A1(_____5F53_524D_5546_4EBA_4EFB_52A1ID)
    _____5F53_524D_72B6_6001["是否运行中"] = false
end
____exports["启动世界地图全部单位缓步创建"] = function(_____9009_9879)
    local _____5DF2_5408_5E76_9009_9879 = __TS__ObjectAssign({}, ____exports["世界地图单位总调度默认选项"], _____9009_9879)
    ____exports["停止世界地图全部单位缓步创建"]()
    _____91CD_7F6E_603B_8C03_5EA6()
    _____5F53_524D_72B6_6001["是否运行中"] = true
    _____5F53_524D_72B6_6001["当前阶段"] = "杂鱼"
    _____5168_90E8_521B_5EFA_5B8C_6210_56DE_8C03 = _____5DF2_5408_5E76_9009_9879["完成回调"]
    _____5F53_524D_7CBE_82F1_9009_9879 = _____5DF2_5408_5E76_9009_9879["精英选项"]
    _____5F53_524D_8DEF_4EBANPC_9009_9879 = _____5DF2_5408_5E76_9009_9879["路人NPC选项"]
    _____5F53_524D_5546_4EBA_9009_9879 = _____5DF2_5408_5E76_9009_9879["商人选项"]
    _____5F53_524D_6742_9C7C_4EFB_52A1ID = _____542F_52A8_4E16_754C_5730_56FE_5355_4F4D_7F13_6B65_521B_5EFA_4EFB_52A1(
        _____4E16_754C_5730_56FE_6742_9C7C_51FA_751F_914D_7F6E_8868,
        __TS__ObjectAssign({}, _____4E16_754C_5730_56FE_6742_9C7C_9ED8_8BA4_7F13_6B65_521B_5EFA_9009_9879, _____5DF2_5408_5E76_9009_9879["杂鱼选项"], {["完成回调"] = _____6742_9C7C_5B8C_6210_56DE_8C03})
    )
    if _____5F53_524D_72B6_6001["精英总数"] <= 0 then
        _____7CBE_82F1_5DF2_5B8C_6210 = true
    end
    if _____5F53_524D_72B6_6001["NPC总数"] <= 0 then
        _____8DEF_4EBANPC_5DF2_5B8C_6210 = true
    end
    if _____5F53_524D_72B6_6001["商人总数"] <= 0 then
        _____5546_4EBA_5DF2_5B8C_6210 = true
    end
    _____542F_52A8_603B_8C03_5EA6_76D1_89C6(_____5DF2_5408_5E76_9009_9879["监视间隔秒"] or 0.1)
    return _____521B_5EFA_72B6_6001_526F_672C()
end
return ____exports
