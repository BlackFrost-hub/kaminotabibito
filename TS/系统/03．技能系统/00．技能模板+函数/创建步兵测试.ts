/** @noSelfInFile */

const jass = require("jass.common") as any;
const Player = jass.Player as (playerId: number) => any;
const CreateUnit = jass.CreateUnit as (
    whichPlayer: any,
    unitid: number,
    x: number,
    y: number,
    face: number
) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
    toPlayer: any,
    x: number,
    y: number,
    duration: number,
    message: string
) => void;
const { 快捷创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.05．召唤物") as {
    快捷创建召唤物: (主人单位: any, 单位类型: string | number, X: number, Y: number, 持续时间: number) => any;
};

const 启用测试 = false;

if (启用测试) {
    const 玩家0 = Player(0);
    const 主英雄 = CreateUnit(玩家0, 1214869684, 0, 0, 0); // 'Hblm' 创建一个英雄作为主人

    if (主英雄) {
        const 召唤物 = 快捷创建召唤物(主英雄, "hfoo", 100, 100, 30);
        if (召唤物) {
            DisplayTimedTextToPlayer(玩家0, 0, 0, 10, "步兵召唤成功");
        } else {
            DisplayTimedTextToPlayer(玩家0, 0, 0, 10, "步兵召唤失败");
        }
    } else {
        DisplayTimedTextToPlayer(玩家0, 0, 0, 10, "英雄创建失败");
    }
}

export {};
