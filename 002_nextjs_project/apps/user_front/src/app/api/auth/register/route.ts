import { NextRequest, NextResponse } from 'next/server'
import { createHash } from 'crypto'
import { prisma } from '@my-monorepo/db/client'
import { NEXT_AUTH_CONFIG } from '@/lib/shared/config'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { email, password, name } = body

    // バリデーション
    if (!email || !password || !name) {
      return NextResponse.json(
        { error: 'メールアドレス、パスワード、名前は必須です' },
        { status: 400 }
      )
    }

    // メールアドレスの形式チェック
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(email)) {
      return NextResponse.json(
        { error: '有効なメールアドレスを入力してください' },
        { status: 400 }
      )
    }

    // パスワードの長さチェック
    if (password.length < 6) {
      return NextResponse.json(
        { error: 'パスワードは6文字以上で入力してください' },
        { status: 400 }
      )
    }

    // 名前の長さチェック
    if (name.length < 1 || name.length > 128) {
      return NextResponse.json(
        { error: '名前は1文字以上128文字以下で入力してください' },
        { status: 400 }
      )
    }

    // 既存ユーザーのチェック
    const existingUser = await prisma[NEXT_AUTH_CONFIG.userModel].findUnique({
      where: {
        [NEXT_AUTH_CONFIG.fields.email]: email,
      },
    })

    if (existingUser) {
      return NextResponse.json(
        { error: 'このメールアドレスは既に登録されています' },
        { status: 409 }
      )
    }

    // パスワードをハッシュ化
    const hashedPassword = createHash(NEXT_AUTH_CONFIG.passwordHash)
      .update(password)
      .digest('hex')

    // ユーザーを作成
    const newUser = await prisma[NEXT_AUTH_CONFIG.userModel].create({
      data: {
        [NEXT_AUTH_CONFIG.fields.email]: email,
        [NEXT_AUTH_CONFIG.fields.password]: hashedPassword,
        [NEXT_AUTH_CONFIG.fields.name]: name,
      },
    })

    // パスワードを除いてレスポンス
    const { password: _, ...userWithoutPassword } = newUser

    return NextResponse.json(
      {
        message: 'ユーザー登録が完了しました',
        user: userWithoutPassword,
      },
      { status: 201 }
    )
  } catch (error) {
    console.error('Registration error:', error)
    return NextResponse.json(
      { error: 'ユーザー登録中にエラーが発生しました' },
      { status: 500 }
    )
  }
}
