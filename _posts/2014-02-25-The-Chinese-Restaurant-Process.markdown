---
layout: post
title: The Chinese Restaurant Process
tags: tutorials
---

The [Chinese Restaurant Process][] is a prior for the likelihoods of clustered data. 
Let $$\mathbf{z}$$ be the cluster assignments of users. 
Let  $$K$$ be the number of clusters and let $$\boldsymbol{\pi}$$ be a vector 
of size $$K$$, indicating the probability of being assigned to cluster $$k$$. 
If we put a Dirichlet prior on $$\boldsymbol{\pi}$$ , we have:

$$
\begin{align}
\mathbf{z} &\sim \text{Multinomial}(\boldsymbol{\pi})\notag\\
\boldsymbol{\pi} &\sim \text{Dirichlet}(\alpha)
\end{align}
$$

Assuming that $$\alpha$$ is a fixed parameter, the joint probability of 
$$\mathbf{z}$$ and $$\boldsymbol{\pi}$$ is:

$$
\begin{align}
p(\mathbf{z}, \boldsymbol{\pi}) = 
p(\mathbf{z} | \boldsymbol{\pi})p(\boldsymbol{\pi} | \alpha)
\end{align}
$$

If we integrate out $$\mathbf{\pi}$$, we get the marginal probability of $$\mathbf{z}$$:

$$
\begin{align}
p(\mathbf{z}) &=
\int_{\boldsymbol{\pi}} 
   p(\mathbf{z} | \boldsymbol{\pi}) 
   p (\boldsymbol{\pi} | \alpha) =
\int_{\boldsymbol{\pi}} 
   \prod_{i=1}^K \pi_i^{n_i} 
   \frac{1}{B(\alpha)}
   \prod_{j=1}^K \pi_j^{\alpha-1}
\end{align}
$$

Renaming $$\alpha+n_i$$ as $$\alpha_i'$$, multiplying and dividing by 
$$B(\boldsymbol{\alpha'})$$, and rearranging the elements so that it is 
visually clear, we get:

$$
\begin{align}
p(\mathbf{z})=
\frac{
B(\boldsymbol{\alpha'})
}{
B(\alpha)
}
\int_{\boldsymbol{\pi}}  
   \frac{1}{B(\boldsymbol{\alpha'})}
   \prod_{i=1}^K \pi_i^{\alpha_i' - 1}
\end{align}
$$

where the value of the integral is 1, since the factor inside is a Dirichlet density function. Expanding the definition of the Beta function, we get:

$$
\begin{align}
p(\mathbf{z})=
\frac{
\prod_{i=1}^K \Gamma(\alpha_i + n_i)
}
{
\Gamma \left(\sum_{i=1}^K \alpha_i + n_i \right)
}
\frac{
\Gamma \left(\sum_{i=1}^K \alpha_i \right)
}
{
\prod_{i=1}^K \Gamma(\alpha_i)
}
\end{align}
$$

Note that the presence of the counts $$n_i$$ makes it impossible to factorize 
$$p(\mathbf{z})$$ into the product of the individual $$z$$. 
However, we can derive the conditional probability of one $$z_u$$ given 
all the other assignments:

$$
\begin{align}
p(z_u = j| \mathbf{z_{-u}}) =
\frac{p(\mathbf{z})}
{p(\mathbf{z_{-u}})}
\end{align}
$$

To compute the denominator we assume cluster assignments are exchangeable, 
that is, the joint distribution $$p(\mathbf{z})$$ is the same regardless 
the order in which clusters are assigned. This allows us to assume that 
$$z_u$$ is the last assignment, therefore obtaining $$p(\mathbf{z_{-u}})$$ 
by considering how was the equation $$p(\mathbf{z})$$ before $$z_u$$ was 
assigned to cluster $$j$$. 

$$
\begin{align}
p(\mathbf{z_{-u}}) = 
\frac
{
\Gamma(\alpha_j + n_j-1)
\prod_{i\neq j}^K \Gamma(\alpha_i + n_i)
}
{\Gamma
\left(
\alpha_j + n_j -1 + \sum_{i\neq j}^K \alpha_i + n_i 
\right)
}
\frac{
\Gamma \left(\sum_{i=1}^K \alpha_i \right)
}
{
\prod_{i=1}^K \Gamma(\alpha_i)
}
\end{align}
$$

Plugging $$p(\mathbf{z}_{-u})$$ and $$p(\mathbf{z})$$ into $$p(z_u \vert \mathbf{z}_{-u})$$, we get:

$$
\begin{align}
p(z_i = j| \mathbf{z_{-u}}) 
&\propto
\frac{
\prod_{i=1}^K \Gamma(\alpha_i + n_i)
}
{
\Gamma \left(\sum_{i=1}^K \alpha_i + n_i \right)
}
\frac
{\Gamma
\left(
\alpha_j + n_j -1 + \sum_{i\neq j}^K \alpha_i + n_i 
\right)
}
{
\Gamma(\alpha_j + n_j-1)
\prod_{i\neq j}^K \Gamma(\alpha_i + n_i)
}\\
&=
\frac{
\Gamma(\alpha_j + n_j)
\prod_{i \neq j }^K \Gamma(\alpha_i + n_i)
}
{
\Gamma \left(\sum_{i=1}^K \alpha_i + n_i \right)
}
\frac
{\Gamma
\left(
\alpha_j + n_j -1 + \sum_{i\neq j}^K \alpha_i + n_i 
\right)
}
{
\Gamma(\alpha_j + n_j-1)
\prod_{i\neq j}^K \Gamma(\alpha_i + n_i)
}\\
&=
\frac{
\Gamma(\alpha_j + n_j)
}
{
\Gamma \left(\sum_{i=1}^K \alpha_i + n_i \right)
}
\frac
{\Gamma
\left(
\alpha_j + n_j -1 + \sum_{i\neq j}^K \alpha_i + n_i 
\right)
}
{
\Gamma(\alpha_j + n_j-1)
}
\end{align}
$$

Assuming that all $$\alpha_i$$ have the same value $$\alpha$$, and since the sum of all $$n_i$$ is $$U$$:

$$
\begin{align}
p(z_i = j| \mathbf{z_{-u}}) 
&\propto
\frac{
\Gamma(\alpha + n_j)
}
{
\Gamma \left(K \alpha + U \right)
}
\frac
{\Gamma
\left(
K\alpha_j +U -1
\right)
}
{
\Gamma(\alpha_j + n_j -1)
}
\end{align}
$$

and finally exploiting the fact that $$a \Gamma(a) = \Gamma(a+1)$$:

$$
\begin{align}
p(z_i = j| \mathbf{z_{-u}}) 
&\propto
\frac
{\alpha + n_j}
{K \alpha + U -1}
\end{align}
$$

we can reparametrize $$\alpha$$ as $$\alpha/K$$. Then we have the standard result:

$$
\begin{align}
p(z_i = j| \mathbf{z_{-u}}) 
&\propto
\frac
{\alpha/K + n_j}
{\alpha + U -1}
\end{align}
$$

where $$n_j$$ is the number of users in cluster $$j$$ before the assignment of $$z_u$$.

The Chinese Restaurant Process is the consequence of considering $$K \rightarrow \infty$$. 
For clusters where $$n_j>0$$, we have:

$$
\begin{align}
p(z_i = j| \mathbf{z_{-u}}) 
&\propto
\frac
{n_j}
{\alpha + U -1}
\end{align}
$$

and the probability of assigning $$z_u$$ to any of the (infinite) empty clusters is: 

$$
\begin{align}
p(z_i = j| \mathbf{z_{-u}}) 
&\propto
K\frac
{\alpha/K}
{\alpha + U -1} = 
\frac
{\alpha}
{\alpha + U -1} 
\end{align}
$$

which written in a compact equation is:

$$
\begin{align}
p(z_u = j | \mathbf{z_{-u}}, \alpha) = 
\begin{cases}
\frac{n_{-u,j}}{U - 1 + \alpha}& \text{if } n_{-u,j}>0 \\
\frac{\alpha}{U-1 + \alpha}& \text{if } n_{-u,j}=0
\end{cases}
\end{align}
$$



[Chinese Restaurant Process]: http://en.wikipedia.org/wiki/Chinese_restaurant_process
