export const PopupWindow = ({
  /** @type {string} */ name,
  /** @type {any} */ child,
  /** @type {"none" | "crossfade" | "slide_left" | "slide_right" | "slide_down"} */ transition,
  /** @type {number} */ transition_duration,
  /** @type {any[]} */ ...props
}) =>
  Widget.Window({
    name,
    visible: false,
    ...props,
    setup: (self) =>
      self.keybind("Escape", () => {
        App.closeWindow(name);
      }),
    child: Widget.Box({
      css: "min-height: 2px; min-width: 2px",
      child: Widget.Revealer({
        transition,
        transition_duration,
        hexpand: true,
        vexpand: true,
        child: child || Widget.Box(),
        setup: (self) => {
          self.hook(App, (_, windowName, visible) => {
            if (windowName === name) {
              self.reveal_child = visible;
            }
          });
        },
      }),
    }),
  });
