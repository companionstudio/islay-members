class IslayMembers::Public::MembersController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!, except: :index

  def index
  end

  # GET /account
  def edit
  end

  def update
  end

  private

end
