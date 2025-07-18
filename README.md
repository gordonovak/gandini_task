# im very tired
This repository holds the components for the generation and growth algorithms, with all of their respective versions.

You might think the naming convention of the files is bad, but if you use the ```tab``` key to autofill in the terminal, it's actually faster than typical file names. try it :p 

Also there's no documentation yet. Whoops. 
***
### Generation Algorithms
Please note that:
* ```gen``` stands for generation (as in seed generation).
* ```pxp``` stands for $\mathbb Z_p \times \mathbb Z_p$. 
* ```vX``` stands for "version X"

The latest version is usually the best, but each outputs something different so please be selected with it. 

1. ```gen-pxp-v1.m2``` - the first generation iteration that "worked." sometimes misses some invariants but is relatively accurate. returns a list of polynomials in $R$. 
2. ```gen-pxp-v2.m2``` - this one now starts using matricies and exporting the results in matrix form instead of polynomial form to optimize efficiency. returns a list of matricies $1\times n$. 
3. ```gen-pxp-v3.m2``` - converts all the matricies to lists, because matricies in macaulay2 are actually really slow. returns a list of lists (that represent exponent vectors.)
3. ```ZModVec.m2``` - the original method we came up with using all possible vectors in $\mathbb Z_2$. 

***

### Growth Algorithms
All of these return a list of invariants in polynomial form (in $R$).
* ```gro``` stands for growth (as in seed growth)
1. ```goriginal.m2``` - lucas' original algorithm. only works in 3-variate case and not always. 
2. ```gro-pxp-v0.m2``` - our first adaptation of the algorithm. works fine. misses invariants some of the time. returns a list of polynomials in $R$. 
3. ```gro-pxp-v1.m2``` - first interation of the algorithm that gets all the invariants. returns a list of polynomials in $R$. 
4. ```gro-pxp-v2.m2``` - first iteration of the algorithm to start implementing speed-oriented optimizations. because of this, it ends up missing a bunch of invariants. **oops**.
5. ```gro-pxp-v3.m2``` - changes the polynomials to matricies and this speeds up performance. However, then I focused on getting all the invariants and that slowed the algorithm *way* down. 
6. ```gro-pxp-v4.m2``` - this one changes out the matricies for list and is very efficient compared to the diagonalAction implementation in the ```InvariantRing``` package. *hooray*. 
7. ```test.m2``` - please ignore this. thanks

***

### Combination algorithms
These algorithms combine the growth and generation algorithms together for greater efficiency, as they share memory, assets, and strategies for solving. Also very helpful for the testing in the ```.testing``` directory. 
* ```com``` stands for combination (as in combination algorithm)
* ```vA-(vB-vC)``` stands for:
  * ```vA``` - the Ath version of the **combination** algorithm
  * ```vB``` - the Bth version of the **generation** algorithm
  * ```vC``` - the Cth version of the **growth** algorithm

    I ordered it like this because it's helpful to know at a glance what algorithms are in the combination algorithm. 
1. ```com-pxp-v1-(v2-v3).m2``` - first iteration and attempt at combining the algorithms. contains algorithms that don't work, but it's pretty efficient, so i guess there's that
2. ```com-pxp-v2-(v3-v4).m2``` - this algorithm works, and it's fast too. it utilizes the restructuring using lists throughout everything, so that's great. 
3. ```coriginal.m2``` - the original combination algorithm developed during the Madison Macaulay2 workshop. It's fine. 

***

### Testing
You can look inside the ```.testing``` folder for how i testing a lot of the stuff. the output is in ```.csv``` files so it makes it super easy to view and share and compare with the ```InvariantRing => diagonalAction``` method that's currently implemented. 

Note that the ```vd.m2``` is just meant to store variables for testing. Unless you want to add additional rings and orders to test, there's not much reason to go in there. 