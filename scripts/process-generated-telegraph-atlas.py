"""将 AI 四宫格预警纹样拆成可用于 Warcraft 3 的白色透明贴图。"""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageChops


def trim(image: Image.Image) -> Image.Image:
    alpha = image.getchannel("A")
    box = alpha.getbbox()
    if box is None:
        raise ValueError("裁剪区域没有可见像素")
    return image.crop(box)


def place(image: Image.Image, size: tuple[int, int], padding: int = 18, stretch: bool = False) -> Image.Image:
    target_w, target_h = size
    usable_w = target_w - padding * 2
    usable_h = target_h - padding * 2
    image = trim(image)
    if stretch:
        resized = image.resize((usable_w, usable_h), Image.Resampling.LANCZOS)
    else:
        scale = min(usable_w / image.width, usable_h / image.height)
        resized = image.resize(
            (max(1, round(image.width * scale)), max(1, round(image.height * scale))),
            Image.Resampling.LANCZOS,
        )
    canvas = Image.new("RGBA", size, (0, 0, 0, 0))
    canvas.alpha_composite(resized, ((target_w - resized.width) // 2, (target_h - resized.height) // 2))
    return canvas


def keep_largest_component(image: Image.Image, threshold: int = 8) -> Image.Image:
    """移除四宫格相邻区域切进来的零散装饰。"""
    alpha = image.getchannel("A")
    width, height = image.size
    visible = bytearray(1 if value > threshold else 0 for value in alpha.getdata())
    visited = bytearray(width * height)
    largest: list[int] = []
    for start, value in enumerate(visible):
        if not value or visited[start]:
            continue
        visited[start] = 1
        stack = [start]
        component: list[int] = []
        while stack:
            index = stack.pop()
            component.append(index)
            x = index % width
            y = index // width
            for ny in range(max(0, y - 1), min(height, y + 2)):
                for nx in range(max(0, x - 1), min(width, x + 2)):
                    neighbor = ny * width + nx
                    if visible[neighbor] and not visited[neighbor]:
                        visited[neighbor] = 1
                        stack.append(neighbor)
        if len(component) > len(largest):
            largest = component

    keep = bytearray(width * height)
    for index in largest:
        keep[index] = 1
    pixels = image.load()
    for y in range(height):
        for x in range(width):
            if not keep[y * width + x]:
                pixels[x, y] = (0, 0, 0, 0)
    return image


def make_tint_neutral(image: Image.Image) -> Image.Image:
    """Keep the generated silhouette/alpha while making every visible pixel pure white."""
    alpha = image.getchannel("A")
    visible_white = alpha.point(lambda value: 255 if value > 0 else 0)
    return Image.merge("RGBA", (visible_white, visible_white, visible_white, alpha))


def center_visible_bounds(image: Image.Image) -> Image.Image:
    """Translate visible pixels to the exact texture center without resizing them."""
    box = image.getchannel("A").getbbox()
    if box is None:
        return image
    visible_center_x = (box[0] + box[2] - 1) / 2
    visible_center_y = (box[1] + box[3] - 1) / 2
    target_center_x = (image.width - 1) / 2
    target_center_y = (image.height - 1) / 2
    offset_x = round(target_center_x - visible_center_x)
    offset_y = round(target_center_y - visible_center_y)
    centered = Image.new("RGBA", image.size, (0, 0, 0, 0))
    centered.alpha_composite(image, (offset_x, offset_y))
    return centered


def make_fourfold_symmetric(image: Image.Image) -> Image.Image:
    """Mirror the clean top-right octant, then repeat it every 90 degrees."""
    if image.width != image.height:
        raise ValueError("四向对称处理要求正方形贴图")
    alpha = image.getchannel("A")
    width, height = image.size
    center_x = (width - 1) / 2
    center_y = (height - 1) / 2
    source = alpha.load()
    octant = Image.new("L", image.size, 0)
    target = octant.load()
    for y in range(height):
        dy = y - center_y
        if dy > 0:
            continue
        for x in range(width):
            dx = x - center_x
            if dx >= 0 and dx <= -dy:
                target[x, y] = source[x, y]

    # One 45-degree source segment is mirrored first, so every arrow-facing
    # ornament and every diagonal arc junction is geometrically identical.
    top_quarter = ImageChops.lighter(octant, octant.transpose(Image.Transpose.FLIP_LEFT_RIGHT))
    symmetric_alpha = Image.new("L", image.size, 0)
    rotated = top_quarter
    for _ in range(4):
        symmetric_alpha = ImageChops.lighter(symmetric_alpha, rotated)
        rotated = rotated.transpose(Image.Transpose.ROTATE_90)
    visible_white = symmetric_alpha.point(lambda value: 255 if value > 0 else 0)
    return Image.merge("RGBA", (visible_white, visible_white, visible_white, symmetric_alpha))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--out-dir", required=True)
    args = parser.parse_args()

    source = Image.open(args.input).convert("RGBA")
    width, height = source.size
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    sector = source.crop((0, 0, round(width * 0.57), round(height * 0.53)))
    line = source.crop((round(width * 0.47), 0, width, round(height * 0.53)))
    rectangle = source.crop((0, round(height * 0.52), round(width * 0.56), round(height * 0.93)))
    ring = source.crop((round(width * 0.52), round(height * 0.49), width, round(height * 0.96)))

    # 扇形模型的地面网格宽长比约 2:1，因此源图先横向压缩，进游戏后恢复原比例。
    sector = trim(sector)
    sector = sector.resize((max(1, sector.width // 2), sector.height), Image.Resampling.LANCZOS)
    make_tint_neutral(center_visible_bounds(keep_largest_component(place(sector, (512, 512), padding=12)))).save(
        out_dir / "telegraph-sector-white.png"
    )

    # AI 生成的直线是斜向构图，旋成朝上的模型贴图。
    line = trim(line).rotate(-45, expand=True, resample=Image.Resampling.BICUBIC)
    make_tint_neutral(center_visible_bounds(keep_largest_component(place(line, (512, 512), padding=12)))).save(
        out_dir / "telegraph-line-white.png"
    )

    # 矩形需要铺满 UV，模型会按 1:1~1:6 的世界比例再次拉伸。
    make_tint_neutral(
        center_visible_bounds(keep_largest_component(place(rectangle, (512, 512), padding=12, stretch=True)))
    ).save(
        out_dir / "telegraph-rectangle-white.png"
    )
    make_tint_neutral(make_fourfold_symmetric(keep_largest_component(place(ring, (512, 512), padding=12)))).save(
        out_dir / "telegraph-ring-white.png"
    )


if __name__ == "__main__":
    main()
