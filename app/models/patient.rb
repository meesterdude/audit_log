# == Schema Information
#
# Table name: patients
#
#  id             :integer          not null, primary key
#  first_name     :string
#  last_name      :string
#  physician_name :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Patient < ApplicationRecord
  after_update :record_changes

  has_many :activity_logs, as: :loggable

  def record_changes
    self.activity_logs.create(changes_hash: self.changes)
  end

  def undo(steps=1)
    reset_to self.activity_logs.last(steps).first
  end

  def reset_to(activity_log)
    activity_log.changes_hash.except("updated_at").each {|k, v| self[k] = v.first}
    self
  end


end
