const systemTray = await Service.import("systemtray");

const tray = () =>
  Widget.Box({
    className: "tray",
    spacing: 4,
    children: systemTray.bind("items").as((items) => {
      return items.map((item) =>
        Widget.Button({
          child: Widget.Icon({ icon: item.bind("icon") }),
          tooltip_markup: item.bind("tooltip_markup"),
          on_primary_click: (_, event) => item.activate(event),
          on_secondary_click: (_, event) => item.openMenu(event),
        }),
      );
    }),
  });

export const SysTray = () => {
  const showSysTray = Variable(false);

  const trayRevealer = Widget.Revealer({
    revealChild: false,
    transition_duration: 200,
    transition: "slide_left",
    child: tray(),
    setup: (self) =>
      self.hook(showSysTray, () => {
        self.reveal_child = showSysTray.value;
      }),
  });

  const button = Widget.Button({
    class_name: "tray-button",
    child: Widget.Icon({
      class_name: "icon",
      size: 10,
      icon: "keyboard-hide-symbolic",
      setup: (self) =>
        self.hook(showSysTray, () =>
          self.toggleClassName("showing", showSysTray.value),
        ),
    }),
    onClicked: () => {
      showSysTray.setValue(!showSysTray.value);
    },
  });

  return Widget.Box({
    spacing: 8,
    children: [trayRevealer, button],
  });
};
