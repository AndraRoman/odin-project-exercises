class Invitation < ActiveRecord::Base

  belongs_to :event, inverse_of: :invitations
  belongs_to :invitee, class_name: "User", inverse_of: :invitations

end
