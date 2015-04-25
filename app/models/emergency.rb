class Emergency < ActiveRecord::Base
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates :code, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity,
            numericality: { greater_than_or_equal_to: 0 }

  def as_json(options = {})
    defaults = {
      except: [:id, :created_at, :updated_at]
    }
    super defaults.merge(options)
  end
end
