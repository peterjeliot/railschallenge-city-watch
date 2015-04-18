class Responder < ActiveRecord::Base
  validates :type, :name, :capacity, presence: true
  validates :on_duty, inclusion: { in: [true, false] }
  validates :capacity, inclusion: { in: [1..5], message: 'is not included in the list' }

  # This allows the "type" column to not conflict
  # It usually refers to class name, used for inheritance
  def self.inheritance_column
    nil
  end

  after_initialize :ensure_off_duty

  private

  def ensure_off_duty
    self.on_duty = false if on_duty.nil?
  end
end
