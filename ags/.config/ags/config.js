import { Media } from "./Media.js";

const calendar = Widget.Calendar({
    showDayNames: true,
    showDetails: false,
    showHeading: true,
    showWeekNumbers: true,
    detail: (self, y, m, d) => {
        return `<span color="white">${y}. ${m}. ${d}.</span>`;
    },
    onDaySelected: ({ date: [y, m, d] }) => {
        print(`${y}. ${m}. ${d}.`);
    },
});

const myBox = Widget.Box({
    vertical: false,
    children: [calendar, Widget.Separator({ orientation: 1 }), Media()],
});

// Widget.Window() is top-level container that holds
// all widgets
const win = Widget.Window({
    name: "mpris",
    anchor: ["top"],
    child: myBox,
});

App.config({
    style: "./style.css",
    windows: [win],
});
