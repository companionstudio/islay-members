class IslayMembers::Public::ApplicationController < Islay::Public::ApplicationController  
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :member
  end

  def resource
    @resource ||= Member.new
  end

  def resource_class
    Member
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:member]
  end
end
