import { NextRequest, NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/server/auth'
import { NEXT_AUTH_CONFIG } from '@/lib/shared/config'
import { prisma } from '@my-monorepo/db/client'

export async function POST(request: NextRequest) {
  try {
    // セッション確認
    const session = await getServerSession(authOptions)
    if (!session?.user) {
      return NextResponse.json({ error: '認証が必要です' }, { status: 401 })
    }

    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    const { name, email }: { name?: string; email?: string } = await request.json()

    if (!name || !email) {
      return NextResponse.json(
        { error: '名前とメールアドレスは必須です' },
        { status: 400 }
      )
    }

    // 名前とメールアドレスのバリデーション
    if (!name || name.trim().length === 0) {
      return NextResponse.json({ error: '名前は必須です' }, { status: 400 })
    }

    if (!email || email.trim().length === 0) {
      return NextResponse.json({ error: 'メールアドレスは必須です' }, { status: 400 })
    }

    // 簡単なメールバリデーション
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(email.trim())) {
      return NextResponse.json(
        { error: '有効なメールアドレスを入力してください' },
        { status: 400 }
      )
    }

    // 現在のユーザー情報を取得
    const currentUser = await prisma[NEXT_AUTH_CONFIG.userModel].findUnique({
      where: {
        [NEXT_AUTH_CONFIG.fields.id]: parseInt(session.user.id),
      },
    })

    if (!currentUser) {
      return NextResponse.json({ error: 'ユーザーが見つかりません' }, { status: 404 })
    }

    // メールアドレスが変更されている場合、重複チェック
    if (email.trim() !== currentUser[NEXT_AUTH_CONFIG.fields.email]) {
      const existingUser = await prisma[NEXT_AUTH_CONFIG.userModel].findUnique({
        where: {
          [NEXT_AUTH_CONFIG.fields.email]: email.trim(),
        },
      })

      if (existingUser) {
        return NextResponse.json(
          { error: 'このメールアドレスは既に使用されています' },
          { status: 400 }
        )
      }
    }

    // プロフィールを更新
    const updatedUser = await prisma[NEXT_AUTH_CONFIG.userModel].update({
      where: {
        [NEXT_AUTH_CONFIG.fields.id]: parseInt(session.user.id),
      },
      data: {
        [NEXT_AUTH_CONFIG.fields.name]: name.trim(),
        [NEXT_AUTH_CONFIG.fields.email]: email.trim(),
      },
    })

    return NextResponse.json({
      message: 'プロフィールが正常に更新されました',
      user: {
        id: updatedUser[NEXT_AUTH_CONFIG.fields.id],
        name: updatedUser[NEXT_AUTH_CONFIG.fields.name],
        email: updatedUser[NEXT_AUTH_CONFIG.fields.email],
      },
    })
  } catch {
    return NextResponse.json({ error: 'サーバーエラーが発生しました' }, { status: 500 })
  }
}
