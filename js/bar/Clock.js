import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

export const Clock = () =>
  Widget.Box({
    class_name: "clock",
    spacing: 12,
    children: [
      Widget.Icon({
        class_name: "icon",
        icon: "clock-applet-symbolic",
      }),
      Widget.Label({
        setup: (self) =>
          self.poll(1000, (self) =>
            execAsync(["date", "+%H:%M"]).then((date) => (self.label = date)),
          ),
      }),
    ],
  });
