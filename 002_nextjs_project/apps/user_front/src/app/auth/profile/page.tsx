'use client'

import { useSession, signOut } from 'next-auth/react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { APP_PAGES } from '@/lib/shared/config'

export default function ProfilePage() {
  const { data: session, status } = useSession()
  const router = useRouter()

  if (status === 'loading') {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-lg">読み込み中...</div>
      </div>
    )
  }

  if (!session) {
    router.push(APP_PAGES.auth.login)
    return null
  }

  return (
    <div className="min-h-screen bg-gray-100">
      <header className="bg-white shadow-sm">
        <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <h1 className="text-xl font-bold text-gray-900">マイページ</h1>
            <div className="flex items-center gap-4">
              <Link
                href={APP_PAGES.home}
                className="text-sm text-gray-600 hover:text-gray-900"
              >
                ホームに戻る
              </Link>
              <button
                onClick={() => {
                  void signOut()
                }}
                className="px-4 py-2 bg-red-600 text-white text-sm font-medium rounded-md hover:bg-red-700"
              >
                ログアウト
              </button>
            </div>
          </div>
        </div>
      </header>

      <main className="py-10">
        <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-white shadow-sm rounded-lg overflow-hidden">
            <div className="px-4 py-5 sm:p-6">
              <h2 className="text-lg font-medium text-gray-900">プロフィール情報</h2>
              <div className="mt-4 space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700">
                    ユーザーID
                  </label>
                  <p className="mt-1 text-sm text-gray-900 p-2 bg-gray-50 rounded-md">
                    {session.user.id}
                  </p>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">
                    メールアドレス
                  </label>
                  <p className="mt-1 text-sm text-gray-900 p-2 bg-gray-50 rounded-md">
                    {session.user.email}
                  </p>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">
                    名前
                  </label>
                  <p className="mt-1 text-sm text-gray-900 p-2 bg-gray-50 rounded-md">
                    {session.user.name}
                  </p>
                </div>
              </div>
            </div>
          </div>

          <div className="mt-8 bg-white shadow-sm rounded-lg overflow-hidden">
            <div className="px-4 py-5 sm:p-6">
              <h2 className="text-lg font-medium text-gray-900">アカウント設定</h2>
              <div className="mt-4 space-y-3">
                <Link
                  href={APP_PAGES.auth.editProfile}
                  className="block w-full px-4 py-3 bg-green-600 text-white text-center font-medium rounded-md hover:bg-green-700"
                >
                  プロフィールを編集
                </Link>
                <Link
                  href={APP_PAGES.auth.changePassword}
                  className="block w-full px-4 py-3 bg-blue-600 text-white text-center font-medium rounded-md hover:bg-blue-700"
                >
                  パスワードを変更
                </Link>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
