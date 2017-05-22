class AddUserReferenceToQuestionablePizza < ActiveRecord::Migration
  def change
    add_reference :questionable_pizzas, :user, :index => true
  end
end
