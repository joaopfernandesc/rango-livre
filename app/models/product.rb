class Product < ApplicationRecord
    acts_as_paranoid

    before_create :set_uuid

    def set_uuid
        self.uuid = SecureRandom.uuid
    end
    
end
