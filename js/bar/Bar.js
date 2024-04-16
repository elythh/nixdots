import { Workspaces } from "./Workspaces.js";
import { Clock } from "./Clock.js";
import { SysTray } from "./SysTray.js";
import { ControlButton } from "./ControlButton.js";
import { BatteryLabel } from "./BatteryLabel.js";
import { AppLauncherButton } from "./AppLauncherButton.js";

const StartBox = () =>
  Widget.Box({
    // vertical: true,
    hpack: "start",
    css: "margin: 0.2rem 0.8em",
    spacing: 8,
    children: [AppLauncherButton(), Workspaces()],
  });

const EndBox = () =>
  Widget.Box({
    css: "margin: 0.2rem 0.8em",
    // vertical: true,
    hpack: "end",
    spacing: 8,
    children: [SysTray(), BatteryLabel(), Clock(), ControlButton()],
  });

export const Bar = (monitor = 0) =>
  Widget.Window({
    name: `bar-${monitor}`,
    class_name: "bar",
    monitor,
    anchor: ["right", "bottom", "left"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      class_name: "cbox",
      // vertical: true,
      start_widget: StartBox(),
      end_widget: EndBox(),
    }),
  });
