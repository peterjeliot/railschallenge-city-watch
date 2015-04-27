class Emergency < ActiveRecord::Base
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates :code, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity,
            numericality: { greater_than_or_equal_to: 0 }

  has_many :responders, primary_key: :code, foreign_key: :emergency_code

  attr_accessor :full_response

  def resolved_at=(time)
    self.responders = [] if time
    super
  end

  def as_json(options = {})
    defaults = {
      except: [:id, :created_at, :updated_at],
      root: true
    }
    result = super defaults.merge(options)
    result['emergency']['responders'] = responders.map(&:name)
    result['emergency']['full_response'] = full_response # TODO
    result
  end
end
