class CardsetsController < ApplicationController
  before_action :administrate!, except: [:show]

  def new
    render :new
  end

  def create
    file = params[:cardset]
    begin
      data = JSON.parse(file.read)
    rescue JSON::ParserError => e
      flash[:notice] = "That JSON file is all fucked up."
      redirect_to root_path
    end
    ImportJob.perform_later(data, params[:import_dir])
    flash[:notice] = "Your data is queued for Import. You'll receive an email upon completion."
    redirect_to root_path
  end

  def index
    @cardsets = CardSet.all
    render :index
  end

  def show
    @cardset = CardSet.find_by!(code: params[:id])
    @cards = @cardset.cards.page(params[:page]).per(15)
    render :show
  end
end
