// // @ts-check

// import eslint from '@eslint/js'
// import tseslint from 'typescript-eslint'
// import prettierConfig from 'eslint-config-prettier'
// import globals from 'globals'

// export default tseslint.config(
//   // 1. グローバルに無視するファイルやディレクトリ
//   {
//     ignores: ['node_modules/', 'dist/'],
//   },

//   // 2. ESLintの推奨設定
//   eslint.configs.recommended,

//   // 3. TypeScript-ESLintの推奨設定
//   ...tseslint.configs.recommended,

//   // 4. 実行環境の設定 (Node.js)
//   // ブラウザで動くコードの場合は globals.browser を使います
//   {
//     languageOptions: {
//       globals: {
//         ...globals.node, // Node.jsのグローバル変数を有効化
//       },
//     },
//   },

//   // 5. Prettierとの競合ルールを無効化する設定（必ず最後に置く）
//   prettierConfig
// )
