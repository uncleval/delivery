class ApplicationController < ActionController::Base
  def authenticate!
    if request.format == Mime[:json]
      check_token!
    else
      authenticate_user!
    end
  end

  def set_locale!
    if params[:locale].present?
      I18n.locale = params[:locale]
    end
  end

  def current_user
    if request.format == Mime[:json]
      @user
    else
      super
    end
  end

  def current_credential
    return nil if request.format != Mime[:json]

    Credential.find_by(key: request.headers["X-API-KEY"]) || Credential.new
  end

  private

  def buyer?
    (current_user && current_user.buyer?) && current_credential.buyer?
  end

  def only_buyers!
    is_buyer = (current_user && current_user.buyer?) && current_credential.buyer?

    if !is_buyer
      render json: {message: "Not authorized"}, status: 401
    end
  end

  def check_token!
    if user =  authenticate_with_http_token { |t, _| User.from_token(t) }
      @user = user
    else
      render json: {message: "Not authorized"}, status: 401
    end
  end
end
