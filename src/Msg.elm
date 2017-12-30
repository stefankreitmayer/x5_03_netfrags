module Msg exposing (..)

import Window

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Resource exposing (..)


type Msg
  = ChangeSearchString String
  | InspectItem Resource Playlist
  | CloseItemInspector
  | ShowDetails Resource
  | HideDetails Resource
  | ToggleItemDropmenu Resource
  | ToggleItemOptional Resource Bool
  | ChangeAnnotation Resource String String
  | DislikeResult String
  | RevokeDislike
  | ConfirmDislike String
  | HoverRating (Rateable, Int)
  | UnHoverRating
  | EnterRating
  | UpdateWindowSize Window.Size
  | StartItem Resource


subscriptions : Model -> Sub Msg
subscriptions {ui} =
  [ Window.resizes UpdateWindowSize ] |> Sub.batch
