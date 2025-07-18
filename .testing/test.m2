-- Test document to test efficiency of certain algorithms.

needsPackage "InvariantRing";
load "/Users/gordienovak/special/generation_algorithms/gen-pxp-v1.m2";
load "/Users/gordienovak/special/growth_algorithms/gro-pxp-v1.m2";
load "vd.m2"

dataFile = openOut "output.csv";
invarFile = openOut "invariants.csv";
dataFile << "Trial, Ring, mod, DiagAction (s), Our Alg (s), Ratio, Invar\n";

-- Grabs the total time
dataFile << ("\n \nTotal Time (s)," | toString((toList(timing(


trial = 0;
for r from 0 to (#RList - 1) do (
    print ("\n--------");
    print ("Testing " | toString (RList#r));
    for m in PrimeList do (
        print("Mod " | toString m);
        print("- Qdiag... ");
        trial = trial + 1;
        if (toString (RList#r) == "R") then (
            dataFile << (toString trial | ",''," | toString (m) | ",");
        )
        else (
            dataFile << (toString trial | "," | toString (RList#(r)) | "," | toString (m) | ",");
        );
        
        -- Testing DiagonalAction
        L = for i to 20 list 
            (toList( 
                timing (
                    gens (RList#r ^ (diagonalAction ( WList#r, for i to ((numRows WList#r) - 1) list m, RList#r)));
                )
            ));
        M = L;
        l = for el in L list round(8,el_0);
        t1 = (sum l / (#l));
        dataFile << (toString t1 | ",");

        print ("- New Alg... ");
        -- Testing our Algorithm
        L = for i to 20 list 
            (toList(
                timing (
                    growseeds( genseeds(RList#r, WList#r, m), m )
                )
            ));
        l = (for el in L list round(8,el_0));
        t2 = (sum l / #l);
        dataFile << (toString t2 | "," | toString (t1/t2) | "\n");

        ML = for i to min(#M, #L_0_1) - 1 list (
            if (M_i != L_0_1_i) then (
                false
            ) else true
        );

        for l in L_0_1 do (invarFile << (toString(l) | ","));
        invarFile << "\n";
        for m in M do (invarFile << (toString(m) | ","));
        invarFile << "\n";
        for ml in ML do (invarFile << (toString(ml) | ","));
        invarFile << "\n";
        print " ";
    );
);

)))_0));

close dataFile;
close invarFile;






