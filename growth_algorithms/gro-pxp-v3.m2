--  File Created July 16th, 2025


toPoly := (m) -> (
    n = 1;
    Re = QQ[v..z];
    Reg = gens Re;
    for i when i < #m do (
        n = n*((Reg_i)^(m_i_0))
    );
    return n;
)

inTrash := (m, trash) -> (
    
)

gandiniminimal := (m, L) -> (
    if m == 0 then return 0;
    k := numColumns m;
    for l to #L-1 do (
        mmin = true;
        lmin = true;
        for i to #m - 1 when (mmin or lmin) do (
            if (m_i_0 > L#l_i_0) then mmin = false;
            if (L#l_i_0 > m_i_0) then lmin = false;
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

    -- Then we create the list we're actually going to add stuff to.
    seedList = for l in seedList list (matrix({apply(flatten entries(l), x -> ((x % p) + p) % p)}));
    newList := seedList;
    trashList := (seedList);
    -- This is the loop that determines the total number of powers that we need to check
    -- The formula is n(p-1) + 1
    iterations = 0;
    for i from 1 to (k*(p-1)) do (

        -- Then, we iterate through all the elements of our seed list. 
        for m when m < #newList do (

            -- If the pure power of the first element is minimal, then we continue. 
            m' := (newList#m)*i;
            for n to #newList - 1 do (
                n' := newList#n;
                -- [P1] ST: This part mods out the exponents. 
                print ("modding out");
                print ((toList(timing(

                

                m' =  matrix({apply(
                    numColumns m', i -> (((m'_i_0 + n'_i_0) % p + p) % p)
                )});

                )))_0);
                -- [P1] FIN --

                print "minimizing";
                print ((toList(timing(

                if (m' != 0) and (not any(trashList, t -> (m' == t))) then (
                    result = gandiniminimal(m', newList);
                    if (result == 1) then newList = replace(n, m', newList)
                    else if (result == 2) then newList = newList | {m'}
                    else trashList = trashList | {m'};
                );
                )))_0);
                iterations = iterations + 1;
            );
        );
    );

    for i from 0 to (numgens R - 1) do (
        newList = newList | {matrix({for k to numgens R - 1 list (if i == k then p else 0)})};
    );

    polyList := {};

    for i in newList do (
        n = 1;
        for j to #i - 1 do (n = n * ((gR_j)^(i_j_0)));
        polyList = polyList | {n};
    );

    print iterations;

    return polyList;
)



export {"growseeds"}