module SessionsHelper

  # Hypothesis: strange behavior is triggered by log_in separate from session creation
  # OBSERVATION if, on one page, I log out, the right three things seem to happen BUT as soon as I reload or navigate to a different url (eg users/16 from users/15) then the *original* user is back in session[:user_id]

  def log_in(user)
    session[:user_id] = user.id
    user.remember # remember_token associated, remember_digest saved to db
    cookies.permanent[:remember_token] = user.remember_token
  end

  # this method (and current_user) seems to be unavailable even though log_in is fine. what gives?
  # session[:user_id] destroyed by caller
  def log_out
    @current_user = nil
    session.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # doesn't set/unset self.current_user if session or cookies fail
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id) # assigns and returns @current_user
    elsif remember_token = cookies.permanent[:remember_token].to_s
      remember_digest = User.digest(remember_token)
      user = User.find_by(remember_digest: remember_digest)
      if user
        log_in user
        @current_user ||= user
      end
    end
  end

end
