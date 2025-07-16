## Algorithm Details
***
#### ```invariantgens.m2```
The $\text{invariantgens}$ algorithm takes three inputs:
* $R$, the ring being acted upon.
* $W$, a weight matrix representing the group action on the ring.
* $\mathbb Z_p$, the order of the elementary abelian $p$-group.

Then, it has one output:
* $L$, a list of the minimal generating elements of the invariant ring. 

In order to make this algorithm functional, it utilizes the ```expandseeds.m2``` code and the ```genseeds.m2``` code. 

##### ```genseeds.m2```
The $\text{genseeds}$ algorithm takes three inputs:
* $R$ the ring
* $W$, the full rank n $\times$ m weight matrix representing the group action. (m $\geq$ n)
* $\mathbb Z$-$\text{list}$, the list representing the dimensions of the $p$-group. 

Then, the algorithm has one output:
* $L$, a list of the generating seeds.

```genseeds``` inputs a weight matrix $W$ thats linearly independent, so $\text{dim(ker}(W)) = m-n.$ 
First we find one $n \times m$ sub matrix $A$ at such that $\det(A) \ne 0.$ 

Now we can create $m-n$, $n \times n+1$ sub matrices. by taking our full-rank $n\times n$ sub-matrix $A$, than adding a column vector in $W$ not in $A$. That will give us $m-n$ choices for our sub matrices.

Let $W_S$ be a sub matrix of $W,$ where $S$ is a the set of indices corresponding to the columns of $W$. For each $W_S$ we claim we can create a vector $\bar v_S$ such that all row vectors in $r_m \in W$ we have that $r_m \cdot \bar v_S =0$. We can define:

$$\bar v_S = \sum_{a_i \in S} (-1)^{i+1}e_{a_i}p_{\hat{a_i}}.$$

Then, $\bar v_S$ is an exponent vector, where for a component $v_i$, our resultant invariant for the ring $\mathbb K[x_1 \cdots x_n]$ is: 

$$f(x_1 \, ... \; x_n) = \prod_{i=1}^n x_i^{v_i}.$$

##### ```expandseeds.m2```
After the seeds have been generated, the $\text{expandseeds}$ algorithm takes in two inputs:
* $L$, a list of the generating seeds
* $\mathbb Z$-$\text{list}$, a list of the dimensions of the weight matrix.

Then, it will output:
* $\text{Basis}$, a list containing the generators of the invariant ring. 

In order to perform the expansion, ```expandseeds.m2``` performs the following algorithm:
1. Add the generating seeds to $\text{Basis}$. 
2. Multiplies the generating seeds to powers of themselves, and then mods out by the respective value in $\mathbb Z$-$\text{list}$. This operation is repeated a number of times equal to the number of generators of the ring, $R$. 
3. Then, it adds the pure powers to the generating set $\text{Basis}$. 
4. Finally, it performs a minimization algorithm to reduce elements that can be created by other elements.

For more details, please refer to the comments in the code itself. 
***

#### ```modVector.m2```
The $\text{Abelian Skew Invariants}$ algorithm takes two inputs:
* $W$, finite abelian group
* $R$, a ring

This gives us one output: 
* $L$, a list of the invariants of $W$ over $R$. 

Our algorithm is as follows:
1. Calculate all possible vectors $\bar v_{z}\in \mathbb Z_2 \times \,...\times \mathbb Z_2$ of length $\ell$.  
$\ell$ is the number of columns in our weight matrix, $W$. 
2. Perform the operation $f=W\cdot\bar v_z$. 
3. If $f\;\text{mod } p$ contains all $0$ entries, the exponent vector $\bar v_z$ is invariant, and add it to the list of invariants. 
Here, $p$ is the respective size of the cyclic factor of the weight matrix. 
4. Then, we compute the resultant invariants from the list of invariant exponent vectors.
***
#### ```spoiled_invariantgens.m2```
This file is a different version of the algorithm from the ```invariantgens.m2``` file. 

The $\text{spoiled-invariantgens}$ algorithm takes three inputs:
* $R$, the ring being acted upon.
* $W$, a weight matrix representing the group action on the ring.
* $p$, the order of the elementary abelian $p$-group.

Then, it caculates the all possible determinants of the square submatricies of $W$. 
We then extract the coefficients of the determinant of the submatrix and mod them out by $p$, and store the result in a list. 
Finally, we remove redunancies from the list and return it. 
