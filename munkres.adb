
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


package body munkres is



--indexes range from 1..k*k and 1..k:
procedure hungarian( 
	cost: iatype;  --linearized 2D cost array
	assn: in out iatype; --permutation array
	ok: out boolean
	) is


	use text_io;

	n : constant integer := assn'last;                                  
	-- num rows/columns (square)

	type matrix is  array(1..n,1..n) of integer;
	c0, C : matrix;
	-- cost matrix [C will be overwritten]


	path: array(1..2*n,1..2) of integer:=(others=>(others=>0));

	M :  array(1..n,1..n) of integer := (others=>(others=>0));
	-- a mask matrix to indicate primed (= 2) 
	-- and starred (=1) zeros in C

	C_cov,R_cov :  array(1..n) of integer:=(others=>0);
	-- maintains record of which row/columns are covered. 
	-- covered = 1, non-covered = 0

	j, 
	uncMin, --minimum of all Uncovered elements
	z0_r, z0_c, --indices of primed NON-covered zero
	tot, stepnum : integer := 0;

	done : boolean;




	procedure myassert( 
		condition : boolean;  
		flag: integer:=0;
		msg: string := ""
		) is
	begin
	  if condition=false then
			put("ASSERTION Failed!  ");
			if flag /= 0 then
				put( "@ " & integer'image(flag) &" : " );
			end if;
			put_line(msg);
			new_line;
			raise program_error;
	  end if;
	end myassert;





---------------------------------------------------------------------
 procedure step1(step : in out integer) is
    minval : integer;
  begin

	--subtract row minimum:
    for row in 1..n loop
      minval:=C(row,1);
      for col in 2..n loop
        if minval>C(row,col) then
          minval:=C(row,col);
        end if;
      end loop;
      for col in 1..n loop
        C(row,col):=C(row,col)-minval;
      end loop;
    end loop;

	--subtract column minimum:
    for col in 1..n loop
      minval:=C(1,col);
      for row in 2..n loop
        if minval>C(row,col) then
          minval:=C(row,col);
        end if;
      end loop;
      for row in 1..n loop
        C(row,col):=C(row,col)-minval;
      end loop;
    end loop;

	 -- Now, every row & column has a zero and
	 -- this problem is equivalent to original.

    step:=2;

  end step1;



---------------------------------------------------------------------
  procedure step2(step: in out integer) is
  begin

	--temporarily abuse *_cov() to indicate presence
	--of starred zero in a given row, col:
    for i in 1..n loop
      for j in 1..n loop
        if C(i,j)=0 and C_cov(j)=0 and R_cov(i)=0 then
          M(i,j):=1; --star this zero
          C_cov(j):=1;
          R_cov(i):=1;
        end if;
      end loop;
    end loop;

	--reinitialize cover arrays:
    for i in 1..n loop
      C_cov(i):=0;
      R_cov(i):=0;
    end loop;

    step:=3;

  end step2;


---------------------------------------------------------------------
procedure step3(step : in out integer) is
    count : integer;
begin


    for i in 1..n loop
      for j in 1..n loop
        if M(i,j)=1 then --this zero is starred
          C_cov(j):=1;   --so cover its column
        end if;
      end loop;
    end loop;
    count:=0;
    for j in 1..n loop
      count:=count + C_cov(j);
    end loop;
    if count>=n then
      step:=7;
    else
      step:=4;
    end if;

end step3; 



---------------------------------------------------------------------
 procedure step4(step : in out integer) is
 	 col2,
    row,col  : integer;
    done     : boolean;

-- added 23oct18 fastrgv
    function found_star_in_row(
	 	row : in integer;
		col : out integer) return boolean is
      i,j : integer;
      foundstar: boolean:=false;
    begin
      col:=0;
      i:=row;
		foundstar:=false;

        j:=1;
		  columnloop:
        loop
         --if C(i,j)=0 and M(i,j)=1 then
         if M(i,j)=1 then --only zeros are starred!
				foundstar:=true;
				col:=j;
				exit columnloop;
         end if;
          j:=j+1;
         exit when j>n;
        end loop columnloop;

		return foundstar;

    end found_star_in_row;



    procedure find_uncovered_zero(row,col : out integer) is
      i,j : integer;
    begin
      row:=0;
      col:=0;
      i:=1;

		iloop: --search all rows
      loop

        j:=1;
		  jloop: --search all cols
        loop

				if C(i,j)=0 and R_cov(i)=0 and C_cov(j)=0 then --nonCoveredZero
					row:=i;
					col:=j;
					exit iloop;
				end if;

				j:=j+1;
				exit jloop when j>n;

        end loop jloop;

        i:=i+1;
        exit iloop when i>n;

      end loop iloop;

    end find_uncovered_zero;


    function foundMinUncovered(mini : out integer)
	 	return boolean is
		row,col,
      i,j : integer;
      found: boolean := false;
    begin
	   mini:=integer'last; --9999;
      row:=0;
      col:=0;
      i:=1;
		iloop: --row
      loop
        j:=1;
		  jloop: --col
        loop
				if 
					C(i,j)<mini  --decreases mini
				and 
					R_cov(i)=0 and C_cov(j)=0  --nonCovered
				then
					row:=i;
					col:=j;
					mini:=C(i,j);
					found:=true;
				end if;

				j:=j+1;
				exit jloop when j>n;
        end loop jloop;

        i:=i+1;
		  exit iloop when i>n;
      end loop iloop;

		return found;

    end foundMinUncovered;


begin

	done:=false;
	while not(done) loop
		find_uncovered_zero(row,col);
		if row=0 then --no unCoveredZero found
			done:=true;
			if foundMinUncovered(uncMin) then
				step:=6;
			else -- all elements are covered...we are completely done
				step:=7;
			end if;

		else -- exists uncovered zero @(row,col)

			--myassert(col>0, 41, "munkres@step4");

			M(row,col):=2; --this unCoveredZero is now primed

			if found_star_in_row(row,col2) then --my change
				R_cov(row):=1; --cover this row
				C_cov(col2):=0; --uncover this col
			else
				z0_r:=row; z0_c:=col; --coords of uncovered prime
				done:=true;
				step:=5;
			end if;
		end if;
	end loop;

end step4;

---------------------------------------------------------------------

 
procedure step5(step : in out integer) is
  count : integer:=0;
  done  : boolean;
  row,col   : integer:=0;

  procedure find_star_in_col(col : in integer; row : in out integer) is
  begin
    row:=0;
    for i in 1..n loop
      if M(i,col)=1 then
        row:=i;
      end if;
    end loop;
  end find_star_in_col;

  procedure find_prime_in_row(row : in integer; col : in out integer) is
  begin
  	 col:=0;
    for j in 1..n loop
      if M(row,j)=2 then
        col:=j;
      end if;
    end loop;
  end find_prime_in_row;

  procedure convert_path is
  begin
    for i in 1..count loop
      if M(path(i,1),path(i,2))=1 then
        M(path(i,1),path(i,2)):=0;
      else
        M(path(i,1),path(i,2)):=1;
      end if;
    end loop;
  end convert_path;

  procedure clear_covers is
  begin
    for i in 1..n loop
      R_cov(i):=0;
      C_cov(i):=0;
    end loop;
  end clear_covers;

  procedure erase_primes is
  begin
    for i in 1..n loop
      for j in 1..n loop
        if M(i,j)=2 then
          M(i,j):=0;
        end if;
      end loop;
    end loop;
  end erase_primes;

begin

	count:=1;
	path(count,1):=z0_r; --primed, uncovered zero
	path(count,2):=z0_c; --from step4
	done:=false;
	while not(done) loop

		find_star_in_col(path(count,2),row);

		if row>0 then
			count:=count+1;
			path(count,1):=row;
			path(count,2):=path(count-1,2); --same col as before
		else --there is no starred zero in same col
			done:=true;
		end if;

		if not(done) then
			find_prime_in_row(path(count,1),col);
			--myassert(0<col and col<=n, 51, "munkres.step5");
			count:=count+1;
			path(count,1):=path(count-1,1); --same row as before
			path(count,2):=col;
		end if;

	end loop;
	convert_path;
	clear_covers;
	erase_primes;
	step:=3;

end step5; 



---------------------------------------------------------------------
procedure step6(step : in out integer) is
    minval : integer;
begin

	minval:=uncMin; --calculated in step 4

	 for i in 1..n loop
		for j in 1..n loop
		  if R_cov(i)=1 then
			 C(i,j):=C(i,j)+minval;
		  end if;
		  if C_cov(j)=0 then
			 C(i,j):=C(i,j)-minval;
		  end if;
		end loop;
	 end loop;

    step:=4;

end step6;
  
---------------------------------------------------------------------

	okrow: boolean;

begin -- hungarian (main)

	j:=0;
	for r in 1..n loop
	for c in 1..n loop
		j:=j+1;
		c0(r,c) := cost(j);
	end loop;
	end loop;
	c:=c0;

	ok:=true;
	done:=false;
	stepnum:=1;
	while not(done) loop
		case stepnum is
		when 1 => step1(stepnum);
		when 2 => step2(stepnum);
		when 3 => step3(stepnum);
		when 4 => step4(stepnum);
		when 5 => step5(stepnum);
		when 6 => step6(stepnum);
		when others => done:=true;
		end case;
	end loop;

	--prep for exporting ASSN:
	for r in 1..n loop
		okrow:=false;
		for c in 1..n loop
			if m(r,c)=1 then --starred
				assn(r):=c; 
				okrow:=true;
			end if;
		end loop;
		if not okrow then ok:=false; end if; --extra guard
	end loop;

end hungarian;

end munkres; --package

