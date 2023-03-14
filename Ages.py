#!/usr/bin/env python3

from datetime import date

# Define the birth dates of your daughters
daughter1_birthdate = date(2018, 2, 18)
daughter2_birthdate = date(2020, 11, 2)

# Calculate the current date
today = date.today()

# Calculate the age of daughter 1
delta1 = today - daughter1_birthdate
years1 = delta1.days // 365
months1 = (delta1.days % 365) // 30
days1 = delta1.days % 30

# Calculate the age of daughter 2
delta2 = today - daughter2_birthdate
years2 = delta2.days // 365
months2 = (delta2.days % 365) // 30
days2 = delta2.days % 30

# Print the results
print("Daughter 1 is {} years, {} months, and {} days old.".format(years1, months1, days1))
print("Daughter 2 is {} years, {} months, and {} days old.".format(years2, months2, days2))
