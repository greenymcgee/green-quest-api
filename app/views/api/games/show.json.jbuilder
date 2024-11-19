json.game { json.partial! "api/games/game", game: @game }
json.errors @game.errors if @game.errors.present?
