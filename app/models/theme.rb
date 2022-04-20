class Theme < ApplicationRecord
    has_many :squares

    validates :themeName, presence:true
end
