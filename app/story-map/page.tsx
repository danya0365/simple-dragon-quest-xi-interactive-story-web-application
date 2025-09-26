import { StoryMapView } from "@/src/presentation/components/story-map/StoryMapView";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Story Map | Dragon Quest XI",
  description: "Story Map for Dragon Quest XI Interactive Story",
};

/**
 * Story Map page - Server Component for SEO optimization
 * Main game interface for Dragon Quest XI Interactive Story
 */
export default function StoryMapPage() {
  return <StoryMapView />;
}
