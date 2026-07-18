# 四 Boss SFX 制作与接入记录

> 适用 Boss：沉睡英魂·亚伦柯斯、祖地双灵卫、安兹·乌尔·恭、夏提雅·布拉德弗伦。
>
> 当前状态：历史规划与淘汰候选仍保留在本文档；本轮用户最终确认的 41 个 Boss SFX 已完成 64kbps 转码并迁移到 `imports/Sound`，尚未接入 TS 播放逻辑。

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
| P0 | `aronkos_soul_cleave_charge.mp3` | 亡冥英斩蓄势开始 | `0.8-1.2s` | 剑刃聚压 + 低频魂火吸附 | `Heavy ancient greatsword gathering compressed pale soul energy, restrained low rumble and dark air pressure, isolated dark fantasy game sound effect, no music, no voice, no bright metallic scrape, soft high frequencies` | Boss 坐标，`Reuse` | 确认（v2 候选 `_02`） |
| P0 | `aronkos_soul_cleave_dash_hit.mp3` | 亡冥英斩突进与主命中 | `1.0-1.5s` | 厚重压风 + 短促切入 + 苍白魂尾 | `A massive armored knight dashing with one heavy greatsword cleave, deep air displacement, short dense impact and pale spectral tail, isolated game sound effect, no music, no voice, no sharp metal screech` | Boss 推进路径中点或命中点，`Reuse` | 确认 |
| P1 | `aronkos_returning_soul_slash.mp3` | P3 归魂剑痕反向结算 | `0.8-1.2s` | 反向吸回 + 较轻魂刃掠过 | `A delayed spectral sword trail reawakening and sweeping backward along an old path, hollow pale soul rush with a controlled low impact, isolated game sound effect, no music, no piercing highs` | 回斩路径中点，`Reuse` | 确认（候选 `_02`） |
| P1 | `aronkos_fallen_spirit_descent.mp3` | 英灵陨星从高处坠落 | `1.3-2.0s` | 悠长魂体推进，不含落地爆点 | `A fallen knight spirit weapon descending from a great height, long grave-bound spectral pressure and cold air descent, isolated game sound effect, no music, no fireball whistle, no scream` | 落点，`Reuse` | 确认（v3 候选 `_01`） |
| P0 | `aronkos_fallen_spirit_impact.mp3` | 英灵陨星落地结算 | `0.9-1.4s` | 墓土震动 + 低矮魂爆 + 盔甲残响 | `A heavy spectral weapon striking grave soil, broad low impact, muted earth shock and distant ancient armor resonance, isolated game sound effect, no music, no fiery explosion, no sharp debris` | 落点，`Reuse` | 确认（候选 `_01`） |
| P1 | `aronkos_grave_gaze_release.mp3` | 亡者凝视正面扇形结算 | `0.8-1.2s` | 沉重魂压向外推出 | `A solemn undead knight releasing a broad forward wave of oppressive soul pressure, deep controlled push and cold spectral resonance, isolated game sound effect, no voice, no music, not a sonic boom` | Boss 坐标，`Reuse` | 确认（v7 自然尾音版） |
| P1 | `aronkos_tombstone_rest_complete.mp3` | 墓碑安魂完成 | `1.5-2.4s` | 符文逐层熄灭 + 魂火收束 + 轻微升空尾音 | `Ancient grave runes extinguishing one by one, pale soul flame folding inward and one peaceful spirit rising softly, isolated game sound effect, no music, no crystal shatter, no explosion` | 墓碑坐标，`Reuse` | 确认（v3 候选 `_02`） |
| P1 | `aronkos_undying_oath_awaken.mp3` | P3 不灭军魂 / 10% 最终强化 | `1.5-2.2s` | 铠甲低鸣 + 军魂聚拢 + 稳定收紧 | `An exhausted ancient oath knight gathering the last disciplined strength, deep armor resonance and many faint warrior spirits converging inward, isolated game sound effect, no voice, no music, no rage scream` | Boss 坐标，`Reuse` | 确认（v1 候选 `_01`） |
| P0 | `aronkos_duty_ends_defeat.mp3` | 正式战败归静 | `2.5-4.0s` | 剑甲落地 + 魂火离体 + 墓风归静 | `A greatsword and ancient armor settling heavily onto grave soil, pale soul fire slowly leaving the body, grave wind becoming peaceful with a final sense of duty fulfilled, isolated cinematic game sound effect, no music, no scream, no explosion` | Boss 死亡点，`Reuse` | 确认（候选 `_01`） |

复用边界：亡冥英斩普通命中与 P3 首次突进可共用 `dash_hit`；英魂残影斩击可降低音量复用 `returning_soul_slash`。英灵陨星的坠落和落地必须分开，以便与实际预警时间对齐。

## 四、祖地双灵卫

听感核心：赤誓灵卫使用暗金重剑、盾面和沉稳冲击；苍影灵卫使用冷蓝灵识、空灵镇魂与克制祷潮。双色誓链、净化成功和灵魂崩解必须能仅凭声音区分。

| 优先级 | 文件名 | 技能 / 触发点 | 建议时长 | 分层方案 | 英文生成提示词 | 播放建议 | 状态 |
|--------|--------|---------------|----------|----------|------------------|----------|------|
| P0 | `twin_guards_oath_link_establish.mp3` | 双灵同誓建立或重新连接 | `1.3-2.0s` | 暗金低鸣 + 冷蓝灵音 + 双脉冲稳定锁合 | `Two ancient guardian soul currents, one dark golden and heavy and one cold blue and ethereal, forming a stable oath link with two synchronized pulses, isolated fantasy game sound effect, no music, no electricity crackle, no bright chime` | 两 Boss 中点，`Reuse` | 确认 |
| P1 | `twin_guards_oath_link_protect.mp3` | 低血成员获得同誓保护 | `0.7-1.1s` | 誓链收紧 + 低沉护盾确认 | `An ancient dual-spirit oath chain tightening to protect a weakened guardian, restrained low shield resonance and paired soul pulse, isolated game sound effect, no music, no metallic ping` | 被保护 Boss，`Reuse` | 确认（v1 候选 `_01`） |
| P1 | `twin_guards_red_oath_shield_charge.mp3` | 誓锋壁进 / 赤誓蓄力推进 | `0.9-1.4s` | 重甲踏步 + 盾面压风 | `A massive ancient shield guardian bracing and driving forward, dark gold shield pressure, heavy armored step and dense low air push, isolated game sound effect, no music, no sharp metal scrape` | 赤誓 Boss，`Reuse` | 确认（候选 `_01`） |
| P1 | `twin_guards_azure_spirit_seal.mp3` | 镇魂印建立 / 苍影灵识锁定 | `1.0-1.6s` | 冷蓝灵识聚焦 + 克制封印落定 | `A cold blue ancestral spirit focusing into a precise soul-binding seal, hollow inward resonance and a soft low confirmation, isolated game sound effect, no music, no sparkling magic chimes` | 镇魂印落点，`Reuse` | 确认（候选 `_02`） |
| P0 | `twin_guards_gate_validation_impact.mp3` | 封门校验组合技重击结算 | `1.2-1.8s` | 盾剑重击 + 古门低鸣 + 双魂确认 | `Two ancestral guardians completing a gate trial with one enormous shield-and-blade impact, ancient stone gate resonance and paired spirit confirmation, isolated game sound effect, no music, no explosion, softened high frequencies` | 封门中心，`Reuse` | 确认（候选 `_02`） |
| P1 | `twin_guards_corruption_transform.mp3` | 侵蚀择形，首名守卫变异 | `1.8-2.8s` | 誓约失衡 + 魂体扭曲 + 低频断裂 | `An ancient guardian oath becoming corrupted, disciplined soul resonance bending out of alignment and breaking into a deep unstable form, isolated dark fantasy game sound effect, no music, no monster scream, no electrical crackle` | 变异 Boss，`Reuse` | 确认（v1 候选 `_01`） |
| P1 | `twin_guards_dual_key_purify.mp3` | 双钥净化节点成功 | `1.3-2.0s` | 暗金与月白先后进入 + 节点向内净化 | `A two-step ancestral purification, heavy dark-gold martial force followed by moon-white spiritual clarity, converging inward to cleanse one ancient gate node, isolated game sound effect, no music, no glass shatter` | 净化节点，`Reuse` | 确认（候选 `_02`） |
| P1 | `twin_guards_gate_misjudgment_break.mp3` | 封门误判安全窗出现 / Boss 易伤 | `0.8-1.3s` | 封门低鸣骤停 + 月白魂裂 | `An ancient soul gate realizing a false judgment, deep pressure abruptly releasing into a short moon-white spirit fracture and vulnerable opening, isolated game sound effect, no music, no glass crack, no piercing highs` | Boss 或封门中心，`Reuse` | 确认（v1 候选 `_02`） |
| P0 | `twin_guards_shared_breath_collapse.mp3` | 同息归寂首名崩解与最终同步收束 | `2.2-3.5s` | 双魂失同步 + 魂体抽离 + 可回灌尾流 | `Two bound ancestral guardian souls losing synchronization, one spirit body dispersing and being drawn away while a faint return current remains possible, deep solemn collapse, isolated game sound effect, no music, no scream, no explosion` | 两 Boss 中点，`Reuse` | 确认（候选 `_01`） |

复用边界：赤誓的普通盾击可复用 `shield_charge` 的主体层短版；苍影普通镇魂反馈可复用 `spirit_seal` 的轻量版。`oath_link_establish`、`dual_key_purify` 与 `shared_breath_collapse` 是 Boss 身份音，不跨 Boss 复用。

## 五、安兹·乌尔·恭

听感核心：绝对位阶的空间压力、白金高阶魔法、死亡法则和冷静控制。避免普通火球、廉价闪电、连续怪笑和刺耳人类尖叫。

| 优先级 | 文件名 | 技能 / 触发点 | 建议时长 | 分层方案 | 英文生成提示词 | 播放建议 | 状态 |
|--------|--------|---------------|----------|----------|------------------|----------|------|
| P1 | `ainz_reality_slash.mp3` | 现实断裂结算 | `0.8-1.3s` | 空间受压 + 深层撕开 + 短促闭合 | `Reality under immense magical pressure splitting open in one deep controlled fracture and closing sharply, isolated dark fantasy game sound effect, no music, no glass shatter, no electric crackle, soft high frequencies` | 裂缝中心，`Reuse` | 确认（候选 `_01`） |
| P1 | `ainz_grasp_heart.mp3` | 心脏掌握锁定与结算 | `1.0-1.6s` | 低频心跳骤紧 + 无形挤压 + 静默停顿 | `A distant low heartbeat seized by invisible supreme necromancy, pressure tightening inward followed by a brief dead silence, isolated game sound effect, no music, no gore, no human scream` | 目标位置，`Reuse` | 确认（候选 `_01`） |
| P1 | `ainz_greater_magic_arrow_six_arrow_volley.mp3` | 高阶魔法箭六箭连续离弦 | `0.45s` | 原生箭矢主冲击连续 6 次，每发 `75ms` | `Six rapid spectral arrow launches compressed into 0.45 seconds, clear repeated arrow-flight attacks with dry arcane character, isolated dark fantasy game sound effect, no music, no voice, no laser pew, no chime` | 安兹坐标，模型开始帧同步播放一次 | 确认（v8） |
| P1 | `ainz_brilliant_green_body.mp3` | 光辉翠绿体护盾建立 | `1.2-1.8s` | 翠绿法则展开 + 深沉护盾稳定 | `A supreme emerald defensive spell unfolding around an undead sorcerer, dense magical law locking into a calm resilient barrier, isolated game sound effect, no music, no glass shimmer, no bright chime` | 安兹坐标，`Reuse` | 确认（v2 候选 `_01`） |
| P1 | `ainz_high_undead_summon.mp3` | 高阶亡灵召唤完成 | `1.8-2.8s` | 地下回应 + 法阵开启 + 重型亡灵落定 | `A supreme necromancer opening an ancient summoning circle, deep voices from below without words, grave pressure rising as one powerful undead servant materializes, isolated game sound effect, no music, no crowd screams` | 召唤点，`Reuse` | 确认（候选 `_01`） |
| P0 | `ainz_time_stop_activation.mp3` | 时间停止预展示结束、冻结生效 | `2.0-3.0s` | 环境快速抽空 + 低频时钟压力 + 真空锁定 | `The entire battlefield sound rapidly draining away as time is stopped, one deep clock-like pressure pulse and a vast vacuum lock, isolated cinematic game sound effect, no music, no ticking sequence, no bright chime, very soft high frequencies` | 安兹或场地中心，`Reuse` | 确认 |
| P0 | `ainz_fallen_down_charge.mp3` | 天空坠落持续聚能 | `2.5-4.0s` | 高空巨大法阵启动 + 白金能量持续下压 | `A colossal high-altitude platinum magic array activating and continuously concentrating divine arcane power downward, immense low pressure building with no release yet, isolated cinematic game sound effect, no music, no fire, no choir, no sharp hiss` | 目标区域中心，`Reuse` | 确认（v2 候选 `_02`） |
| P0 | `ainz_fallen_down_pillar_impact.mp3` | 天空坠落光柱贯穿结算 | `1.5-2.4s` | 白金贯穿 + 深层地鸣 + 能量收束 | `A colossal platinum pillar of supreme magic piercing straight down and overwhelming the ground with deep arcane force, then collapsing inward, isolated game sound effect, no music, no fiery explosion, no piercing laser tone` | 目标区域中心，`Reuse` | 确认（候选 `_02`） |
| P1 | `ainz_all_life_death_countdown_pulse.mp3` | 一切生命的终点每段倒计时 | `0.45-0.75s` | 单次低沉法则脉冲，可重复播放 | `One short low pulse of an absolute death countdown, distant clock pressure and fading life resonance, isolated game sound effect, no music, no voice, no bright tick, no sharp transient` | 安兹或场地中心，`Reuse` | 确认（v2 候选 `_02`） |
| P0 | `ainz_all_life_death_final_wave.mp3` | 一切生命的终点最终结算 | `2.2-3.5s` | 生命声消失 + 低频女妖死亡波 + 大范围归零 | `All living resonance vanishing at once under an absolute death law, a vast low spectral wail without human screaming and a deep wave leaving emptiness behind, isolated cinematic game sound effect, no music, no piercing shriek` | 场地中心，`Reuse` | 确认（候选 `_02`） |
| P1 | `ainz_albedo_guard_intercept.mp3` | 雅儿贝德护卫拦截 / 暗金屏障建立 | `1.0-1.6s` | 重甲切入 + 黑翼压风 + 暗金盾定型 | `A heavily armored dark-winged guardian intercepting an attack, broad black wing pressure and a dense dark-gold barrier locking in place, isolated game sound effect, no music, no sharp metal scrape` | 雅儿贝德或保护目标，`Reuse` | 确认（v2 候选 `_01`） |

复用边界：时间停止后的三个延迟伤害继续使用各自技能声音，不把冻结音重复播放三次。天空坠落必须保留“聚能”和“贯穿”两个文件；十二段倒计时只复用同一个短脉冲，通过时序和音量塑造压力。

## 六、夏提雅·布拉德弗伦

听感核心：优雅而危险的长枪、低频血能汲取、苍白神圣净化、英灵延迟镜像和血月节拍。血系声音不使用黏腻咀嚼或大面积血浆表现。

| 优先级 | 文件名 | 技能 / 触发点 | 建议时长 | 分层方案 | 英文生成提示词 | 播放建议 | 状态 |
|--------|--------|---------------|----------|----------|------------------|----------|------|
| P1 | `shalltear_lance_dash_thrust.mp3` | 滴管穿心突进 | `0.9-1.4s` | 细长枪压风 + 短促穿刺 | `An elegant vampire lancer making a fast precise forward thrust, narrow air pressure and a short dense spear impact, isolated game sound effect, no music, no sharp metal scrape, no scream` | 夏提雅推进路径，`Reuse` | 确认（候选 `_01`） |
| P0 | `shalltear_spuit_lance_third_hit_drain.mp3` | 滴管三连第三击强化穿刺命中 | `1.0-1.5s` | 穿刺命中候选 2 + 原生吸血药水回流音 | `A precise heavy lance thrust followed by a short low blood-energy absorption flowing back into the weapon, elegant and dangerous, isolated game sound effect, no music, no gore, no wet chewing, no metal screech` | 命中目标，`Reuse` | 确认（原生吸血音混音） |
| P0 | `shalltear_spuit_lance_thrust_impact.mp3` | 滴管三连第三击穿刺命中层 | `0.7-1.1s` | 细长枪压风 + 干净穿刺命中 | `A single precise heavy spear thrust striking a hard target, narrow fast air displacement followed by a dense clean penetration impact, elegant vampire lancer, isolated game sound effect, no blood magic, no absorption, no wet sound, no music, no voice, no sharp metal screech` | 命中目标，`Reuse` | 中间候选（采用 `_02`） |
| P0 | `shalltear_spuit_lance_blood_drain.mp3` | 滴管三连第三击汲血回流层 | `0.8-1.2s` | 暗红血能反向吸附 + 低频回流确认 | `Dark crimson magical blood energy smoothly draining backward from a struck target into an elegant vampire lance, a low controlled suction and a refined reverse-flow pulse, isolated game sound effect, no spear thrust, no impact, no gore, no wet chewing, no heartbeat monitor, no music, no voice` | 命中目标，延迟叠放，`Reuse` | 中间候选（未采用） |
| P1 | `shalltear_blood_mark_create.mp3` | 鲜血印记落地 | `0.7-1.1s` | 液态符文向内落定 + 心跳低音 | `A dark crimson liquid magic sigil settling onto the ground with one restrained low heartbeat, isolated game sound effect, no music, no gore, no sticky organic noise` | 血印坐标，`Reuse` | 确认（v2 候选 `_01`） |
| P1 | `shalltear_blood_mark_reclaim.mp3` | 鲜血回收吸收剩余血印 | `1.5-2.3s` | 多条血能线收束 + 心跳加强 + 回流完成 | `Several dark crimson magical blood currents drawing smoothly inward toward a vampire lancer, low heartbeat pressure and a concise absorption finish, isolated game sound effect, no music, no gore, no wet chewing` | 夏提雅坐标，`Reuse` | 候选 |
| P0 | `shalltear_purifying_lance_impact.mp3` | 净化投枪落地及净化血印 | `1.0-1.6s` | 投枪命中层 + 血印净化层，拆分后合成 | `A pale-gold holy lance descending from above and striking with a clean inward purification burst, restrained divine weight, isolated game sound effect, no music, no glass shatter, no piercing chime` | 投枪落点，`Reuse` | 确认（合成 v2 `_01`） |
| P1 | `shalltear_valkyrie_echo_attack.mp3` | 英灵战乙女延迟复刻攻击 | `0.8-1.3s` | 比本体更轻、更空的枪影推进 | `A pale spectral valkyrie echo repeating a lance attack, lighter and more hollow than the original strike with a clean delayed phantom trail, isolated game sound effect, no music, no voice, no sharp highs` | 英灵位置，`Reuse` | 确认（v2 候选 `_01`） |
| P1 | `shalltear_true_blood_feast_phase.mp3` | P3 真祖血宴阶段转换 | `1.8-2.8s` | 英灵回归 + 血印统一收束 + 真祖脉动 | `A spectral valkyrie merging back into a vampire noble as remaining crimson sigils converge, deep aristocratic blood power awakening in a controlled pulse, isolated game sound effect, no music, no scream, no gore` | 夏提雅坐标，`Reuse` | 确认（v2 候选 `_01`） |
| P1 | `shalltear_blood_moon_start.mp3` | 血月终舞启动 | `1.5-2.4s` | 血月低频出现 + 四拍节奏引子 | `A dark crimson blood moon manifesting overhead with deep ritual pressure and the beginning of a clear four-beat combat rhythm, isolated cinematic game sound effect, no music, no choir, no scream` | 场地中心，`Reuse` | 确认（v1 候选 `_01`） |
| P0 | `shalltear_blood_moon_final_dive.mp3` | 血月终舞第四轮后最终俯冲重击 | `1.2-1.9s` | 枪刃推进 + 高速俯冲 + 低频重击，去除人声 | `An elegant vampire valkyrie completing a four-part lance dance with a final high-speed diving spear strike, deep crimson force and one heavy controlled impact, isolated game sound effect, no music, no voice, no vocal, no choir, no scream, no human sound, no metal screech` | 俯冲终点，`Reuse` | 确认（v2 候选 `_01`） |
| P1 | `shalltear_resurrection_ritual_pulse.mp3` | 血之复生仪式循环脉动 | `0.8-1.2s` | 三枚结晶共同低频脉冲，可按剩余数量调音量 | `One restrained pulse from three dark crimson resurrection crystals, blood magic gathering toward a central vampire body with mounting low pressure, isolated game sound effect, no music, no heartbeat monitor, no scream` | 场地中心，`Reuse` | 确认（手工 v3 纯合成） |
| P1 | `shalltear_resurrection_resolve.mp3` | 复生成功或三晶全毁失败收束 | `1.8-2.8s` | 建议分别生成成功回流与失败熄灭两个变体 | `A vampire resurrection ritual reaching its decisive resolution, crimson crystal energy either returning inward or fading into pale silence, deep controlled fantasy magic, isolated game sound effect, no music, no explosion, no scream` | 夏提雅坐标，`Reuse` | 确认（手工 v5 成功/失败分支） |

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
| 10 | 夏提雅 | `shalltear_spuit_lance_third_hit_drain.mp3` | 穿刺命中后接原生吸血药水回流音，整体是否自然。 |
| 11 | 夏提雅 | `shalltear_purifying_lance_impact.mp3` | 苍白净化与普通血系攻击是否有明显区分。 |
| 12 | 夏提雅 | `shalltear_blood_moon_final_dive.mp3` | 是否适合四拍终舞后的最终重击。 |

## 八、首批试听确认与拆层记录（2026-07-17）

以下确认仅表示试听候选通过，仍未迁移到 `imports/Sound`，也未接入 TS。

### 已确认候选

- 亡冥英斩突进与主命中
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_soul_cleave_dash_hit_02.mp3`
  - 推荐变体：`_02`
  - 实际时长：`1.28s`
  - 后处理：无
  - 试听结论：用户确认候选 2 可用，保持沉重骑士突进与主命中方向。
  - 建议正式路径：`imports/Sound/Boss/Aronkos/SFX/aronkos_soul_cleave_dash_hit.mp3`
  - 代码触发点：亡冥英斩突进与主命中点
  - 当前状态：`确认`

- 双灵同誓建立或重新连接
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_oath_link_establish_02.mp3`
  - 推荐变体：`_02`
  - 实际时长：`1.68s`
  - 后处理：无
  - 试听结论：用户确认候选 2 可用，保持暗金与冷蓝双灵、双脉冲锁合方向。
  - 建议正式路径：`imports/Sound/Boss/AncestralTwinGuards/SFX/twin_guards_oath_link_establish.mp3`
  - 代码触发点：双灵同誓建立或重新连接
  - 当前状态：`确认`

- 时间停止冻结生效
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_time_stop_activation_02.mp3`
  - 推荐变体：`_02`
  - 实际时长：`2.40s`
  - 后处理：无
  - 试听结论：用户确认候选 2 可用，保持环境抽空、低频压力与真空锁定方向。
  - 建议正式路径：`imports/Sound/Boss/Ainz/SFX/ainz_time_stop_activation.mp3`
  - 代码触发点：时间停止预展示结束、冻结生效
  - 当前状态：`确认`

### 夏提雅滴管穿心拆层候选

- 穿刺命中层
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\_layers\shalltear_spuit_lance_thrust_impact_01.mp3`、`..._02.mp3`
  - 推荐变体：待试听
  - 实际时长：`1.00s`
  - 后处理：无
  - 试听结论：原“穿刺＋汲血”混合候选全部否决，改为独立穿刺命中层。
  - 建议正式路径：待确认后决定
  - 代码触发点：滴管三连第三击穿刺命中
  - 当前状态：`候选`

- 汲血回流层
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\_layers\shalltear_spuit_lance_blood_drain_01.mp3`、`..._02.mp3`
  - 推荐变体：待试听
  - 实际时长：`1.08s`
  - 后处理：无
  - 试听结论：原“穿刺＋汲血”混合候选全部否决，改为独立汲血回流层。
  - 建议正式路径：待确认后决定
  - 代码触发点：滴管三连第三击命中后的汲血回流，可按实际命中时点延迟叠放
  - 当前状态：`候选`

### 夏提雅最终试听确认与候选历史

- 最终确认文件
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_spuit_lance_third_hit_native_potion_full_volume.mp3`
  - 逻辑文件名：`shalltear_spuit_lance_third_hit_drain.mp3`
  - 推荐变体：穿刺命中候选 2 + 原生吸血药水音
  - 实际时长：`2.059501s`
  - 后处理：穿刺命中候选 2 作为前段，底层降低 `6dB`；原始吸血 WAV 保持 `0dB`，延迟 `260ms` 进入；统一为 `44100Hz` 立体声 `mp3_44100_128`，仅做峰值保护。
  - 试听结论：用户选择第一版全音量混音。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_spuit_lance_third_hit_drain.mp3`
  - 代码触发点：滴管三连第三击命中目标后，穿刺与汲血回流作为同一技能结算音效播放。
  - 当前状态：`确认`

- 原始吸血素材
  - 源文件：`C:\Users\Administrator\Desktop\吸血魔法_爱给网_aigei_com.wav`
  - 规格：`22050Hz`、单声道、`1.799501s`、源峰值约 `-4.8dB`
  - 用途：替代 AI 生成的汲血回流层，作为魔兽原生吸血药水风格的回流主体。
  - 当前状态：`试听源，未迁移`

- 已否决的完整混合候选
  - `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_spuit_lance_third_hit_drain_01.mp3`
  - `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_spuit_lance_third_hit_drain_02.mp3`
  - 结论：原 AI 生成的“穿刺命中 + 汲血回流”混合方向不符合夏提雅的吸血感觉，全部否决。

- 已生成的分层候选
  - 穿刺命中：`...\_layers\shalltear_spuit_lance_thrust_impact_01.mp3`、`..._02.mp3`；采用 `_02` 作为最终混音前段。
  - AI 汲血回流：`...\_layers\shalltear_spuit_lance_blood_drain_01.mp3`、`..._02.mp3`；因加入原生吸血素材，未作为最终回流层。

- 已生成的混音对照版本
  - `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_spuit_lance_third_hit_native_potion_mix.mp3`：旧版，吸血源降低 `2dB`，不采用。
  - `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_spuit_lance_old_candidate2_native_potion_mix.mp3`：旧完整候选 2 混音版，吸血源降低 `3dB`，不采用。
- `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_spuit_lance_old_candidate2_native_potion_full_volume.mp3`：旧完整候选 2 的全音量对照版，未采用。

### 第二批生成候选（2026-07-17）

本批共 9 个机制音，每项 2 个候选；候选均为 `mp3_44100_128`、`44100Hz`、立体声，尚未试听确认、迁移或接入代码。

- 亚伦柯斯·英灵陨星落地结算
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_fallen_spirit_impact_01.mp3`、`..._02.mp3`
  - 实际时长：`1.20s`
  - 后处理：无
  - 试听重点：墓土震动、低矮魂爆、盔甲残响；不要像火焰陨石。
  - 建议正式路径：`imports/Sound/Boss/Aronkos/SFX/aronkos_fallen_spirit_impact.mp3`
  - 当前状态：`候选`

- 亚伦柯斯·正式战败归静
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_duty_ends_defeat_01.mp3`、`..._02.mp3`
  - 实际时长：`3.20s`
  - 后处理：无
  - 试听重点：剑甲落地、魂火离体、墓风归静和职责结束感。
  - 建议正式路径：`imports/Sound/Boss/Aronkos/SFX/aronkos_duty_ends_defeat.mp3`
  - 当前状态：`候选`

- 祖地双灵卫·封门校验组合技重击结算
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_gate_validation_impact_01.mp3`、`..._02.mp3`
  - 实际时长：`1.48s`
  - 后处理：无
  - 试听重点：盾剑重击、古门低鸣、双魂确认必须同时成立。
  - 建议正式路径：`imports/Sound/Boss/AncestralTwinGuards/SFX/twin_guards_gate_validation_impact.mp3`
  - 当前状态：`候选`

- 祖地双灵卫·同息归寂
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_shared_breath_collapse_01.mp3`、`..._02.mp3`
  - 实际时长：`2.76s`
  - 后处理：无
  - 试听重点：双魂失同步、抽离崩散以及仍可回灌的尾流。
  - 建议正式路径：`imports/Sound/Boss/AncestralTwinGuards/SFX/twin_guards_shared_breath_collapse.mp3`
  - 当前状态：`候选`

- 安兹·天空坠落持续聚能
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_fallen_down_charge_01.mp3`、`..._02.mp3`
  - 实际时长：`3.20s`
  - 后处理：无
  - 试听重点：高空白金法阵持续下压，不能提前爆发、不能像火焰或合唱。
  - 建议正式路径：`imports/Sound/Boss/Ainz/SFX/ainz_fallen_down_charge.mp3`
  - 当前状态：`候选`

- 安兹·天空坠落光柱贯穿结算
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_fallen_down_pillar_impact_01.mp3`、`..._02.mp3`
  - 实际时长：`1.88s`
  - 后处理：无
  - 试听重点：白金贯穿、深层地鸣、能量收束；不能像激光或火焰爆炸。
  - 建议正式路径：`imports/Sound/Boss/Ainz/SFX/ainz_fallen_down_pillar_impact.mp3`
  - 当前状态：`候选`

- 安兹·一切生命的终点最终结算
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_all_life_death_final_wave_01.mp3`、`..._02.mp3`
  - 实际时长：`2.76s`
  - 后处理：无
  - 试听重点：生命声归零、低沉死亡波和绝对法则感；不能出现尖叫。
  - 建议正式路径：`imports/Sound/Boss/Ainz/SFX/ainz_all_life_death_final_wave.mp3`
  - 当前状态：`候选`

- 夏提雅·净化投枪落地及净化血印
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_purifying_lance_impact_01.mp3`、`..._02.mp3`
  - 实际时长：`1.28s`
  - 后处理：无
  - 试听重点：苍白神圣净化，和血系吸收音明确区分。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_purifying_lance_impact.mp3`
  - 当前状态：`候选`

- 夏提雅·血月终舞最终俯冲重击
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_moon_final_dive_01.mp3`、`..._02.mp3`
  - 实际时长：`1.60s`
  - 后处理：无
  - 试听重点：四拍终舞后的高速俯冲、优雅枪刃和低频重击；不要尖锐金属声。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_blood_moon_final_dive.mp3`
  - 当前状态：`候选`

校验备注：`ffprobe` 已确认本批文件格式、采样率、声道和时长；逐文件 `volumedetect` 扫描在串行批处理时超时，未据此筛选候选，试听后再做针对性峰值和高频处理。

### 第二批试听确认与返工记录（2026-07-18）

#### 已确认

- 亚伦柯斯·英灵陨星落地结算：`aronkos_fallen_spirit_impact_01.mp3`，用户选择候选 1。
- 亚伦柯斯·正式战败归静：`aronkos_duty_ends_defeat_01.mp3`，用户选择候选 1。
- 祖地双灵卫·封门校验组合技重击结算：`twin_guards_gate_validation_impact_02.mp3`，用户选择候选 2。
- 祖地双灵卫·同息归寂：`twin_guards_shared_breath_collapse_01.mp3`，用户选择候选 1。
- 安兹·天空坠落光柱贯穿结算：`ainz_fallen_down_pillar_impact_02.mp3`，用户选择候选 2。
- 安兹·一切生命的终点最终结算：`ainz_all_life_death_final_wave_02.mp3`，用户选择候选 2。

以上文件仍只处于 `确认`，未迁入 `imports/Sound`，未接入代码。

#### 返工项

- 安兹·天空坠落持续聚能：原候选缺少可辨识的高空法阵持续嗡鸣，原候选 1/2 均不作为最终版；返工时必须加入持续、低沉、可听见的法阵共鸣嗡鸣，并保持能量尚未释放。
- 夏提雅·净化投枪落地及净化血印：原候选的净化部分偏单一音符，不符合血印被净化的连续收束感；拆为“投枪命中层”和“血印净化层”后再合成，净化层禁止单一提示音和明亮音符。
- 夏提雅·血月终舞最终俯冲重击：原候选出现人声，不作为最终版；返工提示词必须明确禁止人声、歌声、合唱、尖叫和任何人类发声。

#### 返工候选

- 安兹·天空坠落持续聚能 v2
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_fallen_down_charge_v2_01.mp3`、`..._02.mp3`
  - 实际时长：`3.20s`
  - 后处理：无
  - 试听重点：持续、低沉、可辨识的高空法阵嗡鸣，能量只聚集不释放。
  - 当前状态：`返工候选`

- 夏提雅·净化投枪命中层
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\_layers\shalltear_purifying_lance_impact_layer_01.mp3`、`..._02.mp3`
  - 实际时长：`1.00s`
  - 后处理：作为合成前段，混音时底层降低 `5dB`。
  - 当前状态：`中间候选`

- 夏提雅·血印净化层
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\_layers\shalltear_blood_mark_purification_01.mp3`、`..._02.mp3`
  - 实际时长：`1.20s`
  - 后处理：作为合成后段，延迟 `220ms`，保持原音量；禁止单音符和明亮提示音。
  - 当前状态：`中间候选`

- 夏提雅·净化投枪与血印净化合成试听
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_purifying_lance_impact_v2_01.mp3`、`..._02.mp3`
  - 实际时长：`1.42s`
  - 后处理：分别使用同编号的投枪命中层与血印净化层；命中先出，净化延迟 `220ms`。
  - 建议正式路径：待试听确认后回填 `imports/Sound/Boss/Shalltear/SFX/shalltear_purifying_lance_impact.mp3`
  - 当前状态：`返工候选`

- 夏提雅·血月终舞最终俯冲 v2
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_moon_final_dive_v2_01.mp3`、`..._02.mp3`
  - 实际时长：`1.60s`
  - 后处理：无；提示词明确禁止人声、歌声、合唱、尖叫和动物声。
  - 当前状态：`返工候选`

#### 返工确认（2026-07-18）

- 安兹·天空坠落持续聚能
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_fallen_down_charge_v2_02.mp3`
  - 推荐变体：v2 候选 2
  - 实际时长：`3.20s`
  - 后处理：无
  - 试听结论：用户确认，法阵持续嗡鸣方向可用。
  - 建议正式路径：`imports/Sound/Boss/Ainz/SFX/ainz_fallen_down_charge.mp3`
  - 代码触发点：天空坠落持续聚能阶段
  - 当前状态：`确认`

- 夏提雅·净化投枪落地及净化血印
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_purifying_lance_impact_v2_01.mp3`
  - 推荐变体：合成 v2 候选 1
  - 实际时长：`1.42s`
  - 后处理：投枪命中层与血印净化层合成；命中先出，净化层延迟 `220ms`，净化层保持原音量。
  - 试听结论：用户确认，拆分合成方向可用。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_purifying_lance_impact.mp3`
  - 代码触发点：净化投枪落地并净化血印
  - 当前状态：`确认`

- 夏提雅·血月终舞最终俯冲重击
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_moon_final_dive_v2_01.mp3`
  - 推荐变体：v2 候选 1
  - 实际时长：`1.60s`
  - 后处理：无；提示词明确禁止人声、歌声、合唱、尖叫和动物声。
  - 试听结论：用户确认，去除人声后的最终俯冲方向可用。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_blood_moon_final_dive.mp3`
  - 代码触发点：血月终舞第四轮后的最终俯冲重击
  - 当前状态：`确认`

### 第三批生成候选（2026-07-18）

本批补齐已确认主机制之间的关键起手、锁定、回收与召唤反馈。每项 2 个候选，均为 `mp3_44100_128`、`44100Hz`、立体声；无后处理、尚未试听确认。

- 亚伦柯斯·亡冥英斩蓄势开始
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_soul_cleave_charge_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_soul_cleave_charge_02.mp3`
  - 实际时长：`1.00s`
  - 建议正式路径：`imports/Sound/Boss/Aronkos/SFX/aronkos_soul_cleave_charge.mp3`
  - 当前状态：`候选`

- 亚伦柯斯·P3 归魂剑痕反向结算
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_returning_soul_slash_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_returning_soul_slash_02.mp3`
  - 实际时长：`1.00s`
  - 建议正式路径：`imports/Sound/Boss/Aronkos/SFX/aronkos_returning_soul_slash.mp3`
  - 当前状态：`候选`

- 亚伦柯斯·英灵陨星从高处坠落
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_fallen_spirit_descent_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_fallen_spirit_descent_02.mp3`
  - 实际时长：`1.60s`
  - 建议正式路径：`imports/Sound/Boss/Aronkos/SFX/aronkos_fallen_spirit_descent.mp3`
  - 当前状态：`候选`

- 祖地双灵卫·赤誓灵卫盾锋壁进
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_red_oath_shield_charge_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_red_oath_shield_charge_02.mp3`
  - 实际时长：`1.08s`
  - 建议正式路径：`imports/Sound/Boss/AncestralTwinGuards/SFX/twin_guards_red_oath_shield_charge.mp3`
  - 当前状态：`候选`

- 祖地双灵卫·苍影灵卫镇魂印建立
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_azure_spirit_seal_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_azure_spirit_seal_02.mp3`
  - 实际时长：`1.28s`
  - 建议正式路径：`imports/Sound/Boss/AncestralTwinGuards/SFX/twin_guards_azure_spirit_seal.mp3`
  - 当前状态：`候选`

- 祖地双灵卫·双钥净化节点成功
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_dual_key_purify_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_dual_key_purify_02.mp3`
  - 实际时长：`1.60s`
  - 建议正式路径：`imports/Sound/Boss/AncestralTwinGuards/SFX/twin_guards_dual_key_purify.mp3`
  - 当前状态：`候选`

- 安兹·现实断裂结算
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_reality_slash_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_reality_slash_02.mp3`
  - 实际时长：`1.08s`
  - 建议正式路径：`imports/Sound/Boss/Ainz/SFX/ainz_reality_slash.mp3`
  - 当前状态：`候选`

- 安兹·心脏掌握锁定与结算
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_grasp_heart_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_grasp_heart_02.mp3`
  - 实际时长：`1.28s`
  - 建议正式路径：`imports/Sound/Boss/Ainz/SFX/ainz_grasp_heart.mp3`
  - 当前状态：`候选`

- 安兹·高阶亡灵召唤完成
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_high_undead_summon_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_high_undead_summon_02.mp3`
  - 实际时长：`2.20s`
  - 建议正式路径：`imports/Sound/Boss/Ainz/SFX/ainz_high_undead_summon.mp3`
  - 当前状态：`候选`

- 夏提雅·滴管穿心突进
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_lance_dash_thrust_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_lance_dash_thrust_02.mp3`
  - 实际时长：`1.08s`
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_lance_dash_thrust.mp3`
  - 当前状态：`候选`

- 夏提雅·鲜血回收吸收剩余血印
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_02.mp3`
  - 实际时长：`1.88s`
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_blood_mark_reclaim.mp3`
  - 当前状态：`候选`

- 夏提雅·英灵战乙女延迟复刻攻击
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_valkyrie_echo_attack_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_valkyrie_echo_attack_02.mp3`
  - 实际时长：`1.00s`
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_valkyrie_echo_attack.mp3`
  - 当前状态：`候选`

### 第三批试听确认与待返工（2026-07-18）

#### 已确认

- 亚伦柯斯·P3 归魂剑痕反向结算：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_returning_soul_slash_02.mp3`，用户选择候选 2。
- 亚伦柯斯·亡冥英斩蓄势：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_soul_cleave_charge_v2_02.mp3`，用户选择返工候选 2。
- 亚伦柯斯·英灵陨星坠落：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_fallen_spirit_descent_v3_01.mp3`，用户确认 v3 候选 1。
- 祖地双灵卫·赤誓灵卫盾锋壁进：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_red_oath_shield_charge_01.mp3`，用户选择候选 1。
- 祖地双灵卫·苍影灵卫镇魂印建立：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_azure_spirit_seal_02.mp3`，用户选择候选 2。
- 祖地双灵卫·双钥净化节点成功：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_dual_key_purify_02.mp3`，用户选择候选 2。
- 安兹·现实断裂结算：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_reality_slash_01.mp3`，用户选择候选 1。
- 安兹·心脏掌握锁定与结算：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_grasp_heart_01.mp3`，用户选择候选 1。
- 安兹·高阶亡灵召唤完成：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_high_undead_summon_01.mp3`，用户选择候选 1。
- 夏提雅·滴管穿心突进：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_lance_dash_thrust_01.mp3`，用户选择候选 1。
- 夏提雅·英灵战乙女延迟复刻攻击：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_valkyrie_echo_attack_v2_01.mp3`，用户选择返工候选 1。

#### 待返工或未确认

- 夏提雅·鲜血回收吸收剩余血印：`shalltear_blood_mark_reclaim_02.mp3`，用户选择候选 2。

#### 第三批返工候选（2026-07-18）

- 亚伦柯斯·亡冥英斩蓄势：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_soul_cleave_charge_v2_01.mp3`、`..._v2_02.mp3`；`1.60s`。改为三段式剑压收紧与魂火吸附，临界前停止，尚待试听。
- 亚伦柯斯·英灵陨星坠落：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_fallen_spirit_descent_v2_01.mp3`、`..._v2_02.mp3`；`2.68s`。改为高空魂体持续压场、加速逼近的坠压，不含落地爆点，尚待试听。
- 亚伦柯斯·英灵陨星坠落 v3：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_fallen_spirit_descent_v3_01.mp3`；`1.00s`。按现有落点预警窗口重制：由远及近、连续加速、临界前截断，不含命中或爆点，尚待试听。
- 夏提雅·英灵战乙女延迟复刻攻击：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_valkyrie_echo_attack_v2_01.mp3`、`..._v2_02.mp3`；`1.28s`。改为轻空的延迟枪影，提示词明确排除人声、呼吸、低语与所有生物发声，尚待试听。

### 第四批生成候选（2026-07-18）

本批共 8 个未完成核心机制、每项 2 个候选；全部为 `mp3_44100_128`、`44100Hz`、立体声，尚未试听确认、迁移或接入代码。

- 亚伦柯斯·亡者凝视正面扇形结算
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_grave_gaze_release_v1_01.mp3`、`..._v1_02.mp3`
  - 实际时长：`1.08s`
  - 试听重点：正面、沉重的亡者魂压外推，不应像爆炸或音爆。

- 亚伦柯斯·墓碑安魂完成
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_tombstone_rest_complete_v1_01.mp3`、`..._v1_02.mp3`
  - 实际时长：`2.08s`
  - 试听重点：符文熄灭、魂火收束与平静升空，不应像水晶破裂。

- 祖地双灵卫·同誓保护触发
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_oath_link_protect_v1_01.mp3`、`..._v1_02.mp3`
  - 实际时长：`1.00s`
  - 试听重点：双魂誓链收紧后形成低沉护盾确认，避免金属叮响。

- 祖地双灵卫·侵蚀择形变异
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_corruption_transform_v1_01.mp3`、`..._v1_02.mp3`
  - 实际时长：`2.28s`
  - 试听重点：纪律性的双魂共鸣失衡、扭曲、断裂后沉入变异，不应有怪叫或电流。

- 安兹·高阶魔法箭生成与发射
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_greater_magic_arrow_volley_v1_01.mp3`、`..._v1_02.mp3`
  - 实际时长：`1.28s`
  - 试听重点：多枚白金法箭严整成形后齐射，避免激光或清脆风铃感。

- 安兹·光辉翠绿体护盾建立
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_brilliant_green_body_v1_01.mp3`、`..._v1_02.mp3`
  - 实际时长：`1.48s`
  - 试听重点：翠绿法则展开后稳定锁定，应是沉着的防御法术而非玻璃亮片。

- 夏提雅·鲜血印记落地
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_create_v1_01.mp3`、`..._v1_02.mp3`
  - 实际时长：`0.88s`
  - 试听重点：血能细线向内落定，一次克制的低频确认；不可黏腻或血腥。

- 夏提雅·真祖血宴阶段转换
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_true_blood_feast_phase_v1_01.mp3`、`..._v1_02.mp3`
  - 实际时长：`2.28s`
  - 试听重点：战乙女回归、血印收束、真祖力量苏醒；避免人声、尖叫和爆炸。

#### 第四批试听确认与返工（2026-07-18）

- 祖地双灵卫·同誓保护触发：`twin_guards_oath_link_protect_v1_01.mp3`，用户选择候选 1。
- 祖地双灵卫·侵蚀择形变异：`twin_guards_corruption_transform_v1_01.mp3`，用户选择候选 1。
- 安兹·光辉翠绿体护盾建立：`ainz_brilliant_green_body_v2_01.mp3`，用户选择候选 1。
- 夏提雅·鲜血印记落地：`shalltear_blood_mark_create_v2_01.mp3`，用户选择候选 1。
- 夏提雅·真祖血宴阶段转换：`shalltear_true_blood_feast_phase_v2_01.mp3`，用户选择候选 1。
- 亚伦柯斯·墓碑安魂完成：`aronkos_tombstone_rest_complete_v3_02.mp3`，用户选择候选 2。
- 亚伦柯斯·亡者凝视正面扇形结算：`aronkos_grave_gaze_release_v7_loud_natural_tail.mp3`，用户确认自然尾音版。
- 安兹·高阶魔法箭六箭连续离弦：`ainz_greater_magic_arrow_six_arrow_model_sync_v8_fast_peak.mp3`，用户确认立即播放版。
- 亚伦柯斯·墓碑安魂：v2 候选仍带玻璃感，待重做。
- 安兹·高阶魔法箭：v2 候选没有明确箭矢离弦；模型内部有 6 支箭先后坠落，应使用单次播放、内部连续六发的组合音，待试听确认。
- 亚伦柯斯·亡者凝视：以 v2 候选 2 为基础，待提高约 `3.5dB` 后试听。

#### 第四批返工候选（2026-07-18）

- 亚伦柯斯·亡者凝视：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_grave_gaze_release_v2_01.mp3`、`..._v2_02.mp3`；`1.00s`。改为完整可闻的中低频魂压外推，平均声压相对 v1 提升约 `7.3dB`。
- 亚伦柯斯·墓碑安魂完成：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_tombstone_rest_complete_v2_01.mp3`、`..._v2_02.mp3`；`2.00s`。改为可清楚听见的符文熄灭、魂火收束、安静升空，平均声压相对 v1 提升约 `14.7dB`。
- 安兹·高阶魔法箭齐射：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_greater_magic_arrow_volley_v2_01.mp3`、`..._v2_02.mp3`；`1.20s`。改为严整法阵成形后的清晰同步齐射。
- 安兹·光辉翠绿体护盾建立：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_brilliant_green_body_v2_01.mp3`、`..._v2_02.mp3`；`1.36s`。改为有重量的翠绿法则展开并锁入坚实护盾。
- 夏提雅·鲜血印记落地：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_create_v2_01.mp3`、`..._v2_02.mp3`；`0.88s`。改为血能细线落地、向内封印与明确低频确认。
- 夏提雅·真祖血宴阶段转换：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_true_blood_feast_phase_v2_01.mp3`、`..._v2_02.mp3`；`2.20s`。提示词已明确排除人声、歌声、呼吸、低语和一切生物发声，尚待试听。
- 亚伦柯斯·墓碑安魂完成 v3：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_tombstone_rest_complete_v3_01.mp3`、`..._v3_02.mp3`；`1.76s`。改为石墓沉降、魂火收束与墓风升空，明确排除玻璃、水晶、碎片和铃音，尚待试听。
- 安兹·高阶魔法箭每轮离弦 v3：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_greater_magic_arrow_launch_v3_01.mp3`、`..._v3_02.mp3`；`0.48s`。已淘汰：单发箭声不足以表现单个模型内部连续落下的 6 支箭。
- 亚伦柯斯·亡者凝视提高响度版：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_grave_gaze_release_v3_02_boosted.mp3`；`1.00s`。基于 v2 候选 2 提高 `3.5dB`，平均声压 `-12.0dB`、峰值 `-1.2dB`，尚待试听。
- 亚伦柯斯·亡者凝视整体抬升 v5：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_grave_gaze_release_v5_02_loud.mp3`；`1.00s`。基于 v2 候选 2 全段提高 `8dB` 并限幅，平均声压 `-9.1dB`、峰值 `-0.3dB`，尚待试听。
- 安兹·高阶魔法箭原生离弦试听：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_greater_magic_arrow_launch_native_frost_arrow_v2_01.mp3`；`0.94s`。来源为用户提供的 `FrostArrowLaunch1.wav`，已转为 `44100Hz` 立体声 `128kbps` MP3 并提高整体响度；待试听决定是否用于箭阵离弦。
- 亚伦柯斯·亡者凝视高响度回响版 v6：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_grave_gaze_release_v6_loud_echo.mp3`；`1.76s`。已淘汰：反馈式回响产生明显电音。
- 安兹·高阶魔法箭原生单发 tick：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_greater_magic_arrow_launch_native_tick_v3.mp3`；`0.42s`。由原生 Frost Arrow 前段裁剪并淡出，仅作为连续箭声的中间素材。
- 安兹·高阶魔法箭六发连续试听 v3：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_greater_magic_arrow_six_tick_preview_v3.mp3`；`2.67s`。已淘汰：按技能批次 `0.45s` 编排，未与单个六箭模型内部动画对齐。
- 安兹·高阶魔法箭六箭模型同步 v4：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_greater_magic_arrow_six_arrow_model_sync_v4.mp3`；`1.67s`。已淘汰：`0.25s` 的六发间隔超出实际模型与代码时序。
- 亚伦柯斯·亡者凝视自然衰减尾音 v7：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_grave_gaze_release_v7_loud_natural_tail.mp3`；`1.56s`。主冲击提高 `10dB`，使用 `130ms / 310ms / 560ms` 的低通、递减延迟副本构成自然回响；平均声压 `-10.4dB`、峰值 `-0.4dB`；用户确认。
- 安兹·高阶魔法箭六箭模型同步 v8：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_greater_magic_arrow_six_arrow_model_sync_v8_fast_peak.mp3`；`0.45s`。从 Frost Arrow 的 `0.10s` 主冲击裁取每发 `75ms` 脉冲，在 `0 / 75 / 150 / 225 / 300 / 375ms` 连续排列 6 次；平均声压 `-11.6dB`、峰值 `-1.5dB`；模型开始时立即播放一次，用户确认。

### 第五批生成候选（2026-07-18）

本批覆盖剩余 7 个核心机制；常规机制每项 2 个候选，血之复生最终收束按成功/失败分别生成。全部为 `mp3_44100_128`、`44100Hz`、立体声，尚未试听确认、迁移或接入代码。

- 亚伦柯斯·不灭军魂 / 最终强化：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Aronkos\SFX\aronkos_undying_oath_awaken_v1_01.mp3`、`..._v1_02.mp3`；`2.00s`。残存骑士意志、铠甲低鸣与军魂内收，不应狂暴或有喊叫。
- 祖地双灵卫·封门误判安全窗：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\AncestralTwinGuards\SFX\twin_guards_gate_misjudgment_break_v1_01.mp3`、`..._v1_02.mp3`；`1.08s`。封门压制中断后出现月白魂裂与易伤缺口，不应像玻璃裂开。
- 安兹·一切生命的终点倒计时脉冲：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_all_life_death_countdown_pulse_v1_01.mp3`、`..._v1_02.mp3`；`0.60s`。绝对死亡法则的一次低压脉冲，可按倒计时节点重复播放；不是心跳或时钟滴答。
- 安兹·雅儿贝德护卫拦截：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_albedo_guard_intercept_v1_01.mp3`、`..._v1_02.mp3`；`1.20s`。黑翼压风、重甲切入和暗金屏障定型；无台词、无金属刺耳摩擦。
- 夏提雅·血月终舞启动：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_moon_start_v1_01.mp3`、`..._v1_02.mp3`；`1.88s`。血月显现与四拍战舞引子，不应变成音乐或合唱。
- 夏提雅·血之复生仪式脉冲：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_ritual_pulse_v1_01.mp3`、`..._v1_02.mp3`；`1.00s`。三枚血晶向中心尸身回压，可按场上剩余血晶数量调节；不是监护仪心跳。
- 夏提雅·血之复生最终收束：成功回流 `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_success_v1.mp3`；失败熄灭 `C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_failure_v1.mp3`；均 `2.00s`。二者必须分别绑定不同结算分支。

#### 第五批试听确认与返工（2026-07-18）

- 亚伦柯斯·不灭军魂：`aronkos_undying_oath_awaken_v1_01.mp3`，用户选择候选 1。
- 祖地双灵卫·封门误判安全窗：`twin_guards_gate_misjudgment_break_v1_02.mp3`，用户选择候选 2。
- 夏提雅·血月终舞启动：`shalltear_blood_moon_start_v1_01.mp3`，用户选择候选 1。
- 夏提雅·血之复生仪式脉冲：`shalltear_resurrection_ritual_pulse_handcrafted_v3.mp3`，用户确认单个低频脉冲。
- 夏提雅·血之复生成功回流：`shalltear_resurrection_resolve_success_handcrafted_v5_bloodflow_loud.mp3`，用户确认手工 v5。
- 夏提雅·血之复生失败熄灭：`shalltear_resurrection_resolve_failure_handcrafted_v5_collapse_loud.mp3`，用户确认手工 v5。
- 安兹·一切生命的终点倒计时脉冲：`ainz_all_life_death_countdown_pulse_v2_02.mp3`，用户选择候选 2。
- 安兹·雅儿贝德护卫拦截：`ainz_albedo_guard_intercept_v2_01.mp3`，用户选择候选 1。
- 安兹·一切生命的终点倒计时脉冲：v1 音量过小，v2 全新生成，待试听。
- 安兹·雅儿贝德护卫拦截：v1 不通过，v2 全新生成，待试听。
- 夏提雅·血之复生仪式脉冲：v1 不通过，v2 全新生成，待试听。
- 夏提雅·血之复生最终收束：v1 出现人声，v2 成功/失败分支均全新生成并排除人声，待试听。

#### 第五批返工候选（2026-07-18）

- 安兹·一切生命的终点倒计时脉冲 v2：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_all_life_death_countdown_pulse_v2_01.mp3`、`..._v2_02.mp3`；`0.60s`。平均声压约 `-2.5dB / -3.0dB`，尚待试听。
- 安兹·雅儿贝德护卫拦截 v2：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Ainz\SFX\ainz_albedo_guard_intercept_v2_01.mp3`、`..._v2_02.mp3`；`1.20s`。全新生成，强制无台词、无人声，尚待试听。
- 夏提雅·血之复生仪式脉冲 v2：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_ritual_pulse_v2_01.mp3`、`..._v2_02.mp3`；`1.00s`。全新生成，强制无心跳监护仪感与人声，尚待试听。
- 夏提雅·血之复生成功回流 v2：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_success_v2_01.mp3`、`..._v2_02.mp3`；`2.00s`。成功分支，强制无人声，尚待试听。
- 夏提雅·血之复生失败熄灭 v2：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_failure_v2_01.mp3`、`..._v2_02.mp3`；`2.00s`。失败分支，强制无人声，尚待试听。
- 夏提雅·血之复生仪式脉冲手工 v3：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_ritual_pulse_handcrafted_v3.mp3`；`1.00s`。纯低频振荡与衰减包络合成，无语音采样，平均声压 `-13.2dB`，尚待试听。
- 夏提雅·血之复生成功回流手工 v3：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_success_handcrafted_v3.mp3`；`2.00s`。已淘汰：纯正弦上行包络产生明显老式游戏音阶感。
- 夏提雅·血之复生失败熄灭手工 v3：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_failure_handcrafted_v3.mp3`；`2.00s`。已淘汰：纯正弦下行包络产生明显老式游戏音阶感。
- 夏提雅·血之复生成功回流手工 v4：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_success_handcrafted_v4_organic.mp3`；`2.20s`。已淘汰：仍有海浪式宽带底噪听感。
- 夏提雅·血之复生失败熄灭手工 v4：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_failure_handcrafted_v4_organic.mp3`；`2.20s`。已淘汰：仍有海浪式宽带底噪听感。
- 夏提雅·血之复生成功回流手工 v5：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_success_handcrafted_v5_bloodflow_loud.mp3`；`1.60s`。改为短促血能收束层依次增强，最后一次回流最强，无语音采样，平均声压 `-13.0dB`，尚待试听。
- 夏提雅·血之复生失败熄灭手工 v5：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_resurrection_resolve_failure_handcrafted_v5_collapse_loud.mp3`；`1.60s`。改为短促能量断裂层逐次减弱并拉开间隔，无语音采样，平均声压 `-16.1dB`，尚待试听。

### 鲜血回收旧方向候选（2026-07-18，已作废）

- 夏提雅·鲜血回收短促血爆与瞬时回收：
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_burst_v1_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_burst_v1_02.mp3`
  - 实际时长：`0.80s`
  - 后处理：ElevenLabs `mp3_44100_128` 原生输出；未迁移、未接入代码。01 平均声压约 `-19.7dB`，02 平均声压约 `-11.9dB`，两版峰值均为 `0.0dB`
  - 制作语义：血印先短暂炸开，随后立刻向夏提雅方向收束并回收到体内；排除流水、海浪、湿黏血腥、人声、低语、心跳和仪式鼓点。
  - 试听结论：已作废；错误加入“向夏提雅回收”的回流语义，不符合用户确认的“鲜血短暂炸开”方向。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_blood_mark_reclaim.mp3`
  - 代码触发点：`03．异界Boss/04．夏提雅/08．鲜血回收.ts` 的回收前摇/结算动作；当前未接入。
  - 当前状态：淘汰；文件保留作历史，不作为推荐或正式资源。

### 鲜血回收纯血爆裂候选（2026-07-18）

- 夏提雅·鲜血回收纯血魔法爆裂：
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_blood_burst_v2_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_blood_burst_v2_02.mp3`
  - 实际时长：`0.52s`（请求时长 `0.55s`，生成结果自动收尾）
  - 后处理：ElevenLabs `mp3_44100_128` 原生输出；未迁移、未接入代码。01 平均声压约 `-19.3dB`、峰值 `-2.2dB`；02 平均声压约 `-15.7dB`、峰值 `0.0dB`
  - 制作语义：一次短促的鲜血魔法爆裂，血印瞬间破开并向外炸散，快速干净衰减；明确排除吸附、回流、蓄力、长尾、流水、海浪、湿黏血腥、人声、低语、心跳和仪式鼓点。
  - 试听结论：尚待用户试听；02 响度更清楚，01 作为较轻版本保留对比。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_blood_mark_reclaim.mp3`
  - 代码触发点：`03．异界Boss/04．夏提雅/08．鲜血回收.ts` 的鲜血回收结算动作；当前未接入。
  - 当前状态：新候选，纯血爆裂方向，等待用户试听确认。

### 鲜血回收爆裂后补充回流候选（2026-07-18）

- 夏提雅·鲜血回收血爆加短促回流：
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_burst_return_v3_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_burst_return_v3_02.mp3`
  - 实际时长：`0.52s`
  - 后处理：以纯血爆裂 `blood_burst_v2_02` 为主体，截取其短尾反向处理后叠加；01 回流层较轻、延迟约 `175ms`，02 回流层更明显、延迟约 `145ms`。最终平均声压约 `-15.9dB`、峰值约 `-0.3dB`。
  - 制作语义：先是鲜血短暂向外炸开，紧接着出现极短的方向性回收提示；回流仅作动作确认，不做长流水、持续吸附或仪式音。
  - 试听结论：已淘汰；用户反馈回流方向根本听不出来，上一版回流层被鲜血爆裂主体覆盖。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_blood_mark_reclaim.mp3`
  - 代码触发点：`03．异界Boss/04．夏提雅/08．鲜血回收.ts` 的鲜血回收结算动作；当前未接入。
  - 当前状态：淘汰；文件保留作历史，不作为推荐或正式资源。

### 鲜血回收独立回流层强化候选（2026-07-18）

- 夏提雅·鲜血回收血爆与明显回流强化：
  - 候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_burst_return_v4_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_burst_return_v4_02.mp3`
  - 实际时长：`0.61s / 0.63s`
  - 后处理：使用独立生成的回流层 `shalltear_blood_mark_reclaim_return_layer_v1_01/02.mp3`，不再从爆裂声反向伪造；主体血爆后分别延迟约 `135ms / 155ms` 播放回流层，并提高回流层增益。最终平均声压约 `-13.4dB / -14.2dB`，峰值约 `0.0dB / -0.1dB`。
  - 制作语义：血印先短暂向外炸开，随后出现清楚的、由外向内的血能抽回声；回流是独立可闻动作，不做海浪、长流水或持续吸附。
  - 试听结论：已淘汰；用户反馈仍然完全听不出回流方向，AI 回流层的语义不成立。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_blood_mark_reclaim.mp3`
  - 代码触发点：`03．异界Boss/04．夏提雅/08．鲜血回收.ts` 的鲜血回收结算动作；当前未接入。
  - 当前状态：淘汰；文件保留作历史，不作为推荐或正式资源。

### 鲜血回收原生吸血回流候选（2026-07-18）

- 夏提雅·鲜血回收血爆与原生吸血回流：
  - 独立回流层：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_return_native_v1.mp3`
  - 合成候选绝对路径：`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_burst_native_return_v5_01.mp3`、`C:\Users\Administrator\Desktop\syzl\audio_temp\Boss\Shalltear\SFX\shalltear_blood_mark_reclaim_burst_native_return_v5_02.mp3`
  - 素材来源：用户提供的 `C:\Users\Administrator\Desktop\吸血魔法_爱给网_aigei_com.wav`，截取、加速、提高响度并转为 `44100Hz / 立体声 / 128kbps MP3`。
  - 实际时长：独立回流层 `0.55s`；合成候选 `0.95s / 1.07s`。
  - 后处理：纯血爆裂先播放；01 在约 `400ms` 后播放原生吸血回流，02 在约 `520ms` 后播放且回流更突出。独立回流层平均声压约 `-15.6dB`，合成候选平均声压约 `-14.6dB`。
  - 制作语义：先听到一次鲜血短暂炸开，再听到一个完全独立、连续且明显的吸血回流动作；两者刻意分开，避免回流再次被爆裂覆盖。
  - 试听结论：用户选择候选 1；01 的间隔较短，爆裂与原生吸血回流衔接更自然。候选 2 保留作未采用对比版。
  - 建议正式路径：`imports/Sound/Boss/Shalltear/SFX/shalltear_blood_mark_reclaim.mp3`
  - 代码触发点：`03．异界Boss/04．夏提雅/08．鲜血回收.ts` 的鲜血回收结算动作；当前未接入。
  - 当前状态：用户确认候选 1；独立回流层只作为合成素材，不与合成候选同时播放。尚未迁移或接入代码。

### 第六批正式资源迁移（2026-07-18）

- 迁移范围：仅包含用户最终确认的 41 个 SFX；历史候选、返工版、淘汰版、分层中间素材和未采用对照版均未迁移。
- 转码规格：`MP3 / 64kbps / 44100Hz / 立体声`。
- 正式目录与数量：`imports/Sound/Boss/Aronkos/SFX/`（9 个）、`imports/Sound/Boss/AncestralTwinGuards/SFX/`（9 个）、`imports/Sound/Boss/Ainz/SFX/`（11 个）、`imports/Sound/Boss/Shalltear/SFX/`（12 个）。
- 文件命名：已去除候选变体后缀，目标文件名与各条目建议正式路径一致；重复文件名检查通过。
- 特别确认：夏提雅鲜血回收使用用户选择的 `shalltear_blood_mark_reclaim_burst_native_return_v5_01.mp3`，正式文件为 `imports/Sound/Boss/Shalltear/SFX/shalltear_blood_mark_reclaim.mp3`。
- 当前状态：资源已迁移；TS 播放入口、生成 Lua 路径检查、实机距离衰减与 MIX 打包尚未在本批执行。

本批迁移后，41 个正式 SFX 已不再只是试听候选；未迁移的历史文件仍仅保留在 `audio_temp`。

## 九、确认、迁移与代码接入检查表

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

## 十、后续记录格式

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
