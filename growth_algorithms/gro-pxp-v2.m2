--  File Created July 16th, 2025
exponentCompare = method();
exponentCompare(List, List) := (l, m) -> (
    if (m == l) then return 2;
    lbot = true;
    mbot = true;
    for k to #m - 1 do(
        if (l_k > (m#k)) then lbot = false;
        if (l#k < (m#k)) then mbot = false;
    );
    if lbot then return 2;
    if mbot then return 1;
    return 0;
)

isGandiniMinimal = method();
isGandiniMinimal(List, RingElement) := (L, m) -> (
    if (m == 1) then return L;
    me = flatten(exponents(m));
    for l when l < #L-1 do (
        toDo = exponentCompare(flatten(exponents(L#l)), me);
        if toDo == 0 then continue;
        if toDo == 1 then (L = replace(l, m, L);)
        else if toDo == 2 then return L;
    );
    return L | {m};
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
    for i from 1 to #gR do (

        -- Then, we iterate through all the elements of our seed list. 
        for m when (m < (#M - 1)) do (

            -- If the pure power of the first element is minimal, then we continue. 
            if (guideList#0 != -1) then (
                m' = M#m^i;
                for n in M do (
                    m' := M#m^i;
                    -- [P1] ST: This part mods out the exponents. 
                    me = flatten (exponents(m' * n));
                        m' = 1;
                    for pow to #me - 1 do (
                        m' = m' * (gR#pow ^ ((me#pow) % p));
                    );
                    -- [P1] FIN --

                    -- [P2] ST: This part appends the pure power element to the front of the list
                    -- We need to make sure that's its not 1 though. 
                    M = isGandiniMinimal(M, m');
                    -- We do this so it's easy to check if the pure power is minimal in the next if statement. 
                    -- [P2] FIN --
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