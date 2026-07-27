import ast
import re
from pathlib import Path

import bpy


SOURCE_BLEND = Path(
    r"F:\Blender\Projects\尤菲_un_War3_work_20260718_185351"
) / "Euphilia_v171_stand_sidehair01_02_clearance.blend"
PROJECT_ROOT = Path.home() / "Desktop" / "syzl" / "模型制作" / "尤菲莉亚"
TOOLS_DIR = PROJECT_ROOT / "模型制作记录" / "工具"
OUTPUT_DIR = (
    PROJECT_ROOT
    / "正式采纳模型"
    / "Euphilia_v171_War3经典版_1024_最终_丝袜无接缝"
)
FULL_WRAPPER = TOOLS_DIR / "Euphilia_v169_export_full_animation_dense_dissipate_payload.py"
MDX_WRAPPER = (
    TOOLS_DIR
    / "Euphilia_v169_export_mdx800_repeated4_greedy256_exact_singletons_dense_dissipate_payload.py"
)


def extract_string_assignment(source, variable_name):
    tree = ast.parse(source)
    for statement in tree.body:
        if not isinstance(statement, ast.Assign) or len(statement.targets) != 1:
            continue
        target = statement.targets[0]
        if isinstance(target, ast.Name) and target.id == variable_name:
            value = ast.literal_eval(statement.value)
            if not isinstance(value, str):
                raise RuntimeError(f"{variable_name} is not a string")
            return value
    raise RuntimeError(f"Missing string assignment: {variable_name}")


if Path(bpy.data.filepath) != SOURCE_BLEND:
    raise RuntimeError(f"Refusing to export unexpected Blender file: {bpy.data.filepath}")
if not FULL_WRAPPER.is_file() or not MDX_WRAPPER.is_file():
    raise RuntimeError("The approved v169 export wrappers are missing")
if not OUTPUT_DIR.is_dir():
    raise RuntimeError(f"The prepared output directory is missing: {OUTPUT_DIR}")

source = FULL_WRAPPER.read_text(encoding="utf-8").replace("v169", "v171")
source, expected_count = re.subn(
    r'^EXPECTED_FILE = r".*"$',
    lambda _match: f'EXPECTED_FILE = r"{SOURCE_BLEND}"',
    source,
    count=1,
    flags=re.MULTILINE,
)
source, output_count = re.subn(
    r'^OUTPUT_DIR = r".*"$',
    lambda _match: f'OUTPUT_DIR = r"{OUTPUT_DIR}"',
    source,
    count=1,
    flags=re.MULTILINE,
)
if expected_count != 1 or output_count != 1:
    raise RuntimeError("Failed to retarget the v169 export wrapper")

mdx_wrapper_source = MDX_WRAPPER.read_text(encoding="utf-8")
repeated4_patch = extract_string_assignment(mdx_wrapper_source, "repeated4_patch")
prepared_texture_patch = r"""
source = replace_once(
    source,
    '''unique_textures = sorted({source["texture_blp"] for source in MATERIALS.values()})
texture_files = []
for filename in unique_textures:
    source = os.path.join(TEXTURE_SOURCE_DIR, filename)
    target = os.path.join(OUTPUT_DIR, filename)
    if not os.path.exists(source):
        raise RuntimeError(f"Missing source BLP: {source}")
    shutil.copy2(source, target)
    texture_files.append({"file": filename, "bytes": os.path.getsize(target)})
''',
    '''unique_textures = sorted({source["texture_blp"] for source in MATERIALS.values()})
texture_files = []
for filename in unique_textures:
    target = os.path.join(OUTPUT_DIR, filename)
    if not os.path.exists(target):
        raise RuntimeError(f"Missing prepared BLP: {target}")
    texture_files.append({"file": filename, "bytes": os.path.getsize(target)})
''',
)
"""
final_exec = 'exec(compile(source, str(TEMPLATE), "exec"), globals())'
if source.count(final_exec) != 1:
    raise RuntimeError("Unexpected v169 wrapper entry point")
source = source.replace(
    final_exec,
    prepared_texture_patch + "\n" + repeated4_patch + "\n" + final_exec,
)

exec(compile(source, str(FULL_WRAPPER), "exec"), globals())
