/** @noSelfInFile */
const 平台原生表 = require("jass.japi");
const 原生函数表 = 平台原生表;
export function 地图_评论次数(玩家) {
    return 原生函数表["DzAPI_Map_CommentCount"](玩家);
}
export function 地图_地图评论次数() {
    return 原生函数表["DzAPI_Map_CommentTotalCount"]();
}
export function 地图_玩家在地图自定义排行榜上的排名(玩家, ID) {
    return 原生函数表["DzAPI_Map_CommentTotalCount1"](玩家, ID);
}
export function 地图_玩家签到天数(玩家, ID) {
    return 原生函数表["DzAPI_Map_ContinuousCount"](玩家, ID);
}
export function 地图_自定义排行榜上榜人数(ID) {
    return 原生函数表["DzAPI_Map_CustomRankCount"](ID);
}
export function 地图_自定义排行榜上的玩家昵称(ID, 排名) {
    return 原生函数表["DzAPI_Map_CustomRankPlayerName"](ID, 排名);
}
export function 地图_自定义排行榜上的玩家数值(ID, 排名) {
    return 原生函数表["DzAPI_Map_CustomRankValue"](ID, 排名);
}
export function 地图_玩家好友数量(玩家) {
    return 原生函数表["DzAPI_Map_FriendCount"](玩家);
}
export function 地图_取活动数据() {
    return 原生函数表["DzAPI_Map_GetActivityData"]();
}
export function 地图_玩家在地图社区上的互动数据(玩家, 数据项) {
    return 原生函数表["DzAPI_Map_GetForumData"](玩家, 数据项);
}
export function 地图_本局游戏的开始时间() {
    return 原生函数表["DzAPI_Map_GetGameStartTime"]();
}
export function 地图_玩家在公会的职责(玩家) {
    return 原生函数表["DzAPI_Map_GetGuildRole"](玩家);
}
export function 地图_玩家天梯等级(玩家) {
    return 原生函数表["DzAPI_Map_GetLadderLevel"](玩家);
}
export function 地图_玩家天梯排名(玩家) {
    return 原生函数表["DzAPI_Map_GetLadderRank"](玩家);
}
export function 地图_玩家抽取地图宝箱总次数(玩家) {
    return 原生函数表["DzAPI_Map_GetLotteryUsedCount"](玩家);
}
export function 地图_玩家抽取指定地图宝箱次数(玩家, 序号) {
    return 原生函数表["DzAPI_Map_GetLotteryUsedCountEx"](玩家, 序号);
}
export function 地图_玩家地图商城道具剩余数量(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetMallItemCount"](玩家, 键名);
}
export function 地图_地图配置参数(键名) {
    return 原生函数表["DzAPI_Map_GetMapConfig"](键名);
}
export function 地图_玩家地图等级(玩家) {
    return 原生函数表["DzAPI_Map_GetMapLevel"](玩家);
}
export function 地图_玩家在地图等级排行榜上的排名(玩家) {
    return 原生函数表["DzAPI_Map_GetMapLevelRank"](玩家);
}
export function 地图_本局游戏的地图模式() {
    return 原生函数表["DzAPI_Map_GetMatchType"]();
}
export function 地图_取平台贵宾(玩家) {
    return 原生函数表["DzAPI_Map_GetPlatformVIP"](玩家);
}
export function 地图_玩家在KK对战平台的完整昵称(玩家) {
    return 原生函数表["DzAPI_Map_GetPlayerUserName"](玩家);
}
export function 地图_取服务器存档组(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetPublicArchive"](玩家, 键名);
}
export function 地图_BOSS击杀后的掉落内容(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetServerArchiveDrop"](玩家, 键名);
}
export function 地图_BOSS击杀后的掉落数量(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetServerArchiveEquip"](玩家, 键名);
}
export function 地图_取服务器存储的数据(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetServerValue"](玩家, 键名);
}
export function 地图_取服务器值错误码(玩家) {
    return 原生函数表["DzAPI_Map_GetServerValueErrorCode"](玩家);
}
export function 地图_玩家本局游戏距上一局游戏的时间差(玩家) {
    return 原生函数表["DzAPI_Map_GetSinceLastPlayedSeconds"](玩家);
}
export function 地图_取服务器存储的技能类型(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetStoredAbilityId"](玩家, 键名);
}
export function 地图_取服务器上的整数变量(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetStoredInteger"](玩家, 键名);
}
export function 地图_取服务器存储的整数(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetStoredIntegerEX"](玩家, 键名);
}
export function 地图_取服务器上的实数变量(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetStoredReal"](玩家, 键名);
}
export function 地图_取服务器上的字符串变量(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetStoredString"](玩家, 键名);
}
export function 地图_取服务器存储的字符串(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetStoredStringEX"](玩家, 键名);
}
export function 地图_取服务器存储的单位类型(玩家, 键名) {
    return 原生函数表["DzAPI_Map_GetStoredUnitType"](玩家, 键名);
}
export function 地图_读取全局存档(键名) {
    return 原生函数表["DzAPI_Map_Global_GetStoreString"](键名);
}
export function 地图_玩家在指定地图累计消耗平台金币(玩家, 地图ID) {
    return 原生函数表["DzAPI_Map_MapsConsumeGold"](玩家, 地图ID);
}
export function 地图_玩家在指定地图的平台木材消耗(玩家, 地图ID) {
    return 原生函数表["DzAPI_Map_MapsConsumeLumber"](玩家, 地图ID);
}
export function 地图_玩家在指定地图的地图等级(玩家, 地图ID) {
    return 原生函数表["DzAPI_Map_MapsLevel"](玩家, 地图ID);
}
export function 地图_玩家累计游戏时长(玩家) {
    return 原生函数表["DzAPI_Map_MapsTotalPlayed"](玩家);
}
export function 地图_玩家累计游戏局数(玩家) {
    return 原生函数表["DzAPI_Map_PlayedGames"](玩家);
}
export function 地图_取服务器存档(玩家, 键名) {
    return 原生函数表["DzAPI_Map_ServerArchive"](玩家, 键名);
}
export function 建造_异步获取当前正在建造的技能编号() {
    return 原生函数表["DzAsyncGetCurrentBuildingAbilityId"]();
}
export function 建造_异步获取当前正在建造的单位编号() {
    return 原生函数表["DzAsyncGetCurrentBuildingUnitId"]();
}
export function 按位与(值A, 值B) {
    return 原生函数表["DzBitAnd"](值A, 值B);
}
export function 整数的2进制的位值(整数值, 字节序号) {
    return 原生函数表["DzBitGet"](整数值, 字节序号);
}
export function 整数的256进制的位值(整数值, 字节序号) {
    return 原生函数表["DzBitGetByte"](整数值, 字节序号);
}
export function 按位取反(整数值) {
    return 原生函数表["DzBitNot"](整数值);
}
export function 按位或(值A, 值B) {
    return 原生函数表["DzBitOr"](值A, 值B);
}
export function 按位左移(整数值, 移位位数) {
    return 原生函数表["DzBitShiftLeft"](整数值, 移位位数);
}
export function 按位右移(整数值, 移位位数) {
    return 原生函数表["DzBitShiftRight"](整数值, 移位位数);
}
export function 四字节组合为整数(字节1, 字节2, 字节3, 字节4) {
    return 原生函数表["DzBitToInt"](字节1, 字节2, 字节3, 字节4);
}
export function 按位异或(值A, 值B) {
    return 原生函数表["DzBitXor"](值A, 值B);
}
export function 转换屏幕坐标到世界x坐标(x, y) {
    return 原生函数表["DzConvertScreenPositionX"](x, y);
}
export function 转换屏幕坐标到世界y坐标(x, y) {
    return 原生函数表["DzConvertScreenPositionY"](x, y);
}
export function 转化_目标允许字符串转整数(目标类型) {
    return 原生函数表["DzConvertStr2Targs"](目标类型);
}
export function 转化_目标允许整数转字符串(目标类型) {
    return 原生函数表["DzConvertTargs2Str"](目标类型);
}
export function 装饰物_新建地形装饰物(ID, 变体, x, y, z, 旋转角度, 缩放) {
    return 原生函数表["DzDoodadCreate"](ID, 变体, x, y, z, 旋转角度, 缩放);
}
export function 装饰物_装饰物动画数量(装饰物) {
    return 原生函数表["DzDoodadGetAnimationCount"](装饰物);
}
export function 装饰物_装饰物动画名(装饰物, 序号) {
    return 原生函数表["DzDoodadGetAnimationName"](装饰物, 序号);
}
export function 装饰物_装饰物动画时间(装饰物, 序号) {
    return 原生函数表["DzDoodadGetAnimationTime"](装饰物, 序号);
}
export function 装饰物_装饰物当前动画编号(装饰物) {
    return 原生函数表["DzDoodadGetCurrentAnimationIndex"](装饰物);
}
export function 装饰物_装饰物动画播放速度(装饰物) {
    return 原生函数表["DzDoodadGetTimeScale"](装饰物);
}
export function 装饰物_装饰物的类型编号(装饰物) {
    return 原生函数表["DzDoodadGetTypeId"](装饰物);
}
export function 装饰物_装饰物的横坐标坐标(装饰物) {
    return 原生函数表["DzDoodadGetX"](装饰物);
}
export function 装饰物_装饰物的纵坐标坐标(装饰物) {
    return 原生函数表["DzDoodadGetY"](装饰物);
}
export function 装饰物_装饰物的高度坐标(装饰物) {
    return 原生函数表["DzDoodadGetZ"](装饰物);
}
export function 界面_添加模型(父级界面) {
    return 原生函数表["DzFrameAddModel"](父级界面);
}
export function 界面_添加模型特效(模型界面, 附着点, 模型路径) {
    return 原生函数表["DzFrameAddModelEffect"](模型界面, 附着点, 模型路径);
}
export function 界面_原生_获取聊天输入栏控件() {
    return 原生函数表["DzFrameGetChatEditBar"]();
}
export function 界面_取子控件(界面, 序号) {
    return 原生函数表["DzFrameGetChild"](界面, 序号);
}
export function 界面_取子控件数量(界面) {
    return 原生函数表["DzFrameGetChildrenCount"](界面);
}
export function 界面_取命令条按钮(行, 列) {
    return 原生函数表["DzFrameGetCommandBarButton"](行, 列);
}
export function 界面_取技能自动施法指示器(界面) {
    return 原生函数表["DzFrameGetCommandBarButtonAutoCastIndicator"](界面);
}
export function 界面_取技能冷却指示器(界面) {
    return 原生函数表["DzFrameGetCommandBarButtonCooldownIndicator"](界面);
}
export function 界面_取技能右下角数字文本框体(界面) {
    return 原生函数表["DzFrameGetCommandBarButtonNumberOverlay"](界面);
}
export function 界面_取技能右下角数字文本控件(界面) {
    return 原生函数表["DzFrameGetCommandBarButtonNumberText"](界面);
}
export function 界面_获取控件绑定的整数(界面) {
    return 原生函数表["DzFrameGetContext"](界面);
}
export function 界面_取BUFF控件(序号) {
    return 原生函数表["DzFrameGetInfoPanelBuffButton"](序号);
}
export function 界面_取框选控件(序号) {
    return 原生函数表["DzFrameGetInfoPanelSelectButton"](序号);
}
export function 界面_获取低于控制台的底层Frame() {
    return 原生函数表["DzFrameGetLowerLevelFrame"]();
}
export function 界面_取模型颜色(模型界面) {
    return 原生函数表["DzFrameGetModelColor"](模型界面);
}
export function 界面_取模型大小(模型界面) {
    return 原生函数表["DzFrameGetModelSize"](模型界面);
}
export function 界面_取模型速度(模型界面) {
    return 原生函数表["DzFrameGetModelSpeed"](模型界面);
}
export function 界面_取模型横坐标(模型界面) {
    return 原生函数表["DzFrameGetModelX"](模型界面);
}
export function 界面_取模型纵坐标(模型界面) {
    return 原生函数表["DzFrameGetModelY"](模型界面);
}
export function 界面_取模型高度(模型界面) {
    return 原生函数表["DzFrameGetModelZ"](模型界面);
}
export function 界面_获取鼠标控件() {
    return 原生函数表["DzFrameGetMouse"]();
}
export function 界面_获取控件的全局名字(界面) {
    return 原生函数表["DzFrameGetName"](界面);
}
export function 界面_取农民控件() {
    return 原生函数表["DzFrameGetPeonBar"]();
}
export function 界面_取相对锚点所在界面(界面, 锚点) {
    return 原生函数表["DzFrameGetPointRelative"](界面, 锚点);
}
export function 界面_取相对锚点的界面锚点(界面, 锚点) {
    return 原生函数表["DzFrameGetPointRelativePoint"](界面, 锚点);
}
export function 界面_取锚点横坐标坐标(界面, 锚点) {
    return 原生函数表["DzFrameGetPointX"](界面, 锚点);
}
export function 界面_取锚点纵坐标坐标(界面, 锚点) {
    return 原生函数表["DzFrameGetPointY"](界面, 锚点);
}
export function 界面_获取控件实际高度(界面) {
    return 原生函数表["DzFrameGetRealHeight"](界面);
}
export function 界面_获取控件实际宽度(界面) {
    return 原生函数表["DzFrameGetRealWidth"](界面);
}
export function 界面_触发的血条() {
    return 原生函数表["DzFrameGetTriggerHpBar"]();
}
export function 界面_触发血条的单位() {
    return 原生函数表["DzFrameGetTriggerHpBarUnit"]();
}
export function 界面_取单位血条(单位) {
    return 原生函数表["DzFrameGetUnitHpBar"](单位);
}
export function 界面_取宽度(界面) {
    return 原生函数表["DzFrameGetWidth"](界面);
}
export function 界面_游戏提示信息界面() {
    return 原生函数表["DzFrameGetWorldFrameMessage"]();
}
export function 界面_转换地图坐标为小地图x坐标(x, y) {
    return 原生函数表["DzFrameWorldToMinimapPosX"](x, y);
}
export function 界面_转换地图坐标为小地图y坐标(x, y) {
    return 原生函数表["DzFrameWorldToMinimapPosY"](x, y);
}
export function 取商店目标(商店, 玩家) {
    return 原生函数表["DzGetActivePatron"](商店, 玩家);
}
export function 取普攻技能(单位) {
    return 原生函数表["DzGetAttackAbility"](单位);
}
export function 取当前缓存模型的数量() {
    return 原生函数表["DzGetCacheModelCount"]();
}
export function 鼠标界面() {
    return 原生函数表["DzGetCursorFrame"]();
}
export function 装饰物_获取当前地形装饰物数量() {
    return 原生函数表["DzGetDoodadsCount"]();
}
export function 取特效透明度(特效) {
    return 原生函数表["DzGetEffectVertexAlpha"](特效);
}
export function 取特效颜色(特效) {
    return 原生函数表["DzGetEffectVertexColor"](特效);
}
export function 取帧率帧数() {
    return 原生函数表["DzGetFPS"]();
}
export function 取游戏界面() {
    return 原生函数表["DzGetGameUI"]();
}
export function 界面_获取游戏外界面底层() {
    return 原生函数表["DzGetGlueUI"]();
}
export function 英雄_获取主属性(单位, 布尔2) {
    return 原生函数表["DzGetHeroPrimaryAttribute"](单位, 布尔2);
}
export function 取英雄主属性附加(单位, 属性) {
    return 原生函数表["DzGetHeroPrimaryAttributePlus"](单位, 属性);
}
export function 英雄_获取主属性类型(单位) {
    return 原生函数表["DzGetHeroPrimaryAttributeType"](单位);
}
export function 取物品技能(特效, 序号) {
    return 原生函数表["DzGetItemAbility"](特效, 序号);
}
export function 物品_获取物品的碰撞体积(物品) {
    return 原生函数表["DzGetItemCollisionSize"](物品);
}
export function 取字符串数量() {
    return 原生函数表["DzGetJassStringTableCount"]();
}
export function 物品_当前选择的物品异步() {
    return 原生函数表["DzGetLastSelectedItem"]();
}
export function 玩家_获取本地玩家的聊天频道() {
    return 原生函数表["DzGetLocalChatRecipient"]();
}
export function 取玩家选中的单位(序号) {
    return 原生函数表["DzGetLocalSelectUnit"](序号);
}
export function 取玩家选中的单位数量() {
    return 原生函数表["DzGetLocalSelectUnitCount"]();
}
export function 取预建造对象() {
    return 原生函数表["DzGetOnBuildAgent"]();
}
export function 取建造的命令编号() {
    return 原生函数表["DzGetOnBuildOrderId"]();
}
export function 取建造的命令类型() {
    return 原生函数表["DzGetOnBuildOrderType"]();
}
export function 取监听到的技能() {
    return 原生函数表["DzGetOnTargetAbilId"]();
}
export function 取监听到技能预选目标() {
    return 原生函数表["DzGetOnTargetAgent"]();
}
export function 取监听到技能预选目标_2() {
    return 原生函数表["DzGetOnTargetInstantTarget"]();
}
export function 取监听到技能预选命令() {
    return 原生函数表["DzGetOnTargetOrderId"]();
}
export function 取监听到技能预选命令类型() {
    return 原生函数表["DzGetOnTargetOrderType"]();
}
export function 物品_玩家当前选择的物品同步(玩家) {
    return 原生函数表["DzGetPlayerLastSelectedItem"](玩家);
}
export function 当前选择的单位() {
    return 原生函数表["DzGetSelectedLeaderUnit"]();
}
export function 当前选择的单位异步() {
    return 当前选择的单位();
}
export function 硬件_获取屏幕设备高度() {
    return 原生函数表["DzGetSystemMetricsHeight"]();
}
export function 硬件_获取屏幕设备宽度() {
    return 原生函数表["DzGetSystemMetricsWidth"]();
}
export function 坐标_获取地形高度轴高度(x, y) {
    return 原生函数表["DzGetTerrainZ"](x, y);
}
export function 取时间日期从时间戳(时间戳) {
    return 原生函数表["DzGetTimeDateFromTimestamp"](时间戳);
}
export function 取触发按键() {
    return 原生函数表["DzGetTriggerKey"]();
}
export function 取触发按键玩家() {
    return 原生函数表["DzGetTriggerKeyPlayer"]();
}
export function 技能_获取技能施法范围(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityArea"](单位, 技能代码);
}
export function 技能_获取技能图标(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityArt"](单位, 技能ID);
}
export function 技能_设置技能魔法施放回复后摇(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityBackSwing"](单位, 技能ID);
}
export function 技能_获取建造技能命令编号象牙塔(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityBuildOrderId"](单位, 技能代码);
}
export function 技能_获取技能魔法施放点前摇(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityCastPoint"](单位, 技能ID);
}
export function 技能_获取技能魔法施法时间(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityCastTime"](单位, 技能ID);
}
export function 技能_获取技能当前冷却时间(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityCool"](单位, 技能代码);
}
export function 技能_获取技能魔法消耗(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityCost"](单位, 技能代码);
}
export function 技能_获取技能dataA(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityDataA"](单位, 技能代码);
}
export function 技能_获取技能dataB(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityDataB"](单位, 技能代码);
}
export function 技能_获取技能dataC(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityDataC"](单位, 技能代码);
}
export function 技能_获取技能dataD(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityDataD"](单位, 技能代码);
}
export function 技能_获取技能dataE(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityDataE"](单位, 技能代码);
}
export function 技能_获取当前禁用的内部计数(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityDisabledCount"](单位, 技能ID);
}
export function 技能_获取技能持续时间普通(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityDuration"](单位, 技能ID);
}
export function 技能_工程升级_获取替换后的技能编号(单位, 旧ID) {
    return 原生函数表["DzGetUnitAbilityEngineeringUpgradeNewId"](单位, 旧ID);
}
export function 技能_工程升级_获取替换前的技能编号(单位, 新ID) {
    return 原生函数表["DzGetUnitAbilityEngineeringUpgradeOldId"](单位, 新ID);
}
export function 技能_获取技能持续时间英雄(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityHeroDuration"](单位, 技能ID);
}
export function 技能_获取当前是否禁用状态(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityIsDisabled"](单位, 技能ID);
}
export function 技能_获取技能最大冷却时间(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityMaxCool"](单位, 技能代码);
}
export function 技能_获取技能投射物弧度(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityMissileArc"](单位, 技能ID);
}
export function 技能_获取技能投射物模型(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityMissileArt"](单位, 技能ID);
}
export function 技能_获取技能投射物数量弹幕攻击(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityMissileCount"](单位, 技能ID);
}
export function 技能_获取技能投射物伤害弹幕攻击(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityMissileDamage"](单位, 技能ID);
}
export function 技能_获取技能投射物允许自导(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityMissileHoming"](单位, 技能ID);
}
export function 技能_获取技能投射物最大伤害弹幕攻击(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityMissileMaxDamage"](单位, 技能ID);
}
export function 技能_获取技能投射物速度(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityMissileSpeed"](单位, 技能ID);
}
export function 技能_获取技能命令编号(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityOrderId"](单位, 技能ID);
}
export function 技能_获取技能施法距离(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityRange"](单位, 技能代码);
}
export function 技能_获取技能等级要求(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityReqLevel"](单位, 技能代码);
}
export function 技能_获取魔法书的技能列表(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilitySpellBookList"](单位, 技能ID);
}
export function 技能_获取技能目标允许(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityTargs"](单位, 技能代码);
}
export function 技能_获取当前科技条件是否达成(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityTechReach"](单位, 技能ID);
}
export function 技能_获取技能提示(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityTip"](单位, 技能ID);
}
export function 技能_获取技能提示扩展(单位, 技能ID) {
    return 原生函数表["DzGetUnitAbilityUberTip"](单位, 技能ID);
}
export function 技能_获取建造技能单位编号象牙塔(单位, 技能代码) {
    return 原生函数表["DzGetUnitAbilityUnitId"](单位, 技能代码);
}
export function 单位_获取单位作为目标类型(单位) {
    return 原生函数表["DzGetUnitAsAttackTargetType"](单位);
}
export function 单位_获取单位攻击1目标允许(单位) {
    return 原生函数表["DzGetUnitAttack1TargetType"](单位);
}
export function 单位_获取单位攻击2目标允许(单位) {
    return 原生函数表["DzGetUnitAttack2TargetType"](单位);
}
export function 单位_获取攻击最大目标数(单位, 序号) {
    return 原生函数表["DzGetUnitAttackTargetCount"](单位, 序号);
}
export function 单位_获取魔法施放回复后摇(单位) {
    return 原生函数表["DzGetUnitBackSwing"](单位);
}
export function 单位_获取魔法施放点前摇(单位) {
    return 原生函数表["DzGetUnitCastPoint"](单位);
}
export function 单位_获取单位的碰撞体积(单位) {
    return 原生函数表["DzGetUnitCollisionSize"](单位);
}
export function 单位_获取单位控制命令是否被屏蔽(单位) {
    return 原生函数表["DzGetUnitDisableControlOrder"](单位);
}
export function 单位_获取单位本地命令是否被屏蔽(单位) {
    return 原生函数表["DzGetUnitDisableLocalOrder"](单位);
}
export function 单位_获取每秒生命恢复(单位) {
    return 原生函数表["DzGetUnitLifeRegen"](单位);
}
export function 单位_获取每秒魔法恢复(单位) {
    return 原生函数表["DzGetUnitManaRegen"](单位);
}
export function 单位_获取最高移动速度(单位) {
    return 原生函数表["DzGetUnitMaxSpeed"](单位);
}
export function 单位_获取最低移动速度(单位) {
    return 原生函数表["DzGetUnitMinSpeed"](单位);
}
export function 单位_获取单位头顶高度偏移(单位) {
    return 原生函数表["DzGetUnitOverheadOffset"](单位);
}
export function 单位_获取投射物发射坐标横坐标(单位) {
    return 原生函数表["DzGetUnitPojectileLaunchX"](单位);
}
export function 单位_获取投射物发射坐标纵坐标(单位) {
    return 原生函数表["DzGetUnitPojectileLaunchY"](单位);
}
export function 单位_获取投射物发射坐标高度(单位) {
    return 原生函数表["DzGetUnitPojectileLaunchZ"](单位);
}
export function 单位_获取单位高度轴高度(单位) {
    return 原生函数表["DzGetUnitZ"](单位);
}
export function 取单位组里单位数量(单位组) {
    return 原生函数表["DzGroupGetCount"](单位组);
}
export function 取单位组里指定索引的单位(单位组, 序号) {
    return 原生函数表["DzGroupGetUnitAt"](单位组, 序号);
}
export function 物品_获取物品大小(物品) {
    return 原生函数表["DzItemGetSize"](物品);
}
export function 物品_获取物品颜色(物品) {
    return 原生函数表["DzItemGetVertexColor"](物品);
}
export function 检查字符串是否包含指定的子字符串(字符串1, 目标字符串, 布尔3) {
    return 原生函数表["DzStringContains"](字符串1, 目标字符串, 布尔3);
}
export function 字符串中查找子字符串并返回其位置(字符串1, 目标字符串, 偏移, 布尔4) {
    return 原生函数表["DzStringFind"](字符串1, 目标字符串, 偏移, 布尔4);
}
export function 检查字符串第一个不包含指定字符串里任意字符的位置(字符串1, 目标字符串, 偏移, 布尔4) {
    return 原生函数表["DzStringFindFirstNotOf"](字符串1, 目标字符串, 偏移, 布尔4);
}
export function 检测字符串里第一个包含指定字符串里任意字符的位置(字符串1, 目标字符串, 偏移, 布尔4) {
    return 原生函数表["DzStringFindFirstOf"](字符串1, 目标字符串, 偏移, 布尔4);
}
export function 从后往前查找字符串中不包含指定字符串任意字符的所在位置(字符串1, 目标字符串, 偏移, 布尔4) {
    return 原生函数表["DzStringFindLastNotOf"](字符串1, 目标字符串, 偏移, 布尔4);
}
export function 从后往前查找字符串中包含指定字符串任意字符的所在位置(字符串1, 目标字符串, 偏移, 布尔4) {
    return 原生函数表["DzStringFindLastOf"](字符串1, 目标字符串, 偏移, 布尔4);
}
export function 插入字符串(字符串1, 位置, 目标字符串) {
    return 原生函数表["DzStringInsert"](字符串1, 位置, 目标字符串);
}
export function 替换字符串(字符串1, 目标字符串, 字符串3, 布尔4) {
    return 原生函数表["DzStringReplace"](字符串1, 目标字符串, 字符串3, 布尔4);
}
export function 反转字符串(字符串1) {
    return 原生函数表["DzStringReverse"](字符串1);
}
export function 删除字符串两边的空格(字符串1) {
    return 原生函数表["DzStringTrim"](字符串1);
}
export function 删除字符串左边的空格(字符串1) {
    return 原生函数表["DzStringTrimLeft"](字符串1);
}
export function 删除字符串右边的空格(字符串1) {
    return 原生函数表["DzStringTrimRight"](字符串1);
}
export function 漂浮字_取当前漂浮文字的字体() {
    return 原生函数表["DzTextTagGetFont"]();
}
export function 漂浮字_取漂浮文字的阴影颜色(类型) {
    return 原生函数表["DzTextTagGetShadowColor"](类型);
}
export function 单位_创建幻象单位(玩家, 单位ID, x, y, 实数5) {
    return 原生函数表["DzUnitCreateIllusion"](玩家, 单位ID, x, y, 实数5);
}
export function 单位_为单位创建幻象(单位) {
    return 原生函数表["DzUnitCreateIllusionFromUnit"](单位);
}
export function 单位_取单位的指定技能(单位, 技能编码) {
    return 原生函数表["DzUnitFindAbility"](单位, 技能编码);
}
export function 单位_取单位的命令数量(单位) {
    return 原生函数表["DzUnitOrdersCount"](单位);
}
export function 工作表的值实数(整数1, 字符串2, 行, 列) {
    return 原生函数表["DzXlsxWorksheetGetCellFloat"](整数1, 字符串2, 行, 列);
}
export function 工作表的值整数(整数1, 字符串2, 行, 列) {
    return 原生函数表["DzXlsxWorksheetGetCellInteger"](整数1, 字符串2, 行, 列);
}
export function 工作表的值字符串(整数1, 字符串2, 行, 列) {
    return 原生函数表["DzXlsxWorksheetGetCellString"](整数1, 字符串2, 行, 列);
}
export function 单元格的数据类型(整数1, 字符串2, 行, 列) {
    return 原生函数表["DzXlsxWorksheetGetCellType"](整数1, 字符串2, 行, 列);
}
export function 工作表的总列数(整数1, 字符串2) {
    return 原生函数表["DzXlsxWorksheetGetColumnCount"](整数1, 字符串2);
}
export function 工作表的总行数(整数1, 字符串2) {
    return 原生函数表["DzXlsxWorksheetGetRowCount"](整数1, 字符串2);
}
export function 脚本扩展_执行(脚本) {
    return 原生函数表["EXExecuteScript"](脚本);
}
export function 技能扩展_取整数数据(技能, 等级, 数据类型) {
    return 原生函数表["EXGetAbilityDataInteger"](技能, 等级, 数据类型);
}
export function 技能扩展_取实数数据(技能, 等级, 数据类型) {
    return 原生函数表["EXGetAbilityDataReal"](技能, 等级, 数据类型);
}
export function 技能扩展_取字符串数据(技能, 等级, 数据类型) {
    return 原生函数表["EXGetAbilityDataString"](技能, 等级, 数据类型);
}
export function 技能扩展_取编号(技能) {
    return 原生函数表["EXGetAbilityId"](技能);
}
export function 技能扩展_取状态(技能, 状态类型) {
    return 原生函数表["EXGetAbilityState"](技能, 状态类型);
}
export function 物品扩展_取字符串数据(物品编码, 数据类型) {
    return 原生函数表["EXGetItemDataString"](物品编码, 数据类型);
}
export function 单位扩展_取技能(单位, 技能编码) {
    return 原生函数表["EXGetUnitAbility"](单位, 技能编码);
}
export function 单位扩展_按序号取技能(单位, 序号) {
    return 原生函数表["EXGetUnitAbilityByIndex"](单位, 序号);
}
export function 平台扩展_玩家平台该地图成就点数(玩家) {
    return 原生函数表["KKApiAchievementPoints"](玩家);
}
export function 平台扩展_取玩家在指定地图会员等级(玩家, 地图ID) {
    return 原生函数表["KKApiConsumeLevel"](玩家, 地图ID);
}
export function 平台扩展_取玩家当天总游戏局数(玩家) {
    return 原生函数表["KKApiDayRounds"](玩家);
}
export function 平台扩展_取随机数的组编号(玩家, 键名) {
    return 原生函数表["KKApiGetBackendLogicGroup"](玩家, 键名);
}
export function 平台扩展_取随机数的值(玩家, 键名) {
    return 原生函数表["KKApiGetBackendLogicIntResult"](玩家, 键名);
}
export function 平台扩展_取随机数的值_2(玩家, 键名) {
    return 原生函数表["KKApiGetBackendLogicStrResult"](玩家, 键名);
}
export function 平台扩展_取随机数的生成时间(玩家, 键名) {
    return 原生函数表["KKApiGetBackendLogicUpdateTime"](玩家, 键名);
}
export function 平台扩展_取赛事模式() {
    return 原生函数表["KKApiGetCompetitionGameMode"]();
}
export function 平台扩展_玩家在公会的等级(玩家) {
    return 原生函数表["KKApiGetGuildLevel"](玩家);
}
export function 平台扩展_取天梯投降的队伍编号() {
    return 原生函数表["KKApiGetLadderSurrenderTeamId"]();
}
export function 平台扩展_事件响应_商城道具最后变动的数量(玩家, 键名) {
    return 原生函数表["KKApiGetMallItemUpdateCount"](玩家, 键名);
}
export function 平台扩展_取地图版本号() {
    return 原生函数表["KKApiGetMapVersion"]();
}
export function 平台扩展_取服务器存档限制余额(玩家, 键名) {
    return 原生函数表["KKApiGetServerValueLimitLeft"](玩家, 键名);
}
export function 平台扩展_取变动的随机存档() {
    return 原生函数表["KKApiGetSyncBackendLogic"]();
}
export function 平台扩展_转换时间戳为具体时间(时间戳) {
    return 原生函数表["KKAPIGetTimeDateFromTimestamp"](时间戳);
}
export function 平台扩展_取时间戳日份(时间戳) {
    return 原生函数表["KKAPIGetTimestampDay"](时间戳);
}
export function 平台扩展_取时间戳月份(时间戳) {
    return 原生函数表["KKAPIGetTimestampMonth"](时间戳);
}
export function 平台扩展_取时间戳年份(时间戳) {
    return 原生函数表["KKAPIGetTimestampYear"](时间戳);
}
export function 平台扩展_宠物探险次数(玩家) {
    return 原生函数表["KKApiMapExplorationNum"](玩家);
}
export function 平台扩展_宠物探险时间(玩家) {
    return 原生函数表["KKApiMapExplorationTime"](玩家);
}
export function 平台扩展_测试大厅预约人数() {
    return 原生函数表["KKApiMapOrderNum"]();
}
export function 平台扩展_取玩家的平台编号(玩家) {
    return 原生函数表["KKApiPlayerGUID"](玩家);
}
export function 平台扩展_玩家地图任务当前进度(玩家, 整数2) {
    return 原生函数表["KKApiQueryTaskCurrentProgress"](玩家, 整数2);
}
export function 平台扩展_玩家地图任务总进度(玩家, 整数2) {
    return 原生函数表["KKApiQueryTaskTotalProgress"](玩家, 整数2);
}
export function 平台扩展_剩余次数(玩家, 分组键) {
    return 原生函数表["KKApiRandomSaveGameCount"](玩家, 分组键);
}
export function 平台扩展_技能按钮_获取按钮上的技能编号(整数1) {
    return 原生函数表["KKCommandButtonGetAbilityId"](整数1);
}
export function 平台扩展_技能按钮_获取按钮上的命令编号(整数1) {
    return 原生函数表["KKCommandButtonGetOrderId"](整数1);
}
export function 平台扩展_界面_获取技能_物品按钮的冷却模型控件(整数1) {
    return 原生函数表["KKCommandGetCooldownModel"](整数1);
}
export function 平台扩展_转化_技能编号为整数(整数值) {
    return 原生函数表["KKConvertAbilId2Int"](整数值);
}
export function 平台扩展_转化_转颜色为整数(整数值) {
    return 原生函数表["KKConvertColor2Int"](整数值);
}
export function 平台扩展_转化_整数为技能编号(整数值) {
    return 原生函数表["KKConvertInt2AbilId"](整数值);
}
export function 平台扩展_转化_转整数为颜色(整数值) {
    return 原生函数表["KKConvertInt2Color"](整数值);
}
export function 界面_取颜色(透明度, 红, 绿, 蓝) {
    return 原生函数表["DzGetColor"](透明度, 红, 绿, 蓝);
}
export function 平台扩展_技能_创建技能按钮控件() {
    return 原生函数表["KKCreateCommandButton"]();
}
export function 请求额外_整数数据(数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8) {
    return 原生函数表["RequestExtraIntegerData"](数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8);
}
export function 请求额外_实数数据(数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8) {
    return 原生函数表["RequestExtraRealData"](数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8);
}
export function 请求额外_字符串数据(数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8) {
    return 原生函数表["RequestExtraStringData"](数据类型, 玩家, 字符串3, 字符串4, 布尔5, 整数6, 整数7, 整数8);
}
