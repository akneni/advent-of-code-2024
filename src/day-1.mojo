from python import Python

fn load_data() raises -> (List[Int], List[Int]):
    var text: String
    with open('data/day-1.txt', 'r') as f:
        text = f.read()
    
    var lst: List[String] = text.split('\n')
    var lst_2: List[List[String]] = List[List[String]]()

    for i in range(len(lst)):
        var s: String = lst[i]
        if s.strip() == '': 
            continue
        lst_2.append(s.split('   '))

    var nums_1 = List[Int]()
    var nums_2 = List[Int]()

    for s in lst_2:
        nums_1.append(int(s[][0]))
        nums_2.append(int(s[][1]))

    return nums_1, nums_2

fn part_1() raises -> Int:
    var nums_1: List[Int]
    var nums_2: List[Int]

    nums_1, nums_2 = load_data()

    sort(nums_1)
    sort(nums_2)

    var acc: Int = 0
    for i in range(len(nums_1)):
        acc += abs(nums_1[i] - nums_2[i])

    return acc

fn part_2() raises -> Int:
    var nums_1: List[Int]
    var nums_2: List[Int]

    nums_1, nums_2 = load_data()

    var freq = List[Int]()
    var max_num = max(max_l(nums_1), max_l(nums_2))

    for _ in range(max_num):
        freq.append(0)

    for i in nums_2:
        freq[i[]] += 1

    var acc = 0
    
    for i in nums_1:
        acc += (i[] * freq[i[]])

    return acc

fn max_l(lst: List[Int]) -> Int:
    var acc: Int = lst[0]
    for i in lst:
        if i[] > acc:
            acc = i[]
    return acc


fn main() raises:
    # var p1_solution = part_1()
    # print(p1_solution)

    var p2_solution = part_2()
    print(p2_solution)