# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

todo_list_count = 30

item_lower = 17
item_upper = 45

todo_list_count.times do |todo_list_num|
  todo_list = TodoList.create(code: TodoList.generate_code )
  item_count = [*item_lower..item_upper].sample

  item_count.times do |item_num|
    title     = Faker::Company.bs
    content   = Faker::Lorem.paragraph
    show_time = Time.now + [*0..300].sample
    TodoItem.create(todo_list_id: todo_list.id,
                 title: title,
                 content: content,
                 show_time: show_time,
                 priority: [*1..5].sample)
    todo_list.item_count += 1;
  end
end
