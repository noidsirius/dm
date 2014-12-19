class Event < ActiveRecord::Base
  translates :title, :description, :sentence, :summary, :location, :type, :category
end
