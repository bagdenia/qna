class AtmsController < ApplicationController
  skip_authorization_check
  respond_to :js
  def create
    @atm = Atm.create(atm_params)
    respond_to do |format|
      format.js
    end
    # if @atm.save
    #   redirect_to atms_path
    # else
    #   render :error
    # end
  end

  def index
    @atms = Atm.all
  end

  def closest
    @atms = Atm.get_closest(params[:lat].to_f, params[:lng].to_f)
  end

  private

  def atm_params
    params.require(:atm).permit(:address, :lng, :lat)
  end
end
