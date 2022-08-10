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


--- Proof Generation Results ---
+------+-------+------+----------+-------------+
| size | start | end  | time (s) | memory (KB) |
+------+-------+------+----------+-------------+
|  3   |   1   |  3   | 14.3433  |   1533460   |
|  3   |  2015 | 2017 |  14.196  |   1542272   |
|  21  |   1   |  21  | 116.2051 |   12037728  |
|  21  |  2015 | 2035 | 117.305  |   12037728  |
+------+-------+------+----------+-------------+

```

The proof generation results were gathered using Giza ([this](https://github.com/maxgillett/giza/commit/934d4f421764173080ca0c3078b53b98ae895c7c) commit in particular)
