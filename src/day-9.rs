
use std::fs;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Block {
    File(u32),
    Empty,
}


fn load_data(path: &str) -> Vec<Block> {
    let text = fs::read_to_string(path).unwrap();
    let mut files = vec![];

    let mut is_file = true;
    let mut file_id = 0;
    for c in text.chars() {
        let num: u8 = c.to_string().parse().unwrap();
        let payload = if is_file {
            Block::File(file_id)
        }
        else {
            Block::Empty
        };

        for _i in 0..num {
            files.push(payload);
        }

        if is_file {
            file_id += 1;
        }
        is_file = !is_file
    }

    files
}

fn part_1() {
    let mut files = load_data("data.txt");
    // println!("{:?}", files);

    let mut i = 0;
    let mut j = files.len() - 1;

    while i < j {
        while files[i] != Block::Empty {
            i += 1;
        }
        while files[j] == Block::Empty  {
            j -= 1;
        }

        if i < j {
            files.swap(i, j);
        }
    }

    let mut checksum = 0;
    for (i, s) in files.iter().enumerate() {
        match *s {
            Block::File(id) => checksum += i * id as usize,
            Block::Empty => break,
        }
    }

    println!("{:?}", checksum);
}

fn part_2() {
    let mut files = load_data("data.txt");

    let mut j = files.len() - 1;

    while j > 0 {
        while files[j] == Block::Empty && j > 0  {
            j -= 1;
        }
        
        while j > 0 && files[j-1] == files[j] {
            j -= 1;
        }
        let len_j = find_len(&files, j);
        let mut i = 0;
        while i < j {
            let len_i = find_len(&files, i);
            match files[i] {
                Block::File(_) => {
                    i += len_i;
                }
                Block::Empty => {
                    if len_i >= len_j {
                        for k in 0..len_j {
                            files[i+k] = files[j+k];
                            files[j+k] = Block::Empty;
                        }
                        break;
                    }
                    else {
                        i += len_i;
                    }
                }
            }
        }
        if j > 0 {
            j -= 1;
        }
    }

    let mut checksum = 0;
    for (i, s) in files.iter().enumerate() {
        match *s {
            Block::File(id) => checksum += i * id as usize,
            Block::Empty => continue,
        }
    }

    println!("{:?}", checksum);
}

#[inline]
fn find_len(vec: &[Block], idx: usize) -> usize {
    let mut top_c = idx + 1;
    while top_c < vec.len() && vec[idx] == vec[top_c] {
        top_c += 1;
    }
    top_c - idx
}

fn main() {
    // part_1();
    part_2();


}
