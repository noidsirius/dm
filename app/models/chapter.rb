class Chapter < ActiveRecord::Base

  has_and_belongs_to_many :problems, class_name: 'Problem', foreign_key: 'problem_id', join_table: 'problem_chapters', association_foreign_key: 'chapter_id'
end
