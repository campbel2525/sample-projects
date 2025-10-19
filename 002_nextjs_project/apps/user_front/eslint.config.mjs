// import { dirname } from 'path'
// import { fileURLToPath } from 'url'
// import { FlatCompat } from '@eslint/eslintrc'
// import prettierConfig from 'eslint-config-prettier' // ←【追加】Prettier連携用の設定をインポート

// const __filename = fileURLToPath(import.meta.url)
// const __dirname = dirname(__filename)

// const compat = new FlatCompat({
//   baseDirectory: __dirname,
// })

// // export default eslintConfig ← この形式から、直接配列をエクスポートする形に変更します
// export default [
//   // 1. 【追加】無視するディレクトリの設定
//   // これで .next ディレクトリなどをESLintがチェックしなくなります
//   {
//     ignores: ['.next/', 'node_modules/', 'dist/'],
//   },

//   // 2. Next.jsの基本設定を読み込み (ここは元のコードと同じです)
//   ...compat.extends('next/core-web-vitals', 'next/typescript'),

//   // 3. 【追加】未使用変数(_)を許可するためのルールカスタマイズ
//   {
//     rules: {
//       '@typescript-eslint/no-unused-vars': [
//         'error',
//         {
//           argsIgnorePattern: '^_',
//           varsIgnorePattern: '^_',
//           caughtErrorsIgnorePattern: '^_',
//         },
//       ],
//     },
//   },

//   // 4. 【追加】Prettierとの競合回避設定 (必ず配列の最後に置きます！)
//   prettierConfig,
// ]
