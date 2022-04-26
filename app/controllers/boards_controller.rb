# frozen_string_literal: true

# this is a comment
class BoardsController < ActionController::Base
  include Rails.application.routes.url_helpers

  def create
    theme_res = create_theme
    return if theme_res[0] != 201

    theme_id = append_theme_id(theme_res)
    squares_res = create_squares_bulk

    if squares_res[0] == 201
      render json: { message: "OK", theme_id: }, status: :created
    else
      render json: squares_res.errors, status: :unprocessable_entity
    end
  end

  def theme_params
    params.require(:theme, :square).permit(:themeName, :squareValue)
  end

  def create_theme
    ThemesController.dispatch(:create, request, response)
  end

  def create_squares_bulk
    SquaresController.dispatch(:bulk_create, request, response)
  end

  def append_theme_id(theme_response)
    theme_id = JSON.parse(theme_response[2].body)["theme"]["id"]
    request.params[:theme_id] = theme_id

    theme_id
  end
end
