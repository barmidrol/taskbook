namespace :db do
  desc "Create 100 users with random names and descriptions"
  task :populate => :environment do
  require 'populator'
  require 'faker'
    Task.populate 10 do |task|
    task.title = Faker::Lorem.word
    task.content = Faker::Lorem.paragraph
    task.user_id = 3
    task.answers = 'answer'
    puts task.title
    end
    puts 'All done'
  end
end