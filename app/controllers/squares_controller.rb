class SquaresController < ApplicationController
  def show
    @squares = Square.where("theme_id = ?", params[:id]).select(:squareValue, :id)
    
    @randomDeck = Array.new
    @rowArray = Array.new

    25.downto(1) do
      @randomSquare = rand(@squares.length)
      @correctSquares = @squares.slice(@randomSquare, 1)
      @randomDeck.push(@correctSquares[0].squareValue)
    end

    (1..5).each do
      @minideck = Array.new
      (1..5).each do
        @squareObject = Hash.new
        @randomIndex = rand(@randomDeck.length)
        @square = @randomDeck.slice(@randomIndex, 1)[0]
        @squareObject['value'] = @square
        @squareObject['checked'] = false
        @minideck.push(@squareObject)
      end
      @rowArray.push(@minideck)
    end

    if @rowArray.length > 0
      render json: {board: @rowArray}, status: :ok
    elsif @rowArray.length == 0
      render status: :no_content
    else
      render json: @square.errors, status: :unprocessable_entity
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
