class QuestionablePizzasController < ApplicationController
  http_basic_authenticate_with name: ENV['CAM_NAME'], password: ENV['CAM_PASSWORD'], only: :cam_says

  def ask_cam
    @can_ask_cam = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:waiting_on_cam], :client_ip => request.remote_ip).count == 0
    @is_temporary_banned = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:no], :client_ip => request.remote_ip).where("created_at > ? ", DateTime.now - 69.hours).count > 2
    if @is_temporary_banned
      @unban_time = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:no], :client_ip => request.remote_ip).where("created_at > ? ", DateTime.now - 69.hours).order("created_at ASC").first.created_at + 69.hours
    end
    @is_it_pizza = QuestionablePizza.new
  end

  def create
    @show_index_link = params[:show_index_link] != "false"
    create_params = questionable_pizza_params
    pizza_image_link = create_params.delete(:pizza_image_link)
    pizza_video_link = create_params.delete(:pizza_video_link)

    if !pizza_image_link.nil? && pizza_image_link.length > 0
      @is_it_pizza = QuestionablePizza.create_with_image_url(create_params, pizza_image_link)
    elsif !pizza_video_link.nil? && pizza_video_link.length > 0
      @is_it_pizza = QuestionablePizza.create_with_video_url(create_params, pizza_video_link)
    else
      @is_it_pizza = QuestionablePizza.create(create_params)
    end
    flash[:error]

    respond_to do |format|
      format.html {
        if @is_it_pizza.errors.any?
          flash[:error] = @is_it_pizza.errors.first
          redirect_to questionable_pizzas_ask_cam_path, :flash => { :error =>  @is_it_pizza.errors.first }
        end
      }
      format.json {
        if @is_it_pizza.errors.any?
          render json: @is_it_pizza.errors, :status => :unprocessable_entity
        else
          head :ok
        end
      }
    end
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
    accepted_params = params.fetch(:questionable_pizza, {}).permit(:pizza_image, :pizza_video, :pizza_image_link, :pizza_video_link)
    accepted_params[:client_ip] = request.remote_ip
    accepted_params
  end
end
