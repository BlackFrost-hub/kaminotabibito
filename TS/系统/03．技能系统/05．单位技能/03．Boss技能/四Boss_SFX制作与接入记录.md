# 四 Boss SFX 制作与接入记录

> 适用 Boss：沉睡英魂·亚伦柯斯、祖地双灵卫、安兹·乌尔·恭、夏提雅·布拉德弗伦。
>
> 当前状态：**仅完成需求规划，尚未生成、试听确认、迁移或接入代码。** 所有 AI 候选必须先进入 `audio_temp`；只有用户明确确认并要求迁移后，才可进入 `imports/Sound` 并接入 TS。

## 一、固定目录与 BossKey

| Boss | BossKey | 临时试听目录 | 建议正式目录 |
|------|---------|--------------|--------------|
| 沉睡英魂·亚伦柯斯 | `Aronkos` | `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\` | `imports/Sound/Boss/Aronkos/SFX/` |
| 祖地双灵卫 | `AncestralTwinGuards` | `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\` | `imports/Sound/Boss/AncestralTwinGuards/SFX/` |
| 安兹·乌尔·恭 | `Ainz` | `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\` | `imports/Sound/Boss/Ainz/SFX/` |
| 夏提雅·布拉德弗伦 | `Shalltear` | `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\` | `imports/Sound/Boss/Shalltear/SFX/` |

## 二、统一制作规格

- 生成工具：`scripts/elevenlabs_sound_generation.py`。
- 候选格式：`mp3_44100_128`，默认提示词影响力 `0.7`，默认不循环。
- 命名：全小写英文 `snake_case`；候选变体由脚本追加 `_01`、`_02`、`_03`。
- 文件规模：每个 Boss 最终保留 `7-16` 个核心 SFX。本表规划的是机制级声音，不为每个普通动作单独建文件。
- 听感边界：压制 `3kHz-8kHz` 尖峰，避免尖锐金属刮擦、玻璃破裂、连续人声尖叫和无意义高频氛围层。
- 复杂声音拆成起手、主体、低频确认或尾音层生成；最终优先合成为一个可直接播放的文件，避免运行时无必要地同时叠放多条声音。
- 默认空间播放入口：`Sound3DII_CooPlayReuse`。
- 只有同一路径确实需要同时叠放多个实例时，才使用 `Sound3DII_CooPlayPool4MultiInstanceRare`。
- 当前只记录建议播放入口。正式接入前必须再次检查项目现有音效配置表和播放封装，不在 Boss 私有文件里重复实现播放器。

### 状态约定

| 状态 | 含义 |
|------|------|
| `规划` | 只有需求和提示词，尚未生成。 |
| `候选` | 已生成到 `audio_temp`，等待试听。 |
| `确认` | 用户已确认具体候选，但尚未迁移。 |
| `已迁移` | 已进入 `imports/Sound/Boss/.../SFX/`，尚未接代码。 |
| `已接入` | TS 配置、触发点和清理流程已完成并通过构建检查。 |

## 三、沉睡英魂·亚伦柯斯

听感核心：沉重骑士、暗银剑压、苍白魂火、墓土回响与职责结束后的归静。禁止做成火焰陨石、紫黑刺客或高速恶魔斩击。

| 优先级 | 文件名 | 技能 / 触发点 | 建议时长 | 分层方案 | 英文生成提示词 | 播放建议 | 状态 |
|--------|--------|---------------|----------|----------|------------------|----------|------|
| P0 | `aronkos_soul_cleave_charge.mp3` | 亡冥英斩蓄势开始 | `0.8-1.2s` | 剑刃聚压 + 低频魂火吸附 | `Heavy ancient greatsword gathering compressed pale soul energy, restrained low rumble and dark air pressure, isolated dark fantasy game sound effect, no music, no voice, no bright metallic scrape, soft high frequencies` | Boss 坐标，`Reuse` | 规划 |
| P0 | `aronkos_soul_cleave_dash_hit.mp3` | 亡冥英斩突进与主命中 | `1.0-1.5s` | 厚重压风 + 短促切入 + 苍白魂尾 | `A massive armored knight dashing with one heavy greatsword cleave, deep air displacement, short dense impact and pale spectral tail, isolated game sound effect, no music, no voice, no sharp metal screech` | Boss 推进路径中点或命中点，`Reuse` | 规划 |
| P1 | `aronkos_returning_soul_slash.mp3` | P3 归魂剑痕反向结算 | `0.8-1.2s` | 反向吸回 + 较轻魂刃掠过 | `A delayed spectral sword trail reawakening and sweeping backward along an old path, hollow pale soul rush with a controlled low impact, isolated game sound effect, no music, no piercing highs` | 回斩路径中点，`Reuse` | 规划 |
| P1 | `aronkos_fallen_spirit_descent.mp3` | 英灵陨星从高处坠落 | `1.3-2.0s` | 悠长魂体推进，不含落地爆点 | `A fallen knight spirit weapon descending from a great height, long grave-bound spectral pressure and cold air descent, isolated game sound effect, no music, no fireball whistle, no scream` | 落点，`Reuse` | 规划 |
| P0 | `aronkos_fallen_spirit_impact.mp3` | 英灵陨星落地结算 | `0.9-1.4s` | 墓土震动 + 低矮魂爆 + 盔甲残响 | `A heavy spectral weapon striking grave soil, broad low impact, muted earth shock and distant ancient armor resonance, isolated game sound effect, no music, no fiery explosion, no sharp debris` | 落点，`Reuse` | 规划 |
| P1 | `aronkos_grave_gaze_release.mp3` | 亡者凝视正面扇形结算 | `0.8-1.2s` | 沉重魂压向外推出 | `A solemn undead knight releasing a broad forward wave of oppressive soul pressure, deep controlled push and cold spectral resonance, isolated game sound effect, no voice, no music, not a sonic boom` | Boss 坐标，`Reuse` | 规划 |
| P1 | `aronkos_tombstone_rest_complete.mp3` | 墓碑安魂完成 | `1.5-2.4s` | 符文逐层熄灭 + 魂火收束 + 轻微升空尾音 | `Ancient grave runes extinguishing one by one, pale soul flame folding inward and one peaceful spirit rising softly, isolated game sound effect, no music, no crystal shatter, no explosion` | 墓碑坐标，`Reuse` | 规划 |
| P1 | `aronkos_undying_oath_awaken.mp3` | P3 不灭军魂 / 10% 最终强化 | `1.5-2.2s` | 铠甲低鸣 + 军魂聚拢 + 稳定收紧 | `An exhausted ancient oath knight gathering the last disciplined strength, deep armor resonance and many faint warrior spirits converging inward, isolated game sound effect, no voice, no music, no rage scream` | Boss 坐标，`Reuse` | 规划 |
| P0 | `aronkos_duty_ends_defeat.mp3` | 正式战败归静 | `2.5-4.0s` | 剑甲落地 + 魂火离体 + 墓风归静 | `A greatsword and ancient armor settling heavily onto grave soil, pale soul fire slowly leaving the body, grave wind becoming peaceful with a final sense of duty fulfilled, isolated cinematic game sound effect, no music, no scream, no explosion` | Boss 死亡点，`Reuse` | 规划 |

复用边界：亡冥英斩普通命中与 P3 首次突进可共用 `dash_hit`；英魂残影斩击可降低音量复用 `returning_soul_slash`。英灵陨星的坠落和落地必须分开，以便与实际预警时间对齐。

## 四、祖地双灵卫

听感核心：赤誓灵卫使用暗金重剑、盾面和沉稳冲击；苍影灵卫使用冷蓝灵识、空灵镇魂与克制祷潮。双色誓链、净化成功和灵魂崩解必须能仅凭声音区分。

| 优先级 | 文件名 | 技能 / 触发点 | 建议时长 | 分层方案 | 英文生成提示词 | 播放建议 | 状态 |
|--------|--------|---------------|----------|----------|------------------|----------|------|
| P0 | `twin_guards_oath_link_establish.mp3` | 双灵同誓建立或重新连接 | `1.3-2.0s` | 暗金低鸣 + 冷蓝灵音 + 双脉冲稳定锁合 | `Two ancient guardian soul currents, one dark golden and heavy and one cold blue and ethereal, forming a stable oath link with two synchronized pulses, isolated fantasy game sound effect, no music, no electricity crackle, no bright chime` | 两 Boss 中点，`Reuse` | 规划 |
| P1 | `twin_guards_oath_link_protect.mp3` | 低血成员获得同誓保护 | `0.7-1.1s` | 誓链收紧 + 低沉护盾确认 | `An ancient dual-spirit oath chain tightening to protect a weakened guardian, restrained low shield resonance and paired soul pulse, isolated game sound effect, no music, no metallic ping` | 被保护 Boss，`Reuse` | 规划 |
| P1 | `twin_guards_red_oath_shield_charge.mp3` | 誓锋壁进 / 赤誓蓄力推进 | `0.9-1.4s` | 重甲踏步 + 盾面压风 | `A massive ancient shield guardian bracing and driving forward, dark gold shield pressure, heavy armored step and dense low air push, isolated game sound effect, no music, no sharp metal scrape` | 赤誓 Boss，`Reuse` | 规划 |
| P1 | `twin_guards_azure_spirit_seal.mp3` | 镇魂印建立 / 苍影灵识锁定 | `1.0-1.6s` | 冷蓝灵识聚焦 + 克制封印落定 | `A cold blue ancestral spirit focusing into a precise soul-binding seal, hollow inward resonance and a soft low confirmation, isolated game sound effect, no music, no sparkling magic chimes` | 镇魂印落点，`Reuse` | 规划 |
| P0 | `twin_guards_gate_validation_impact.mp3` | 封门校验组合技重击结算 | `1.2-1.8s` | 盾剑重击 + 古门低鸣 + 双魂确认 | `Two ancestral guardians completing a gate trial with one enormous shield-and-blade impact, ancient stone gate resonance and paired spirit confirmation, isolated game sound effect, no music, no explosion, softened high frequencies` | 封门中心，`Reuse` | 规划 |
| P1 | `twin_guards_corruption_transform.mp3` | 侵蚀择形，首名守卫变异 | `1.8-2.8s` | 誓约失衡 + 魂体扭曲 + 低频断裂 | `An ancient guardian oath becoming corrupted, disciplined soul resonance bending out of alignment and breaking into a deep unstable form, isolated dark fantasy game sound effect, no music, no monster scream, no electrical crackle` | 变异 Boss，`Reuse` | 规划 |
| P1 | `twin_guards_dual_key_purify.mp3` | 双钥净化节点成功 | `1.3-2.0s` | 暗金与月白先后进入 + 节点向内净化 | `A two-step ancestral purification, heavy dark-gold martial force followed by moon-white spiritual clarity, converging inward to cleanse one ancient gate node, isolated game sound effect, no music, no glass shatter` | 净化节点，`Reuse` | 规划 |
| P1 | `twin_guards_gate_misjudgment_break.mp3` | 封门误判安全窗出现 / Boss 易伤 | `0.8-1.3s` | 封门低鸣骤停 + 月白魂裂 | `An ancient soul gate realizing a false judgment, deep pressure abruptly releasing into a short moon-white spirit fracture and vulnerable opening, isolated game sound effect, no music, no glass crack, no piercing highs` | Boss 或封门中心，`Reuse` | 规划 |
| P0 | `twin_guards_shared_breath_collapse.mp3` | 同息归寂首名崩解与最终同步收束 | `2.2-3.5s` | 双魂失同步 + 魂体抽离 + 可回灌尾流 | `Two bound ancestral guardian souls losing synchronization, one spirit body dispersing and being drawn away while a faint return current remains possible, deep solemn collapse, isolated game sound effect, no music, no scream, no explosion` | 两 Boss 中点，`Reuse` | 规划 |

复用边界：赤誓的普通盾击可复用 `shield_charge` 的主体层短版；苍影普通镇魂反馈可复用 `spirit_seal` 的轻量版。`oath_link_establish`、`dual_key_purify` 与 `shared_breath_collapse` 是 Boss 身份音，不跨 Boss 复用。

## 五、安兹·乌尔·恭

听感核心：绝对位阶的空间压力、白金高阶魔法、死亡法则和冷静控制。避免普通火球、廉价闪电、连续怪笑和刺耳人类尖叫。

| 优先级 | 文件名 | 技能 / 触发点 | 建议时长 | 分层方案 | 英文生成提示词 | 播放建议 | 状态 |
|--------|--------|---------------|----------|----------|------------------|----------|------|
| P1 | `ainz_reality_slash.mp3` | 现实断裂结算 | `0.8-1.3s` | 空间受压 + 深层撕开 + 短促闭合 | `Reality under immense magical pressure splitting open in one deep controlled fracture and closing sharply, isolated dark fantasy game sound effect, no music, no glass shatter, no electric crackle, soft high frequencies` | 裂缝中心，`Reuse` | 规划 |
| P1 | `ainz_grasp_heart.mp3` | 心脏掌握锁定与结算 | `1.0-1.6s` | 低频心跳骤紧 + 无形挤压 + 静默停顿 | `A distant low heartbeat seized by invisible supreme necromancy, pressure tightening inward followed by a brief dead silence, isolated game sound effect, no music, no gore, no human scream` | 目标位置，`Reuse` | 规划 |
| P1 | `ainz_greater_magic_arrow_volley.mp3` | 高阶魔法箭生成与发射 | `1.0-1.5s` | 白金法术成形 + 多枚克制推进 | `Several high-tier platinum magic arrows forming with dense arcane authority and launching in a controlled volley, isolated game sound effect, no music, no laser pew, no sparkling chimes, no sharp highs` | 安兹坐标，`Reuse` | 规划 |
| P1 | `ainz_brilliant_green_body.mp3` | 光辉翠绿体护盾建立 | `1.2-1.8s` | 翠绿法则展开 + 深沉护盾稳定 | `A supreme emerald defensive spell unfolding around an undead sorcerer, dense magical law locking into a calm resilient barrier, isolated game sound effect, no music, no glass shimmer, no bright chime` | 安兹坐标，`Reuse` | 规划 |
| P1 | `ainz_high_undead_summon.mp3` | 高阶亡灵召唤完成 | `1.8-2.8s` | 地下回应 + 法阵开启 + 重型亡灵落定 | `A supreme necromancer opening an ancient summoning circle, deep voices from below without words, grave pressure rising as one powerful undead servant materializes, isolated game sound effect, no music, no crowd screams` | 召唤点，`Reuse` | 规划 |
| P0 | `ainz_time_stop_activation.mp3` | 时间停止预展示结束、冻结生效 | `2.0-3.0s` | 环境快速抽空 + 低频时钟压力 + 真空锁定 | `The entire battlefield sound rapidly draining away as time is stopped, one deep clock-like pressure pulse and a vast vacuum lock, isolated cinematic game sound effect, no music, no ticking sequence, no bright chime, very soft high frequencies` | 安兹或场地中心，`Reuse` | 规划 |
| P0 | `ainz_fallen_down_charge.mp3` | 天空坠落持续聚能 | `2.5-4.0s` | 高空巨大法阵启动 + 白金能量持续下压 | `A colossal high-altitude platinum magic array activating and continuously concentrating divine arcane power downward, immense low pressure building with no release yet, isolated cinematic game sound effect, no music, no fire, no choir, no sharp hiss` | 目标区域中心，`Reuse` | 规划 |
| P0 | `ainz_fallen_down_pillar_impact.mp3` | 天空坠落光柱贯穿结算 | `1.5-2.4s` | 白金贯穿 + 深层地鸣 + 能量收束 | `A colossal platinum pillar of supreme magic piercing straight down and overwhelming the ground with deep arcane force, then collapsing inward, isolated game sound effect, no music, no fiery explosion, no piercing laser tone` | 目标区域中心，`Reuse` | 规划 |
| P1 | `ainz_all_life_death_countdown_pulse.mp3` | 一切生命的终点每段倒计时 | `0.45-0.75s` | 单次低沉法则脉冲，可重复播放 | `One short low pulse of an absolute death countdown, distant clock pressure and fading life resonance, isolated game sound effect, no music, no voice, no bright tick, no sharp transient` | 安兹或场地中心，`Reuse` | 规划 |
| P0 | `ainz_all_life_death_final_wave.mp3` | 一切生命的终点最终结算 | `2.2-3.5s` | 生命声消失 + 低频女妖死亡波 + 大范围归零 | `All living resonance vanishing at once under an absolute death law, a vast low spectral wail without human screaming and a deep wave leaving emptiness behind, isolated cinematic game sound effect, no music, no piercing shriek` | 场地中心，`Reuse` | 规划 |
| P1 | `ainz_albedo_guard_intercept.mp3` | 雅儿贝德护卫拦截 / 暗金屏障建立 | `1.0-1.6s` | 重甲切入 + 黑翼压风 + 暗金盾定型 | `A heavily armored dark-winged guardian intercepting an attack, broad black wing pressure and a dense dark-gold barrier locking in place, isolated game sound effect, no music, no sharp metal scrape` | 雅儿贝德或保护目标，`Reuse` | 规划 |

复用边界：时间停止后的三个延迟伤害继续使用各自技能声音，不把冻结音重复播放三次。天空坠落必须保留“聚能”和“贯穿”两个文件；十二段倒计时只复用同一个短脉冲，通过时序和音量塑造压力。

## 六、夏提雅·布拉德弗伦

听感核心：优雅而危险的长枪、低频血能汲取、苍白神圣净化、英灵延迟镜像和血月节拍。血系声音不使用黏腻咀嚼或大面积血浆表现。

| 优先级 | 文件名 | 技能 / 触发点 | 建议时长 | 分层方案 | 英文生成提示词 | 播放建议 | 状态 |
|--------|--------|---------------|----------|----------|------------------|----------|------|
| P1 | `shalltear_lance_dash_thrust.mp3` | 滴管穿心突进 | `0.9-1.4s` | 细长枪压风 + 短促穿刺 | `An elegant vampire lancer making a fast precise forward thrust, narrow air pressure and a short dense spear impact, isolated game sound effect, no music, no sharp metal scrape, no scream` | 夏提雅推进路径，`Reuse` | 规划 |
| P0 | `shalltear_spuit_lance_third_hit_drain.mp3` | 滴管三连第三击强化穿刺命中 | `1.0-1.5s` | 枪击主体 + 低频血能吸附回流 | `A precise heavy lance thrust followed by a short low blood-energy absorption flowing back into the weapon, elegant and dangerous, isolated game sound effect, no music, no gore, no wet chewing, no metal screech` | 命中目标，`Reuse` | 规划 |
| P1 | `shalltear_blood_mark_create.mp3` | 鲜血印记落地 | `0.7-1.1s` | 液态符文向内落定 + 心跳低音 | `A dark crimson liquid magic sigil settling onto the ground with one restrained low heartbeat, isolated game sound effect, no music, no gore, no sticky organic noise` | 血印坐标，`Reuse` | 规划 |
| P1 | `shalltear_blood_mark_reclaim.mp3` | 鲜血回收吸收剩余血印 | `1.5-2.3s` | 多条血能线收束 + 心跳加强 + 回流完成 | `Several dark crimson magical blood currents drawing smoothly inward toward a vampire lancer, low heartbeat pressure and a concise absorption finish, isolated game sound effect, no music, no gore, no wet chewing` | 夏提雅坐标，`Reuse` | 规划 |
| P0 | `shalltear_purifying_lance_impact.mp3` | 净化投枪落地及净化血印 | `1.0-1.6s` | 苍白神圣蓄能 + 高空枪落 + 向内净化爆点 | `A pale-gold holy lance descending from above and striking with a clean inward purification burst, restrained divine weight, isolated game sound effect, no music, no glass shatter, no piercing chime` | 投枪落点，`Reuse` | 规划 |
| P1 | `shalltear_valkyrie_echo_attack.mp3` | 英灵战乙女延迟复刻攻击 | `0.8-1.3s` | 比本体更轻、更空的枪影推进 | `A pale spectral valkyrie echo repeating a lance attack, lighter and more hollow than the original strike with a clean delayed phantom trail, isolated game sound effect, no music, no voice, no sharp highs` | 英灵位置，`Reuse` | 规划 |
| P1 | `shalltear_true_blood_feast_phase.mp3` | P3 真祖血宴阶段转换 | `1.8-2.8s` | 英灵回归 + 血印统一收束 + 真祖脉动 | `A spectral valkyrie merging back into a vampire noble as remaining crimson sigils converge, deep aristocratic blood power awakening in a controlled pulse, isolated game sound effect, no music, no scream, no gore` | 夏提雅坐标，`Reuse` | 规划 |
| P1 | `shalltear_blood_moon_start.mp3` | 血月终舞启动 | `1.5-2.4s` | 血月低频出现 + 四拍节奏引子 | `A dark crimson blood moon manifesting overhead with deep ritual pressure and the beginning of a clear four-beat combat rhythm, isolated cinematic game sound effect, no music, no choir, no scream` | 场地中心，`Reuse` | 规划 |
| P0 | `shalltear_blood_moon_final_dive.mp3` | 血月终舞第四轮后最终俯冲重击 | `1.2-1.9s` | 枪刃推进 + 高速俯冲 + 低频重击 | `An elegant vampire valkyrie completing a four-part lance dance with a final high-speed diving spear strike, deep crimson force and one heavy controlled impact, isolated game sound effect, no music, no metal screech` | 俯冲终点，`Reuse` | 规划 |
| P1 | `shalltear_resurrection_ritual_pulse.mp3` | 血之复生仪式循环脉动 | `0.8-1.2s` | 三枚结晶共同低频脉冲，可按剩余数量调音量 | `One restrained pulse from three dark crimson resurrection crystals, blood magic gathering toward a central vampire body with mounting low pressure, isolated game sound effect, no music, no heartbeat monitor, no scream` | 场地中心，`Reuse` | 规划 |
| P1 | `shalltear_resurrection_resolve.mp3` | 复生成功或三晶全毁失败收束 | `1.8-2.8s` | 建议分别生成成功回流与失败熄灭两个变体 | `A vampire resurrection ritual reaching its decisive resolution, crimson crystal energy either returning inward or fading into pale silence, deep controlled fantasy magic, isolated game sound effect, no music, no explosion, no scream` | 夏提雅坐标，`Reuse` | 规划 |

复用边界：滴管穿心和普通前两段枪击可以共用克制的枪击主体，但第三击必须带独立的汲血回流。英灵攻击只复用 `valkyrie_echo_attack`，不可直接与本体同音量叠放。复生成功与失败若单个候选无法同时表达清楚，应拆为两个最终文件。

## 七、首批生成清单

首批只生成最能校验四名 Boss 声音身份的 `12` 项，每项先生成 `2-3` 个变体。试听确认声音方向后，再制作 P1 项与拆层混音。

| 顺序 | Boss | 文件名 | 试听重点 |
|------|------|--------|----------|
| 1 | 亚伦柯斯 | `aronkos_soul_cleave_dash_hit.mp3` | 是否足够沉重，且没有刺耳金属摩擦。 |
| 2 | 亚伦柯斯 | `aronkos_fallen_spirit_impact.mp3` | 是否像英魂武器落墓土，而非火焰陨石。 |
| 3 | 亚伦柯斯 | `aronkos_duty_ends_defeat.mp3` | 是否有“职责结束”的安静收束。 |
| 4 | 双灵卫 | `twin_guards_oath_link_establish.mp3` | 暗金与冷蓝能否形成双色、双脉冲身份。 |
| 5 | 双灵卫 | `twin_guards_gate_validation_impact.mp3` | 是否同时有古门、重击与双灵确认感。 |
| 6 | 双灵卫 | `twin_guards_shared_breath_collapse.mp3` | 是否能表达抽离、崩散以及仍可回灌。 |
| 7 | 安兹 | `ainz_time_stop_activation.mp3` | 环境抽空和绝对停滞是否成立。 |
| 8 | 安兹 | `ainz_fallen_down_charge.mp3` + `ainz_fallen_down_pillar_impact.mp3` | 聚能与贯穿是否明确分层，且不是火焰爆炸。 |
| 9 | 安兹 | `ainz_all_life_death_final_wave.mp3` | 是否低沉、绝对且没有刺耳尖叫。 |
| 10 | 夏提雅 | `shalltear_spuit_lance_third_hit_drain.mp3` | 枪击与汲血回流能否一耳朵识别。 |
| 11 | 夏提雅 | `shalltear_purifying_lance_impact.mp3` | 苍白净化与普通血系攻击是否有明显区分。 |
| 12 | 夏提雅 | `shalltear_blood_moon_final_dive.mp3` | 是否适合四拍终舞后的最终重击。 |

## 八、确认、迁移与代码接入检查表

- [ ] 候选仅位于对应 `audio_temp/Boss/<BossKey>/SFX/`。
- [ ] 每个候选记录实际时长、变体编号和试听结论。
- [ ] 检查波形、峰值及 `3kHz-8kHz` 瞬态；必要时制作可听出差异的柔化版本。
- [ ] 复杂音效确认各层真实起点、高峰和尾音后再混音，不凭主观猜测偏移时间。
- [ ] 用户明确确认最终候选。
- [ ] 用户明确要求迁移后，才复制到 `imports/Sound/Boss/<BossKey>/SFX/`。
- [ ] 正式文件名去除候选变体歧义，并回填本记录的最终路径和状态。
- [ ] 在 Boss 公共表现配置中登记路径，不把路径散落到多个技能实现文件。
- [ ] 复用 `Sound3DII_CooPlayReuse`；接入前复查是否已有更具体的公共技能音效封装。
- [ ] 技能取消、阶段切换、团灭、挑战退出和 Boss 死亡时，不遗留循环音或延迟播放。
- [ ] TS 构建通过后检查生成 Lua 中的路径、播放入口和触发时点。
- [ ] 实机确认声音位置、距离衰减、重复播放限制及与 Voice 的互相遮蔽。

## 九、后续记录格式

每次生成或处理后，在对应条目旁补充以下信息，不另建散乱临时文档：

```text
候选绝对路径：
推荐变体：
实际时长：
后处理：
试听结论：
建议正式路径：
代码触发点：
当前状态：
```
