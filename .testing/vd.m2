-- variable definitions that can be used for testing

listIt = method();
listIt := (n) -> (for i to n - 1 list random(ZZ)%2);

RList = {
    QQ[a..c], 
    QQ[a..e], 
    QQ[a..g]
};
g = for i in RList list (numgens i);

WList = {
    matrix{{0,1,1},{1,0,1}},
    matrix{{1,1,1,1,1},{1,1,1,1,0}},
    matrix{listIt(g#2), listIt(g#2), listIt(g#2)}
};
PrimeList = {
    2, 3
};