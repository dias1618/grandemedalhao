#!/usr/bin/env python3
"""Gera sprites pixel art do personagem principal (32x32 frames)."""

from pathlib import Path
from PIL import Image

FRAME = 32
OUT_DIR = Path(__file__).resolve().parent.parent / "assets" / "sprites" / "player"

# Paleta do plano
SKIN = (232, 196, 154)
SKIN_D = (212, 165, 116)
HAIR = (92, 61, 46)
HAIR_D = (62, 40, 24)
SHIRT = (196, 165, 116)
SHIRT_D = (168, 140, 96)
PANTS = (74, 55, 40)
PANTS_D = (58, 42, 30)
BOOTS = (46, 34, 24)
OUTLINE = (26, 20, 16)
BAG = (107, 78, 55)

DOWN, LEFT, RIGHT, UP = 0, 1, 2, 3


def blank() -> Image.Image:
    return Image.new("RGBA", (FRAME, FRAME), (0, 0, 0, 0))


def px(img: Image.Image, x: int, y: int, color: tuple[int, int, int]) -> None:
    if 0 <= x < FRAME and 0 <= y < FRAME:
        img.putpixel((x, y), (*color, 255))


def rect(img: Image.Image, x: int, y: int, w: int, h: int, color: tuple[int, int, int]) -> None:
    for dy in range(h):
        for dx in range(w):
            px(img, x + dx, y + dy, color)


def outline_rect(
    img: Image.Image, x: int, y: int, w: int, h: int, fill: tuple[int, int, int], edge: tuple[int, int, int] = OUTLINE
) -> None:
    for dy in range(h):
        for dx in range(w):
            c = edge if dx == 0 or dy == 0 or dx == w - 1 or dy == h - 1 else fill
            px(img, x + dx, y + dy, c)


def leg_pose(walk_frame: int) -> tuple[int, int]:
    """Deslocamento dos pés: esquerdo, neutro, direito, neutro."""
    if walk_frame == 0:
        return -2, 2
    if walk_frame == 2:
        return 2, -2
    return 0, 0


def draw_boots_down(img: Image.Image, y_base: int, left_x: int, right_x: int) -> None:
    outline_rect(img, left_x, y_base, 4, 3, BOOTS)
    outline_rect(img, right_x, y_base, 4, 3, BOOTS)


def draw_pants_down(img: Image.Image, y_base: int, left_x: int, right_x: int) -> None:
    outline_rect(img, left_x, y_base - 5, 4, 5, PANTS)
    outline_rect(img, right_x, y_base - 5, 4, 5, PANTS)
    px(img, left_x + 1, y_base - 5, PANTS_D)
    px(img, right_x + 2, y_base - 5, PANTS_D)


def draw_torso_down(img: Image.Image, y: int, breathe: int = 0) -> None:
    ty = y + breathe
    outline_rect(img, 11, ty, 10, 8, SHIRT)
    rect(img, 12, ty + 1, 8, 6, SHIRT)
    px(img, 13, ty + 3, SHIRT_D)
    px(img, 18, ty + 4, SHIRT_D)
    # Mochila lateral
    outline_rect(img, 20, ty + 1, 3, 5, BAG)


def draw_head_down(img: Image.Image, y: int, breathe: int = 0) -> None:
    hy = y + breathe
    # Cabelo
    outline_rect(img, 11, hy, 10, 4, HAIR)
    rect(img, 12, hy + 1, 8, 2, HAIR_D)
    # Rosto
    outline_rect(img, 11, hy + 3, 10, 6, SKIN)
    rect(img, 12, hy + 4, 8, 4, SKIN)
    px(img, 13, hy + 5, SKIN_D)
    px(img, 18, hy + 5, SKIN_D)
    # Olhos
    px(img, 13, hy + 5, OUTLINE)
    px(img, 18, hy + 5, OUTLINE)


def draw_arms_down(img: Image.Image, y: int, left_swing: int, right_swing: int, interact: bool = False) -> None:
    if interact:
        outline_rect(img, 8, y + 2, 3, 5, SHIRT)
        outline_rect(img, 6, y + 1, 3, 3, SKIN)  # braço estendido
        px(img, 5, y + 1, SKIN)
        outline_rect(img, 19, y + 3, 3, 4, SHIRT)
        return
    outline_rect(img, 8, y + 2 + left_swing, 3, 4, SHIRT)
    outline_rect(img, 19, y + 2 + right_swing, 3, 4, SHIRT)


def draw_down(img: Image.Image, walk_frame: int, idle_breathe: int = 0, interact: bool = False) -> None:
    bob = 1 if walk_frame in (1, 3) and not interact else 0
    breathe = idle_breathe
    y_base = 28 - bob
    left_off, right_off = leg_pose(walk_frame)
    center_l = 12 + left_off
    center_r = 17 + right_off
    swing_l = -walk_frame % 2
    swing_r = walk_frame % 2
    draw_pants_down(img, y_base, center_l, center_r)
    draw_boots_down(img, y_base, center_l, center_r)
    draw_torso_down(img, 14, breathe)
    draw_arms_down(img, 15, swing_l, swing_r, interact)
    draw_head_down(img, 7, breathe)


def draw_head_up(img: Image.Image, y: int, breathe: int = 0) -> None:
    hy = y + breathe
    outline_rect(img, 11, hy, 10, 7, HAIR)
    rect(img, 12, hy + 1, 8, 5, HAIR_D)
    outline_rect(img, 12, hy + 6, 8, 3, SHIRT)  # colarinho / ombros


def draw_torso_up(img: Image.Image, y: int, breathe: int = 0) -> None:
    ty = y + breathe
    outline_rect(img, 11, ty, 10, 8, SHIRT)
    rect(img, 12, ty + 1, 8, 6, SHIRT_D)
    outline_rect(img, 20, ty + 1, 3, 5, BAG)


def draw_legs_up(img: Image.Image, y_base: int, left_off: int, right_off: int) -> None:
    outline_rect(img, 12 + left_off, y_base - 5, 4, 5, PANTS)
    outline_rect(img, 17 + right_off, y_base - 5, 4, 5, PANTS)
    outline_rect(img, 12 + left_off, y_base, 4, 3, BOOTS)
    outline_rect(img, 17 + right_off, y_base, 4, 3, BOOTS)


def draw_up(img: Image.Image, walk_frame: int, idle_breathe: int = 0) -> None:
    bob = 1 if walk_frame in (1, 3) else 0
    breathe = idle_breathe
    y_base = 28 - bob
    left_off, right_off = leg_pose(walk_frame)
    draw_legs_up(img, y_base, left_off, right_off)
    draw_torso_up(img, 14, breathe)
    outline_rect(img, 8, 16 + breathe, 3, 4, SHIRT)
    outline_rect(img, 21, 16 + breathe, 3, 4, SHIRT)
    draw_head_up(img, 7, breathe)


def draw_head_side(img: Image.Image, y: int, facing_left: bool, breathe: int = 0) -> None:
    hy = y + breathe
    if facing_left:
        outline_rect(img, 10, hy, 9, 4, HAIR)
        rect(img, 11, hy + 1, 7, 2, HAIR_D)
        outline_rect(img, 10, hy + 3, 8, 6, SKIN)
        rect(img, 11, hy + 4, 6, 4, SKIN)
        px(img, 11, hy + 5, OUTLINE)  # olho
        px(img, 12, hy + 6, SKIN_D)
    else:
        outline_rect(img, 13, hy, 9, 4, HAIR)
        rect(img, 14, hy + 1, 7, 2, HAIR_D)
        outline_rect(img, 12, hy + 3, 8, 6, SKIN)
        rect(img, 13, hy + 4, 6, 4, SKIN)
        px(img, 19, hy + 5, OUTLINE)
        px(img, 18, hy + 6, SKIN_D)


def draw_torso_side(img: Image.Image, y: int, facing_left: bool, breathe: int = 0) -> None:
    ty = y + breathe
    if facing_left:
        outline_rect(img, 11, ty, 9, 8, SHIRT)
        rect(img, 12, ty + 1, 7, 6, SHIRT)
        outline_rect(img, 18, ty + 2, 3, 5, BAG)
    else:
        outline_rect(img, 10, ty, 9, 8, SHIRT)
        rect(img, 11, ty + 1, 7, 6, SHIRT)
        outline_rect(img, 10, ty + 2, 3, 5, BAG)


def draw_legs_side(img: Image.Image, y_base: int, facing_left: bool, walk_frame: int) -> None:
    if walk_frame == 0:
        front, back = 2, -1
    elif walk_frame == 2:
        front, back = -1, 2
    else:
        front, back = 0, 0
    if facing_left:
        outline_rect(img, 11 + back, y_base - 5, 4, 5, PANTS)
        outline_rect(img, 14 + front, y_base - 5, 4, 5, PANTS)
        outline_rect(img, 11 + back, y_base, 4, 3, BOOTS)
        outline_rect(img, 14 + front, y_base, 4, 3, BOOTS)
    else:
        outline_rect(img, 13 + front, y_base - 5, 4, 5, PANTS)
        outline_rect(img, 10 + back, y_base - 5, 4, 5, PANTS)
        outline_rect(img, 13 + front, y_base, 4, 3, BOOTS)
        outline_rect(img, 10 + back, y_base, 4, 3, BOOTS)


def draw_arm_side(img: Image.Image, y: int, facing_left: bool, walk_frame: int, breathe: int = 0) -> None:
    ty = y + breathe
    swing = (walk_frame % 2) * 2 - 1
    if facing_left:
        outline_rect(img, 9, ty + 2 + swing, 3, 4, SHIRT)
    else:
        outline_rect(img, 20, ty + 2 - swing, 3, 4, SHIRT)


def draw_side(img: Image.Image, facing_left: bool, walk_frame: int, idle_breathe: int = 0) -> None:
    bob = 1 if walk_frame in (1, 3) else 0
    breathe = idle_breathe
    y_base = 28 - bob
    draw_legs_side(img, y_base, facing_left, walk_frame)
    draw_torso_side(img, 14, facing_left, breathe)
    draw_arm_side(img, 15, facing_left, walk_frame, breathe)
    draw_head_side(img, 7, facing_left, breathe)


def render_frame(direction: int, walk_frame: int, idle_breathe: int = 0, interact: bool = False) -> Image.Image:
    img = blank()
    if direction == DOWN:
        draw_down(img, walk_frame, idle_breathe, interact)
    elif direction == LEFT:
        draw_side(img, True, walk_frame, idle_breathe)
    elif direction == RIGHT:
        draw_side(img, False, walk_frame, idle_breathe)
    elif direction == UP:
        draw_up(img, walk_frame, idle_breathe)
    return img


def build_sheet(rows: list[list[Image.Image]]) -> Image.Image:
    cols = max(len(r) for r in rows)
    sheet = Image.new("RGBA", (cols * FRAME, len(rows) * FRAME), (0, 0, 0, 0))
    for row_i, row in enumerate(rows):
        for col_i, frame in enumerate(row):
            sheet.paste(frame, (col_i * FRAME, row_i * FRAME))
    return sheet


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    # Walk: 4 direções × 4 frames (128×128)
    walk_rows = []
    for direction in (DOWN, LEFT, RIGHT, UP):
        walk_rows.append([render_frame(direction, f) for f in range(4)])
    walk_sheet = build_sheet(walk_rows)
    walk_path = OUT_DIR / "player_walk.png"
    walk_sheet.save(walk_path)

    # Idle: 4 direções × 2 frames (64×128)
    idle_rows = []
    for direction in (DOWN, LEFT, RIGHT, UP):
        idle_rows.append([render_frame(direction, 1, idle_breathe=0), render_frame(direction, 1, idle_breathe=1)])
    idle_sheet = build_sheet(idle_rows)
    idle_path = OUT_DIR / "player_idle.png"
    idle_sheet.save(idle_path)

    # Interact: 2 frames direção baixo (64×32)
    interact_frames = [render_frame(DOWN, 1, 0, False), render_frame(DOWN, 1, 0, True)]
    interact_sheet = build_sheet([interact_frames])
    interact_path = OUT_DIR / "player_interact.png"
    interact_sheet.save(interact_path)

    print(f"Gerado: {walk_path} ({walk_sheet.size[0]}x{walk_sheet.size[1]})")
    print(f"Gerado: {idle_path} ({idle_sheet.size[0]}x{idle_sheet.size[1]})")
    print(f"Gerado: {interact_path} ({interact_sheet.size[0]}x{interact_sheet.size[1]})")


if __name__ == "__main__":
    main()
