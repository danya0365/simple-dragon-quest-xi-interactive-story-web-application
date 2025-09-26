"use client";

import { useAuthStore } from "@/src/stores/authStore";
import { useEffect } from "react";

interface AuthProviderProps {
  children: React.ReactNode;
}

export function AuthProvider({ children }: AuthProviderProps) {
  const { initialize } = useAuthStore();

  useEffect(() => {
    // Initialize auth state when component mounts
    initialize();
  }, []);

  return <>{children}</>;
}
