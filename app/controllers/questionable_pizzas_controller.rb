class QuestionablePizzasController < ApplicationController
  http_basic_authenticate_with name: ENV['CAM_NAME'], password: ENV['CAM_PASSWORD'], only: :cam_says

  def ask_cam
    @can_ask_cam = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:waiting_on_cam], :client_ip => request.remote_ip).count == 0
    @is_it_pizza = QuestionablePizza.new
  end

  def create
    @is_it_pizza = QuestionablePizza.create(questionable_pizza_params)
  end

  def cam_says
    @questionable_pizza = QuestionablePizza.find(params[:id])
    @saved_pizza = false

    if @questionable_pizza
      @questionable_pizza.is_it_pizza = params[:is_it_pizza]
      @saved_pizza = @questionable_pizza.save
    end
  end

  def index
    @questionable_pizzas = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:yes]).limit(15).order('updated_at DESC')
  end

  private

  def questionable_pizza_params
    accepted_params = params.require(:questionable_pizza).permit(:pizza_image)
    accepted_params[:client_ip] = request.remote_ip
    accepted_params
  end
end
