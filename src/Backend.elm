module Backend exposing (..)

import Lamdera exposing (ClientId, SessionId)
import Set exposing (Set)
import Shared.Types exposing (CommonState)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { state = initialState
      , connectedClients = Set.empty
      }
    , Cmd.none
    )


initialState : CommonState
initialState =
    { backgroundColor = "#FFFFFF"
    }


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        , Lamdera.onDisconnect ClientDisconnected
        ]


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )
            
        ClientConnected sessionId clientId ->
            ( { model | connectedClients = Set.insert clientId model.connectedClients }
            , Lamdera.sendToFrontend clientId (InitialState model.state)
            )

        ClientDisconnected sessionId clientId ->
            ( { model | connectedClients = Set.remove clientId model.connectedClients }
            , Cmd.none
            )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )
            
        UpdateBackgroundColorRequest newColor ->
            let
                newState =
                    { backgroundColor = newColor }

                updatedModel =
                    { model | state = newState }
            in
            ( updatedModel
            , Lamdera.broadcast (UpdateBackgroundColor newColor)
            )