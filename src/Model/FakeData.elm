module Model.FakeData exposing (..)

import Set exposing (Set)
import Dict exposing (Dict)

import Model.Resource exposing (..)

exampleResources : List Resource
exampleResources =
  [ Resource "Introduction to Machine Learning - Alex Smola" "http://alex.smola.org/drafts/thebook.pdf" "smola" "" (Set.fromList [ "book", "academic" ]) (Dict.singleton attrTextWorkload "10")
  , Resource "Friendly Introduction to Machine Learning - YouTube" "https://www.youtube.com/watch?v=IpGxLWOIZy4" "picodegree" "2016" (Set.fromList [ "video", "course" ]) (Dict.singleton attrTextWorkload "0.5")
  , Resource "Machine Learning Course | Udacity" "https://www.udacity.com/course/intro-to-machine-learning--ud120" "udacity_data" "" (Set.fromList [ "course" ]) (Dict.singleton attrTextWorkload "30")
  , Resource "Machine Learning is Fun! – Adam Geitgey – Medium" "https://medium.com/@ageitgey/machine-learning-is-fun-80ea3ec3c471" "ageitgey" "2014" (Set.fromList [ "article", "entertaining" ]) (Dict.singleton attrTextWorkload "0.3")
  , Resource "San Diego Artificial Intelligence & Deep Learning" "https://www.meetup.com/San-Diego-AI-Deep-Learning/" "meetup_sandiego" "" (Set.fromList [ "meetup group", "san diego" ]) (Dict.singleton attrTextWorkload "2")
  , Resource "London Machine Learning Meetup" "https://www.meetup.com/London-Machine-Learning-Meetup" "meetup_london" "" (Set.fromList [ "meetup group", "london", "11 december" ]) (Dict.singleton attrTextWorkload "2")
  , Resource "Introduction to Machine Learning" "https://ai.stanford.edu/~nilsson/mlbook.html" "nilsson" "" (Set.fromList [ "book", "downloadable" ]) (Dict.singleton attrTextWorkload "5")
  , Resource "Introduction to Machine Learning - Online Course - DataCamp" "https://www.datacamp.com/courses/introduction-to-machine-learning-with-r" "datacamp" "" (Set.fromList [ "course", "free", "r" ]) (Dict.singleton attrTextWorkload "20")
  , Resource "Tokyo Machine Learning Society" "https://www.meetup.com/tokyomachinelearning/" "meetup_tokyo" "" (Set.fromList [ "meetup group", "tokyo" ]) (Dict.singleton attrTextWorkload "2")
  , Resource "An Introduction to Machine Learning Algorithms - DataScience.com" "https://www.datascience.com/blog/introduction-to-machine-learning-algorithms" "datascience" "2017" (Set.fromList [ "article" ]) (Dict.singleton attrTextWorkload "0.2")
  , Resource "A Gentle Introduction to Machine Learning - The New Stack" "https://thenewstack.io/gentle-introduction-machine-learning/" "thenewstack" "2017" (Set.fromList [ "article" ]) (Dict.singleton attrTextWorkload "1")
  , Resource "An Introduction to Machine Learning Theory and Its Applications - Toptal" "https://www.toptal.com/machine-learning/machine-learning-theory-an-introductory-primer" "toptal" "" (Set.fromList [ "article" ]) (Dict.singleton attrTextWorkload "1")
  , Resource "Machine Learning | Coursera" "https://www.coursera.org/learn/machine-learning" "ng" "" (Set.fromList [ "course", "andrew ng", "exercise" ]) (Dict.singleton attrTextWorkload "30")
  , Resource "Introduction To Machine Learning Courses | Coursera" "https://www.coursera.org/specializations/machine-learning" "specialization" "" (Set.fromList [ "course", "free trial", "exercise" ]) (Dict.singleton attrTextWorkload "30")
  , Resource "Machine Learning Foundations: A Case Study Approach" "https://www.coursera.org/learn/ml-foundations" "foundations" "" (Set.fromList [ "course", "free trial" ]) (Dict.singleton attrTextWorkload "25")
  , Resource "Introduction to Machine Learning - SlideShare" "https://www.slideshare.net/rahuldausa/introduction-to-machine-learning-38791937" "slideshare" "2014" (Set.fromList [ "presentation", "downloadable" ]) (Dict.singleton attrTextWorkload "1")
  , Resource "An introduction to machine learning today - Opensource.com" "https://opensource.com/article/17/9/introduction-machine-learning" "opensource" "2017" (Set.fromList [ "article" ]) (Dict.singleton attrTextWorkload "0.5")
  , Resource "Introduction To Machine Learning, Spring 2016 - people.csail.mit.edu" "https://people.csail.mit.edu/dsontag/courses/ml16/" "people" "" (Set.fromList [ "university course" ]) (Dict.singleton attrTextWorkload "40")
  , Resource "A visual introduction to machine learning" "http://www.r2d3.us/visual-intro-to-machine-learning-part-1/" "a_visual" "2015" (Set.fromList [ "article" ]) (Dict.singleton attrTextWorkload "1")
  , Resource "Introduction to Machine Learning for Developers - Algorithmia Blog" "https://blog.algorithmia.com/introduction-machine-learning-developers/" "developers" "" (Set.fromList [ "article" ]) (Dict.singleton attrTextWorkload "1")
  , Resource "A Non-Technical Introduction to Machine Learning – SafeGraph" "https://blog.safegraph.com/a-non-technical-introduction-to-machine-learning-b49fce202ae8?gi=ccaf0749079" "safegraph" "2017" (Set.fromList [ "article" ]) (Dict.singleton attrTextWorkload "0.5")
  , Resource "A Brief Introduction to Machine Learning for Engineers" "https://arxiv.org/abs/1709.02840" "brief" "2017" (Set.fromList [ "book" ]) (Dict.singleton attrTextWorkload "15")
  , Resource "Intro To Machine Learning - Python & R In Data Science" "https://www.udemy.com/machinelearning" "python" "" (Set.fromList [ "course", "r", "python" ]) (Dict.singleton attrTextWorkload "30")
  , Resource "11. Introduction to Machine Learning" "https://www.youtube.com/watch?v=h0e2HAPTGF4" "yout1" "" (Set.fromList [ "mit" ]) (Dict.singleton attrTextWorkload "1")
  , Resource "TensorFlow and Deep Learning without a PhD, Part 1 (Google Cloud Next '17)" "https://www.youtube.com/watch?v=u4alGiomYP4" "yout2" "" (Set.fromList [ "google" ]) (Dict.singleton attrTextWorkload "1")
  , Resource "Introduction to Data Analysis using Machine Learning" "https://www.youtube.com/watch?v=U4IYsLgNgoY" "yout3" "" (Set.fromList [ "" ]) (Dict.singleton attrTextWorkload "1")
  , Resource "Hello World - Machine Learning Recipes #1" "https://www.youtube.com/watch?v=cKxRvEZd3Mw" "yout4" "" (Set.fromList [ "" ]) (Dict.singleton attrTextWorkload "0.1")
  , Resource "Introduction - Learn Python for Data Science #1" "https://www.youtube.com/watch?v=T5pRlIbr6gg" "siraj" "" (Set.fromList [ "" ]) (Dict.singleton attrTextWorkload "0.1")
  , Resource "Machine Learning Guide" "http://ocdevel.com/podcasts/machine-learning" "ocdevel" "" (Set.fromList [ "podcast", "entertaining", "downloadable", "audio only" ]) (Dict.singleton attrTextWorkload "25") ]


computeFakeRating resource metric =
  ((resource.url |> String.length) + (metric |> String.length)) % 5 + 1


computeFakeNumberOfRatings resource metric =
  let
      a = (metric |> String.length) * 5 % 6
      b = (metric |> String.length) % 7
      c = (resource.url |> String.length) % 3
      d = (resource.url |> String.length) % 7
  in
      (a * 2 + b * 3 + c*5 + d^2) % 150


commonRatingMetrics =
  [ "accurate", "up to date", "accessible", "entertaining", "child friendly", "interactive", "well reasoned", "well explained", "clear examples", "hilarious", "attractive", "addictive", "engaging", "math heavy", "correct grammar", "conversational" ]
