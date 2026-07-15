/** @noSelfInFile */

import type { 联合战斗成员生命周期 } from '../../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/20．联合战斗成员生命周期';
import type { 可抢占独占状态管理器 } from '../../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/19．可抢占独占状态';

export type 雅儿贝德阶段状态 = '未登场' | '正常护卫' | '失衡' | '狂怒护卫' | '终局拦截' | '已离场';

export interface 雅儿贝德运行状态 {
  单位?: any;
  阶段状态: 雅儿贝德阶段状态;
  当前生命比例: number;
  守护连接生效: boolean;
  共同护盾生效: boolean;
  失衡结束Ms: number;
  下一个失衡生命比例: number;
  上次普通技能Ms: number;
  上次至尊拦截Ms: number;
  上次守护回归Ms: number;
  上次护卫反击Ms: number;
  上次守护职责Ms: number;
  成员生命周期?: 联合战斗成员生命周期;
  独占状态?: 可抢占独占状态管理器;
  已初始化: boolean;
}

export function 创建雅儿贝德运行状态(this: void, unit?: any): 雅儿贝德运行状态 {
  return {
    单位: unit,
    阶段状态: unit == null || unit === 0 ? '未登场' : '正常护卫',
    当前生命比例: 1,
    守护连接生效: false,
    共同护盾生效: false,
    失衡结束Ms: 0,
    下一个失衡生命比例: 0.8,
    上次普通技能Ms: 0,
    上次至尊拦截Ms: 0,
    上次守护回归Ms: 0,
    上次护卫反击Ms: 0,
    上次守护职责Ms: 0,
    已初始化: unit != null && unit !== 0,
  };
}
