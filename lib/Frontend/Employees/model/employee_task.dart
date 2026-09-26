

class EmployeeTask {
  final String id;
  final String title;
  final String description;
  final String dueTime;
  final TaskPriority priority;
  bool isCompleted;

  EmployeeTask({
    required this.id,
    required this.title,
    required this.description,
    required this.dueTime,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
  });
}

enum TaskPriority { low, medium, high }