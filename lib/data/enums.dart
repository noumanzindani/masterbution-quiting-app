/// Central enum definitions — the single source of truth shared by Isar
/// collections and the on-device engines (analytics, streaks, coach).
///
/// Keep enum *order* stable: Isar persists `@enumerated` fields by index, so
/// reordering an existing enum silently corrupts stored data. Only ever
/// append new values at the end.
library;

/// What kind of event a [TrackerEvent] represents.
enum LogType { urge, lapse, cleanCheckin, orgasm, resistWin }

/// The outcome of an urge/event. `lapse` is the mechanism that makes the whole
/// app lapse-tolerant: a relapse is appended as data with `outcome == lapse`,
/// never a delete or a "reset to zero".
enum Outcome { resisted, surfed, delayed, lapse, neutral }

/// Which behavior a goal or event concerns.
enum BehaviorTarget { porn, masturbation, both, none }

/// Trigger taxonomy (stored on [TrackerEvent] as a value-indexed byte list so
/// per-trigger counts are cheap GROUP-BY queries).
enum TriggerType {
  time,
  location,
  emotion,
  device,
  website,
  stress,
  boredom,
  loneliness,
  anger,
  rejection,
  alcohol,
  socialMedia,
}

/// The recovery goal the user picks at onboarding.
enum GoalType { quitPorn, quitMasturbation, reduceFrequency, healthyHabits }

/// CBT exercise types bundled in the recovery program.
enum CbtExercise {
  automaticThought,
  distortion,
  thoughtReplacement,
  triggerAnalysis,
  emotionLabel,
  behavioralExperiment,
  exposure,
  urgeSurf,
  delayedGratification,
  acceptance,
}

/// Healthy-habit types tracked in the habit tracker.
enum HabitType {
  exercise,
  reading,
  meditation,
  prayer,
  sleep,
  water,
  eating,
  social,
  walk,
  gratitude,
}

/// Kinds of free-text journal entries.
enum JournalKind { dailyReflection, emergencyJournal, gratitude }

/// Guided-session modalities.
enum SessionType {
  cbt,
  act,
  mindfulness,
  compassion,
  positivePsych,
  acceptance,
}

/// Why a reward (coins) was granted.
enum RewardReason { streakMilestone, exerciseDone, rewardedAd, dailyCheckin }
