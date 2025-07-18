-- Test document to test efficiency of certain algorithms.

needsPackage "InvariantRing";
load "/Users/gordienovak/special/combination_algorithms/com-pxp-v2-(v3-v4).m2";
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
        diagInvars = sort(gens(RList#r ^ (diagonalAction ( WList#r, for i to ((numRows WList#r) - 1) list m, RList#r))));
        L := for loop to 20 list 
            (toList( 
                timing (
                    gens(RList#r ^ (diagonalAction ( WList#r, for i to ((numRows WList#r) - 1) list m, RList#r)));
                )
            ));
        diagResults := L;
        l = for el in L list round(8,el_0);
        t1 = (sum l / (#l));
        dataFile << (toString t1 | ",");

        print ("- New Alg... ");
        -- Testing our Algorithm
        L = for loop to 20 list 
            (toList(
                timing (
                    diagSub(WList#r, m, RList#r)
                )
            ));
        l = (for el in L list round(8,el_0));
        t2 = (sum l / #l);
        dataFile << (toString t2 | "," | toString (t1/t2) | "\n");
        algInvars = sort (L_0_1);
        ML = for i to min(#diagInvars, #L_0_1) - 1 list (
            if (diagInvars_i != algInvars_i) then (
                false
            ) else true
        );

        for l in L_0_1 do (invarFile << (toString(l) | ","));
        invarFile << "\n";
        for m in diagInvars do (invarFile << (toString(m) | ","));
        invarFile << "\n";
        for ml in ML do (invarFile << (toString(ml) | ","));
        invarFile << "\n";
        print " ";
    );
);

)))_0));

close dataFile;
close invarFile;






