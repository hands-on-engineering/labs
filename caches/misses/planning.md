# 3 C's of Cache Misses Lesson Planning

## Learning Objectives

After this lesson, students will be able to:
- Explain how we classify different cache misses
- Run cache simulations to determine whether a memory accesses are hits or misses (and
  which kind of miss)

## Assessments

Knowledge Check 1:
- Consider an 8-bit system with a 16 B cache consisting of 4 B blocks with 2-way
  set associativity
  * How many lines are in the cache?
    - A: 4 lines (or, equivalently, 4 blocks)
  * How many sets are in the cache? Hint: how do we determine blocks per set?
    - A: 2 sets ("2-way" means 2 blocks per set)

Knowledge Check 2: 
- Why do we even have this classification for cache misses?
  - A: We want a general quantitative way to see how our cache is performing for
    some set of memory accesses.
- T/F: Using the 3 C's will always help us improve our cache
  - A: F, they provide a good guideline but they're a little phony
- How do we classify a series of memory accesses as hits or misses (and type of
  miss)?
  - A: We simulate the series of memory accesses against some different cache
    types and log misses.
- What is another name for "compulsory" miss?
  - A: A "cold start" miss

Knowledge Check 3:
- What are the 3 types of simulations we run to classify memory accesses?
  - A: 
    1. Infinite fully associative cache
       * All new misses are compulsory
    2. Fully associative cache with the same size as the final configuration
       * All new misses are capacity misses
    3. Actual cache configuration
       * All new misses are conflict misses

## Connections

So we already know why we need a cache at all and how awesome the benefits are
if our cache is performing well. We need a general way to think about cache
performance and today's topic will provide us with a guideline of how to do just
that.

## Content 

### Useful Notes

- Scientific prefixes in base 2:
  * 2^10 = Kilo
  * 2^20 = Mega
  * 2^30 = Giga
- Terminology:
  - "k-way" means k blocks per set
    * This means you're working with some kind of set-associative cache
  - Cache block: chunk of data in your cache
  - Cache line: synonymous to cache block

### Knowledge Check 1 as an example

### The 3 C's

The 3 C's provide a way for us to classify each cache miss in a way that gives
us a somewhat concrete way to measure cache performance. It's important to note
that the 3 C's are just guidelines, there's no guarantee that shaping your cache
around these metrics will actually help at all.

So here are the 3 types of misses we can have in our cache:

- Compulsory miss
- Capacity miss
- Conflict miss

A compulsory miss is also known as a "cold start" miss. These misses happen
because our cache starts out empty, so inevitably the first reference to any
block will always miss. 

A capacity miss happens when the cache is too small to hold all the data, and we
would've had a hit with a large enough cache.

A conflict miss happens due to the associativity of our cache. This means that
some newer data booted out the data we're trying to access, and so we missed.

In general, the way that we measure cache performance is with simulations. This
is a very engineering-way to generate metrics, and we'll go in more depth about
exactly which simulations we run to classify hits/misses after the knowledge
check.

### Knowledge Check 2 (no explanation for time)

### Running Simulations

Let's think about how we might classify certain misses. We mentioned that we
want to simulate our memory accesses against different types of caches and
seeing when we miss. 

We're going to run 3 simulations in this order: one to determine compulsory misses, one to
determine capacity misses, and one to determine conflict misses.

Every time we get a miss in a simulation, we mark it as that type of miss and
never update it again for future simulations.

So now, let's think about what kinds of caches we need to run these simulations
against.

For the compulsory miss, say we had an infinite fully associative cache. The
infinite part means that we could hold all the data in memory if we wanted to,
so no capacity misses can happen. The fully associative part means that data can
go anywhere, so we can't have any conflict misses. Then, all misses we see if we
run our series of memory accesses against an infinite fully associative cache
will be compulsory misses. 

For capacity misses, let's consider just putting a size limit on our fully
associative cache. Any new misses we see (ones that weren't already marked as
compulsory misses) must've occurred because we shrunk how big our cache is. So,
if it was a size issue, then all these new misses must be capacity misses.

Now finally for conflict misses, we want to take into account all evictions that
occur in the final cache configuration. We can do this by running our
memory accesses against our final cache configuration, and marking all new
misses (so ones that weren't already marked as compulsory or capacity) as
conflict misses.

### Knowledge Check 3 (no explanation for time)

### Example: W20 Final Version C Problem 5, "The C Musketeers"

So at this point we've covered all the content and we're ready to apply what we
know to a problem. There isn't going to be anything new from here until the end
of the video, but there might be some details about different caches that are
good to review for the final. Seeing a worked out problem is helpful, and I
encourage you to try completing this problem for a different version of the W20
exam.

The first thing we want to do for these types of problems is figure out what
kind of final cache configuration we're being asked to consider. So we see here
we're given a lot of information and we want to pick out the important pieces.

For this problem, the important pieces are noting that our cache can hold 64
bytes, each block is 16 bytes, and the cache is 2-way.

With some math, we can determine how many blocks we have total: 64 B / (16 B / 1
block) = 4 blocks.

So we have 4 blocks in our cache, and if the cache is 2 way then we have 2
blocks for every set. So, in total we have just 2 sets.

Next, we want to perform our 3 simulations and keep track of the misses. I
actually don't like the table provided to organize this info, and so I like to
redraw my chart to be more like this.

The 3 simulations we'll perform are:
1. Infinite fully associative
2. Same size as final fully associative
3. Final cache config

First up is the infinite fully associative cache. 

TODO: work through problem 
