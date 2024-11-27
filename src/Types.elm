module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera exposing (ClientId, SessionId)
import Set exposing (Set)
import Shared.Types exposing (CommonState)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , message : String
    , state : CommonState
    }


type alias BackendModel =
    { state : CommonState
    , connectedClients : Set ClientId
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | ChangeBackground String


type ToBackend
    = NoOpToBackend
    | UpdateBackgroundColorRequest String


type BackendMsg
    = NoOpBackendMsg
    | ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId


type ToFrontend
    = NoOpToFrontend
    | UpdateBackgroundColor String
    | InitialState CommonState