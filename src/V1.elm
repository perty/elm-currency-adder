module V1 exposing (main)

import Browser
import Html exposing (Html, div, h1, text)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type Msg
    = NoOp


type alias Model =
    String


init : Model
init =
    "some string"


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Add money of different currencies"
            ]
        ]
