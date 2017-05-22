class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questionable_pizzas

  validates_presence_of :first_name, :last_name, :middle_name

  before_validation do
    if self.middle_name.nil?
      self.middle_name = User.guess_middle_name
    end
  end

  def can_ask_cam
    allowed_pending_pizza_count = 1
    accepted_pizza_count = self.questionable_pizzas.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:yes]).count
    total_pizza_count = self.questionable_pizzas.where.not(:is_it_pizza => QuestionablePizza.is_it_pizzas[:waiting_on_cam]).count

    if total_pizza_count > 0
      allowed_pending_pizza_count = [[((accepted_pizza_count.to_f / total_pizza_count.to_f) * QuestionablePizza::MAX_NUMBER_OF_PENDING_PIZZAS).ceil, accepted_pizza_count].min, 1].max
    end
    self.questionable_pizzas.where(:is_it_pizza => QuestionablePizza.is_it_pizzas[:waiting_on_cam]).count < allowed_pending_pizza_count
  end

  def self.guess_middle_name
    possible_middle_names = ["the original dubois", "jeanboi's second cousin", "肮脏的狗",
                             "definitely doesn't want to see the 3rd reich return", "probably not a rapist",
                             "no middle name required", "pomagranite buttcheeks"]
    possible_middle_names.sample
  end
end
