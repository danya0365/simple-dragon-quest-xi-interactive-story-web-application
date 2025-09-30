// Domain enums for type safety

export enum EventType {
  DIALOGUE = "dialogue",
  EXPLORATION = "exploration",
  SHOPPING = "shopping",
  STORY = "story",
  ACTION = "action",
  CHOICE = "choice",
  TRIAL = "trial",
  BATTLE = "battle",
  BOSS_BATTLE = "boss_battle",
  QUEST = "quest",
  BLESSING = "blessing",
  PREPARATION = "preparation",
  CLIMAX = "climax",
  TIME_TRAVEL = "time_travel",
  REVELATION = "revelation",
  ULTIMATE_BATTLE = "ultimate_battle",
  CONSTRUCTION = "construction",
  WEDDING = "wedding",
  LIFE_EVENT = "life_event",
  REFLECTION = "reflection",
  LEGACY = "legacy",
  FINALE = "finale",
}

export enum InteractionType {
  DIALOGUE = "dialogue",
  CHOICE = "choice",
  BATTLE = "battle",
  ITEM = "item",
  SKILL = "skill",
}

export enum ChoiceType {
  NORMAL = "normal",
  IMPORTANT = "important",
  SPECIAL = "special",
  HIDDEN = "hidden",
}
