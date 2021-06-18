########
# PART 1
########

# Download the arules package from CRAN site https://cran.r-project.org/ (Links to an external site.)  and load it in RStudio
install.packages("arules")
library("arules")
# Load the Groceries data set that comes with the arules package
data("Groceries")

# Use the R functions that you have already seen in class to explore the data set in order to answer the following questions:
# How many items are in the data set?
ncol(Groceries)
# Or
length(Groceries@itemInfo$labels)

# How many transactions are in the data set?
nrow(Groceries)

# Calculate the density value
summary(Groceries)

# Give the interpretation of this density value
# The matrix contains 2,6% of non-zero cells.

# Which are the most commonly found items in the data set?
items_freq = as.data.frame(table(Groceries@data@i))
items_freq$label = Groceries@itemInfo$labels
head(items_freq[order(-items_freq$Freq),],10)

# What percentage of transactions contain yogurt ?
itemFrequency(Groceries)[["yogurt"]]*100
# Or
items_freq$Freq[which(items_freq$label=="yogurt")]/nrow(Groceries)*100

# How many transactions have only seven items ?
Groceries[which(size(Groceries) == 7)]

# How many transactions have two items ?
Groceries[which(size(Groceries) == 2)]

# What is the average number of items in a transaction ? 
mean(size(Groceries))

# Bonus: Own analysis
# Most items in a transaction:
max(size(Groceries))

# Median amount of items in transactions:
median(size(Groceries))

# Which R function will you use to display transactions 4 to 8.
LIST(Groceries)[4:8]
# Or
as(Groceries,"list")[4:8]

# Which R function will you use to see the proportion of transactions that contain the first item:
subset(Groceries, items %in% as(Groceries,"list")[[1]][1])

# Which R function will you use to view the proportion of transactions that contain a number of other items (for example items 3 to 7)
Inspect(Groceries[3:7])

# Which R function will you use to visually display the proportion of transactions containing items that have at least 15% support
itemFrequency(Groceries,type="relative")[as.numeric(itemFrequency(Groceries,type="relative")) > 0.15]

# Display the proportions of the top 10 items
itemFrequency(Groceries,type="absolute")[1:10]

# Visualize the entire sparse matrix, including all the items of the data set
itemFrequencyPlot(Groceries, col=rainbow(10))
# It is also possible to use the sample function, but it is barely readable with every single transaction represented.

########
# PART 2
########

# Load Data and preprocess text; Find the association items in the Groceries data set using the default support and confidence
# Definitions:
# Support: How popular an itemset is, as measured by the proportion of transactions in which an itemset appears.
# Confidence: How likely item Y is purchased when item X is purchased.
# Lift: How likely item Y is purchased when item X is purchased, while controlling for how popular item Y is.

# Default minimum support: 0.1
# Default minimum confidence: 0.8

# Association items with default parameters using apriori:
rules <- apriori(Groceries)

# Try different support and confidence levels to generate different numbers of rules and explain what it means
# Example of Apriori with different support and confidence:
rules <- apriori(Groceries, parameter = list(supp = 0.01, conf = 0.5)) 
summary(rules)
# Explanation:
# By changing support from 0.1 to 0.01, we are including products that are in 1 in 100 transactions instead of 1 in 10 in our rules.
# When using a confidence of 0.5 instead of 0.8, we are lowering the support threshold required for a product purchased at the same time as another: in our case, it means that more groceries will be included in the rules when they are present in the same transaction.

# Which R function will you use to get a high-level overview of the generated rules and to answer the following questions:
inspect(rules)

# How many rules have 3 items (lhs and rhs)?
rules[size(rules) == 3]
# To display the rules themselves:
inspect(rules[size(rules) == 3])

# Take a closer look at the first 10 rules.
inspect(rules[1:10])

# Are these rules interesting? What three categories are used to define "interesting"?
# An interesting rule could be characterized by its lift, support and confidence.
# Since our dataset contains just short of ten thousand transactions, the top 10 rules of all those we created in question 2 (support and confidence of at least 0.01 and 0.5 respectively) represent popular products,
# and those rules have a decently high lift (i.e. >2), which means they exceed the expected confidence of independent products taken on their own. As such, they could indeed be defined as interesting.

# Take a closer look at the ten best rules.	
rules<-sort(rules, by="lift", decreasing=TRUE)
inspect(rules[1:10])

# Find any rules that contain the word "chocolate" and store it in chocrules  object
chocrules = subset(rules, subset = lhs %in% "chocolate" | rhs %in% "chocolate")
# View the rules
inspect(chocrules)