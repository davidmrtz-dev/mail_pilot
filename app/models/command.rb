class Command < ApplicationRecord
  enum :status, { pending: 0, running: 1, completed: 2, failed: 3 }

  VALID_COMMANDS = %w[
    ROOM_1_ON ROOM_1_OFF
    ROOM_2_ON ROOM_2_OFF
    ROOM_3_ON ROOM_3_OFF
    ROOM_4_ON ROOM_4_OFF
    DOOR_OPEN DOOR_CLOSE
    ALARM_ON ALARM_OFF
  ].freeze

  validates :action, presence: true
  validates :action, inclusion: { in: VALID_COMMANDS, message: "%{value} is not a valid command" }, unless: -> { action.start_with?("DISPLAY:") }
end
