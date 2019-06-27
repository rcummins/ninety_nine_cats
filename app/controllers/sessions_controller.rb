class SessionsController < ApplicationController
    def new
        render :new
    end

    def create
        user = User.find_by_credentials(params[:user][:username],
            params[:user][:password])

            if user
                user.reset_session_token!
                session[:session_token] = user.session_token
                redirect_to cats_url
            else
                flash[:errors] = ["That username/password was not found"]
                redirect_to new_user_url
            end
    end
end