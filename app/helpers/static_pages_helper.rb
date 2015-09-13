module StaticPagesHelper
  
  def masthead_text
    case controller_name
    when 'tasks'
      case action_name
      when 'new'
        'Create task'
      when 'index'
        'Tasks'
      when 'show'
        task = Task.find_by(id: params[:id])
        task.title
      else
        'Nothing to do here'
      end
    when 'users'
      'Users'
    end
  end
end
