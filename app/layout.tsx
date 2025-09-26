import type { Metadata } from "next";
import "../public/styles/index.css";
import { AuthProvider } from "@/src/presentation/components/providers/AuthProvider";

export const metadata: Metadata = {
  title: "Dragon Quest Story",
  description: "Interactive Dragon Quest Story Experience",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="th">
      <body className="antialiased">
        <AuthProvider>
          {children}
        </AuthProvider>
      </body>
    </html>
  );
}
