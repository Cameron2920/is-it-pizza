class AskCamMailer < ActionMailer::Base
  default from: "cam@likes.pizza"

  def ask_cam(media_file_path, questionable_pizza_id, is_pizza_image)
    @media_file_path = media_file_path
    @questionable_pizza_id = questionable_pizza_id
    @is_pizza_image = is_pizza_image
    mail(to: 'cam@monolithinteractive.com', subject: 'We need your help cam')
  end
end
