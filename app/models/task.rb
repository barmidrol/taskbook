class Task < ActiveRecord::Base
	validates_presence_of :title, :content, :answers
  has_and_belongs_to_many :users
  ratyrate_rateable "users_rating"
  acts_as_taggable 
end
