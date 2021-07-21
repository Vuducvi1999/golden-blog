# Preview all emails at http://localhost:3000/rails/mailers/post_mailer
class PostMailerPreview < ActionMailer::Preview
  def create_post
    PostMailer.create_post(User.first, Post.last)
  end

  def update_post
    PostMailer.update_post(User.first, Post.last)
  end

  def delete_post
    PostMailer.delete_post(User.first, Post.last)
  end

  def approved_post
    PostMailer.approved_post(User.first, Post.last)
  end
  
  def rejected_post
    PostMailer.rejected_post(User.first, Post.last)
  end
end
