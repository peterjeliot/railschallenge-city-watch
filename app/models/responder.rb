class Responder < ActiveRecord::Base
  validates :type, :name, :capacity, :on_duty, presence: true

  # This allows the "type" column to not conflict
  def self.inheritance_column
    nil
  end

  after_initialize :ensure_off_duty

  private

  def ensure_off_duty
    self.on_duty = false
  end
end
