class TasksController < ApplicationController
  respond_to :html, :js
  before_action :authenticate_user!, only: [:create, :new]

def index
  if params[:tag]
    @tasks = Task.tagged_with(params[:tag])
  elsif params[:not_solved]
    all = Task.all
    @tasks = Array.new
    all.each do |task|
      if task.users.count == 1 && current_user != task.users[0]
        @tasks.push task
      end
    end
  elsif params[:user_id]
    @tasks = Task.where(:user_id => params[:user_id])
  else
    @tasks = Task.all
  end
end

	def show
		@task = Task.find_by(id: params[:id])
    @comment = Comment.new
	end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    @task.answers.delete!(' ')
    if @task.save 
      flash[:notice] = "Task was successfully added!"
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def new
    @task = Task.new
  end

  def solve
    task = Task.find_by(id: params[:id])
    answer = params[:answer]
    correct_answers = get_answers_array(task.answers)
    respond_to do |format|
      if correct_answers.include?(answer)
        task.users << current_user
        current_user.rating += rate(task)
        flash.now[:notice] = "Correct!"
        format.js
        task.save
        current_user.save
      else
        flash.now[:warning] = "incorrect answer! Please try again"
        format.js
      end
    end
  end

  private 

    def task_params
      params.require(:task).permit(:title, :content, :difficulty, :category,
                                   :answers, :tag_list => [])
    end

    def get_answers_array(string)
      string.split(',').to_a
    end

    def rate(task)
      difficulties = { 'Hard' => 3, 'Medium' => 2, 'Easy' => 1 }
      difficulties[task.difficulty]
    end
end
