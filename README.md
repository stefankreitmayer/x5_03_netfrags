# x5gon prototype 02

User interface sketch for X5gon project

## Use scenario

Same as [prototype 01](https://github.com/stefankreitmayer/x5_01_metacourse)

## Data

Similar to [prototype 01](https://github.com/stefankreitmayer/x5_01_metacourse)

## Build instructions

Same as [prototype 01](https://github.com/stefankreitmayer/x5_01_metacourse)

## Thoughts about interface design

Iterating on [prototype 01](https://github.com/stefankreitmayer/x5_01_metacourse)

Moving away from the Google-search clone, towards a more Amazon-like design.

Goals:
1. As a learner, when I see a list of resources, in order to recognise resources easily, I want to see a picture for each resource.
2. As a learner, when I see a list of resources, in order to evaluate each resource, I want to see how each resource was rated or classified by other users.
3. As a learner, when I select a resource, in order to keep browsing, I want to stay on the platform.
4. As a learner, when I select a resource, in order to keep my resources organised, I want to put the resource into one of several categories (could be called "trays" or "baskets" or "boxes"...) such as yes/no/maybe.
5. As a learner, in order to stay organised, I want to see an overview of all my baskets and their contents.
6. As a learner, in order to stay organised, I want to move a resource from one basket to another.
7. As a learner, in order to stay organised, I want to remove a resource from a basket.
8. As a learner, when I'm done with a resource, in order to stay organised and mark the resource as good, I want to put the resource in the "worked really well for me" basket.

Once people start using the platform, I suppose we might get useful data out of tracking how learners move their resources from one basket to another over the course of their learning. Presumably, we could use these data to infer recommendability (perhaps within similar learner types) and perhaps visualise them in a way that helps learners browse more efficiently (caveat: feedback loop).

## Preliminary insights

Unlike Amazon, most OERs don't have a (good) title image. MOOCs usually do (or sometimes they have a video trailer instead, e.g. [this one](https://www.udemy.com/machinelearning/) ), but blog articles, ebooks, etc usually just have title and author. Blog articles often have a generic background (stock photo, e.g. mountains or sky) that has nothing to do with the topic. I have seen pdf books where the cover is just a blank page with the title. Not very appealing to a browsing audience. I wouldn't be surprised if this had an effect on the amount of attention certain resources get from learners. I don't have a perfect solution to this problem.  Nevertheless I think that pictures are needed. We could potentially auto-generate them, if needed, using e.g. random colours, the resource title, the logo of the domain, an automatic screen grab (if license allows), etc. Or perhaps we could use [Opengraph](http://ogp.me/). The latter might be a good option because it puts the resource provider in charge of how their product appears on our site.

Although creating images manually obviously isn't an option, for the purpose of this prototype I did it anyway, using screenshots, in order to get a feel for how bad the situation is, what the page could look like if every resource had an image, and to get ideas for automated solutions.
