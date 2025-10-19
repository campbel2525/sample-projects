'use client'

import { useSession, signOut } from 'next-auth/react'
import Link from 'next/link'
import { APP_PAGES } from '@/lib/shared/config'

export default function Home() {
  const { data: session, status } = useSession()

  if (status === 'loading') {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-lg">読み込み中...</div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-100">
      <header className="bg-white shadow-sm">
        <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <h1 className="text-xl font-bold text-gray-900">
              サンプルアプリケーション
            </h1>
            <div className="flex items-center gap-4">
              {session ? (
                <>
                  <span className="text-sm text-gray-600">
                    こんにちは、{session.user.name ?? session.user.email}さん
                  </span>
                  <button
                    onClick={() => {
                      void signOut()
                    }}
                    className="px-4 py-2 bg-red-600 text-white text-sm font-medium rounded-md hover:bg-red-700"
                  >
                    ログアウト
                  </button>
                </>
              ) : (
                <div className="flex items-center gap-2">
                  <Link
                    href={APP_PAGES.auth.login}
                    className="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700"
                  >
                    ログイン
                  </Link>
                  <Link
                    href={APP_PAGES.auth.register}
                    className="px-4 py-2 bg-green-600 text-white text-sm font-medium rounded-md hover:bg-green-700"
                  >
                    新規登録
                  </Link>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>

      <main className="py-10">
        <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-white shadow-sm rounded-lg overflow-hidden">
            <div className="px-4 py-5 sm:p-6">
              {session ? (
                <div>
                  <h2 className="text-lg font-medium text-gray-900">ダッシュボード</h2>
                  <div className="mt-4 pt-4 border-t border-gray-200">
                    <Link
                      href={APP_PAGES.auth.profile}
                      className="inline-block px-6 py-3 bg-blue-600 text-white font-medium rounded-md hover:bg-blue-700"
                    >
                      マイページへ
                    </Link>
                  </div>
                </div>
              ) : (
                <div>
                  <h2 className="text-lg font-medium text-gray-900">ようこそ</h2>
                  <p className="mt-2 text-sm text-gray-600">
                    このアプリケーションを使用するにはログインが必要です。
                  </p>
                  <div className="mt-4 flex gap-4">
                    <Link
                      href={APP_PAGES.auth.login}
                      className="inline-block px-6 py-3 bg-blue-600 text-white font-medium rounded-md hover:bg-blue-700"
                    >
                      ログイン
                    </Link>
                    <Link
                      href={APP_PAGES.auth.register}
                      className="inline-block px-6 py-3 bg-green-600 text-white font-medium rounded-md hover:bg-green-700"
                    >
                      新規登録
                    </Link>
                  </div>
                  <div className="mt-4 pt-4 border-t border-gray-200">
                    <p className="text-xs text-gray-500">
                      初めてご利用の方は「新規登録」から、既にアカウントをお持ちの方は「ログイン」からお進みください。
                    </p>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
