const battery = await Service.import("battery");

export const BatteryLabel = () => {
  const batteryPercent = battery
    .bind("percent")
    .as((p) => (p > 0 ? p / 100 : 0));
  return Widget.Box({
    className: battery
      .bind("charging")
      .as((ch) => (ch ? "battery-label charging" : "battery-label")),
    visible: battery.bind("available"),
    vertical: true,
    children: [
      Widget.Box({
        className: "battery-bulb",
        hexpand: false,
      }),
      Widget.LevelBar({
        vertical: true,
        heightRequest: 28,
        value: batteryPercent,
        inverted: true,
      }),
      Widget.Label({}).hook(
        battery,
        (self) => (self.label = `${battery.percent}%`),
      ),
    ],
  });
};
