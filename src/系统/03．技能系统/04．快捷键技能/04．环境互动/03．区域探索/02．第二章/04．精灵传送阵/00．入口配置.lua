local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_1["解析配置内部ID"]
local ____require_result_2 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_2["创建物品并注册排泄监听"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitAddItem = jass.UnitAddItem
local _____679C_5B50_7269_54C1ID = "伊达之果#I03W"
local _____7CBE_7075_5C0F_5C4B_63D0_793A_6587_672C = "意外发现了某处能进入的精灵小屋，命中率+1%。"
local _____7A7A_6728_6869_63D0_793A_6587_672C = "意外发现了藏在空木桩里的果子。"
local _____6811_4E0A_7269_54C1_63D0_793A_6587_672C = "意外发现了藏在树上的果子。"
local function _____521B_5EFA_5E76_7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, _____7269_54C1ID)
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____7269_54C1ID),
        GetUnitX(_____65BD_6CD5_5355_4F4D),
        GetUnitY(_____65BD_6CD5_5355_4F4D)
    )
    if _____7269_54C1 ~= nil and _____7269_54C1 ~= 0 then
        UnitAddItem(_____65BD_6CD5_5355_4F4D, _____7269_54C1)
    end
end
local function _____5904_7406_7CBE_7075_5C0F_5C4B_8C03_67E5(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local ____ = _____8C03_67E5_70B9
    local _____73A9_5BB6 = jass.GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    local _____5F53_524D_547D_4E2D = __TS__Number(YDUserDataGetSafe("player", _____73A9_5BB6, "命中率", "real")) or 0
    YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        "命中率",
        "real",
        _____5F53_524D_547D_4E2D + 0.01
    )
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____7CBE_7075_5C0F_5C4B_63D0_793A_6587_672C, 3000)
    return true
end
local function _____5904_7406_7A7A_6728_6869_8C03_67E5(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local ____ = _____8C03_67E5_70B9
    _____521B_5EFA_5E76_7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, _____679C_5B50_7269_54C1ID)
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____7A7A_6728_6869_63D0_793A_6587_672C, 3000)
    return true
end
local function _____5904_7406_6811_4E0A_7269_54C1_8C03_67E5(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local ____ = _____8C03_67E5_70B9
    _____521B_5EFA_5E76_7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, _____679C_5B50_7269_54C1ID)
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____6811_4E0A_7269_54C1_63D0_793A_6587_672C, 3000)
    return true
end
--- 注册精灵传送阵的常驻环境互动探索点。
____exports["注册精灵传送阵探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵传送阵.精灵小屋",
        X = -20745.7,
        Y = -15044.7,
        ["触发范围"] = 250,
        ["一次性"] = false,
        ["触发回调"] = _____5904_7406_7CBE_7075_5C0F_5C4B_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵传送阵.空木桩",
        X = -19529.4,
        Y = -14869.6,
        ["触发范围"] = 250,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_7A7A_6728_6869_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵传送阵.树上物品",
        X = -17832,
        Y = -14822.9,
        ["触发范围"] = 250,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_6811_4E0A_7269_54C1_8C03_67E5
    })
end
return ____exports
