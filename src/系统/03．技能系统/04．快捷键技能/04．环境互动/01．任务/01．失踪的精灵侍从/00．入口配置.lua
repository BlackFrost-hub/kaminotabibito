local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注销环境互动调查点"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_1["销毁点特效"]
local ____require_result_2 = require("系统.08．任务系统.01．任务数据")
local questDB = ____require_result_2.questDB
local ____require_result_3 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____require_result_3.questManager
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
____exports["失踪的精灵侍从任务ID"] = 10024
local _____5931_8E2A_7684_7CBE_7075_4F8D_4ECE_4EFB_52A1_952E = tostring(____exports["失踪的精灵侍从任务ID"])
local _____5931_8E2A_7684_7CBE_7075_4F8D_4ECE_4EFB_52A1_76EE_6807ID = "obj1"
local _____5931_8E2A_4F8D_4ECE_8C03_67E5_7EBF_7D22_914D_7F6E_8868 = {{
    ID = "王庭徽记",
    ["名称"] = "染血的王庭徽记",
    X = -7641.2,
    Y = -14602.9,
    Z = 0,
    ["模型路径"] = "Common\\Effect\\Form\\Investigation\\Radiance Psionic.mdx",
    ["发现文本"] = "|cffffff00『调查发现』：|r在王庭外墙角落找到了一枚染血的王庭徽记。徽记上的血迹已经干涸，像是有人仓促地将它从现场带走。"
}, {
    ID = "侍从披风",
    ["名称"] = "撕裂的侍从披风",
    X = -6552.3,
    Y = -15508.9,
    Z = 0,
    ["模型路径"] = "Common\\Effect\\Form\\Investigation\\MissingServantCape.mdx",
    ["发现文本"] = "|cffffff00『调查发现』：|r城外小路旁留着一件撕裂的侍从披风，布料上还沾着泥土，像是在挣扎中被硬生生扯下来的。"
}, {
    ID = "异常血迹",
    ["名称"] = "古树附近的异常血迹",
    X = -7877.4,
    Y = -9151.3,
    Z = 205.7,
    ["模型路径"] = "Common\\Effect\\Form\\Investigation\\MissingServantBlood.mdx",
    ["发现文本"] = "|cffffff00『调查发现』：|r古树附近残留着一片异常血迹。血迹的颜色和凝固方式都不像普通野兽留下的，附近还残留着陌生的气息。"
}}
local _____5F53_524D_8C03_67E5_7EBF_7D22_8FD0_884C_72B6_6001_8868 = {}
local _____5DF2_8C03_67E5_7EBF_7D22ID_8868 = {}
local function _____8BFB_53D6_5F53_524D_4EFB_52A1_76EE_6807_8FDB_5EA6()
    local ____temp_5
    if questDB.globalData ~= nil then
        ____temp_5 = questDB.globalData.quests:get(_____5931_8E2A_7684_7CBE_7075_4F8D_4ECE_4EFB_52A1_952E)
    else
        ____temp_5 = nil
    end
    local _____6D3B_52A8_4EFB_52A1 = ____temp_5
    if _____6D3B_52A8_4EFB_52A1 == nil or _____6D3B_52A8_4EFB_52A1.objectives == nil or #_____6D3B_52A8_4EFB_52A1.objectives == 0 then
        return nil
    end
    local _____76EE_6807 = _____6D3B_52A8_4EFB_52A1.objectives[1]
    if _____76EE_6807 == nil then
        return nil
    end
    return {["当前"] = _____76EE_6807.current, ["需求"] = _____76EE_6807.required}
end
local function _____67E5_627E_8C03_67E5_7EBF_7D22(_____8C03_67E5_70B9ID)
    do
        local i = 0
        while i < #_____5931_8E2A_4F8D_4ECE_8C03_67E5_7EBF_7D22_914D_7F6E_8868 do
            local _____914D_7F6E = _____5931_8E2A_4F8D_4ECE_8C03_67E5_7EBF_7D22_914D_7F6E_8868[i + 1]
            if _____914D_7F6E.ID == _____8C03_67E5_70B9ID then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
local function _____6E05_7406_8C03_67E5_7EBF_7D22_7279_6548(_____8C03_67E5_70B9ID)
    do
        local i = #_____5F53_524D_8C03_67E5_7EBF_7D22_8FD0_884C_72B6_6001_8868 - 1
        while i >= 0 do
            do
                local _____72B6_6001 = _____5F53_524D_8C03_67E5_7EBF_7D22_8FD0_884C_72B6_6001_8868[i + 1]
                if _____72B6_6001.ID ~= _____8C03_67E5_70B9ID then
                    goto __continue11
                end
                _____9500_6BC1_70B9_7279_6548(_____72B6_6001["特效"])
                __TS__ArraySplice(_____5F53_524D_8C03_67E5_7EBF_7D22_8FD0_884C_72B6_6001_8868, i, 1)
                return
            end
            ::__continue11::
            i = i - 1
        end
    end
end
local function _____6E05_7406_5931_8E2A_4F8D_4ECE_8C03_67E5_5165_53E3()
    do
        local i = #_____5931_8E2A_4F8D_4ECE_8C03_67E5_7EBF_7D22_914D_7F6E_8868 - 1
        while i >= 0 do
            _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9(_____5931_8E2A_4F8D_4ECE_8C03_67E5_7EBF_7D22_914D_7F6E_8868[i + 1].ID)
            i = i - 1
        end
    end
    do
        local i = #_____5F53_524D_8C03_67E5_7EBF_7D22_8FD0_884C_72B6_6001_8868 - 1
        while i >= 0 do
            _____9500_6BC1_70B9_7279_6548(_____5F53_524D_8C03_67E5_7EBF_7D22_8FD0_884C_72B6_6001_8868[i + 1]["特效"])
            table.remove(_____5F53_524D_8C03_67E5_7EBF_7D22_8FD0_884C_72B6_6001_8868)
            i = i - 1
        end
    end
    do
        local i = #_____5931_8E2A_4F8D_4ECE_8C03_67E5_7EBF_7D22_914D_7F6E_8868 - 1
        while i >= 0 do
            _____5DF2_8C03_67E5_7EBF_7D22ID_8868[_____5931_8E2A_4F8D_4ECE_8C03_67E5_7EBF_7D22_914D_7F6E_8868[i + 1].ID] = false
            i = i - 1
        end
    end
end
local function _____5904_7406_5931_8E2A_4F8D_4ECE_8C03_67E5_70B9(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____7EBF_7D22 = _____67E5_627E_8C03_67E5_7EBF_7D22(_____8C03_67E5_70B9.ID)
    if _____7EBF_7D22 == nil or _____5DF2_8C03_67E5_7EBF_7D22ID_8868[_____7EBF_7D22.ID] == true then
        return false
    end
    if _____8BFB_53D6_5F53_524D_4EFB_52A1_76EE_6807_8FDB_5EA6() == nil then
        return false
    end
    local _____8FDB_5EA6 = _____8BFB_53D6_5F53_524D_4EFB_52A1_76EE_6807_8FDB_5EA6()
    if _____8FDB_5EA6 == nil or _____8FDB_5EA6["当前"] >= _____8FDB_5EA6["需求"] then
        return false
    end
    if not questDB.updateObjective(_____73A9_5BB6ID, _____5931_8E2A_7684_7CBE_7075_4F8D_4ECE_4EFB_52A1_952E, _____5931_8E2A_7684_7CBE_7075_4F8D_4ECE_4EFB_52A1_76EE_6807ID, _____8FDB_5EA6["当前"] + 1) then
        return false
    end
    _____5DF2_8C03_67E5_7EBF_7D22ID_8868[_____7EBF_7D22.ID] = true
    _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9(_____7EBF_7D22.ID)
    _____6E05_7406_8C03_67E5_7EBF_7D22_7279_6548(_____7EBF_7D22.ID)
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____7EBF_7D22["发现文本"], 5000)
    questManager.triggerUIRefresh(_____73A9_5BB6ID, _____5931_8E2A_7684_7CBE_7075_4F8D_4ECE_4EFB_52A1_952E)
    local _____65B0_8FDB_5EA6 = _____8FDB_5EA6["当前"] + 1
    if _____65B0_8FDB_5EA6 >= _____8FDB_5EA6["需求"] then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, "|cffffff00『调查结果』：|r三处线索已经查齐了。回去向内务总管·语维复命吧。", 5000)
    end
    return true
end
local function _____6CE8_518C_5931_8E2A_4F8D_4ECE_8C03_67E5_70B9()
    _____6E05_7406_5931_8E2A_4F8D_4ECE_8C03_67E5_5165_53E3()
    do
        local i = 0
        while i < #_____5931_8E2A_4F8D_4ECE_8C03_67E5_7EBF_7D22_914D_7F6E_8868 do
            do
                local _____7EBF_7D22 = _____5931_8E2A_4F8D_4ECE_8C03_67E5_7EBF_7D22_914D_7F6E_8868[i + 1]
                local _____8C03_67E5_70B9 = {
                    ID = _____7EBF_7D22.ID,
                    X = _____7EBF_7D22.X,
                    Y = _____7EBF_7D22.Y,
                    ["触发范围"] = 300,
                    ["触发回调"] = _____5904_7406_5931_8E2A_4F8D_4ECE_8C03_67E5_70B9
                }
                if not _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9(_____8C03_67E5_70B9) then
                    goto __continue28
                end
                local _____7279_6548 = _____521B_5EFA_70B9_7279_6548({["模型路径"] = _____7EBF_7D22["模型路径"], X = _____7EBF_7D22.X, Y = _____7EBF_7D22.Y, Z = _____7EBF_7D22.Z})
                _____5F53_524D_8C03_67E5_7EBF_7D22_8FD0_884C_72B6_6001_8868[#_____5F53_524D_8C03_67E5_7EBF_7D22_8FD0_884C_72B6_6001_8868 + 1] = {ID = _____7EBF_7D22.ID, ["特效"] = _____7279_6548}
            end
            ::__continue28::
            i = i + 1
        end
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(nil, "|cffffff00『任务提示』：|r王庭外墙、城外小路和古树附近都可能留下了线索。请在附近使用环境互动。", 5000)
end
____exports["接受失踪的精灵侍从任务"] = function(______73A9_5BB6ID)
    _____6CE8_518C_5931_8E2A_4F8D_4ECE_8C03_67E5_70B9()
end
____exports["完成失踪的精灵侍从任务"] = function(______73A9_5BB6ID)
    _____6E05_7406_5931_8E2A_4F8D_4ECE_8C03_67E5_5165_53E3()
end
____exports["失踪的精灵侍从任务配置"] = {
    ["名称"] = "失踪的精灵侍从",
    ["类型"] = "调查",
    ["需求数量"] = 3,
    ["进度文本"] = "调查线索N/3",
    ["描述"] = "调查王庭外墙、城外小路和古树附近，寻找失踪精灵侍从留下的线索",
    ["奖励"] = "所有玩家+10000金币;所有玩家+当前等级升级所需经验的30%经验;完成任务的玩家+1能量碎片",
    ["奖励显示"] = "所有玩家+10000金币;所有玩家+当前等级升级所需经验的30%;完成任务的玩家+1能量碎片",
    ["NPC开始对白"] = "NPC：有一名侍从失踪了。按理说，他只是负责王庭内务，不该离开城里这么久。\nNPC：我已经派人查过城门和巡逻记录，可这件事越查越不对劲。\nPlayer：你怀疑他在城外遇到了麻烦？\nNPC：我不敢妄下结论，但外墙角落、城外小路，还有古树附近，都有人发现过不寻常的痕迹。",
    ["任务接受对白"] = "Player：我去把这几处地方查一遍。\nNPC：好。先别惊动城里的守卫，找到什么就记下什么，等线索齐了再回来告诉我。",
    ["NPC完成对白"] = "NPC：王庭徽记、侍从披风，还有古树旁的血迹……看来他确实不是自行离城。\nNPC：这件事已经不能再当作普通失踪处理了。我会立刻封存巡逻记录，并安排人手继续追查。\nPlayer：如果还有新的线索，随时来找我们。",
    ["接取后动作"] = ____exports["接受失踪的精灵侍从任务"],
    ["完成后动作"] = ____exports["完成失踪的精灵侍从任务"],
    ["可重复"] = false,
    ["启用"] = true
}
return ____exports
