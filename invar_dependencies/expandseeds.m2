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

-- METHOD_NAME: expandseeds
-- USAGE: Finds the minimal generating seed invariants for an invariant ring
--      INPUT: 
--          * L     : List              => contains generating seeds for expansion.
--          * ZList : List              => contains the list of moduluses of each variable.
--      OUTPUT:
--          * N     : List              => list of minimal generating invariants for the ring.
expandseeds = method();
expandseeds (List, List) := (L, ZList) ->(

    R = ring(L_0);
    gR = gens(ring L_0);
    -- M will be all of the elements in our group and N will include only minimal elements of M

    M = {};
    -- This for loop goes through the variables and appends the pure powers to M
    
    -- This code accumulates the m' over and over and then mods out by our modDegree
    for m in L do (
        M = M | {m};

        for n in L do (
            m' = m;
            if not (n == m) then (
                
                for p to n*(ZList_0 - 1) when (m' != 0) do (

                    -- Then, we multiply out a power. 
                    m' = m' * n;


                    me = flatten (exponents(m'));
                    for pow to #me - 1 when (m' != 0) do (
                        if (me_pow >= ZList_0) then (
                            m' = lift(m' / ((gR#pow)^(ZList#0)), R);
                            --m' = m' % (gens R)_pow^(ZList_0);
                        )
                    );
                    -- First we add m' to our M
                    M = M | {m'};

                );
            );
        );
    );

    

    --remove duplicate monomials
    M = unique(M);
    M = sort(M);


    N = {};

    for i from 0 to (numgens R - 1) do (
        M = M | {(gR#i)^(ZList#i)};
    );

    -- Now, we're going reduce the set to be minimal
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

expandseeds (List, ZZ) := (L, Zp) ->(
    R = ring(L_0);
    return expandseeds(L, for i to #(gens R) - 1 list Zp);
)

export {"expandseeds"};