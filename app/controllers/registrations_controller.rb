class RegistrationsController < ApplicationController
  skip_forgery_protection only: [:create, :sign_in, :me]
  before_action :authenticate!, only: [:me]
  # rescue_from ActionController::ParameterMissing, with: :param_missing
  rescue_from User::InvalidToken, with: :not_authorized

  def me
    render json: {id: current_user.id, email: current_user.email}
  end

  def sign_in
    user = User.find_by(email: sign_in_params[:email])

    if !user || !user.valid_password?(sign_in_params[:password])
      render json: {message: "Nope!"}, status: 401
    else
      token = User.token_for(user)
      render json: {email: user.email, token: token}
    end
  end

  def create
    @user = User.new(user_params)

    # if @user.save
    #   render json: {"email": @user.email}
    # end

    if @user.save
      respond_to do |format|
        # format.html { redirect_to root_path, notice: "New registration created." }
        format.json { render json: {"email": @user.email} }
      end
    else
      respond_to do |format|
        # format.html { render :new, status: :unprocessable_entity }
        format.json { render :error, status: :unprocessable_entity }
      end
    end
  end

  private

  def sign_in_params
    params
      .required(:login)
      .permit(:email, :password)
  end

  def user_params
    params
      .required(:user)
      .permit(:email, :password, :password_confirmation, :role)
  end

  def not_authorized(e = nil)
    render json: {message: "Nope!"}, status: 401
  end
end
