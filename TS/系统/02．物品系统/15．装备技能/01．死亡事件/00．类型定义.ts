/** @noSelfInFile */

export interface 死亡事件上下文 {
  死亡单位: any;
  击杀单位: any;
  死亡单位所有者: any;
  死亡坐标X: number;
  死亡坐标Y: number;
}

export interface 尸体召唤配置 {
  装备名: string;
  搜索半径: number;
  召唤单位类型: string;
  限时生命Buff: string;
  持续时间: number;
  特效路径: string;
  特效持续时间: number;
  额外生命值: number;
  生命值系数: number;
  额外攻击力: number;
  攻击力状态: number;
  攻击力系数: number;
}

export interface 击杀叠层配置 {
  装备名: string;
  每次增加层数: number;
  最大层数: number;
  满层升级到装备名?: string;
}

export interface 死亡事件配置 {
  尸体召唤: 尸体召唤配置;
  击杀叠层列表: 击杀叠层配置[];
}

export interface 已解析尸体召唤配置 extends 尸体召唤配置 {
  装备ID?: string;
}

export interface 已解析击杀叠层配置 extends 击杀叠层配置 {
  装备ID?: string;
  满层升级到装备ID?: string;
}

export interface 已解析死亡事件配置 {
  尸体召唤: 已解析尸体召唤配置;
  击杀叠层列表: 已解析击杀叠层配置[];
}
