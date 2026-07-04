/** @noSelfInFile */

const { 注册击杀回复触发模板 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.00．击杀回复触发模板") as {
  注册击杀回复触发模板: (this: void, 配置: any) => any;
};
const { 单位持有装备 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助") as {
  单位持有装备: (this: void, unit: any, 装备名: string) => boolean;
};

function 盗贼首领徽记触发条件(this: void, event: any): boolean {
  return 单位持有装备(event.击杀单位, "盗贼首领徽记");
}

注册击杀回复触发模板({
  名称: "盗贼首领徽记",
  冷却秒数: 0.5,
  恢复魔法值: 50,
  恢复最大魔法比例: 0.05,
  使用默认魔法特效: true,
  触发条件: 盗贼首领徽记触发条件,
});

export {};
