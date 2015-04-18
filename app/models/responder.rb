class Responder < ActiveRecord::Base
  # This allows the "type" column to not conflict
  # "type" usually refers to class name, used for inheritance
  def self.inheritance_column
    nil
  end

  validates :type, :name, :capacity, presence: true
  validates :name, uniqueness: true
  validates :on_duty, inclusion: { in: [true, false] }
  validates :capacity, inclusion: { in: (1..5).to_a }

  after_initialize :ensure_on_duty_value

  def json_format
    filtered_column_names = %w(emergency_code type name capacity on_duty)
    filtered_attributes = attributes.select do |attr, _|
      filtered_column_names.include? attr
    end
    { responder: filtered_attributes }
  end

  private

  def ensure_on_duty_value
    self.on_duty = false if on_duty.nil?
  end
end
