class IslayMembers::Public::MembersController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!, except: :index

  def index
  end

  # GET /account
  def edit
  end

  def update
  end

  def subscription
    if params[:subscription_active].present?
      state = params[:subscription_active] == 'true'

      current_member.subscription_active = state
      if state
        flash[:result] = "Thank you! Your subscription has been activated."
      else
        flash[:result] = "Your subscription has been deactivated."
      end
    end
    redirect_to(params[:return_to]) if params[:return_to].present?
  end

  private

end
