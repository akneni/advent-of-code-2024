#![allow(unused)]
use std::{collections::HashSet, default, fs, ops::{Index, IndexMut}};

const VISITED_CHAR: char = '.';

#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq)]
struct Coords {
    i: usize,
    j: usize,
}

impl Coords {
    #[inline]
    fn update(&self, i: isize, j: isize) -> Self {
        let mut coords = *self;

        if i >= 0 {
            coords.i += i as usize;
        }
        else {
            coords.i = coords.i.wrapping_sub((-i) as usize);
        }

        if j >= 0 {
            coords.j += j as usize;
        }
        else {
            coords.j = coords.j.wrapping_sub((-j) as usize);
        }
        coords
    }

    #[inline]
    fn split_dir(&self) -> [Self; 4] {
        [
            self.update(-1, 0),
            self.update(1, 0),
            self.update(0, -1),
            self.update(0, 1),
        ]
    }
}

#[derive(Debug, Clone)]
struct Garden {
    data: Vec<char>,
    rows: usize,
    columns: usize,
}

impl Garden {
    fn from(filepath: &str) -> Self {
        let text = fs::read_to_string(filepath)
            .unwrap();

        let char_iter = text
            .trim()
            .split("\n")
            .map(|s| {
                s.chars().collect::<Vec<char>>()
            });
        
        let mut rows;
        let mut columns = 1;
        let mut data: Vec<char> = vec![];
        for mut i in char_iter {
            columns = i.len();
            data.append(&mut i);
        }
        rows = data.len() / columns;
        
        Self{data, rows, columns}
    }

    fn to_string(&self) -> String {
        let mut s = String::new();
        for i in 0..self.rows {
            for j in 0..self.columns {
                s.push(self[Coords{i, j}]);
            }
        }
        s
    }
}

impl Index<Coords> for Garden {
    type Output = char;

    #[inline]
    fn index(&self, index: Coords) -> &Self::Output {
        &self.data[index.i * self.columns + index.j]
    }
}

impl IndexMut<Coords> for Garden {
    #[inline]
    fn index_mut(&mut self, index: Coords) -> &mut Self::Output {
        &mut self.data[index.i * self.columns + index.j]
    }
}

#[derive(Debug)]
struct Region {
    plant_type: char,
    plots: Vec<Coords>,
}

impl Region {
    fn new(c: char) -> Self {
        Region {
            plant_type: c,
            plots: Vec::new(),
        }
    }
}

fn part_1() {
    let garden = Garden::from("/home/aknen/Documents/rust-scratch/data.txt");

    let mut regions: Vec<Region> = vec![];
    let mut plots_visited = garden.clone();

    for i in 0..garden.rows {
        for j in 0..garden.columns {
            let coords = Coords{i, j};

            if plots_visited[coords] == VISITED_CHAR {
                continue;
            }

            let mut reg = Region::new(garden[coords]);

            populate_region(&garden, &mut reg, coords, &mut plots_visited);

            regions.push(reg);
        }
    }

    let mut acc = 0_usize;
    for reg in &regions {
        let area = reg.plots.len();
        let perim = get_perimeter(&garden, reg);
        acc += area * perim;
    }

    println!("{}", acc);
}

fn populate_region(
    garden: &Garden, 
    region: &mut Region, 
    coords: Coords,
    visited: &mut Garden,
) {
    if coords.i >= garden.rows || coords.j >= garden.columns {
        return;
    }
    else if visited[coords] == VISITED_CHAR {
        return;
    }
    else if garden[coords] != region.plant_type {
        return;
    }

    region.plots.push(coords);
    visited[coords] = VISITED_CHAR;

    for c in coords.split_dir() {
        populate_region(garden, region, c, visited);
    }
}


fn get_perimeter(garden: &Garden, region: &Region) -> usize {
    let mut acc = 0;
    
    for coords in &region.plots {
        for perif in coords.split_dir() {
            if perif.i >= garden.rows || perif.j >= garden.columns {
                acc += 1;
            }
            else if garden[perif] != region.plant_type {
                acc += 1;
            }
        }
    }

    acc
}

fn main() {
    part_1();
    // part_2();

}
