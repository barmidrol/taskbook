class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @task = Task.find(params[:id])
    @user_who_commented = current_user
    @comment = Comment.build_from(@task, @user_who_commented.id, params[:body].first.to_s)
    @comment.save
    respond_to do |format|
      format.js
      format.html { redirect_to tasks_path }
    end

  end

end