module TasksHelper

  def author_count(user) 
    Task.where(user_id: user.id).count
  end

  def task_rating(task)
    task.average("users_rating").nil? ? '-' : task.average("users_rating").avg.round(1)
  end

  def top_tasks(user) 
    tasks = Task.where(user_id: user.id).to_a
    tasks.each do |task|
      if task.average("users_rating").nil?
        tasks.delete(task)
      end
    end
    tasks.sort { |a, b| b.average("users_rating").avg <=> a.average("users_rating").avg }[0..10]
  end

  def solved_task_class(task)
    if task.users.include?(current_user) && current_user.id != task.user_id
      "solved"
    end
  end

  def author_task_class(task)
    if signed_in? && current_user.id == task.user_id
      'task-author'
    end
  end

  def solved_task?(task) 
    task.users.drop(0).include? current_user
  end

  def is_author?(task)
    if signed_in?
      current_user.id == task.user_id
    end
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
