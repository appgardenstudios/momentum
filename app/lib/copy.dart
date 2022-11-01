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
      'Momentum helps you work on "The Next Thing" every single day so you can get your project done.';
  String get createProject => 'Get Started';
  String get manageProject => 'Manage Project';
  String get newProject => 'New Project';
  String get previousProject => 'Previous Project';
  String get nextProject => 'Next Project';
  String get createAnotherProjectPrompt =>
      'You can have up to 3 projects in Momentum.';
  String get createAnotherProject => 'New Project';
  String get maxProjectsPrompt =>
      'To help you stay focused, Momentum allows up to 3 projects at any given time. Please complete a project before adding another.';
  String get editTask => 'Edit';
  String get completeTask => 'Complete';
  String get newTaskTitle => 'The Next Thing';
  String get newTaskDescription =>
      'What is the next thing you need to do for this project?';
  String get newTask => 'Create Task';
  String get maxTasksPrompt =>
      'To help you stay focused, Momentum allows up to 3 next things at any given time. Please complete a task before adding another.';
}

class NewProjectPageCopy {
  const NewProjectPageCopy();

  String get title => 'New Project';
  String get nameTitle => 'What is your project called?';
  String get namePrompt =>
      'Something short and memorable works well as a project name.';
  String get nameHint => 'My Project';
  String get nameError => 'Must be between 1 and 32 characters';
  String get timeTitle => 'How long can you work on it every single day?';
  String get timePrompt =>
      'This should be the amount of time you can spend in a single working session.';
  String get timeHint => '30 minutes';
  String get timeError => 'Must not be blank';
  String get cancel => 'Cancel';
  String get save => 'Go';
}

class ManageProjectPageCopy {
  const ManageProjectPageCopy();

  String get title => 'Edit Project';
  String get nameTitle => 'Project Name';
  String get nameHint => '';
  String get nameError => 'Must be between 1 and 32 characters';
  String get timeTitle => 'Task Time';
  String get timeHint => '';
  String get timeError => 'Must not be blank';
  String get cancel => 'Cancel';
  String get save => 'Save';
  String get complete => 'Project Complete?';
}

class CompleteProjectPageCopy {
  const CompleteProjectPageCopy();

  String get title => 'Congratulations!';
  String get prompt =>
      'Would you like to mark this project as completed? If so, please note that any uncompleted tasks will be marked as closed.';
  String get yes => 'yes';
  String get no => 'No';
}

class NewTaskPageCopy {
  const NewTaskPageCopy();

  String get title => 'New Task';
  String get nameTitle =>
      'What is the next thing you need to do for this project?';
  String namePrompt(String time) =>
      'You should to be able to complete this in $time.';
  String get nameHint => 'The Next Thing';
  String get nameError => 'Must be between 1 and 64 characters';
  String get descriptionTitle =>
      'Are there any details or notes you need to write down?';
  String get descriptionPrompt =>
      'Getting it out of your head will help you remember it.';
  String get descriptionHint => 'Details or Notes';
  String get cancel => 'Cancel';
  String get save => 'Go';
}

class ManageTaskPageCopy {
  const ManageTaskPageCopy();

  String get editTitle => 'Edit Task';
  String get deleteTitle => 'Delete Task';
  String get nameTitle => 'The Next Thing';
  String get nameHint => '';
  String get nameError => 'Must be between 1 and 64 characters';
  String get descriptionTitle => 'Details or Notes';
  String get descriptionHint => '';
  String deletePrompt(String name) => 'Delete $name';
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
