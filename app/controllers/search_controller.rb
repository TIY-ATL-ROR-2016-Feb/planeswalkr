class SearchController < ApplicationController
	def card_search
    if params[:card_set]
      @set = CardSet.find(params[:card_set])
      @cards = @set.cards
    else
      @cards = Card.where
    end
    @cards = @cards.named(params[:name]) if params[:name].present?
    @cards = @cards.containing(params[:text]) if params[:text].present?
    @cards = filter_by_cost(params[:mana_cost]) if cost_filter?
		render :card_search
	end

  private
  def cost_filter?
    params[:cost_filter].present? && params[:mana_cost].present?
  end

  def filter_by_cost(cost)
    case params[:cost_filter]
    when "<" then
      @cards.cost_under(cost)
    when "=" then
      @cards.cost_is(cost)
    when ">" then
      @cards.cost_over(cost)
    end
  end
end
