const audio = await Service.import("audio");

export const speakerIcon = () => {
  const category = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  };

  const icon = audio.speaker.stream?.is_muted
    ? 0
    : [101, 67, 34, 1, 0].find(
        (threshold) => threshold <= audio.speaker.volume * 100,
      );

  return `audio-volume-${category[icon]}-symbolic`;
};

export const microphoneIcon = () => {
  const category = {
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  };

  const icon = audio.microphone.stream?.is_muted
    ? 0
    : [67, 34, 1, 0].find(
        (threshold) => threshold <= audio.microphone.volume * 100,
      );

  return `microphone-sensitivity-${category[icon]}-symbolic`;
};
