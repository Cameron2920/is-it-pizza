class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questionable_pizzas

  validates_presence_of :first_name, :last_name
end
