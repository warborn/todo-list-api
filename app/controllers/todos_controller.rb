class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy, :completed]

  def import
    @import = User::Import.new todo_import_params
    if @import.save
      render json: {
        new_todos: @import.serialized(@import.new_todos),
        updated_todos: @import.serialized(@import.updated_todos),
        todos_imported: @import.imported_count,
        todos_updated:  @import.updated_count
      }, status: :created, location: @todo
    else
      render json: {
        errors: @import.errors
      }, status: :unprocessable_entity
    end
  end

  # GET /todos
  # GET /todos.json
  def index
    @todos = Todo.all

    render json: @todos, callback: params[:callback]
  end

  # GET /todos/1
  # GET /todos/1.json
  def show
    render json: @todo
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    if @todo.update(todo_params)
      head :no_content
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1/completed
  def completed
    @todo.toggle(:completed)

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    @todo.destroy

    head :no_content
  end

  private

    def set_todo
      @todo = Todo.find(params[:id])
    end

    def todo_params
      params.require(:todo).permit(:name, :completed)
    end

    def todo_import_params
      params.require(:todo_import).permit(:file)
    end
end
