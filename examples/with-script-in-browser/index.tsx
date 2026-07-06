import React, { StrictMode } from "react";
import { createRoot } from "react-dom/client";

import "eterill-excalidraw/index.css";
import { Excalidraw } from "eterill-excalidraw";

const rootElement = document.getElementById("root")!;
const root = createRoot(rootElement);

// 移除默认边距，防止滚动条
document.body.style.margin = "0";
document.body.style.overflow = "hidden";

root.render(
  <StrictMode>
    <div style={{ height: "100vh", width: "100vw" }}>
      <Excalidraw />
    </div>
  </StrictMode>,
);
