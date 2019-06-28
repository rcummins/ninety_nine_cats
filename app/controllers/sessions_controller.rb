class SessionsController < ApplicationController
    before_action :skip_if_logged_in
    skip_before_action :skip_if_logged_in, only: [:destroy]

    def new
        render :new
    end

    def create
        user = User.find_by_credentials(params[:user][:username],
            params[:user][:password])

            if user
                login_user!(user)
                redirect_to cats_url
            else
                flash[:errors] = ["That username/password was not found"]
                redirect_to new_user_url
            end
    end

    def destroy
        user = current_user

        if user
            user.reset_session_token!
            session[:session_token] = nil
            redirect_to new_session_url
        end
    end

    private

    def skip_if_logged_in
        redirect_to cats_url if current_user
    end
end