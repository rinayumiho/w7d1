class UsersController < ApplicationController

    before_action :ensure_logged_out, only: [:new, :create]

    def index
        @users = User.all
        render json: @users
    end
    def show
        @user = User.find_by(id: params[:id])
        render :show
    end

    def new
        render :new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            login(@user)
            redirect_to user_url(@user)
        else
            render :new
        end
    end

    private

    def user_params
        params.require(:user).permit(:user_name, :password)
    end
end
