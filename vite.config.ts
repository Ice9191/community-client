import { defineConfig } from "vite";
import uni from "@dcloudio/vite-plugin-uni";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [uni()],
  css: {
    preprocessorOptions: {
      scss: {
        // 静默 Dart Sass 弃用警告（来自 Vite 旧版 JS API 及 uni-ui 组件内部的 mix()/darken()）
        silenceDeprecations: [
          "legacy-js-api",
          "global-builtin",
          "color-functions",
        ],
      },
    },
  },
});
