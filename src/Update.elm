module Update exposing (..)

import Set
import Dict
import Debug exposing (log)


import Model exposing (..)
import Model.Ui exposing (..)
import Model.Resource exposing (..)
import Msg exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update action oldModel =
  let
      model =
        case action of
          OpenInfoPopup _ ->
            oldModel
          _ ->
            { oldModel
            | itemDropmenu = Nothing }
  in
      case action of
        InspectItem resource ->
          ({ model | inspectedItem = Just resource, inspectorMode = ShowItem }, Cmd.none)

        CloseItemInspector ->
          ({ model | inspectedItem = Nothing, inspectorMode = ShowItem }, Cmd.none)

        ChangeSearchString _ ->
          (model, Cmd.none)

        -- ToggleItemDropmenu resource ->
        --   let
        --       newState = if model.itemDropmenu == Just resource then Nothing else Just resource
        --   in
        --       ({ model | itemDropmenu = newState }, Cmd.none)

        -- ToggleItemOptional resource checked ->
        --   let
        --       optionalItems =
        --         model.optionalItems |> (if checked then Set.insert else Set.remove) resource.url
        --   in
        --       ({ model | optionalItems = optionalItems }, Cmd.none)

        DislikeItem item ->
          ({ model | inspectorMode = AskReasonForHidingItem
                   , dislikedItems = item :: model.dislikedItems }, Cmd.none)

        UndoDislikeItem item ->
          ({ model | dislikedItems = model.dislikedItems |> removeFromList item
                   , inspectorMode = ShowItem }, Cmd.none)

        SelectReasonForHidingItem _ ->
          ({ model | inspectorMode = ThanksForReasonForHidingItem, timeWhenSelectingReasonForDislikingItem = model.currentTime }, Cmd.none)

        HoverRating r ->
          ({ model | hoveringRating = Just r }, Cmd.none)

        UnHoverRating ->
          ({ model | hoveringRating = Nothing }, Cmd.none)

        EnterRating ->
          case model.hoveringRating of
            Nothing ->
              (model, Cmd.none)

            Just (k, v) ->
              ({ model | hoveringRating = Nothing, enteredRatings = model.enteredRatings |> Dict.insert k v }, Cmd.none)

        UpdateWindowSize {width, height} ->
          ({ model | windowWidth = width
                   , windowHeight = height
                   , paginationIndices = Dict.empty }, Cmd.none)

        MarkItemAsStarted item ->
          ({ model | playlists = model.playlists |> removeFromAllPlaylists item
                   , startedItems = item :: model.startedItems
                   , completedItems = model.completedItems |> removeFromList item
                   , paginationIndices = model.paginationIndices |> resetPaginationIndex headingStartedItems }, Cmd.none)

        MarkItemAsCompleted item ->
          ({ model | playlists = model.playlists |> removeFromAllPlaylists item
                   , completedItems = item :: model.completedItems
                   , startedItems = model.startedItems |> removeFromList item
                   , paginationIndices = model.paginationIndices |> resetPaginationIndex headingCompletedItems }, Cmd.none)

        ChangePageIndex heading newIndex ->
          ({ model | paginationIndices = model.paginationIndices |> Dict.insert heading newIndex }, Cmd.none)

        ChangeMyNotes item str ->
          ({ model | myNotesForItems = model.myNotesForItems |> Dict.insert item.url str }, Cmd.none)

        ClickPageBody ->
          ({ model | infoPopup = Nothing } |> closeInspector, Cmd.none)

        OpenInfoPopup message ->
          ({ model | infoPopup = if model.infoPopup==Nothing then Just message else Nothing }, Cmd.none)

        Tick currentTime ->
          ({ model | currentTime = currentTime } |> autoCloseInspectorAfterThanks , Cmd.none)

        UnimplementedAction ->
          ({ model | timeOfLastPopupTrigger = model.currentTime }, Cmd.none)


annotationsFromFeatures : Resource -> Model -> Model
annotationsFromFeatures resource model =
  let
      annotations =
        case resource.features |> Dict.get attrTextWorkload of
          Nothing ->
            model.annotations

          Just hours ->
            model.annotations
            |> Dict.insert (resource.url, attrTextWorkload) hours
  in
      { model | annotations = annotations }


autoCloseInspectorAfterThanks model =
  if model.inspectorMode == ThanksForReasonForHidingItem && model.currentTime > model.timeWhenSelectingReasonForDislikingItem + 1200 then
    model |> closeInspector
  else
    model


resetPaginationIndex heading paginationIndices =
  paginationIndices |> Dict.insert heading 0


closeInspector model =
  { model
  | inspectedItem = Nothing
  , inspectorMode = ShowItem }
