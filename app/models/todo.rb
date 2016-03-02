include DateHelper

class Todo < ActiveRecord::Base
  attr_reader :created

  def created
    time_ago_in_words(created_at)
  end

end
