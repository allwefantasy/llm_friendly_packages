# ReactJS + TailwindCSS 快速指南

## 准备项目/环境

```bash
mkdir <PROJECT_NAME>
cd  <PROJECT_NAME>

npx create-react-app frontend --template typescript
cd frontend
rm -rf .git
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
npm install axios react-router-dom
npm install --save-dev @types/react-router-dom

cd ..
auto-coder init --source_dir .
```

tailwindcss 需要配置一下，修改 `frontend/src/index.css`,在最前面添加:

```css
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';
```

然后修改`tailwind.config.js`:

```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {  
  content: ['./src/**/*.{js,jsx,ts,tsx}', './public/index.html'],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

## 注意事项

1. 当你进行编程的请使用 react-router-dom v6 版本的API。
2. 整体技术组合是：reactjs + typescript + tailwindcss

下面的 Makefile 内容可以通过运行 make ts 用于在一个项目目录里创建一个 frontend 应用，然后使用前面提到的 reactjs + typescript + tailwindcss 技术栈。

```makefile
# Makefile for running the translation service

# The Python interpreter to use
PYTHON := python

FRONTEND_DIR = ./frontend


# Help command to display available commands
help:
	@echo "Available commands:"
	@echo "  make run  - Run the translation service"
	@echo "  make help - Display this help message"

ts: create_project install_dependencies init_tailwind configure

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

clean:
	rm -rf frontend
```  

