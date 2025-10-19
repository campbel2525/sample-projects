import { NextAuthOptions } from 'next-auth'
import CredentialsProvider from 'next-auth/providers/credentials'
import { createHash } from 'crypto'
import { NEXT_AUTH_CONFIG, APP_PAGES } from '@/lib/shared/config'
import { prisma } from '@my-monorepo/db/client'

export const authOptions: NextAuthOptions = {
  providers: [
    CredentialsProvider({
      name: 'credentials',
      credentials: {
        email: { label: 'Email', type: 'email' },
        password: { label: 'Password', type: 'password' },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          return null
        }

        try {
          // ユーザーを検索
          const user = await prisma[NEXT_AUTH_CONFIG.userModel].findUnique({
            where: {
              [NEXT_AUTH_CONFIG.fields.email]: credentials.email,
            },
          })

          if (!user) {
            return null
          }

          // 設定されたハッシュ方式でパスワードをハッシュ化して比較
          const hashedPassword = createHash(NEXT_AUTH_CONFIG.passwordHash)
            .update(credentials.password)
            .digest('hex')

          if (user[NEXT_AUTH_CONFIG.fields.password] !== hashedPassword) {
            return null
          }

          // 認証成功時にユーザー情報を返す
          return {
            id: user[NEXT_AUTH_CONFIG.fields.id].toString(),
            email: user[NEXT_AUTH_CONFIG.fields.email],
            name: user[NEXT_AUTH_CONFIG.fields.name],
          }
        } catch {
          return null
        }
      },
    }),
  ],
  session: {
    strategy: 'jwt',
    maxAge: NEXT_AUTH_CONFIG.session.maxAge,
  },
  jwt: {
    maxAge: NEXT_AUTH_CONFIG.session.maxAge,
  },
  pages: {
    signIn: APP_PAGES.auth.login,
  },
  cookies: {
    sessionToken: {
      name: NEXT_AUTH_CONFIG.cookies.sessionToken,
      options: {
        httpOnly: true,
        sameSite: 'lax',
        path: '/',
        secure: process.env.NODE_ENV === 'production',
      },
    },
    callbackUrl: {
      name: NEXT_AUTH_CONFIG.cookies.callbackUrl,
      options: {
        sameSite: 'lax',
        path: '/',
        secure: process.env.NODE_ENV === 'production',
      },
    },
    csrfToken: {
      name: NEXT_AUTH_CONFIG.cookies.csrfToken,
      options: {
        httpOnly: true,
        sameSite: 'lax',
        path: '/',
        secure: process.env.NODE_ENV === 'production',
      },
    },
  },
  callbacks: {
    async jwt({ token, user }) {
      // 初回ログイン時にユーザー情報をトークンに設定
      if (user) {
        token.id = user.id
        token.name = user.name
        token.email = user.email
      }

      // セッションが要求されるたびにDBから最新のユーザー情報を取得してトークンを更新
      if (token.id) {
        const dbUser = await prisma[NEXT_AUTH_CONFIG.userModel].findUnique({
          where: { [NEXT_AUTH_CONFIG.fields.id]: parseInt(token.id) },
        })

        // ユーザーが存在する場合、トークンを最新情報で更新
        if (dbUser) {
          token.name = dbUser[NEXT_AUTH_CONFIG.fields.name]
          token.email = dbUser[NEXT_AUTH_CONFIG.fields.email]
        }
      }

      return token
    },
    session({ session, token }) {
      if (session.user) {
        session.user.id = token.id
        session.user.name = token.name
        session.user.email = token.email
      }
      return session
    },
  },
}
