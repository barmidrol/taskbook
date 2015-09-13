module TasksHelper

  def solved_task(task)
    if task.users.include? current_user
      "solved"
    else
      ""
    end
  end

end
