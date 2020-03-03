module V5 exposing (main)

import Browser
import Html exposing (Html, div, h1, input, option, select, table, td, text, th, thead, tr)
import Html.Events exposing (onInput)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type Msg
    = LeftValue String
    | LeftCurrency String
    | RightValue String
    | RightCurrency String


type alias Currency =
    { code : String
    , rate : Float
    }


type alias Model =
    { leftValue : String
    , leftCurrency : String
    , rightValue : String
    , rightCurrency : String
    , currencies : List Currency
    }


init : Model
init =
    { leftValue = ""
    , leftCurrency = ""
    , rightValue = ""
    , rightCurrency = ""
    , currencies = currencies
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        LeftValue string ->
            { model | leftValue = string }

        LeftCurrency string ->
            { model | leftCurrency = string }

        RightValue string ->
            { model | rightValue = string }

        RightCurrency string ->
            { model | rightCurrency = string }


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Add money of different currencies"
            ]
        , div []
            [ input [ onInput LeftValue ] []
            , select [ onInput LeftCurrency ] currencyOptions
            , text " + "
            , input [ onInput RightValue ] []
            , select [ onInput RightCurrency ] currencyOptions
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
                    text <|
                        (String.fromFloat <|
                            addTwoCurrencies left model.leftCurrency right model.rightCurrency
                        )
                            ++ " "
                            ++ model.rightCurrency

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


currencyOptions : List (Html Msg)
currencyOptions =
    [ option [] [ text "--" ] ] ++ (List.map currencyOption <| List.map .code currencies)


currencyOption : String -> Html Msg
currencyOption currency =
    option [] [ text currency ]


addTwoCurrencies : Float -> String -> Float -> String -> Float
addTwoCurrencies v1 c1 v2 c2 =
    let
        rate1 =
            findCurrencyRate c1

        rate2 =
            findCurrencyRate c2
    in
    ((rate1 * v1) + (rate2 * v2)) / rate2



-- Return the currency rate. We can be confident that the user can not select
-- a none-existing currency so a default of 1.0 is safe.


findCurrencyRate : String -> Float
findCurrencyRate codeName =
    let
        maybeRate =
            List.filter (\c -> c.code == codeName) currencies
                |> List.map .rate
                |> List.head
    in
    Maybe.withDefault 1.0 maybeRate
