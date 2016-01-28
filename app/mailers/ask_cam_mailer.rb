class AskCamMailer < ActionMailer::Base
  default from: "cam@likes.pizza"

  def ask_cam(image_file_path, questionable_pizza_id)
    @image_file_path = image_file_path
    @questionable_pizza_id = questionable_pizza_id
    mail(to: 'cam@monolithinteractive.com', subject: 'We need your help cam')
  end
end
