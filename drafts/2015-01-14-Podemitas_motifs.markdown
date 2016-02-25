---
title: Analyzing the neighborhoods of user posts
tags: drafts
---

In this post (work in progress), I will cluster Podemos forum users  according to the graphs around their posts. The idea is to find which groups of users tend to participate (more than the average) in cascades, which ones tend to participate (more than the average) in stars, and son on.
 
As in the previous post, I will use the threads written on January 2015 on the [Reddit subforum of Podemos](https://www.reddit.com/r/podemos). The podemos forum (a.k.a subreddit) contains 995 discussion threads that started on January. These threads contain a total of 12912 posts written by 1218 users.

#### Discussion trees

A very natural to represent a conversation thread is a tree where vertices represent posts and edges represent replies from some post to another. Let us see some of the discussions of our dataset:


<p align="center">
<img src="../images/2015-01-15-tree1.png" width="300px">
<img src="../images/2015-01-15-tree2.png" width="300px">
<img src="../images/2015-01-15-tree12.png" width="300px">
</p>
<p align="center">
<img src="../images/2015-01-15-tree38.png" width="300px">
<img src="../images/2015-01-15-tree40.png" width="300px">
<img src="../images/2015-01-15-tree41.png" width="300px">
</p>

#### Motifs in discussion trees

Imagine we take one post $p$ as well as it neighborhood of posts and we create a graph from that. I will call this subgraph a `motif`. I would like to count, for every user, the different motifs around their posts given a neighborhood radius $R$. Unfortunatelly this concept of neighborhood based on distances has an infinite number of possible graphs. Both trees in the below image represent two possible neighborhoods of the red vertex (the white vertex represents the root post of the thread):

<p align="center">
<img src="../images/2015-01-15-large_neighborhood.png" width="300px">
<img src="../images/2015-01-15-short_neighborhood.png" width="300px">
</p>

<!---OLD: if the original neighborhood has more than $M$ vertices we will keep only the $M$ that are closest in time to the post $p$.-->
To reduce our space of possible neighborhoods we will introduce the concept of *temporal neighborhood*: if post $p$ was written at time $t$, the temporal neighborhood (of radius $R$) of a $p$ is the set of $R$ posts in its *spacial neighborhood* that were written in a time closest to $t$ (and where closeness is computed as $|t_i-t|$) and where the posts in the shortest path from each neighbour and $p$ belong also to the *temporal neighborhood*.

With this in mind, we count the *temporal neighborhoods* of every user's posts. To make it funnier (and more fine-grained), we will also put a color (white) on the root post. For a spacial neighborhood of radius $1$ and a temporal neighborhood of radius $4$ we obtain:

<p align="center">
<img src="../images/2016-01-15-motifs_1_4.png" width="600px">
</p>

We can play the the spacial and the temporal radius. Let's see what happens if we set both radius to $4$:

<p align="center">
<img src="../images/2016-01-15-motifs_4_4.png" width="600px">
</p>
where I named the neighborhoods to help the intuition.

(**Question**: how come *spot* is the most frequent? How is it possible to have no neighbors at all? Or what might be wrong?)

#### Clustering users with respect to their neighborhoods

Given the neighborhoods in which each user participates, we will analyze whether there exists different types of users or all users look similar.  

We want to make the analyse independent of the number of posts, and for that we normalize each user feature vector so that features indicate the percentage of posts in this kind of neighborhood. Moreover, some neighborhoods are much more common than others due to the nature of the forums. Thus, we normalize and scale the features so that every feature has a global mean 0 and variance 1. Features now represent *z-scores*, that is, how many standard deviations is this user feature away from the mean.

We will use a simple *k-means* to find the clusters. To decide the number of clusters, we run *k-means* for $k=2,...,25$ clusters and look at the  *Within-Cluster Sum of Squares*.
<p align="center">
<a href="../images/2016-01-15-elbow2.png"> 
<img src="../images/2016-01-15-elbow2.png" width="600px">
</a>
</p>
We choose 5 clusters to keep thinks simple. We re-run the k-means for $k=5$ (see the [colored scatter matrix](../images/2016-01-15-ggpairs.png)) and then plot the scatter matrix of every pair of variables, where colors correspond to the clusters. Let's plot a couple of PCA projections (with two different libraries) over the first two components:
<p align="center">
<a href="../images/2016-01-15-PCA.png">
<img src="../images/2016-01-15-PCA.png" width="450px">
</a>
<a href="../images/2016-01-15-PCA2.png">
<img src="../images/2016-01-15-PCA2.png" width="450px">
</a>
</p>

PCA only let us see a low-dimensional projection of our data. To explore the data in all the original dimensions we can use whisker plots:
<p align="center">
<a href="../images/2016-01-15-whiskers.png">
<img src="../images/2016-01-15-whiskers.png" width="600px">
</a>
</p>


### Making sense of it

From the plots above, let's try to describe every group:

**Spotters** 

  * Light blue. Salient motif: *spot*
  * Spotters are seen isolated, without neighborhoods. This doesn't seem to have sense and needs more analysis.

**Bifurcators**

  * Red. Salient motif: *CCB*
  * Bifurcators have a special tendency to participate in bifurcations that are placed deeper in the conversation.


**Answerers**

  * Green. Salient motif: *CA3* *SA*
  * Answerers are seen replying to the main post along with other people (CA3) and sometimes getting even some reply (SA).

**Catalyzers**

  * Pink. Salient motif: *CIA* 
  * Catalyzers are seen answering to the root and then being followed by a chain.

**Common People**

  * Light blue. No salient motif.
  * Common people do not stand out on any kind of neighborhood. Since they are among the active users (like all the analyzed users) they might not play any central role but they might be necessary for the health of the forum.

**Lurkers**

  * Less than 10 posts during the observation period.
  * All users with less than ten posts in this dataset are considered as lurkers. No explicit role is assigned to them since we have not enough data.

### Participations of roles in threads

Although we focused on structural motifs (neighborhoods), it's interesting to see whether there is some roles tend to participate in longer or shorter threads. If we plot a scatter plot of participation role (the role of the post author) vs thread length, we observe that *lurkers* and *spotters* are observed in shorter threads, through the means are not very different.
<p align="center">
<a href="../images/2016-01-15-whiskers_roles_vs_length.png">
<img src="../images/2016-01-15-whiskers_roles_vs_length.png" width="600px">
</a>
</p>


We can also plot the proportion of roles in every thread and the proportion of roles in the first 10 posts of every thread:
<p align="center">
<a href="../images/2016-01-15-thread_role_composition.png">
<img src="../images/2016-01-15-thread_role_composition.png" width="450px">
</a>
<a href="../images/2016-01-15-thread_role_composition_nfirst.png">
<img src="../images/2016-01-15-thread_role_composition_nfirst.png" width="450px">
</a>
</p>


### Co-participation network of roles

Future:
- [] co-participation of roles
- [] roles as predictors of thread length
