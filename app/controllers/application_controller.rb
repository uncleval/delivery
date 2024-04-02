class ApplicationController < ActionController::Base
  def authenticate!
    if request.format == Mime[:json]
      check_token!
    else
      authenticate_user!
    end
  end

  def current_user
    if request.format == Mime[:json]
      @user
    else
      super
    end
  end

  private

  def check_token!
    if user =  authenticate_with_http_token { |t, _| User.from_token(t) }
      @user = user
    else
      render json: {message: "Not authorized"}, status: 401
    end
  end
end
