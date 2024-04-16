import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";

/** @param {any} ws */
const dispatch = (ws) => Hyprland.messageAsync(`dispatch workspace ${ws}`);
export const Workspaces = () =>
  Widget.EventBox({
    class_name: "workspaces",
    child: Widget.Box({
      spacing: 4,
      children: Array.from({ length: 5 }, (_, i) => i + 1).map((i) =>
        Widget.Button({
          attribute: i,
          child: Widget.Box({
            vpack: "fill",
          }),
          setup: (self) =>
            self.hook(Hyprland, () => {
              self.toggleClassName(
                "active",
                Hyprland.active.workspace.id === i,
              );
              self.toggleClassName(
                "occupied",
                (Hyprland.getWorkspace(i)?.windows || 0) > 0,
              );
            }),
          onClicked: () => dispatch(i),
        }),
      ),
    }),
  });
