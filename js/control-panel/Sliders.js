const audio = await Service.import("audio");

import { speakerIcon, microphoneIcon } from "../Variables.js";

/** @param {'speaker' | 'microphone'} type */
const AudioSlider = (type = "speaker") =>
  Widget.Box({
    class_name: `audio-slider ${type}`,
    children: [
      Widget.Icon({ class_name: "icon" }).hook(
        audio,
        (self) => {
          if (!audio[type]) return;
          self.icon = type === "speaker" ? speakerIcon() : microphoneIcon();
        },
        `${type}-changed`,
      ),
      Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => (audio[type].volume = value),
        setup: (self) =>
          self.hook(audio[type], () => {
            self.value = audio[type].volume || 0;
          }),
      }),
      Widget.Label({
        css: "min-width: 3.2rem;",
        justification: "center",
      }).hook(
        audio,
        (self) => {
          let muted = audio[type].stream?.is_muted;
          self.toggleClassName("muted", muted);
          self.label = muted
            ? "mut"
            : `${Math.round(audio[type].volume * 100)}%`;
        },
        `${type}-changed`,
      ),
    ],
  });

export const Speaker = () => AudioSlider("speaker");
export const Microphone = () => AudioSlider("microphone");
