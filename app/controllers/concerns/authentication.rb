module Authentication
  extend ActiveSupport::Concern

  included do
    private

    def current_user
      if session[:user_id].present?
        @current_user ||= User.find_by(id: session[:user_id])&.decorate
      elsif cookies.encrypted[:user_id].present?
        user = User.find_by(id: cookies.encrypted[:user_id])
        if user&.is_remember_token_authenticated?(cookies.encrypted[:remember_token])
          sign_in(user)
          @current_user ||= user.decorate
        end
      end
    end

    def user_signed_in?
      current_user.present?
    end

    def require_authentication
      redirect_to root_path if session[:user_id].nil?
    end

    def require_no_authentication
      redirect_to root_path unless session[:user_id].nil?
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end

    def remember(user)
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token
      cookies.encrypted.permanent[:user_id] = user.id
    end

    def forget(user)
      user.forget_me
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end

    helper_method :current_user, :user_signed_in?
  end
end
