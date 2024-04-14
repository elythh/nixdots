export const AppLauncherButton = () =>
  Widget.Button({
    className: "app-l-button",
    onClicked: () => App.toggleWindow("app_launcher"),
    child: Widget.Icon({
      className: "icon",
      icon: "system-search-symbolic",
    }),
  });
