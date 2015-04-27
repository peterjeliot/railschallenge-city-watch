class Emergency < ActiveRecord::Base
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates :code, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity,
            numericality: { greater_than_or_equal_to: 0 }

  has_many :responders, primary_key: :code, foreign_key: :emergency_code

  def resolved_at=(time)
    if time
      self.responders = []
      responders.each do |resp|
        resp.emergency_code = nil # I thought the association took care of this...
      end
    end
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
