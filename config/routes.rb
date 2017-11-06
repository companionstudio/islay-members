Rails.application.routes.draw do
  islay_admin 'islay_members' do
    
    scope :path => 'members' do
    end

  end

  islay_secure_public 'members' do
    
  end 

end
