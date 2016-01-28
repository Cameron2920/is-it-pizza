class QuestionablePizzasController < ApplicationController
  http_basic_authenticate_with name: ENV['CAM_NAME'], password: ENV['CAM_PASSWORD'], only: :cam_says

  def ask_cam
    if params.has_key?(:questionable_pizza)
      @is_it_pizza = QuestionablePizza.create(questionable_pizza_params)
    end

    if !@is_it_pizza.nil? && @is_it_pizza.errors.nil?

    else
      @is_it_pizza = QuestionablePizza.new
    end
  end

  def cam_says
    @questionable_pizza = QuestionablePizza.find(params[:id])

    if @questionable_pizza
      @questionable_pizza.is_it_pizza = params[:is_it_pizza]

      if @questionable_pizza.save

      end
    end
  end

  private

  def questionable_pizza_params
    params.require(:questionable_pizza).permit(:pizza_image)
  end
end
