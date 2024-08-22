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
npm install axios
npm install react-router-dom
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

