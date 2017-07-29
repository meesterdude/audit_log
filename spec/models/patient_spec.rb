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

require 'rails_helper'

RSpec.describe Patient, type: :model do

  specify { expect(Patient.ancestors.include?(Loggable)).to eq(true) }

  # Validations
  specify{ expect(Patient.new(last_name: 'lawblog')).to_not be_valid }
  specify{ expect(Patient.new(first_name: 'bob')).to_not be_valid }
  specify{ expect(Patient.new(first_name: 'bob', last_name: "lawblog")).to be_valid }

  # Loggable
  describe "Loggable" do


    it "creates an ActivityLog on create and update" do
      patient = Patient.create(first_name: 'mad', last_name: 'max')
      patient.update(last_name: 'maxy')
      expect(patient.activity_logs.count).to be
    end

    describe "Instance Methods" do

      let!(:patient){Patient.create(first_name: "charly", last_name: 'dai')}

      before do
        patient.update(first_name: "charles")
        patient.update(last_name: "bay")
        patient.update(first_name: "charly", last_name: 'day')
      end

      subject {patient}

      describe "#undo" do

        it "rolls back to previous version" do
          expect(subject.undo.last_name).to eql "bay"
        end

        it "unravels changes with each call" do
          subject.undo
          subject.undo
          expect(subject.first_name).to eql "charles"
          expect(subject.last_name).to eql "bay"
        end

        it "rolls back a certain number of steps when passed an integer" do
          updated_patient = subject.undo(5)
          expect(updated_patient.first_name).to eql "charly"
          expect(updated_patient.last_name).to eql "dai"
        end

      end

    end

  end



end
