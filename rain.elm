import Html exposing (Html, div, text)
import Time exposing (Time, millisecond)
import Svg exposing (svg, rect, circle)
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

-- Updates
type Msg = Reset
  | Tick Time

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)


-- View
view: Model -> Html Msg
view model =
  div [] []

-- Subscriptions
subscriptions: Model -> Sub Msg
subscriptions model =
  Time.every (1000 / 24 * millisecond) Tick
