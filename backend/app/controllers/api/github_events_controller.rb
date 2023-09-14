class Api::GithubEventsController < ApplicationController
  # Podrías querer saltar la verificación del token CSRF sólo para este método
  # si estás seguro de la legitimidad del webhook
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    # Aquí recibirías el payload del webhook de GitHub
    github_event = params[:github_event]

    # Procesar el evento de GitHub (guardarlo en la base de datos, etc.)
    GithubEvent.create(data: github_event)

    render json: { message: 'Event received' }
  end
end
