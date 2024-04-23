dir_path = "C:/Users/admin/Desktop/ss13/white/strings/names"

from os import path, listdir

for file in listdir(dir_path):
    if file.endswith(".txt"):
        with open(path.join(dir_path, file), "r", encoding="utf-8") as f:
            lines = f.readlines()
            lines.sort()
        with open(path.join(dir_path, file), "w", encoding="utf-8") as f:
            f.writelines(lines)
