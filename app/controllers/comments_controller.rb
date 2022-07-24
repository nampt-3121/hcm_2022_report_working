class CommentsController < ApplicationController
  def create
    @comment = Comment.new comment_params
    @comment.user_id = current_user.id
    @comment.report_id = params[:report_id]
    if @comment.save
      flash[:success] = t ".create_comment_message"
    else
      flash.now[:danger] = t ".create_comment_error"
    end
    redirect_to report_path(params[:report_id])
  end

  def destroy
    if @comment.destroy
      flash[:success] = t ".deleted_message"
    else
      flash[:danger] = t ".delete_failed_message"
    end
    redirect_to report_path(params[:report_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:report_id, :description)
  end
end
