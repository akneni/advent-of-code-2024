#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <time.h>

#define BOOL uint8_t
#define TRUE 1
#define FALSE 0

uint64_t fsizeof(FILE* f) {
    int64_t cur_pos = ftell(f);

    fseek(f, 0, SEEK_END);
    int64_t length = ftell(f);
    fseek(f, 0, cur_pos);
    return length;
}

typedef struct {
	uint8_t* map;
	uint64_t num_rows;
	uint64_t num_columns;
} TopMap;

// PRECONDITION: The file must not have more than 4096 columns
TopMap TopMap_from(const char* filepath) {
	FILE* fp = fopen(filepath, "r");

	uint64_t size = fsizeof(fp);

	TopMap map;
	map.map = (uint8_t*) malloc(size * sizeof(uint8_t));
	map.num_rows = 0;
	map.num_columns = 0;

	uint64_t buff_size = 4096;
	uint8_t buf[buff_size];	
	uint64_t map_counter = 0;

	while (TRUE) {
		uint64_t num_read = fread(buf, 1, buff_size, fp);
		for(int i = 0; i < num_read; i++) {
			if (buf[i] == (uint8_t) '\n') {
				if (map.num_columns == 0) map.num_columns = i;
			}
			else if (buf[i] != EOF) {
				// 48 is '0' in ascii
				map.map[map_counter] = buf[i] - 48;
				map_counter++;
			}
		}
		if (num_read < buff_size) {
			break;
		}
	}

	if (map_counter % map.num_columns != 0) {
		perror("Irregular number of columns");
		exit(1);
	}

	map.num_rows = map_counter / map.num_columns;

	fclose(fp);
	return map;
}

typedef struct {
	uint32_t i;
	uint32_t j;
} Coords;

#define PathHist_Num_Coords 10
typedef struct {
	TopMap map;
	Coords coords[PathHist_Num_Coords];
	uint64_t coords_idx;
} PathHist;

PathHist PathHist_from(const TopMap* map) {
	PathHist path;
	uint64_t sizeof_map = map->num_columns * map->num_rows * sizeof(uint8_t);
	path.map.map = (uint8_t*) malloc(sizeof_map);
	memset(path.map.map, 0, sizeof_map);
	memset(path.coords, 0, PathHist_Num_Coords*sizeof(uint32_t)*2);
	path.coords_idx = 0;
	return path;
}

uint64_t part_1_h(const TopMap* map, uint64_t i, uint64_t j, PathHist* peaks_found);

uint64_t part_1() {
	TopMap map = TopMap_from("data.txt");

	PathHist peaks_found = PathHist_from(&map);

	uint64_t acc = 0;
	for(uint64_t i = 0; i < map.num_rows; i++) {
		for(uint64_t j = 0; j < map.num_columns; j++) {
			if (map.map[i*map.num_columns + j] == 0) {
				uint64_t trailhead_score = part_1_h(&map, i, j, &peaks_found);
				acc += trailhead_score;
			}
		}
	}

	free(map.map);
	free(peaks_found.map.map);
	return acc;
}

void zero_out_mem(PathHist* peaks_found, uint64_t i, uint64_t j){
	if (peaks_found->coords_idx >= PathHist_Num_Coords) {
		uint64_t i_min =  (i > 10) ? i-10 : 0;
		uint64_t j_min =  (j > 10) ? j-10 : 0;
		uint64_t i_max =  (i < peaks_found->map.num_rows - 11) ? i+10 : peaks_found->map.num_rows;
		uint64_t j_max =  (j < peaks_found->map.num_columns - 11) ? j+10 : peaks_found->map.num_columns;
		for(uint64_t a = i_min; a <= i_max; a++) {
			for(uint64_t b = j_min; b <= j_max; b++) {
				peaks_found->map.map[a*peaks_found->map.num_columns + b] = 0;
			}
		}
	}
	else {
		for(uint64_t a = 0; a < peaks_found->coords_idx ; a++) {
			Coords coords = peaks_found->coords[a];
			peaks_found->map.map[coords.i*peaks_found->map.num_columns + coords.j] = 0;
		}
		peaks_found->coords_idx = 0;
	}

}

// Returns the number of paths to 9 can be achived from this point
uint64_t part_1_h(const TopMap* map, uint64_t i, uint64_t j, PathHist* peaks_found) {
	uint8_t curr_eleveation = map->map[i*map->num_columns + j];
	if (curr_eleveation == 9) {
		uint8_t found = peaks_found->map.map[i*peaks_found->map.num_columns + j];
		if (found > 0) {
			return 0;
		}
		peaks_found->map.map[i*peaks_found->map.num_columns + j] = 1;
		if (peaks_found->coords_idx < PathHist_Num_Coords) {
			peaks_found->coords[peaks_found->coords_idx] = (Coords){.i=i, .j=j};
			peaks_found->coords_idx++;
		}
		return 1;
	}

	uint64_t acc = 0;
	uint8_t new_elevation = curr_eleveation+1;
	// up
	if (i > 0 && map->map[(i-1)*map->num_columns + j] == new_elevation) {
		acc += part_1_h(map, i-1, j, peaks_found);
	}
	// down
	if (i < map->num_rows-1 && map->map[(i+1)*map->num_columns + j] == new_elevation) {
		acc += part_1_h(map, i+1, j, peaks_found);
	}

	// left
	if (j > 0 && map->map[i*map->num_columns + j-1] == new_elevation) {
		acc += part_1_h(map, i, j-1, peaks_found);
	}
	// right
	if (j < map->num_columns-1 && map->map[i*map->num_columns + j+1] == new_elevation) {
		acc += part_1_h(map, i, j+1, peaks_found);
	}

	// Reset peaks_found to all zeroes
	if (curr_eleveation == 0) {
		zero_out_mem(peaks_found, i, j);
	}

	return acc;
}


uint64_t part_2_h(const TopMap* map, uint64_t i, uint64_t j);

uint64_t part_2() {
	TopMap map = TopMap_from("data.txt");

	uint64_t acc = 0;
	for(uint64_t i = 0; i < map.num_rows; i++) {
		for(uint64_t j = 0; j < map.num_columns; j++) {
			if (map.map[i*map.num_columns + j] == 0) {
				uint64_t trailhead_score = part_2_h(&map, i, j);
				acc += trailhead_score;
			}
		}
	}

	free(map.map);
	return acc;
}

// Returns the number of paths to 9 can be achived from this point
uint64_t part_2_h(const TopMap* map, uint64_t i, uint64_t j) {
	uint8_t curr_eleveation = map->map[i*map->num_columns + j];
	if (curr_eleveation == 9) {
		return 1;
	}

	uint64_t acc = 0;
	uint8_t new_elevation = curr_eleveation+1;
	// up
	if (i > 0 && map->map[(i-1)*map->num_columns + j] == new_elevation) {
		acc += part_2_h(map, i-1, j);
	}
	// down
	if (i < map->num_rows-1 && map->map[(i+1)*map->num_columns + j] == new_elevation) {
		acc += part_2_h(map, i+1, j);
	}

	// left
	if (j > 0 && map->map[i*map->num_columns + j-1] == new_elevation) {
		acc += part_2_h(map, i, j-1);
	}
	// right
	if (j < map->num_columns-1 && map->map[i*map->num_columns + j+1] == new_elevation) {
		acc += part_2_h(map, i, j+1);
	}

	return acc;
}

int main(int argc, char** argv) {
	// uint64_t res = part_1();
	uint64_t res = part_2();
	printf("%lu\n", res);

    return 0;
}
