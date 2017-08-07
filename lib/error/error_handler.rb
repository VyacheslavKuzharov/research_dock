# Error module to Handle errors globally
# include Error::ErrorHandler in application_controller.rb
module Error
  module ErrorHandler
    def self.included(clazz)
      include ApiHelper

      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |e|
          throw_error!(404, :record_not_found , e.to_s)
        end
        rescue_from StandardError do |e|
          throw_error!(500, :standard_error, e.to_s)
        end

        rescue_from CustomError do |e|
          throw_error!(e.error, e.status, e.message)
        end
      end

    end
  end
end