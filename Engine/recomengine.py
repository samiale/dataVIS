# coding: utf-8

import pandas
from apyori import apriori
import itertools

# Due to the CSV being oddly formatted (lacks empty columns), pandas is unable to import it as is
# The following bloc solves that
# region https://stackoverflow.com/a/52890095
# Input
data_file = "groceries.csv"

# Delimiter
data_file_delimiter = ','

# The max column count a line in the file could have
largest_column_count = 0

# Loop the data lines
with open(data_file, 'r') as temp_f:
    # Read the lines
    lines = temp_f.readlines()
    for l in lines:
        # Count the column count for the current line
        column_count = len(l.split(data_file_delimiter)) + 1
        # Set the new most column count
        largest_column_count = column_count if largest_column_count < column_count else largest_column_count

# Close file
temp_f.close()

# Generate column names (will be 0, 1, 2, ..., largest_column_count - 1)
column_names = [i for i in range(0, largest_column_count)]

# Read csv
df = pandas.read_csv(data_file, header=None, delimiter=data_file_delimiter, names=column_names)
# endregion

# Display the amount of transactions
print("The Groceries dataset was imported. It contains {0[0]} transactions, each representing a client and containing up to {0[1]} items.".format(df.shape))

groceriesListRaw = df.values.tolist()

# Eliminate NaN entries from the dataset by filtering non-string items
groceriesList = []
for groceries in groceriesListRaw:
    temp = []
    for grocery in groceries:
        if type(grocery) == str:
            temp.append(grocery)
    groceriesList.append(temp)

# Create the rules generating object, one may change minimum support and confidence here
rulesGenerator = apriori(groceriesList, min_support=0.001, min_confidence=0.8, min_length = 1)

print("Generating rules, this may take a moment...")

rules = list(rulesGenerator)

print("Done generating rules.")

# To get the lhs: list(rules[x][0])[:-1] where x is the rule number
# To get the rhs: list(rules[x][0])[-1:] where x is the rule number

# CAUTION: Depending on the amount of rules, this may have a VERY long runtime, due to being wholly unoptimized. 
# May just want to use the loop just underneath that one
# recommendations = []
# for i in range(0, len(groceriesList)):
#     itemsList = groceriesList[i]
#     itemsMatch = []
#     # https://docs.python.org/2/library/itertools.html#recipes - powerset
#     for itemCombination in itertools.chain.from_iterable(itertools.combinations(itemsList, r) for r in range(len(itemsList)+1)):
#         for rule in rules:
#             lhs = list(rule[0])[:-1]
#             lhs.sort()
#             items = list(itemCombination)
#             items.sort()
#             if lhs == items:
#                 print("Matched {0} with {1} for basket {2}. Full rule: {3}".format(lhs, items, i, rule))
#                 itemsMatch.append(list(rule[0])[-1:])
#     if itemsMatch == []:
#         recommendations.append(None)
#     else:
#         recommendations.append(itemsMatch)

# Main loop, I guess
while(True):
    user = input("\nPlease enter a number between 0 and {0} to see the associated client's recommended products: ".format(len(groceriesList)))
    print("Calculating, please wait...")
    itemsList = groceriesList[int(user)]
    itemsMatch = []
    # https://docs.python.org/2/library/itertools.html#recipes - powerset
    for itemCombination in itertools.chain.from_iterable(itertools.combinations(itemsList, r) for r in range(len(itemsList)+1)):
        for rule in rules:
            lhs = list(rule[0])[:-1]
            lhs.sort()
            items = list(itemCombination)
            items.sort()
            if lhs == items:
                print("Matched {0} with {1}. Full rule: {2}".format(lhs, items, rule))
                itemsMatch.append(list(rule[0])[-1:][0])

    # Remove duplicates
    itemsMatch = list(dict.fromkeys(itemsMatch))
    if itemsMatch:
        print("Client #{0}'s recommended products are the following:".format(user))
        print("\n".join(itemsMatch))
    else:
        print("Could not recommend anything to client #{0}. Rules may need adjusting, or client just did not buy enough items.".format(user))