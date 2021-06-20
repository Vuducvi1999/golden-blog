class Dashboard::BinhluanController < ApplicationController
  def create
    @post = Post.find_by(id: params[:_id])
    @comment = @post.binhluans.build(binhluan_params)

    respond_to do |format|
      if @comment.save
        format.js {render partial:'dashboard/binhluan/create'}
      end
    end
  end

  def binhluan_params
    params.require(:binhluan).permit(:body)
  end
end
