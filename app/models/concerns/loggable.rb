require 'active_support/concern'

module Loggable
  extend ActiveSupport::Concern

  included do
    has_many :activity_logs, -> { order(created_at: :asc) }, as: :loggable
    after_save :record_changes
  end

  # records any changes made to self
  def record_changes
    self.activity_logs.create(changes_hash: self.changes)
  end

  # Rolls back the object to the previous version. repeated calls will go further back,
  # unraveling changes made along the way.
  # or pass in an integer of steps to go back from, but reload object before
  # switching from without steps to with to avoid unexpected changes being acquired
  #
  # Parameters:
  #  steps(optional)  - Integer of steps to go back
  #
  # Returns:
  # Modified self with previous values altered
  def undo(steps=nil)
    @steps ||= 1
    @steps += 1 unless steps
    reset_to self.activity_logs.last(steps || @steps).first
  end

  private

  # Resets self to be the previous version stored in a given activity_log
  #
  # Parameters:
  #  activity_log  - an ActivityLog object to rollback to
  #
  # Returns:
  #  self with modified attributes
  def reset_to(activity_log)
    activity_log.changes_hash.except("updated_at").each {|k, v| self[k] = v.last}
    self
  end

end
