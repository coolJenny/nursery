# == Schema Information
#
# Table name: discount_code_daycares
#
#  id               :integer          not null, primary key
#  discount_code_id :integer
#  daycare_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class DiscountCodeDaycare < ActiveRecord::Base
end
