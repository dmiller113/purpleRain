import Html exposing (Html, div, text)
import Time exposing (Time, millisecond)
import Svg exposing (svg, rect, line)
import Svg.Attributes exposing (..)
import Random
import Basics exposing (floor)


-- Main
main: Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- Models
init: (Model, Cmd Msg)
init = ( { x = 10, y = 10, length = 5, velocity = { x = 0, y = 6} }, Cmd.none)

type alias Model = Drop

type alias Velocity =
  { x: Int
  , y: Int
  }

type alias Drop =
  { x: Int
  , y: Int
  , length: Int
  , velocity: Velocity
  }

type alias Color = String

purpleColor: Color
purpleColor = "#ad6ffb"

backgroundColor: Color
backgroundColor = "#f7f7f7"


-- Updates
type Msg = Reset
  | Tick Time

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Reset ->
      init
    Tick newTime ->
      ( { x = (model.x + model.velocity.x), y = (model.y + model.velocity.y), length = model.length, velocity = model.velocity }, Cmd.none)


-- View
view: Model -> Html Msg
view model =
  let
    convertCoord n =
      let
        offset =
          10
      in
        (toString(offset + n))
  in
    div [] [
      svg [ width "400", height "400", viewBox "0 0 400 400" ]
        [ rect [x (convertCoord 10), y (convertCoord 10), width "400", height "400", fill backgroundColor] []
        , line [x1 (convertCoord model.x), y1 (convertCoord model.y), x2 (convertCoord (model.x + (model.length * model.velocity.x))), y2 (convertCoord (model.y + (model.length * model.velocity.y))), stroke purpleColor, strokeWidth "3" ] []
        ]
    ]

-- Subscriptions
subscriptions: Model -> Sub Msg
subscriptions model =
  Time.every (1000 / 24 * millisecond) Tick
