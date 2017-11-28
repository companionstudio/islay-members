class IslayMembers::Public::MemberAddressController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!

  def index
  end

  def new
    @address = current_member.addresses.build
  end

  def create
  end

  def update
  end

  def delete
  end

  private

end
