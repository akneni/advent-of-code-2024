
alias CharMap = List[List[String]]
alias word = List[String]('X', 'M', 'A', 'S')
alias mods = List[List[Int]](
        List[Int](-1, -1),
        List[Int](1, -1),
        List[Int](-1, 1),
        List[Int](1, 1),
    )


fn load_data(filepath: String) raises -> CharMap:
    var text: String
    with open(filepath, "r") as f:
        text = f.read()    
    var char_map = CharMap()
    for line in text.split('\n'):
        if line[].strip() == '': break
        char_map.append(List[String]())
        for c in range(len(line[])):
            char_map[-1].append(str(line[][c]))
    return char_map

fn part_1() raises -> Int:
    var char_map = load_data('data/day-4.txt')

    
    var acc: Int = 0
    for i in range(len(char_map)):
        for j in range(len(char_map[i])):
            if char_map[i][j] == word[0]:
                acc += traverser(char_map, i, j)

    return acc

fn traverser(c_map: CharMap, i: Int, j: Int) -> Int:
    var acc: Int = 0

    for dir in valid_dirs(c_map, i, j):
        var i_owned = i
        var j_owned = j
        var is_valid = True

        for c in word:
            if c_map[i_owned][j_owned] != c[]:
                is_valid = False
                break
            increment(i_owned, j_owned, dir[])
        if is_valid: acc += 1

    return acc

fn valid_dirs(c_map: CharMap, i: Int, j: Int) -> List[Int]:
    var dirs = List[Int]()

    var range = len(word) - 1
    var u = i-range >= 0
    var d = i+range < len(c_map)
    var l = j-range >= 0
    var r = j+range < len(c_map[0])

    if u: dirs.append(0)
    if u and r: dirs.append(1)
    if r: dirs.append(2)
    if d and r: dirs.append(3)
    if d: dirs.append(4)
    if d and l: dirs.append(5)
    if l: dirs.append(6)
    if u and l: dirs.append(7)

    return dirs

@always_inline
fn increment(inout i: Int, inout j: Int, dir: Int):
    """
    0 is north
    1 is northeast
    2 is east
    ...
    7 is northwest
    (like a clock).
    """
    if dir == 0:
        i -= 1
    elif dir == 1:
        i -= 1
        j += 1
    elif dir == 2:
        j += 1
    elif dir == 3:
        i += 1
        j += 1
    elif dir == 4:
        i += 1
    elif dir == 5:
        i += 1
        j -= 1
    elif dir == 6:
        j -= 1
    elif dir == 7:
        i -= 1
        j -= 1

fn part_2() raises -> Int:
    var char_map = load_data('data/day-4.txt')
    
    var acc: Int = 0
    for i in range(1, len(char_map)-1):
        for j in range(1, len(char_map[i])-1):
            if char_map[i][j] == 'A' and is_xmas(char_map, i, j):
                acc += 1
                
    return acc

fn is_xmas(char_map: CharMap, i: Int, j: Int) -> Bool:
    var m = 0
    var s = 0

    for mod in mods:
        var char = char_map[i-mod[][0]][j-mod[][1]]
        if char == 'M':
            m += 1
        elif char == 'S':
            s += 1
        else:
            return False
        
    if m != 2:
        return False

    if char_map[i-1][j-1] == char_map[i+1][j+1]:
        return False

    return True


fn main() raises:
    # var p1_solution = part_1()
    # print(p1_solution)

    var p2_solution = part_2()
    print(p2_solution)
