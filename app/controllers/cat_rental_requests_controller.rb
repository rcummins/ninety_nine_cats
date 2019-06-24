class CatRentalRequestsController < ApplicationController
    def new
        render :new
    end

    def create
        @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)

        if @cat_rental_request.save
            @cat = Cat.find_by(id: cat_rental_request_params[:cat_id])
            redirect_to cat_url(@cat)
        else
            render :new
        end
    end

    def approve
        CatRentalRequest
            .find_by(id: params[:id])
            .approve!

        @cat = Cat.find_by(id: CatRentalRequest.find_by(id: params[:id]).cat_id)
        redirect_to cat_url(@cat)
    end

    def deny
        CatRentalRequest
            .find_by(id: params[:id])
            .deny!

        @cat = Cat.find_by(id: CatRentalRequest.find_by(id: params[:id]).cat_id)
        redirect_to cat_url(@cat)
    end

    private

    def cat_rental_request_params
        params
            .require(:cat_rental_request)
            .permit(:cat_id, :start_date, :end_date, :status)
    end
end