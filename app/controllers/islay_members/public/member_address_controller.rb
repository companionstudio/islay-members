class IslayMembers::Public::MemberAddressController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!
  before_action :find_resource, only: [:edit, :update, :destroy]
  before_action :new_resource,  only: [:new, :create]

  def index
  end

  def new
    @address = current_member.addresses.build
  end

  def edit
  end

  def create
    persist! @address
  end

  def update
    persist! @address
  end

  def destroy
    if @address.destroy
      flash[:result]  = 'Address deleted'
      redirect_to([:public, :member, :address, :index])
    else
      redirect_to([:edit, :public, :member, address])
    end
  end

  private

  def persist!(address)
    if address.update_attributes(params[:address].permit!)
      flash[:result] = address.new_record? ? 'Address saved' : 'Address updated'
      redirect_to([:edit, :public, :member, address])
    else
      render(address.new_record? ? :new : :edit)
    end
  end

  def find_resource
    @address = current_member.addresses.find(params[:id])
  end

  def new_resource
    @address = current_member.addresses.build
  end
end
