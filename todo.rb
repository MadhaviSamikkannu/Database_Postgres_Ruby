require 'active_record'

class Todo < ActiveRecord::Base
  def due_today?
    Date.today == due_date
  end

  def self.due_today
    where("due_date = ?",Date.today)
  end
  def self.overdue
      where("due_date < ?",Date.today)
  end

  def self.due_later
    where("due_date > ?",Date.today)
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map {|todo| todo.to_displayable_string }
  end

  def self.show_list ( )
    puts "My Todo-list\n\n"
    puts "Overdue\n "
    puts overdue.to_displayable_list
    puts"\n"
    puts "Due Today\n "
    puts due_today.to_displayable_list
    puts"\n"
    puts "Due Later\n "
    puts due_later.to_displayable_list
  end

  def self.add_task(todo_create)
    create!(todo_text: todo_create[:todo_text], due_date: Date.today + todo_create[:due_in_days], completed: false)
  end

  def self.mark_as_complete(todo_id)
    todo = Todo.find(todo_id)
    todo.completed = true
    todo.save
    todo
  end

end
