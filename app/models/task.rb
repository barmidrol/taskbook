class Task < ActiveRecord::Base
	validates_presence_of :title, :content, :answers
  has_and_belongs_to_many :users
  acts_as_taggable 
end
