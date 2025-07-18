--  File Created July 7th, 2025

--  CREDITS  --
--  Advisor: Francesca Gandini
--  Theory: Marcus Cassel & Sumner Strom
--  Code: Gordon Novak
--      * Last Editied - Gordon Novak 07/03/25
--  Documentation: Gordon Novak
--      * Last Documented - 07/07/25
--  Review: Marcus Cassel & Sumner Strom
--      * Last Reviewed - 07/03/25

-- //////////////// --
-- //////////////// --
-- CODE STARTS HERE
-- //////////////// --
-- //////////////// --

-- METHOD_NAME: growseeds
-- USAGE: Finds the minimal generating seed invariants for an invariant ring
--      INPUT: 
--          * L     : List              => contains generating seeds for expansion.
--          * ZList : List              => contains the list of moduluses of each variable.
--      OUTPUT:
--          * N     : List              => list of minimal generating invariants for the ring.

growseeds = method();

growseeds (List, List) := (L, ZList) ->(

    R = ring(L_0);
    gR = gens(ring L_0);
    -- M will be all of the elements in our group and N will include only minimal elements of M

    M = {};

    -- This code accumulates the m' over and over and then mods out by our modDegree

    for m in L do (

        M = M | {m};
        m' = m;
        for p in ZList when (m' != 0) do (

            -- Then, we multiply out a power. 
            m' = m' * m;

            for j to (#gR - 1) do (
                while (degree(gR#j, m') > ZList#j) do (
                    m' = lift(m' / ((gR#j)^(ZList#j)), R);

                );
            );

            -- First we add m' to our M
            M = M | {m'};

        );
    );
    -- This for loop goes through the variables and appends the monomials to M

    for i from 0 to (numgens R - 1) do (
        M = M | {(gR#i)^(ZList#i)};
    );

    --remove duplicate monomials
    M = unique(M);
    M = sort(M);

    N = {};
    -- Now, we're going to check if we can make 
    for i when (i < #M) do (

        candidate = M_i;

        for j when (j < #M) do (
            if (i != j and (candidate % M_j) == 0) then (
                
                candidate = candidate // M_j;

                if candidate == 1_R then (
                    break;
                );
            );  
        );
        if (candidate != 1_R) then (
            N = N | {M_i};
        )
    );

    -- Finally, we return M

    return N;

)

growseeds (List, ZZ) := (L, Zp) ->(

    R = ring(L_0);
    return growseeds(L, for i to #(gens R) - 1 list Zp);

)

