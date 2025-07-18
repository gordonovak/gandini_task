--  File Created July 7th, 2025

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


-- METHOD_NAME: genseeds
-- USAGE: Finds the minimal generating seed invariants for an invariant ring
--      INPUT: 
--          * R     : polynomialRing    => Ring being acted upon
--          * W     : matrix            => Weight matrix representing the group action
--          * Z     : integer           => List of the order of the cyclic groups that the weight matrix represents
--      OUTPUT:
--          * N     : List              => List of generating seeds
genseeds = method();
genseeds(PolynomialRing, Matrix, List) := (R, W, ZList) -> (

    -- Setting n & m for ease of use
    n = numColumns W;
    m = numRows W;

    -- The variable that holds the full rank submatrix
    subVars = matrix{{0}};
    -- We need to keep track of the columns of our full rank matrix
    colList = {};

    -- Keeps track of the indicies of the columns from which we'll form the submatricies
    mList = toList (0..(m-1));

    -- Now, we start going through sets of m x m submatricies to check if the determinant is nonzero.
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
    if (subVars == matrix{{0}}) then (
        print ("error: i cant do it.\n");
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
        -- This for loop allows us to do a cofactor expaction on the chosen sub matrix, and puts it into vector.
        for i in wColumns do (
            -- e is basis vector e_j (e.g. {0,1,0,...,0})
            e = for j from 0 to n-1 list (if j == i then 1 else 0);
            
            -- Makes a square sub matrix that is removing one of the columns
            subM = submatrix(W, mList, sort(toList(set(wColumns) - set({i}))));
            -- scales the unit vector
            tempVec = tempVec | {signFlip * (determinant subM ) * e};
            
            -- F lip the signFlip
            signFlip = signFlip * -1;
        );
        --  Takes every tempVec and adds them together to form a vector that represents exponents.  
        vecExp = vecExp | {fold((a,b) -> (for i to #a - 1 list (a_i + b_i)), tempVec)};
        
    );


    expR = {};
    for vec in vecExp do (
        seed = 1;
        for e to (#vec - 1) do (
            if (vec#e != 0) then (
                seed = seed * (gens R)#e^((ZList#e + vec#e) % ZList#e);
            );
        );
        expR = expR | {seed};
    );

    return expR;
)

genseeds(PolynomialRing, Matrix, ZZ) := (R, W, Zp) -> (
    return genseeds(R, W, for i to #(gens R) - 1 list Zp);
)

export {"genseeds"};