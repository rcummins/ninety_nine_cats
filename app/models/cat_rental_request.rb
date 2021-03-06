class CatRentalRequest < ApplicationRecord
    STATUS_OPTIONS = %w(PENDING APPROVED DENIED)

    validates :status, inclusion: { in: STATUS_OPTIONS }
    validates :start_date, :end_date, :status, presence: true
    validate :start_date_before_end_date
    validate :does_not_overlap_approved_request

    belongs_to :cat
    belongs_to :requester, class_name: :User, foreign_key: :user_id

    def start_date_before_end_date
        if self.start_date > self.end_date
            errors[:start_date] << "must come before end date"
            errors[:end_date] << "must come after start date"
        end
    end

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

    def overlapping_pending_requests
        self
            .overlapping_requests
            .where(status: 'PENDING')
    end

    def does_not_overlap_approved_request
        if self.overlapping_approved_requests.exists?
            errors[:base] << 'Dates overlap with previously approved request'
        end
    end

    def pending?
        self.status == 'PENDING'
    end

    def deny!
        self.status = 'DENIED'
        self.save!
    end

    def approve!
        return false unless self.pending?

        ActiveRecord::Base.transaction do
            self.overlapping_pending_requests.each do |request|
                request.deny!
            end

            self.status = 'APPROVED'
            self.save!
        end
    end
end
