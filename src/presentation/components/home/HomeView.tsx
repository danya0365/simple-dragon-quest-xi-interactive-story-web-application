"use client";

import { useAuthStore } from "@/src/stores/authStore";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect } from "react";

export function HomeView() {
  const router = useRouter();
  const { user, initialize, initialized } = useAuthStore();

  // Initialize auth store
  useEffect(() => {
    if (!initialized) {
      initialize();
    }
  }, [initialize, initialized]);

  // Redirect authenticated users to dashboard
  useEffect(() => {
    if (user && initialized) {
      router.push("/dashboard");
    }
  }, [user, initialized, router]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900">
      {/* Hero Section */}
      <div className="relative overflow-hidden">
        {/* Background Pattern */}
        <div className="absolute inset-0 bg-[url('/patterns/dragon-quest-pattern.svg')] opacity-10"></div>

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
          <div className="text-center">
            {/* Main Logo/Title */}
            <div className="mb-8">
              <h1 className="text-6xl md:text-8xl font-bold text-yellow-400 mb-4 font-serif">
                Dragon Quest XI
              </h1>
              <p className="text-2xl md:text-3xl text-blue-200 font-medium">
                Interactive Story
              </p>
              <div className="w-32 h-2 bg-gradient-to-r from-yellow-400 to-yellow-500 mx-auto mt-6 rounded-full"></div>
            </div>

            {/* Subtitle */}
            <p className="text-xl md:text-2xl text-blue-100 mb-12 max-w-3xl mx-auto leading-relaxed">
              เริ่มการผจญภัยสุดยิ่งใหญ่ในโลกแห่งเวทมนตร์และการผจญภัย
              <br />
              <span className="text-blue-300">
                ที่คุณเป็นผู้กำหนดเส้นทางของเรื่องราว
              </span>
            </p>

            {/* CTA Buttons */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-16">
              <Link
                href="/login"
                className="bg-gradient-to-r from-yellow-500 to-yellow-600 hover:from-yellow-600 hover:to-yellow-700 text-blue-900 font-bold py-4 px-8 rounded-lg text-lg transition-all duration-200 transform hover:scale-105 shadow-lg"
              >
                🎮 เริ่มการผจญภัย
              </Link>

              <Link
                href="#features"
                className="bg-white/10 backdrop-blur-md border border-white/20 text-white font-medium py-4 px-8 rounded-lg text-lg hover:bg-white/20 transition-all duration-200"
              >
                📖 เรียนรู้เพิ่มเติม
              </Link>
            </div>

            {/* Hero Image Placeholder */}
            <div className="relative max-w-4xl mx-auto">
              <div className="bg-gradient-to-br from-blue-600/30 to-purple-600/30 rounded-2xl border border-white/20 p-8 backdrop-blur-md">
                <div className="aspect-video bg-gradient-to-br from-yellow-400/20 to-yellow-500/20 rounded-lg flex items-center justify-center">
                  <div className="text-center">
                    <div className="text-8xl mb-4">🏰</div>
                    <p className="text-blue-200 text-lg">
                      Dragon Quest XI Interactive Story
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Features Section */}
      <section id="features" className="py-24 bg-black/20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-yellow-400 mb-4 font-serif">
              คุณสมบัติเด่น
            </h2>
            <p className="text-xl text-blue-200 max-w-2xl mx-auto">
              สัมผัสประสบการณ์การเล่นเกมแบบใหม่ที่ผสมผสานระหว่างการอ่านและการโต้ตอบ
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {/* Feature 1 */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8 text-center hover:bg-white/20 transition-all duration-300">
              <div className="text-5xl mb-4">🗺️</div>
              <h3 className="text-xl font-bold text-white mb-3">
                แผนที่โลกแบบโต้ตอบ
              </h3>
              <p className="text-blue-200">
                สำรวจโลกของ Dragon Quest XI ผ่านแผนที่โต้ตอบที่สวยงาม
                พร้อมปลดล็อคพื้นที่ใหม่ตามความคืบหน้า
              </p>
            </div>

            {/* Feature 2 */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8 text-center hover:bg-white/20 transition-all duration-300">
              <div className="text-5xl mb-4">💬</div>
              <h3 className="text-xl font-bold text-white mb-3">
                เรื่องราวแบranch
              </h3>
              <p className="text-blue-200">
                ตัวเลือกของคุณจะส่งผลต่อเส้นทางเรื่องราว ตัวละครที่เข้าร่วม
                และผลลัพธ์ของการผจญภัย
              </p>
            </div>

            {/* Feature 3 */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8 text-center hover:bg-white/20 transition-all duration-300">
              <div className="text-5xl mb-4">👥</div>
              <h3 className="text-xl font-bold text-white mb-3">ระบบปาร์ตี้</h3>
              <p className="text-blue-200">
                รวบรวมเพื่อนร่วมทางในการผจญภัย
                แต่ละตัวละครมีเรื่องราวและความสามารถเฉพาะตัว
              </p>
            </div>

            {/* Feature 4 */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8 text-center hover:bg-white/20 transition-all duration-300">
              <div className="text-5xl mb-4">🎒</div>
              <h3 className="text-xl font-bold text-white mb-3">ระบบไอเทม</h3>
              <p className="text-blue-200">
                สะสมไอเทม อาวุธ และเครื่องใช้วิเศษจากการผจญภัย
                เพื่อเสริมพลังให้กับปาร์ตี้
              </p>
            </div>

            {/* Feature 5 */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8 text-center hover:bg-white/20 transition-all duration-300">
              <div className="text-5xl mb-4">💾</div>
              <h3 className="text-xl font-bold text-white mb-3">
                บันทึกอัตโนมัติ
              </h3>
              <p className="text-blue-200">
                ความคืบหน้าของคุณจะถูกบันทึกอัตโนมัติ
                สามารถกลับมาเล่นต่อได้ทุกเมื่อ
              </p>
            </div>

            {/* Feature 6 */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8 text-center hover:bg-white/20 transition-all duration-300">
              <div className="text-5xl mb-4">🎨</div>
              <h3 className="text-xl font-bold text-white mb-3">UI สวยงาม</h3>
              <p className="text-blue-200">
                ออกแบบด้วยธีม Dragon Quest ที่สวยงาม
                พร้อมแอนิเมชันและเอฟเฟกต์ที่ลื่นไหล
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Story Preview Section */}
      <section className="py-24">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-yellow-400 mb-4 font-serif">
              เรื่องราวที่รอคุณอยู่
            </h2>
            <p className="text-xl text-blue-200 max-w-2xl mx-auto">
              เริ่มต้นจาก Prison Arc - การหลบหนีจากคุก Heliodor พร้อมกับ Erik
            </p>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div className="space-y-6">
              <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6">
                <h3 className="text-2xl font-bold text-yellow-400 mb-4">
                  บท 1: The Darkspawn
                </h3>
                <p className="text-blue-200 leading-relaxed">
                  เริ่มต้นการผจญภัยของ Hero ผู้ถูกเรียกว่า Darkspawn จากหมู่บ้าน
                  Cobblestone สู่ปราสาท Heliodor
                </p>
              </div>

              <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6">
                <h3 className="text-2xl font-bold text-yellow-400 mb-4">
                  บท 2: The Dungeons of Heliodor
                </h3>
                <p className="text-blue-200 leading-relaxed">
                  Hero ถูกจับและขังในคุก Heliodor ที่นี่เขาได้พบกับ Erik
                  โจรหนุ่มผู้จะกลายเป็นเพื่อนร่วมทาง
                </p>
              </div>

              <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6">
                <h3 className="text-2xl font-bold text-yellow-400 mb-4">
                  บท 3: The Great Escape
                </h3>
                <p className="text-blue-200 leading-relaxed">
                  วางแผนและดำเนินการหลบหนีจากคุก Heliodor
                  การเลือกของคุณจะกำหนดวิธีการหลบหนีและผลลัพธ์ที่ตามมา
                </p>
              </div>
            </div>

            <div className="bg-gradient-to-br from-blue-600/30 to-purple-600/30 rounded-2xl border border-white/20 p-8 backdrop-blur-md">
              <div className="aspect-square bg-gradient-to-br from-yellow-400/20 to-yellow-500/20 rounded-lg flex items-center justify-center">
                <div className="text-center">
                  <div className="text-6xl mb-4">⚔️</div>
                  <p className="text-blue-200 text-lg font-medium">
                    Prison Arc
                  </p>
                  <p className="text-blue-300 text-sm mt-2">
                    3 บท • 6 เหตุการณ์หลัก
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-24 bg-gradient-to-r from-yellow-500/10 to-yellow-600/10">
        <div className="max-w-4xl mx-auto text-center px-4 sm:px-6 lg:px-8">
          <h2 className="text-4xl font-bold text-yellow-400 mb-6 font-serif">
            พร้อมเริ่มการผจญภัยแล้วหรือยัง?
          </h2>
          <p className="text-xl text-blue-200 mb-8">
            สร้างบัญชีและเริ่มต้นเรื่องราวของคุณใน Dragon Quest XI Interactive
            Story
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <Link
              href="/login"
              className="bg-gradient-to-r from-yellow-500 to-yellow-600 hover:from-yellow-600 hover:to-yellow-700 text-blue-900 font-bold py-4 px-8 rounded-lg text-lg transition-all duration-200 transform hover:scale-105 shadow-lg"
            >
              🎮 เริ่มเล่นเลย
            </Link>
          </div>

          {/* Demo Account Info */}
          <div className="mt-8 bg-blue-900/30 rounded-lg border border-blue-500/30 p-6">
            <p className="text-blue-200 font-medium mb-3">
              ทดลองเล่นด้วยบัญชีตัวอย่าง:
            </p>
            <div className="text-sm text-blue-300 space-y-1">
              <p>• admin@test.com (รหัส: 12345678)</p>
              <p>• user1@test.com (รหัส: 12345678)</p>
              <p>• user2@test.com (รหัส: 12345678)</p>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-black/40 border-t border-white/10 py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h3 className="text-2xl font-bold text-yellow-400 mb-4 font-serif">
              Dragon Quest XI Interactive Story
            </h3>
            <p className="text-blue-300 mb-6">
              สร้างด้วย Next.js, Supabase และความรักในเกม Dragon Quest
            </p>
            <div className="flex justify-center space-x-6 text-blue-400">
              <span>🎮 Interactive Story</span>
              <span>⚔️ RPG Adventure</span>
              <span>📖 Branching Narrative</span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
