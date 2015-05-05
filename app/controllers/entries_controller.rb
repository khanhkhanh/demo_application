class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @entries = current_user.entries.build(entry_params)
    if @entries.save
      flash[:success] = "Entry created!"
      redirect_to request.referrer || root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def index
    @entries = Entry.paginate(page: params[:page])
  end

  def show
    @entry = Entry.find(params[:id])
    @comments = @entry.comments.paginate(page: params[:page])
    @comments = @comments.reverse
    if !current_user.nil?
      @comment = current_user.comments.new(entry_id: @entry.id)
    end
  end

  def destroy
    @entries.destroy
    flash[:success] = "Entry deleted"
    redirect_to request.referrer || root_url
  end

  private

    def entry_params
      params.require(:entry).permit(:title, :body, :picture)
    end

    def correct_user
      @entries = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entries.nil?
    end
end
