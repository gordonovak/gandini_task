
-- Demo for dairy queen
-- make sure to read these comments they're suuuper important

-- ///////////////////
-- ok now we start!!!!
-- ///////////////////

-- first we need to load the file with our algorithms:
load "invariantgens.m2";

-- then, we can start using the genseeds, expandseeds, and invarseedgen algorithms

-- /////////////////////
-- generating seeds algorithm
-- /////////////////////

-- To start running the code, type "M2" into your terminal and everything should work beautifully

-- First, we need to define the ring we're working in.
-- If we don't, and we just define a polynomial, we'll get an error:
f := x_1^2 + x_2
-- You should see "error: no method for binary operator ^ applied to indexed variables"
-- Instead, let's define the ring we're working in:
R = QQ[x_1, x_2, x_3]
-- Here, QQ denotes the rationals. (RR denotes the reals, ZZ the integers, ect.)

-- Then, we can define our polynomial!
f := x_1^2 + x_2

-- You should see that f belongs to the ring R:
--       2
-- o4 = x  + y
--
-- o4 : R
-- 

-- Perfect, now we're ready to start using the algorithm. 
-- Now, let's define a weight matrix that concerns the group action on our ring:
W = matrix{{0,1,1},{1,0,1}};
M = {{0,1},{1,0}};

-- Now, we need to specify the order of each of our group elements. (In elementary p-abelian groups, all orders should be the same)
Zp = 2;

-- Finally, we can call our seed generator function!
seedList = genseeds(R, W, Zp)
-- You should see something like this:
--
-- oo14 = {x x x }
--          1 2 3
--
-- oo14 : List

-- Note that the seed generator function can either be called with:
--  * genseeds(Ring, Matrix, ZZ)
-- OR it can be called with a list for the mods:
--  * genseeds(Ring, Matrix List)

-- /////////////////////
-- expanding seeds algorithm
-- /////////////////////

-- Now that we have a set of seeds, we can now call the expand seeds algorithm on the seeds we just generated:
expandseeds(seedList, Zp)

-- Pretty straightforward. 

-- /////////////////////
-- composite function
-- /////////////////////

-- Now it might seem like a hassle to generate and expand the seeds separately, so we programmed a composite method that handles the functions of the two methods simultaneously:
invariantgens(R, W, Zp)


-- /////////////////////
-- additional notes
-- /////////////////////

-- To find each of these algorithms, you can do to:
-- ø/p-invariants/invar_dependencies/genseeds.m2
-- ø/p-invariants/invar_dependencies/expandseeds.m2
-- ø/p-invariants/invargenset.m2

-- Furthermore, you may have notices an inconsistent use of semicolons (;) throughout this document. The semicolon SUPRESSES output so you don't see some results that are kind of unnecessary.
-- For example:
R1 = QQ[x_1..x_9];
R2 = ZZ[x_1..x_3]
-- The one with the semicolon has no output but the one without the semicolon does. For menial code like this, there's not much need to see the output (because i know ZZ[x_1..x_3] is a three-variate polynomial ring), so we supress it intentionally. 

-- /////////////////////
-- additional examples
-- /////////////////////

-- Initial 3 variable example
R = QQ[x_0..x_2];
W = matrix{{0,1,1},{1,0,1}};
ZList = {2,2,2};
invariantgens(R, W, ZList)

-- 5 variable example
R = QQ[v,w,x,y,z];
Zp = 4;
W = matrix{{1,1,1,1,1},{1,1,1,1,0}};
invariantgens(R,W,ZList)

