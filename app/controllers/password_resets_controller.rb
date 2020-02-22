class PasswordResetsController < ApplicationController
  before_action :get_user,			only: [:edit, :update]
  before_action :valid_user,		only: [:edit, :update]
  before_action :check_expiration, 	only: [:edit, :update]

  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
  		@user.create_reset_digest
  		@user.send_password_rest_smail
  		flash[:info] = "Email sent with password reset instructions"
  		redirect_to root_url
  	else
  		flash.now[:danger] = "Email address not found"
  		render 'new'
  	end
  end

  def edit
  end

  def update
  	if params[:user][:password].empty?
  		@user.errors.add(:password, :blank)
  		render 'edit'
  	elsif @user.update_attributes(user_params)
  		log_in @user
  		flash[:success] = "Password has been reset."
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end

  #パスワードの再設定の期限が切れている場合にはtrue
  def password_reset_expired?
  	reset_sent_at < 2.hours.ago
  end

  private
  	def user_params
  		params.require(:user).permit(:password, :password_confirmation)
  	end

  	#beforeフィルタ
  	def get_user
  		@user = User.find_by(email: params[:email])
  	end

  	#有効なユーザーか確認
  	def valid_user
  		unless(@user && @user.activated? &&
  				@user.authenticated?(:reset, params[:id]))
  		redirect_to root_url
  		end
  	end
  	#トークンが期限切れか確認
  	def check_expritation
  		if @user.password_reset_expired?
  			flash[:danger] = "password reset has exired."
  			redirect_to new_password_rest_url
  		end
  	end
end
