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

  const tutorialPathPattern = /\/tutorials\/(?:grasphandtracking|grasp\/)/;

  const imageTreatments = {
    "Hero-GraspSphere.png": {
      imageClass: "grasp-hero-image",
      frameClass: "grasp-hero-media",
    },
    "Step05-GraspStates.png": {
      imageClass: "grasp-concept-image",
      frameClass: "grasp-concept-media",
      label: "Grasp Concept",
    },
    "Step06-SphereResult.png": {
      imageClass: "grasp-result-image",
      frameClass: "grasp-result-media",
      label: "Expected Result",
    },
  };

  function setPageClasses() {
    document.documentElement.classList.add("grasp-site-enhanced");
    document.documentElement.classList.toggle(
      "grasp-overview-page",
      location.pathname.includes("/tutorials/grasphandtracking/")
    );
    document.documentElement.classList.toggle(
      "grasp-step-page",
      location.pathname.includes("/tutorials/grasp/")
    );
  }

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

  function filenameFromImage(image) {
    const rawSource = image.getAttribute("src") || image.currentSrc || "";
    const path = rawSource.split("?")[0].split("#")[0];
    return path.split("/").pop();
  }

  function mediaFrameForImage(image) {
    const figure = image.closest("figure");

    if (figure) {
      return figure;
    }

    const parent = image.parentElement;

    if (parent && parent.tagName === "PICTURE" && parent.parentElement) {
      return parent.parentElement;
    }

    return parent;
  }

  function ensureImageLabel(frame, label) {
    if (!label || frame.querySelector(".grasp-image-label")) {
      return;
    }

    const badge = document.createElement("span");
    badge.className = "grasp-image-label";
    badge.textContent = label;
    frame.prepend(badge);
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
    setPageClasses();

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

  function decorateHeroText() {
    document.querySelectorAll("h1").forEach((element) => {
      if (normalizedText(element) === "Grasp") {
        element.classList.add("grasp-hero-title");
      }
    });

    document.querySelectorAll("p, div, span").forEach((element) => {
      if (
        isLeafTextElement(element, normalizedText(element))
        && normalizedText(element) === "visionOS · ARKit · Hand Tracking · RealityKit"
      ) {
        element.classList.add("grasp-hero-eyebrow");
      }
    });
  }

  function decorateImages() {
    document.querySelectorAll("img").forEach((image) => {
      const filename = filenameFromImage(image);
      const treatment = imageTreatments[filename];

      if (!treatment) {
        return;
      }

      if (
        filename === "Hero-GraspSphere.png"
        && !location.pathname.includes("/tutorials/grasphandtracking/")
      ) {
        return;
      }

      if (
        filename === "Step05-GraspStates.png"
        && !location.pathname.includes("/tutorials/grasp/05-graspprogress")
      ) {
        return;
      }

      if (
        filename === "Step06-SphereResult.png"
        && !location.pathname.includes("/tutorials/grasp/06-spherevisibility")
      ) {
        return;
      }

      image.classList.add(treatment.imageClass);

      const frame = mediaFrameForImage(image);

      if (!frame) {
        return;
      }

      frame.classList.add("grasp-media-frame", treatment.frameClass);
      ensureImageLabel(frame, treatment.label);
    });
  }

  function decorateSectionHeadings() {
    if (!location.pathname.includes("/tutorials/grasp/")) {
      return;
    }

    const headings = Array.from(document.querySelectorAll("main h2"))
      .filter((heading) => {
        const text = normalizedText(heading);
        return text && !heading.closest("nav, aside, footer");
      });

    if (!headings.length) {
      return;
    }

    headings.forEach((heading, index) => {
      heading.classList.add("grasp-section-heading");

      if (heading.querySelector(".grasp-section-kicker")) {
        return;
      }

      const label = `Section ${index + 1} of ${headings.length}`;
      const existingEyebrow =
        heading.querySelector(".eyebrow a")
        || heading.querySelector(".eyebrow");

      if (existingEyebrow) {
        existingEyebrow.classList.add("grasp-section-kicker");
        existingEyebrow.textContent = label;
        return;
      }

      const kicker = document.createElement("span");
      kicker.className = "grasp-section-kicker";
      kicker.textContent = label;
      heading.prepend(kicker);
    });
  }

  function decorateFooter() {
    if (!tutorialPathPattern.test(location.pathname)) {
      return;
    }

    const main = document.querySelector("main");

    if (!main || main.querySelector(".grasp-site-footer")) {
      return;
    }

    const footer = document.createElement("footer");
    footer.className = "grasp-site-footer";
    footer.innerHTML = 'Grasp · visionOS Hand Tracking Tutorial · <a href="https://github.com/dojmj/2026TechMap_tutorial">View on GitHub</a>';
    main.appendChild(footer);
  }

  function decoratePage() {
    decorateTextBlocks();
    decorateHeroText();
    decorateImages();
    decorateSectionHeadings();
    decorateFooter();
  }

  let scheduled = false;

  function scheduleDecorate() {
    if (scheduled) {
      return;
    }

    scheduled = true;
    window.requestAnimationFrame(() => {
      scheduled = false;
      decoratePage();
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
