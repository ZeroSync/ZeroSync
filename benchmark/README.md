# VM Benchmarks

## Usage

You can run the benchmark script from the benchmark folder using
```
python benchmarks.py [SETS] [CSV_FILE]
```

For now SETS can be one of three values:

- 1: Runs small batch size set
- 2: Runs medium and small batch size sets
- 3: Runs large, medium and small batch size sets

New batches to benchmark can be added to the specified batch sets in (```benchmarks.py```)[https://github.com/lucidLuckylee/starkRelay/blob/main/benchmark/benchmarks.py]

## Baseline results

Gathered on a PC with Ryzen 5 3600 processor @ 3.6GHz 

```
+-------+------+----------+-------------+---------+---------+
| start | end  | time (s) | memory (KB) |  steps  |  cells  |
+-------+------+----------+-------------+---------+---------+
|   1   |  3   |  7.4041  |    257028   |  77934  |  90280  |
|  2015 | 2017 |  7.5022  |    257612   |  78397  |  90744  |
|   1   |  21  | 38.1149  |    988440   |  571140 |  636387 |
|  2015 | 2035 | 38.6976  |    989308   |  571595 |  636835 |
|   1   | 252  | 455.7168 |   10687708  | 7208302 | 7909592 |
|  2015 | 2266 | 458.0312 |   10688268  | 7208769 | 7910064 |
+-------+------+----------+-------------+---------+---------+
```
