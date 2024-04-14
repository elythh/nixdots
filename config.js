import { Bar } from "./js/bar/Bar.js";
import { NotificationPopup } from "./js/notifs/NotificationPopup.js";
import { controlpanel } from "./js/control-panel/ControlPanel.js";
import { forMonitors } from "./js/utils.js";
import { applauncher } from "./js/app-launcher/AppLauncher.js";
// import { ImageWindow } from "./js/image-window/ImageWindow.js";

let loadCSS = () => {
  const scss = `${App.configDir}/scss/style.scss`;
  const css = `${App.configDir}/finalcss/style.css`;

  Utils.exec(`sassc ${scss} ${css}`);
  App.resetCss(); // reset if need
  App.applyCss(`${App.configDir}/finalcss/style.css`);
};

Utils.monitorFile(
  `${App.configDir}/style/`,
  function () {
    loadCSS();
  },
  "directory",
);

loadCSS();

App.config({
  style: `${App.configDir}/finalcss/style.css`,
  closeWindowDelay: {
    control_panel: 300,
    app_launcher: 300,
  },
  windows: [
    ...forMonitors(Bar),
    // ImageWindow(),
    ...forMonitors(NotificationPopup),
    controlpanel,
    applauncher,
  ],
});
