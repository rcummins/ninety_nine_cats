class CatRentalRequestsController < ApplicationController
    before_action :only_owner_approve_deny, only: [:approve, :deny]

    def new
        render :new
    end

    def create
        @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)

        if @cat_rental_request.save
            @cat = Cat.find_by(id: cat_rental_request_params[:cat_id])
            redirect_to cat_url(@cat)
        else
            flash.now[:errors] = @cat_rental_request.errors.full_messages
            render :new
        end
    end

    def approve
        current_cat_rental_request.approve!
        redirect_to cat_url(current_cat)
    end

    def deny
        current_cat_rental_request.deny!
        redirect_to cat_url(current_cat)
    end

    private

    def cat_rental_request_params
        params
            .require(:cat_rental_request)
            .permit(:cat_id, :start_date, :end_date, :status)
    end

    def current_cat_rental_request
        @cat_rental_request ||=
            CatRentalRequest.includes(:cat).find_by(id: params[:id])
    end

    def current_cat
        current_cat_rental_request.cat
    end

    def only_owner_approve_deny
        unless current_user == current_cat.owner
            redirect_to cat_url(current_cat)
        end
    end
end