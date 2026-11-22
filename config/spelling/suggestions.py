"""Offer British English suggestions for a copied word, then copy the choice."""

import re
import subprocess


def notify(message):
    subprocess.run(["notify-send", "Spelling", message], check=False)


def main():
    clipboard = subprocess.run(
        ["wl-paste", "--no-newline", "--type", "text"],
        capture_output=True, text=True, check=False,
    )
    if clipboard.returncode:
        notify("Copy a word first, then press Super+C.")
        return
    word = clipboard.stdout.strip()
    if len(word) > 128 or not re.fullmatch(r"[^\W\d_]+(?:['-][^\W\d_]+)*", word):
        notify("Copy a single word to request spelling suggestions.")
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
