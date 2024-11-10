# 创建一个 reactjs + typescript + tailwindcss + python 项目

1. 当你进行编程的请使用 react-router-dom v6 版本的API。
2. 整体技术组合是：reactjs + typescript + tailwindcss + python. 前端编译后会打包成静态文件，然后通过Python的package_data 集成到python包里，最后发布到pypi里。

下面的 Makefile 内容可以通过运行 make ts 用于在一个项目目录里创建一个 frontend 应用，然后使用前面提到的 reactjs + typescript + tailwindcss 技术栈。

##File: Makefile 示例文件
# Makefile for running the translation service

# The Python interpreter to use
PYTHON := python

FRONTEND_DIR = ./frontend


# Help command to display available commands
help:
	@echo "Available commands:"
	@echo "  make run  - Run the translation service"
	@echo "  make help - Display this help message"

create_project:	
	npx create-react-app frontend --template typescript
	cd $(FRONTEND_DIR) && rm -rf .git

install_dependencies:
	cd $(FRONTEND_DIR) && npm install -D tailwindcss postcss autoprefixer
	cd $(FRONTEND_DIR) && npm install axios react-router-dom
	cd $(FRONTEND_DIR) && npm install --save-dev @types/react-router-dom

init_tailwind:
	cd $(FRONTEND_DIR) && npx tailwindcss init -p

configure:
	@echo "@import 'tailwindcss/base';" | cat - $(FRONTEND_DIR)/src/index.css > temp && mv temp $(FRONTEND_DIR)/src/index.css
	@echo "@import 'tailwindcss/components';" >> $(FRONTEND_DIR)/src/index.css
	@echo "@import 'tailwindcss/utilities';" >> $(FRONTEND_DIR)/src/index.css
	@echo "/** @type {import('tailwindcss').Config} */" > $(FRONTEND_DIR)/tailwind.config.js
	@echo "module.exports = {" >> $(FRONTEND_DIR)/tailwind.config.js
	@echo "  content: ['./src/**/*.{js,jsx,ts,tsx}', './public/index.html']," >> $(FRONTEND_DIR)/tailwind.config.js
	@echo "  theme: {" >> $(FRONTEND_DIR)/tailwind.config.js
	@echo "    extend: {}," >> $(FRONTEND_DIR)/tailwind.config.js
	@echo "  }," >> $(FRONTEND_DIR)/tailwind.config.js
	@echo "  plugins: []," >> $(FRONTEND_DIR)/tailwind.config.js
	@echo "}" >> $(FRONTEND_DIR)/tailwind.config.js

ts: create_project install_dependencies init_tailwind configure

clean:
	rm -rf frontend
    

## 创建 Python 后端

##File: setup.py 示例文件

import os
from setuptools import find_packages
from setuptools import setup

folder = os.path.dirname(__file__)
version_path = os.path.join(folder, "src", "williamtoolbox", "version.py")

__version__ = None
with open(version_path) as f:
    exec(f.read(), globals())

req_path = os.path.join(folder, "requirements.txt")
install_requires = []
if os.path.exists(req_path):
    with open(req_path) as fp:
        install_requires = [line.strip() for line in fp]

readme_path = os.path.join(folder, "README.md")
readme_contents = ""
if os.path.exists(readme_path):
    with open(readme_path) as fp:
        readme_contents = fp.read().strip()

setup(
    name="williamtoolbox",
    version=__version__,
    description="williamtoolbox: William Toolbox",
    author="allwefantasy",
    long_description=readme_contents,
    long_description_content_type="text/markdown",
    entry_points={
        'console_scripts': [
            'william.toolbox = williamtoolbox.williamtoolbox_command:main',
            'william.toolbox.backend = williamtoolbox.server.backend_server:main',
            'william.toolbox.frontend = williamtoolbox.server.proxy_server:main',
        ],
    },
    package_dir={"": "src"},
    packages=find_packages("src"),    
    package_data={
        "williamtoolbox": ["web/**/*"],
    },
    install_requires=install_requires,
    classifiers=[        
        "Topic :: Scientific/Engineering :: Artificial Intelligence",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
    requires_python=">=3.9",
)


在上面的文件中，核心有两点
1. 通过 package_data 指定静态文件所在的目录，以及需要包含的文件。
2. 通过 entry_points 指定可执行命令。

python 目录结构为项目根目录里有src,setup.py,README.md,Makefile,deploy.sh， 以及.gitignore文件。.gitignore文件里至少需要 web,logs,__pycache__,dist,build,pasted 等目录。

前后端构建好后，下面是典型的发布脚本：

##File: Makefile 示例文件

release: ## Build and package web assets	
	cd frontend && npm install && npm run build
	tar -czf web.static.tar.gz -C frontend/build .
	rm -rf src/williamtoolbox/web && mkdir -p src/williamtoolbox/web	
	mv web.static.tar.gz src/williamtoolbox/web/	
	cd src/williamtoolbox/web/ && tar -xzf web.static.tar.gz && rm web.static.tar.gz
	./deploy.sh && pip install -e .

##File: deploy.sh 示例文件

#!/bin/bash

# 项目名称
project="williamtoolbox"

# 使用Python一行命令提取版本号，减少对grep和cut的依赖
version=$(python -c "with open('src/williamtoolbox/version.py') as f: print([line.split('=')[1].strip().strip('\"') for line in f if '__version__' in line][0])")
echo "Version: $version"

# 清理dist目录
echo "Clean dist"
rm -rf ./dist/*

# 卸载当前安装的项目版本
echo "Uninstall ${project}"
pip uninstall -y ${project}

# 构建项目
echo "Build ${project} ${version}"
python setup.py sdist bdist_wheel
cd ./dist/

# 安装新构建的项目版本
echo "Install ${project} ${version}"
pip install ${project}-${version}-py3-none-any.whl && cd -

# 默认模式设定
export MODE=${MODE:-"release"}

# 发布模式下的操作
if [[ ${MODE} == "release" ]]; then
 git tag v${version}
 git push origin v${version}  # 请根据实际情况使用正确的远程仓库名
 echo "Upload ${project} ${version}"
 twine upload dist/*
fi





