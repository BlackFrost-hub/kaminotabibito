/** @noSelfInFile */
import {
    注册持有型周期效果,
    type 持有型周期效果控制器,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/02．持有型周期效果';
import {
    创建次数型伤害免疫,
    type 次数型伤害免疫控制器,
} from '../../../03．技能系统/00．技能模板+函数/04．机制组件/08．机制触发/08．次数型伤害免疫';
import { 创建句柄上下文托管器 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/24．句柄上下文托管';
import {
    同步可充能层数Buff,
    清除可充能层数Buff,
} from '../../../03．技能系统/00．技能模板+函数/04．机制组件/01．层数状态/07．可充能层数Buff';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
import {
    取装备物品ID,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
interface 翠绿防护层 {
    控制器: 次数型伤害免疫控制器;
}

interface 翠绿防护状态 {
    单位: any;
    层列表: 翠绿防护层[];
}

const 防护 = 创建句柄上下文托管器<翠绿防护状态>('光辉翠绿宝石');
const 翠绿防护最低生命比例 = 0.08;
const 翠绿防护持续秒 = 22;
const 翠绿防护刷新毫秒 = 20000;
const 翠绿防护最大层数 = 2;
let 光辉翠绿周期控制器: 持有型周期效果控制器 | null = null;

function 同步翠绿防护Buff(this: void, state: 翠绿防护状态): void {
    for (let i = state.层列表.length - 1; i >= 0; i--) {
        if (!state.层列表[i].控制器.是否生效()) state.层列表.splice(i, 1);
    }
    let 显示剩余毫秒 = 0;
    for (let i = 0; i < state.层列表.length; i++) {
        const 剩余毫秒 = state.层列表[i].控制器.读取剩余毫秒();
        if (剩余毫秒 > 显示剩余毫秒) 显示剩余毫秒 = 剩余毫秒;
    }
    const 下次充能剩余毫秒 = 光辉翠绿周期控制器 != null
        ? 光辉翠绿周期控制器.读取单位下次触发剩余毫秒(state.单位)
        : 翠绿防护刷新毫秒;
    同步可充能层数Buff({
        单位: state.单位,
        BuffID: 常规BuffID.光辉翠绿宝石_翠绿防护,
        当前层数: state.层列表.length,
        有层剩余毫秒: 显示剩余毫秒,
        下次充能剩余毫秒,
        Buff显示值: 800,
        Buff附加参数: {
            sourceUnit: state.单位,
            effectSourceName: 四Boss战利品装备名.光辉翠绿宝石,
            effectSourceType: '装备',
            effectValue2: 翠绿防护最低生命比例,
            tickWhilePaused: true,
        },
    });
}

function 移除单层翠绿防护(this: void, state: 翠绿防护状态, layer: 翠绿防护层): void {
    if (防护.读取(state.单位) !== state) return;
    for (let i = state.层列表.length - 1; i >= 0; i--) {
        if (state.层列表[i] === layer) state.层列表.splice(i, 1);
    }
    同步翠绿防护Buff(state);
}

function 过滤翠绿防护伤害(this: void, c: any): boolean {
    if (c.isDamageTransfer === true || c.isEquipmentSkillDamage === true) return false;
    const tag = c.skillDamageTag;
    if (typeof tag === 'string' && (tag.indexOf('DOT') >= 0 || tag.indexOf('持续') >= 0 || tag.indexOf('反伤') >= 0 || tag.indexOf('环境') >= 0)) {
        return false;
    }
    return c.isNormalAttack === true || c.isSkillAttack === true || c.isSkillDamage === true || c.isWrappedSkillDamage === true;
}

function on翠绿防护抵挡(this: void, e: any): void {
    播放单位特效(四Boss装备特效.翠绿护盾, e.单位, 'origin', 1.2, 0.32);
}

function 新增一层翠绿防护(this: void, unit: any): void {
    let state = 防护.读取(unit);
    if (state == null) {
        state = { 单位: unit, 层列表: [] };
        防护.写入(unit, state);
    }
    for (let i = state.层列表.length - 1; i >= 0; i--) {
        if (!state.层列表[i].控制器.是否生效()) state.层列表.splice(i, 1);
    }
    if (state.层列表.length >= 翠绿防护最大层数) return;
    const currentState = state;
    let layer: 翠绿防护层 | null = null;
    const controller = 创建次数型伤害免疫({
        名称: '光辉翠绿体',
        单位: unit,
        免疫类型: '物理伤害',
        免疫次数: 1,
        持续秒: 翠绿防护持续秒,
        最低伤害: 800,
        最低伤害占最大生命比例: 翠绿防护最低生命比例,
        过滤伤害: 过滤翠绿防护伤害,
        on抵挡: on翠绿防护抵挡,
        on结束: function on单层翠绿防护结束(this: void): void {
            if (layer != null) 移除单层翠绿防护(currentState, layer);
        },
    });
    layer = { 控制器: controller };
    currentState.层列表.push(layer);
    同步翠绿防护Buff(currentState);
    播放单位特效(四Boss装备特效.翠绿护盾, unit, 'origin', 1, 0.25);
}

function 清除全部翠绿防护(this: void, unit: any): void {
    const state = 防护.取出(unit);
    if (state == null) return;
    for (let i = state.层列表.length - 1; i >= 0; i--) {
        const controller = state.层列表[i].控制器;
        if (controller.是否生效()) controller.取消();
    }
    state.层列表.length = 0;
    清除可充能层数Buff(unit, 常规BuffID.光辉翠绿宝石_翠绿防护);
}

function on获取光辉翠绿宝石(this: void, unit: any): void {
    新增一层翠绿防护(unit);
}

function on丢弃光辉翠绿宝石(this: void, unit: any): void {
    清除全部翠绿防护(unit);
}

function on光辉翠绿宝石周期(this: void, unit: any): void {
    新增一层翠绿防护(unit);
}

光辉翠绿周期控制器 = 注册持有型周期效果({
    物品类型ID: 取装备物品ID(四Boss战利品装备名.光辉翠绿宝石),
    间隔毫秒: 翠绿防护刷新毫秒,
    按单位独立计时: true,
    获取回调: on获取光辉翠绿宝石,
    丢弃回调: on丢弃光辉翠绿宝石,
    周期回调: on光辉翠绿宝石周期,
});
export {};
