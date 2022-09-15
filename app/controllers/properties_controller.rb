class PropertiesController < ApplicationController
  def new
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)
    @valid_experts = Expert.where(city: @property.city, nb_sales: 0...15)
    score_attribution_array = array_expert_score(@valid_experts)
    score_attribution_array_sorted = score_attribution_array.sort_by { |array| array[1] }
    @expert = score_attribution_array_sorted.last.first unless score_attribution_array_sorted.empty?
    @property.expert = @expert if @expert
    if @property.save
      redirect_to properties_path
    else
      render "pages/home"
   end
  end

  def array_expert_score(valid_experts)
    score_attribution_array = []
    valid_experts.each do |expert|
      score_attribution =
        case @property.price
        when 1..500000
          calcul(expert.score_a, expert.nb_sales)
          # score_attribution = expert.score_a * ((15 - expert.nb_sales).to_f / 15 * 2) if expert.score_a && expert.score_a > 0
        when 500000..1000000
          calcul(expert.score_b, expert.nb_sales)
          # score_attribution = expert.score_b * ((15 - expert.nb_sales).to_f / 15 * 2) if expert.score_b && expert.score_b > 0
        else
          calcul(expert.score_c, expert.nb_sales)
          # score_attribution = expert.score_c * ((15 - expert.nb_sales).to_f / 15 * 2) if expert.score_c && expert.score_c > 0
        end
      next unless score_attribution
      score_attribution_array << [expert, score_attribution]
    end
    return score_attribution_array
  end

  def calcul(expert_score, expert_nb_sales)
    expert_score * ((15 - expert_nb_sales).to_f / 15 * 2) if expert_score && expert_score > 0
  end

  def index
    @properties = Property.order(created_at: :desc)
  end

  private

  def property_params
    params.require(:property).permit(:city, :price)
  end

end
