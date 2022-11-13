require 'csv'

namespace :questionable_pizzas do
  task export_for_ml: :environment do
    supported_image_types = [".png", ".gif", ".jpeg", ".jpg"]
    timestamp = DateTime.now.to_i
    FileUtils.mkdir_p("./export/#{timestamp}/pizza")
    FileUtils.mkdir_p("./export/#{timestamp}/not_pizza")
    source_directory = "./image_export/var/is-it-pizza/public/system/questionable_pizzas/pizza_images/"
    questionable_pizzas = QuestionablePizza.where.not(pizza_image_file_name: nil).where(is_it_pizza: [:yes, :no])
    Rails.logger.info("Exporting images starting")

    questionable_pizzas.find_each.with_index do |questionable_pizza, index|
      Rails.logger.info("Exporting image #{index + 1} / #{questionable_pizzas.size}") if index % 10 == 0
      image_path = questionable_pizza.pizza_image.path.split("system/questionable_pizzas/pizza_images/")[1]

      if supported_image_types.find{|image_type| image_path.downcase.ends_with?(image_type)}
        if questionable_pizza.is_it_pizza&.to_sym == :yes
          FileUtils.cp("#{source_directory}/#{image_path}", "./export/#{timestamp}/pizza") rescue nil
        elsif questionable_pizza.is_it_pizza&.to_sym == :no
          FileUtils.cp("#{source_directory}/#{image_path}", "./export/#{timestamp}/not_pizza") rescue nil
        end
      end
    end
    Rails.logger.info("Exporting images finished")
  end
end
