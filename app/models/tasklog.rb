class Tasklog < ApplicationRecord
  belongs_to :worklog
  validates_presence_of :task_description
end
