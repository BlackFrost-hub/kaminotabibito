# 剧情步骤

这是主线剧情的正式执行层。

## 当前结构

- `00．剧情步骤类型.ts`
  - 步骤类型与片段配置定义。
- `01．剧情片段配置表.ts`
  - 所有正式挂表片段的统一入口。
- `02．剧情步骤播放器.ts`
  - 步骤执行器。
- `03．剧情片段模板.ts`
  - 统一片段模板。
- `01．第一章`
  - 精灵村、沙漠、蛇人族与第一章 Boss 的剧情集合，章内文件按全局进度号命名，从 `01` 到 `18`。
- `02．第二章`
  - 精灵城与第二章 Boss 承接剧情集合，章内文件按全局进度号命名，从 `19` 起一直到 `34`；当前只剩 `32` 是过程占位文件。
- `03．第三章`
  - 从王城战后启程，经第一章沙漠、熔岩小镇进入万浴熔灵；当前正式接入 `35-38`，后续熔岩核心、双重凤凰与英灵封印节点已写入章内总案。
- `04．第四章`
  - 从万浴熔灵返回奥斯特利帝国；当前仅预设计边境哨卡、风啸峡谷、山顶风龙、枫叶村大教堂与帝都山路，尚未正式挂表。
- `06．Boss死亡剧情索引.ts`
  - Boss 死亡事件到主线剧情片段的轻量索引。
- `01．主线剧情入口/05．主线剧情事件配置表.ts`
  - 主线物品事件、技能通道事件、最终伤害事件的统一入口配置。

## 目录组织

- 顶层保留 `00．主线剧情` 总索引层。
- 章节目录里的文件序列号必须等于剧情进度号，禁止每章从 `01` 重新编号。
- `01．第一章` 管 `01-18`，`02．第二章` 管 `19-34`。
- `01．第一章` 当前正式挂表片段：
  - `jlc_elven_village_gate_release`
  - `jlc_elven_village_elder_quest`
  - `jlc_goblin_cave_intro`
  - `jlc_goblin_boss_intro`
  - `jlc_goblin_defeated_return_elder`
  - `jlc_desert_arrival`
  - `jlc_desert_young_mercenary`
  - `jlc_desert_elder_hint`
  - `jlc_desert_intelligence_merchant`
  - `jlc_snake_territory_entry`
  - `jlc_snake_keeper_first_meet`
  - `jlc_snake_ogre_task_accept`
  - `jlc_desert_ogre_boss_start`
  - `jlc_desert_ogre_first_death`
  - `jlc_slaughter_ogre_death`
  - `jlc_snake_keeper_return_item`
  - `jlc_return_village_after_guard_duel`
  - `jlc_cult_final_boss_start`
  - `jlc_cult_final_boss_death`
- `02．第二章` 当前正式挂表片段：
  - `elven_forest_gate_arrival`
  - `elven_city_alvin_start`
  - `elven_city_gate_open`
  - `elven_city_palace_guard`
  - `elven_city_side_quest_discover`
  - `elven_city_king_audience`
  - `elven_city_hunter_start`
  - `elven_city_troll_leader_start`
  - `elven_city_treant_leader_death`
  - `elven_city_report_magic_letter`
  - `elven_city_hectel_decode`
  - `elven_city_emergency_meeting`
  - `elven_city_chapter_boss_death_bridge`
  - `elven_city_chapter_end`
- `03．第三章` 当前正式挂表片段：
  - `molten_realm_departure_from_elven_city`
  - `molten_realm_lava_town_arrival`
  - `molten_realm_demon_city_call`
  - `molten_realm_avar_audience`

## 迁移原则

- 文件边界先对齐 JASS 真实触发链，不按润色稿随意切。
- 片段来源优先查 `JASS/世界地图/主线剧情/`：普通范围/矩形入口看 `精灵村.j`、`蛇人族.j`、`精灵城.j`，死亡承接看 `死亡触发.j`，NPC/范围注册看 `主线NPC初始化.j`。
- 物品拾取/使用、环境互动、受伤血线这类独立 JASS 触发器不塞进普通对白文件；统一先落到 `01．主线剧情入口/05．主线剧情事件配置表.ts`，再由 `03/04` 初始化文件注册并分发。
- 一个文件可以覆盖一段连续剧情链，文件内部再用局部步骤数组拆子段。
- 不再把村口、长老、Boss、复命拆成一堆顶层配置文件。
- 后续主线维护优先使用“紧凑剧情片段”格式：对白用 `对白列表` 按 `序号` 排列，每句必须写 `持续时间`；动作用 `动作时间线` 挂到 `beforeDialog`、`afterDialog` 或 `absoluteTime`，避免不清楚动作是在某句对白前还是后。
- 对白 `持续时间` 默认按“可见字数 + 标点停顿”估算，再按用户要求微调，不再凭感觉随手写一个常数。
- `absoluteTime` 表示从片段开始累计秒数；`beforeDialog/afterDialog` 表示绑定到指定 `对白序号` 前后。加速时对白持续时间和可跳过等待都按倍速缩放，绝对时间动作也按片段时间轴等比处理。
- 旧 `剧情步骤[]` 作为底层执行格式保留；紧凑剧情片段是更适合迁移和人工校对的维护格式，后续可由转换器编译成执行步骤。
- Boss 死亡剧情不直接塞进 Boss 运行清理层。运行层只做清理、奖励、音乐、YDUserData 等通用逻辑；主线死亡剧情放在剧情片段里，由 `Boss死亡剧情索引` 按语义名/阶段/剧情进度桥接。
- JASS 里明显重复或只为编辑器触发器服务的噪声可以安全压缩，但必须保留功能语义：进度推进、任务提示、镜头/电影模式、视野、音乐、特效、物品、单位创建、Boss 启动和死亡承接不能漏。

## Boss 死亡剧情维护

- 死亡剧情维护入口是 `06．Boss死亡剧情索引.ts`。
- 索引只写映射关系：Boss 单位 ID、Boss 名、需要剧情进度、设置剧情进度、阶段标记、剧情片段 ID。
- 具体对白、镜头、特效、物品、任务提示、二阶段 Boss 创建，仍然写在对应剧情片段文件里。
- Boss 战运行层后续只需要在通用死亡清理后查询索引并触发片段，不要把主线对白直接写进 Boss 运行文件。

## 当前待补

- `地精祭祀` 这类 Boss 预创建范围触发器，现已完成：
  - `CreateTrigger + TriggerRegisterUnitInRangeSimple`
  - 写入 `Boss.*` 的 YDUserData 绑定
  - 写入 `主线剧情入口` 上下文
  - 可直接接统一剧情播放器执行入口
