module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (Html, div, text)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import Lamdera
import Shared.Types exposing (CommonState)
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , message = "Welcome to Muktanshu's First ELM Project!"
      , state = initialState
      }
    , Cmd.none
    )


initialState : CommonState
initialState =
    { backgroundColor = "#FFFFFF"
    }


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        ChangeBackground color ->
            let
                newState =
                    { backgroundColor = color }
            in
            ( { model | state = newState }
            , Lamdera.sendToBackend (UpdateBackgroundColorRequest color)
            )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )
            
        UpdateBackgroundColor newColor ->
            let
                newState =
                    { backgroundColor = newColor }
            in
            ( { model | state = newState }, Cmd.none )
            
        InitialState state ->
            ( { model | state = state }, Cmd.none )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = "Color Palette"
    , body =
        [ div 
            [ Attr.style "text-align" "center"
            , Attr.style "padding-top" "40px"
            , Attr.style "min-height" "100vh"
            , Attr.style "background-color" model.state.backgroundColor
            , Attr.style "transition" "background-color 0.3s ease"
            ]
            [ div
                [ Attr.style "font-family" "sans-serif"
                , Attr.style "padding-top" "40px"
                ]
                [ text model.message ]
            , div [ Attr.style "padding-top" "20px" ]
                [ text "Color Palette:"
                , div
                    [ Attr.style "display" "flex"
                    , Attr.style "justify-content" "center"
                    , Attr.style "margin-top" "20px"
                    ]
                    [ colorBlock "#FF5733"
                    , colorBlock "#33FF57"
                    , colorBlock "#3357FF"
                    , colorBlock "#FF33A1"
                    , colorBlock "#A133FF"
                    ]
                ]
            ]
        ]
    }


colorBlock : String -> Html FrontendMsg
colorBlock color =
    div
        [ Attr.style "width" "50px"
        , Attr.style "height" "50px"
        , Attr.style "margin" "0 10px"
        , Attr.style "background-color" color
        , Attr.style "cursor" "pointer"
        , Attr.style "border" "2px solid #000000"
        , onClick (ChangeBackground color)
        ]
        []