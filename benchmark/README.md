# VM Benchmarks

# Additional requirements
- [prettytable](https://pypi.org/project/prettytable/) to print out the results: 
```
pip install prettytable
```

## Usage
Make sure to run starkRelay once and create the working directory and config in the parent folder (so there exists starkRelay/work/starkRelay.toml).
You can then run the benchmark script from the benchmark folder using
```
python benchmarks.py [SETS] [CSV_FILE]
```

For now SETS can be one of three values:

- 1: Runs small batch size set
- 2: Runs medium and small batch size sets
- 3: Runs large, medium and small batch size sets

New batches to benchmark can be added to the specified batch sets in [```benchmarks.py```](https://github.com/lucidLuckylee/starkRelay/blob/main/benchmark/benchmarks.py)

## Baseline results

Gathered on a PC with Ryzen 5 3600 processor @ 3.6GHz 

```
--- Batch Validation Results ---
+------+-------+------+----------+-------------+---------+---------+
| size | start | end  | time (s) | memory (KB) |  steps  |  cells  |
+------+-------+------+----------+-------------+---------+---------+
|  3   |   1   |  3   |  7.4271  |    256728   |  77934  |  90280  |
|  3   |  2015 | 2017 |  7.5285  |    257396   |  78397  |  90744  |
|  21  |   1   |  21  | 38.2657  |    988428   |  571140 |  636387 |
|  21  |  2015 | 2035 | 38.5479  |    988992   |  571595 |  636835 |
| 252  |   1   | 252  | 463.0418 |   10687624  | 7208302 | 7909592 |
| 252  |  2015 | 2266 | 459.7708 |   10688384  | 7208769 | 7910064 |
+------+-------+------+----------+-------------+---------+---------+

--- Inclusion Merkle Proof Results ---
+------+-------+------+----------+-------------+--------+--------+
| size | start | end  | time (s) | memory (KB) | steps  | cells  |
+------+-------+------+----------+-------------+--------+--------+
|  3   |   1   |  3   |  3.7224  |    257396   | 26134  | 31118  |
|  3   |  2015 | 2017 |  3.7517  |    257396   | 26136  | 31122  |
|  21  |   1   |  21  |  4.8124  |    988992   | 34636  | 40101  |
|  21  |  2015 | 2035 |  4.8011  |    988992   | 34630  | 40089  |
| 252  |   1   | 252  | 18.7284  |   10688384  | 140042 | 151844 |
| 252  |  2015 | 2266 | 18.5993  |   10688384  | 140048 | 151856 |
+------+-------+------+----------+-------------+--------+--------+
```
