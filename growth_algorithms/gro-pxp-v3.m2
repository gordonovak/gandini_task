--  File Created July 16th, 2025


isgdiv := (m, l) -> (
    for i to numColumns m - 1 do if (m_i_0-(l_i_0)) < 0 then return false;
    return true;
)

gandiniminimal := (m, L) -> (
    for l in L do (
        if (not (l == m) and isgdiv(m, l)) then (
            m = m - l;
            if m == 0 then (
                return false;
            );
        );  
    );
    return true;
)

-- Input
--  * R - polynomialRing
--  * L - list of exponent vectors
--  * p - order of the elementary abelian group
--  * k - number of rows of the weight matrix
-- Output
--  A list of the polynomial invariants that generate the invariant ring
growseeds = method();
growseeds(PolynomialRing, List, ZZ, ZZ) := (R, L, p, k) -> (

    gR = gens R;

    -- First we create a list to keep track of our invariants, whether we want to stop powering or not. 
    guideList = toList(0..(#L - 1));

    -- Then we create the list we're actually going to add stuff to.
    M = L;

    -- This is the loop that determines the total number of powers that we need to check
    -- The formula is n(p-1) + 1
    for i from 1 to (k*(p-1)+1) do (

        -- Then, we iterate through all the elements of our seed list. 
        for m to #L - 1 do (

            -- If the pure power of the first element is minimal, then we continue. 
            if (guideList#m != -1) then (
                m' = (L#m)*i;
                for n in L do (

                    -- [P1] ST: This part mods out the exponents. 
                    mn = m' * transpose n;
                    m' = matrix(apply(entries m', r -> apply(r, x -> x%p)));
                    -- [P1] FIN --

                    if (m' != 0) then (
                        if (n == L#m) then (
                            M = {m'} | M;
                        ) else ( -- Then adds non direct-powers to the end of the list. 
                            M = M | {m'};
                        );  
                    );
                );

                -- We call this function to check for minimal status. 
                -- If it's not, we update the guidelist accordingly, and remove that element. 
                print m';
                if (not gandiniminimal(m', M)) then (
                    guideList#m = -1;
                    M = drop(M, 1); -- drop removes the element. 
                );
            );
        );
    );

    for i from 0 to (numgens R - 1) do (
        M = M | {matrix({for k to numgens R - 1 list (if i == k then p else 0)})};
    );

    N = {};

    gR = gens R;
    for i in M do (
        n = 1;
        print gens R;
        for k to #i - 1 do (n = n * (transpose matrix(for r in gens R list r^p)););
        N = N | {n};
    );
    print N;

    return flatten entries mingens ideal N;
)



export {"growseeds"}