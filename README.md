# project_dom_tree
Like leaves on the wind

### Sean Luckett

### No instructions for use -- not completely done

I've gotten all I need to out of this assignment. You could figure it out, and do some stuff with it, but
it basically involves creating a string/stream of html and passing it to an instance of DomParser. Then you can pass
DomParser#root_node to NodeRenderer and TreeSearcher as the "tree."

###Things to complete should it ever be necessary:
* Have TreeSearcher able to search tree for DOM text elements
* Find out if the assignment really wants to search by attribute 'name,' given the parser page says don't worry about name
or source attributes

###Things to improve:
* TreeSearcher really should be using other objects to search by type
    * search objects for each type. these can handle the children, parent, and search_by
    * TreeSearcher then creates the type of searcher in its case statements on search type
    * TreeSearcher can fire off a single search polymorphically
    