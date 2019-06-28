class UsersController < ApplicationController
    before_action :skip_if_logged_in

    def new
        render :new
    end

    def create
        user = User.new(user_params)

        if user.save
            login_user!(user)
            redirect_to cats_url
        else
            flash.now[:errors] = user.errors.full_messages
            render :new
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :password)
    end

    def skip_if_logged_in
        redirect_to cats_url if current_user
    end
end