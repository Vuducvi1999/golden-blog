# Preview all emails at http://localhost:3000/rails/mailers/post_mailer
class PostMailerPreview < ActionMailer::Preview
  def create_post
    PostMailer.create_post(User.first, Post.last)
  end
end
