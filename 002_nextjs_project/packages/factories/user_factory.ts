// factories/user_factory.ts

import type { User } from "@prisma/client";
import { faker } from "@faker-js/faker";
import crypto from "crypto";

/**
 * Prisma の User モデルから `id` を除いた型
 */
export type NewUser = Omit<User, "id">;

/**
 * SHA-256 ハッシュ関数
 */
function hashPassword(password: string): string {
  return crypto.createHash("sha256").update(password).digest("hex");
}

/**
 * User 用ファクトリー
 * @param overrides - 任意のフィールド上書き
 */
export const userFactory = (overrides: Partial<NewUser> = {}): NewUser => {
  const now = new Date();
  const rawPassword =
    overrides.password ?? faker.internet.password({ length: 20 });
  const hashedPassword = hashPassword(rawPassword);

  return {
    email: overrides.email ?? faker.internet.email(),
    password: hashedPassword,
    name:
      overrides.name ??
      faker.person.firstName() + " " + faker.person.lastName(),
    createdAt: overrides.createdAt ?? now,
    updatedAt: overrides.updatedAt ?? now,
  };
};
