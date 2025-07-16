--  File Created July 7th, 2025

--  CREDITS  --
--  Advisor: Francesca Gandini
--  Theory: Marcus Cassel & Sumner Strom
--  Code: Gordon Novak
--      * Last Editied - Gordon Novak 07/07/25
--  Documentation: Gordon Novak
--      * Last Documented - 07/07/25
--  Review: Marcus Cassel & Sumner Strom
--      * Last Reviewed - 07/03/25

-- //////////////// --
-- //////////////// --
-- CODE STARTS HERE
-- //////////////// --
-- //////////////// --

load "./invar_dependencies/genseeds.m2";
load "./invar_dependencies/expandseeds.m2";

-- METHOD_NAME: invariantgens
-- USAGE: Finds the minimal generating seed invariants for an invariant ring
--      INPUT: 
--          * R     : polynomialRing    => Ring being acted upon
--          * W     : matrix            => Weight matrix representing the group action
--          * Z     : List              => List of the order of the cyclic groups that the weight matrix represents
--      OUTPUT:
--          * N     : List              => Generating elements of the ring of invariants
invariantgens = method();
invariantgens(PolynomialRing, Matrix, List) := (R, W, ZList) -> (
    return expandseeds(genseeds(R, W, ZList), ZList);
)
invariantgens(PolynomialRing, Matrix, ZZ) := (R, W, Zp) -> (
    return expandseeds(genseeds(R, W, Zp), Zp);
)

needsPackage "InvariantRing"
qdiag = method();
qdiag(Matrix, ZZ, PolynomialRing) := (W, d, R) -> (
    return R^(diagonalAction(W, for i to (numRows W) - 1 list d, R));
)
qdiag(Matrix, List, PolynomialRing) := (W, d, R) -> (
    return R^(diagonalAction(W, d, R));
)

export {"invariantgens"}

beginDocumentation();

load "./invar_dependencies/gensDoc.m2";