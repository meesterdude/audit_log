# == Schema Information
#
# Table name: activity_logs
#
#  id            :integer          not null, primary key
#  loggable_type :string
#  loggable_id   :integer
#  changes_hash  :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ActivityLog < ApplicationRecord
   serialize :changes_hash, JSON
end
