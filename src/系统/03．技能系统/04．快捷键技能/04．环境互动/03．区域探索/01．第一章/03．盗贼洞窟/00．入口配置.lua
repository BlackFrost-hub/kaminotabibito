local ____lualib = require("lualib_bundle")
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____53E5_67C4_6709_6548, _____589E_52A0_73A9_5BB6_8D44_6E90, _____7ED9_4E88_63A2_7D22_7269_54C1, _____7ED3_7B97_67D3_8840_901A_884C_724C_906D_9047, _____5904_7406_67D3_8840_901A_884C_724C_906D_9047_6B7B_4EA1, _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9, _____89E3_6790_914D_7F6E_5185_90E8ID, _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C, _____6309_540D_5B57_53CD_67E5_7269_54C1ID, unregisterDeathListener, _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6, Player, GetUnitX, GetUnitY, GetPlayerState, SetPlayerState, UnitAddItem, PLAYER_STATE_RESOURCE_GOLD, _____63D0_793A_6301_7EED_6BEB_79D2, _____67D3_8840_901A_884C_724C_70B9_4F4DID, _____67D3_8840_901A_884C_724C_906D_9047_5DF2_521B_5EFA, _____67D3_8840_901A_884C_724C_5DF2_7ED3_7B97, _____67D3_8840_901A_884C_724C_906D_9047_82F1_96C4, _____67D3_8840_901A_884C_724C_906D_9047_73A9_5BB6ID, _____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868
function _____53E5_67C4_6709_6548(_____53E5_67C4)
    return _____53E5_67C4 ~= nil and _____53E5_67C4 ~= 0
end
function _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6ID, _____72B6_6001, _____6570_91CF)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    SetPlayerState(
        _____73A9_5BB6,
        _____72B6_6001,
        GetPlayerState(_____73A9_5BB6, _____72B6_6001) + _____6570_91CF
    )
end
function _____7ED9_4E88_63A2_7D22_7269_54C1(_____5355_4F4D, _____7269_54C1_540D)
    local _____7269_54C1ID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D)
    if _____7269_54C1ID == nil then
        return false
    end
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____7269_54C1ID),
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    )
    if not _____53E5_67C4_6709_6548(_____7269_54C1) then
        return false
    end
    UnitAddItem(_____5355_4F4D, _____7269_54C1)
    return true
end
function _____7ED3_7B97_67D3_8840_901A_884C_724C_906D_9047()
    if _____67D3_8840_901A_884C_724C_5DF2_7ED3_7B97 or #_____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868 > 0 then
        return
    end
    _____67D3_8840_901A_884C_724C_5DF2_7ED3_7B97 = true
    _____67D3_8840_901A_884C_724C_906D_9047_5DF2_521B_5EFA = false
    unregisterDeathListener(_____5904_7406_67D3_8840_901A_884C_724C_906D_9047_6B7B_4EA1)
    _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9(_____67D3_8840_901A_884C_724C_70B9_4F4DID)
    if _____67D3_8840_901A_884C_724C_906D_9047_82F1_96C4 == nil or _____67D3_8840_901A_884C_724C_906D_9047_73A9_5BB6ID < 0 then
        return
    end
    local _____73A9_5BB6ID = _____67D3_8840_901A_884C_724C_906D_9047_73A9_5BB6ID
    local _____82F1_96C4 = _____67D3_8840_901A_884C_724C_906D_9047_82F1_96C4
    _____67D3_8840_901A_884C_724C_906D_9047_82F1_96C4 = nil
    _____67D3_8840_901A_884C_724C_906D_9047_73A9_5BB6ID = -1
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6ID, PLAYER_STATE_RESOURCE_GOLD, 20000)
    _____7ED9_4E88_63A2_7D22_7269_54C1(_____82F1_96C4, "盗贼神符（魔抗）")
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____82F1_96C4,
        "|cffff6666『染血通行牌』：|r最后一名骷髅盗贼倒下，通行牌上的血痕终于不再渗出。附近的盗贼已经被清除。|n|cffffff00获得20000金币、盗贼神符（魔抗）。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
end
function _____5904_7406_67D3_8840_901A_884C_724C_906D_9047_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    if not _____67D3_8840_901A_884C_724C_906D_9047_5DF2_521B_5EFA or _____67D3_8840_901A_884C_724C_5DF2_7ED3_7B97 then
        return
    end
    do
        local i = 0
        while i < #_____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868 do
            do
                if _____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868[i + 1] ~= _____6B7B_4EA1_5355_4F4D then
                    goto __continue19
                end
                __TS__ArraySplice(_____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868, i, 1)
                break
            end
            ::__continue19::
            i = i + 1
        end
    end
    if #_____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868 == 0 then
        _____7ED3_7B97_67D3_8840_901A_884C_724C_906D_9047()
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
_____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注销环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
_____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_1["解析配置内部ID"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_3["立即移除单位并取消排泄登记"]
local ____require_result_4 = require("lib.扩展函数.物品相关函数.创建物品函数")
_____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_4["创建物品并注册排泄监听"]
local ____require_result_5 = require("系统.02．物品系统.13．物品名反查")
_____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_5["按名字反查物品ID"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_6["调整玩家属性"]
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_7.registerDeathListener
unregisterDeathListener = ____require_result_7.unregisterDeathListener
local ____require_result_8 = require("系统.09．表现系统.06．广播提示消息.index")
_____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_8["发送单位提示给玩家"]
local ____require_result_9 = require("系统.11．剧情系统.02．支线任务.04．莫尔特斯.01．任务运行")
local _____8BFB_53D6_5F53_524D_83AB_5C14_7279_65AF_4EFB_52A1Boss = ____require_result_9["读取当前莫尔特斯任务Boss"]
Player = jass.Player
local GetWidgetLife = jass.GetWidgetLife
local IsUnitType = jass.IsUnitType
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetPlayerState = jass.GetPlayerState
SetPlayerState = jass.SetPlayerState
UnitAddItem = jass.UnitAddItem
local _____73A9_5BB6_4E2D_7ACB_654C_5BF9 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
local PLAYER_STATE_RESOURCE_LUMBER = jass.PLAYER_STATE_RESOURCE_LUMBER
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
_____63D0_793A_6301_7EED_6BEB_79D2 = 5200
local _____8D70_79C1_8D26_518C_70B9_4F4DID = "盗贼洞窟.走私账册"
local _____9ED1_6C34_9000_8DEF_70B9_4F4DID = "盗贼洞窟.黑水退路"
_____67D3_8840_901A_884C_724C_70B9_4F4DID = "盗贼洞窟.染血通行牌"
local _____65E7_6218_65D7_6B8B_8A93_70B9_4F4DID = "盗贼洞窟.旧战旗残誓"
local _____76D7_8D3C_6D1E_7A9F_6742_5175_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID("骷髅盗贼#nsog")
local _____67D3_8840_901A_884C_724C_6742_5175_504F_79FB_5217_8868 = {{-220, -140, 45}, {220, -140, 135}, {-220, 140, 315}, {220, 140, 225}}
local _____67D3_8840_901A_884C_724CX = 26402.3
local _____67D3_8840_901A_884C_724CY = -25213.2
_____67D3_8840_901A_884C_724C_906D_9047_5DF2_521B_5EFA = false
_____67D3_8840_901A_884C_724C_5DF2_7ED3_7B97 = false
_____67D3_8840_901A_884C_724C_906D_9047_82F1_96C4 = nil
_____67D3_8840_901A_884C_724C_906D_9047_73A9_5BB6ID = -1
_____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868 = {}
local function _____5904_7406_8D70_79C1_8D26_518C_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6ID, PLAYER_STATE_RESOURCE_GOLD, 15000)
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6ID, PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffcc99ff『走私账册』：|r账册的封皮已经泡软，里面没有货物清单，只有几组反复出现的分账记录。最后一页标着佣兵团遇袭的日期，旁边写着：清空退路，等首领验货。|n|cffffff00获得15000金币、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_9ED1_6C34_9000_8DEF_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "生命恢复", 10)
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6ID, PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cff66ccff『黑水退路』：|r黑水从岩缝里缓慢渗出，水面没有洞窟里的蓝光。沿着水痕看去，岩壁上留着几道新鲜的拖擦痕，像是有人把沉重的箱子从这里运了出去。|n|cffffff00生命恢复永久+10，获得1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____6E05_7406_67D3_8840_901A_884C_724C_906D_9047_5355_4F4D()
    do
        local i = 0
        while i < #_____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868 do
            local _____5355_4F4D = _____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868[i + 1]
            if _____53E5_67C4_6709_6548(_____5355_4F4D) then
                _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____5355_4F4D)
            end
            i = i + 1
        end
    end
    __TS__ArraySetLength(_____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868, 0)
end
local function _____5904_7406_67D3_8840_901A_884C_724C_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if _____67D3_8840_901A_884C_724C_906D_9047_5DF2_521B_5EFA or _____67D3_8840_901A_884C_724C_5DF2_7ED3_7B97 then
        return false
    end
    if _____76D7_8D3C_6D1E_7A9F_6742_5175_7C7B_578BID <= 0 then
        return false
    end
    do
        local i = 0
        while i < #_____67D3_8840_901A_884C_724C_6742_5175_504F_79FB_5217_8868 do
            local _____504F_79FB = _____67D3_8840_901A_884C_724C_6742_5175_504F_79FB_5217_8868[i + 1]
            local _____5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                _____73A9_5BB6_4E2D_7ACB_654C_5BF9,
                _____76D7_8D3C_6D1E_7A9F_6742_5175_7C7B_578BID,
                _____67D3_8840_901A_884C_724CX + _____504F_79FB[1],
                _____67D3_8840_901A_884C_724CY + _____504F_79FB[2],
                _____504F_79FB[3]
            )
            if not _____53E5_67C4_6709_6548(_____5355_4F4D) then
                _____6E05_7406_67D3_8840_901A_884C_724C_906D_9047_5355_4F4D()
                return false
            end
            _____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868[#_____67D3_8840_901A_884C_724C_906D_9047_5355_4F4D_5217_8868 + 1] = _____5355_4F4D
            i = i + 1
        end
    end
    _____67D3_8840_901A_884C_724C_906D_9047_82F1_96C4 = _____65BD_6CD5_5355_4F4D
    _____67D3_8840_901A_884C_724C_906D_9047_73A9_5BB6ID = _____73A9_5BB6ID
    _____67D3_8840_901A_884C_724C_906D_9047_5DF2_521B_5EFA = true
    registerDeathListener(_____5904_7406_67D3_8840_901A_884C_724C_906D_9047_6B7B_4EA1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6666『染血通行牌』：|r通行牌上的血已经干了，边缘却有一道新裂痕。你触碰牌面时，远处传来短促的金属碰撞声，洞里还有盗贼没有离开。|n|cffffff00击败出现的骷髅盗贼，清理这条通道。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return false
end
local function _____83AB_5C14_7279_65AF_5DF2_6B7B_4EA1()
    local ____Boss_5355_4F4D = _____8BFB_53D6_5F53_524D_83AB_5C14_7279_65AF_4EFB_52A1Boss()
    if not _____53E5_67C4_6709_6548(____Boss_5355_4F4D) then
        return false
    end
    return GetWidgetLife(____Boss_5355_4F4D) <= 0.405 or IsUnitType(____Boss_5355_4F4D, UNIT_TYPE_DEAD) == true
end
local function _____5904_7406_65E7_6218_65D7_6B8B_8A93_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____83AB_5C14_7279_65AF_5DF2_6B7B_4EA1() then
        return false
    end
    if not _____7ED9_4E88_63A2_7D22_7269_54C1(_____65BD_6CD5_5355_4F4D, "影旗追猎徽记") then
        return false
    end
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffcc99ff『旧战旗残誓』：|r战旗背面缝着一段没有完成的誓文，最后一句被利器划断：首领倒下之后，活着的人不再守护任何东西，只带走自己能拿走的财物。旗杆底部还藏着一枚未曾交出的追猎徽记。|n|cffffff00获得影旗追猎徽记。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
--- 注册盗贼洞窟四个世界级一次性环境互动点。
____exports["注册盗贼洞窟探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = _____8D70_79C1_8D26_518C_70B9_4F4DID,
        X = 29344.9,
        Y = -24512.3,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_8D70_79C1_8D26_518C_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = _____9ED1_6C34_9000_8DEF_70B9_4F4DID,
        X = 24419,
        Y = -24890.9,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_9ED1_6C34_9000_8DEF_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = _____67D3_8840_901A_884C_724C_70B9_4F4DID,
        X = _____67D3_8840_901A_884C_724CX,
        Y = _____67D3_8840_901A_884C_724CY,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_67D3_8840_901A_884C_724C_8C03_67E5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = _____65E7_6218_65D7_6B8B_8A93_70B9_4F4DID,
        X = 29401.5,
        Y = -22635.5,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_65E7_6218_65D7_6B8B_8A93_8C03_67E5
    })
end
return ____exports
