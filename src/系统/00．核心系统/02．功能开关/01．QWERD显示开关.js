/** @noSelfInFile */
const jass = require("jass.common");
const 获取玩家编号 = jass.GetPlayerId;
const 显示限时文本 = jass.DisplayTimedTextToPlayer;
const 获取本地玩家 = jass.GetLocalPlayer;
const 聊天命令事件中心 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const 本地存档 = require("系统.10．存档系统.01．本地存档.index");
const 冷却显示命令 = "-cool";
const 魔法消耗显示命令 = "-cost";
const 动态技能文本命令 = "-动态技能";
const 仇恨文字命令 = "-仇恨文字";
const 仇恨文字英文命令 = "-hate";
const 系统提示前缀 = "|cffffff00[System]|r ";
const 提示持续时间 = 5;
const 冷却显示开关表 = {};
const 魔法消耗显示开关表 = {};
const 动态技能文本开关表 = {};
const 仇恨文字开关表 = {};
let 已初始化 = false;
let 已加载本机显示配置 = false;
function 应用玩家显示配置(player) {
    if (player == null || player === 0)
        return;
    本地存档.加载玩家本地存档(player);
    const playerId = 获取玩家编号(player);
    const 字段 = 本地存档.本地存档字段;
    冷却显示开关表[playerId] = 本地存档.读取本地存档布尔(player, 字段.QWERD冷却显示开关, true);
    魔法消耗显示开关表[playerId] = 本地存档.读取本地存档布尔(player, 字段.QWERD蓝耗显示开关, true);
    动态技能文本开关表[playerId] = 本地存档.读取本地存档布尔(player, 字段.动态技能文本开关, true);
    仇恨文字开关表[playerId] = 本地存档.读取本地存档布尔(player, 字段.仇恨漂浮文字开关, true);
}
function 加载本机显示配置() {
    if (已加载本机显示配置)
        return;
    const localPlayer = 获取本地玩家();
    if (localPlayer == null || localPlayer === 0)
        return;
    已加载本机显示配置 = true;
    应用玩家显示配置(localPlayer);
}
function 强制加载命令玩家显示配置(whichPlayer) {
    if (whichPlayer == null || whichPlayer === 0)
        return;
    应用玩家显示配置(whichPlayer);
    if (whichPlayer === 获取本地玩家()) {
        已加载本机显示配置 = true;
    }
}
function 保存显示开关配置(whichPlayer, field, enabled) {
    本地存档.设置本地存档布尔(whichPlayer, field, enabled, true);
}
function 读取冷却显示开关(playerId) {
    const value = 冷却显示开关表[playerId];
    return value == null ? true : value;
}
function 读取魔法消耗显示开关(playerId) {
    const value = 魔法消耗显示开关表[playerId];
    return value == null ? true : value;
}
function 读取动态技能文本开关(playerId) {
    const value = 动态技能文本开关表[playerId];
    return value == null ? true : value;
}
function 读取仇恨文字开关(playerId) {
    const value = 仇恨文字开关表[playerId];
    return value == null ? true : value;
}
function 输出开关提示(whichPlayer, label, enabled) {
    const 状态文本 = enabled ? "ON" : "OFF";
    显示限时文本(whichPlayer, 0, 0.02, 提示持续时间, 系统提示前缀 + label + "=" + 状态文本);
}
function 切换冷却显示命令动作(whichPlayer) {
    强制加载命令玩家显示配置(whichPlayer);
    const playerId = 获取玩家编号(whichPlayer);
    const 当前值 = 读取冷却显示开关(playerId);
    const nextValue = !当前值;
    冷却显示开关表[playerId] = nextValue;
    保存显示开关配置(whichPlayer, 本地存档.本地存档字段.QWERD冷却显示开关, nextValue);
    输出开关提示(whichPlayer, "lengque", nextValue);
}
function 切换魔法消耗显示命令动作(whichPlayer) {
    强制加载命令玩家显示配置(whichPlayer);
    const playerId = 获取玩家编号(whichPlayer);
    const 当前值 = 读取魔法消耗显示开关(playerId);
    const nextValue = !当前值;
    魔法消耗显示开关表[playerId] = nextValue;
    保存显示开关配置(whichPlayer, 本地存档.本地存档字段.QWERD蓝耗显示开关, nextValue);
    输出开关提示(whichPlayer, "lanhao", nextValue);
}
function 切换动态技能文本命令动作(whichPlayer) {
    强制加载命令玩家显示配置(whichPlayer);
    const playerId = 获取玩家编号(whichPlayer);
    const 当前值 = 读取动态技能文本开关(playerId);
    const nextValue = !当前值;
    动态技能文本开关表[playerId] = nextValue;
    保存显示开关配置(whichPlayer, 本地存档.本地存档字段.动态技能文本开关, nextValue);
    输出开关提示(whichPlayer, "dongtai", nextValue);
}
function 切换仇恨文字命令动作(whichPlayer) {
    强制加载命令玩家显示配置(whichPlayer);
    const playerId = 获取玩家编号(whichPlayer);
    const 当前值 = 读取仇恨文字开关(playerId);
    const nextValue = !当前值;
    仇恨文字开关表[playerId] = nextValue;
    保存显示开关配置(whichPlayer, 本地存档.本地存档字段.仇恨漂浮文字开关, nextValue);
    输出开关提示(whichPlayer, "chouhen", nextValue);
}
export function 本地玩家是否开启冷却显示() {
    加载本机显示配置();
    const localPlayer = 获取本地玩家();
    if (localPlayer == null || localPlayer === 0)
        return true;
    return 读取冷却显示开关(获取玩家编号(localPlayer));
}
export function 本地玩家是否开启魔法消耗显示() {
    加载本机显示配置();
    const localPlayer = 获取本地玩家();
    if (localPlayer == null || localPlayer === 0)
        return true;
    return 读取魔法消耗显示开关(获取玩家编号(localPlayer));
}
export function 本地玩家是否开启动态技能文本() {
    加载本机显示配置();
    const localPlayer = 获取本地玩家();
    if (localPlayer == null || localPlayer === 0)
        return true;
    return 读取动态技能文本开关(获取玩家编号(localPlayer));
}
export function 本地玩家是否开启仇恨文字() {
    加载本机显示配置();
    const localPlayer = 获取本地玩家();
    if (localPlayer == null || localPlayer === 0)
        return true;
    return 读取仇恨文字开关(获取玩家编号(localPlayer));
}
export function 初始化QWERD显示开关() {
    if (已初始化)
        return;
    已初始化 = true;
    加载本机显示配置();
    聊天命令事件中心.注册聊天命令监听(冷却显示命令, 切换冷却显示命令动作);
    聊天命令事件中心.注册聊天命令监听(魔法消耗显示命令, 切换魔法消耗显示命令动作);
    聊天命令事件中心.注册聊天命令监听(动态技能文本命令, 切换动态技能文本命令动作);
    聊天命令事件中心.注册聊天命令监听(仇恨文字命令, 切换仇恨文字命令动作);
    聊天命令事件中心.注册聊天命令监听(仇恨文字英文命令, 切换仇恨文字命令动作);
}
