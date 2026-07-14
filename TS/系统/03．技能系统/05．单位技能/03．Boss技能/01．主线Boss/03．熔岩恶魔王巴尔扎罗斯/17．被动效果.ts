/** @noSelfInFile */

import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 获取或创建巴尔扎罗斯上下文, 注册巴尔扎罗斯运行时 } from "./03．运行时上下文";
import { 初始化巴尔扎罗斯熔核封印与护卫机制 } from "./04．熔核封印与护卫机制";
import { 初始化巴尔扎罗斯格鲁姆技能 } from "./01．护卫A格鲁姆/index";
import { 初始化巴尔扎罗斯塞拉技能 } from "./02．护卫B塞拉/index";
import { 初始化巴尔扎罗斯地核召唤节点 } from "./11．地核召唤";
import { 初始化巴尔扎罗斯熔岩护盾节点 } from "./12．熔岩护盾";
import { 初始化巴尔扎罗斯末日熔爆节点 } from "./13．末日熔爆";
import { 注册巴尔扎罗斯技能结构 } from "./15．技能入口";
import { stringToFourCC } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const { 注册Boss自动技能启动监听 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};

const 巴尔扎罗斯单位类型ID = stringToFourCC(巴尔扎罗斯单位技能配置.单位ID);
let 巴尔扎罗斯被动已注册 = false;

function on巴尔扎罗斯Boss启动(this: void, 启动上下文: any): void {
  const context = 获取或创建巴尔扎罗斯上下文(启动上下文.Boss单位);
  if (context != null) {
    初始化巴尔扎罗斯熔核封印与护卫机制(context);
    初始化巴尔扎罗斯格鲁姆技能(context);
    初始化巴尔扎罗斯塞拉技能(context);
    初始化巴尔扎罗斯地核召唤节点(context);
    初始化巴尔扎罗斯熔岩护盾节点(context);
    初始化巴尔扎罗斯末日熔爆节点(context);
  }
}

export function 注册巴尔扎罗斯被动效果(this: void): void {
  if (巴尔扎罗斯被动已注册) return;
  巴尔扎罗斯被动已注册 = true;
  注册巴尔扎罗斯运行时();
  注册巴尔扎罗斯技能结构();
  注册Boss自动技能启动监听({
    名称: "巴尔扎罗斯运行时上下文绑定",
    单位类型ID: 巴尔扎罗斯单位类型ID,
    on启动: on巴尔扎罗斯Boss启动,
  });
}

注册巴尔扎罗斯被动效果();
