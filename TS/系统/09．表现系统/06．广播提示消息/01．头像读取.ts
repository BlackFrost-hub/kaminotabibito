/** @noSelfInFile */

const jass = require("jass.common") as any;
const ydwe = require("lib.扩展函数.YDWE函数.index") as {
  ObjectType: { UNIT: number };
};
const ydweSafe = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertySafe: (this: void, objectType: number, objectId: number | string, property: string) => string;
};

import { 广播提示默认头像 } from "./00．常量定义";

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const getObjectProperty = ydweSafe.getObjectPropertySafe;
const ObjectType = ydwe.ObjectType;

const 单位头像缓存: Record<number, string | undefined> = {};

function 是贴图路径(this: void, 路径: string): boolean {
  if (路径 == null || 路径 === "") return false;
  const 小写路径 = 路径.toLowerCase();
  return 小写路径.endsWith(".blp") || 小写路径.endsWith(".dds") || 小写路径.endsWith(".tga");
}

export function 取单位类型头像(this: void, 单位类型ID: number): string {
  if (单位类型ID == null || 单位类型ID === 0) return 广播提示默认头像;
  const 缓存 = 单位头像缓存[单位类型ID];
  if (缓存 != null) return 缓存;

  const 美术路径 = getObjectProperty(ObjectType.UNIT, 单位类型ID, "Art");
  if (是贴图路径(美术路径)) {
    单位头像缓存[单位类型ID] = 美术路径;
    return 美术路径;
  }

  const 图标路径 = getObjectProperty(ObjectType.UNIT, 单位类型ID, "uico");
  if (是贴图路径(图标路径)) {
    单位头像缓存[单位类型ID] = 图标路径;
    return 图标路径;
  }

  单位头像缓存[单位类型ID] = 广播提示默认头像;
  return 广播提示默认头像;
}

export function 取单位类型Art头像(this: void, 单位类型ID: number): string {
  if (单位类型ID == null || 单位类型ID === 0) return "";
  const 美术路径 = getObjectProperty(ObjectType.UNIT, 单位类型ID, "Art");
  return 是贴图路径(美术路径) ? 美术路径 : "";
}

export function 取单位头像(this: void, 单位: any): string {
  if (单位 == null || 单位 === 0) return 广播提示默认头像;
  return 取单位类型头像(GetUnitTypeId(单位));
}
