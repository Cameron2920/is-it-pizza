class QuestionablePizzasController < ApplicationController
  before_action :authenticate_cam, only: :cam_says

  def ask_cam
    can_ask?
    @is_it_pizza = QuestionablePizza.new
  end

  def create
    redirect_to questionable_pizzas_ask_cam_path, :flash => { :error => "No, I don't think so..." } and return unless can_ask?
    @show_index_link = params[:show_index_link] != "false"
    create_params = questionable_pizza_params
    create_params[:is_it_pizza] = :yes if @current_user&.is_cam?
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
          flash[:error] = @is_it_pizza.errors.full_messages.join(". ")
          redirect_to questionable_pizzas_ask_cam_path, :flash => { :error =>  @is_it_pizza.errors.full_messages.join(". ") }
        end
      }
      format.json {
        if @is_it_pizza.errors.any?
          render json: @is_it_pizza.errors.full_messages, :status => :unprocessable_entity
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
    @questionable_pizzas = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:yes]).order('updated_at DESC')
    @questionable_pizzas = @questionable_pizzas.page(params[:page])
  end

  private

  def can_ask?
    if !@current_user.nil?
      @can_ask_cam = @current_user.can_ask_cam
      @is_temporary_banned = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:no], :user => @current_user).where("created_at > ? ", DateTime.now - 69.hours).count > 2

      if @is_temporary_banned
        @unban_time = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:no], :user => @current_user).where("created_at > ? ", DateTime.now - 69.hours).order("created_at ASC").first.created_at + 69.hours
      end
    else
      @can_ask_cam = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:waiting_on_cam], :client_ip => request.remote_ip).count == 0
      @is_temporary_banned = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:no], :client_ip => request.remote_ip).where("created_at > ? ", DateTime.now - 69.hours).count > 2

      if @is_temporary_banned
        @unban_time = QuestionablePizza.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:no], :client_ip => request.remote_ip).where("created_at > ? ", DateTime.now - 69.hours).order("created_at ASC").first.created_at + 69.hours
      end
    end
    @can_ask_cam
  end

  def questionable_pizza_params
    accepted_params = params.fetch(:questionable_pizza, {}).permit(:pizza_image, :pizza_video, :pizza_image_link, :pizza_video_link)
    accepted_params[:client_ip] = request.remote_ip
    accepted_params[:user] = @current_user
    accepted_params
  end

  def authenticate_cam
    unless @current_user&.is_cam?
      http_basic_authenticate_or_request_with(name: "cam", password: Rails.application.config.cam_password)
    end
  end
end
