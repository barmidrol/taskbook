class TasksController < ApplicationController
  respond_to :html, :js
  before_action :authenticate_user!, only: [:create, :new]
  before_action :set_task, only: [:show, :edit, :update, :solve, :destroy]
  before_action :correct_user?, only: [:update, :edit]

  def index
    @tasks = Task.all
    if params[:tag]
      @tasks = Task.tagged_with(params[:tag])
    elsif params[:not_solved]
      all = Task.all
      @tasks = Array.new
      all.each do |task|
        if task.users.include?(current_user) == 0 && current_user.id != task.user_id
          @tasks.push task
        end
      end
    elsif params[:user_id]  
      @tasks = Task.where(user_id: params[:user_id])
    elsif params[:category]
      @tasks = Task.where(category: params[:category])
    elsif params[:difficulty]
      @tasks = Task.where(difficulty: params[:difficulty])
    end
    #pry.binding
  end

	def show
    @comment = Comment.new
	end

  def edit
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task was successfully deleted!"
  end

  def update
    @task.update(task_params)
    redirect_to @task
  end

  def create
    @user = current_user
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
    answer = params[:answer]
    correct_answers = get_answers_array(@task.answers)
    respond_to do |format|
      if correct_answers.include?(answer)
        current_user.solved += 1
        @task.users << current_user
        current_user.rating += rate(@task)
        flash.now[:notice] = "Correct!"
        format.js
        @task.save
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

    def set_task
      @task = Task.find(params[:id])
    end

    def rate(task)
      difficulties = { 'Hard' => 3, 'Medium' => 2, 'Easy' => 1 }
      difficulties[task.difficulty]
    end

    def correct_user?
      redirect_to tasks_path, warning: "You don't have permissions to do this" unless current_user == @user
    end

end
