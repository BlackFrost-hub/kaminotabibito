local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置")
local _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387 = ____require_result_1["环境互动装备奖励概率"]
local ____require_result_2 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_2["解析配置内部ID"]
local ____require_result_3 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_4.YDUserDataSetSafe
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_5["发送单位提示给玩家"]
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UnitAddItem = jass.UnitAddItem
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
--- 血坛奖励：攻击/续航向白嫖饰品，C+ 档。
local _____796D_8840_4E4B_76BF_7269_54C1ID = "I0G8"
--- 池底遗物奖励：均衡/守护向白嫖饰品，C+ 档。
local _____7956_5730_7EB9_7AE0_5FBD_8BB0_7269_54C1ID = "I0HH"
--- 灵泉单次恢复的生命与魔法值。
local _____7075_6CC9_6062_590D_91CF = 100
--- 灵泉永久祝福：满状态首次互动时写入玩家属性表。
local _____7075_6CC9_795D_798F_751F_547D_6062_590D = 10
local _____7075_6CC9_795D_798F_9B54_6CD5_6062_590D = 3
local _____7956_5730_63A2_7D22_70B9_63D0_793A_6301_7EED_6BEB_79D2 = 4500
--- 玩家ID -> 是否已领取灵泉永久祝福。
local _____7075_6CC9_795D_798F_5DF2_9886_53D6_8868 = {}
local function _____5355_4F4D_662F_5426_6EE1_8840_6EE1_84DD(_____5355_4F4D)
    return GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE) >= GetUnitState(_____5355_4F4D, UNIT_STATE_MAX_LIFE) - 0.5 and GetUnitState(_____5355_4F4D, UNIT_STATE_MANA) >= GetUnitState(_____5355_4F4D, UNIT_STATE_MAX_MANA) - 0.5
end
local function _____6062_590D_5355_4F4D_751F_547D_4E0E_9B54_6CD5(_____5355_4F4D, _____6062_590D_91CF)
    local _____76EE_6807_751F_547D = GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE) + _____6062_590D_91CF
    local _____6700_5927_751F_547D = GetUnitState(_____5355_4F4D, UNIT_STATE_MAX_LIFE)
    if _____76EE_6807_751F_547D < _____6700_5927_751F_547D then
        SetUnitState(_____5355_4F4D, UNIT_STATE_LIFE, _____76EE_6807_751F_547D)
    else
        SetUnitState(_____5355_4F4D, UNIT_STATE_LIFE, _____6700_5927_751F_547D)
    end
    local _____76EE_6807_9B54_6CD5 = GetUnitState(_____5355_4F4D, UNIT_STATE_MANA) + _____6062_590D_91CF
    local _____6700_5927_9B54_6CD5 = GetUnitState(_____5355_4F4D, UNIT_STATE_MAX_MANA)
    if _____76EE_6807_9B54_6CD5 < _____6700_5927_9B54_6CD5 then
        SetUnitState(_____5355_4F4D, UNIT_STATE_MANA, _____76EE_6807_9B54_6CD5)
    else
        SetUnitState(_____5355_4F4D, UNIT_STATE_MANA, _____6700_5927_9B54_6CD5)
    end
end
local function _____7ED9_4E88_63A2_7D22_5956_52B1_7269_54C1(_____5355_4F4D, _____7269_54C1ID)
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____7269_54C1ID),
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    )
    if _____7269_54C1 ~= nil and _____7269_54C1 ~= 0 then
        UnitAddItem(_____5355_4F4D, _____7269_54C1)
    end
end
local function _____5904_7406_8840_575B_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local ____ = _____8C03_67E5_70B9
    _____7ED9_4E88_63A2_7D22_5956_52B1_7269_54C1(_____65BD_6CD5_5355_4F4D, _____796D_8840_4E4B_76BF_7269_54C1ID)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffffcc00『血坛低语』：|r坛上的血迹新旧交叠，最新的那层还没有干透。指尖触及的刹那，一段不属于任何活人的祷词掠过意识——他们在这里，向祖地之外的存在献祭。低语散去时，坛边多出了一只余温尚存的祭皿。",
        _____7956_5730_63A2_7D22_70B9_63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_6C60_5E95_9057_7269_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local ____ = _____8C03_67E5_70B9
    _____7ED9_4E88_63A2_7D22_5956_52B1_7269_54C1(_____65BD_6CD5_5355_4F4D, _____7956_5730_7EB9_7AE0_5FBD_8BB0_7269_54C1ID)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffccffff『调查发现』：|r你探入池底，摸到一枚冰凉的物件——刻着祖地鹿王纹章的旧徽记，链绳早已腐断。它为什么会沉在这里？",
        _____7956_5730_63A2_7D22_70B9_63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_7075_6CC9_6C72_53D6(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    if not _____5355_4F4D_662F_5426_6EE1_8840_6EE1_84DD(_____65BD_6CD5_5355_4F4D) then
        _____6062_590D_5355_4F4D_751F_547D_4E0E_9B54_6CD5(_____65BD_6CD5_5355_4F4D, _____7075_6CC9_6062_590D_91CF)
        _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
            Player(_____73A9_5BB6ID),
            _____65BD_6CD5_5355_4F4D,
            "|cffccffff『灵泉汲取』：|r你以掌心贴近灵泉，水中残留的灵心余韵顺着指尖散入四肢，生命与魔法得到了舒缓。",
            _____7956_5730_63A2_7D22_70B9_63D0_793A_6301_7EED_6BEB_79D2
        )
        return true
    end
    if _____7075_6CC9_795D_798F_5DF2_9886_53D6_8868[_____73A9_5BB6ID] ~= true then
        _____7075_6CC9_795D_798F_5DF2_9886_53D6_8868[_____73A9_5BB6ID] = true
        local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
        local _____5F53_524D_751F_547D_6062_590D = __TS__Number(YDUserDataGetSafe("player", _____73A9_5BB6, "生命恢复", "real")) or 0
        YDUserDataSetSafe(
            "player",
            _____73A9_5BB6,
            "生命恢复",
            "real",
            _____5F53_524D_751F_547D_6062_590D + _____7075_6CC9_795D_798F_751F_547D_6062_590D
        )
        local _____5F53_524D_9B54_6CD5_6062_590D = __TS__Number(YDUserDataGetSafe("player", _____73A9_5BB6, "魔法恢复", "real")) or 0
        YDUserDataSetSafe(
            "player",
            _____73A9_5BB6,
            "魔法恢复",
            "real",
            _____5F53_524D_9B54_6CD5_6062_590D + _____7075_6CC9_795D_798F_9B54_6CD5_6062_590D
        )
        _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
            Player(_____73A9_5BB6ID),
            _____65BD_6CD5_5355_4F4D,
            "|cffccffff『灵泉祝福』：|r你的身心已与灵泉同频。泉水的余韵从此常驻你的血脉——生命恢复+10，魔法恢复+3。",
            _____7956_5730_63A2_7D22_70B9_63D0_793A_6301_7EED_6BEB_79D2
        )
        return true
    end
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffccffff『灵泉』：|r泉水的余韵已融入你的血脉，此刻的你无需更多。",
        _____7956_5730_63A2_7D22_70B9_63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
--- 注册精灵祖地的常驻环境互动探索点；在环境互动初始化时调用。
____exports["注册精灵祖地探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "祖地.血坛",
        X = -26764.5,
        Y = -1976.2,
        ["一次性"] = true,
        ["一次性奖励概率"] = _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387,
        ["触发回调"] = _____5904_7406_8840_575B_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "祖地.池底遗物",
        X = -27864.4,
        Y = -5418.7,
        ["一次性"] = true,
        ["一次性奖励概率"] = _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387,
        ["触发回调"] = _____5904_7406_6C60_5E95_9057_7269_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "祖地.灵泉",
        X = -27942.8,
        Y = -3025.5,
        ["一次性"] = false,
        ["触发回调"] = _____5904_7406_7075_6CC9_6C72_53D6
    })
end
return ____exports
