Basics of R Programming Homework Exercises
================
Jeff Hughes
May 09, 2022

#### Exercise 1

If x &lt;- c(“ww”, “ee”, “ff”, “uu”, “kk”), what will be the output for
x\[c(2,3)\]?  
a. “ee”, “ff”  
b. “ee”  
c. “ff”

The output for x\[c(2,3)\] will be “ee”, “ff”.

#### Exercise 2

If x &lt;- c(“ss”, “aa”, “ff”, “kk”, “bb”), what will be the third value
in the index vector operation x\[c(2, 4, 4)\]?  
a. “ss”  
b. NA  
c. “kk”

The third value in the index vector operation x\[c(2, 4, 4)\] will be
“kk”.

#### Exercise 3

If x &lt;- c(“pp”, “aa”, “gg”, “kk”, “bb”), what will be the fourth
value in the index vector operation x\[-2\]?  
a. “aa”  
b. “gg”  
c. “bb”

The fourth value in the index vector operation x\[-2\] will be “bb”.

#### Exercise 4

Let a &lt;- c(2, 4, 6, 8) and b &lt;- c(TRUE, FALSE, TRUE, FALSE), what
will be the output for the R expression max(a\[b\])?

The output for the R expression max(a\[b\]) will be 6.

#### Exercise 5

Let a &lt;- c (3, 4, 7, 8) and b &lt;- c(TRUE, TRUE, FALSE, FALSE), what
will be the output for the R expression sum(a\[b\])?

The output for the R expression sum(a\[b\]) will be 7.

#### Exercise 6

Write an R expression that will return the sum value of 10 for the
vector x &lt;- c(2, 1, 4, 2, 1, NA)

The R expression sum(x\[-6\]) will return a value of 10.  
The R expression sum(x, na.rm = TRUE) will also return a value of 10.

#### Exercise 7

Create a two-dimensional 5×5 array named ‘a’ comprised of sequence of
even integers greater than 25.

``` r
a <- array(seq(26, length.out = 25, by = 2), c(5, 5))
a
```

    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]   26   36   46   56   66
    ## [2,]   28   38   48   58   68
    ## [3,]   30   40   50   60   70
    ## [4,]   32   42   52   62   72
    ## [5,]   34   44   54   64   74

#### Exercise 8

Create three vectors that each contain just 1 element with variable
names p, q, and r, and values 1, 2, and 3. Then, create a new vector
that contains multiple elements, using the scalars we just created.
i.e., create a vector u of length 3, with the subsequent elements of p,
q and r.

``` r
p <- 1
q <- 2
r <- 3
u <- c(p, q, r)
u
```

    ## [1] 1 2 3

#### Exercise 9

Create a longer vector, using the assignment operator (&lt;-), the c()
function, and the vector u we just created (in Exercise 8). Now create a
new vector u with length 30 that contains the elements of u as follows:
1, 2, 3, 1, 2, 3, …., 1, 2, 3

``` r
u <- rep(u, 10)
u
```

    ##  [1] 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3

#### Exercise 10

For this exercise, first write down your answer, without using R. Then,
check your answer using R.\] If x= seq(4,12,4), what is the output for
x?  
The output for x is 4, 8, 12.

#### Exercise 11

If x &lt;- c(1, 3, 5, 7, NA) write an r expression that will return the
output 1, 3, 5, 7.

``` r
x <- c(1, 3, 5, 7, NA)
x[-5]
```

    ## [1] 1 3 5 7

#### Exercise 12

Create a logical vector with length=3, where the sum of vector is 2.

``` r
x <- c(TRUE, FALSE, TRUE)
sum(x)
```

    ## [1] 2

##### Exercise 13

Create a dataframe named cancer by importing the ‘cancer\_survival.csv’
dataset. Print and extract 3rd and 5th rows with 1st and 3rd columns.
What are the values extracted?

``` r
cancer <- read.csv("https://raw.githubusercontent.com/beveratraining/Introduction-to-Data-Science-in-R/main/cancer_survival.csv")
cancer[c(3, 5), c(1, 3)]
```

    ##   age positive_nodes_detected
    ## 3  30                       0
    ## 5  31                       4

``` r
cancer[c(3, 5), c("age", "positive_nodes_detected")]
```

    ##   age positive_nodes_detected
    ## 3  30                       0
    ## 5  31                       4

#### Exercise 14

Work through the tutorial “matrices and data frames upd4\_2022.R”
script. See GitHub location:
<https://github.com/beveratraining/Introduction-to-Data-Science-in-R>
