class IslayMembers::Public::MembersController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!, except: :index

  def index
    template = member_signed_in? ? :index_logged_in : :index_logged_out
    render template
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
