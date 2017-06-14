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
init = ( [{ x = 10, y = 10, length = 5, velocity = { x = 0, y = 6} }], Cmd.none)

type alias Model = List Drop

type alias Velocity =
  { x: Int
  , y: Int
  }

type alias Box =
  { width: Int
  , height: Int
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

svgSize: Box
svgSize =
  { width = 400
  , height = 400
  }

randomPosition : Random.Generator { x: Int, y: Int }
randomPosition =
  Random.map2 (\x y -> { x = x, y = y }) (Random.int 0 400) (Random.int -40 -20)

randomVelocity : Random.Generator Velocity
randomVelocity =
  Random.map2 Velocity (Random.int 1 2) (Random.int 6 12)

randomDrop : Random.Generator Drop
randomDrop =
  Random.map3 (\pos len velocity -> { x = pos.x, y = pos.y, length = len, velocity = velocity }) (randomPosition) (Random.int 5 10) (randomVelocity)


-- Updates
type Msg = Reset
  | Tick Time
  | GenerateDrop Drop


generateDropMessage : Int -> Cmd Msg
generateDropMessage length =
  if length < 100 then
    Random.generate GenerateDrop randomDrop
  else
    Cmd.none


numberOrReset: Int -> Int -> Int -> Int
numberOrReset constraint resetTo number =
  if number <= constraint then
    number
  else
    resetTo

resetToBeforeView: Int -> Int
resetToBeforeView number =
  numberOrReset svgSize.height -100 number


addVelocity: Drop -> (Int, Int)
addVelocity raindrop =
  let
    newX =
      resetToBeforeView(raindrop.x + raindrop.velocity.x)
    newY =
      resetToBeforeView(raindrop.y + raindrop.velocity.y)
  in
    (newX, newY)


updateDropPosition: Drop -> Drop
updateDropPosition raindrop =
  let
    (nX, nY) = addVelocity raindrop

  in
    { x = nX, y = nY, length = raindrop.length, velocity = raindrop.velocity }


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Reset ->
      init
    Tick newTime ->
      ( List.map updateDropPosition model, (generateDropMessage (List.length model)))
    GenerateDrop drop ->
      (model ++ [drop], Cmd.none)



-- View
drawRain: Drop -> Svg.Svg Msg
drawRain raindrop =
  line [x1 (toString(raindrop.x)), y1 (toString(raindrop.y)), x2 (toString(raindrop.x + (raindrop.length * raindrop.velocity.x))), y2 (toString(raindrop.y + (raindrop.length * raindrop.velocity.y))), stroke purpleColor, strokeWidth "3" ] []


view: Model -> Html Msg
view model =
  let
    boxWidth =
      (toString(svgSize.width))
    boxHeight =
      (toString(svgSize.height))
  in
    div [] [
      svg [ width boxWidth, height boxHeight, viewBox "0 0 400 400" ]
        ([ rect [x "0", y "0", width boxWidth, height boxHeight, fill backgroundColor] []
        ] ++ (List.map drawRain model))
    ]

-- Subscriptions
subscriptions: Model -> Sub Msg
subscriptions model =
  Time.every (1000 / 24 * millisecond) Tick
