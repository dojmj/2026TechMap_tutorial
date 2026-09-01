#!/usr/bin/env python3
"""Apply lightweight presentation fixes to a generated DocC site."""

from __future__ import annotations

import json
import shutil
import sys
from pathlib import Path


CODE_GUIDES = {
    "01-ProjectSetup-01.swift": (
        "📌 코드 확인: 약 1번째 줄부터, 약 6번째 줄부터",
        "📍 위치: GraspApp App 선언 전체와 GraspApp.body 내부의 WindowGroup",
    ),
    "01-ProjectSetup-02.swift": (
        "📌 코드 확인: 약 1번째 줄부터",
        "📍 위치: ContentView 구조체 전체",
    ),
    "01-ProjectSetup-03.swift": (
        "📌 코드 확인: 약 1번째 줄부터",
        "📍 위치: ImmersiveView 구조체 전체",
    ),
    "02-HandTracking-01.swift": (
        "📄 새 파일 생성: 약 1번째 줄부터",
        "📍 위치: Grasp 앱 Target 내부",
    ),
    "02-HandTracking-02.swift": (
        "✅ 코드 추가: 약 10번째 줄부터",
        "📍 위치: HandTrackingManager 클래스 내부, session과 handTracking 프로퍼티 아래",
    ),
    "02-HandTracking-03.swift": (
        "✅ 코드 추가: 약 18번째 줄과 약 25번째 줄부터",
        "📍 위치: startTracking() 내부와 HandTrackingManager 클래스 내부",
    ),
    "02-HandTracking-04.swift": (
        "✏️ 코드 수정: 약 6번째 줄과 약 12번째 줄부터",
        "📍 위치: ImmersiveView 구조체의 프로퍼티 영역과 RealityView 뒤",
    ),
    "03-HandJoints-01.swift": (
        "✅ 코드 추가: 약 33번째 줄부터",
        "📍 위치: processHandUpdates() 내부, isTracked guard 바로 아래",
    ),
    "03-HandJoints-02.swift": (
        "✅ 코드 추가: 약 37번째 줄부터",
        "📍 위치: processHandUpdates() 내부, skeleton guard 아래",
    ),
    "03-HandJoints-03.swift": (
        "✅ 코드 추가: 약 44번째 줄과 약 76번째 줄부터",
        "📍 위치: processHandUpdates() 내부 Joint 선택 아래와 HandTrackingManager 클래스 하단",
    ),
    "04-FingerDistance-01.swift": (
        "📄 새 파일 생성: 약 1번째 줄부터",
        "📍 위치: Grasp 앱 Target 내부",
    ),
    "04-FingerDistance-02.swift": (
        "✅ 코드 추가: 약 9번째 줄과 약 74번째 줄부터",
        "📍 위치: HandTrackingManager 프로퍼티 영역과 processHandUpdates()의 wristPosition 계산 아래",
    ),
    "04-FingerDistance-03.swift": (
        "🔄 코드 교체: 약 74번째 줄부터",
        "📍 위치: processHandUpdates() 내부의 기존 indexDistance 출력 부분",
    ),
    "05-GraspProgress-01.swift": (
        "✅ 코드 추가: 약 11번째 줄부터",
        "📍 위치: GraspDetector 구조체 내부, fingerDistance(from:to:) 메서드 아래",
    ),
    "05-GraspProgress-02.swift": (
        "✅ 코드 추가: 약 22번째 줄부터",
        "📍 위치: GraspDetector 구조체 내부, closureProgress(distance:) 메서드 아래",
    ),
    "05-GraspProgress-03.swift": (
        "✅ 코드 추가: 약 90번째 줄부터",
        "📍 위치: processHandUpdates() 내부, 다섯 손가락 Position과 wristPosition 계산 아래",
    ),
    "06-SphereVisibility-01.swift": (
        "📄 새 파일 생성: 약 1번째 줄부터",
        "📍 위치: Grasp 앱 Target 내부",
    ),
    "06-SphereVisibility-02.swift": (
        "✏️ 코드 수정: 약 9번째 줄부터",
        "📍 위치: ImmersiveView.body 내부의 RealityView content 클로저",
    ),
    "06-SphereVisibility-03.swift": (
        "✅ 코드 추가: 약 9번째 줄, 약 120번째 줄, 약 146번째 줄부터",
        "📍 위치: HandTrackingManager 프로퍼티 영역, processHandUpdates()의 graspProgress 계산 아래, 클래스 하단",
    ),
    "06-SphereVisibility-04.swift": (
        "✏️ 코드 수정: 약 40번째 줄과 약 49번째 줄",
        "📍 위치: processHandUpdates() 내부의 isTracked guard와 skeleton guard",
    ),
}


def inline_content_from_text(text: str) -> list[dict[str, str]]:
    """Convert lightweight backtick spans into DocC inline code nodes."""
    inline_content: list[dict[str, str]] = []
    parts = text.split("`")

    for index, part in enumerate(parts):
        if not part:
            continue

        if index % 2:
            inline_content.append({"type": "codeVoice", "code": part})
        else:
            inline_content.append({"type": "text", "text": part})

    return inline_content


def guide_caption(guide: tuple[str, str]) -> list[dict[str, object]]:
    title, location = guide
    return [
        {
            "type": "paragraph",
            "inlineContent": inline_content_from_text(f"{title}\n{location}"),
        }
    ]


def normalized_base_path(value: str) -> str:
    base_path = value.strip() or "/"
    if not base_path.startswith("/"):
        base_path = f"/{base_path}"
    if not base_path.endswith("/"):
        base_path = f"{base_path}/"
    return base_path


def inject_asset_tags(html_path: Path, base_path: str) -> None:
    html = html_path.read_text(encoding="utf-8")
    stylesheet = (
        f'<link href="{base_path}css/grasp-tutorial.css" rel="stylesheet">'
    )
    script = f'<script defer src="{base_path}js/grasp-tutorial.js"></script>'

    if "grasp-tutorial.css" not in html:
        html = html.replace("</head>", f"{stylesheet}</head>")

    if "grasp-tutorial.js" not in html:
        html = html.replace("</body>", f"{script}</body>")

    html_path.write_text(html, encoding="utf-8")


def mark_swift_code(node: object) -> None:
    if isinstance(node, dict):
        code_file = node.get("code")
        if node.get("type") == "step" and code_file in CODE_GUIDES:
            node["caption"] = guide_caption(CODE_GUIDES[str(code_file)])

        identifier = str(node.get("identifier", ""))
        file_name = str(node.get("fileName", ""))
        is_swift_file = identifier.endswith(".swift") or file_name.endswith(".swift")

        if node.get("type") == "file" and is_swift_file:
            node["syntax"] = "swift"
            node["fileType"] = "swift"

        for value in node.values():
            mark_swift_code(value)

    elif isinstance(node, list):
        for item in node:
            mark_swift_code(item)


def update_json_file(json_path: Path) -> None:
    try:
        data = json.loads(json_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return

    mark_swift_code(data)
    json_path.write_text(
        json.dumps(data, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: enhance-docc-site.py <site-dir> [base-path]", file=sys.stderr)
        return 2

    site_dir = Path(sys.argv[1]).resolve()
    base_path = normalized_base_path(sys.argv[2] if len(sys.argv) > 2 else "/")

    if not site_dir.is_dir():
        print(f"Site directory not found: {site_dir}", file=sys.stderr)
        return 1

    css_dir = site_dir / "css"
    js_dir = site_dir / "js"
    css_dir.mkdir(parents=True, exist_ok=True)
    js_dir.mkdir(parents=True, exist_ok=True)

    source_dir = Path(__file__).resolve().parent
    shutil.copy2(source_dir / "grasp-tutorial.css", css_dir / "grasp-tutorial.css")
    shutil.copy2(source_dir / "grasp-tutorial.js", js_dir / "grasp-tutorial.js")
    (site_dir / "theme-settings.json").write_text("{}\n", encoding="utf-8")

    for html_path in site_dir.rglob("*.html"):
        inject_asset_tags(html_path, base_path)

    data_dir = site_dir / "data"
    if data_dir.exists():
        for json_path in data_dir.rglob("*.json"):
            update_json_file(json_path)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
