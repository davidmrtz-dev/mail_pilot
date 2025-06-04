class CommandsController < ApplicationController
  # POST /inbound
  def receive_email
    body = params[:TextBody].to_s.strip.upcase
    command_text = body

    if command_text.present?
      Rails.logger.info(">> Received command: #{command_text}")
      Command.create(action: command_text)
      render json: { status: "command received", command: command_text }, status: :ok
    else
      Rails.logger.warn(">> No command found in email")
      render json: { error: "No command found" }, status: :unprocessable_entity
    end
  end

  # GET /device/commands/latest
  def latest
    command = Command.pending.order(created_at: :asc).first

    if command
      command.running!
      render json: { id: command.id, command: command.action }
    else
      render json: { command: nil }
    end
  end

  # PATCH /device/commands/:id/complete
  def complete
    command = Command.find_by(id: params[:id])

    if command&.running?
      command.completed!
      render json: { status: "command completed" }
    else
      render json: { error: "command not found or not running" }, status: :not_found
    end
  end

  # PATCH /device/commands/:id/failed
  def failed
    command = Command.find_by(id: params[:id])

    if command&.running?
      command.failed!
      render json: { status: "command failed" }
    else
      render json: { error: "command not found or not running" }, status: :not_found
    end
  end
end
