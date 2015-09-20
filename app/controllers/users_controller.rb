class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, only: [:update, :edit]

  def show
  	@user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user].permit(:name))
        #pry.binding
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content } # 204 No Content
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def correct_user?
      redirect_to tasks_path, notice: "Error!" unless current_user != @user
    end
end
