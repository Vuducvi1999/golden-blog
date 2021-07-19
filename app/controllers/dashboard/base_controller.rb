class Dashboard::BaseController < ApplicationController
  before_action :check_user 
  def check_user
    authorize :manage, :check_user?, policy_class: ManagePolicy
  end
end