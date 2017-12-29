module View exposing (view)

import Html exposing (Html)
import Color exposing (..)
import Set exposing (Set)
import Dict exposing (Dict)
-- import Debug exposing (log)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onCheck, onMouseOver, onMouseOut)
import Element.Input as Input
import Element.Keyed as Keyed

import Style
import Style.Color as Color
import Style.Font as Font
import Style.Border as Border
import Style.Shadow as Shadow

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Resource exposing (..)
import Model.FakeData exposing (computeFakeRating, computeFakeNumberOfRatings, commonRatingMetrics)

import Msg exposing (..)


type MyStyles
  = NoStyle
  | DebugStyle
  | InvisibleStyle
  | ThinvisibleStyle
  | HeaderStyle
  | ResourceStyle
  | ResourceTitleStyle
  | HintStyle
  | ProjectStyle
  | EllipsisStyle
  | AnnotationsStyle
  | AnnotationInputStyle
  | PlaylistStyle
  | PlaylistHeadingStyle
  | H4Style
  | TagStyle
  | AddButtonCircleStyle
  | CloseButtonStyle
  | ModalityDistributionStyle
  | ModalityStylePresent
  | ModalityStyleNotPresent
  | DislikeReasonStyle
  | StarStyle
  | StarHoverStyle
  | UrlStyle
  | ItemInspectorStyle
  | ItemInspectorImageStyle


stylesheet =
  Style.styleSheet
    [ Style.style NoStyle []
    , Style.style DebugStyle
      [ Color.background <| Color.rgb 210 210 210
      , Border.all 2
      ]
    , Style.style InvisibleStyle
      [ Style.opacity 0
      ]
    , Style.style ThinvisibleStyle
      [ Style.opacity 0.2
      ]
    , Style.style HeaderStyle
      [ Color.text <| Color.rgb 0 100 180
      , Color.background <| Color.white
      , Color.border <| Color.rgb 100 100 100
      , Font.weight 900
      , Border.bottom 1
      ]
    , Style.style ResourceStyle
      [ Color.background <| Color.white
      , Color.text <| Color.black
      , Shadow.simple
      ]
    , Style.style ResourceTitleStyle
      [ Color.text <| Color.rgb 50 50 50
      , Font.size 16
      , Font.weight 600
      ]
    , Style.style HintStyle
      [ Color.text <| Color.rgb 120 120 120
      ]
    , Style.style ProjectStyle
      [ Color.background <| Color.rgb 230 230 230
      ]
    , Style.style EllipsisStyle
      [ Style.opacity 0.66
      ]
    , Style.style AnnotationsStyle
      [ Border.top 1
      , Border.left 1
      , Color.border <| Color.rgb 200 200 200
      , Color.background <| Color.rgb 230 230 230
      ]
    , Style.style AnnotationInputStyle
      [ Border.bottom 1
      , Color.border <| Color.rgb 200 200 200
      , Shadow.simple
      ]
    , Style.style PlaylistStyle
      [
      ]
    , Style.style PlaylistHeadingStyle
      [ Color.text <| Color.rgb 40 40 40
      , Font.size 18
      ]
    , Style.style TagStyle
      [ Border.all 1
      , Border.rounded 2
      , Color.border <| Color.rgb 200 200 200
      , Font.size 13
      ]
    , Style.style H4Style
      [ Font.weight 600
      ]
    , Style.style AddButtonCircleStyle
      [ Color.border <| Color.rgb 100 100 100
      , Border.all 1
      ]
    , Style.style CloseButtonStyle
      [ Color.text <| Color.rgb 100 100 100
      , Font.weight 100
      ]
    , Style.style ModalityDistributionStyle
      [ Color.background <| Color.rgb 50 50 50
      ]
    , Style.style ModalityStylePresent
      [ Color.text <| Color.rgb 80 180 80
      ]
    , Style.style ModalityStyleNotPresent
      [ Color.text <| Color.rgb 180 180 180
      ]
    , Style.style DislikeReasonStyle
      [ Color.border <| Color.rgb 100 100 100
      , Border.all 1
      ]
    , Style.style StarStyle
      [ Style.opacity 0.85
      ]
    , Style.style StarHoverStyle
      [ Style.opacity 0.5
      ]
    , Style.style UrlStyle
      [ Color.text <| Color.rgb 30 80 200
      ]
    , Style.style ItemInspectorStyle
      [ Color.text <| Color.rgb 30 80 200
      , Color.border <| Color.rgb 100 100 100
      , Color.background <| Color.rgb 255 255 255
      , Border.all 1
      , Shadow.simple
      ]
    , Style.style ItemInspectorImageStyle
      [ Color.border <| Color.rgb 100 100 100
      , Border.all 1
      ]
    ]


view : Model -> Html Msg
view ({ui} as model) =
  viewport stylesheet <|
  column NoStyle [ height fill ] [ renderPageHeader model, renderPageBody model ]


renderPageHeader model =
  row HeaderStyle [ padding 10, spacing 20 ]
    [ el NoStyle [] (text "x5gon") ]
  |> below [ renderItemInspector model ]


renderPageBody model =
  [ renderProject model ]
  |> column NoStyle [ width fill, height fill, spacing 10, yScrollbar ]


renderProject model =
  model.playlists
  |> List.map (renderPlaylist model)
  |> column ProjectStyle [ width fill, padding 10, spacing 10 ]


renderPlaylist : Model -> Playlist -> Element MyStyles variation Msg
renderPlaylist model ({heading, items} as playlist) =
  column PlaylistStyle [ paddingBottom 10 ]
  [ el PlaylistHeadingStyle [] (text heading)
  , items
    |> List.map (renderPlaylistItem model playlist)
    |> Keyed.row NoStyle [ width fill, height fill, spacing 10 ]
    |> List.singleton
    |> row NoStyle [ width fill, padding 10, spacing 10, xScrollbar ]
  ]


-- returns a Keyed element
renderPlaylistItem : Model -> Playlist -> Resource -> (String, Element MyStyles variation Msg)
renderPlaylistItem model playlist resource =
  let
      image =
        decorativeImage NoStyle [ width (px 200), maxHeight (px 106) ] { src = "images/resource_covers/" ++ resource.coverImageStub ++ ".png" }
        |> el NoStyle [ minHeight (px 106) ]
      titleAndDate =
        column NoStyle [ spacing 3, width fill ]
          [ paragraph ResourceTitleStyle [] [ text resource.title ]
          , el HintStyle [ width fill ] (text resource.date)
          -- , renderTagList resource
          ]
        -- , column NoStyle [ spacing 10 ]
        --   [ decorativeImage EllipsisStyle [ width (px 20) ] { src = "images/icons/ellipsis.png" }
        --     |> button NoStyle [ onClick (ToggleItemDropmenu resource), alignRight ]
        --     |> renderItemDropmenu model resource
        --     |> el NoStyle []
        --   ]
      children =
        [ image, titleAndDate ]
      element =
        children
        |> column NoStyle [ padding 10, spacing 10, maxWidth (px 220) ]
        |> button ResourceStyle [ onClick (InspectItem resource playlist) ]
  in
      (resource.url, element)


renderItemInspector model =
  case model.selectedItem of
    Nothing ->
      (text "")
      |> el ItemInspectorStyle [ hidden ]

    Just (resource, _) ->
      let
          item =
            renderInspectedItem model resource
            |> List.singleton
            |> Keyed.row NoStyle [ spacing 10 ]
            |> el NoStyle []
          closeButton =
            button CloseButtonStyle [ onClick CloseItemInspector, alignLeft, padding 10 ] (text "×")
      in
          column ItemInspectorStyle [ width (px inspectorWidth), moveRight (windowWidth - inspectorWidth + 2) ] [ closeButton, item ]


-- returns a Keyed element
renderInspectedItem : Model -> Resource -> (String, Element MyStyles variation Msg)
renderInspectedItem model resource =
  let
      image =
        decorativeImage ItemInspectorImageStyle [ width (px 400), maxHeight (px 212) ] { src = "images/resource_covers/" ++ resource.coverImageStub ++ ".png" }
        |> el NoStyle [ minHeight (px 212) ]
      content =
        column NoStyle [ spacing 3, width fill ]
          [ h3 ResourceTitleStyle [] ( text resource.title )
          , image
          , el HintStyle [ width fill ] (text resource.date)
          , renderItemDetails model resource
          ]
      element =
        [ content ]
        |> column NoStyle [ paddingLeft 10, paddingRight 10, paddingBottom 10, spacing 10, maxWidth (px (inspectorWidth - 20)) ]
  in
      (resource.url, element)


renderTagList resource =
  resource.tags
  |> Set.toList
  |> List.map renderTag
  |> row NoStyle [ spacing 5 ]


renderTag str =
  el TagStyle [ paddingXY 2 1 ] (text str)


renderItemDetails model resource =
  [ paragraph NoStyle [] [ text resource.url ] |> newTab resource.url ]
  |> column NoStyle [ spacing 3 ]


renderItemAnnotations model resource =
  let
      renderAnnotationInput name =
        Input.text AnnotationInputStyle (if name == attrTextWorkload then [ width (px 40) ] else [])
          { onChange = ChangeAnnotation resource name
          , value = getAnnotation model resource name
          , label = Input.labelLeft <| el NoStyle [] (text name)
          , options = []
          }
      renderAnnotation name =
        if name == attrTextWorkload then
          row NoStyle []
          [ renderAnnotationInput name
          , Input.checkbox NoStyle [ alignRight ]
              { onChange = ToggleItemOptional resource
              , checked = isItemOptional model resource
              , label = el NoStyle [] (text "optional")
              , options = []
              }
          ]
        else
          renderAnnotationInput name
      ratingEditor =
        renderRatingEditor model resource
  in
      column AnnotationsStyle [ spacing 3, padding 5 ]
        ((itemAnnotation |> List.map renderAnnotation) ++ [ ratingEditor ])


renderRatingEditor model resource =
  let
      button =
        row NoStyle [ spacing 6 ]
          [ el NoStyle [] (text "My Ratings")
          , decorativeImage NoStyle [ width (px 8), height (px 4) ] { src = "images/icons/triangle_down.svg" }
            |> el NoStyle [ paddingTop 6]
          ]
      existinMetrics =
        commonRatingMetrics
        |> List.map (renderEditableRating model resource)
        |> column NoStyle []
  in
      column NoStyle []
        [ button
        , existinMetrics ]


renderEditableRating model resource metric =
  let
      rateable = (resource.url, metric)
  in
      row NoStyle [ spacing 5 ]
        [ metric |> text |> el NoStyle [ alignRight ] |> el NoStyle [ width (percent 50)]
        , renderStarGraphEditable model rateable ThinvisibleStyle (model.enteredRatings |> Dict.get rateable |> Maybe.withDefault 0)
        ]


renderRatings resource =
  commonRatingMetrics
  |> List.map (renderRating resource)
  |> column NoStyle []


renderRating resource metric =
  row NoStyle [ spacing 5 ]
    [ renderStarGraphStatic InvisibleStyle (computeFakeRating resource metric)
    , metric |> text |> el NoStyle [ width fill ]
    , (computeFakeNumberOfRatings resource metric |> toString) ++ " users" |> text |> el NoStyle []
    ]


renderStarGraphStatic hiddenStyle n =
  List.range 1 5
  |> List.map (renderStarStatic n)
  |> row NoStyle []


renderStarGraphEditable model rateable hiddenStyle n =
  List.range 1 5
  |> List.map (renderStarEditable model rateable n)
  |> row NoStyle []


renderStarStatic nStarsOfResource starIndex =
  drawStar (if starIndex <= nStarsOfResource then StarStyle else InvisibleStyle) []


renderStarEditable model rateable nStarsOfResource starIndex =
  let
      isHovering =
        case model.hoveringRating of
          Nothing ->
            False

          Just (r, nStars) ->
            r == rateable && starIndex <= nStars
      style =
        if isHovering then
          StarHoverStyle
        else if starIndex <= nStarsOfResource then
          StarStyle
        else
          ThinvisibleStyle
  in
      drawStar style [ onMouseOver (HoverRating (rateable, starIndex)), onMouseOut UnHoverRating, onClick EnterRating ]


drawStar style events =
  decorativeImage style [ width (px 12), height (px 12) ] { src = "images/icons/star2.svg" }
  |> el NoStyle (events ++ [ paddingXY 0 2 ])


renderDislikeMenu =
  column NoStyle [ spacing 10 ]
    [ paragraph ResourceTitleStyle [] [ text "Don't like this result? Tell us why - thanks!" ]
    , [ "Not an OER", "Not trustworthy", "Low quality", "Doesn't fit my needs", "Doesn't fit my preferences", "Other reason" ]
      |> List.map renderDislikeReasonOption
      |> column NoStyle [ spacing 5 ]
    , el NoStyle [] (text "Never mind, it's fine")
      |> button HintStyle [ onClick RevokeDislike ]
    ]


renderDislikeReasonOption reason =
  el NoStyle [] (text reason)
  |> button DislikeReasonStyle [ paddingXY 5 2, onClick (ConfirmDislike reason) ]


inspectorWidth = 640


windowWidth = 1440
