require_dependency "safe_html"

class Action
  include Mongoid::Document

  STATUS_ACTIONS = [
    CREATE                      = "create",
    SCHEDULE_FOR_PUBLISHING     = "schedule_for_publishing",
    PUBLISH                     = "publish",
    NEW_VERSION                 = "new_version",
  ]

  NON_STATUS_ACTIONS = [
    NOTE = "note",
  ]

  embedded_in :edition

  belongs_to :recipient, class_name: "User"
  belongs_to :requester, class_name: "User"

  field :approver_id,        type: Integer
  field :approved,           type: DateTime
  field :comment,            type: String
  field :comment_sanitized,  type: Boolean, default: false
  field :request_type,       type: String
  field :request_details,    type: Hash, default: {}
  field :email_addresses,    type: String
  field :customised_message, type: String
  field :created_at,         type: DateTime, default: lambda { Time.zone.now }

  def status_action?
    STATUS_ACTIONS.include?(request_type)
  end

  def to_s
    if request_type == SCHEDULE_FOR_PUBLISHING
      string = "Scheduled for publishing"
      string += " on #{request_details['scheduled_time'].to_datetime.in_time_zone('London').strftime('%d/%m/%Y %H:%M')}" if request_details['scheduled_time'].present?
      string
    else
      request_type.humanize.capitalize
    end
  end
end
