module ApplicationHelper
  def dispatch_responders(e) # emergency
    e.full_response = true # default value
    responders = %w(Fire Police Medical).flat_map do |type|
      all_resources(e, type) ||
      exact_match(e, type, false) || nearest_greater(e, type, false) || sum_of_lessers(e, type, false) ||
      exact_match(e, type, true) || nearest_greater(e, type, true) || sum_of_lessers(e, type, true)
    end.reject(&:nil?)

    responders.each do |resp|
      resp.emergency_code = e.code
      resp.save!
    end
    e.save!
  end

  def all_resources(emergency, type)
    if Responder.where(type: type, on_duty: true).sum(:capacity) < emergency.severities[type]
      emergency.full_response = false
      return Responder.where(type: type, on_duty: true)
    else
      return nil
    end
  end

  def exact_match(emergency, type, use_off_duty)
    return [] if emergency.severities[type] == 0
    if use_off_duty
      Responder.where(type: type, capacity: emergency.severities[type]).first
    else
      Responder.where(type: type, on_duty: true, capacity: emergency.severities[type]).first
    end
  end

  def nearest_greater(emergency, type, use_off_duty)
    if use_off_duty
      Responder.where(type: type).where('capacity > ?', emergency.severities[type]).first
    else
      Responder.where(type: type, on_duty: true).where('capacity > ?', emergency.severities[type]).first
    end
  end

  def sum_of_lessers(emergency, type, use_off_duty)
    # yes, this is very inefficient. This problem is like the knapsack problem,
    # and this should have a real algorithm to solve that
    # (or at least not use .combination)
    if use_off_duty
      resps = Responder.where(type: type).where('capacity < ?', emergency.severities[type])
    else
      resps = Responder.where(type: type, on_duty: true).where('capacity < ?', emergency.severities[type])
    end
    2.upto(resps.length) do |count|
      resps.combination(count).each do |combo|
        return combo if combo.map(&:capacity).sum >= emergency.severities[type]
      end
    end
    nil
  end
end
