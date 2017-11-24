class IslayMembers::Public::MembersController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!, except: :index

  def index
    if member_signed_in?
      render template = :index_logged_in
    else
      redirect_to new_member_registration_path
    end
  end

  def index_logged_in
  end

  def index_logged_out
  end

  # GET /account
  def edit
  end

  def offers
  end

  def orders
  end

  private

end
