module ApplicationHelper
  def dispatch_responders(e) # emergency
    responders = %w(Fire Police Medical).flat_map do |type|
      all_resources(e, type) ||
      exact_match(e, type, false) || nearest_greater(e, type, false) || sum_of_lessers(e, type, false) ||
      exact_match(e, type, true) || nearest_greater(e, type, true) || sum_of_lessers(e, type, true)
    end.reject(&:nil?)

    responders.each do |resp|
      resp.emergency_code = e.code
      resp.save!
    end
  end

  def all_resources(emergency, type)
    severities = {
      'Fire' => emergency.fire_severity,
      'Police' => emergency.police_severity,
      'Medical' => emergency.medical_severity
    }
    if Responder.where(type: type, on_duty: true).sum(:capacity) < severities[type]
      emergency.full_response = false
      return Responder.where(type: type, on_duty: true)
    else
      return nil
    end
  end

  def exact_match(emergency, type, use_off_duty)
    severities = {
      'Fire' => emergency.fire_severity,
      'Police' => emergency.police_severity,
      'Medical' => emergency.medical_severity
    }
    if severities[type] == 0
      emergency.full_response = true
      return []
    end
    if use_off_duty
      emergency.full_response = true
      Responder.where(type: type, on_duty: true, capacity: severities[type]).first
    else
      Responder.where(type: type, capacity: severities[type]).first
    end
  end

  def nearest_greater(emergency, type, use_off_duty)
    severities = {
      'Fire' => emergency.fire_severity,
      'Police' => emergency.police_severity,
      'Medical' => emergency.medical_severity
    }
    if use_off_duty
      emergency.full_response = true
      Responder.where(type: type, on_duty: true).where('capacity > ?', severities[type]).first
    else
      Responder.where(type: type).where('capacity > ?', severities[type]).first
    end
  end

  def sum_of_lessers(emergency, type, use_off_duty)
    severities = {
      'Fire' => emergency.fire_severity,
      'Police' => emergency.police_severity,
      'Medical' => emergency.medical_severity
    }
    if use_off_duty
      resps = Responder.where(type: type).where('capacity < ?', severities[type])
    else
      resps = Responder.where(type: type, on_duty: true).where('capacity < ?', severities[type])
    end
    2.upto(resps.length) do |count|
      resps.combination(count).each do |combo|
        if combo.map(&:capacity).sum == severities[type]
          emergency.full_response = true
          return combo
        end
      end
    end
    nil
  end

  def capacities_list(type)
    Responder.where(type: type, on_duty: true).order(capacity: :asc).map(&:capacity)
  end
end
