"use client";

import { useAuthStore } from "@/src/stores/authStore";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

export function LoginView() {
  const router = useRouter();
  const { signIn, signUp, user, loading } = useAuthStore();

  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Redirect if already logged in
  useEffect(() => {
    if (user) {
      router.push("/");
    }
  }, [user, router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setIsSubmitting(true);

    try {
      let result;
      if (isLogin) {
        result = await signIn(email, password);
      } else {
        result = await signUp(email, password);
      }

      if (result.error) {
        setError(result.error);
      } else if (!isLogin) {
        setError("");
        alert("สมัครสมาชิกสำเร็จ! กรุณาตรวจสอบอีเมลเพื่อยืนยันบัญชี");
      }
    } catch (err) {
      setError("เกิดข้อผิดพลาดที่ไม่คาดคิด");
    } finally {
      setIsSubmitting(false);
    }
  };

  // Show loading while initializing
  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-white text-lg">กำลังโหลด...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center p-4">
      <div className="max-w-md w-full">
        {/* Dragon Quest Logo/Title */}
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-yellow-400 mb-2 font-serif">
            Dragon Quest XI
          </h1>
          <p className="text-blue-200 text-lg">Interactive Story</p>
          <div className="w-24 h-1 bg-yellow-400 mx-auto mt-4 rounded"></div>
        </div>

        {/* Login/Register Form */}
        <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8 shadow-2xl">
          <div className="text-center mb-6">
            <h2 className="text-2xl font-bold text-white mb-2">
              {isLogin ? "เข้าสู่ระบบ" : "สมัครสมาชิก"}
            </h2>
            <p className="text-blue-200">
              {isLogin
                ? "เข้าสู่ระบบเพื่อเริ่มการผจญภัย"
                : "สร้างบัญชีใหม่เพื่อเริ่มเล่น"}
            </p>
          </div>

          {error && (
            <div className="bg-red-500/20 border border-red-500/50 rounded-lg p-3 mb-4">
              <p className="text-red-200 text-sm text-center">{error}</p>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label
                htmlFor="email"
                className="block text-sm font-medium text-blue-200 mb-2"
              >
                อีเมล
              </label>
              <input
                type="email"
                id="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full px-4 py-3 bg-white/10 border border-white/30 rounded-lg text-white placeholder-blue-300 focus:outline-none focus:ring-2 focus:ring-yellow-400 focus:border-transparent"
                placeholder="กรอกอีเมลของคุณ"
                required
              />
            </div>

            <div>
              <label
                htmlFor="password"
                className="block text-sm font-medium text-blue-200 mb-2"
              >
                รหัสผ่าน
              </label>
              <input
                type="password"
                id="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full px-4 py-3 bg-white/10 border border-white/30 rounded-lg text-white placeholder-blue-300 focus:outline-none focus:ring-2 focus:ring-yellow-400 focus:border-transparent"
                placeholder="กรอกรหัสผ่าน"
                required
                minLength={6}
              />
            </div>

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full bg-gradient-to-r from-yellow-500 to-yellow-600 hover:from-yellow-600 hover:to-yellow-700 text-blue-900 font-bold py-3 px-4 rounded-lg transition-all duration-200 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
            >
              {isSubmitting ? (
                <div className="flex items-center justify-center">
                  <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-blue-900 mr-2"></div>
                  กำลังดำเนินการ...
                </div>
              ) : isLogin ? (
                "เข้าสู่ระบบ"
              ) : (
                "สมัครสมาชิก"
              )}
            </button>
          </form>

          {/* Toggle between login/register */}
          <div className="mt-6 text-center">
            <p className="text-blue-200">
              {isLogin ? "ยังไม่มีบัญชี?" : "มีบัญชีแล้ว?"}
              <button
                type="button"
                onClick={() => {
                  setIsLogin(!isLogin);
                  setError("");
                  setEmail("");
                  setPassword("");
                }}
                className="ml-2 text-yellow-400 hover:text-yellow-300 font-medium underline"
              >
                {isLogin ? "สมัครสมาชิก" : "เข้าสู่ระบบ"}
              </button>
            </p>
          </div>

          {/* Demo accounts info */}
          <div className="mt-6 p-4 bg-blue-900/30 rounded-lg border border-blue-500/30">
            <p className="text-blue-200 text-sm font-medium mb-2">
              บัญชีทดสอบ:
            </p>
            <div className="text-xs text-blue-300 space-y-1">
              <p>• admin@test.com (รหัส: 12345678)</p>
              <p>• user1@test.com (รหัส: 12345678)</p>
              <p>• user2@test.com (รหัส: 12345678)</p>
            </div>
          </div>
        </div>

        {/* Back to home link */}
        <div className="text-center mt-6">
          <Link
            href="/"
            className="text-blue-300 hover:text-blue-200 text-sm underline"
          >
            ← กลับหน้าแรก
          </Link>
        </div>
      </div>
    </div>
  );
}
