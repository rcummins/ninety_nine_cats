class CatRentalRequest < ApplicationRecord
    STATUS_OPTIONS = %w(PENDING APPROVED DENIED)

    validates :status, inclusion: { in: STATUS_OPTIONS }
    validates :start_date, :end_date, :status, presence: true

    belongs_to :cat
end