library(Matrix)

montyhall <- function(k) {
  
  episodes <- as(rbind(rep(c(1, 0, 0), k), rep(c(0, 1, 0), k), rep(c(0, 0, 1), k)), "sparseMatrix") # sample 3k episodes
  episodes <- episodes[ , sample(ncol(episodes))] # shuffle for realism
  
  # contestant picks ex ante
  firstpick <- sample(1:3, k * 3, replace = T)
  
  left <- left2 <- rbind(rep(NA, k * 3), rep(NA, k * 3))
  noswitchwins  <- switchwins  <- rep(0, k * 3)
  noswitchwins2 <- switchwins2 <- rep(0, k * 3)

  # 1. show host takes away one of the zeros you did not pick
  
  left <- sapply(1:(3*k), function(j) {
                    if (firstpick[j] == which(episodes[, j] == 1)) {
                      rbind(episodes[firstpick[j], j], episodes[sample(which(episodes[, j] != 1), 1), j])
                    } else {
                      rbind(episodes[firstpick[j], j], episodes[which(episodes[, j] == 1), j])
                    }})
  
  # 2. show host takes away one of the boxes you did not pick - may be the winning one!
  
  left2 <- sapply(1:(3*k), function(j) rbind(episodes[firstpick[j], j], episodes[sample(setdiff(1:3, firstpick[j]), 1), j]))

  # 1. no switch 
  noswitchwins  <- left[1, ] == 1
  
  # 1. switch to the other remaining box, which is always in the lower row of left[, j]
  switchwins    <- left[2, ] == 1
  
  # 2. no switch 
  noswitchwins2 <- left2[1, ] == 1
  
  # 2. switch to the other remaining box, which is always in the lower row of left[, j]
  switchwins2   <- left2[2, ] == 1
  
  # sample proportion of episodes where the host does not take out the winning box.
  a <- mean(colSums(left2) == 1)
  
  # for case 2., we divide by  by the sample proportion of episodes where the host does not take out the winning box, to obtain the POSTERIOR probability of winning. 
  return(list(ns1 = mean(noswitchwins), s1 = mean(switchwins), ns2 = mean(noswitchwins2) / a, s2 = mean(switchwins2) / a))
  
} 


k <- seq(from = 1, to = 1001, by = 25)
results <- sapply(k, montyhall)

dev.new(height = 12, width = 15)
matplot(1:ncol(results), t(results),type="l",col=c("red","blue","green","orange"), lty=c(1,1,1,1), 
        lwd = c(2,2,2,2), ylab = "Share of wins", xlab = "Number of Episodes", axes = F)
abline(1/3, 0)
abline(1/2, 0)
abline(2/3, 0)
axis(2, at = seq(0, 1, 0.05))
axis(side=1, at=1:((5 * floor(ncol(results) / 5))+1), labels=c(3*(k - 1)))
legend("bottom", c("no switch - host knows", "switch - host knows", "no switch - host doesn't know", "switch - host doesn't know"),cex=0.8, fill = c("red","blue","green","orange"), ncol = 4, bty = "n")

