--  File Created July 18th, 2025

--  CREDITS  --
--  Advisor: Francesca Gandini
--  Theory: Marcus Cassel & Sumner Strom
--  Code: Gordon Novak
--      * Last Editied - Gordon Novak 07/07/25
--  Documentation: Gordon Novak
--      * Last Documented - 07/03/25
--  Review: Marcus Cassel & Sumner Strom
--      * Last Reviewed - 07/03/25

-- //////////////// --
-- //////////////// --
-- CODE STARTS HERE
-- //////////////// --
-- //////////////// --


-- generation of seeds algorithm
-- Input
--  * R     : polynomialRing    => Ring being acted upon
--  * W     : matrix            => Weight matrix representing the group action
--  * Z     : integer           => List of the order of the cyclic groups that the weight matrix represents
-- Output
--  * N     : List              => List of generating seeds
genseeds = method();
genseeds(Matrix, ZZ, PolynomialRing) := (W, ZList, R) -> (

    -- Setting n & m for ease of use
    n = numColumns W;
    m = numRows W;

    -- The variable that holds the full rank submatrix
    subVars = matrix{{0}};
    -- We need to keep track of the columns of our full rank matrix
    colList = {};

    -- Keeps track of the indicies of the columns from which we'll form the submatricies
    mList = toList (0..(m-1));

    --We go through sets of m x m submatricies to find nonzero determinant.
    for i to n - m do (
        -- Form the submatrix of size m x m
        rod = submatrix(W, mList, toList (i..(i + m - 1)));

        -- If determinant is nonzero, we'll use it:
        if (determinant rod != 0) then (
            subVars = rod;
            colList = toList (i..(i + m - 1));
            break;
        );
    );

    -- If there are no possible invariants, return an empty list. 
    if (subVars == matrix{{0}}) then (
        error ("No invariants for this weight matrix.\n");
        return {};
    );

    -- Keeps track of each of the vectors representing the exponents 
    vecExp = {};
    
    for v in toList(set(toList (0..(n-1))) - set(colList)) do (
        wColumns = sort({v} | colList); 
        -- Creates a Census of gerballs
        tempVec = {};
        -- Sets the signFlip to 1 to start
        signFlip = 1;
        -- We then do cofactor expaction on the chosen sub matrix, and put it into vector.
        for i in wColumns do (
            -- e is basis vector e_j (e.g. {0,1,0,...,0})
            e = matrix ({for j from 0 to n-1 list (if j == i then 1 else 0)});
            
            -- Makes a square sub matrix that is removing one of the columns
            subM = submatrix(W, mList, sort(toList(set(wColumns) - set({i}))));
            -- scales the unit vector
            tempVec = tempVec | {signFlip * (determinant subM ) * e};
            
            -- F lip the signFlip
            signFlip = signFlip * -1;
        );
        --  Sums every tempVec together.
        vecExp = vecExp | {sum tempVec};
    );

    return vecExp;
)


export {"genseeds"};