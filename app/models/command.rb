class Command < ApplicationRecord
  enum :status, { pending: 0, running: 1, completed: 2, failed: 3 }

  VALID_COMMANDS = %w[
    LED_ON LED_OFF
    SERVO_0 SERVO_90
    BUZZER_ON BUZZER_OFF
    RGB_RED RGB_GREEN RGB_BLUE
    DISPLAY:HELLO DISPLAY:BYE
  ].freeze

  validates :action, presence: true
  validates :action, inclusion: { in: VALID_COMMANDS, message: "%{value} is not a valid command" }, unless: -> { action.start_with?("DISPLAY:") }
end
