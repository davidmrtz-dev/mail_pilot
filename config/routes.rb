Rails.application.routes.draw do
  post "/inbound", to: "commands#receive_email"
  get  "/device/commands/latest", to: "commands#latest"
  patch "/device/commands/:id/complete", to: "commands#complete"
  patch "/device/commands/:id/failed", to: "commands#failed"
end
