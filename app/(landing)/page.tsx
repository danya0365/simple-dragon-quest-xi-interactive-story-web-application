import { HomeView } from "@/src/presentation/components/home/HomeView";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Dragon Quest XI Interactive Story",
  description: "เริ่มการผจญภัยสุดยิ่งใหญ่ใน Dragon Quest XI Interactive Story - เกมเล่าเรื่องแบบโต้ตอบที่จะพาคุณสู่โลกแห่งเวทมนตร์และการผจญภัย",
};

export default function Home() {
  return <HomeView />;
}
