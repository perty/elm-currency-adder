module V4 exposing (main)

import Browser
import Html exposing (Html, div, h1, input, table, td, text, th, thead, tr)
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


type alias Currency =
    { code : String
    , rate : Float
    }


type alias Model =
    { leftValue : String
    , rightValue : String
    , currencies : List Currency
    }


init : Model
init =
    Model "" "" currencies


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
            , text " = "
            , viewResult model
            , viewCurrenciesTable model
            ]
        ]


viewResult : Model -> Html Msg
viewResult model =
    case String.toFloat model.leftValue of
        Just left ->
            case String.toFloat model.rightValue of
                Just right ->
                    text <| String.fromFloat (left + right)

                Nothing ->
                    text "?"

        Nothing ->
            text "?"


viewCurrenciesTable : Model -> Html Msg
viewCurrenciesTable model =
    table
        []
        ([ thead []
            [ th [] [ text "Code" ]
            , th [] [ text "Rate" ]
            ]
         ]
            ++ viewCurrenciesRows model.currencies
        )


viewCurrenciesRows : List Currency -> List (Html Msg)
viewCurrenciesRows c =
    List.map viewCurrencyRow c


viewCurrencyRow : Currency -> Html Msg
viewCurrencyRow c =
    tr [] [ td [] [ text c.code ], td [] [ text (String.fromFloat c.rate) ] ]



-- Data


currencies : List Currency
currencies =
    [ Currency "EUR" 10.57
    , Currency "USD" 9.5
    , Currency "CHF" 9.9
    , Currency "INR" 0.13
    ]
