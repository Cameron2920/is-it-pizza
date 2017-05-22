class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questionable_pizzas

  validates_presence_of :first_name, :last_name

  def can_ask_cam
    allowed_pending_pizza_count = 1
    accepted_pizza_count = self.questionable_pizzas.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:yes]).count
    total_pizza_count = self.questionable_pizzas.where.not(:is_it_pizza => QuestionablePizza.is_it_pizzas[:waiting_on_cam]).count

    if total_pizza_count > 0
      allowed_pending_pizza_count = [[((accepted_pizza_count.to_f / total_pizza_count.to_f) * QuestionablePizza::MAX_NUMBER_OF_PENDING_PIZZAS).ceil, accepted_pizza_count].min, 1].max
    end
    self.questionable_pizzas.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:waiting_on_cam]).count < allowed_pending_pizza_count
  end
end
