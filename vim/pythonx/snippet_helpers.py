import re
import inflection
import os

def path_without_extension(path):
    return re.sub(r"(.*?)\.(.*)$", "\\1", path)

def path_without_first_dir(path):
    if re.search(r"^(app|spec|lib/tasks|test|web)\/", path):
        return re.sub(r"^([a-z-]+\/){2}", "", path)
    else:
        return re.sub(r"^([a-z-]+\/){1}", "", path)

def path_first_dir(path):
    return re.sub(r"\/.*$", "", path)

def path_as_class_name(path, separator = "::", blacklist = []):
    path = path_without_extension(path)
    path = re.sub(r"^_", "", path)
    parts = path.split("/")
    uniq_parts = []
    for part in parts:
        print(part)
        if part not in blacklist and part not in uniq_parts:
            uniq_parts.append(part)
    print(uniq_parts)
    return separator.join(map(inflection.camelize, uniq_parts))

def current_project_name():
    return re.sub(r".*\/([^/]*)$", "\\1", os.getcwd())

def filename_without_extension(path):
    return path.split("/")[-1].split(".")[0]
