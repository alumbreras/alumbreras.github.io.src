# Un Antonio Banos
N <- 1

# una urna con 3030 papeletas numeradas
papeletas <- 1:3030

# Simula muchas, muchas asambleas
M <- 100000
asambleas <- data.frame(matrix(0,M,1))
names(asambleas) <- "papeleta"
for (i in 1:M){
  asambleas[i,] <- sample(papeletas, N)
}
hist(asambleas$papeleta, breaks = 100, probability=TRUE, 
     xlab="Papeleta ganadora", ylab="probabilidad (sobre 1)", 
     main="100000 asambleas de la CUP")

# probabilidad de empate
empates <- sum(asambleas$papeleta==1515)
probabilidad_empate <- empates/M
cat("Probabilidad de empate:", probabilidad_empate*100)

###################################################################################

# N cupaires
N <- 3030

# con un debate muy ajustado
probabilitat_si <- 0.5
probabilitat_no <- 1 - probabilitat_si

# Simula muchas, muchas asambleas
M <- 100000
asambleas <- data.frame(matrix(0,M,2))
names(asambleas) <- c("sies", "noes")
for (i in 1:M){
  votos <- sample(c("si", "no"), N, replace=TRUE, prob=c(probabilitat_si,probabilitat_no))
  sies <- sum(votos=="si")
  noes <- sum(votos=="no")
  asambleas[i,] <- c(sies, noes)
}
hist(asambleas$sies, breaks = 100)
hist(asambleas$sies, breaks = 100, probability=TRUE, 
     xlab="Numero de sies", ylab="probabilidad (sobre 1)", 
     main="100000 asambleas de la CUP")

# probabilidad de empate
empates <- sum(asambleas$sies==1515)
probabilidad_empate <- empates/M
cat("Probabilidad de empate:", probabilidad_empate*100)

##################################################################################
# N cupaires
N <- 3030

# 80% ya llegan con el voto decidido.
si_fijos <- 1212 # 3030*0.4
no_fijos <- 1212 # 3030*0.4

indecisos <- N - si_fijos - no_fijos

# con un debate muy ajustado
probabilitat_si <- 0.5
probabilitat_no <- 1 - probabilitat_si

# Simula muchas, muchas asambleas
M <- 100000
asambleas <- data.frame(matrix(0,M,2))
names(asambleas) <- c("sies", "noes")
for (i in 1:M){
  votos <- sample(c("si", "no"), indecisos, replace=TRUE, prob=c(probabilitat_si,probabilitat_no))
  sies <- sum(votos=="si") + si_fijos
  noes <- sum(votos=="no") + no_fijos
  asambleas[i,] <- c(sies, noes)
}
hist(asambleas$sies, breaks = 100)
hist(asambleas$sies, breaks = 100, probability=TRUE, 
     xlab="Numero de sies", ylab="probabilidad (sobre 1)", 
     main="100000 asambleas de la CUP")

# probabilidad de empate
empates <- sum(asambleas$sies==1515)
probabilidad_empate <- empates/M
cat("Probabilidad de empate:", probabilidad_empate*100)

