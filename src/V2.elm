module V2 exposing (main)

import Browser
import Html exposing (Html, div, h1, input, text)
import Html.Events exposing (onInput)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type Msg
    = LeftValue String
    | RightValue String


type alias Model =
    { leftValue : String
    , rightValue : String
    }


init : Model
init =
    Model "" ""


update : Msg -> Model -> Model
update msg model =
    case msg of
        LeftValue string ->
            { model | leftValue = string }

        RightValue string ->
            { model | rightValue = string }


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Add money of different currencies"
            ]
        , div []
            [ input [ onInput LeftValue ] []
            , text " + "
            , input [ onInput RightValue ] []
            ]
        ]
