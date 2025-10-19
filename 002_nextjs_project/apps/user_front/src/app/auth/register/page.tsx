import React from 'react'
import RegisterForm from '@/components/RegisterForm'

export default function RegisterPage() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="max-w-md w-full p-8">
        <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
          新規登録
        </h2>
        <RegisterForm />
      </div>
    </div>
  )
}
