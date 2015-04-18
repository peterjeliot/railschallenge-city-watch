class Responder < ActiveRecord::Base
  # This allows the "type" column to not conflict
  # It usually refers to class name, used for inheritance
  def self.inheritance_column
    nil
  end

  validates :type, :name, :capacity, presence: true
  validates :name, uniqueness: true
  validates :on_duty, inclusion: { in: [true, false] }
  validates :capacity, inclusion: { in: (1..5).to_a, message: 'is not included in the list' }

  after_initialize :ensure_off_duty

  def json_format
    wanted_columns = %w(emergency_code type name capacity on_duty)
    { responder: attributes.select { |attr, _| wanted_columns.include? attr } }
  end

  private

  def ensure_off_duty
    self.on_duty = false if on_duty.nil?
  end
end
