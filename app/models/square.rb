class Square < ApplicationRecord
    belongs_to :theme

    validates :squareValue, presence:true
end
