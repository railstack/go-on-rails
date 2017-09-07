# == Schema Information
#
# Table name: pictures
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  url            :string(255)
#  imageable_id   :integer
#  imageable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
end
