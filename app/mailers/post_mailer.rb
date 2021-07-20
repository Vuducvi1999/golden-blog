class PostMailer < ApplicationMailer
  def create_post user, post 
    @user = user 
    @post = post 
    mail(
      to: @user.email,
      subject:  "Created Post: #{@post.title}",
      content_type: "text/html"
    )
  end
end
