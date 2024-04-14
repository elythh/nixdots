import Gdk from "gi://Gdk";

/**
 * @param {number} length
 * @param {number=} start
 * @returns {Array<number>}
 */
export function range(length, start = 1) {
  return Array.from({ length }, (_, i) => i + start);
}

/**
 * @param {(monitor: number) => any} widget
 * @returns {Array<import('types/widgets/window').default>}
 */
export function forMonitors(widget) {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return range(n, 0).map(widget).flat(1);
}
