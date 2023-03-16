#!/usr/bin/env python3
# Author: Theodoros Pavlidis
# Prints the ages of the family.

from datetime import date

# Define the birth dates of your daughters, wife, and yourself
Sofia_birthdate = date(2018, 2, 18)
Vasiliki_birthdate = date(2020, 11, 2)
Ioanna_birthdate = date(1987, 7, 29)
Theo_birthdate = date(1984, 7, 7)

# Calculate the current date
today = date.today()

# Calculate the age of each person
delta1 = today - Sofia_birthdate
years1 = delta1.days // 365
months1 = (delta1.days % 365) // 30
days1 = delta1.days % 30

delta2 = today - Vasiliki_birthdate
years2 = delta2.days // 365
months2 = (delta2.days % 365) // 30
days2 = delta2.days % 30

delta_wife = today - Ioanna_birthdate
years_wife = delta_wife.days // 365
months_wife = (delta_wife.days % 365) // 30
days_wife = delta_wife.days % 30

delta_me = today - Theo_birthdate
years_me = delta_me.days // 365
months_me = (delta_me.days % 365) // 30
days_me = delta_me.days % 30

# Print the results
print("\033[92mSofia is {} years, {} months, and {} days old.\033[92m".format(years1, months1, days1))
print("Vasiliki is {} years, {} months, and {} days old.".format(years2, months2, days2))
print("Ioanna is {} years, {} months, and {} days old.".format(years_wife, months_wife, days_wife))
print("Theo is {} years, {} months, and {} days old.".format(years_me, months_me, days_me))

# If I wanted only the first line to be green I would add the "\033[0m" sequence in the end.
