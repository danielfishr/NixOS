"""Copy the selected word, offer British English suggestions, then copy the choice."""

import json
import os
import re
import select
import subprocess
import sys


def notify(message):
    subprocess.run(["notify-send", "Spelling", message], check=False)


def copy_selection():
    result = subprocess.run(
        ["hyprctl", "activewindow", "-j"], capture_output=True, text=True, check=True,
    )
    window = json.loads(result.stdout)
    address = window.get("address", "")
    if not re.fullmatch(r"0x[0-9a-fA-F]+", address):
        notify("Focus an application and select a word first.")
        return False
    terminal_classes = {
        "kitty", "alacritty", "foot", "footclient", "org.wezfurlong.wezterm",
        "com.mitchellh.ghostty", "org.kde.konsole", "org.gnome.terminal",
        "gnome-terminal", "gnome-terminal-server", "org.gnome.ptyxis", "terminator",
    }
    modifiers = "CTRL + SHIFT" if window.get("class", "").lower() in terminal_classes else "CTRL"
    action = (
        "hl.dsp.send_shortcut({mods=" + json.dumps(modifiers)
        + ', key="C", window=' + json.dumps("address:" + address) + "})"
    )
    # Observe offers, not clipboard contents: even copying the same word is fresh.
    with subprocess.Popen(
        ["wl-paste", "--watch", sys.executable, "-c", 'print("changed", flush=True)'],
        stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
    ) as watcher:
        try:
            def updated():
                return bool(select.select([watcher.stdout], [], [], 1.5)[0]
                            and os.read(watcher.stdout.fileno(), 4096))

            # The initial offer (including an empty clipboard) confirms readiness.
            if not updated():
                notify("Could not watch the clipboard. Try again.")
                return False
            result = subprocess.run(
                ["hyprctl", "dispatch", action], capture_output=True, text=True, check=True,
            )
            if result.stdout.strip() != "ok" or not updated():
                notify("No new copy received. Select a word in an app that supports copying.")
                return False
            return True
        finally:
            watcher.terminate()
            watcher.wait(timeout=2)


def main():
    try:
        if not copy_selection():
            return
    except (subprocess.SubprocessError, ValueError):
        notify("Could not copy the selection from Hyprland.")
        return
    clipboard = subprocess.run(
        ["wl-paste", "--no-newline", "--type", "text"],
        capture_output=True, text=True, check=False,
    )
    if clipboard.returncode:
        notify("Select a word first, then press Super+C.")
        return
    word = clipboard.stdout.strip()
    if len(word) > 128 or not re.fullmatch(r"[^\W\d_]+(?:['-][^\W\d_]+)*", word):
        notify("Select a single word to request spelling suggestions.")
        return

    result = subprocess.run(
        ["aspell", "--lang=en_GB", "--encoding=utf-8", "--mode=none", "-a"],
        input=f"^{word}\n", capture_output=True, text=True, check=False,
    )
    if result.returncode:
        notify("Aspell could not load the en_GB dictionary.")
        return
    suggestions = []
    correct = False
    for line in result.stdout.splitlines()[1:]:
        if line.startswith(("& ", "? ")):
            suggestions.extend(line.partition(": ")[2].split(", "))
        elif line.startswith(("*", "+", "-")):
            correct = True
    suggestions = list(dict.fromkeys(value for value in suggestions if value))
    if not suggestions:
        notify("Word is correctly spelled (en_GB)." if correct else "No suggestions found.")
        return

    choice = subprocess.run(
        ["rofi", "-dmenu", "-i", "-no-custom", "-p", f"Spelling: {word}"],
        input="\n".join(suggestions) + "\n",
        capture_output=True, text=True, check=False,
    )
    if choice.returncode:
        return
    replacement = choice.stdout.rstrip("\n")
    if replacement not in suggestions:
        return
    # Do not overwrite something copied while the suggestion menu was open.
    current = subprocess.run(
        ["wl-paste", "--no-newline", "--type", "text"],
        capture_output=True, text=True, check=False,
    )
    if current.returncode or current.stdout != clipboard.stdout:
        notify("Clipboard changed; the correction was not copied.")
        return
    subprocess.run(["wl-copy", "--type", "text/plain;charset=utf-8"], input=replacement,
                   text=True, check=True)
    notify("Suggestion copied. Paste it to replace the selected word.")


if __name__ == "__main__":
    main()
