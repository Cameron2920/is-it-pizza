class AskCamMailer < ActionMailer::Base
  default from: "cam@likes.pizza"

  def ask_cam(media_file_path, questionable_pizza_id)
    @media_file_path = media_file_path
    @questionable_pizza_id = questionable_pizza_id
    mail(to: 'cam@monolithinteractive.com', subject: 'We need your help cam')
  end
end
