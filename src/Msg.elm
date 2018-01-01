module Msg exposing (..)

import Window
import Time exposing (Time)

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Resource exposing (..)


type Msg
  = ChangeSearchString String
  | InspectItem Resource
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
  | MarkItemAsStarted Resource
  | MarkItemAsCompleted Resource
  | Tick Time
  | UnimplementedAction


subscriptions : Model -> Sub Msg
subscriptions {ui} =
  [ Window.resizes UpdateWindowSize
  , Time.every (100 * Time.millisecond) Tick
  ] |> Sub.batch
