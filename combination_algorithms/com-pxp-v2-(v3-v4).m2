-- file created july 18th 2025
-- puts everything in terms of list - fastest algorithm yet



isZero = method();
isZero(List) := L -> (
    for i in L do (
        if (i != 0) then return false;
    );
    return true;
);

gandiniminimal := (m, L) -> (
    k := #m;
    for l to #L-1 do (
        mmin = true;
        lmin = true;
        for i to #m - 1 when (mmin or lmin) do (
            if (m_i > L#l_i) then mmin = false;
            if (L#l_i > m_i) then lmin = false;
        );
        if lmin then return 0;
        if mmin then return 1;
    );
    return 2;
)

diagSub = method();
diagSub(Matrix, ZZ, PolynomialRing) := (W, d, R) -> (

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
        print ("No invariants for this weight matrix.\n");
        print W;
        return {};
    );

    -- Keeps track of each of the vectors representing the exponents 
    seedList = {};
    
    for v in toList(set(toList (0..(n-1))) - set(colList)) do (
        wColumns = sort({v} | colList); 
        -- Creates a Census of gerballs
        tempVec = {};
        -- Sets the signFlip to 1 to start
        signFlip = 1;
        -- We then do cofactor expaction on the chosen sub matrix, and put it into vector.
        for i in wColumns do (
            -- e is basis vector e_j (e.g. {0,1,0,...,0})
            e = for j from 0 to n-1 list (if j == i then 1 else 0);
            
            -- Makes a square sub matrix that is removing one of the columns
            subM = submatrix(W, mList, sort(toList(set(wColumns) - set({i}))));
            -- scales the unit vector
            tempVec = tempVec | {signFlip * (determinant subM) * e};
            
            -- F lip the signFlip
            signFlip = signFlip * -1;
        );
        --  Sums every tempVec together.
        seedList = seedList | {sum tempVec};
    );

    gR := gens R;
    ind := numgens R - 1;

    -- Then we create the list we're actually going to add stuff to.
    seedList = for l in seedList list apply(l, x -> ((x % d) + d) % d);
    newList := seedList;
    trashList := seedList | {apply(ind + 1, i -> 0)};
    -- This is the loop that determines the total number of powers that we need to check
    -- The formula is n(d-1) + 1

    for i from 1 to ((numRows W)*(d-1)) do (

        -- Then, we iterate through all the elements of our seed list. 
        for m when m < #newList do (

            -- If the pure power of the first element is minimal, then we continue. 
            m' := (newList#m)*i;

            for n to #newList - 1 do (
                n' := newList#n;
                -- [P1] ST: This part mods out the exponents. 
                m' = (m' + n') % d;
                -- [P1] FIN --

                if (not isZero(m')) and (not any(trashList, t -> (m' == t))) then (
                    result = gandiniminimal(m', newList);
                    if (result == 1) then newList = replace(n, m', newList)
                    else if (result == 2) then newList = newList | {m'}
                    else trashList = trashList | {m'};
                );
            );
        );
    );


    for i from 0 to (numgens R - 1) do (
        newList = newList | {for k to numgens R - 1 list (if i == k then d else 0)};
    );

    polyList := {};

    for i in newList do (
        n = 1;
        for j to #i - 1 do (n = n * ((gR_j)^(i_j)));
        polyList = polyList | {n};
    );

    return flatten entries mingens ideal polyList;
)