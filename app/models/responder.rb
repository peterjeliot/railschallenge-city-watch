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

  def as_json(options = {})
    defaults = {
      except: [:id, :created_at, :updated_at],
      root: true
    }
    super options.merge(defaults)
  end

  private

  def ensure_on_duty_value
    self.on_duty = false if on_duty.nil?
  end
end
