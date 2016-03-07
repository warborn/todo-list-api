namespace :import do
  desc "Import todos from csv"

  task todos: :environment do
    counter = 0
    filename = File.join Rails.root, "todos.csv"
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      todo = Todo.assign_from_row(row)
      if todo.save
        counter += 1
      end
    end
    puts "Imported #{counter} todos"
  end
end
