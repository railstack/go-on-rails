# == Schema Information
#
# Table name: physicians
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Physician < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments

  validates :name, presence: true
end
