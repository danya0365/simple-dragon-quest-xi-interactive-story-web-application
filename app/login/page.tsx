import { LoginView } from "@/src/presentation/components/auth/LoginView";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "เข้าสู่ระบบ | Dragon Quest XI",
  description: "เข้าสู่ระบบเพื่อเริ่มการผจญภัยใน Dragon Quest XI Interactive Story",
};

/**
 * Login page - Server Component for SEO optimization
 */
export default function LoginPage() {
  return <LoginView />;
}
