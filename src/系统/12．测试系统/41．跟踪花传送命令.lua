local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 跟踪花传送命令（-跟踪花）
-- 
-- 功能：把玩家英雄瞬移到一株"花"采集物旁边（荧光草/星露花/晨曦花/月影花）。
-- - 只找花物品，不找聚灵花单位（植物配置表里的 nsea 单位不在目标内）；
-- - 搜索范围：06．植物配置表 随机物品配置引用的全部刷新区域（动态矩形注册表惰性注册）；
-- - 落点 = 花的位置沿"花→英雄原位置"方向偏移 120 码（英雄原位置必然可达，避免卡进地形）；
-- - 传送后镜头立即切到落点；找不到花时给出提示（可能已被采集或尚未刷新）。
local jass = require("jass.common")
local ____require_result_0 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_0["是允许测试玩家"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("系统.00．核心系统.07．联机安全工具")
local safeEnumItemsInRect = ____require_result_3.safeEnumItemsInRect
local ____require_result_4 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_4["获取矩形区域"]
local ____require_result_5 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.06．植物配置表")
local _____4E16_754C_5730_56FE_690D_7269_968F_673A_7269_54C1_914D_7F6E_8868 = ____require_result_5["世界地图植物随机物品配置表"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_6.debugLogForce
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local GetEnumItem = jass.GetEnumItem
local GetItemTypeId = jass.GetItemTypeId
local GetItemX = jass.GetItemX
local GetItemY = jass.GetItemY
local IsItemVisible = jass.IsItemVisible
local PanCameraToTimedForPlayer = jass.PanCameraToTimedForPlayer
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____6A21_5757_540D = "跟踪花传送命令"
local _____4F20_9001_547D_4EE4 = "-跟踪花"
--- 落点与花的距离（码）
local _____843D_70B9_504F_79FB_8DDD_79BB = 120
--- 花物品ID → 显示名（与 06．植物配置表 / 01．装备数据 一致）
local _____82B1_7269_54C1ID_8868 = {[1936226148] = "荧光草", [1227900980] = "星露花", [1227900981] = "晨曦花", [1227900982] = "月影花"}
--- 从配置表提取去重后的刷新区域名称
local function _____53D6_82B1_5237_65B0_533A_57DF_540D_79F0_5217_8868()
    local _____533A_57DF_540D_96C6_5408 = __TS__New(Set)
    for ____, _____914D_7F6E in ipairs(_____4E16_754C_5730_56FE_690D_7269_968F_673A_7269_54C1_914D_7F6E_8868) do
        if _____914D_7F6E["矩形区域名称"] ~= nil and _____914D_7F6E["矩形区域名称"] ~= "" then
            _____533A_57DF_540D_96C6_5408:add(_____914D_7F6E["矩形区域名称"])
        end
    end
    local _____5217_8868 = {}
    _____533A_57DF_540D_96C6_5408:forEach(function(____, _____540D_79F0)
        local ____temp_7 = #_____5217_8868 + 1
        _____5217_8868[____temp_7] = _____540D_79F0
        return ____temp_7
    end)
    return _____5217_8868
end
--- 在单个区域内收集花物品候选
local function _____6536_96C6_533A_57DF_5185_82B1_5019_9009(_____533A_57DF_540D_79F0, _____7ED3_679C)
    local rect = _____83B7_53D6_77E9_5F62_533A_57DF(_____533A_57DF_540D_79F0)
    if rect == nil or rect == 0 then
        return
    end
    safeEnumItemsInRect(
        nil,
        rect,
        nil,
        function()
            local item = GetEnumItem()
            if item == nil or item == 0 then
                return
            end
            if not IsItemVisible(item) then
                return
            end
            local typeId = GetItemTypeId(item)
            local _____540D_79F0 = _____82B1_7269_54C1ID_8868[typeId]
            if _____540D_79F0 == nil then
                return
            end
            _____7ED3_679C[#_____7ED3_679C + 1] = {
                ["物品"] = item,
                ["名称"] = _____540D_79F0,
                X = GetItemX(item),
                Y = GetItemY(item)
            }
        end
    )
end
--- 沿"花 → 英雄原位置"方向取落点（英雄原位置必然可达）
local function _____53D6_4F20_9001_843D_70B9(_____82B1X, _____82B1Y, _____82F1_96C4X, _____82F1_96C4Y)
    local dx = _____82F1_96C4X - _____82B1X
    local dy = _____82F1_96C4Y - _____82B1Y
    local _____957F_5EA6 = math.sqrt(dx * dx + dy * dy)
    if _____957F_5EA6 < 1 then
        dx = 0
        dy = -1
    else
        dx = dx / _____957F_5EA6
        dy = dy / _____957F_5EA6
    end
    return {x = _____82B1X + dx * _____843D_70B9_504F_79FB_8DDD_79BB, y = _____82B1Y + dy * _____843D_70B9_504F_79FB_8DDD_79BB}
end
local function ____on_8DDF_8E2A_82B1_547D_4EE4(player, _command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local hero = getRegisteredPlayerHero(player)
    if hero == nil or hero == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到当前玩家已注册英雄")
        return
    end
    local _____5019_9009_5217_8868 = {}
    local _____533A_57DF_540D_5217_8868 = _____53D6_82B1_5237_65B0_533A_57DF_540D_79F0_5217_8868()
    do
        local i = 0
        while i < #_____533A_57DF_540D_5217_8868 do
            _____6536_96C6_533A_57DF_5185_82B1_5019_9009(_____533A_57DF_540D_5217_8868[i + 1], _____5019_9009_5217_8868)
            i = i + 1
        end
    end
    if #_____5019_9009_5217_8868 <= 0 then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "[跟踪花] 场上当前没有找到任何花（可能已被采集，等待刷新后重试）"
        )
        debugLogForce(
            _____6A21_5757_540D,
            "未找到花物品：搜索区域 =",
            table.concat(_____533A_57DF_540D_5217_8868, " / ")
        )
        return
    end
    local _____76EE_6807 = _____5019_9009_5217_8868[math.floor(math.random() * #_____5019_9009_5217_8868) + 1]
    local _____82F1_96C4X = GetUnitX(hero)
    local _____82F1_96C4Y = GetUnitY(hero)
    local _____843D_70B9 = _____53D6_4F20_9001_843D_70B9(_____76EE_6807.X, _____76EE_6807.Y, _____82F1_96C4X, _____82F1_96C4Y)
    SetUnitX(hero, _____843D_70B9.x)
    SetUnitY(hero, _____843D_70B9.y)
    PanCameraToTimedForPlayer(player, _____76EE_6807.X, _____76EE_6807.Y, 0)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        ((((((("[跟踪花] 已传送到 " .. _____76EE_6807["名称"]) .. " 旁边（共发现 ") .. tostring(#_____5019_9009_5217_8868)) .. " 株，坐标 ") .. tostring(math.floor(_____76EE_6807.X + 0.5))) .. ", ") .. tostring(math.floor(_____76EE_6807.Y + 0.5))) .. "）"
    )
    debugLogForce(
        _____6A21_5757_540D,
        "传送完成：目标 =",
        _____76EE_6807["名称"],
        "落点 =",
        math.floor(_____843D_70B9.x + 0.5),
        math.floor(_____843D_70B9.y + 0.5),
        "候选数 =",
        #_____5019_9009_5217_8868
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____4F20_9001_547D_4EE4, ____on_8DDF_8E2A_82B1_547D_4EE4)
debugLogForce(_____6A21_5757_540D, "已注册命令：输入", _____4F20_9001_547D_4EE4, "把玩家英雄瞬移到一株花旁边")
return ____exports
