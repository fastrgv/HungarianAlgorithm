
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

-- This algorithm was copied on 20sep18 from:
-- https://users.cs.duke.edu/~brd/Teaching/
--			Bio/asmb/current/Handouts/munkres.html
-- and modified to correct some errors.  It has now been tested 
-- on thousands of testcases and seems to be working properly.  
-- Please send any improvements or further corrections back to:
-- <fastrgv@gmail.com>




with text_io;
with munkres;


procedure munktest is

	use text_io;

	d: constant integer := 11;

	use munkres;

	assn:   iatype(1..d);

	x: constant integer := 65534;
	cost:   iatype(1..d*d) := (

 0, 2, 3, 3, x, 4, 5, 5, 6, 6, x,
 2, 0, 3, 1, x, 2, 5, 3, 6, 4, x,
 3, 1, 4, 2, 1, 3, 6, 4, 7, 5, x,
 x, x, 2, 4, x, 5, 6, 6, 7, 7, x,
 x, x, 1, 3, x, 4, 5, 5, 6, 6, x,
 x, x, 3, 1, 0, 2, 5, 3, 6, 4, x,
 x, x, 2, 4, x, 5, 6, 6, 7, 7, x,
 x, x, 3, 1, x, 0, 3, 1, 4, 2, x,
 x, x, 4, 2, 1, 1, 4, 2, 5, 3, x,
 x, x, 8, 8, x, 7, 6, 6, 3, 5, 4,
 x, x, 7, 7, x, 6, 5, 5, 2, 4, 3
	
	);


	j,r,c,total: integer := 0;

	function indx(r,c: integer) return integer is
	begin
		return (r-1)*d+c;
	end indx;

	Ok: boolean;

begin

	munkres.hungarian(cost,assn,Ok);

	for i in 1..d loop
		r:=i;
		c:=assn(i);
		put("row="&integer'image(r));
		put("  matches col="&integer'image(c));
		new_line;
		if c>d or c<1 then
			put_line("col is bogus");
			if Ok then
				put_line("Ok=true ???");
			else
				put_line("Ok=FALSE !!!");
			end if;
			raise program_error; 
		end if;
		total := total + cost( indx(r,c) );
	end loop;
	put_line("Total Cost: "&integer'image(total));

end munktest;

