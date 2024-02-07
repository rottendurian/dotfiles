import shutil
import os

prefix = os.path.expanduser("~/.config")
directories = [
    "sway",
    "i3",
    "gammastep",
    "kitty",
    "rofi",
    "wofi",
    "neofetch",
    "waybar",
]


def append_directory(dir, file):
    return dir + "/" + file


def main():
    for dir in directories:
        try:
            shutil.rmtree(dir)
        except FileNotFoundError as err:
            print("intiailizing file", err.filename)

        try:
            shutil.copytree(append_directory(prefix, dir), dir)
        except FileNotFoundError as err:
            print("could not copy directory", err)

    try:
        shutil.rmtree("fonts")
    except:
        pass
    try:
        directory = os.path.expanduser("~/.local/share/fonts")
        shutil.copytree(directory, "fonts")
    except FileNotFoundError as err:
        print("could not copy directory", err)


if __name__ == "__main__":
    main()
