class QuestionablePizza < ActiveRecord::Base
  has_attached_file :pizza_image, default_url: "/pizza_images/missing.png"
  validates_attachment_content_type :pizza_image, content_type: /\Aimage\/.*\Z/
  validates :pizza_image, :presence => true
  validates :client_ip, :presence => true

  enum is_it_pizza: [ :yes, :no, :waiting_on_cam ]

  before_save :set_is_it_pizza
  before_save :ip_waiting_on_cam
  after_create :ask_cam

  private

  def set_is_it_pizza
    self.is_it_pizza ||= :waiting_on_cam
  end

  def ask_cam
    AskCamMailer.ask_cam(self.pizza_image.url, self.id).deliver
  end

  def ip_waiting_on_cam
    self.is_it_pizza != :waiting_on_cam || QuestionablePizza.where(:client_ip => self.client_ip, :is_it_pizza => QuestionablePizza.is_it_pizzas[:waiting_on_cam]).count == 0
  end
end
