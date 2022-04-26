# frozen_string_literal: true

# this is a comment
class ThemesController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    @themes = Theme.all
    render json: @themes
  end

  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      render json: { message: "Success!", theme: @theme }, status: :created
    else
      render json: @theme.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_theme
    @theme = Theme.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def theme_params
    params.require(:theme).permit(:themeName)
  end
end
