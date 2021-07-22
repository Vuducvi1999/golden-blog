class Dashboard::DashboardController < Dashboard::BaseController
  require 'will_paginate/array'

  def index
  end

  def manage_posts
    authorize :manage, :check_admin?, policy_class: ManagePolicy

    posts_group = Post.all.order(updated_at: :desc).group_by(&:status) 
    new_posts = posts_group['new_created'] ||= []
    approved_posts = posts_group['approved'] ||= []
    rejected_posts = posts_group['rejected'] ||= []


    @new_posts_paginate = new_posts.paginate(page: params[:page_new_posts], per_page: 10)

    @approved_posts_paginate = approved_posts.paginate(page: params[:page_approved_posts], per_page: 10)

    @rejected_posts_paginate = rejected_posts.paginate(page: params[:page_rejected_posts], per_page: 10)


    respond_to do |format|
      format.html
      format.js {render partial:"dashboard/dashboard/manage_posts.js.erb"}
    end
  end



end