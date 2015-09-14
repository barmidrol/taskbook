module TasksHelper

  def solved_task(task)
    if task.users.include? current_user && current_user != task.users[0]
      "solved"
    end
  end

  def link_to_author(task)
    link_to task.users[0].name, task.users[0]
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
end
