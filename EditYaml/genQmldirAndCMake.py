from string import Template
from typing import List
import glob
from pathlib import Path
from jinja2 import Environment, FileSystemLoader
import os


path = Path(".")

def get_glob_pattersns(patterns):
    return [p for pat in patterns for p in sorted(path.glob(pat))]

template_dict = {
    "module_name" : "EditYaml",
    "qml_glob" : get_glob_pattersns(["**/*.qml"]),
    "qml_singletons": [],
    "cpp_sources": get_glob_pattersns(["**/*.cpp"]),
    "qt6_required": [],
    "RESOURCES" : get_glob_pattersns(["icons/*.svg"])
}


environment = Environment(loader=FileSystemLoader("."))
template = environment.get_template("qmldir.j2")
content = template.render(
    template_dict
)
with open("qmldir", "w") as text_file:
    text_file.write(content)

template = environment.get_template("CMakeLists.j2")
content = template.render(
    template_dict
)
with open("CMakeLists.txt", "w") as text_file:
    text_file.write(content)