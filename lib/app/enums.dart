enum ExperienceLevel { fresh, junior, midLevel, senior }

enum TaskState {
  all,
  inprogress,
  waiting,
  finished;

  static TaskState? from(String name) {
    for (TaskState value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}

enum TaskPriority {
  low,
  medium,
  high;

  static TaskPriority? from(String name) {
    for (TaskPriority value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
