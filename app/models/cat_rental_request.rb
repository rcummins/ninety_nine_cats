class CatRentalRequest < ApplicationRecord
    STATUS_OPTIONS = %w(PENDING APPROVED DENIED)

    validates :status, inclusion: { in: STATUS_OPTIONS }
    validates :start_date, :end_date, :status, presence: true
    validate :does_not_overlap_approved_request

    belongs_to :cat

    def overlapping_requests
        CatRentalRequest
            .where('start_date <= ?', self.end_date)
            .where('end_date >= ?', self.start_date)
            .where(cat_id: self.cat_id)
            .where.not(id: self.id)
    end

    def overlapping_approved_requests
        self
            .overlapping_requests
            .where(status: 'APPROVED')
    end

    def does_not_overlap_approved_request
        if self.overlapping_approved_requests.exists?
            errors[:base] << 'Dates overlap with previously approved request'
        end
    end
end
