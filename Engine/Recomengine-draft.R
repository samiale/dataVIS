# Load dataset
#install.packages("arules")
library("arules")
data("Groceries")

# Load combination helper
#install.packages("gtools")
#library("gtools")

# Unique users
users <- as(Groceries, "list")

# Item list
itemlist <- Groceries@itemInfo$labels

# Generate association rules for each and every items
# Using a confidence of 0.5 and support of 0.01
rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.5))

# Associate rules to specific items
# i <- 1
# itemrules <- list()
# while (i <= length(itemlist))
# {
#  itemrules[[i]] <- subset(rules, subset = rhs %in% itemlist[i])
#  i <- i+1
# }

# recommandations <- function(transaction, rules)
# {
#   if(length(transaction) > 1)
#   {
#     combinmtx <- combinations(length(transaction), 2)
#     userrules <- list()
#     i <- 1
#     while (i <= nrow(combinmtx))
#     {
#       #sprintf("Testing %s with %s", transaction[combinmtx[,1]], transaction[combinmtx[,2]])
#       userrules[[i]] <- subset(rules, subset = lhs %in% transaction[combinmtx[i,1]] & lhs %in% transaction[combinmtx[i,2]]))
#       i <- i+1
#     }
#   }
#   
#   return(userrules)
# }

recommendations <- function(transaction, rules)
{
  userrules <- subset(rules, subset = lhs %in% transaction)
  return(userrules@rhs@itemInfo$labels[userrules@rhs@data@i+1])
}