source("Clustering.Util.R")
library(cluster)
library(e1071)
library(xtable)
library(factoextra)

D <- dataset
cbind(data.frame(id=1:nrow(D),D))

set.seed(23)
# Przykładowy zbiór
D <- data.frame(x1 = c(5, 3.5, 3, 3.3, 4, 4, 6, 4.5, 3, 5, 7, 5.5),
                x2 = c(50, 25, 9, 30, 9, 27, 75, 45, 34, 80, 90, 60),
                Class = c(1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1))
#D$x1 <- D$x1 + rnorm(nrow(D))
#D$x2 <- D$x2 + rnorm(nrow(D), mean = 0, 10)
D$Class <- as.factor(D$Class)

D[, -3] <- scale(D[, -3])

# Nowy przykład
newExample = data.frame(x1=-1, x2=0.5, Class=0)

# Wizualizacja
ggplot(D, aes(x1, x2, label = 1:nrow(D))) +
    geom_point(aes(shape = Class), size = 4)
    #+ xlim(-2.5, 3.5) + ylim(-2.5, 3.2)

# Grupowanie
clustering = kmeans(D[, -3], 2)

# Wizualizacja
fviz_cluster(clustering, data = D[, -3], geom = "point", stand = FALSE) +
    geom_point(aes(shape = D$Class), size = 4)

# Transformacja
list[train, test] = addClusteringFeatures("km", D, newExample, "distance", FALSE, 2, "euclidean", FALSE, TRUE, FALSE)

# Wizualizacja
ggplot(train, aes(C1, C2)) +
    geom_point(aes(shape = Class), size = 4)

# Uczenie
model <- glm(Class ~., family=binomial(link='logit'), data=train)

# Wizualizacja
slope <- coef(model)[2]/(-coef(model)[3])
intercept <- coef(model)[1]/(-coef(model)[3]) 

ggplot(train, aes(C1, C2)) +
    geom_point(aes(shape = Class), size = 4) +
    geom_abline(intercept = intercept, slope = slope)

# Wizualizacja nowego przykładu w oryginalnej przestrzeni
ggplot(D, aes(x1, x2)) +
    geom_point(aes(shape = Class), size = 4) +
    geom_point(data = newExample, aes(shape=factor(3))) +
    scale_shape_manual(values=c(16, 17, 8))

# Wizualizacja w przestrzeni klastrów i predykcja
ggplot(train, aes(C1, C2)) +
    geom_point(aes(shape = Class), size = 4) +
    geom_point(data = test, aes(shape=factor(3))) +
    scale_shape_manual(values=c(16, 17, 8)) +
    geom_abline(intercept = intercept, slope = slope)
