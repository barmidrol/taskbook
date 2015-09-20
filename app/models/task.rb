require 'elasticsearch/model'

class Task < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
	validates_presence_of :title, :content, :answers
  has_and_belongs_to_many :users
  ratyrate_rateable "users_rating"
  acts_as_taggable 
  acts_as_commentable
  default_scope { order('created_at DESC') }

  def self.search(query)
  __elasticsearch__.search(
    {
      query: {
        multi_match: {
          query: query,
          fields: ['title^10', 'content']
        }
      }, highlight: {
        pre_tags: ['<em>'],
        post_tags: ['</em>'],
        fields: {
          title: {},
          content: {}
        }
      } 
    }
  )
  end

  settings index: {  
    analysis: {
            tokenizer: {
              threegram: {
                type: 'nGram',
                min_gram: 2,
                max_gram: 3,
                token_chars: ['letter', 'digit']
              }
            },
            analyzer: {
              threegram: {
                tokenizer: :threegram,
                filter: [:standard, :lowercase, :stop]
              }
            }
          }
  } {
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'threegram'
      indexes :description, analyzer: 'threegram'
    end
  }
 
end

Task.__elasticsearch__.client.indices.delete index: Task.index_name rescue nil

# Create the new index with the new mapping
Task.__elasticsearch__.client.indices.create \
  index: Task.index_name,
  body: { settings: Task.settings.to_hash, mappings: Task.mappings.to_hash }

Task.import