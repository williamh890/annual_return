import csv
import random
import time
import copy

random.seed(time.time())


class Year(object):
    def __init__(self, year=None, stocks=None, bonds=None, treasuries=None):
        self.year = int(year)
        self.stocks = float(stocks) / 100
        self.bonds = float(bonds) / 100
        self.treasuries = float(treasuries) / 100

    def __str__(self):
        return "{}, {}, {}, {}".format(self.year, self.stocks,
                                       self.bonds, self.treasuries)

    def get_ratios(self):
        return [self.stocks, self.bonds, self.treasuries]


class Strategy(object):
    def __init__(self, addition, stocks, bonds, treasuries):
        self.addition = addition
        self.stocks = stocks
        self.bonds = bonds
        self.treasuries = treasuries

        if stocks + bonds + treasuries > 1:
            raise StandardError("Over 100 entered for strategy")

    def __repr__(self):
        return "Strategy({}, {}, {}, {})".format(3600, self.stocks, self.bonds, self.treasuries)

    def __str__(self):
        return "{}, {}, {}".format(self.stocks, self.bonds, self.treasuries)


years = []

with open("historical_data.csv", "r") as historical_data_csv:
    historical_data = csv.reader(historical_data_csv)

    for year in historical_data:
        new_year = Year(
            year=year[1],
            stocks=year[2][:-1],
            treasuries=year[3][:-1],
            bonds=year[4][:-1]
        )

        years.append(new_year)


def annual_return(num_years, strategy):
    balance = 0

    distribution = {}
    deviations = []
    for y in range(num_years):
        if y != num_years:
            balance += strategy.addition

        # Find the random year values
        random_year = random.choice(years)

        distribution = {"stocks": balance * strategy.stocks * random_year.stocks,
                        "bonds": balance * strategy.bonds * random_year.bonds,
                        "treasuries": balance * strategy.treasuries * random_year.treasuries}

        for invest_class, amount in distribution.items():
            balance += amount

    return round(balance)


def write_results(strat_returns):
    with open("data.csv", "w") as data_file:
        for returns in strat_returns:
            line = ""
            for run in returns:
                line += "{}, ".format(run)

            data_file.write(line[:-1] + "\n")


if __name__ == "__main__":
    acending_decending_percentages = zip(
        [x / 10 for x in range(0, 11, 1)],
        [x / 10 for x in range(10, -1, -1)]
    )

    strats = [
        Strategy(3600, stock_amount, bond_amount, 0) for stock_amount, bond_amount in acending_decending_percentages
    ]

    strat_returns = []

    for strat in strats:
        returns = []
        for run in range(1000):
            returns.append(annual_return(30, strat))

        strat_returns.append(sorted(returns))

    write_results(strat_returns)
