class IslayMembers::Public::MembersController < IslayMembers::Public::ApplicationController

  def index
    @membership = Member.new
  end

  def home
    
  end

  def create
    @membership = Member.create!(permitted_params[:member])
    redirect_to public_club_home_path
  end

  private

  def permitted_params
    params.permit!
  end
end
