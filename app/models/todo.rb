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
  end

  def self.assign_from_row(row)
    todo = Todo.where(name: row[:name]).first_or_initialize
    todo.assign_attributes row.to_hash.slice(:name)
    todo
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
