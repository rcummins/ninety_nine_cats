class Cat < ApplicationRecord
    include ActionView::Helpers::DateHelper

    validates :color, inclusion: { in: %w(black brown white orange) }
    validates :sex, inclusion: { in: %w(M F) }
    validates :birth_date, :color, :name, :sex, :description, presence: true
    
    def age
        time_ago_in_words(self.birth_date).capitalize
    end
end