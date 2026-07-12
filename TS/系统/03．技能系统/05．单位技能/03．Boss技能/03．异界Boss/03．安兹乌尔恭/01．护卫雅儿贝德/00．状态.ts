/** @noSelfInFile */

export type 雅儿贝德阶段状态 = '未登场' | '正常护卫' | '失衡' | '狂怒护卫' | '终局拦截' | '已离场';

export interface 雅儿贝德运行状态 {
  单位?: any;
  阶段状态: 雅儿贝德阶段状态;
  当前生命比例: number;
  守护连接生效: boolean;
  共同护盾生效: boolean;
  已初始化: boolean;
}
