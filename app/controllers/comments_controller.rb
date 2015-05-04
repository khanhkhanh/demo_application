class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
  end

  def create
    @comments = current_user.comments.build(comment_params)
    if @comments.save
      # flash[:success] = "Comments created!"
      redirect_to request.referrer
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @comments.destroy
    # flash[:success] = "Comments deleted"
    redirect_to request.referrer || root_url
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :entry_id)
    end

    def correct_user
      @comments = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comments.nil?
    end
end
