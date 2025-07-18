-- File created july 18th, gordie novak


-- These two functions aid with the growth algorithm

-- This one checks if one exponent vector is divisible by another
isgdiv := (m, l) -> (
    for i to numColumns m - 1 do if (m_i_0-(l_i_0)) < 0 then return false;
    return true;
)

-- This one checks if one exponent vector can be created with the others. 
gandiniminimal := (m, vecExp) -> (
    for l in vecExp do (
        if (not (l == m) and isgdiv(m, l)) then (
            m = m - l;
            if m == 0 then (
                return false;
            );
        );  
    );
    return true;
)

diagSub = method();
diagSub(Matrix, ZZ, PolynomialRing) := (W, d, R) -> withLocalScope (

    --->----------------->--->
    -- Generation Algorithm Begin
    --->----------------->--->

    -- Setting n & m for ease of use
    n := numColumns W;
    m := numRows W;

    -- The variable that holds the full rank submatrix
    subVars := matrix{{0}};
    -- We need to keep track of the columns of our full rank matrix
    colList := {};

    -- Keeps track of the indicies of the columns from which we'll form the submatricies
    mList := toList (0..(m-1));

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
    vecExp := {};
    
    for v in toList(set(toList (0..(n-1))) - set(colList)) do (
        wColumns := sort({v} | colList); 
        -- Creates a Census of gerballs
        tempVec := {};
        -- Sets the signFlip to 1 to start
        signFlip := 1;
        -- We then do cofactor expaction on the chosen sub matrix, and put it into vector.
        for i in wColumns do (
            -- evec is basis vector e_j (evec.g. {0,1,0,...,0})
            evec := matrix ({for j from 0 to n-1 list (if j == i then 1 else 0)});
            
            -- fullListakes a square sub matrix that is removing one of the columns
            subfullList := submatrix(W, mList, sort(toList(set(wColumns) - set({i}))));
            -- scales the unit vector
            tempVec = tempVec | {signFlip * (determinant subfullList ) * evec};
            
            -- F lip the signFlip
            signFlip = signFlip * -1;
        );
        --  Sums every tempVec together.
        vecExp = vecExp | {sum tempVec};
    );


    --->----------------->--->
    -- Growth Algorithm Begin
    --->----------------->--->

    gR := gens R;
    k := n;

    -- First we create a list to keep track of our invariants, whether we want to stop powering or not. 
    guideList = toList(0..(#vecExp - 1));

    -- Then we create the list we're actually going to add stuff to.
    vecExp = for l in vecExp list (matrix({apply(flatten entries(l), x -> ((x % d) + d) % d)}));
    fullList := vecExp;

    -- This is the loop that determines the total number of powers that we need to check
    -- The formula is n(d-1) + 1
    for i from 1 to (k*(d-1)+1) do (

        -- Then, we iterate through all the elements of our seed list. 
        for m to #vecExp - 1 do (

            -- If the pure power of the first element is minimal, then we continue. 
            if (guideList#m != -1) then (
                m' := (vecExp#m)*i;
                for n in vecExp do (

                    -- [P1] ST: This part mods out the exponents. 
                    mn := m' * transpose n;
                    m' = matrix(apply(entries m', r -> apply(r, x -> ((x % d) + d) % d)));
                    -- [P1] FIN --

                    if (m' != 0) then (
                        if (n == vecExp#m) then (
                            fullList = {m'} | fullList;
                        ) else ( -- Then adds non direct-powers to the end of the list. 
                            fullList = fullList | {m'};
                        );  
                    );
                ); 
            );
        );
    );


    -- This adds the pure power exponent vectors to the list
    for i from 0 to (numgens R - 1) do (
        fullList = fullList | {matrix({for k to numgens R - 1 list (if i == k then d else 0)})};
    );

    N := {};

    -- This for loop converts exponent vectors to polynomials in the ring.
    for i in fullList do (
        n = 1;
        for j to #gR - 1 do (n = n * ((gR_j)^(i_j_0)));
        N = N | {n};
    );

    -- This one finds the minimal basis and returns it. 
    return flatten entries mingens ideal N;
)