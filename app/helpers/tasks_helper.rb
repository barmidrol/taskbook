module TasksHelper

  def task_rating(task)
    task.average("users_rating").nil? ? '-' : task.average("users_rating").avg 
  end

  def solved_task_class(task)
    if task.users.include?(current_user) && current_user.id != task.user_id
      "solved"
    end
  end

  def author_task_class(task)
    if current_user.id == task.user_id
      'task-author'
    end
  end

  def solved_task?(task) 
    task.users.drop(0).include? current_user
  end

  def is_author?(task)
    current_user.id == task.user_id
  end

  def link_to_author(task)
    user = User.find(task.user_id)
    link_to user.name, user
  end

  def content_md(task)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(task.content)
  end 

  def difficulty_label(task)
    case task.difficulty
    when 'Easy'
      'label label-success'
    when 'Medium'
      'label label-warning'
    when 'Hard'
      'label label-danger'
    end
  end 

  def solved_count(task)
    task.users.count
  end
end
