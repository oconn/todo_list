require 'csv'
require 'time'

class Task
  @@task_ids = 1
  attr_reader :id, :created_at, :completed_at, :task, :tags
  def initialize(args)
    @id = @@task_ids
    @created_at = Time.parse(args[:created_at])
    @completed_at = args[:completed_at].empty? ? "not completed" : Time.parse(args[:completed_at])
    @task = args[:task]
    @tags = args[:tags].split(",")
    increment_id
  end

  def increment_id
    @@task_ids +=1
  end

  def to_s
     created = created_at.strftime(format='%l%P %b %-d')
     completed_at == "not completed" ? complete = "not completed" : complete = completed_at.strftime(format='%l%P %b %-d')
    "#{id}. #{task}. Created at: #{created}, #{tags}, Completed at: #{complete}"                                           #.strftime(format='%l%P %b %-d')
  end

  def <=>(next_task)
    if self.created_at > next_task.created_at
      1
    elsif self.created_at < next_task.created_at
      -1
    else
      0
    end
  end
end


class List

  attr_reader :contents
  def initialize
    @contents = []
    populate_contents
  end

  def create_task(args)
    Task.new(args)
  end


  def add_task(task)
    args = {created_at: Time.now.to_s, completed_at:  "", task: task, tags: ""}
    contents << create_task(args)
  end

  def delete_task(id)
    task = find_task_by_id(id)
    contents.delete(task)
  end

  def find_task_by_id(id)
    contents.select{|task| task.id == id}[0]
  end

  def populate_contents
    CSV.foreach('list.csv',headers: true, :header_converters => :symbol) do |row|
      @contents << create_task(row)
    end
  end

  def display(tasks = self.contents)
    puts tasks
  end

  def display_by_tag(tag)
    display(get_tasks_by_tag(tag))
  end

  def display_in_order
    display(contents.sort)
  end
  def get_tasks_by_tag(tag)
    contents.select {|task| task.tags.include?(tag)}
  end

  private

  attr_writer :contents
end


my_list = List.new
# puts my_list.contents[0]
my_list.display

puts

puts
my_list.display_in_order

puts
my_list.add_task("Call mom")
my_list.display
