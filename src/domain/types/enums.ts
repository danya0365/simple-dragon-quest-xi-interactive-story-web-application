// Domain enums for type safety

export enum EventType {
  STORY = "story",
  DIALOGUE = "dialogue", 
  CHOICE = "choice",
  BATTLE = "battle",
  QUEST = "quest",
  COMBAT = "combat" // alias for battle
}

export enum InteractionType {
  DIALOGUE = "dialogue",
  CHOICE = "choice",
  BATTLE = "battle",
  ITEM = "item",
  SKILL = "skill"
}

export enum ChoiceType {
  NORMAL = "normal",
  IMPORTANT = "important",
  SPECIAL = "special",
  HIDDEN = "hidden"
}
