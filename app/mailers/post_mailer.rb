class PostMailer < ApplicationMailer
  def create_post user, post 
    @user = user 
    @post = post 
    mail(
      to: @user.email,
      subject:  "You have created post - GoldenBlog",
      content_type: "text/html"
    )
  end

  def update_post user, post
    @user = user 
    @post = post
    mail(
      to: @user.email,
      subject: "You have updated post - GoldenBlog",
      content_type: 'text/html'
    )
  end

  def delete_post user, post
    @user = user 
    @post = post
    mail(
      to: @user.email,
      subject: "You have deteled post - GoldenBlog",
      content_type: 'text/html'
    )
  end

  def approved_post user, post
    @user = user 
    @post = post
    mail(
      to: @user.email,
      subject: "Approved post - GoldenBlog",
      content_type: 'text/html'
    )
  end
  
  def rejected_post user, post
    @user = user 
    @post = post
    mail(
      to: @user.email,
      subject: "Rejected post - GoldenBlog",
      content_type: 'text/html'
    )
  end
end
