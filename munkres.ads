

--
-- Copyright (C) 2018  <fastrgv@gmail.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You may read the full text of the GNU General Public License
-- at <http://www.gnu.org/licenses/>.
--


-- This algorithm was copied on 20sep18 from:
-- https://users.cs.duke.edu/~brd/Teaching/
--			Bio/asmb/current/Handouts/munkres.html
-- and modified to correct some errors.  It has now been tested 
-- on thousands of testcases and seems to be working properly.  
-- Please send any improvements or further corrections back to:
-- <fastrgv@gmail.com>



package munkres is

	type iatype is array(integer range <>) of integer;

-- this calls an O(n**3) implementation of the
-- Hungarian matching algorithm.  The cost matrix is
-- assumed square, and the [minimal] total cost is
-- [sum-over-i] : cost( indx(i,assign(i)) )
	procedure hungarian( 
		cost: iatype; 
		assn: in out iatype;
		ok: out boolean);

end munkres; --package

