--  File Created July 18th, 2025

-- trying to put everything in terms of lists

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

-- Input
--  * R - polynomialRing
--  * seedList - list of exponent vectors
--  * p - order of the elementary abelian group
--  * k - number of rows of the weight matrix
-- Output
--  A list of the polynomial invariants that generate the invariant ring
growseeds = method();  
growseeds(PolynomialRing, List, ZZ, ZZ) := (R, seedList, p, k) -> (

    gR := gens R;
    ind := numgens R - 1;

    -- Then we create the list we're actually going to add stuff to.
    seedList = for l in seedList list apply(l, x -> ((x % p) + p) % p);
    newList := seedList;
    trashList := seedList | {apply(ind + 1, i -> 0)};
    -- This is the loop that determines the total number of powers that we need to check
    -- The formula is n(p-1) + 1

    modtime = 0;
    mintime = 0;

    for i from 1 to (k*(p-1)) do (

        -- Then, we iterate through all the elements of our seed list. 
        for m when m < #newList do (

            -- If the pure power of the first element is minimal, then we continue. 
            m' := (newList#m)*i;

            for n to #newList - 1 do (
                n' := newList#n;
                -- [P1] ST: This part mods out the exponents. 
                m' = (m' + n') % p;
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
        newList = newList | {for k to numgens R - 1 list (if i == k then p else 0)};
    );

    polyList := {};

    for i in newList do (
        n = 1;
        for j to #i - 1 do (n = n * ((gR_j)^(i_j)));
        polyList = polyList | {n};
    );

    return polyList;
)



export {"growseeds"}