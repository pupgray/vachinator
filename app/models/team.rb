class Team < ApplicationRecord
  belongs_to :captain, class_name: 'User', required: true
end
