
fn load_data(filepath: String) raises -> String:
    var text: String
    with open(filepath, "r") as f:
        text = f.read()    
    return text

fn part_1() raises -> Int:
    var text = load_data('data/day-3.txt')
    
    var acc: Int = 0
    var str_offset: Int = 0
    while str_offset < len(text):
        var idx = text.find('mul(', str_offset)
        if idx == -1: break
        str_offset = idx + len('mul(')

        var x1: Int
        var x2: Int

        idx = text.find(',', str_offset)
        if idx == -1: break
        try:
            x1 = int(text[str_offset:idx])
            str_offset = idx + 1
        except:
            str_offset += 1
            continue

        idx = text.find(')', str_offset)
        if idx == -1: break
        try:
            x2 = int(text[str_offset:idx])
            str_offset = idx + 1
        except:
            str_offset += 1
            continue

        acc += x1*x2
    return acc

fn part_2() raises -> Int:
    var text = load_data('data/day-3.txt')
    
    var acc: Int = 0
    var str_offset: Int = 0
    while str_offset < len(text):
        var idx = text.find('mul(', str_offset)
        if idx == -1: break

        # Handle jumpts due to don't() commands
        var dont_idx = text.find("don't()", str_offset)
        if dont_idx != -1 and dont_idx < idx:
            str_offset = dont_idx + len("don't()")
            var do_idx = text.find('do()', str_offset)
            if do_idx == -1: break
            str_offset = do_idx + len('do()')
            continue

        str_offset = idx + len('mul(')

        var x1: Int
        var x2: Int

        idx = text.find(',', str_offset)
        if idx == -1: break
        try:
            x1 = int(text[str_offset:idx])
            str_offset = idx + 1
        except:
            str_offset += 1
            continue

        idx = text.find(')', str_offset)
        if idx == -1: break
        try:
            x2 = int(text[str_offset:idx])
            str_offset = idx + 1
        except:
            str_offset += 1
            continue

        acc += x1*x2
    return acc



fn main() raises:
    # var p1_solution = part_1()
    # print(p1_solution)

    var p2_solution = part_2()
    print(p2_solution)