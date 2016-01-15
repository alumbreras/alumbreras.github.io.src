#################################
# Example of Rejection Sampling
#################################

library(ggplot2)

# Define nasty function
f <- function(x){ x^2/exp(x)}
x <- seq(0,10,0.01)

xmin <- 0
xmax <- 10

C <- 15 # garantees that envelope is always higher than f
# Sample from envelop distribution
renvelope <- function(n){runif(n,xmin,xmax)}
denvelope <- function(x){C*dunif(x,xmin, xmax)}

df <- data.frame(x=x, f=f(x), q=denvelope(x))
gg <- ggplot(df, aes(x=x)) + 
      geom_line(aes(y=f, color="real")) + 
      geom_line(aes(y=q, color="envelop")) +
      theme(legend.title=element_blank()) +
      ggtitle("real and envelop distribution")
print(gg)    

nsamples <- 10000

# Sample from envelop distribution
samples <- renvelope(nsamples)

# Sample from uniform distribution
u <- runif(nsamples)

accept <- u < f(samples)/denvelope(samples)
accept <- as.numeric(accept)

df = data.frame(sample = samples, accept = factor(accept, levels= c(1,0)))

gg<- ggplot(df, aes(x=df$sample)) + 
     geom_histogram(aes(fill = accept), binwidth=0.1) + 
     ggtitle("Samples")
            
print(gg)

cat("Acceptance ratio:", sum(accept)/length(accept))