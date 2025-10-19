import { NextRequest, NextResponse } from 'next/server'
import { getServerSession } from 'next-auth'
import { createHash } from 'crypto'
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
    const {
      currentPassword,
      newPassword,
    }: { currentPassword?: string; newPassword?: string } = await request.json()

    if (!currentPassword || !newPassword) {
      return NextResponse.json(
        { error: '現在のパスワードと新しいパスワードは必須です' },
        { status: 400 }
      )
    }

    if (!newPassword || newPassword.length < 8) {
      return NextResponse.json(
        { error: '新しいパスワードは8文字以上で入力してください' },
        { status: 400 }
      )
    }

    // 現在のユーザー情報を取得
    const user = await prisma[NEXT_AUTH_CONFIG.userModel].findUnique({
      where: {
        [NEXT_AUTH_CONFIG.fields.id]: parseInt(session.user.id),
      },
    })

    if (!user) {
      return NextResponse.json({ error: 'ユーザーが見つかりません' }, { status: 404 })
    }

    // 現在のパスワードを確認
    const hashedCurrentPassword = createHash(NEXT_AUTH_CONFIG.passwordHash)
      .update(currentPassword)
      .digest('hex')

    if (user[NEXT_AUTH_CONFIG.fields.password] !== hashedCurrentPassword) {
      return NextResponse.json(
        { error: '現在のパスワードが正しくありません' },
        { status: 400 }
      )
    }

    // 新しいパスワードをハッシュ化
    const hashedNewPassword = createHash(NEXT_AUTH_CONFIG.passwordHash)
      .update(newPassword)
      .digest('hex')

    // パスワードを更新
    await prisma[NEXT_AUTH_CONFIG.userModel].update({
      where: {
        [NEXT_AUTH_CONFIG.fields.id]: parseInt(session.user.id),
      },
      data: {
        [NEXT_AUTH_CONFIG.fields.password]: hashedNewPassword,
      },
    })

    return NextResponse.json({
      message: 'パスワードが正常に変更されました',
    })
  } catch {
    return NextResponse.json({ error: 'サーバーエラーが発生しました' }, { status: 500 })
  }
}
