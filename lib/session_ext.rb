class ActionDispatch::Session::AbstractStore::SessionHash
  def user_id
    self[:user_id]
  end
  
  def user_id=(uid)
    self[:user_id] = uid
  end
  
  def user
    @user ||= User[self[:user_id]]
  end
  
  def user=(usr)
    self.user_id = usr.pk
    @user = usr
  end
end