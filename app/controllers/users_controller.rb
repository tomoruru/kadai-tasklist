class UsersController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @users = @user.users.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user=User.new(user_params)
    
    if @user.save
      flash[:success ] ='ユーザーを登録しました。'
      redirect_to login_url
    else
      flash.now[:danger] = 'ユーザー登録に失敗しました。'
      render :new
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def correct_user
    @user = current_user.users.find_by(id: params[:id])
    unless @user
      redirect_to root_url
    end
  end
  
end
