class User::Import
  include ActiveModel::Model
  attr_accessor :file, :imported_count, :updated_count, :new_record, :new_todos, :updated_todos

  def process!
    @new_todos = []
    @updated_todos = []
    @imported_count = 0
    @updated_count = 0
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      todo = Todo.assign_from_row(row)
      @new_record = todo.new_record?
      if todo.save
        if @new_record
          new_todos << todo
          @imported_count += 1
        else
          updated_todos << todo
          @updated_count  += 1
        end
      else
        errors.add(:base, "#{$.} - #{todo.errors.full_messages.join(",")}")
      end
    end
  end

  def save
    process!
    errors.none?
  end

  def serialized todos
    todos.map do |todo|
      ActiveModel::SerializableResource.new(todo)
    end
  end
end
