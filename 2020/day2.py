def part1():
    valid_passwords = 0
    with open("2020/data/day2.txt") as file:
        lines = file.readlines()
        for line in lines:
            criteria, password = line.strip().split(":")
            digit, letter = criteria.split(" ")
            minimum, maximum = map(int, digit.split("-"))
            if minimum <= password.count(letter) <= maximum:
                valid_passwords += 1
    return valid_passwords

def part2():
    valid_passwords = 0
    with open("2020/data/day2.txt") as file:
        lines = file.readlines()
        for line in lines:
            criteria, password = line.strip().split(":")
            digit, letter = criteria.split(" ")
            first, second = map(int, digit.split("-"))
            does_it_fail = (password[first] == letter and password[second] == letter) or (password[first] != letter and password[second] != letter)
            if not does_it_fail:
                valid_passwords += 1
    return valid_passwords

print(part2())