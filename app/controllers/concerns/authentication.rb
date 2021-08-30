module Authentication
  extend ActiveSupport::Concern

  included do
    private

    def current_user
      if session[:user_id].present?
        @current_user ||= User.find_by(id: session[:user_id])&.decorate
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
      session.delete(:user_id)
      @current_user = nil
    end

    helper_method :current_user, :user_signed_in?
  end
end
