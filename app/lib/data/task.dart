class Task {
  final String id;
  final String projectId;
  final String name;
  final String description;
  final String status;
  final String createdOn;

  const Task({
    required this.id,
    required this.projectId,
    required this.name,
    required this.status,
    required this.description,
    required this.createdOn,
  });
}
