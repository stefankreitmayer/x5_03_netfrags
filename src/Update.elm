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
          ToggleItemDropmenu _ ->
            oldModel
          _ ->
            closeDropmenu oldModel
  in
      case action of
        ChangeSearchString _ ->
          (model, Cmd.none)

        AddResourceToProject resource ->
          ({ model | projectResources = resource :: model.projectResources } |> annotationsFromFeatures resource, Cmd.none)

        ShowDetails resource ->
          ({ model | expandedSearchResults = resource.url :: model.expandedSearchResults}, Cmd.none)

        HideDetails resource ->
          ({ model | expandedSearchResults = model.expandedSearchResults |> List.filter (\url -> not (url == resource.url))}, Cmd.none)

        ToggleItemDropmenu resource ->
          let
              newState = if model.itemDropmenu == Just resource then Nothing else Just resource
          in
              ({ model | itemDropmenu = newState }, Cmd.none)

        RemoveResourceFromProject resource ->
          ({ model | projectResources = model.projectResources |> List.filter (\res -> not (res == resource)) }, Cmd.none)

        ToggleItemOptional resource checked ->
          let
              optionalItems =
                model.optionalItems |> (if checked then Set.insert else Set.remove) resource.url
          in
              ({ model | optionalItems = optionalItems }, Cmd.none)

        ChangeAnnotation resource name value ->
          ({ model | annotations = model.annotations |> Dict.insert (resource.url, name) value }, Cmd.none)


        DislikeResult url ->
          ({ model | dislikedResult = Just url }, Cmd.none)


        RevokeDislike ->
          ({ model | dislikedResult = Nothing }, Cmd.none)


        ConfirmDislike _ ->
          ({ model | dislikedResult = Nothing, searchResults = model.searchResults |> List.filter (\r -> model.dislikedResult == Just r.url |> not) }, Cmd.none)


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


        -- AddRelevantTag name ->
        --   ({ model | relevantTags = model.relevantTags |> Set.insert name }, Cmd.none)


        -- RemoveRelevantTag name ->
        --   ({ model | relevantTags = model.relevantTags |> Set.remove name }, Cmd.none)



closeDropmenu : Model -> Model
closeDropmenu model =
  { model | itemDropmenu = Nothing }


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
