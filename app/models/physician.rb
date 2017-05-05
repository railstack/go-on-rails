# == Schema Information
#
# Table name: physicians
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  introduction :text(65535)
#

class Physician < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments

  validates :name, presence: true, length: { in: 6..15 }
  validates :introduction, presence: true
end
