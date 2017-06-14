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
init = ( { x = 10, y = 10, length = 5, velocity = { x = 0, y = 1} }, Cmd.none)

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
  (model, Cmd.none)


-- View
view: Model -> Html Msg
view model =
  div [] [
    svg [ width "400", height "400", viewBox "0 0 400 400" ]
      [ rect [x "10", y "10", width "400", height "400", fill backgroundColor] []
      , line [x1 "10", y1 "10", x2 "20", y2 "20", stroke purpleColor, strokeWidth "3" ] []
      ]
  ]

-- Subscriptions
subscriptions: Model -> Sub Msg
subscriptions model =
  Time.every (1000 / 24 * millisecond) Tick
