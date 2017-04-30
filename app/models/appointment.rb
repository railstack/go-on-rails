# == Schema Information
#
# Table name: appointments
#
#  id               :integer          not null, primary key
#  appointment_date :datetime
#  phisician_id     :integer
#  patient_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Appointment < ApplicationRecord
  belongs_to :physician
  belongs_to :patient
end
