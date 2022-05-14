module ApplicationHelper

  def logout_path
    destroy_user_session_path
  end

end
