--  File Created July 16th, 2025

isGandiniMinimal = method();
isGandiniMinimal(List, RingElement) := (L, m) -> (
    R = ring(m);
    for l in L do (
        if (not l == m and (m % l) == 0) then (
            m = m // l;
            if m == 1_R then (
                return false;
            );
        );  
    );
    return true;
)

growseeds = method();
growseeds(List, ZZ, ZZ) := (L, p, n) -> (
    R = ring(L_0);
    gR = gens(ring L_0);

    -- First we create a list to keep track of our invariants, whether we want to stop powering or not. 
    guideList = toList(0..(#L - 1));

    -- Then we create the list we're actually going to add stuff to.
    M = L;

    -- This is the loop that determines the total number of poers that we need to check
    -- The formula is n(p-1) + 1
    for i from 1 to (n*(p-1)+1) do (

        -- Then, we iterate through all the elements of our seed list. 
        for m to #L - 1 do (

            -- If the pure power of the first element is minimal, then we continue. 
            if (guideList#m != -1) then (
                m' = L#m^i;
                for n in L do (

                    -- [P1] ST: This part mods out the exponents. 
                    me = flatten (exponents(m' * n));
                    m' = 1;
                    for pow to #me - 1 when (m' != 0) do (
                        m' = m' * (gR#pow ^ (me#pow % p));
                    );
                    -- [P1] FIN --

                    -- [P2] ST: This part appends the pure power element to the front of the list
                    -- We need to make sure that's its not 1 though. 
                    if (m' != 1) then (
                        if (n == L#m) then (
                            M = {m'} | M;
                        ) else ( -- Then adds non pure-powers to the end of the list. 
                            M = M | {m'};
                        );
                    );
                    -- We do this so it's easy to check if the pure power is minimal in the next if statement. 
                    -- [P2] FIN --
                );

                -- We call this function to check for minimal status. If it's not, we update the guidelist accordingly, and remove that element. 
                if (not isGandiniMinimal(M, M#0)) then (
                    guideList#m = -1;
                    M = drop(M, 1); -- drop removes the element. 
                );
            );
        );
    );

    for i from 0 to (numgens R - 1) do (
        M = M | {(gR#i)^(p)};
    );

    return flatten entries mingens ideal M;
)

export {"growseeds"}