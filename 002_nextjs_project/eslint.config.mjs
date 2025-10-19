// eslint.config.mjs
import { dirname } from "path";
import { fileURLToPath } from "url";
import eslint from "@eslint/js";
import tseslint from "typescript-eslint";
import prettierConfig from "eslint-config-prettier";
import globals from "globals";

const projectRoot = dirname(fileURLToPath(import.meta.url));

// The `tseslint.config` helper simplifies creating flat configurations.
export default tseslint.config(
  // 1. Global ignores for the entire monorepo.
  {
    ignores: [
      "**/node_modules/",
      "**/dist/",
      "**/.next/",
      "**/coverage/",
      "**/build/",
      // IMPORTANT: Ignore config files recursively using `**/`.
      "**/*.config.js",
      "**/*.config.mjs",
      "**/*.config.ts",
      "**/*.d.ts",
      "repomix-output.xml",
      "packages/db/prisma/migrations/**",
    ],
  },

  // 2. Apply ESLint's recommended and typescript-eslint's base recommended rules to all files.
  // These are spread directly into the main config array.
  eslint.configs.recommended,
  ...tseslint.configs.recommended,

  // 3. Apply rules that REQUIRE type information ONLY to TypeScript files.
  {
    files: ["**/*.ts", "**/*.tsx"],
    extends: [
      ...tseslint.configs.recommendedTypeChecked,
      ...tseslint.configs.stylisticTypeChecked,
    ],
    languageOptions: {
      parserOptions: {
        project: true, // Auto-detects tsconfig.json files.
        tsconfigRootDir: projectRoot,
      },
    },
  },

  // 4. Set up global variables for browser and Node.js environments.
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
      },
    },
  },

  // 5. Apply your common rule customizations across all linted files.
  {
    rules: {
      "no-console": "warn",
      "@typescript-eslint/no-unused-vars": [
        "error",
        {
          argsIgnorePattern: "^_",
          varsIgnorePattern: "^_",
          caughtErrorsIgnorePattern: "^_",
        },
      ],
      "@typescript-eslint/no-explicit-any": "warn",
      "@typescript-eslint/no-unsafe-function-type": "warn",
    },
  },

  // 6. As a safeguard, explicitly disable type-aware rules for JavaScript files.
  {
    files: ["**/*.js", "**/*.mjs", "**/*.cjs"],
    extends: [tseslint.configs.disableTypeChecked],
  },

  // 7. Prettier config must be LAST to override other formatting rules.
  prettierConfig,
);
