class TasksController < ApplicationController
	def index
		@tasks = Task.limit(10)
	end

	def show
		@task = Task.find_by(id: params[:id])
	end

  def create
    
  end
end
