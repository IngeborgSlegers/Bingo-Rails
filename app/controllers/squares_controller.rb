# frozen_string_literal: true

# this is a comment
class SquaresController < ApplicationController
  def show
    @squares = Square.where("theme_id = ?", params[:id]).select(:squareValue, :id)
    return if @squares.empty?

    @random_deck = []
    @row_array = []

    random25
    build_deck_form

    if !@row_array.empty?
      render json: { board: @row_array }, status: :ok
    else
      render json: @square.errors, status: :unprocessable_entity
    end
  end

  def random25
    25.downto(1) do
      @random_square = rand(@squares.length)
      @correct_squares = @squares.slice(@random_square, 1)
      @random_deck.push(@correct_squares[0].squareValue)
    end
  end

  def build_deck_form
    5.times do
      @minideck = []
      build_mini_deck
      @row_array.push(@minideck)
    end
  end

  def build_mini_deck
    5.times do
      @square_object = {}
      @random_index = rand(@random_deck.length)
      @square = @random_deck.slice(@random_index, 1)[0]
      @square_object["value"] = @square
      @square_object["checked"] = false
      @minideck.push(@square_object)
    end
  end

  def index
    @squares = Square.all
    render json: @squares, status: :ok
  end

  def create
    @square = Square.new(square_params)

    if @square.save
      render json: @square, status: :created
    else
      render json: @square.errors, status: :unprocessable_entity
    end
  end

  def bulk_create
    square_values = params[:squareValue]

    @squares = Square.create_with(created_at: Time.now, updated_at: Time.now).insert_all(format_bulk_request(square_values))

    if @squares
      render json: { message: "Success" }, status: :created
    else
      render json: @squares.errors, status: :unprocessable_entity
    end
  end

  def format_bulk_request(values)
    format_request = []
    values.each do |t|
      format_request.push(
        {
          theme_id: request.params[:theme_id],
          squareValue: t
        }
      )
    end
    format_request
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_theme
    @theme = Theme.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def square_params
    params.require(:square).permit(:squareValue, :theme_id)
  end
end
