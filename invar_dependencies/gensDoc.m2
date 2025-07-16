document{
    Key => invariantgens, 

    Headline => "Finds the generating set of invariants under a group action.",

    Usage => "invariantgens(R, W, Z)",

    Inputs => {
        "R"     => PolynomialRing   => {" ring upon which the group action is applied."},
        "W"     => Matrix           => {" the weight matrix representing the group action."},
        "ZList" => Thing               => {"a ", TT "List", " or ", TT "Integer", " representing the dimension of the group action."}
        },    

    Outputs => {
        "N" => List => {"A list of the generating seeds."},
    },

    PARA {"This function returns the generating set of invariants under a group action."},

    SUBSECTION "Examples",
    PARA {"We can use this algorithm in rings of any number of variables. For example, "},
    EXAMPLE {
        "R = QQ[x_0..x_2];",
        "W = matrix{{0,1,1},{1,0,1}};",
        "ZList = {2,2,2};",
        "invariantgens(R, W, ZList)"
    },
    EXAMPLE {
        "R = QQ[v,w,x,y,z];",
        "Zp = 4;",
        "W = matrix{{1,1,1,1,1},{1,1,1,1,0}};",
        "invariantgens(R,W,Zp)"
    }
}

document {
    Key => genseeds, 

    Headline => "Finds the minimal generating seed invariants for an invariant ring.",

    Usage => "genseeds(PolynomialRing, Matrix, List) := (R, W, ZList)",

    Inputs => {
        "R" => PolynomialRing => {"Ring upon which the group action is applied."},
        "W" => Matrix => {"The weight matrix representing the group action."},
        "ZList" => List => {"The list of the dimensions of the weight matrix."}
        },    

    Outputs => {
        "N" => List => {"A list of the generating seeds."},
    },

    PARA {"This function returns the generating seeds that can be used to find all invariants under a group action."},

    SUBSECTION "Examples",
    PARA {"We can use this algorithm in rings of any number of variables. For example, "},
    EXAMPLE {
        "R = QQ[x_0..x_2];",
        "W = matrix{{0,1,1},{1,0,1}};",
        "ZList = {2,2,2};",
        "genseeds(R,W,ZList)"
    }
}

document {
    Key => expandseeds, 
    Headline => "Expands a complete set of seed generators to create the minimal generating set of an invariant ring.",
    Usage => "expandseeds(R,W,ZList)",
    Inputs => {
        "L" => List => {"seeds that can be used to generate the ring of invariants."},
        "ZList" => List => {"dimensions of the weight matrix."}
    },    

    Outputs => {
        "Basis" => List => {"set of generators for the ring of invariants under a group action."},
    },

    PARA {"This function returns the set of generators for a ring of invariants."},

    SUBSECTION "Examples",
    PARA {"We can use this algorithm in rings of any number of variables, but the dimensions of the weight matrix utilized must be known. For automatic utilization, either use the ", TT "invargenset", " method, or combine with the ", TT "genseeds", " method."},
    EXAMPLE {
        "R = QQ[v,w,x,y,z]",
        "ZList = {3,3,3,3,3};",
        "expandseeds({v^2 * y, w^2 * y, x^2 * y}, ZList)"
    },


    SUBSECTION {"Ways to use ", TT "expandseeds", "."},
    UL {
        CODE {"expandseeds(R, W, ZList)"}
    }

}
