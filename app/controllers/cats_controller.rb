class CatsController < ApplicationController
    before_action :deny_if_logged_out

    def index
        @cats = Cat.all
        render :index
    end

    def show
        @cat = Cat.find_by(id: params[:id])
        @cat_rental_requests = CatRentalRequest
            .where(cat_id: params[:id])
            .order(:start_date)

        if @cat
            render :show
        else
            redirect_to cats_url
        end
    end

    def new
        @cat = Cat.new
        render :new
    end

    def create
        @cat = Cat.new(cat_params.merge({user_id: current_user.id}))

        if @cat.save
            redirect_to cat_url(@cat)
        else
            flash.now[:errors] = @cat.errors.full_messages
            render :new
        end
    end

    def edit
        @cat = Cat.find_by(id: params[:id])
        render :edit
    end

    def update
        @cat = Cat.find_by(id: params[:id])

        if @cat.update_attributes(cat_params)
            redirect_to cat_url(@cat)
        else
            flash.now[:errors] = @cat.errors.full_messages
            render :edit
        end
    end

    def destroy
        cat = Cat.find_by(id: params[:id])
        cat.destroy

        redirect_to cats_url
    end

    private

    def cat_params
        params
            .require(:cat)
            .permit(:birth_date, :color, :name, :sex, :description)
    end

    def deny_if_logged_out
        redirect_to new_session_url unless current_user
    end
end
