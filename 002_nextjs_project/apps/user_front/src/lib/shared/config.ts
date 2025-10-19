// クッキーのプレフィックス
export const COOKIE_PREFIX = 'user_front'

// アプリケーション全体のページパス設定
export const APP_PAGES = {
  // 基本ページ
  home: '/',

  // 認証関連
  auth: {
    login: '/auth/login',
    logout: '/auth/logout',
    register: '/auth/register',
    profile: '/auth/profile',
    editProfile: '/auth/edit-profile',
    changePassword: '/auth/change-password',
  },
} as const

// NextAuth.js認証設定
export const NEXT_AUTH_CONFIG = {
  // 使用するテーブル/モデル名
  userModel: 'user',

  // フィールド名のマッピング
  fields: {
    id: 'id',
    email: 'email',
    password: 'password',
    name: 'name',
  },

  // パスワードハッシュ化方式
  passwordHash: 'sha256' as const,

  // セッション設定
  session: {
    maxAge: 60 * 60 * 24 * 30, // 30日
  },

  // NextAuth.js用のクッキー名設定
  cookies: {
    sessionToken: `${COOKIE_PREFIX}-next-auth.session-token`,
    callbackUrl: `${COOKIE_PREFIX}-next-auth.callback-url`,
    csrfToken: `${COOKIE_PREFIX}-next-auth.csrf-token`,
  },
} as const
