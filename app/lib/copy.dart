class Copy {
  static CommonCopy common = const CommonCopy();
  static HomePageCopy home = const HomePageCopy();
}

class CommonCopy {
  const CommonCopy();

  String get appTitle => 'Momentum';
}

class HomePageCopy {
  const HomePageCopy();

  String get welcome => 'Welcome!';
  String get initialPrompt =>
      'Momentum helps you break a project down into bite-sized pieces so you can work on it every single day.';
  String get createProject => 'Create Project';
  String get manageProject => 'Manage Project';
  String get newProject => 'New Project';
  String get previousProject => 'Previous Project';
  String get nextProject => 'Next Project';
  String get createAnotherProjectPrompt => 'You can create up to 3 projects';
  String get createAnotherProject => 'Create Another';
  String get maxProjectsPrompt => 'Complete a project before adding another.';
  String get editTask => 'Edit';
  String get completeTask => 'Done';
  String get newTaskTitle => 'The Next Thing';
  String get newTaskDescription =>
      'Set the next thing you need to do by creating a task.';
  String get newTask => 'Create Task';
  String get maxTasksPrompt => 'Complete a task before adding another.';
}
