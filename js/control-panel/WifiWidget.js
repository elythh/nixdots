const network = await Service.import("network")

import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

const WifiIndicator = () =>
  Widget.Box({
    hpack: "start",
    spacing: 10,
    children: [
      Widget.Icon({
	class_name: "icon",
        icon: network.wifi.bind("icon_name"),
      }),
      Widget.Label({
        label: network.wifi.bind("ssid").as((ssid) => ssid || "Unknown"),
      }),
    ],
  });
const WiredIndicator = () =>
  Widget.Box({
    spacing: 10,
    hpack: "start",
    children: [
      Widget.Icon({
        class_name: "icon",
        icon: network.wired.bind("icon_name"),
      }),
      Widget.Label("Wired"),
    ],
  });
export const Wifi = () =>
  Widget.Button({
    className: "wifi",
    hexpand: true,
    onClicked: () => execAsync("nm-connection-editor"),
    child: Widget.Stack({
      homogeneous: false,
      children: {
        wifi: WifiIndicator(),
        wired: WiredIndicator(),
      },
      shown: network.bind("primary").as((p) => p || "wifi"),
    }),
  });
