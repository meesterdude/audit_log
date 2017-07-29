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
  include Loggable

  validates :first_name, :last_name, presence: true

end
