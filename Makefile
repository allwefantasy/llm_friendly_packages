# Makefile for setting up ReactJS + TailwindCSS project

# Variables
PROJECT_NAME ?= my_react_project
FRONTEND_DIR = $(PROJECT_NAME)/frontend

.PHONY: all create_project install_dependencies init_tailwind configure clean

all: create_project install_dependencies init_tailwind configure

create_project:
	mkdir -p $(PROJECT_NAME)
	cd $(PROJECT_NAME) && npx create-react-app frontend --template typescript
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
	rm -rf $(PROJECT_NAME)