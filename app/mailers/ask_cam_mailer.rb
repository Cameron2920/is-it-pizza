class AskCamMailer < ActionMailer::Base
  default from: "cam@likes.pizza"

  def ask_cam(media_file_path, questionable_pizza_id, is_pizza_image)
    @media_file_path = media_file_path
    @questionable_pizza_id = questionable_pizza_id
    @is_pizza_image = is_pizza_image
    mail(to: 'cam@monolithinteractive.com', subject: 'We need your help cam')
  end

  def notify_user_of_pizza(user, questionable_pizza)
    @user = user
    @is_it_pizza = questionable_pizza.is_it_pizza
    mail(to: user.email, subject: 'Hey n3rd, one of your submitted pizzas has been verified')
  end
end
