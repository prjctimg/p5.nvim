The lua/gist.lua module looks unnecessarily verbose with all those error checks and unneeded notifications:

Make the path traversal condition check be a single expression of chained `and/or` statements.
Remove notifications for minor internal errors that the user should normally never deal with.
Simplify the logic for creating unique paths when working with the gists.
