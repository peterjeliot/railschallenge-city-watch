class Emergency < ActiveRecord::Base
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates :code, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity,
            numericality: { greater_than_or_equal_to: 0 }

  has_many :responders, primary_key: :code, foreign_key: :emergency_code, inverse_of: :emergency

  def resolved_at=(time)
    self.responders = [] if time
    super
  end

  def as_json(options = {})
    defaults = {
      except: [:id, :created_at, :updated_at]
    }
    new_options = defaults.merge(options)
    result = super new_options
    if new_options[:root]
      # what's the right way to do this? include/method puts a hash of {name: foo}s, not an array of foos
      result['emergency']['responders'] = responders.map(&:name)
      result['emergency']['full_response'] = full_response # TODO
    else
      result['responders'] = responders.map(&:name)
      result['full_response'] = full_response # TODO
    end
    result
  end
end
