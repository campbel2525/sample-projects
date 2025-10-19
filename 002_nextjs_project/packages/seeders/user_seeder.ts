// prisma/seeders/user.seeder.ts など（ファイル名はあなたの環境に合わせてください）

import { prisma } from "@my-monorepo/db/client";
import { userFactory } from "@my-monorepo/factories/user_factory";

const DEFAULT_USER1_EMAIL = "user1@example.com";
const DEFAULT_USER2_EMAIL = "user2@example.com";
const DEFAULT_PASSWORD = "test1234"; // このパスワードがハッシュ化されます

/**
 * 2人の特定の初期ユーザーを作成するシーダー
 */
export async function seedUsers(): Promise<void> {
  // 1人目のユーザーデータをファクトリで生成
  // emailとpasswordを指定して、残りはファクトリに任せる
  const user1 = userFactory({
    email: DEFAULT_USER1_EMAIL,
    password: DEFAULT_PASSWORD,
  });

  // 2人目のユーザーデータをファクトリで生成
  const user2 = userFactory({
    email: DEFAULT_USER2_EMAIL,
    password: DEFAULT_PASSWORD,
  });

  // 作成するユーザーのリストを定義
  const usersToCreate = [user1, user2];

  // eslint-disable-next-line no-console
  console.log("Seeding 2 initial users...");

  // ループ処理でデータベースにユーザーを作成
  for (const userData of usersToCreate) {
    // 既に同じメールアドレスのユーザーが存在しないか確認（任意ですが推奨）
    const existingUser = await prisma.user.findUnique({
      where: { email: userData.email },
    });

    if (!existingUser) {
      await prisma.user.create({
        data: userData,
      });
      // eslint-disable-next-line no-console
      console.log(`  Created user: ${userData.email}`);
    } else {
      // eslint-disable-next-line no-console
      console.log(`  Skipped (already exists): ${userData.email}`);
    }
  }

  // eslint-disable-next-line no-console
  console.log("User seeding finished.");
}
