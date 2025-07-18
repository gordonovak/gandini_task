toPoly := (m) -> (
    n = 1;
    Re = QQ[v..z];
    Reg = gens Re;
    print m;
    for i to (#m - 1) do (
        n = n*((Reg_i)^(m_i))
    );
    return n;
)

n =10000;

print((toList(timing (
for k to n do (

{{1,1,1,1,1,1,1,1}} == {{1,1,1,1,1,1,1,1}}

))))_0);

print((toList(timing (
for k to n do (

matrix{{1,1,1,1,1,1,1,1}} == matrix{{1,1,1,1,1,1,1,1}}

))))_0);
