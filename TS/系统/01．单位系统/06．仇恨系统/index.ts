export * from "./00．仇恨存储";
export * from "./01．仇恨计算";
export * from "./02．目标选择";
export * from "./03．仇恨驱动";
export * from "./04．仇恨显示";
export * from "./05．技能目标选择";
export * from "./06．对外接口";

const {
  注册伤害仇恨回调,
} = require("系统.01．单位系统.06．仇恨系统.01．仇恨计算") as {
  注册伤害仇恨回调: (this: void) => void;
};

const {
  初始化仇恨系统,
} = require("系统.01．单位系统.06．仇恨系统.03．仇恨驱动") as {
  初始化仇恨系统: (this: void) => void;
};

注册伤害仇恨回调();
初始化仇恨系统();
