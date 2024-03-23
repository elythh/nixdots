import { Hyprland } from "../imports.js";

export const getFocusedWorkspace = (self) =>
  self.children.forEach((btn) => {
    if (
      Hyprland.getWorkspace(btn.attribute.index)?.windows > 0 &&
      btn.attribute.index !== Hyprland.active.workspace.id
    ) {
      btn.className = "";
    } else {
      btn.className =
        btn.attribute.index === Hyprland.active.workspace.id
          ? "focused"
          : "empty";
    }
    btn.visible = Hyprland.workspaces.some(
      (ws) => ws.id === btn.attribute.index,
    );
  });
