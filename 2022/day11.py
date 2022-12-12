IS_PART1 = False

class Monkey:
    def __init__(self, items, operation, test):
        self.items = items
        self.operation = self.parse_operation(operation)
        self.test = self.parse_test(test)
        self.inspections = 0
    
    def parse_operation(self, operation):
        return lambda old: eval(operation.split("= ")[1])
    
    def parse_test(self, test):
        self.divisor = int(test[0].split("by ")[1])
        t_monkey = int(test[1].split("monkey ")[1])
        f_monkey = int(test[2].split("monkey ")[1])
        return lambda value: (t_monkey,value%self.divisor) if value%self.divisor == 0 else (f_monkey,value%self.divisor)


monkey_lines = open("11.in","r").read().split("\n\n")
monkeys = []
for monkey in monkey_lines:
    lines = monkey.split("\n")
    items = list(map(int, lines[1].split(": ")[1].split(",")))
    monkeys.append(
        Monkey(items, lines[2], lines[3:])
    )

def find_gcd(x, y):
    while(y):
        x, y = y, x % y
    return x
# Driver Code       
divisor = 1
for monkey in monkeys:
    divisor *= monkey.divisor


ROUNDS = 20 if IS_PART1 else 10_000
import tqdm
for round in tqdm.tqdm(range(ROUNDS)):
    for i, monkey in enumerate(monkeys):
        for item in monkey.items:
            divide_with = 3 if IS_PART1 else 1
            if IS_PART1:
                worry_level = monkey.operation(item) // divide_with
            else:
                worry_level = monkey.operation(item) % divisor
            monkey.inspections += 1
            next_monkey, is_divisible = monkey.test(worry_level)
            monkeys[next_monkey].items.append(worry_level)
        monkey.items = []

top_inspections = sorted([monkey.inspections for monkey in monkeys])[-2:]
print(top_inspections, top_inspections[0]*top_inspections[1])
