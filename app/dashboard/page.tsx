import { DashboardView } from "@/src/presentation/components/dashboard/DashboardView";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "แดชบอร์ด | Dragon Quest XI",
  description: "แดशบอร์ดหลักสำหรับการผจญภัยใน Dragon Quest XI Interactive Story",
};

/**
 * Dashboard page - Server Component for SEO optimization
 * Main game interface for Dragon Quest XI Interactive Story
 */
export default function DashboardPage() {
  return <DashboardView />;
}
