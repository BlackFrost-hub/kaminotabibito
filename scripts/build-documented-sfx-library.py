from __future__ import annotations

import hashlib
import re
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOUND_ROOT = ROOT / "imports" / "Sound"
DOC_ROOT = ROOT / "TS" / "系统" / "03．技能系统" / "05．单位技能" / "03．Boss技能"
CATALOG_ROOT = ROOT / ".cursor" / "rules" / "resources" / "audio" / "sfx-asset-catalog"
AUDIO_EXTENSIONS = {".mp3", ".wav", ".ogg"}
NON_SOUND_CONTEXT = (
    "用于", "播放", "触发", "context", ".ts", "玩家", "目标", "伤害",
    "无敌", "技能", "冷却", "血线", "机制", "随机", "位置", "Boss", "P2", "P3",
)


@dataclass
class Entry:
    path: str
    category: str
    description: str
    source: str
    line: int
    sha256: str


CATEGORY_METADATA = {
    "环绕持续": ("aura.md", "环绕单位或地面的持续层。"),
    "蓄力与冲锋": ("charge-rush.md", "蓄力、冲锋、路径拖尾和推进感。"),
    "爪痕与斩痕": ("claw-slash.md", "爪痕、斩痕、抓击和刀刃质感。"),
    "点名与诅咒": ("mark-curse.md", "点名、诅咒、拘束和封锁感。"),
    "瞬时爆发": ("instant-burst.md", "瞬时爆发、破碎、炸裂和重击。"),
    "镜像与残影": ("illusion-echo.md", "镜像、残影、投影和回响。"),
    "直线与贯穿": ("line-pierce.md", "直线波、切面、丝带、贯穿和回流。"),
    "法阵与符文": ("magic-ritual.md", "法阵、符文、仪式和规则感脉冲。"),
    "标记与锚点": ("marker-anchor.md", "核心、节点、血印和锚点。"),
    "升降与回填": ("rise-return.md", "升起、坠落、回填和空中主体感。"),
    "旋转与环绕": ("rotate-circulate.md", "旋转刃、回旋、漩涡和环形运动。"),
    "护盾与屏障": ("shield-barrier.md", "护盾、屏障、格挡和破盾。"),
    "扩散与放射": ("spread-radiate.md", "扩散、散射、放射和范围展开。"),
    "未指定分类": ("unassigned.md", "已有声音描述，但无法可靠对应以上声响形态。"),
}


def clean(text: str) -> str:
    text = text.strip().strip("| ")
    text = text.replace("`", "")
    return re.sub(r"\s+", " ", text)


def classify(text: str) -> str:
    rules = [
        ("蓄力与冲锋", ("聚压", "蓄压", "蓄力", "突进", "冲锋", "推进", "路径", "pressure_build", "charge", "dash")),
        ("爪痕与斩痕", ("爪", "剑气", "魂刃", "刀光", "斩", "切割", "横扫", "slash")),
        ("点名与诅咒", ("束缚", "锁定", "诅咒", "牵引", "眩晕", "封印", "影钉", "bind", "lock", "curse")),
        ("瞬时爆发", ("命中", "冲击", "重击", "爆发", "爆裂", "爆开", "砸地", "贯穿", "撕开", "震动", "破裂", "碎裂", "blast", "impact", "thump", "snap")),
        ("镜像与残影", ("幻", "残影", "英灵", "回响", "镜", "幽影", "phantom", "echo", "illusion")),
        ("直线与贯穿", ("压风", "直线", "冲击波", "丝带", "回流", "掠过", "line", "shockwave", "ribbon", "trail")),
        ("法阵与符文", ("法阵", "符文", "仪式", "血月", "法则", "circle", "rune", "ritual")),
        ("标记与锚点", ("核心", "血印", "节点", "倒计时", "锚点", "mark", "marker")),
        ("升降与回填", ("俯冲", "坠落", "落地", "升空", "光柱", "下降", "回填", "descent", "dive", "pillar")),
        ("旋转与环绕", ("旋", "漩", "回旋", "涡", "旋转", "环斩", "vortex", "rotate")),
        ("护盾与屏障", ("护盾", "防御", "格挡", "破盾", "屏障", "守护", "盾面", "盾剑", "挡反", "shield", "parry")),
        ("扩散与放射", ("外扩", "扩散", "翅", "黑翼", "帷幕", "放射", "大范围", "spread", "wave")),
        ("环绕持续", ("光环", "领域", "气场", "环境", "共鸣", "环绕", "aura", "field")),
    ]
    lowered = text.lower()
    for category, words in rules:
        if any(word in lowered for word in words):
            return category
    return "未指定分类"


def table_sound_description(lines: list[str], index: int) -> str:
    line = lines[index]
    if not line.lstrip().startswith("|"):
        return ""
    cells = [clean(cell) for cell in line.strip().strip("|").split("|")]
    for cursor in range(index - 1, max(-1, index - 40), -1):
        candidate = lines[cursor]
        if not candidate.lstrip().startswith("|"):
            break
        header = [clean(cell) for cell in candidate.strip().strip("|").split("|")]
        if len(header) != len(cells):
            continue
        row = dict(zip(header, cells))
        suggested = row.get("建议声音", "")
        if suggested and suggested not in {"-", "暂无"}:
            return f"建议声音：{suggested}"
        layers = row.get("分层方案", "")
        if layers and layers not in {"-", "暂无"}:
            layers = re.split(r"，可(?:重复播放|按)", layers, maxsplit=1)[0]
            return f"分层方案：{layers}"
    return ""


def extract_expression(value: str) -> str:
    marker = value.find("表达")
    if marker < 0:
        return ""
    expression = value[marker + len("表达"):]
    expression = re.split(r"；(?:不是|不包含|不要|不用于)", expression, maxsplit=1)[0]
    expression = expression.split("。", 1)[0].strip("：；， ")
    return f"声音描述：{expression}" if expression else ""


def extract_production_description(value: str) -> str:
    if "制作备注：" not in value:
        return ""
    note = value.split("制作备注：", 1)[1]
    first_sentence = note.split("。", 1)[0].strip()
    if first_sentence.startswith("分层合成") or "层合并" in first_sentence:
        return f"声音构成：{first_sentence}"
    formed = re.search(r"形成([^。；]+)", note)
    if formed:
        return f"声音描述：{formed.group(1).strip()}"
    generated = re.search(r"按[“\"]([^”\"]+)[”\"]整体生成", note)
    if generated:
        return f"声音描述：{generated.group(1).strip()}"
    return ""


def is_sound_focused(description: str) -> bool:
    return not any(marker in description for marker in NON_SOUND_CONTEXT)


def labeled_sound_descriptions(lines: list[str], index: int) -> list[str]:
    if lines[index].lstrip().startswith("|"):
        return []
    descriptions: list[str] = []
    item_pattern = re.compile(r"^\s*\d+\.\s+\S")
    start = index
    while start >= 0 and not item_pattern.match(lines[start]) and not lines[start].lstrip().startswith("#"):
        start -= 1
    if start >= 0 and item_pattern.match(lines[start]):
        end = start + 1
        while end < len(lines) and not item_pattern.match(lines[end]) and not lines[end].lstrip().startswith("#"):
            end += 1
    else:
        start = index
        while start > 0 and lines[start - 1].strip():
            start -= 1
        end = index + 1
        while end < len(lines) and lines[end].strip():
            end += 1
    direct_labels = ("建议声音：", "声音描述：", "听感描述：", "声音构成：", "分层方案：", "制作语义：")
    for line in lines[start:end]:
        value = clean(line.lstrip("- "))
        if not value or ".mp3" in value:
            continue
        direct = next((label for label in direct_labels if value.startswith(label)), "")
        if direct:
            content = value[len(direct):].strip()
            if content and not content.startswith("用于"):
                descriptions.append(f"{direct}{content}")
            continue
        expression = extract_expression(value)
        if expression:
            descriptions.append(expression)
            continue
        if value.startswith("语义："):
            semantic = value[len("语义："):]
            if semantic and not semantic.startswith("用于"):
                semantic = re.split(r"；(?:不是|不包含|不要|不用于|这是|适合|后续)", semantic, maxsplit=1)[0]
                semantic = semantic.split("。", 1)[0]
                descriptions.append(f"声音描述：{semantic.strip()}")
            continue
        production = extract_production_description(value)
        if production:
            descriptions.append(production)
    return [description for description in descriptions if is_sound_focused(description)]


def find_entry(audio: Path, documents: list[Path]) -> Entry | None:
    best: tuple[int, Entry] | None = None
    relative_audio = audio.relative_to(ROOT).as_posix()
    digest = hashlib.sha256(audio.read_bytes()).hexdigest()

    for document in documents:
        lines = document.read_text(encoding="utf-8").splitlines()
        for index, line in enumerate(lines):
            if audio.name not in line:
                continue
            descriptions = labeled_sound_descriptions(lines, index)
            table_description = table_sound_description(lines, index)
            if table_description:
                descriptions.insert(0, table_description)
            descriptions = list(dict.fromkeys(descriptions))
            if not descriptions:
                continue
            description = "；".join(descriptions)
            source = document.relative_to(ROOT).as_posix()
            entry = Entry(
                path=relative_audio,
                category=classify(description),
                description=description,
                source=source,
                line=index + 1,
                sha256=digest,
            )
            score = len(description)
            if best is None or score > best[0]:
                best = (score, entry)
    return best[1] if best else None


def render_category(category: str, entries: list[Entry]) -> str:
    lines = [
        f"# {category}",
        "",
        f"> {CATEGORY_METADATA[category][1]} 这里只记录正式资源已有文档写明的声音描述。",
        "",
        "| 正式资源 | 大概声音 | 来源 |",
        "| --- | --- | --- |",
    ]
    for entry in sorted(entries, key=lambda item: item.path):
        description = entry.description.replace("|", "\\|")
        lines.append(f"| `{entry.path}` | {description} | `{entry.source}:{entry.line}` |")
    lines.append("")
    return "\n".join(lines)


def render_unrecorded(omitted: list[str]) -> str:
    lines = [
        "# 未收录正式音效",
        "",
        "> 这些正式文件存在于项目，但现有文档没有提供足够的声音描述，因此不进入分类音效库。",
        "",
    ]
    lines.extend(f"- `{path}`" for path in omitted)
    lines.append("")
    return "\n".join(lines)


def render_index(entries: list[Entry], omitted: list[str]) -> str:
    by_category: dict[str, list[Entry]] = defaultdict(list)
    for entry in entries:
        by_category[entry.category].append(entry)

    exact_groups: dict[str, list[Entry]] = defaultdict(list)
    for entry in entries:
        exact_groups[entry.sha256].append(entry)
    duplicate_groups = [group for group in exact_groups.values() if len(group) > 1]

    lines = [
        "# Boss SFX 资产分类目录",
        "",
        "> 本目录只记录 `imports/Sound` 中已有、且项目 Markdown 明确写过听感或声音构成的正式 SFX。Voice 台词、训练音频、`audio_temp` 候选和没有声音描述的正式文件不收录。",
        "",
        "## 分类入口",
        "",
        "| 声响分类 | 文件 | 数量 | 主要语义 |",
        "| --- | --- | ---: | --- |",
    ]
    for category, (filename, semantic) in CATEGORY_METADATA.items():
        lines.append(f"| {category} | [`{filename}`]({filename}) | {len(by_category[category])} | {semantic} |")
    lines.extend([
        "",
        "## 文件组织规则",
        "",
        "1. 每条正式音效只进入一个主分类文件，不因不同技能或角色复制条目。",
        "2. 分类名称按声音形态语义命名，参考 `.cursor/rules/resources/visual/effect-asset-catalog/form/README.md` 的形态划分，但不复制特效目录名。",
        "3. 表格只写正式资源、大概声音和来源，不写技能用途、播放节点或接入代码。",
        "4. 新音效必须先迁入 `imports/Sound`，并在需求文档补齐声音描述后才能进入分类文件。",
        "",
        "## 收录概况",
        "",
        f"- 已收录：{len(entries)} 条。",
        f"- 未收录：{len(omitted)} 个正式文件。详见 [`unrecorded.md`](unrecorded.md)。",
        f"- 精确重复组：{len(duplicate_groups)} 组（SHA-256）。",
        "- 本目录不根据文件名或主观试听补写声音说明。",
        "",
    ])
    if duplicate_groups:
        lines.extend(["## 精确重复", ""])
        for index, group in enumerate(duplicate_groups, 1):
            lines.append(f"{index}. " + "、".join(f"`{entry.path}`" for entry in group))
        lines.append("")
    return "\n".join(lines)


def main() -> None:
    CATALOG_ROOT.mkdir(parents=True, exist_ok=True)
    documents = sorted(DOC_ROOT.rglob("*.md"))
    audio_files = sorted(
        path for path in SOUND_ROOT.rglob("*")
        if path.is_file() and path.suffix.lower() in AUDIO_EXTENSIONS and "Voice" not in path.parts
    )
    entries: list[Entry] = []
    omitted: list[str] = []
    for audio in audio_files:
        entry = find_entry(audio, documents)
        if entry is None:
            omitted.append(audio.relative_to(ROOT).as_posix())
        else:
            entries.append(entry)
    by_category: dict[str, list[Entry]] = defaultdict(list)
    for entry in entries:
        by_category[entry.category].append(entry)
    for category, (filename, _) in CATEGORY_METADATA.items():
        (CATALOG_ROOT / filename).write_text(render_category(category, by_category[category]), encoding="utf-8", newline="\n")
    (CATALOG_ROOT / "unrecorded.md").write_text(render_unrecorded(omitted), encoding="utf-8", newline="\n")
    (CATALOG_ROOT / "README.md").write_text(render_index(entries, omitted), encoding="utf-8", newline="\n")
    print(f"documented={len(entries)} omitted={len(omitted)} output={CATALOG_ROOT}")


if __name__ == "__main__":
    main()
