/**
 * 通用函数 - 统一导出入口
 */

export * from "./00．单位动画等待";
export * from "./01．控制与Buff";
export * from "./02．单位与范围";
export * from "./03．移动速度";
export * from "./04．调试输出";
export * from "./06．闪烁";
export * from "./07．单位组工具";
export * from "./08．无敌帧";
export * from "./09．提示特效";
export * from "./10．命中规则";
export * from "./11．技能表现预设";
export * from "./12．Boss台词广播";
export * from "./13．施法时间线";
export * from "./14．持续施法发射";
export * from "./15．单位技能壳提示";
export * from "./16．技能提示圈工厂";
export * from "./17．闪电效果代码";
export * from "./18．单位动画守护";
export {
  stringToFourCC as BossStringToFourCC,
  取单位ID as Boss取单位ID,
  单位有效 as Boss单位有效,
  距离平方XY as Boss距离平方XY,
  距离XY as Boss距离XY,
  两点角度 as Boss两点角度,
  单位间角度 as Boss单位间角度,
  角度差绝对值 as Boss角度差绝对值,
  目标正面朝向来源 as Boss目标正面朝向来源,
  极坐标X as Boss极坐标X,
  极坐标Y as Boss极坐标Y,
  限制数值 as Boss限制数值,
  点到线段距离平方 as Boss点到线段距离平方,
  播放点特效 as Boss播放点特效,
  播放单位特效 as Boss播放单位特效,
} from "./19．Boss公共工具";

export * from "./01．便捷短函数集合/index";
