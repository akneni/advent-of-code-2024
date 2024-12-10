from python import Python, PythonObject


alias MulOp: UInt8 = 0
alias AddOp: UInt8 = 1
alias ConcatOp: UInt8 = 2

fn product(iterables: List[Int], repeat: Int = 1) -> List[List[Int]]:
    # Repeat the iterables 'repeat' times
    var pools = List[List[Int]]()
    for _ in range(repeat):
        pools.append(iterables)

    # If still no pools, return empty
    if len(pools) == 0:
        return List[List[Int]]()

    # Initialize indices to track current position in each pool
    var indices = List[Int]()
    for _i in range(len(pools)):
        indices.append(0)
    var results = List[List[Int]]()
    
    while True:
        # Construct the current combination
        var combo = List[Int]()
        for i in range(len(pools)):
            combo.append(pools[i][indices[i]])
        results.append(combo)
        
        # "Odometer" style increment
        var i = len(pools) - 1
        while i >= 0:
            indices[i] += 1
            if indices[i] == len(pools[i]):
                indices[i] = 0
                i -= 1
            else:
                break
        
        # If we've rolled over all the way, we're done
        if i < 0:
            break

    return results

fn load_data(filepath: String) raises -> List[List[Int]]:
    var text: String
    with open(filepath, "r") as f:
        text = f.read()
    
    var equations = List[List[Int]]()
    for line in text.split('\n'):
        if line[].strip() == '': continue

        equations.append(List[Int]())
        var res = int(line[].split(':')[0])
        equations[-1].append(res)
        var split_line = line[].strip().split(' ')
        for i in range(1, len(split_line)):
            equations[-1].append(int(split_line[i]))
    
    return equations

fn part_1() raises -> Int:
    var equations = load_data('data/day-7.txt')
    
    var acc: Int = 0

    for eq in equations:
        if is_solvable(eq[]):
            acc += eq[][0]

    return acc

fn part_2() raises -> Int:
    var equations = load_data('data/day-7.txt')
    
    var acc: Int = 0

    for eq in equations:
        if is_solvable(eq[]):
            acc += eq[][0]

    return acc

fn is_solvable(eq: List[Int]) raises -> Bool:
    for i in product(List[Int](0, 1, 2), repeat = len(eq)-2):
        if is_solvable_h(eq, i[]):
            return True

    return False

fn is_solvable_h(eq: List[Int], ops: List[Int]) raises -> Bool:
    var acc: Int = eq[1]

    for i in range(2, len(eq)):
        if UInt8(int(ops[i-2])) == MulOp:
            acc *= eq[i]
        elif UInt8(int(ops[i-2])) == AddOp:
            acc += eq[i]
        elif UInt8(int(ops[i-2])) == ConcatOp:
            acc = int_concat(acc, eq[i])
        else:
            print("warning")

    return acc == eq[0]

@always_inline
fn int_concat(a: Int, b: Int) -> Int:
    var digits: Int = 0
    var temp_b: Int = b

    # Count the digits in b
    while temp_b > 0:
        temp_b = temp_b // 10
        digits += 1

    return (a * (10**digits)) + b


fn is_solvable_heuristic(eq: List[Int]) raises -> Bool:
    for i in product(List[Int](0, 1, 2), repeat = len(eq)-2):
        if is_solvable_h(eq, i[]):
            return True

    return False


fn main() raises:
    # var p1_solution = part_1()
    # print(p1_solution)

    var p2_solution = part_2()
    print(p2_solution)
