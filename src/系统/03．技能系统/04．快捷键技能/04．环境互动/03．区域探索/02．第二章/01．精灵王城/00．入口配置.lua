--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置")
local _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387 = ____require_result_1["环境互动装备奖励概率"]
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_2["按名字反查物品ID"]
local ____require_result_3 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_3["解析配置内部ID"]
local ____require_result_4 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_4["创建物品并注册排泄监听"]
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_5["发送单位提示给玩家"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_6["调整玩家属性"]
local Player = jass.Player
local GetPlayerState = jass.GetPlayerState
local SetPlayerState = jass.SetPlayerState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitAddItem = jass.UnitAddItem
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local GetHeroInt = jass.GetHeroInt
local SetHeroInt = jass.SetHeroInt
local PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
local PLAYER_STATE_RESOURCE_LUMBER = jass.PLAYER_STATE_RESOURCE_LUMBER
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local _____738B_57CE_63A2_7D22_63D0_793A_6301_7EED_6BEB_79D2 = 5200
local function _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6, _____72B6_6001, _____6570_91CF)
    local _____5F53_524D_6570_91CF = GetPlayerState(_____73A9_5BB6, _____72B6_6001)
    SetPlayerState(_____73A9_5BB6, _____72B6_6001, _____5F53_524D_6570_91CF + _____6570_91CF)
end
local function _____7ED9_4E88_63A2_7D22_7269_54C1(_____5355_4F4D, _____7269_54C1_540D)
    local _____7269_54C1ID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D)
    if _____7269_54C1ID == nil then
        return false
    end
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____7269_54C1ID),
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    )
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    UnitAddItem(_____5355_4F4D, _____7269_54C1)
    return true
end
local function _____5904_7406_57CE_5899_65E7_68B0_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD, 10000)
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6, PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, "|cffffcc00『城墙旧械』：|r这架城防器械的锁扣留有新鲜磨痕，受力方向却来自城内。有人曾绕过守卫，从内侧动过它。你在夹层中找到一袋遗落的钱币和一枚能量碎片。|n|cffffff00获得10000金币、1能量碎片。|r", _____738B_57CE_63A2_7D22_63D0_793A_6301_7EED_6BEB_79D2)
    return true
end
local function _____5904_7406_82B1_5703_82B1_724C_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    if not _____7ED9_4E88_63A2_7D22_7269_54C1(_____65BD_6CD5_5355_4F4D, "月影花") then
        return false
    end
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD, 5000)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, "|cffccffff『王城花圃』：|r泥土里压着一块折断的园丁花牌。背面的交接日期被人匆忙刮去，花圃似乎曾在无人知晓的时段换过看守。花牌旁还有一朵保存完好的月影花。|n|cffffff00获得5000金币、1朵月影花。|r", _____738B_57CE_63A2_7D22_63D0_793A_6301_7EED_6BEB_79D2)
    return true
end
local function _____5904_7406_53E4_6811_796D_575B_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    SetHeroInt(
        _____65BD_6CD5_5355_4F4D,
        GetHeroInt(_____65BD_6CD5_5355_4F4D, false) + 2,
        true
    )
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, "|cff99ff99『古树祭坛回响』：|r发光符文中的灵力并非自然消散，而是被某种力量从中途切断。残存的回响沿着掌心融入意识，也让你记住了这条异常的灵力流向。|n|cffffff00永久智力+2。|r", _____738B_57CE_63A2_7D22_63D0_793A_6301_7EED_6BEB_79D2)
    return true
end
local function _____5904_7406_738B_5EAD_5723_6CC9_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    if not _____7ED9_4E88_63A2_7D22_7269_54C1(_____65BD_6CD5_5355_4F4D, "精灵王城三花灵药") then
        return false
    end
    SetUnitState(
        _____65BD_6CD5_5355_4F4D,
        UNIT_STATE_LIFE,
        GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MAX_LIFE)
    )
    SetUnitState(
        _____65BD_6CD5_5355_4F4D,
        UNIT_STATE_MANA,
        GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MAX_MANA)
    )
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, "|cffccffff『王庭圣泉』：|r指尖触及水面的瞬间，一缕黑色异痕从泉底掠过，随即被重新涌出的清流冲散。泉水恢复纯净，池沿的精灵灵药也重新显露出来。|n|cffffff00生命与魔法完全恢复；获得1瓶精灵王城三花灵药。|r", _____738B_57CE_63A2_7D22_63D0_793A_6301_7EED_6BEB_79D2)
    return true
end
local function _____5904_7406_4E66_623F_65E7_6863_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    if not _____7ED9_4E88_63A2_7D22_7269_54C1(_____65BD_6CD5_5355_4F4D, "封印旧档书签") then
        return false
    end
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, "|cffccffff『书房旧档』：|r书架底层藏着一份被拆散的旧档。“西利乌斯”与“自愿封印”仍能从残页中辨认出来，但最关键的署名已被撕去。夹在档案中的书签仍封存着一缕旧日秘术。|n|cffffff00获得封印旧档书签。|r", _____738B_57CE_63A2_7D22_63D0_793A_6301_7EED_6BEB_79D2)
    return true
end
local function _____5904_7406_8BAE_4E8B_5385_6B8B_5377_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "暴击率", 0.02)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "命中率", 0.05)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, "|cffffcc99『议事厅残卷』：|r城西巡逻路线并非遗漏，而是被人刻意留出了一段空白。沿着残卷上的调度规律推演，你找到了守卫视线交替时最容易被忽略的间隙。|n|cffffff00永久暴击率+2%、命中率+5%。|r", _____738B_57CE_63A2_7D22_63D0_793A_6301_7EED_6BEB_79D2)
    return true
end
local function _____5904_7406_738B_5EAD_8A93_65D7_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    if not _____7ED9_4E88_63A2_7D22_7269_54C1(_____65BD_6CD5_5355_4F4D, "王庭旧誓徽章") then
        return false
    end
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, "|cff99ccff『王庭誓旗』：|r褪色的誓文仍清晰写着：灾厄来临时，王庭卫队应先护送平民撤离，而非固守王宫。旗座内留存的旧徽章见证过这道命令。|n|cffffff00获得王庭旧誓徽章。|r", _____738B_57CE_63A2_7D22_63D0_793A_6301_7EED_6BEB_79D2)
    return true
end
--- 注册精灵王城的世界级一次性探索点；首次成功触发后由核心立即注销。
____exports["注册精灵王城探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵王城.城墙旧械",
        X = -15248.4,
        Y = -7513.1,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_57CE_5899_65E7_68B0_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵王城.花圃遗落花牌",
        X = -15566.2,
        Y = -7841,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_82B1_5703_82B1_724C_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵王城.古树祭坛回响",
        X = -8794.7,
        Y = -8694,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_53E4_6811_796D_575B_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵王城.王庭圣泉",
        X = -4483.8,
        Y = -7045.8,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_738B_5EAD_5723_6CC9_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵王城.书房旧档",
        X = 14301.1,
        Y = -22922.7,
        ["一次性"] = true,
        ["一次性奖励概率"] = _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387,
        ["触发回调"] = _____5904_7406_4E66_623F_65E7_6863_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵王城.议事厅残卷",
        X = 12939.1,
        Y = -24109.9,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_8BAE_4E8B_5385_6B8B_5377_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "精灵王城.王庭誓旗",
        X = 17804.7,
        Y = -23856.4,
        ["一次性"] = true,
        ["一次性奖励概率"] = _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387,
        ["触发回调"] = _____5904_7406_738B_5EAD_8A93_65D7_8C03_67E5
    })
end
return ____exports
