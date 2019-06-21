class Cat < ApplicationRecord
    include ActionView::Helpers::DateHelper

    COLORS = %w(Black Brown White Orange)

    validates :color, inclusion: { in: COLORS }
    validates :sex, inclusion: { in: %w(M F) }
    validates :birth_date, :color, :name, :sex, :description, presence: true

    has_many :cat_rental_requests, dependent: :destroy

    def age
        time_ago_in_words(self.birth_date).capitalize
    end
end