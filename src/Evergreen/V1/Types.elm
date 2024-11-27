module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V1.Shared.Types
import Lamdera
import Set
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , state : Evergreen.V1.Shared.Types.CommonState
    }


type alias BackendModel =
    { state : Evergreen.V1.Shared.Types.CommonState
    , connectedClients : Set.Set Lamdera.ClientId
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | ChangeBackground String


type ToBackend
    = NoOpToBackend
    | UpdateBackgroundColorRequest String


type BackendMsg
    = NoOpBackendMsg
    | ClientConnected Lamdera.SessionId Lamdera.ClientId
    | ClientDisconnected Lamdera.SessionId Lamdera.ClientId


type ToFrontend
    = NoOpToFrontend
    | UpdateBackgroundColor String
    | InitialState Evergreen.V1.Shared.Types.CommonState
