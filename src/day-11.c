#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
#include <inttypes.h> 
#include <math.h>
#include <omp.h>
#include "vector.h"

#define CACHE_SIZE 10000
#define NUM_BLINKS 75

uint64_t fsizeof(FILE* f) {
    int64_t cur_pos = ftell(f);

    fseek(f, 0, SEEK_END);
    int64_t length = ftell(f);
    fseek(f, 0, cur_pos);
    return length;
}

Vector load_data(const char* filename) {
	FILE* fp = fopen(filename, "r");

	Vector v = Vector_init(sizeof(uint64_t));

	uint64_t num;
	while(fscanf(fp, "%" SCNu64, &num) == 1) {
		Vector_push(&v, &num);
	}

	fclose(fp);
	return v;
}

#define num_pow_10s 19
uint64_t pow_10s[num_pow_10s] = {
	10,
	100,
	1000,
	10000,
	100000,
	1000000,
	10000000,
	100000000,
	1000000000,
	10000000000,
	100000000000,
	1000000000000,
	10000000000000,
	100000000000000,
	1000000000000000,
	10000000000000000,
	100000000000000000,
	1000000000000000000,
	(uint64_t)1000000000000000000 * (uint64_t) 10
};

uint64_t get_num_digits(uint64_t n) {
    // Each comparison cuts off at a power of 10
    if (n < 10ULL)                   return 1;
    if (n < 100ULL)                  return 2;
    if (n < 1000ULL)                 return 3;
    if (n < 10000ULL)                return 4;
    if (n < 100000ULL)               return 5;
    if (n < 1000000ULL)              return 6;
    if (n < 10000000ULL)             return 7;
    if (n < 100000000ULL)            return 8;
    if (n < 1000000000ULL)           return 9;
    if (n < 10000000000ULL)          return 10;
    if (n < 100000000000ULL)         return 11;
    if (n < 1000000000000ULL)        return 12;
    if (n < 10000000000000ULL)       return 13;
    if (n < 100000000000000ULL)      return 14;
    if (n < 1000000000000000ULL)     return 15;
    if (n < 10000000000000000ULL)    return 16;
    if (n < 100000000000000000ULL)   return 17;
    if (n < 1000000000000000000ULL)  return 18;
    if (n < 10000000000000000000ULL) return 19;
    return 20;
}

uint64_t simulate_blink_rec(uint64_t num, uint64_t blinks, int64_t* stone_cache) {
	if (blinks == 0) {
		return 1;
	}

	if (num == 0) {
		return simulate_blink_rec(1, blinks-1, stone_cache); 
	}

	uint64_t cache_idx = (CACHE_SIZE * (blinks-1)) + num;
	if (num < CACHE_SIZE && stone_cache[cache_idx] != -1) {
		return stone_cache[cache_idx];
	}

	uint64_t acc;
	uint64_t num_digits = get_num_digits(num);
	if (num_digits % 2 == 0) {
		uint64_t div = pow_10s[(num_digits/2)-1];
		uint64_t f = num / div;
		uint64_t s = num % div;
		acc = simulate_blink_rec(f, blinks-1, stone_cache);
		acc += simulate_blink_rec(s, blinks-1, stone_cache);
	}
	else {
		acc = simulate_blink_rec(num * 2024, blinks-1, stone_cache);
	}

	if (num < CACHE_SIZE) {
		stone_cache[cache_idx] = acc;
	}

	return acc;
}

uint64_t part_1_2() {
	Vector stones = load_data("data.txt");
	uint64_t acc = 0;
	uint64_t cache_size = (CACHE_SIZE+1) * (NUM_BLINKS+1);
	int64_t* stone_cache = (int64_t*) malloc(cache_size * sizeof(int64_t));
	for(int i = 0; i < cache_size; i++) {
		stone_cache[i] = -1;
	}

	omp_set_num_threads(14);
	#pragma omp parallel for reduction(+:acc) schedule(dynamic)
	for (uint64_t i = 0; i < stones.length; i++) {
		uint64_t num = ((uint64_t*) stones.data)[i];
		acc += simulate_blink_rec(num, NUM_BLINKS, stone_cache);
	}

	Vector_free(&stones);
	free(stone_cache);
	return acc;
}

int main(int argc, char** argv) {
	uint64_t res = part_1_2();
	printf("%lu\n", res);

    return 0;
}
