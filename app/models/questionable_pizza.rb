class QuestionablePizza < ActiveRecord::Base
  has_attached_file :pizza_image, default_url: "/pizza_images/missing.png"
  validates_attachment_content_type :pizza_image, content_type: /\Aimage\/.*\Z/, :if => Proc.new { |qp| qp.pizza_image.file? }
  has_attached_file :pizza_video, default_url: "/pizza_videos/missing.png"
  validates_attachment_content_type :pizza_video, content_type: /\Avideo\/.*\Z/, :if => Proc.new { |qp| qp.pizza_video.file? }
  validate :presence_of_video_or_image
  validates :client_ip, :presence => true

  enum is_it_pizza: [ :yes, :no, :waiting_on_cam ]

  before_save :set_is_it_pizza
  before_save :ip_waiting_on_cam
  after_create :ask_cam

  def pizza_media
    if self.pizza_image.exists?
      return pizza_image
    end
    self.pizza_video
  end

  def is_pizza_image
    self.pizza_image.exists?
  end

  private

  def set_is_it_pizza
    self.is_it_pizza ||= :waiting_on_cam
  end

  def ask_cam
    AskCamMailer.ask_cam(self.pizza_media.url, self.id, self.is_pizza_image).deliver
  end

  def ip_waiting_on_cam
    self.is_it_pizza != :waiting_on_cam || QuestionablePizza.where(:client_ip => self.client_ip, :is_it_pizza => QuestionablePizza.is_it_pizzas[:waiting_on_cam]).count == 0
  end

  def presence_of_video_or_image
    self.errors.add(:pizza_media, "must have only video or pizza") if self.pizza_image.file? && self.pizza_video.file?
    self.errors.add(:pizza_media, "must have either video or pizza") if !self.pizza_image.file? && !self.pizza_video.file?
  end
end
