include DateHelper

class Todo < ActiveRecord::Base

  before_save :set_completed_at, if: :task_completed?
  before_save :remove_completed_at, unless: :task_completed?

  def created_time
    time_ago_in_words(created_at)
  end

  def completed_time
    if completed_at
    time_ago_in_words(completed_at)
    else
      nil
    end
    # completed_at
  end

  private

  def set_completed_at
    self.completed_at = Time.zone.now
  end

  def remove_completed_at
    self.completed_at = nil
  end

  def task_completed?
    self.completed == true
  end

end
