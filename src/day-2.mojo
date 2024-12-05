# import time
from python import Python

fn load_data(filepath: String) raises -> List[List[Int]]:
    var reports = List[List[Int]]()

    var text: String
    with open(filepath, "r") as f:
        text = f.read()
    
    for line in text.split('\n'):
        if line[].strip() == '':
            break
        reports.append(List[Int]())
        for i in line[].strip().split(' '):
            reports[-1].append(int(i[]))

    return reports

fn part_1() raises -> Int:
    var reports = load_data('data/day-2.txt')
    
    var acc: Int = 0

    for rep in reports:
        var is_valid: Bool = True
        var global_dir: Int8 = 0
        for i in range(1, len(rep[])):
            var dir: Int8 = 1 if rep[][i] > rep[][i-1] else -1
            if rep[][i] == rep[][i-1]:
                is_valid = False
                break
            elif abs(rep[][i] - rep[][i-1]) > 3:
                is_valid = False
                break
            
            if global_dir != 0 and dir != global_dir:
                is_valid = False
                break
            elif dir != global_dir:
                global_dir = dir
            
        if is_valid: acc += 1    

    return acc

fn part_2() raises -> Int:
    var reports = load_data('data/day-2.txt')

    var acc: Int = 0
    for rep in reports:
        for i in range(-1, len(rep[])):
            if is_valid(rep[], i):
                acc += 1
                break
    return acc

fn is_valid(rep: List[Int], mask: Int) -> Bool:
    var global_dir: Int8 = 0
    var i = 1
    var j = 0
    while True:
        if i == mask:
            i += 1
        elif j == mask:
            j += 1
            if j == i: i += 1
        if i >= len(rep):
            break

        var dir: Int8 = 1 if rep[i] > rep[j] else -1
        if rep[i] == rep[j]:
            return False
        elif abs(rep[i] - rep[j]) > 3:
            return False
        if global_dir != 0 and dir != global_dir:
            return False
        elif dir != global_dir:
            global_dir = dir
        
        i += 1
        j += 1
            
    return True

fn display(x: List[Bool]):
    var s: String = "["
    for i in x:
        if i[]:
            s += "True"
        else:
            s += "False"
        s += ", "
    s += "]"
    print(s)


fn main() raises:
    # var p1_solution = part_1()
    # print(p1_solution)

    var p2_solution = part_2()
    print(p2_solution)