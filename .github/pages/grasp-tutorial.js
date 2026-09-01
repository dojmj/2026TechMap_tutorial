(function () {
  const codeGuidePrefixes = [
    "✅ 코드 추가:",
    "✏️ 코드 수정:",
    "🗑️ 코드 삭제:",
    "🔄 코드 교체:",
    "📄 새 파일 생성:",
    "📌 코드 확인:",
  ];

  const resultPrefixes = [
    "✅ 실행 결과",
    "확인할 결과",
    "성공 기준",
  ];

  const filePrefixes = [
    "+ 새 파일:",
    "수정할 파일:",
    "확인할 파일:",
  ];

  function normalizedText(element) {
    return (element.textContent || "").replace(/\s+/g, " ").trim();
  }

  function isLeafTextElement(element, text) {
    if (!text || text.length > 240) {
      return false;
    }

    if (element.closest("pre, code")) {
      return false;
    }

    return !element.querySelector("p, pre, table, ul, ol, section, article");
  }

  function startsWithAny(text, prefixes) {
    return prefixes.some((prefix) => text.startsWith(prefix));
  }

  function splitCodeGuideRows(element) {
    if (element.dataset.graspGuideRows === "true") {
      return;
    }

    const lines = (element.textContent || "")
      .replace(/\r\n/g, "\n")
      .split("\n")
      .map((line) => line.trim())
      .filter(Boolean);

    if (lines.length !== 2) {
      return;
    }

    if (!startsWithAny(lines[0], codeGuidePrefixes) || !lines[1].startsWith("📍 위치:")) {
      return;
    }

    element.textContent = "";
    lines.forEach((line, index) => {
      const row = document.createElement("span");
      row.className = index === 0
        ? "grasp-code-guide-row grasp-code-guide-action"
        : "grasp-code-guide-row grasp-code-guide-location";
      row.textContent = line;
      element.appendChild(row);
    });
    element.dataset.graspGuideRows = "true";
  }

  function decorateTextBlocks() {
    document.querySelectorAll("p, li, span, div, figcaption").forEach((element) => {
      const text = normalizedText(element);

      if (
        element.closest(".grasp-code-guide")
        && !element.classList.contains("grasp-code-guide")
      ) {
        return;
      }

      if (!isLeafTextElement(element, text)) {
        return;
      }

      if (startsWithAny(text, filePrefixes)) {
        element.classList.add("grasp-code-file");
      }

      if (startsWithAny(text, codeGuidePrefixes)) {
        element.classList.add("grasp-code-guide");
        splitCodeGuideRows(element);
      }

      if (startsWithAny(text, resultPrefixes)) {
        element.classList.add("grasp-result-guide");
      }

      if (text.startsWith("[IMAGE NEEDED:")) {
        element.classList.add("grasp-image-needed");
      }

      if (/^Step\s+\d+$/.test(text)) {
        element.classList.add("grasp-step-label");
      }
    });

    document.querySelectorAll("pre").forEach((element) => {
      element.classList.add("grasp-code-block");
    });
  }

  let scheduled = false;

  function scheduleDecorate() {
    if (scheduled) {
      return;
    }

    scheduled = true;
    window.requestAnimationFrame(() => {
      scheduled = false;
      decorateTextBlocks();
    });
  }

  document.addEventListener("DOMContentLoaded", scheduleDecorate);
  window.addEventListener("hashchange", scheduleDecorate);

  const observer = new MutationObserver(scheduleDecorate);
  observer.observe(document.documentElement, {
    childList: true,
    subtree: true,
  });

  scheduleDecorate();
})();
