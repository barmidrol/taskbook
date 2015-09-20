module StaticPagesHelper
  
  def masthead_text
    case controller_name
    when 'tasks'
      case action_name
      when 'new'
        'Create task'
      when 'index'
        if params[:not_solved]
          'Not solved tasks'
        elsif params[:user_id]
          user = User.find(params[:user_id])
          "#{user.name}'s tasks"
        elsif params[:tag]
          "Tagged with '#{params[:tag]}'"
        else 'Tasks'
        end
      when 'show'
        task = Task.find_by(id: params[:id])
        task.title
      when 'show'
        'Edit task'
      else
        'Nothing to do here'
      end
    when 'users'
      "#{@user.name}'s profile"
    when 'search'
      a = params[:q]
      "Search '#{a}'"
    end
    end
end
