/** @noSelfInFile */
// 祖地秘境·深渊鳞将掉落：深渊潮汐法典（主动·潮汐冲击，通用点目标壳 IP03）
// 潮汐冲击：短暂蓄势0.4秒后向目标点方向释放潮汐波，直线450码、宽160码内敌人受攻击力×100%魔法伤害并减速25%，持续2秒；冷却18秒。
// 实现选型：通用物品技能槽位 + 开始主动技能前摇预警执行模板（超位魔法残章模式，不强制硬直）+ 胶囊区域取直线敌人。

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 开始主动技能前摇预警执行模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/04．主动技能流程模板/01．前摇预警执行模板";
import { 获取胶囊区域单位 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/09．形状区域/胶囊区域";
import {
    取装备冷却键,
    装备冷却中,
    进入装备冷却并显示,
    是敌对单位,
    取攻击力,
    造成装备伤害,
    装备伤害类型,
    祖地秘境战利品装备名,
} from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
const jass = require("jass.common") as any;
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
    施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
    创建点特效: (this: void, params: { 模型路径: string; X: number; Y: number; Z?: number; Z轴角度?: number; 持续秒?: number; 缩放?: number }) => any;
};

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (rad: number) => number;
const Sin = jass.Sin as (rad: number) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;

const 潮汐波特效 = "Common\\Effect\\Form\\Line\\DeathWave.mdx";

export function 处理深渊潮汐法典使用(this: void, ctx: 物品技能事件上下文): void {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.深渊潮汐法典)) return;
    const caster = ctx.施法单位;
    const cfg = 物品使用数值配置.深渊潮汐法典;
    const 冷却键 = 取装备冷却键(caster, 祖地秘境战利品装备名.深渊潮汐法典, "物品使用");
    if (装备冷却中(冷却键)) return;
    进入装备冷却并显示(冷却键, cfg.冷却秒, caster, 祖地秘境战利品装备名.深渊潮汐法典);

    const x = ctx.目标X;
    const y = ctx.目标Y;
    const cx = GetUnitX(caster);
    const cy = GetUnitY(caster);
    const rad = Atan2(y - cy, x - cx);
    const deg = rad * bj_RADTODEG;
    const 距离 = cfg.直线距离;
    const 终点X = cx + Cos(rad) * 距离;
    const 终点Y = cy + Sin(rad) * 距离;

    开始主动技能前摇预警执行模板({
        施法者: caster,
        目标X: x,
        目标Y: y,
        前摇: {
            持续时间: cfg.前摇秒,
            强制硬直: false,
            允许自我打断: true,
            施法动作名: "spell",
        },
        提示圈: {
            类型: "矩形",
            X: cx,
            Y: cy,
            宽度: cfg.宽度,
            长度: 距离,
            朝向: deg,
            持续时间: cfg.前摇秒,
            来源单位: caster,
        },
        执行: function on潮汐冲击结算(this: void): void {
            // 沿线三段 DeathWave，复用深渊回潮特效资源。
            for (let i = 1; i <= 3; i++) {
                const t = (i / 3) * 距离;
                创建点特效({ 模型路径: 潮汐波特效, X: cx + Cos(rad) * t, Y: cy + Sin(rad) * t, Z: 0, Z轴角度: deg, 持续秒: 1.2, 缩放: 0.9 });
            }
            const units = 获取胶囊区域单位({
                起点X: cx,
                起点Y: cy,
                终点X,
                终点Y,
                宽度: cfg.宽度,
                单位筛选: (u) => 是敌对单位(caster, u),
            });
            const damage = 取攻击力(caster) * cfg.攻击倍率;
            for (let i = 0; i < units.length; i++) {
                造成装备伤害(caster, units[i], damage, 装备伤害类型.魔法, false, undefined, {
                    装备技能类型: "装备主动",
                    物品ID: jass.GetItemTypeId(ctx.物品),
                    物品实例: ctx.物品,
                    技能ID: ctx.技能ID,
                    标签: "潮汐冲击",
                    伤害形态: "AOE",
                });
                施加快速减速Buff(caster, units[i], 0, cfg.减速比例, cfg.减速秒, 祖地秘境战利品装备名.深渊潮汐法典, "装备");
            }
        },
    });
}

export {};
