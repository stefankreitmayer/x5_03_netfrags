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
  | PageBodyStyle
  | HeaderStyle
  | SidebarStyle
  | ResourceStyle
  | ResourceTitleStyle
  | HintStyle
  | ProjectStyle
  | DropmenuStyle
  | EllipsisStyle
  | AnnotationsStyle
  | AnnotationInputStyle
  | ProjectOverviewStyle
  | ProjectTitleStyle
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
    , Style.style PageBodyStyle
      [ Color.background <| Color.rgb 210 210 210
      , Border.all 2
      ]
    , Style.style HeaderStyle
      [ Color.background <| Color.rgb 0 100 180
      , Color.text <| Color.white
      ]
    , Style.style SidebarStyle
      [ Color.background <| Color.rgb 50 50 50
      , Color.text <| Color.white
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
      [ Border.right 2
      ]
    , Style.style DropmenuStyle
      [ Color.background <| Color.white
      , Color.text <| Color.black
      , Color.border <| Color.rgb 200 200 200
      , Border.all 1
      , Shadow.simple
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
    , Style.style ProjectOverviewStyle
      [ Color.background <| Color.rgb 80 80 80
      , Color.text <| Color.rgb 230 230 230
      , Shadow.simple
      ]
    -- , Style.style ProjectTitleStyle
    --   [ Font.size 16
    --   , Font.weight 600
    --   ]
    , Style.style ProjectTitleStyle
      [ Color.text <| Color.rgb 150 150 150
      , Font.size 24
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
      [ Color.text <| Color.rgb 70 70 70
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
    ]


view : Model -> Html Msg
view ({ui} as model) =
  viewport stylesheet <|
  column NoStyle [ height fill ] [ renderPageHeader, renderPageBody model ]


renderPageHeader =
  row HeaderStyle [ padding 10, spacing 20 ]
    [ el NoStyle [] (text "x5gon") ]


renderPageBody model =
  row PageBodyStyle [ height fill ]
    -- [ renderSideBar
    [ renderProject model
    , renderCatalogue model
    ]


-- renderSideBar =
--   column SidebarStyle [ width (px 200), padding 10 ]
--     [ el NoStyle [] (text "[project selector goes here]")
--     ]


renderCatalogue model =
  column NoStyle [ width (percent 45), padding 10, spacing 10 ]
    [ renderSearchTextField
    , renderSearchResults model
    ]


renderSearchTextField =
  -- TODO wrap in search node, see http://package.elm-lang.org/packages/mdgriffith/style-elements/4.2.1/Element
  Input.search NoStyle [ padding 3 ]
    { onChange = ChangeSearchString
    , value = "machine learning introduction"
    , label = Input.labelLeft <| el NoStyle [ padding 3 ] (text "Search for topic:")
    , options = []
    }


renderSearchResults : Model -> Element MyStyles variation Msg
renderSearchResults ({searchResults} as model) =
  searchResults
  |> List.map (renderSearchResult model)
  |> (::) (renderNumberOfSearchResults (List.length searchResults))
  |> (::) renderSearchFilters
  |> column NoStyle [ width fill, spacing 10 ]
  |> List.singleton
  |> column NoStyle [ width fill, height fill, spacing 10, yScrollbar ]


renderSearchFilters =
  [ "Any type", "Any year", "Any age", "Any language", "Any popularity", "Any X5 rating" ]
  |> List.map renderSearchFilter
  |> row NoStyle [ spacing 20 ]

renderSearchFilter name =
  row NoStyle [ spacing 6 ]
    [ el HintStyle [] (text name)
    , decorativeImage NoStyle [ width (px 8), height (px 4) ] { src = "images/icons/triangle_down.svg" }
      |> el NoStyle [ paddingTop 6]
    ]

renderSearchResult model resource =
  let
    addButton =
      if List.member resource model.projectResources then
        el HintStyle [ padding 3 ] (text "Added")
      else
        button NoStyle [ padding 10, onClick (AddResourceToProject resource) ] (text "Add") |> el NoStyle []
    dislikeButton =
      decorativeImage NoStyle [ width (px 25), height (px 25) ] { src = "images/icons/dislike.svg" }
      |> button NoStyle [ width fill, padding 8, onClick (DislikeResult resource.url) ] |> el NoStyle []
    buttons =
      column NoStyle [ spacing 10 ] <|
      if model.dislikedResult == Just resource.url then
        [ addButton ]
      else
        [ addButton, dislikeButton ]
  in
      row NoStyle [ spacing 10 ]
        [ renderSearchResultResource model resource
        , buttons
        ]


renderNumberOfSearchResults : Int -> Element MyStyles variation Msg
renderNumberOfSearchResults n =
  let
      str =
        case n of
          0 -> "No results"
          1 -> "1 result"
          _ -> (toString n) ++ " results"
  in
      el HintStyle [] (text str)


renderProject model =
  column ProjectStyle [ width (percent 55) ]
    [ renderProjectOverview model
    , column NoStyle [ height fill, padding 10, spacing 10 ]
        [ renderItems model
        ]
    ]


renderItems : Model -> Element MyStyles variation Msg
renderItems model =
  case model.projectResources of
    [] ->
      el HintStyle [ height fill, paddingTop 10 ] (text "To build your project, search for a topic and start adding items.")

    resources ->
      resources
      |> List.map (renderItem model)
      |> Keyed.column NoStyle [ width fill, height fill, spacing 10 ]
      |> List.singleton
      |> column NoStyle [ width fill, height fill, spacing 10, yScrollbar ]


renderProjectOverview : Model -> Element MyStyles variation Msg
renderProjectOverview model =
  column ProjectOverviewStyle [ padding 10, spacing 5 ]
    [ row NoStyle []
      [ h2 ProjectTitleStyle [] (text "Computational Thinking for Age 9")
      , decorativeImage EllipsisStyle [ width (px 20) ] { src = "images/icons/ellipsis_white.png" } |> el NoStyle [ alignRight ] |> el NoStyle [ width fill ]
      ]
    , renderTotalWorkload model
    , renderModalityDistribution model
    -- , h4 H4Style [] (text "Relevant tags")
    -- , renderRelevantTags model
    -- , h4 H4Style [] (text "Suggested tags (click to add)")
    -- , renderSuggestedTags model
    ]

renderTotalWorkload model =
  let
      hours =
        model.projectResources
        |> List.map (workloadInHours model)
        |> List.sum
        |> toString
  in
     "Total workload: " ++ hours ++ " hours" |> text |> el NoStyle []


renderModalityDistribution model =
  let
      resources = model.projectResources
      count fn =
        model.projectResources
        |> List.map (\resource -> if fn resource then 1 else 0)
        |> List.sum
      modality label fn =
        label ++ ": " ++ (count fn |> toString)
        |> text
        |> el (if (count fn > 0) then ModalityStylePresent else ModalityStyleNotPresent) []
  in
      column ModalityDistributionStyle [ spacing 3, padding 10 ]
        [ modality "To watch" (\{tags} -> (tags |> Set.member "video") || (tags |> Set.member "course"))
        , modality "To listen" (\{tags} -> (tags |> Set.member "podcast") || (tags |> Set.member "audiobook"))
        , modality "To read" (\{tags} -> (tags |> Set.member "article") || (tags |> Set.member "book"))
        , modality "To practice" (\{tags} -> (tags |> Set.member "course") || (tags |> Set.member "quiz"))
        , modality "To socialise" (\{tags} -> (tags |> Set.member "meetup group"))
        , modality "To attend" (\{tags} -> (tags |> Set.member "event"))
        , modality "To visit" (\{tags} -> (tags |> Set.member "meetup group"))
        ]


-- renderRelevantTags model =
--   model.relevantTags
--   |> Set.toList
--   |> List.map renderRelevantTag
--   |> Keyed.wrappedRow NoStyle [ spacing 5 ]


-- renderSuggestedTags model =
--   let
--       tags =
--         model.searchResults
--         |> List.foldr (\resource tags -> tags |> Set.union resource.tags) Set.empty
--   in
--       Set.diff tags model.relevantTags
--       |> Set.toList
--       |> List.map renderSuggestedTag
--       |> Keyed.wrappedRow NoStyle [ spacing 5 ]


renderSearchResultResource model resource =
  row ResourceStyle [ padding 10, spacing 10, width fill ]
    (if model.dislikedResult == Just resource.url then
      [ renderDislikeMenu ]
    else
      [ decorativeImage NoStyle [ width (px 150), maxHeight (px 80) ] { src = "images/resource_covers/" ++ resource.coverImageStub ++ ".png" }
      , column NoStyle [ spacing 3, width fill ]
        [ paragraph ResourceTitleStyle [] [ text resource.title ]
        , el HintStyle [ width fill ] (text resource.date)
        , renderTagList resource
        , renderSearchResultDetails model resource
        ]
      ]
    )


-- returns a Keyed element
renderItem : Model -> Resource -> (String, Element MyStyles variation Msg)
renderItem model resource =
  let
      element =
        column ResourceStyle [ padding 10, spacing 10, width fill ]
          [ row NoStyle [ spacing 10 ]
              [ decorativeImage NoStyle [ width (px 150), maxHeight (px 80) ] { src = "images/resource_covers/" ++ resource.coverImageStub ++ ".png" }
              , column NoStyle [ spacing 3, width fill ]
                [ paragraph ResourceTitleStyle [] [ text resource.title ]
                , el HintStyle [ width fill ] (text resource.date)
                , renderTagList resource
                , renderItemDetails model resource
                ]
              , column NoStyle [ spacing 10 ]
                [ decorativeImage EllipsisStyle [ width (px 20) ] { src = "images/icons/ellipsis.png" }
                  |> button NoStyle [ onClick (ToggleItemDropmenu resource), alignRight ]
                  |> renderItemDropmenu model resource
                  |> el NoStyle []
                ]
              ]
            , renderItemAnnotations model resource
          ]
  in
      (resource.url, element)


renderTagList resource =
  resource.tags
  |> Set.toList
  |> List.map renderTag
  |> row NoStyle [ spacing 5 ]


renderTag str =
  el TagStyle [ paddingXY 2 1 ] (text str)


-- renderRelevantTag str =
--   row TagStyle [ paddingXY 2 1, spacing 3 ]
--   [ text str
--   -- alternatively, use "✖"
--   , text "×" |> button CloseButtonStyle [ onClick (RemoveRelevantTag str) ]
--   ]
--   |> (,) str


-- renderSuggestedTag str =
--   button TagStyle [ paddingXY 2 1, onClick (AddRelevantTag str) ] (text str)
--   |> (,) str


renderSearchResultDetails model resource =
  let
      (collapseButton, details) =
        if List.member resource.url model.expandedSearchResults then
          ( button NoStyle [ paddingXY 4 1, onClick (HideDetails resource), alignRight ] (text "Less")
          , [ renderRatings resource
            , paragraph UrlStyle [] [ text resource.url ] |> newTab resource.url
            ]
          )
        else
          ( button NoStyle [ paddingXY 4 1, onClick (ShowDetails resource), alignRight ] (text "More")
          , [])
  in
      column NoStyle [ spacing 3 ]
        (collapseButton :: details)


renderItemDetails model resource =
  column NoStyle [ spacing 3 ]
    [ paragraph NoStyle [] [ text resource.url ] |> newTab resource.url ]


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


renderItemDropmenu model resource button =
  if model.itemDropmenu == Just resource then
    button
    |> below [ el DropmenuStyle [ alignRight, paddingXY 10 5, onClick (RemoveResourceFromProject resource) ] (text "Remove") ]
  else
    button


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
