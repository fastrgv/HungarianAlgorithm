
# Hungarian Algorithm Implementation in Ada

* Although written in Ada, this code could be considered an algorithmic description.


# Problem Description
The Hungarian algorithm can be described as optimally solving a workers versus jobs assignment problem that minimizes total cost.  This implementation assumes a square cost matrix, i.e. the number of jobs equals the number of workers to do them.

A simple example, whose solution is almost immediately obvious follows.

       clean   sweep     wash
Albert  $2       $3       $3

Betty   $3       $2       $3

Carol   $3       $3       $2

The Hungarian method, when applied to the above table would give the minimum cost of $6, by assigning Albert to clean, Betty to sweep, and Carol to wash.


# Source
This algorithm was copied on 20sep18 from:
https://users.cs.duke.edu/~brd/Teaching/
			Bio/asmb/current/Handouts/munkres.html
and modified to correct some errors.  

It is currently being used as an integral part of a sokoban solver that is being developed.  Thusly, it has now been tested on thousands of actual testcases and seems to be working properly.  

Please send any improvements or further corrections to:
<fastrgv@gmail.com>


## Note
I have recently searched for a correct version online, but found none.  I found several that "almost" worked but were all flawed, mainly, I think, due to the age and nature of the original algorithmic description.  It was invented before computers were widely available, so was described in terms of hand computations, parts of which are quite confusing, possibly due to language ambiguities. [Kuhn, 1955]


## Legal Mumbo Jumbo:

 Copyright (C) 2018  <fastrgv@gmail.com>

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may read the full text of the GNU General Public License
 at <http://www.gnu.org/licenses/>.

