class TasksController < ApplicationController
  respond_to :html, :js
  before_action :authenticate_user!, only: [:create, :new]

	def index
		@tasks = Task.all
	end

	def show
		@task = Task.find_by(id: params[:id])
	end

  def create
    @task = Task.new(task_params)
    @task.users << current_user
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
        
        flash.now[:notice] = "Correct!"
        format.js
        task.save
      else
        flash.now[:warning] = "incorrect answer! Please try again"
        format.js
      end
    end
  end

  private 

    def task_params
      params.require(:task).permit(:title, :content, :difficulty, :category,
                                   :answers)
    end

    def get_answers_array(string)
      string.split(',').to_a
    end

end
