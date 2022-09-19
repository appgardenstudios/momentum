class Copy {
  static CommonCopy common = const CommonCopy();
  static HomePageCopy home = const HomePageCopy();
  static NewProjectPageCopy newProject = const NewProjectPageCopy();
  static ManageProjectPageCopy manageProject = const ManageProjectPageCopy();
  static CompleteProjectPageCopy completeProject =
      const CompleteProjectPageCopy();
  static NewTaskPageCopy newTask = const NewTaskPageCopy();
  static ManageTaskPageCopy manageTask = const ManageTaskPageCopy();
  static CompleteTaskPageCopy completeTask = const CompleteTaskPageCopy();
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

class NewProjectPageCopy {
  const NewProjectPageCopy();

  String get title => 'New Project';
  String get nameTitle => 'What is your project named?';
  String get namePrompt =>
      'It can be a working name, an actual name, or a silly made-up name.';
  String get nameHint => 'My Project';
  String get nameError => 'Must be between 1 and 32 characters';
  String get timeTitle => 'How much time can you devote to a single task?';
  String get timePrompt =>
      'This should be the amount of time you would like to spend working on your project every day in a single session.';
  String get timeHint => '30 minutes';
  String get timeError => 'Must not be blank';
  String get cancel => 'Cancel';
  String get save => 'Go';
}

class ManageProjectPageCopy {
  const ManageProjectPageCopy();

  String get title => 'Edit Project';
  String get nameTitle => 'Name';
  String get nameHint => 'My Project';
  String get nameError => 'Must be between 1 and 32 characters';
  String get timeTitle => 'Task Time';
  String get timeHint => '30 minutes';
  String get timeError => 'Must not be blank';
  String get cancel => 'Cancel';
  String get save => 'Save';
  String get complete => 'Project Complete?';
}

class CompleteProjectPageCopy {
  const CompleteProjectPageCopy();

  String get title => 'Complete Project';
  String get prompt =>
      'Would you like to mark this project as complete? Any remaining tasks will be closed.';
  String get yes => 'yes';
  String get no => 'No';
}

class NewTaskPageCopy {
  const NewTaskPageCopy();

  String get title => 'New Task';
  String get nameTitle => 'What is the next thing you need to do?';
  String namePrompt(String time) =>
      'Remember, you need to be able to complete this in $time!';
  String get nameHint => 'Task Name';
  String get nameError => 'Must be between 1 and 32 characters';
  String get descriptionTitle => 'Any other details or thoughts?';
  String get descriptionPrompt =>
      'Is there anything you need to remember that you need to get out of your head?';
  String get descriptionHint => 'Task Details';
  String get cancel => 'Cancel';
  String get save => 'Go';
}

class ManageTaskPageCopy {
  const ManageTaskPageCopy();

  String get editTitle => 'Edit Task';
  String get deleteTitle => 'Delete Task';
  String get nameTitle => 'Name';
  String get nameHint => 'Task Name';
  String get nameError => 'Must be between 1 and 32 characters';
  String get descriptionTitle => 'Description';
  String get descriptionHint => 'Task Details';
  String deletePrompt(String name) => 'Delete $name?';
  String get areYouSure => 'Are you sure?';
  String get yes => 'yes';
  String get no => 'No';
  String get delete => 'Delete';
  String get cancel => 'Cancel';
  String get save => 'Save';
}

class CompleteTaskPageCopy {
  const CompleteTaskPageCopy();

  String get title => 'Well Done!';
}
